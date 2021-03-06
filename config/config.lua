local _, ns = ...
local md = ns.Medias

----------------------------------------------------------------
-- Configuration
----------------------------------------------------------------
ns.Config = {
    -- Blizzard CombatText Options
    ["Blizzard"] = true,                   -- enables blizzard damage/healing floating combat text.

    -- CombatText Options
    ["Damage"] = true,                      -- enables damage done frame.
    ["PetDamage"] = true,                   -- display pet damage done.
    ["Healing"] = true,                     -- enables healing done frame.
    ["IncomeDamage"] = false,               -- enables incoming damage frame.
    ["IncomeHealing"] = true,               -- enables incoming healing frame.
    ["Messages"] = true,                    -- enables message frame.
    ["DamageColor"] = true,                 -- sets damage numbers based on spell school.
    ["HealingColor"] = true,                -- sets healing numbers based on spell school.
    ["ShowIcon"] = true,                    -- enables outgoing damage/healing spell icons.
    ["IconSize"] = 14,                      -- sets icon size displayed in outgoing damage/healing frame.
    ["Threshold"] = 1,                      -- sets minimum damage/healing to show.
    ["ShortValues"] = false,                -- enables short value of healing/damage amounts.

    -- Appearence
    ["Font"] = md.PixelFont,                -- sets default font.
    ["FontSize"] = 12,                      -- sets default font size.
    ["FontStyle"] = "MONOCHROMEOUTLINE",    -- sets default font style.
    ["DamageFont"] = md.Font,               -- sets combat text font.
    ["DamageFontSize"] = 20,                -- sets combat text font size (use "auto" to set font size automatically, based on icon size).
    ["DamageFontStyle"] = nil,              -- sets combat text font style.
    ["FadeDuration"] = 0.5,                 -- sets the duration of the fade-out animation for disappearing messages.
    ["TimeVisible"] = 3,                    -- sets the amount of time for a message remains visible before beggin to fade-out.
    ["MaxLines"] = 64,                      -- sets the maximum number of messages to be kept in the frame.
    ["Spacing"] = 2,                        -- sets the spacing between lines.
    ["Scrollable"] = false,                 -- enables scrolling frame lines with mousewheel.

    -- Modules
    ["MergeAoESpam"] = true,                -- merge multiples damage/healing messages into a single one value (useful for dots too).
    ["MergeAoESpamTime"] = 2.0,             -- sets elapsed time (in seconds) aoe spell will be merged. (default 3.0)
    ["Dispel"] = true,                      -- enables dispel messages on outgoing damage frame.
    ["Interrupt"] = true,                   -- enables interrupt messages on outgoind damage frame.
    ["Runes"] = true,                       -- enables deathknight rune rechange
    ["ParseValue"] = false,                 -- show partical value by discounting blocked, absorbed, resistance, etc.s
}

ns.Config["Frames"] = {
    [1] = {
        Name = "INCOME_DAMAGE",
        Anchor = { "CENTER", UIParent, "CENTER", 0, 70 },
        Size = { 204, 256 },
        Justify = "CENTER",
        Enable = ns.Config.IncomeDamage,
    },
    [2] = {
        Name = "INCOME_HEALING",
        Anchor = { "BOTTOMRIGHT", UIParent, "CENTER", -200, 101 },
        Size = { 204, 256 },
        Justify = "CENTER",
        Enable = ns.Config.IncomeHealing,
    },
    [3] = {
        Name = "MESSAGES",
        Anchor = { "BOTTOM", UIParent, "CENTER", 0, 228 },
        Size = { 204, 178 },
        Justify = "CENTER",
        Enable = ns.Config.Messages,
    },
    [4] = {
        Name = "DAMAGE/HEALING_DONE",
        Anchor = { "BOTTOMLEFT", UIParent, "CENTER", 200, 101 },
        Size = { 204, 256 },
        Justify = "CENTER",
        Spam = true,
        Enable = ns.Config.Damage or ns.Config.Healing,
    },
}