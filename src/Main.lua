-- Snow UI 主入口
local P = game:GetService("Players")
local PG = P.LocalPlayer:WaitForChild("PlayerGui")
getgenv().SnowUI = getgenv().SnowUI or {}

local function loadOne(url)
    local ok, code = pcall(function() return game:HttpGet(url) end)
    if ok and code then
        local fn, err = loadstring(code)
        if fn then pcall(fn) end
    end
end

local base = "https://raw.githubusercontent.com/LiTnTg4/snow/main/src"
local order = {"Config.lua","Utils.lua","Core/Sensitivity.lua","Core/Headless.lua","Core/BrokenLegs.lua","Core/Graphics.lua","Core/Accessories.lua","FF/FFlagTool.lua","UI/Toast.lua","UI/PerfButton.lua","UI/Notice.lua","UI/Tabs/FunctionsTab.lua","UI/Tabs/FFlagTab.lua","UI/Tabs/SensitivityTab.lua","UI/Tabs/AccessoriesTab.lua","UI/Tabs/SettingsTab.lua","UI/UI.lua"}
for _, f in ipairs(order) do loadOne(base.."/"..f) end

task.wait(2)
local M = getgenv().SnowUI

local old = PG:FindFirstChild("MinimalUI"); if old then old:Destroy() end
local old2 = PG:FindFirstChild("AccessoryToggleGui"); if old2 then old2:Destroy() end
local old3 = PG:FindFirstChild("PerfMonitor"); if old3 then old3:Destroy() end

local UI = Instance.new("ScreenGui"); UI.Name="MinimalUI"; UI.Parent=PG; UI.ResetOnSpawn=false; UI.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; UI.IgnoreGuiInset=true

M.Sensitivity.Init(); M.Headless.Init(); M.BrokenLegs.Init(); M.Accessories.Init()

local ui = M.Build(UI)
local pDrag, pBtn = M.PerfButton.Create(UI, function() if ui.IsVisible() then ui.Close() else ui.Open() end end)
ui.CloseBtn.MouseButton1Click:Connect(function() ui.Close() end)

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 and ui.IsVisible() then
        local pos = game:GetService("UserInputService"):GetMouseLocation()
        local objs = PG:GetGuiObjectsAtPosition(pos.X, pos.Y)
        local inside = false
        for _, obj in ipairs(objs) do if obj==ui.Panel or obj:IsDescendantOf(ui.Panel) or obj==pDrag or obj:IsDescendantOf(pDrag) then inside=true; break end end
        if not inside then ui.Close() end
    end
end)
print("Snow UI Ready")