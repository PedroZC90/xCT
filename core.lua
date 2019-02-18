local _, ns = ...
local ct = ns.Config
local md = ns.Medias

----------------------------------------------------------------
-- xCT
----------------------------------------------------------------
-- player info
local myName, myClass, myGUID, myRealm

-- import
local bot, band = bit.bor, bit.band
local format, find = string.format, string.find
local ShortValue = xCT.ShortValue
local IconString = xCT.IconString
local GetSpellColor = xCT.GetSpellColor

-- unit flags/mask
local CombatLog_Object_IsA = CombatLog_Object_IsA
local COMBATLOG_FILTER_MINE = COMBATLOG_FILTER_MINE
local COMBATLOG_FILTER_MY_PET = COMBATLOG_FILTER_MY_PET

-- string patterns
local STRING_COLOR      = "|cff%02x%02x%02x"
local STRING_WHITE      = "|cffffffff%s|r"
local STRING_SPAM_COUNT = "|cffffffffx %d|r"
local STRING_CRITICAL   = "|cffffffff(crit)|r %s"
local STRING_ABSORB     = "|cffffffff(%d absorbed)|r"
local STRING_BLOCK      = "|cffffffff(%d blocked)|r"
local STRING_RESIST     = "|cffffffff(%d resisted)|r"

-- frames
local FRAME_DAMAGE_INCOME    = 1
local FRAME_HEALING_INCOME   = 2
local FRAME_MESSAGE          = 3
local FRAME_DAMAGE_HEAL_DONE = 4

-- functions
local Print = function(...) print("|cff00FF96xCT:|r", ...) end
local Debug = function(...) print("|cffff330fxCT:|r", ...) end

local function SetScroll(self, delta)
    if (delta > 0)  then
        self:ScrollUp()
    elseif (delta < 0) then
        self:ScrollDown()
    end
end

local function UpdateSpamQueueValue(queue, amount)
    if (queue and type(queue) == "number") then
        return queue + amount
    end
    return amount
end

local function UpdateSpamQueue(self, elapsed)
    self.lastUpdate = (self.lastUpdate or 0) + elapsed
    if (self.lastUpdate > 0.5) then
        local uptime = time()
        for spellID, data in pairs(self.SpamQueue) do
            if (not data.locked) and (data.queue > 0) and (uptime - data.uptime >= ct.MergeAoESpamTime) then
                local result = ShortValue(data.queue)
                if (not data.color) then
                    Debug(spellID)
                    data.color = { r = 0.00, g = 0.00, b = 0.00 }
                end
                if (data.critical) then result = STRING_CRITICAL:format(result) end
                if (data.icon) then result = result .. " " .. data.icon end
                if (data.count > 1) then result = result .. " " .. STRING_SPAM_COUNT:format(data.count) end
                self:AddMessage(result, data.color.r, data.color.g, data.color.b)
                data.queue = 0
                data.count = 0
                data.critical = false
            end
        end
        self.lastUpdate = 0
    end
end

function xCT:Message(result, color, icon, index)
    local frame = self[index]
    if (not frame) or (not result) then return end
    if (not color) then color = { r = 1.00, g = 0.00, b = 0.50 } end
    if (icon) then result = result .. " " .. icon end
    frame:AddMessage(result, color.r, color.g, color.b)
end

function xCT:UpdateUnit()
    if (UnitHasVehicleUI("player")) then
        self.unit = "vehicle"
    else
        self.unit = "player"
    end
end

function xCT:DisableBlizzardCombatText()
    -- turn off blizard combattext
    CombatText:UnregisterAllEvents()
    CombatText:SetScript("OnLoad", nil)
    CombatText:SetScript("OnEvent", nil)
    CombatText:SetScript("OnUpdate", nil)
    
    -- steal external messages sent by other addons using CombatText_AddMessage
    Blizzard_CombatText_AddMessage=CombatText_AddMessage
    local function CombatText_AddMessage(message, scrollFunction, r, g, b, displayType, isStaggered)
        self:Message(message, { r = r, g = g, b = b }, nil, FRAME_MESSAGE)
    end
end

function xCT:EnableScroll()
    for _, f in ipairs(self) do
        f:EnableMouseWheel(true)
        f:SetScript("OnMouseWheel", SetScroll)
    end
