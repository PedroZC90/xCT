local _, ns = ...
local xCT = ns.xCT
local ct = ns.Config

----------------------------------------------------------------
-- Functions
----------------------------------------------------------------
-- string patterns
local STRING_VULNERABILITY  = "|cffffffff(+%s damage)|r"
local STRING_RESISTED       = "|cffffffff(-%s resisted)|r"
local STRING_BLOCKED        = "|cffffffff(-%s blocked)|r"
local STRING_ABSORBED       = "|cffffffff(-%s absorbed)|r"
local STRING_GLANCING       = "|cffffffff(glance)|r"
local STRING_CRUSHING       = "|cffffffff(crush)|r"
local STRING_OVERHEALING    = "|cffffffff(%s overheal)|r"
local STRING_OVERKILL       = "|cffffffff(%s overkill)|r"

-- returns short value of a number.
local ShortValue = function(v)
    if (ct.ShortValue) then
        if (v >= 1e6) then
            return gsub(format("%.2fm", v / 1e6), "%.?0+([km])$", "%1")
        elseif (v >= 1e3 or v <= -1e3) then
            return gsub(format("%.2fk", v / 1e3), "%.?0+([km])$", "%1")
        else
            return v
        end
    end
    return v
end
xCT.ShortValue = ShortValue

-- returns icon scape sequence of a texture.
local IconString = function(texture)
    if (not texture) then texture = ct.Medias.Blank end
    return "\124T" .. texture .. ":" .. ct.IconSize .. ":" .. ct.IconSize .. ":0:0:64:64:5:59:5:59\124t"
end
xCT.IconString = IconString

-- returns spell color of highest school mask.
local function GetSpellColor(school)
    local color = ct.Colors.School[school]
    if (not color) then
        for k, v in pairs(ct.Colors.School) do
            if (bit.band(k, school) > 0) then
                color = v
            end
        end
    end
    return color
end
xCT.GetSpellColor = GetSpellColor

-- break damage/healing value
local ParseDamageHealingValue = function(amount, overkill, overhealing, resisted, blocked, absorbed, critical, glancing, crushing)
    local result
    
    local isOverkill = (overkill) and (overkill > 0)
    local isOverhealing = (overhealing) and (overhealing > 0)
    local isAbsorbed = (absorbed) and (absorbed > 0)

    if (isOverkill) or (isOverhealing) or (isAbsorbed) or (resisted) or (blocked) or (critical) or (glancing) or (crushing) then

        -- initialize an empty string
        result = nil

        if (resisted) then
            if (resisted < 0) then  -- vulnerability
                result = STRING_VULNERABILITY:format(ShortValue(-resisted))
            else    -- resistance
                result = STRING_RESISTED:format(ShortValue(resisted))
            end
            amount = amount - resisted
        end

        if (blocked) then
            if (result) then
                result = STRING_BLOCKED:format(ShortValue(blocked)) .. " " .. result
            else
                result = STRING_BLOCKED:format(ShortValue(blocked))
            end
            amount = amount - blocked
        end

        if (isAbsorbed) then
            if (result) then
                result = STRING_ABSORBED:format(ShortValue(absorbed)) .. " " .. result
            else
                result = STRING_ABSORBED:format(ShortValue(absorbed))
            end
            amount = amount - absorbed
        end

        if (glancing) then
            if (result) then
                result = STRING_GLANCING .. " " .. result
            else
                result = STRING_GLANCING
            end
        end

        if (crushing) then
            if (result) then
                result = STRING_CRUSHING .. " " .. result
            else
                result = STRING_CRUSHING
            end
        end

        if (isOverhealing) then
            if (result) then
                result = STRING_OVERHEALING:format(ShortValue(overhealing)) .. " " .. result
            else
                result = STRING_OVERHEALING:format(ShortValue(overhealing))
            end
            amount = amount - overhealing
        end

        if (isOverkill) then
            if (result) then
                result = STRING_OVERKILL:format(ShortValue(overkill)) .. " " .. result
            else
                result = STRING_OVERKILL:format(ShortValue(overkill))
            end
            amount = amount - overkill
        end
    end

    if (result) then
        return result .. " " .. amount
    else
        return result
    end
end
xCT.ParseDamageHealingValue = ParseDamageHealingValue