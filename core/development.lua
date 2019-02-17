local _, ns = ...
local xCT = ns.xCT
local ct = ns.Config

----------------------------------------------------------------
-- Development (write anything here)
----------------------------------------------------------------
if (true) then return end

local variables = {
    "enableFloatingCombatText",
    "floatingCombatTextAllSpellMechanics",
    "floatingCombatTextAuras",
    "floatingCombatTextCombatDamage",
    "floatingCombatTextCombatDamageAllAutos",
    "floatingCombatTextCombatDamageDirectionalOffset",
    "floatingCombatTextCombatDamageDirectionalScale",
    "floatingCombatTextCombatHealing",
    "floatingCombatTextCombatHealingAbsorbSelf",
    "floatingCombatTextCombatHealingAbsorbTarget",
    "floatingCombatTextCombatLogPeriodicSpells",
    "floatingCombatTextCombatState",
    "floatingCombatTextComboPoints",
    "floatingCombatTextDamageReduction",
    "floatingCombatTextDodgeParryMiss",
    "floatingCombatTextEnergyGains",
    "floatingCombatTextFloatMode",
    "floatingCombatTextFriendlyHealers",
    "floatingCombatTextHonorGains",
    "floatingCombatTextLowManaHealth",
    "floatingCombatTextPeriodicEnergyGains",
    "floatingCombatTextPetMeleeDamage",
    "floatingCombatTextPetSpellDamage",
    "floatingCombatTextReactives",
    "floatingCombatTextRepChanges",
    "floatingCombatTextSpellMechanics",
    "floatingCombatTextSpellMechanicsOther",
}

for _, var in ipairs(variables) do
    print(var, GetCVar(var))
end