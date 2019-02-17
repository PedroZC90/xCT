local _, ns = ...
local ct = ns.Config

----------------------------------------------------------------
-- Filters
----------------------------------------------------------------
-- merge spell damage to avoid spam.
ct["AoESpam"] = {
    ["DEATHKNIGHT"] = {},
    ["DEMONHUNTER"] = {},
    ["DRUID"] = {
        -- Balance
        [164812] = true,                -- Moonfire
        [164815] = true,                -- Sunfire
        [191037] = true,                -- Starfall
        [202347] = true,                -- Stellar Flare
        [211545] = true,                -- Fury of Elune
        [274282] = true,                -- Half Moon
        [274283] = true,                -- Full Moon

        -- Feral
        [1079] = true,                  -- Rip
        [106830] = true,                -- Trash
        [106785] = true,                -- Swipe
        [155722] = true,                -- Rake
        [202028] = true,                -- Brutal Slash
        [274838] = true,                -- Feral Frenzy
        [285381] = true,                -- Primal Wrath

        -- Guardian
        [77758] = true,                 -- Trash
        [192090] = true,                -- Trash (Periodic Effect)
        [213771] = true,                -- Swipe

        -- Restoration
        [774] = true,                   -- Rejuvenation
        [8936] = true,                  -- Regrowth
        [33763] = true,                 -- Lifebloom
        [33778] = true,                 -- Ysera's Gift
        [48438] = true,                 -- Wild Growth
        [81269] = true,                 -- Efflorescence
        [207386] = true,                -- Spring Blossoms
    },
    ["HUNTER"] = {},
    ["MAGE"] = {},
    ["MONK"] = {
        -- All Specs
        [148135] = true,                -- Chi Burst
        [132463] = true,                -- Chi Wave (Healing Effect)
        [132467] = true,                -- Chi Wave (Damage Effect)

        -- Brewmaster
        [115181] = true,                -- Breath of Fire
        [117952] = true,                -- Crackling Jade Lightning
        [121253] = true,                -- Keg Smash
        [123725] = true,                -- Breath of Fire (Periodic Effect)
        [148187] = true,                -- Rushing Jade Wind
        [196608] = true,                -- Eye of the Tiger
        [227291] = true,                -- Stomp (Invoke Niuzao, the Black Ox)
        [124255] = true,                -- Stagger

        -- Mistweaver
            -- Damage Effect
            [162530] = true,                -- Refreshing Jade Wind

            -- Healing Effect
            [115175] = true,                -- Smoothing Mist
            [115310] = true,                -- Revival
            [116670] = true,                -- Vivify
            [119611] = true,                -- Renewing Mist
            [124682] = true,                -- Enveloping Mist
            [191840] = true,                -- Essence Font
            [191894] = true,                -- Gust of Mists
            [198533] = true,                -- Smoothing Mist (Serpent Dragon Statue)
            [198756] = true,                -- Crane Heal (Invoke Chi-ji, the Red Crane)

        -- Windwalker
        [107270] = true,                -- Spinning Crane Kick
        [117418] = true,                -- Fists of Furye
        [123586] = true,                -- Flying Serpent Kick
        [123996] = true,                -- Crackling Tiger Lightning (Invoke Xuen, the White Tiger)
        [158221] = true,                -- Whirling Dragon Punch
    },
    ["PALADIN"] = {
        -- Holy
            -- Damage Effect
            [81297] = true,                 -- Consecration
            [114919] = true,                -- Light's Hammer (Damage Effect)
            -- Healing Effect
            [53652] = true,                 -- Beacon of Light
            [114871] = true,                -- Holy Prism
            [119952] = true,                -- Arcing Light
            [183881] = true,                -- Judgment of Light
            [210291] = true,                -- Aura of Mercy
            [216371] = true,                -- Avenging Crusader
            [225311] = true,                -- Light of Dawn

        -- Protection
        [31935] = true,                 -- Avenger's Shield
        [53600] = true,                 -- Shield of Righteous
        [88263] = true,                 -- Hammer of Righteous (standing on consecration)
        [204011] = true,                -- Retribution Aura
        [204301] = true,                -- Blessed Hammer

        -- Retribution
        [224239] = true,                -- Divine Storm
        [255937] = true,                -- Wake of Ashes
    },
    ["PRIEST"] = {
        -- All Specs
        [110745] = true,                -- Divine Star
        [122128] = true,                -- Divine Star
        [120692] = true,                -- Halo
        [120696] = true,                -- Halo

        -- Discipline
            -- Damage Effect
            [47666] = true,                 -- Penance
            [132157] = true,                -- Holy Nova
            [204065] = true,                -- Shadow Covenant

            -- Healing Effect
            [47750] = true,                 -- Penance
            [81751] = true,                 -- Atonement
            [204213] = true,                -- Purge the Wicked
            [281265] = true,                -- Holy Nova

        -- Holy
            -- Damage Effect
            [14914] = true,                 -- Holy Fire

            -- Healing Effect
            [139] = true,                   -- Renew
            [596] = true,                   -- Prayer of Healing
            [33110] = true,                 -- Prayer of Mending
            [34861] = true,                 -- Holy Word: Sanctify
            [64844] = true,                 -- Divine Hymn
            [77489] = true,                 -- Echo of Light
            [204883] = true,                -- Circle of Healing
            [265202] = true,                -- Holy Word: Salvation

        -- Shadow
            -- Damage Effect
            [589] = true,                   -- Shadow Word: Pain
            [15407] = true,                 -- Mind Flay
            [34914] = true,                 -- Vampiric Touch (Damage and Heal)
            [49821] = true,                 -- Mind Sear
            [148859] = true,                -- Shadowy Apparition
            [205386] = true,                -- Shadow Crash
            [228360] = true,                -- Void Eruption
            [228361] = true,                -- Void Eruption
            [263165] = true,                -- Void Torrent
            [263346] = true,                -- Dark Void

            -- Healing Effect
            [15290] = true,                 -- Vampiric Embrace
            [47585] = true,                 -- Dispersion
    },
    ["ROGUE"] = {},
    ["SHAMAN"] = {
        -- Elemental
            -- Damage Effect
            [45284] = true,                 -- Lightning Bold Overload
            [45297] = true,                 -- Chain Lightning Overload
            [51490] = true,                 -- Thunderstorm
            [57984] = true,                 -- Fire Blast (Fire Elemental)
            [77478] = true,                 -- Earthquake
            [157331] = true,                -- Wind Gust (Primal Storm Elemental)
            [170379] = true,                -- Earthen Rage
            [188389] = true,                -- Flame Shock
            [188443] = true,                -- Chain Lightning

            -- Healing Effect
            [114911] = true,                -- Ancestral Guidance

        -- Restoration
            -- Damage Effect
            [188838] = true,                -- Flame Shock

            -- Healing Effect
            [1064] = true,                  -- Chain Heal
            [52042] = true,                 -- Healing Stream Totem
            [61295] = true,                 -- Riptide
            [73921] = true,                 -- Healing Raid
            [114942] = true,                -- Healing Tide Totem
            [197997] = true,                -- Wellspring
            [207778] = true,                -- Downpour
            [294020] = true,                -- Restorative Wave
    },
    ["WARLOCK"] = {},
    ["WARRIOR"] = {},
}

-- outgoing healing filter, hide this spam shit.
ct["HealFilter"] = {
    ["DRUID"] = {},
    ["MONK"] = {},
    ["PALADIN"] = {
        [210291] = false,               -- Aura of Mercy
    },
    ["PRIEST"] = {
        [77489] = false,                -- Echo of Light
    },
    ["SHAMAN"] = {},
}