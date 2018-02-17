local T, C, L, G = unpack(oUFLua)

local _, ns = ...
local xCT = ns.xCT
local ct = xCT.Config

------------------------------------------------------------
-- Core
------------------------------------------------------------

-- player info
local myName = UnitName("player")
local myClass = select(2, UnitClass("player"))
local mySpec = GetSpecialization()
local myGUID = UnitGUID("player")

-- icon textures
local PET_ATTACK_TEXTURE = select(3, GetSpellInfo(1079))	-- Rip
local AUTO_ATTACK_TEXTURE = select(3, GetSpellInfo(6603))	-- Auto Attack

-- Merge AoE Spam Table
local AOE_SPAM = {}
for key, tbl in pairs(ct.AOE_SPAM) do
	for spellID, value in pairs(tbl) do
		AOE_SPAM[spellID] = value
	end
end

-- Merge Heal Filter Table
local HEAL_FILTER = {}
for key, tbl in pairs(ct.HEAL_FILTER) do
	for spellID, value in pairs(tbl) do
		HEAL_FILTER[spellID] = value
	end
end

-- events handled by xCT
local COMBAT_EVENTS = {
	SWING_DAMAGE = "DAMAGE",
	RANGE_DAMAGE = "DAMAGE",
	SPELL_DAMAGE = "DAMAGE",
	SPELL_PERIODIC_DAMAGE = "DAMAGE",
	ENVIRONMENTAL_DAMAGE = "DAMAGE",
	DAMAGE_SHIELD = "DAMAGE",
	DAMAGE_SPLIT = "DAMAGE",
	
	SPELL_HEAL = "HEAL",
	SPELL_PERIODIC_HEAL = "HEAL",
	
	SWING_MISSED = "MISS",
	RANGE_MISSED = "MISS",
	SPELL_MISSED = "MISS",
	SPELL_PERIODIC_MISSED = "MISS",
	DAMAGE_SHIELD_MISSED = "MISS",
	
	SPELL_DRAIN = "DRAIN",
	SPELL_LEECH = "DRAIN",
	SPELL_PERIODIC_DRAIN = "DRAIN",
	SPELL_PERIODIC_LEECH = "DRAIN",
}

-- text color based on spell school
local SPELL_SCHOOL_COLOR = {
	[0]  = { 1., 1., 1. },		-- NONE
	[1]	 = { 1., 1., .0 },		-- PHYSICAL
	[2]  = { 1., .9, .5 },		-- HOLY
	[4]  = { 1., .5, .0 },		-- FIRE
	[8]  = { .3, 1., .3 },		-- NATURE
	[16] = { .5, 1., 1. },		-- FROST
	[32] = { .5, .5, 1. },		-- SHADOW
	[64] = { 1., .5, 1. },		-- ARCANE
	-- [33] = { .69, .31, .31 },	-- SHADOWSTRIKE
}

-- return a short value
local function ShortValue(value)
	if (value >= 1e7) then
		return string.format("%.1fm", value / 1e6)
	elseif (value >= 1e6) then
		return string.format("%.2fm", value / 1e6)
	elseif (value >= 1e5) then
		return string.format("%.1fk", value / 1e3)
	elseif (value >= 1e4) then
		return string.format("%.2fk", value / 1e3)
	else
		return string.format("%d", value)
	end
end

-- create a empty spam queue table for each frame.
local SPAM_QUEUE = {}
for id, value in ipairs(ct.Frames) do
	SPAM_QUEUE[id] = {}
	for spellID, value in pairs(AOE_SPAM) do
		SPAM_QUEUE[id][spellID] = {
			queue = 0,
			icon = "",
			color = {},
			count = 0,
			uptime = 0,
			locked = false,
		}
	end
end

-- print spam message
local LastUpdate = 0
local function SpamOnUpdate(self, elapsed)
	local msg = ""
	LastUpdate = LastUpdate + elapsed
	if (LastUpdate > 0.5) then
		LastUpdate = 0
		local uptime = time()
		for spellID, data in pairs(SPAM_QUEUE[self.id]) do
			local r, g, b = unpack(data.color)
			if (not data.locked) and (data.queue > 0) and (uptime - data.uptime >= ct.mergeaoespamtime) then
				msg = data.queue .. " " .. data.icon
				if (data.count > 1) then
					msg = msg .. string.format(" |cffFFFFFF x %d|r ", data.count)
				end
				self:AddMessage(msg, r, g, b, nil, ct.timevisible)
				data.queue = 0
				data.count = 0
			end
		end
	end
