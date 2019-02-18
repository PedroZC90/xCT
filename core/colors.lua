local _, ns = ...
local ct = ns.Config

----------------------------------------------------------------
-- Colors
----------------------------------------------------------------
ct.Colors = {
    -- Damage
    ["DAMAGE"]                      = { r = 1.00, g = 0.10, b = 0.10 },
    ["SPELL_DAMAGE"]                = { r = 0.79, g = 0.30, b = 0.85 },
    ["SPLIT_DAMAGE"]                = { r = 1.00, g = 1.00, b = 1.00 },
    -- Heal
    ["HEAL"]                        = { r = 0.10, g = 1.00, b = 0.10 },
    ["HEAL_ABSORB"]                 = { r = 0.10, g = 1.00, b = 0.10 },
    ["ABSORB_ADDED"]                = { r = 1.00, g = 1.00, b = 0.50 },
    -- Miss
    ["MISS"]                        = { r = 1.00, g = 1.00, b = 1.00 },
    ["DODGE"]                       = { r = 1.00, g = 1.00, b = 1.00 },
    ["PARRY"]                       = { r = 1.00, g = 1.00, b = 1.00 },
    ["EVADE"]                       = { r = 1.00, g = 1.00, b = 1.00 },
    ["IMMUNE"]                      = { r = 1.00, g = 1.00, b = 1.00 },
    ["DEFLECT"]                     = { r = 1.00, g = 1.00, b = 1.00 },
    ["REFLECT"]                     = { r = 1.00, g = 1.00, b = 1.00 },
    -- Resistance
    ["ABSORB"]                      = { r = 1.00, g = 1.00, b = 1.00 },
    ["BLOCK"]                       = { r = 1.00, g = 1.00, b = 1.00 },
    ["RESIST"]                      = { r = 1.00, g = 1.00, b = 1.00 },
    -- Cast
    ["SPELL_CAST"]                  = { r = 1.00, g = 0.85, b = 0.00 },
    ["SPELL_ACTIVE"]                = { r = 1.00, g = 0.85, b = 0.00 },
    -- Auras
    ["SPELL_AURA_END"]              = { r = 0.10, g = 1.00, b = 0.10 },
    ["SPELL_AURA_END_HARMFUL"]      = { r = 1.00, g = 0.10, b = 0.10 },
    ["SPELL_AURA_START"]            = { r = 1.00, g = 0.85, b = 0.00 },
    ["SPELL_AURA_START_HARMFUL"]    = { r = 1.00, g = 0.10, b = 0.10 },
    ["EXTRA_ATTACKS"]               = { r = 1.00, g = 1.00, b = 1.00 },
    -- Extra
    ["INTERRUPT"]                   = { r = 1.00, g = 0.50, b = 0.00 },
    ["DISPEL"]                      = { r = 1.00, g = 1.00, b = 1.00 },
    -- Gains
    ["FACTION"]                     = { r = 0.10, g = 0.10, b = 1.00 },
    ["HONOR_GAINED"]                = { r = 0.10, g = 0.10, b = 1.00 },
    -- Others
    ["HEALTH_LOW"]                  = { r = 1.00, g = 0.10, b = 0.10 },
    ["MANA_LOW"]                    = { r = 1.00, g = 0.10, b = 0.10 },
    ["ENTERING_COMBAT"]             = { r = 1.00, g = 0.10, b = 0.10 },
    ["LEAVING_COMBAT"]              = { r = 1.00, g = 0.10, b = 0.10 },
}

ct.Colors["Auras"] = {
    ["BUFF"]                        = { r = 0.00, g = 1.00, b = 0.50 },
    ["DEBUFF"]                      = { r = 1.00, g = 0.00, b = 0.50 },
}

ct.Colors["Power"] = {
    ["MANA"]                        = { r = 0.31, g = 0.45, b = 0.63 },
    ["INSANITY"]                    = { r = 0.40, g = 0.00, b = 0.80 },
    ["MAELSTROM"]                   = { r = 0.00, g = 0.50, b = 1.00 },
    ["LUNAR_POWER"]                 = { r = 0.93, g = 0.51, b = 0.93 },
    ["HOLY_POWER"]                  = { r = 0.95, g = 0.90, b = 0.60 },
    ["RAGE"]                        = { r = 0.69, g = 0.31, b = 0.31 },
    ["FOCUS"]                       = { r = 0.71, g = 0.43, b = 0.27 },
    ["ENERGY"]                      = { r = 0.65, g = 0.63, b = 0.35 },
    ["CHI"]                         = { r = 0.71, g = 1.00, b = 0.92 },
    ["RUNES"]                       = { r = 0.55, g = 0.57, b = 0.61 },
    ["SOUL_SHARDS"]                 = { r = 0.50, g = 0.32, b = 0.55 },
    ["FURY"]                        = { r = 0.78, g = 0.26, b = 0.99 },
    ["PAIN"]                        = { r = 1.00, g = 0.61, b = 0.00 },
    ["RUNIC_POWER"]                 = { r = 0.00, g = 0.82, b = 1.00 },
    ["AMMOSLOT"]                    = { r = 0.80, g = 0.60, b = 0.00 },
    ["FUEL"]                        = { r = 0.00, g = 0.55, b = 0.50 },
    ["POWER_TYPE_STEAM"]            = { r = 0.55, g = 0.57, b = 0.61 },
    ["POWER_TYPE_PYRITE"]           = { r = 0.60, g = 0.09, b = 0.17 },
    ["ALTPOWER"]                    = { r = 0.00, g = 1.00, b = 1.00 },
    ["COMBO_POINTS"]                = { r = 1.00, g = 0.96, b = 0.41 },
    ["DEMONIC_FURY"]                = { r = 1.00, g = 1.00, b = 1.00 },
    ["ARCANE_CHARGES"]              = { r = 0.10, g = 0.10, b = 0.98 },
    ["AMMOSLOT"]                    = { r = 0.80, g = 0.60, b = 0.00 },
    ["STAGGER"] = {
        [1]                         = { r = 0.42, g = 1.00, b = 0.42 },
        [2]                         = { r = 1.00, g = 1.00, b = 0.42 },
        [3]                         = { r = 1.00, g = 0.42, b = 0.42 },
    }
}

ct.Colors["School"] = {
    [SCHOOL_MASK_NONE]              = { r = 1.00, g = 1.00, b = 1.00 },
    [SCHOOL_MASK_PHYSICAL]          = { r = 1.00, g = 1.00, b = 0.00 },
    [SCHOOL_MASK_HOLY]              = { r = 1.00, g = 0.90, b = 0.50 },
    [SCHOOL_MASK_FIRE]              = { r = 1.00, g = 0.50, b = 0.00 },
    [SCHOOL_MASK_NATURE]            = { r = 0.30, g = 1.00, b = 0.30 },
    [SCHOOL_MASK_FROST]             = { r = 0.50, g = 1.00, b = 1.00 },
    [SCHOOL_MASK_SHADOW]            = { r = 0.50, g = 0.50, b = 1.00 },
    [SCHOOL_MASK_ARCANE]            = { r = 1.00, g = 0.50, b = 1.00 },
}