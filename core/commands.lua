local _, ns = ...
local xCT = ns.xCT
local ct = ns.Config

----------------------------------------------------------------
-- Commands
----------------------------------------------------------------
-- string formats
local STRING_COLOR = "|cffb3ff19%s|r"

local function CommandSplit(cmd)
    if (cmd:find("%s")) then
        return strsplit(" ", cmd)
    end
    return cmd
end

SLASH_XCT1 = "/xct"
SlashCmdList["XCT"] = function(cmd)
    local arg1, arg2, arg3 = CommandSplit(cmd)

    if (arg1 == "show") then
        for index in pairs(ct.Frames) do
            local frame = xCT[index]
            if (frame) then
                frame.Backdrop:Show()
                frame.Header:Show()
                frame.Text:Show()
            end
        end
    elseif (arg1 == "hide") then
        for index in pairs(ct.Frames) do
            local frame = xCT[index]
            if (frame) then
                frame.Backdrop:Hide()
                frame.Header:Hide()
                frame.Text:Hide()
            end
        end
    elseif (arg1 == "") or (arg1 == "help") then
        print(" ")
        print(STRING_COLOR:format("xCT Commands:"))
        print(STRING_COLOR:format("show:"), "Display Frames.")
        print(STRING_COLOR:format("hide:"), "Hide Frames.")
        print(" ")
    end
end