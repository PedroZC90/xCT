local _, ns = ...
local xCT = ns.xCT

local T, C, L, G = unpack(oUFLua)

local hooge = [[Interface\AddOns\xCT\media\HOOGE.ttf]]
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
				if not (CombatLog_Object_IsA(unitFlag, COMBATLOG_FILTER_ME)) then
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
			-- Priest
			[120692] = true,		-- Halo (Heal)
			[120696] = true,		-- Halo (Damage)
			[110745] = true,		-- Divine Star (Heal)
			[122128] = true,		-- Divine Star (Damage)
			-- Discipline
			[47750] = true,			-- Penance (Heal)
			[47666] = true,			-- Penance (Damage)
			[81751] = true,			-- Atonement
			[94472] = true,			-- Atonement
			[194509] = true,		-- Power Word: Radiance
			[204065] = false,		-- Shadow Covenant
			[204213] = true,		-- Purge the Wicked
			-- Holy
			[139] = true,			-- Renew
			[596] = true,			-- Prayer of Healing
			[14914] = true,			-- Holy Fire
			[33110] = false,		-- Prayer of Mending
			[34861] = true,			-- Holy Word: Sanctify
			[64844] = true,			-- Divine Hymn
			[77489] = true,			-- Echo of Light
			[132157] = true,		-- Holy Nova (Damage)
			[204883] = true,		-- Circle of Healing
			[214121] = true,		-- Body and Mind
			-- Shadow
			[589] = true,			-- Shadow Word: Pain
			[15290] = true,			-- Vampiric Embrace 
			[15407] = true,			-- Mind Flay
			[34914] = true,			-- Vampiric Touch
			[148859] = true,		-- Shadowy Apparition
			[228360] = true,		-- Void Eruption
			[237388] = true,		-- Mind Flay (Void Form)
		},
		MONK = {
			-- Monk
			[117952] = true,		-- Crackling Jade Lightning
			[130654] = true,		-- Chi Burst (Heal)
			[148135] = true,		-- Chi Burst (Damage)
			[132463] = true,		-- Chi Wave (Heal)
			[132467] = true,		-- Chi Wave (Damage)
			[196608] = true,		-- Eye of the Tiger (Heal/Damage)
			-- Brewmaster
			[121253] = true,		-- Keg Smash
			[115181] = true,		-- Breath of Fire
			[123725] = true,		-- Breath of Fire
			[148187] = true,		-- Rushing Jade Wind
			[196733] = true,		-- Special Delivery
			[124255] = true,		-- Stagger (Damage Taken)
				[227291] = true,	-- Stomp (Niuzao)
			-- Mistweaver
			[107270] = true,		-- Spinning Crane Kick
			[119611] = true,		-- Renewing Mist
			[124682] = true,		-- Enveloping Mist
			[191894] = true,		-- Gust of Mist
			[115175] = true,		-- Soothing Mist
			[124081] = true,		-- Zen Pulse (Damage)
			[191840] = true,		-- Essence Font
			[198487] = true,		-- Zen Pulse (Heal)
			[162530] = true,		-- Refreshing Jade Wind
				[198756] = true,		-- Crane Heal
				[198533] = true,		-- Soothing Mist (Jade Serpent Statue)	
			-- Windwalker
			[117418] = true,		-- Fists of Fury
			[158221] = true,		-- Whirling Dragon Punch
			[196748] = true,		-- Chi Orb
				[123996] = true,	-- Crackling Tiger Lightning (Xuen)
		},
		DRUID = {
			-- Druid
			[145109] = true,		-- Ysera's Gift
			-- Balance
			[164812] = true,		-- Moonfire
			[164815] = true,		-- Sunfire
			[191037] = true,		-- Starfall
			[194153] = true,		-- Lunar Strike
			[202347] = true,		-- Stellar Flare
			[202497] = true,		-- Shooting Stars
			[211545] = true,		-- Fury of Elune
			-- Feral
			[1079] = true,			-- Rip
			[106785] = true,		-- Swipe (Cat)
			[106830] = true,		-- Thrash
			[202028] = true,		-- Brutal Slash
			-- Guardian
			[22842] = true,			-- Frenzied Regeneration
			[77758] = true,			-- Thrash
			[192090] = true,		-- Thrash (Bear)
			[204069] = true,		-- Lunar Beam
			[213771] = true,		-- Swipe (Bear)
			[213709] = true,		-- Brambles
			[227034] = true,		-- Nature's Guardian (Lunar Beam)
			-- Restoration
			[774] = true,			-- Rejuvenation
			[8936] = true,			-- Regrowth
			[33763] = true,			-- Lifebloom
			[48438] = true,			-- Wild Growth
			[81269] = true,			-- Efflorescence
			[157982] = true,		-- Tranquility
			[200389] = true,		-- Cultivation
			[207386] = true,		-- Spring Blossoms
		},
		SHAMAN = {
			-- Shaman
			-- Elemental
			[45297] = true,			-- Chain Lightning Overload
			[51490] = true,			-- Thunderstorm
			[77478] = true,			-- Earthquake
			[188389] = true,		-- Flame Shock
			[188443] = true,		-- Chain Lightning
			[192231] = true,		-- Liquid Magma Totem
			[170379] = true,		-- Earthen Rage
			-- Restoration
			[421] = true,			-- Chain Lightning
			
			[1064] = true,			-- Chain Heal
			[61295] = true,			-- Riptide
			[52042] = true,			-- Healing Stream Totem
			[73921] = true,			-- Healing Rain
			[114083] = false,		-- Restorative Wave (*)
			[114942] = true,		-- Healing Tide
			[188838] = true,		-- Flame Shock
			[197997] = true,		-- Wellspring
			-- Relic
			[208899] = true,		-- Queen's Decree
			[255227] = true,		-- Gift of the Queen
		},
		PALADIN = {
			-- Paladin
			[81297] = true,			-- Consecration (Damage)
			[183811] = true,		-- Judgment of Light
			-- Holy
			[114852] = true,		-- Holy Prism
			[114871] = true,		-- Holy Prism
			[225311] = true,		-- Light of Dawn
			[119952] = true,		-- Arcing Light (Heal)
			[114919] = true,		-- Arcing Light (Damage)
			-- Protection
			[31935] = true,			-- Avenger's Shield
			[88263] = true,			-- Hammer of the Righteous
			[204301] = true,		-- Blessed Hammer
			[204241] = true,		-- Consecration (Heal)
			-- Retribution
			[184689] = true,		-- Shield of Vengeance
			[198137] = true,		-- Divine Hammer
			[205202] = true,		-- Eye for an Eye
			[210220] = true,		-- Holy Wrath
			[224239] = true,		-- Divine Storm
			[214894] = true,		-- Word of Glory
		},
	},

	HEAL_FILTER = {
		PRIEST = {
			-- Discipline
			[94472] = false,		-- Atonement
			-- Holy
			[139] = false,			-- Renew
			-- Shadow
			[15290] = false,		-- Vampiric Embrace
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
		PALADIN = {
			-- Retribution
			[203539] = true,		-- Greater Blessing of Wisdom
		},
	},

}