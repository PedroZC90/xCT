local _, ns = ...
local xCT = ns.xCT

----------------------------------------------------------------
-- Install
----------------------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

function f:ADDON_LOADED(addon)
    if (addon ~= "xCT")then return end

    print(xCT.WelcomeMessage)

    -- load saved variables
    local Name = UnitName("player")
    local Realm = GetRealmName()

    if (not xCTData) then xCTData = {} end
    if (not xCTData[Realm]) then xCTData[Realm] = {} end
    if (not xCTData[Realm][Name]) then xCTData[Realm][Name] = {} end

    local isInstalled = xCTData[Realm][Name].isInstalled

    if (not isInstalled) then
        self:SetupCombatText()

        xCTData[Realm][Name].isInstalled = true
    end

    self:UnregisterEvent("ADDON_LOADED")
end

-- configure blizzard combat text
function f:SetupCombatText()
    -- Combat Text
    SetCVar("enableFloatingCombatText", 1)
    SetCVar("floatingCombatTextAllSpellMechanics", 0)               -- (default = 0)
    SetCVar("floatingCombatTextAuras", 0)                           -- (default = 0)
    SetCVar("floatingCombatTextCombatDamage", 0)                    -- (default = 1)
    SetCVar("floatingCombatTextCombatDamageAllAutos", 0)            -- (default = 1)
    SetCVar("floatingCombatTextCombatDamageDirectionalOffset", 1)   -- (default = 1)
    SetCVar("floatingCombatTextCombatDamageDirectionalScale", 1)    -- (default = 1)
    SetCVar("floatingCombatTextCombatHealing", 0)                   -- (default = 0)
    SetCVar("floatingCombatTextCombatHealingAbsorbSelf", 0)         -- (default = 1)
    SetCVar("floatingCombatTextCombatHealingAbsorbTarget", 0)       -- (default = 1)
    SetCVar("floatingCombatTextCombatLogPeriodicSpells", 0)         -- (default = 1)
    SetCVar("floatingCombatTextCombatState", 0)
    SetCVar("floatingCombatTextComboPoints", 0)
    SetCVar("floatingCombatTextDamageReduction", 0)
    SetCVar("floatingCombatTextDodgeParryMiss", 0)
    SetCVar("floatingCombatTextEnergyGains", 0)
    SetCVar("floatingCombatTextFloatMode", 1)
    SetCVar("floatingCombatTextFriendlyHealers", 0)
    SetCVar("floatingCombatTextHonorGains", 0)
    SetCVar("floatingCombatTextLowManaHealth", 1)
    SetCVar("floatingCombatTextPeriodicEnergyGains", 0)
    SetCVar("floatingCombatTextPetMeleeDamage", 0)                  -- (default = 1)
    SetCVar("floatingCombatTextPetSpellDamage", 0)                  -- (default = 1)
    SetCVar("floatingCombatTextReactives", 1)
    SetCVar("floatingCombatTextRepChanges", 0)
    SetCVar("floatingCombatTextSpellMechanics", 0)
    SetCVar("floatingCombatTextSpellMechanicsOther", 0)
end