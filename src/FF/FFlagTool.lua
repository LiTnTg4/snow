getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.FFlagTool = {}
local FT = getgenv().SnowUI.FFlagTool
local HS = game:GetService("HttpService")
local sf = "FFlagPaste_saved.json"
function FT.Apply(j)
    if not setfflag then return false,"不支持" end
    local ok,data = pcall(function() return HS:JSONDecode(j) end)
    if not ok then return false,"JSON错误" end
    local n=0
    for f,v in pairs(data) do pcall(function() local cl=f:gsub("DFInt",""):gsub("DFFlag",""):gsub("FFlag",""):gsub("FInt",""); setfflag(cl,tostring(v)); n=n+1 end) end
    return true,n
end
function FT.Save(j) return pcall(function() writefile(sf,j) end) end
function FT.Load() if isfile(sf) then return readfile(sf) end; return nil end