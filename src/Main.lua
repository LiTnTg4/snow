-- Snow UI 主入口
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

getgenv().SnowUI = getgenv().SnowUI or {}

local baseURL = "https://raw.githubusercontent.com/LiTnTg4/snow/main/src"

local loadOrder = {
    "Config.lua", "Utils.lua",
    "Core/Sensitivity.lua", "Core/Headless.lua", "Core/BrokenLegs.lua",
    "Core/Graphics.lua", "Core/Accessories.lua",
    "FF/FFlagTool.lua",
    "UI/Toast.lua", "UI/PerfButton.lua", "UI/Notice.lua",
    "UI/Tabs/FunctionsTab.lua", "UI/Tabs/FFlagTab.lua",
    "UI/Tabs/SensitivityTab.lua", "UI/Tabs/AccessoriesTab.lua",
    "UI/Tabs/SettingsTab.lua", "UI/UI.lua",
}

for _, fileName in ipairs(loadOrder) do
    local url = baseURL .. "/" .. fileName
    local ok, code = pcall(function() return game:HttpGet(url) end)
    if ok and code then
        local fn, err = loadstring(code)
        if fn then
            local s, r = pcall(fn)
            if s then print("[OK] " .. fileName) else warn("[ERR] " .. fileName .. ": " .. tostring(r)) end
        else warn("[SYN] " .. fileName .. ": " .. err) end
    else warn("[NET] " .. fileName) end
end

task.wait(1)
local M = getgenv().SnowUI

local old = PlayerGui:FindFirstChild("MinimalUI")
if old then old:Destroy() end

local UI = Instance.new("ScreenGui")
UI.Name = "MinimalUI"; UI.Parent = PlayerGui
UI.ResetOnSpawn = false; UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; UI.IgnoreGuiInset = true

M.Sensitivity.Init(); M.Headless.Init(); M.BrokenLegs.Init(); M.Accessories.Init()

local uiInstance = M.Build(UI)

local perfDrag, perfBtn = M.PerfButton.Create(UI, function()
    if uiInstance.IsVisible() then uiInstance.Close() else uiInstance.Open() end
end)

uiInstance.CloseBtn.MouseButton1Click:Connect(function() uiInstance.Close() end)

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and uiInstance.IsVisible() then
        local pos = game:GetService("UserInputService"):GetMouseLocation()
        local objs = PlayerGui:GetGuiObjectsAtPosition(pos.X, pos.Y)
        local inside = false
        for _, obj in ipairs(objs) do
            if obj == uiInstance.Panel or obj:IsDescendantOf(uiInstance.Panel)
                or obj == perfDrag or obj:IsDescendantOf(perfDrag) then
                inside = true; break
            end
        end
        if not inside then uiInstance.Close() end
    end
end)

print("============================================")
print("  Snow UI v4.0 Ready")
print("  Click FPS display to open")
print("============================================")