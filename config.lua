local _, ns = ...
local xCT = ns.xCT

local T, C, L, G = unpack(oUFLua)

local hooge = [[Interface\AddOns\xCT\HOOGE.ttf]]
local pixelfont = C.media.pixelfont

------------------------------------------------------------
-- Options
------------------------------------------------------------

xCT.Config = {
	
	-- options
	["blizzardct"] = true,						-- disable blizzard combat text.
	["showposition"] = false,					-- show background to setup frame position easier.
	
	-- appearence
	["font"] = hooge,
	["fontsize"] = 10,
	["fontstyle"] = "OUTLINE,MONOCHROME",
	["damagefont"] = hooge,
	["damagefontsize"] = "auto",				-- size of scrollframe damage font (if set to "auto", fontsize will be equal to icon size).
	["timevisible"] = 10,						-- time (seconds) a single message will be visible (defualt value is 3).
	["scrollable"] = true,						-- allows you to scroll frame lines with mousewheel.
	["maxlines"] = 64,							-- max lines to keep in scrollable mode (more lines = more memory).
	
	-- damage/healing options
	["damagecolor"] = true,						-- display damage numbers based on spell type. (see http://www.wowwiki.com/API_COMBAT_LOG_EVENT)
	["critprefix"] = "|cffFF0000+|r",			-- symbol added before a damage/heal amount.
	["critpostfix"] = "",						-- symbol added after a damage/heal amount.
	["icons"] = true,							-- show spell icons at damage side.
	["iconsize"] = 16,							-- spell icon size shown at damage/heal frame.
	-- ["petdamage"] = true,					-- display player pet damage. (NOT USING)
	
	-- features
	["mergeaoespam"] = true,					-- enable damage/heal aoe spam.
	["mergeaoespamtime"] = 3.0,					-- time in seconds aoe spell will merge into single message.
	["healfilter"] = true,						-- enable heal filter.
	
	Frames = {
		[1] = {
			enable = false,
			Name = "INCOMING_DAMAGE",
			Anchor = { "CENTER", UIParent, "CENTER", 0, 290 },
			size = { 180, 230 },
			justifyH = "CENTER",
			
			types = {
				DAMAGE = true,
				HEAL = false,
				MISS = true,
				DRAIN = true,
			},
			source = function(unitFlag)
				return true
			end,
			dest = function(unitFlag)
				if (CombatLog_Object_IsA(unitFlag, COMBATLOG_FILTER_ME)) then
					return true
				end
				return false
			end,
		},
		[2] = {
			enable = true,
			Name = "INCOMING_HEAL",
			Anchor = { "TOPRIGHT", UIParent, "CENTER", -160, 293 },
			size = { 180, 270 },
			justifyH = "CENTER",
			
			types = {
				HEAL = true,
			},
			source = function(unitFlag)
				return true
			end,
			dest = function(unitFlag)
				if (CombatLog_Object_IsA(unitFlag, COMBATLOG_FILTER_ME)) then
					return true
				end
				return false
			end,
		},
		[3] = {
			enable = true,
			Name = "DAMAGE/HEALING_DONE",
			Anchor = { "TOPLEFT", UIParent, "CENTER", 160, 293 },
			size = { 180, 270 },
			justifyH = "CENTER",
			
			types = {
				DAMAGE = true,
				HEAL = true,
				MISS = true,
				DRAIN = true,
			},
			source = function(unitFlag)
				if (CombatLog_Object_IsA(unitFlag, COMBATLOG_FILTER_ME) or
					CombatLog_Object_IsA(unitFlag, COMBATLOG_FILTER_MINE) or
					CombatLog_Object_IsA(unitFlag, COMBATLOG_FILTER_MY_PET)) then
					return true
				end
				return false
			end,
			dest = function(unitFlag)
				if (CombatLog_Object_IsA(unitFlag, COMBATLOG_FILTER_EVERYTHING)) then
					return true
				end
				return false
			end,
		},
		[4] = {
			enable = false,
			Name = "SPAM",
			Anchor = { "CENTER", UIParent, "CENTER", 0, 35 },
			size = { 180, 200 },
			justifyH = "CENTER",
			
			types = {
				DAMAGE = false,
				HEAL = false,
				MISS = false,
				DRAIN = false,
			},
			source = function(unitFlag)
				return true
			end,
			dest = function(destGUID)
				return true
			end,
		},
	},

	AOE_SPAM = {
		PRIEST = {
		-- Damage
			-- Shadow
			[589] = true,			-- Shadow Word: Pain
			[15290] = true,			-- Vampiric Embrace
			[15407] = true,			-- Mind Flay
			[34914] = true,			-- Vampiric Touch
			[148859] = true,		-- Shadowy Apparition
			[205448] = true,		-- Void Bolt
			[228360] = true,		-- Void Eruption
			[237388] = true,		-- Mind Flay (Void Form)
			-- Disc
			[94472] = true,			-- Atonement
			[204213] = true,		-- Purge the Wicked
			-- Holy
			[14914] = true,			-- Holy Fire
			[132157] = true,		-- Holy Nova
			[139] = true,			-- Renew
			[32546] = false,		-- Binding Heal
			[33110] = false,		-- Prayer of Mending
			[34861] = true,			-- Holy Word: Sanctify
			[64844] = true,			-- Divine Hymn
			[77489] = true,			-- Echo of Light
			[204883] = true,		-- Circle of Healing
			[120692] = true,		-- Halo (Heal)
			[120696] = true,		-- Halo (Damage)
			[110745] = true,		-- Divine Star (Heal)
			[122128] = true,		-- Divine Star (Damage)
			
		},
		MONK = {
			-- Brewmaster
			[121253] = true,		-- Keg Smash
			[115181] = true,		-- Breath of Fire
			[132463] = true,		-- Chi Wave (heal/damage)
			-- Mistweaver
			[119611] = true,		-- Renewing Mist
			[124682] = true,		-- Enveloping Mist
			[191894] = true,		-- Gust of Mist
			[115175] = true,		-- Soothing Mist
		},
		DRUID = {
			-- Balance
			[164812] = true,		-- Moonfire
			[164815] = true,		-- Sunfire
			-- Restoration
			[774] = true,			-- Rejuvenation
			[8936] = true,			-- Regrowth
			[33763] = true,			-- Lifebloom
			[48438] = true,			-- Wild Growth
			[81269] = true,			-- Efflorescence
		},
		SHAMAN = {
			-- Elemental
			[51490] = true,			-- Thunderstorm
			[77478] = true,			-- Earthquake
			[188389] = true,		-- Flame Shock
			[188443] = true,		-- Chain Lightning
			[45297] = true,			-- Chain Lightning Overload
			-- Restoration
			[421] = true,			-- Chain Lightning
			[188838] = true,		-- Flame Shock
			[1064] = true,			-- Chain Heal
			[61295] = true,			-- Riptide
			[52042] = true,			-- Healing Stream Totem
			[73921] = true,			-- Healing Rain
			[77472] = true,			-- Healing Wave
			[114083] = true,		-- Restorative Wave
			[114942] = true,		-- Healing Tide
			[208899] = true,		-- Queen's Decree
			[255227] = true,		-- Gift of the Queen
		},
	},

	HEAL_FILTER = {
		PRIEST = {
			-- Shadow
			[15290] = false,		-- Vampiric Embrace
			-- Discipline
			[94472] = false,		-- Atonement
			-- Holy
			[139] = false,			-- Renew
		},
		MONK = {
			-- Mistweaver
			[119611] = false,		-- Renewing Mist
			[124682] = false,		-- Enveloping Mist
			[191894] = false,		-- Gust of Mist
			[115175] = false,		-- Soothing Mist
		},
		DRUID = {
			-- Restoration
			[774] = false,			-- Rejuvenation
			[8936] = false,			-- Regrowth
		},
		SHAMAN = {
			-- Restoration
			[1064] = false,			-- Chain Heal
			[61295] = false,		-- Riptide
			[52042] = false,		-- Healing Stream Totem
			[114942] = false,		-- Healing Tide
		},
	},

}