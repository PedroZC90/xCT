local _, ns = ...
local xCT = ns.xCT

------------------------------------------------------------
-- Development
------------------------------------------------------------

--[[
-- function to simulate combat text addon.
local function RunConfigMode(self)
	local TimeLastUpdate = 0
	self:SetScript("OnUpdate", function(self, elapsed)
		local UpdateTime = math.random(1, 5)
		TimeLastUpdate = TimeLastUpdate + elapsed
		if (TimeLastUpdate > UpdateTime) then
			local school = 2 ^ math.random(0, 6)
			local r, g, b = unpack(SPELL_SCHOOL_COLOR[school])
			local amount = math.random(1e2, 1e7)
			local icon = IconEscapeSequence(select(3, GetSpellInfo(589)), ct.iconsize, ct.iconsize, 0, 0, 64, 64, 5, 59, 5, 59)
			for index, data in pairs(ct.Frames) do
				self[index]:AddMessage(amount .. " " .. icon , r, g, b, nil, ct.timevisible)
			end
			TimeLastUpdate = 0
		end
	end)
end
--]]