end

function xCT:DisableScroll()
    for _, f in ipairs(self) do
        f:EnableMouseWheel(false)
        f:SetScript("OnMouseWheel", nil)
    end
end

function xCT:CreateFrames()

    local Font, FontSize, FontStyle = ct.Font, ct.FontSize, ct.FontStyle

    -- for index = 1, 4 do
    for index, data in pairs(ct.Frames) do

        if (data.Enable) then
            
            local f = CreateFrame("ScrollingMessageFrame", self:GetName() .. index, self)
            f:SetPoint(unpack(data.Anchor))
            f:SetSize(unpack(data.Size))
            f:SetFading(true)
            f:SetFadeDuration(ct.FadeDuration)
            f:SetTimeVisible(ct.TimeVisible)
            f:SetInsertMode("CENTER")
            f:SetMaxLines(ct.MaxLines)
            f:SetSpacing(ct.Spacing)
            f:SetFont(Font, FontSize, FontStyle)
            f:SetJustifyH(data.Justify)
            f:SetShadowColor(0,0,0,0.7)
            f:SetClampedToScreen(true)
            f:SetClampRectInsets(-7, 7, 7, -7)
            f:SetFrameStrata("BACKGROUND")
            f:SetFrameLevel(3)
            
            -- make scrollable
            if (ct.Scrollable) then
                f:EnableMouse(false)
                f:EnableMouseWheel(true)
                f:SetScript("OnMouseWheel", SetScroll)
            end

            -- resize fonts
            if (ct.DamageFontSize == "auto") then
                if (ct.ShowIcon) then
                    f:SetFont(ct.DamageFont, ct.IconSize, ctDamageFontStyle)
                end
            elseif (type(ct.DamageFontSize) == "number") then
                f:SetFont(ct.DamageFont, ct.DamageFontSize, ct.DamageFontStyle)
            end

            -- enables aoe spam merge
            if (data.Spam) then
                f.SpamQueue = {}
                f:SetScript("OnUpdate", UpdateSpamQueue)
            end

            if (true) then
                -- frame
                f:CreateBackdrop("Transparent")
                f.Backdrop:Hide()

                -- header
                local header = CreateFrame("Frame", f:GetName() .. "Header", f)
                header:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 7)
                header:SetPoint("BOTTOMRIGHT", f, "TOPRIGHT", 0, 7)
                header:SetHeight(16)
                header:CreateBackdrop("Transparent")
                header:Hide()

                local text = header:CreateFontString(nil, "OVERLAY")
                text:SetPoint("CENTER", header, "CENTER", 0, 2)
                text:SetFont(Font, FontSize, FontStyle)
                text:SetText(data.Name)
                text:Hide()

                f.Header = header
                f.Text = text
            end

            self[index] = f
        end
    end
end

----------------------------------------------------------------
-- Event Handlers
----------------------------------------------------------------
xCT:RegisterEvent("ADDON_LOADED")
xCT:RegisterEvent("PLAYER_LOGIN")
xCT:SetScript("OnEvent", function(self, event, ...)
    -- call an event handler function
    self[event](self, ...)
end)

-- build addon
function xCT:ADDON_LOADED(addon)
    if (addon ~= "xCT") then return end

    if (ct.Blizzard) then
        -- force hide blizzard damage/healing floating text
        self:DisableBlizzardCombatText()
    end

    -- create scrolling combat text
    self:CreateFrames()
end

-- initialize addon
function xCT:PLAYER_LOGIN()
    -- initialize unit
    self.unit = "player"

    -- get unit information
    myName = UnitName(self.unit)
    myClass = select(2, UnitClass(self.unit))
    myRealm = GetRealmName()

    -- generate a empty filter tables if class do not have one
    if (not ct.HealFilter[myClass]) then ct.HealFilter[myClass] = {} end
    if (not ct.AoESpam[myClass]) then ct.AoESpam[myClass] = {} end

    -- register events
    if (myClass == "DEATHKNIGHT") and (ct.Runes) then
        self:RegisterEvent("RUNE_POWER_UPDATE")
    end
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("UNIT_POWER_UPDATE")
    self:RegisterEvent("COMBAT_TEXT_UPDATE")
	self:RegisterEvent("UNIT_ENTERED_VEHICLE")
    self:RegisterEvent("UNIT_EXITING_VEHICLE")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    if (ct.Damage) or (ct.Healing) then
        self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    end