end

-- create scroll frames
local function CreateFrames(self)
	for index, data in ipairs(ct.Frames) do
		if (data.enable) then
			local f = CreateFrame("ScrollingMessageFrame", self:GetName() .. index, self)
			
			f.id = index
			f.Name = data.Name
			f.types = data.types
			f.source = data.source
			f.dest = data.dest
			
			f:SetPoint(unpack(data.Anchor))
			f:SetSize(unpack(data.size))
			f:SetJustifyH(data.justifyH)
			f:SetFont(ct.font, ct.fontsize, ct.fontstyle)
			f:SetShadowColor(.0,.0,.0,.7)
			f:SetFading(true)
			f:SetFadeDuration(0.5)
			f:SetTimeVisible(ct.timevisible)
			f:SetMaxLines(ct.maxlines)
			f:SetSpacing(2)
			f:SetClampedToScreen(true)
			f:SetClampRectInsets(.0,.0,ct.fontsize,.0)
			
			if (ct.damagefontsize == "auto") then
				if ct.icons then
					f:SetFont(ct.font, ct.iconsize, ct.fontstyle)
				end
			elseif (type(ct.damagefontsize) == "number") then
				f:SetFont(ct.font, ct.damagefontsize, ct.fontstyle)
			end
			
			if (ct.showposition) then
				f.bg = f:CreateTexture(nil, "BORDER")
				f.bg:SetAllPoints()
				f.bg:SetColorTexture(1.,1.,1.,.3)
				
				f.name = f:CreateFontString(nil, "OVERLAY")
				f.name:SetPoint("CENTER", f, "TOP", 0, -10)
				f.name:SetJustifyH("CENTER")
				f.name:SetFont(ct.font, ct.fontsize, ct.fontstyle)
				f.name:SetText(data.Name)
			end
			
			-- function to update spam messages.
			if (f.types["DAMAGE"] or f.types["HEAL"]) then
				f:SetScript("OnUpdate", SpamOnUpdate)
			end
			
			self[index] = f
		end
	end
end

-- function to sum all spam value.
local function SpamQueue(id, spellID, add)
	local amount
	local spam = SPAM_QUEUE[id][spellID].queue
	if (spam and type(spam) == "number") then
		amount = spam + add
	else
		amount = add
	end
	return amount
end

-- update spell spam queue table
local function FilterSpamMsg(self, timestamp, spellID, amount, r, g, b, icon)
	local id = self.id
	local data = SPAM_QUEUE[id][spellID]
	
	data.locked = true
	data.queue = SpamQueue(id, spellID, amount)
	data.icon = icon or ""
	data.color = { r, g, b }
	data.count = data.count + 1
	if (data.count == 1) then
		data.uptime = time()
	end
	data.locked = false
end

-- return a color base on spell/abilitie school.
local function UpdateMsgColor(school)
	local r, g, b = 1., 1., 1.
	if ct.damagecolor then
		if (SPELL_SCHOOL_COLOR[school]) then
			r, g, b = unpack(SPELL_SCHOOL_COLOR[school])
		end
	end
	return r, g, b
end

-- create an escape sequence to insert icon texture into a string.
local function IconEscapeSequence(texture, size1, size2, xoffset, yoffset, dimx, dimy, coordx1, coordx2, coordy1, coordy2)
	local fmt = "|T%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d|t"
	return string.format(fmt, texture, size1, size2, xoffset, yoffset, dimx, dimy, coordx1, coordx2, coordy1, coordy2)
end

