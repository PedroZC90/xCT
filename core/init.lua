local addon, ns = ...
ns.xCT = CreateFrame("Frame", "xCT", UIParent)
ns.Filters = {}

-- Addon
ns.xCT.Title = GetAddOnMetadata(addon, 'Title')
ns.xCT.Version = GetAddOnMetadata(addon, 'Version')
ns.xCT.VersionNumber = tonumber(ns.xCT.Version)
ns.xCT.Description = GetAddOnMetadata(addon, 'Notes')
ns.xCT.WelcomeMessage = string.format("|cff00ff96xCT %s|r - /xct help", ns.xCT.Version)

-- Character
ns.xCT.myName = UnitName("player")
ns.xCT.myClass = select(2, UnitClass("player"))
ns.xCT.myLevel = UnitLevel("player")
ns.xCT.myFaction = select(2, UnitFactionGroup("player"))
ns.xCT.myRace = select(2, UnitRace("player"))
ns.xCT.myRealm = GetRealmName()