end

function xCT:PLAYER_ENTERING_WORLD(...)
    self:UpdateUnit()
end

function xCT:UNIT_ENTERED_VEHICLE(...)
    local unit, showVehicle = ...
    if (unit == "player") then
        self:UpdateUnit()
        CombatTextSetActiveUnit(self.unit)
    end
end

function xCT:UNIT_EXITING_VEHICLE(...)
    local unit = ...
    if (unit == "player") then
        self.unit = "player"
        CombatTextSetActiveUnit(self.unit)
    end
end

function xCT:UNIT_HEALTH(unit, ...)
    if (unit ~= self.unit) then return end

    local cur = UnitHealth(self.unit)
    local max = UnitHealthMax(self.unit)
    local percentage = cur / max
    
    if (percentage <= COMBAT_TEXT_LOW_HEALTH_THRESHOLD ) then
        if (not self.lowHealth) then
            local color = ct.Colors["HEALTH_LOW"]
            self:Message(HEALTH_LOW, color, nil, FRAME_MESSAGE)
            self.lowHealth = true
        end
    else
        self.lowHealth = nil
    end
end

function xCT:UNIT_POWER_UPDATE(unit, powerToken)
    if (unit ~= self.unit) then return end

    -- local powerType, powerToken = UnitPowerType(self.unit)
    local max = UnitPowerMax(self.unit)
    local cur = UnitPower(self.unit)
    local percentage = cur / max

    if (max ~= 0) and (powerToken == "MANA") and (percentage <= COMBAT_TEXT_LOW_MANA_THRESHOLD) then
        if (not self.lowMana) then
            local color = ct.Colors["MANA_LOW"]
            self:Message(MANA_LOW, color, nil, FRAME_MESSAGE)
            self.lowMana = true
        end
    else
        self.lowMana = nil
    end
end

function xCT:PLAYER_REGEN_DISABLED(...)
    if (ct.Scrollable) then
        self:DisableScroll()
    end
    self:Message("+ Combat", { r = 1.00, g = 1.00, b = 1.00 }, nil, FRAME_MESSAGE)         -- ENTERING_COMBAT
end

function xCT:PLAYER_REGEN_ENABLED(...)
    if (ct.Scrollable) then
        self:EnableScroll()
    end
    self:Message("- Combat", { r = 0.30, g = 1.00, b = 0.30 }, nil, FRAME_MESSAGE)         -- LEAVING_COMBAT
end

function xCT:RUNE_POWER_UPDATE(...)
    local arg2, arg3 = ...
    local start, duration, ready = GetRuneCooldown(arg2)
    if (ready) then
        local result = "+ " .. COMBAT_TEXT_RUNE_DEATH
        if (arg2 <= 2) then
            color = { r = 0.75, g = 0.00, b = 0.00 }
        elseif (arg2 <= 4) then
            color = { r = 0.75, g = 1.00, b = 0.00 }
        else
            color = { r = 0.00, g = 1.00, b = 1.00 }
        end
        self:Message(result, color, nil, FRAME_MESSAGE)
    end
end

