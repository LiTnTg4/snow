getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.FFlagTool = {}
local FFlagTool = getgenv().SnowUI.FFlagTool
local HttpService = game:GetService("HttpService")

local saveFile = "FFlagPaste_saved.json"

function FFlagTool.Apply(jsonText)
    if not setfflag then return false, "执行器不支持setfflag" end
    local success, data = pcall(function() return HttpService:JSONDecode(jsonText) end)
    if not success then return false, "JSON格式错误" end
    local count = 0
    for flag, value in pairs(data) do
        pcall(function()
            local clean = flag:gsub("DFInt", ""):gsub("DFFlag", ""):gsub("FFlag", ""):gsub("FInt", "")
            setfflag(clean, tostring(value))
            count = count + 1
        end)
    end
    return true, count
end

function FFlagTool.Save(jsonText)
    return pcall(function() writefile(saveFile, jsonText) end)
end

function FFlagTool.Load()
    if isfile(saveFile) then return readfile(saveFile) end
    return nil
end