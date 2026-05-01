-- FFlag JSON 工具
local HttpService = game:GetService("HttpService")

local FFlagTool = {}
local saveFile = "FFlagPaste_saved.json"

function FFlagTool.Apply(jsonText)
    if not setfflag then
        return false, "执行器不支持setfflag"
    end
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(jsonText)
    end)
    
    if not success then
        return false, "JSON格式错误"
    end
    
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
    local success = pcall(function()
        writefile(saveFile, jsonText)
    end)
    return success
end

function FFlagTool.Load()
    if isfile(saveFile) then
        return readfile(saveFile)
    end
    return nil
end

function FFlagTool.GetSaveFile()
    return saveFile
end

return FFlagTool