function xCT:COMBAT_TEXT_UPDATE(event)
    local arg2, arg3, arg4 = GetCurrentCombatTextEventInfo()

    -- check if comat text is enabled
    if (SHOW_COMBAT_TEXT == "0") then return end

    -- message parameters
    local result, color, icon

    -- TYPE DAMAGE
    if (event == "DAMAGE") or (event == "DAMAGE_CRIT") then
        
        if (ct.IncomeDamage) then
            if (arg2 == 0) then return end
            -- damage amount
            result = "- " .. ShortValue(arg2)
            -- critical
            if (event == "DAMAGE_CRIT") then result = STRING_CRITICAL:format(result) end

            self:Message(result, ct.Colors["DAMAGE"], nil, FRAME_DAMAGE_INCOME)
        end

    elseif (event == "SPELL_DAMAGE") or (event == "DAMAGE_SHIELD") or (event == "SPELL_DAMAGE_CRIT") then
    
        if (ct.IncomeDamage) then
            if (arg2 == 0) then return end
            -- damage amount
            result = "- " .. ShortValue(arg2)
            -- critical
            if (event == "SPELL_DAMAGE_CRIT") then result = STRING_CRITICAL:format(result) end

            self:Message(result, ct.Colors["SPELL_DAMAGE"], nil, FRAME_DAMAGE_INCOME)
        end

    elseif (event == "SPLIT_DAMAGE") then
        
        if (ct.IncomeDamage) then
            if (arg2 == 0) then return end
            -- damage amount
            result = "- " .. ShortValue(arg2) .. " " .. STRING_WHITE:format("(split)")

            self:Message(result, ct.Colors["SPLIT_DAMAGE"], nil, FRAME_DAMAGE_INCOME)
        end

    -- TYPE HEALING
    elseif (event == "HEAL") or (event == "HEAL_CRIT") or
        (event == "PERIODIC_HEAL") or (event == "PERIODIC_HEAL_CRIT") then
        
        if (ct.IncomeHealing) then
            -- healing amount
            result = "+ " .. ShortValue(arg3)
            
            -- critical
            if (event == "HEAL_CRIT") or (event == "PERIODIC_HEAL_CRIT") then
                result = STRING_CRITICAL:format(result)
            end

            -- add healer name
            if (COMBAT_TEXT_SHOW_FRIENDLY_NAMES == "1") and (UnitName(self.unit) ~= arg2) and (not event:find("PERIODIC")) then
                result = result .. " " .. STRING_WHITE:format("[" .. arg2 .. "]")
            end

            self:Message(result, ct.Colors["HEAL"], nil, FRAME_HEALING_INCOME)
        end

    elseif (event == "HEAL_ABSORB") or (event == "PERIODIC_HEAL_ABSORB") or (event == "HEAL_CRIT_ABSORB") then
        
        if (ct.IncomeHealing) then
            -- healing amount
            result = "+ " .. ShortValue(arg3) .. " " .. ABSORB_TRAILER:format(arg4)

            -- critical
            if (event == "HEAL_CRIT_ABSORB") then result = STRING_CRITICAL:format(result) end

            -- add healer name
            if (COMBAT_TEXT_SHOW_FRIENDLY_NAMES == "1") and (UnitName(self.unit) ~= arg2) and (not event:find("PERIODIC")) then
                result = result .. " " .. STRING_WHITE:format("[" .. arg2 .. "]")
            end

            self:Message(result, ct.Colors["HEAL_ABSORB"], nil, FRAME_HEALING_INCOME)
        end

    elseif (event == "ABSORB_ADDED") then
        
        if (ct.IncomeHealing) then
            -- absorb amount
            result = "+ " .. ShortValue(arg3) .. STRING_WHITE:format("(" .. COMBAT_TEXT_ABSORB .. ")")
            -- add healer name
            if (COMBAT_TEXT_SHOW_FRIENDLY_NAMES == "1") and (UnitName(self.unit) ~= arg2) then
                result = result .. " " .. STRING_WHITE:format("[" .. arg2 .. "]")
            end

            self:Message(result, ct.Colors[event], nil, FRAME_HEALING_INCOME)
        end
    
    -- TYPE MISS
    elseif (event == "MISS") or (event == "SPELL_MISS") and (COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1") then
        self:Message(COMBAT_TEXT_MISS, ct.Colors["MISS"], nil, FRAME_MESSAGE)

    elseif (event == "DODGE") or (event == "SPELL_DODGE") and (COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1") then
        self:Message(COMBAT_TEXT_DODGE, ct.Colors["DODGE"], nil, FRAME_MESSAGE)
        
    elseif (event == "PARRY") or (event == "SPELL_PARRY") and (COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1") then
        self:Message(COMBAT_TEXT_PARRY, ct.Colors["PARRY"], nil, FRAME_MESSAGE)

    elseif (event == "EVADE") or (event == "SPELL_EVADE") and (COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1") then
        self:Message(COMBAT_TEXT_EVADE, ct.Colors["EVADE"], nil, FRAME_MESSAGE)

    elseif (event == "IMMUNE") or (event == "SPELL_IMMUNE") and (COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1") then
        self:Message(COMBAT_TEXT_IMMUNE, ct.Colors["IMMUNE"], nil, FRAME_MESSAGE)

    elseif (event == "DEFLECT") or (event == "SPELL_DEFLECT") and (COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1") then
        self:Message(COMBAT_TEXT_DEFLECT, ct.Colors["DEFLECT"], nil, FRAME_MESSAGE)

    elseif (event == "REFLECT") or (event == "SPELL_REFLECT") and (COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1") then
        self:Message(COMBAT_TEXT_REFLECT, ct.Colors["REFLECT"], nil, FRAME_MESSAGE)

    -- TYPE RESISTANCE
    elseif (event == "ABSORB") or (event == "SPELL_ABSORB") and (COMBAT_TEXT_SHOW_RESISTANCES == "1") then
        
        if (ct.IncomeDamage) then
            if (arg3) then
                -- partial absorb
                result = "- " .. arg2 .. " " .. ABSORB_TRAILER:format(arg3)
            else
                result = COMBAT_TEXT_ABSORB
            end
            self:Message(result, ct.Colors["ABSORB"], nil, FRAME_DAMAGE_INCOME)
        end

    elseif (event == "BLOCK") or (event == "SPELL_BLOCK") and (COMBAT_TEXT_SHOW_RESISTANCES == "1")  then
        
        if (ct.IncomeDamage) then
            if (arg3) then
                -- partial block
                result = "- " .. arg2 .. " " .. BLOCK_TRAILER:format(arg3)
            else
                result = COMBAT_TEXT_BLOCK
            end
            self:Message(result, ct.Colors["BLOCK"], nil, FRAME_DAMAGE_INCOME)
        end

    elseif (event == "RESIST") or (event == "SPELL_RESIST") and (COMBAT_TEXT_SHOW_RESISTANCES == "1")  then
        
        if (ct.IncomeDamage) then
            if (arg3) then
                -- partial resist
                result = "- " .. arg2 .. " " .. RESIST_TRAILER:format(arg3)
            else
                result = COMBAT_TEXT_RESIST
            end
            self:Message(result, ct.Colors["RESIST"], nil, FRAME_DAMAGE_INCOME)
        end
    
    -- TYPE CAST
    elseif (event == "SPELL_ACTIVE") and (COMBAT_TEXT_SHOW_REACTIVES == "1") then
        self:Message(arg2, ct.Colors[event], nil, FRAME_MESSAGE)

    elseif (event == "SPELL_CAST") then
        self:Message(arg2, ct.Colors[event], nil, FRAME_MESSAGE)

    -- TYPE AURA
    elseif (event == "SPELL_AURA_START") and (COMBAT_TEXT_SHOW_AURAS == "1")then
        result = "+ " .. arg2
        self:Message(result, ct.Colors[event], nil, FRAME_MESSAGE)

    elseif (event == "SPELL_AURA_END") and (COMBAT_TEXT_SHOW_AURAS == "1") then
        result = "- " .. arg2
        self:Message(result, ct.Colors[event], nil, FRAME_MESSAGE)

    elseif (event == "SPELL_AURA_START_HARMFUL") and (COMBAT_TEXT_SHOW_AURAS == "1") then
        result = "+ " .. arg2
        self:Message(result, ct.Colors[event], nil, FRAME_MESSAGE)

    elseif (event == "SPELL_AURA_END_HARMFUL") and (COMBAT_TEXT_SHOW_AURAS == "1") then
        result = "- " .. arg2
        self:Message(result, ct.Colors[event], nil, FRAME_MESSAGE)

    -- TYPE GAINS
    elseif (event == "COMBO_POINTS") and (COMBAT_TEXT_SHOW_COMBO_POINTS == "1") then
        if (arg2 > 0) then
            color = { r = 1.00, g = 0.85, b = 0.00 }
            if (arg2 == MAX_COMBO_POINTS) then
                color = { r = 0.00, g = 0.85, b = 1.00 }
            end
            result = COMBAT_TEXT_COMBO_POINTS:format(arg2)
            self:Message(result, color, nil, FRAME_MESSAGE)
        end

    elseif ((event == "ENERGIZE") and (COMBAT_TEXT_SHOW_ENERGIZE == "1")) or
        ((event == "PERIODIC_ENERGIZE") and (COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE == "1")) then
        if (tonumber(arg2) > 0) then
            result = "+ " .. ShortValue(arg2)
            if (arg3 == "MANA") or (arg3 == "RAGE") or (arg3 == "FOCUS") or (arg3 == "ENERGY") or (arg3 == "RUNIC_POWER") or (arg3 == "DEMONIC_FURY") then
                result = result .. " " .. _G[arg3]
            elseif (arg3 == "HOLY_POWER") or (arg3 == "SOUL_SHARDS") or (arg3 == "CHI") or (arg3 == "COMBO_POINTS") or (arg3 == "ARCANE_CHARGES") then
                local numPower = UnitPower("player" , GetPowerEnumFromEnergizeString(arg3))
                result = numPower .. " " .. _G[arg3]
            end

            self:Message(result, ct.Colors.Power[arg3], nil, FRAME_MESSAGE)
        end

    elseif (event == "FACTION") and (COMBAT_TEXT_SHOW_REPUTATION == "1") then
        if (tonumber(arg3) > 0) then
            arg3 = "+ " .. arg3
        end
        result = "(" .. arg2 .. " " .. arg3 .. ")"
        
        self:Message(result, ct.Colors[event], nil, FRAME_MESSAGE)

    elseif (event == "HONOR_GAINED") and (COMBAT_TEXT_SHOW_HONOR_GAINED == "1") then
        arg2 = tonumber(arg2)
        if (not arg2) or (abs(arg2) < 1 ) then return end
        arg2 = floor(arg2)
        if (arg2 > 0) then
            arg2 = "+ " .. arg2
        end
        result = COMBAT_TEXT_HONOR_GAINED:format(arg2)
        
        self:Message(result, ct.Colors[event], nil, FRAME_MESSAGE)

    else
        -- TYPE OTHERS (e.g: EXTRA_ATTACKS, INTERRUPT, SPELL_DISPELLED, ...)
        if (false) then
            result = _G["COMBAT_TEXT_" .. event]
            if (not result) then result = _G[event] end
            
            self:Message(result, { r = 1.00, g = 1.00, b = 1.00 }, nil, FRAME_MESSAGE)
        end
    end
end


function xCT:COMBAT_LOG_EVENT_UNFILTERED()
    -- combatlog
    local timestamp, event, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags,
    dstGUID, dstName, dstFlags, dstRaidFlags = CombatLogGetCurrentEventInfo()

    -- message parameters
    local eventType, result, icon, color

	-- spell standard order
	local spellID, spellName, spellSchool
	local extraSpellID, extraSpellName, extraSpellSchool
	-- damage/heal standard order
	local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, overhealing
	-- miss arguments
	local missType, isOffHand, amountMissed
	-- aura arguments
	local auraType
	-- energize arguments
	local overenergize, powerType, alternatePowerType
	-- drains/leech arguments
	local extraAmount
	-- failed arguments
	local failedType
	-- enchant arguments
	local itemID, itemName
	-- environmental arguments
	local environmentalType
	-- extra data for PARTY_KILL, SPELL_INSTAKILL, UNIT_DIED, UNIT_DESTROYED and UNIT_DISSIPATES
	local recapID, unconsciousOnDeath

    -- check if caster is player or belongs to player
    local fromPlayer = CombatLog_Object_IsA(srcFlags, COMBATLOG_FILTER_MINE)
    -- check if caster is player's pet/guardian
    local fromPet = CombatLog_Object_IsA(srcFlags, COMBATLOG_FILTER_MY_PET) and ct.PetDamage
    -- check if target is the player
    local toPlayer = CombatLog_Object_IsA(dstFlags, COMBATLOG_FILTER_ME)

	-- only player actions are important
    if (not fromPlayer) and (not fromPet) then return end

	-- get event type prefix
	local subevent = strsub(event, 1, 5)
	
	-- Break out the arguments into variable
	if (subevent == "SWING") then
		-- define a spellID for melee attacks
		spellID = (fromPet) and 1079 or 6603		-- Rip / Auto Attack

		if (event == "SWING_DAMAGE") then
			-- damage standard
			amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())
            
            -- define type
            eventType = "DAMAGE"

		elseif (subevent == "SWING_MISSED") then
			-- miss type
			missType, isOffHand, amountMissed = select(12, CombatLogGetCurrentEventInfo())
            
            -- define type
            eventType = "MISSED"

		end
		
	elseif (subevent == "RANGE") then
		-- shots are spells, technically
		spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())

		if (event == "RANGE_DAMAGE") then
			-- damage standard
			amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())
            
            -- define type
            eventType = "DAMAGE"

		elseif ( event == "RANGE_MISSED" ) then
			-- miss type
			missType, isOffHand, amountMissed = select(15, CombatLogGetCurrentEventInfo())
            
            -- define type
            eventType = "MISSED"
            
		end
		
	elseif (subevent == "SPELL") then
		-- spell standard
		spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())

		if (event == "SPELL_DAMAGE") or (event == "SPELL_BUILDING_DAMAGE") or (event == "SPELL_PERIODIC_DAMAGE") then
            -- damage standard
            amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(15, CombatLogGetCurrentEventInfo())
            
            -- define type
            eventType = "DAMAGE"
		
		elseif (event == "SPELL_HEAL") or (event == "SPELL_BUILDING_HEAL") or (event == "SPELL_PERIODIC_HEAL") then
            -- heal standard
            amount, overhealing, absorbed, critical = select(15, CombatLogGetCurrentEventInfo())
            
            -- define type
            eventType = "HEAL"

        elseif (event == "SPELL_MISSED") then
            -- miss type
            missType,  isOffHand, amountMissed = select(15, CombatLogGetCurrentEventInfo())
            
            -- define type
            eventType = "MISSED"

		elseif (event == "SPELL_PERIODIC_MISSED") then
            -- miss type
            missType, isOffHand, amountMissed = select(15, CombatLogGetCurrentEventInfo())
            
            -- define type
            eventType = "MISSED"
        
		elseif (event == "SPELL_INTERRUPT") then
			-- spell interrupted
			extraSpellID, extraSpellName, extraSpellSchool = select(15, CombatLogGetCurrentEventInfo())
            
            -- define type
            eventType = "INTERRUPT"

        elseif (event == "SPELL_INSTAKILL") then
            -- extra data
			unconsciousOnDeath = select(15, CombatLogGetCurrentEventInfo())

            -- define type
            eventType = "EXTRA"

		elseif (event == "SPELL_DISPEL") or (event == "SPELL_STOLEN") then
			-- extra spell standard, aura standard
            extraSpellID, extraSpellName, extraSpellSchool, auraType = select(15, CombatLogGetCurrentEventInfo())
            
            -- define type
            eventType = "DISPEL"

        elseif (event == "SPELL_DISPEL_FAILED") then
            -- extra spell standard
            extraSpellID, extraSpellName, extraSpellSchool = select(15, CombatLogGetCurrentEventInfo())
            -- define type
            eventType = "DISPEL"

        elseif (event == "SPELL_AURA_BROKEN") then
            -- aura standard
            auraType = select(15, CombatLogGetCurrentEventInfo())
            
            -- define type
            eventType = "AURA_BROKEN"

        elseif (event == "SPELL_AURA_BROKEN_SPELL") then
            -- extra spell standard, aura standard
			extraspellID, extraSpellName, extraSpellSchool, auraType = select(15, CombatLogGetCurrentEventInfo())
            
            -- define type
            eventType = "AURA_BROKEN"
		end
	
	elseif (event == "DAMAGE_SHIELD") then
		-- spell damage standard
		spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(12, CombatLogGetCurrentEventInfo())
        
        -- define type
        eventType = "DAMAGE"

	elseif (event == "DAMAGE_SHIELD_MISSED") then
		-- spell miss standard
        spellID, spellName, spellSchool, missType = select(12, CombatLogGetCurrentEventInfo())
        
        -- define type
        eventType = "MISSED"

	elseif (event == "ENVIRONMENTAL_DAMAGE") then
		-- environmental type, damage standard
		environmentalType, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(12, CombatLogGetCurrentEventInfo())
        
        -- define type
        eventType = "DAMAGE"

		-- miss event
		environmentalType = string.upper(environmentalType)
		spellName = _G["ACTION_ENVIRONMENTAL_DAMAGE_" .. environmentalType]
		
	elseif (event == "DAMAGE_SPLIT") then
		-- spell/damage standard arguments
        spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(12, CombatLogGetCurrentEventInfo())
        
        -- define type
        eventType = "DAMAGE"
	end

    -- messages
    if (eventType == "DAMAGE" and ct.Damage) or (eventType == "HEAL" and ct.Healing) then
        local frame = self[FRAME_DAMAGE_HEAL_DONE]

        -- filter annoying healing spells
        if (eventType == "HEAL") and (ct.HealFilter[myClass][spellID]) then return end

        -- text color
        if ((eventType == "DAMAGE") and ct.DamageColor) or
            ((eventType == "HEAL") and ct.HealingColor) then
            color = GetSpellColor(spellSchool or school or 0)
        elseif (eventType == "DAMAGE") then
            color = ct.Colors.School[1]
        elseif (eventType == "HEAL") then
            color = ct.Colors["HEAL"]
        end

        -- action string
        if (ct.ParseValue) then
            result = xCT.ParseDamageHealingValue(amount, overkill, overhealing, resisted, blocked, absorbed, nil, glancing, crushing)
        end

        if (not result) then 
            result = ShortValue(amount)
        end

        -- is critical
        if (critical) then action = STRING_CRITICAL:format(result) end

        -- get ability icon
        if (spellID) and (ct.ShowIcon) then
            icon = IconString(select(3, GetSpellInfo(spellID)))
        end

        -- merge damage/healing spam
        if (ct.MergeAoESpam) and (ct.AoESpam[myClass][spellID]) then
            if (not frame.SpamQueue[spellID]) then
                frame.SpamQueue[spellID] = { queue = 0, critical = false, count = 0, icon = nil, color = nil, uptime = 0, locked = false }
            end
            
            local data = frame.SpamQueue[spellID]
            
            data.locked = true
            data.queue = UpdateSpamQueueValue(data.queue, amount)
            data.critical = critical
            data.icon = icon
            data.color = color
            data.count = (data.count or 0) + 1
            if (data.count == 1) then
                data.uptime = time()
            end
            data.locked = false
            return
        end

        self:Message(result, color, icon, FRAME_DAMAGE_HEAL_DONE)

    elseif (eventType == "MISSED") and (missType) then

        -- action string
        if (event == "DAMAGE_SHIELD_MISSED") then
            result = _G["ACTION_DAMAGE_SHIELD_MISSED_" .. missType]
        else
            if (missType == "RESIST") or (missType == "BLOCK") or (missType == "ABSORB") and (amountMissed ~= 0) then
                result = _G["TEXT_MODE_A_STRING_RESULT_" .. missType]:format(ShortValue(amountMissed))
            else
                result = _G["ACTION_SWING_MISSED_" .. missType]
            end
        end
        
        -- remove parentesis
        result = strtrim(result, "()")

        -- get ability icon
        if (spellID) and (ct.ShowIcon) then
            icon = IconString(select(3, GetSpellInfo(spellID)))
        end

        self:Message(result, ct.Colors["MISS"], icon, FRAME_DAMAGE_HEAL_DONE)

    elseif (event == "DISPEL") and (ct.Dispel) then

        -- text color
        if (auraType) then
            color = ct.Colors.Auras[auraType]
        else
            color = ct.Colors["DISPEL"]
        end

        -- action string
        result = _G["ACTION_" .. event] .. ": " .. extraSpellName

        -- get ability icon
        if (extraSpellID) and (ct.ShowIcon) then
            icon = IconString(select(3, GetSpellInfo(extraSpellID)))
        end

        self:Message(result, color, icon, FRAME_MESSAGE)

    elseif (event == "INTERRUPT") and (ct.Interrupt) then

        -- action string
        result = _G["ACTION_" .. event] .. ": " .. extraSpellName
        
        -- get ability icon
        if (extraSpellID) and (ct.ShowIcon) then
            icon = IconString(select(3, GetSpellInfo(extraSpellID)))
        end

        self:Message(result, ct.Colors["INTERRUPT"], icon, FRAME_MESSAGE)
    
    elseif (event == "AURA_BROKEN") then

        -- action string
        result = _G["ACTION_" .. event] .. ": " .. extraSpellName
        
        -- ability icon
        if (extraSpellID) and (ct.ShowIcon) then
            icon = IconString(select(3, GetSpellInfo(extraSpellID)))
        end

        self:Message(result, ct.Colors.Auras[auraType], icon, FRAME_MESSAGE)

    end
end