-- select an icon texture and return an icon escape sequence string.
local function IconString(event, spellID, unitFlag)
	local texture
	if (spellID) then
		texture = select(3, GetSpellInfo(spellID))
	elseif (event == "SWING_DAMAGE" or event == "SWING_MISSED") then
		texture = AUTO_ATTACK_TEXTURE
		if (CombatLog_Object_IsA(unitFlag, COMBATLOG_FILTER_MINE) or
			CombatLog_Object_IsA(unitFlag, COMBATLOG_FILTER_MY_PET)) then
			texture = PET_ATTACK_TEXTURE
		end
	end
	return IconEscapeSequence(texture, ct.iconsize, ct.iconsize, 0, 0, 64, 64, 5, 59, 5, 59)
end

-- function to filter combat log events.
local function ProcessCombatLog(self, timestamp, combatEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
	local eventType = COMBAT_EVENTS[combatEvent]
	if not eventType then return end
	
	-- prefix
	local spellID, spellName, spellSchool, spellIcon
	local environmentalType
	-- suffixes
	local damage, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand	-- damage
	local heal, overheal			-- heal
	local missType, amountMissed	-- miss
	local powerType, extraAmount	-- drain
	
	local offset
	if (eventType == "DAMAGE") then
		if (combatEvent == "SWING_DAMAGE") then
			offset = 1
		elseif (combatEvent == "ENVIRONMENTAL_DAMAGE") then
			offset = 2
			environmentalType = ...
		else
			offset = 4
			spellID, spellName, spellSchool = ...
		end
		damage, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(offset, ...)
	elseif (eventType == "HEAL") then
		spellID, spellName, spellSchool, heal, overheal, absorbed, critical = ...
	elseif (eventType == "MISS") then
		local offset
		if (combatEvent == "SWING_MISSED") then
			offset = 1
		else
			offset = 4
			spellID, spellName, spellSchool = ...
		end
		missType, isOffHand, amountMissed = select(offset, ...)
	elseif (eventType == "DRAIN") then
		spellID, spellName, spellSchool, damage, powerType, extraAmount = ...
	end
	
	-- heal filter (hide message)
	if (ct.healfilter and (eventType == "HEAL") and HEAL_FILTER[spellID]) then
		return
	end
	
	-- message
	local msg = ""
	if (damage) then msg = ShortValue(damage) end
	if (heal) then msg = ShortValue(heal) end
	if (missType) then msg = missType end
	
	-- critical
	if (critical) then
		msg = ct.critprefix .. msg .. ct.critpostfix
	end
	
	-- icons
	local icon
	if (ct.icons) then
		icon = IconString(combatEvent, spellID, sourceFlags)
		msg = msg .. " " .. icon
	end
	
	-- text color based on school color
	local r, g, b = UpdateMsgColor(school or spellSchool)
	
	-- show event info (good way to get spellIDs)
	-- print(format("|cff%02x%02x%02x", 255 * r, 255 * g, 255 * b), icon, combatEvent, ...)
	
	for i, data in pairs(ct.Frames) do
		if data.enable then
			local f = self[i]
			
			local messageID = nil
			local holdTime = ct.timevisible
			if (f.types[eventType] and f.dest(destFlags) and f.source(sourceFlags)) then
				
				-- merge aoe spam
				if (ct.mergeaoespam and AOE_SPAM[spellID] and (damage or heal)) then
					FilterSpamMsg(f, timestamp, spellID, damage or heal, r, g, b, icon)
					return
				end
				
				f:AddMessage(msg .. " ", r, g, b, messageID, holdTime)
			end
		end
	end
end

-- Turn off Blizzard's default combat text.
local function DisableBlizzardCombatText()
	SetCVar("enableFloatingCombatText", 0)
	SetCVar("floatingCombatTextCombatHealing", 0)
	SetCVar("floatingCombatTextCombatDamage", 0)
	SHOW_COMBAT_TEXT = "0"
	if (CombatText_UpdateDisplayedMessages) then CombatText_UpdateDisplayedMessages() end
end

-- function to handle all registered events.
local function OnEvent(self, event, ...)
	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		ProcessCombatLog(self, ...)
	elseif (event == "ADDON_LOADED") then
		local addon = ...
		if (addon == "xCT") then
			-- create xCT elements
			CreateFrames(self)
			-- forcing to hide blizzard damage/healing floating text
			if ct.blizzardct then 
				DisableBlizzardCombatText()
			end
		end
	end
end

local f = CreateFrame("Frame", "xCT", UIParent)
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", OnEvent)