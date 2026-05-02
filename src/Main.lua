-- Snow UI 主入口
-- 模块化加载器 - 全局表版本

local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- 初始化全局表
getgenv().SnowUI = getgenv().SnowUI or {}

-- 加载顺序
local loadOrder = {
    "Config.lua",
    "Utils.lua",
    "Core/Sensitivity.lua",
    "Core/Headless.lua",
    "Core/BrokenLegs.lua",
    "Core/Graphics.lua",
    "Core/Accessories.lua",
    "FF/FFlagTool.lua",
    "UI/Toast.lua",
    "UI/PerfButton.lua",
    "UI/Notice.lua",
    "UI/Tabs/FunctionsTab.lua",
    "UI/Tabs/FFlagTab.lua",
    "UI/Tabs/SensitivityTab.lua",
    "UI/Tabs/AccessoriesTab.lua",
    "UI/Tabs/SettingsTab.lua",
    "UI/UI.lua",
}

local baseURL = "https://raw.githubusercontent.com/LiTnTg4/snow/main/src"

-- 逐个加载
for _, fileName in ipairs(loadOrder) do
    local url = baseURL .. "/" .. fileName
    local success, code = pcall(function() return game:HttpGet(url) end)
    if success and code then
        local fn, err = loadstring(code)
        if fn then
            local ok, result = pcall(fn)
            if ok then
                print("[OK] " .. fileName)
            else
                warn("[ERR] " .. fileName .. ": " .. tostring(result))
            end
        else
            warn("[SYN] " .. fileName .. ": " .. err)
        end
    else
        warn("[NET] " .. fileName)
    end
end

-- 等待所有模块加载完成
task.wait(1)

-- 初始化
local M = getgenv().SnowUI

-- 清理旧UI
local old = PlayerGui:FindFirstChild("MinimalUI")
if old then old:Destroy() end

local UI = Instance.new("ScreenGui")
UI.Name = "MinimalUI"
UI.Parent = PlayerGui
UI.ResetOnSpawn = false
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.IgnoreGuiInset = true

-- 初始化Core系统
M.Sensitivity.Init()
M.Headless.Init()
M.BrokenLegs.Init()
M.Accessories.Init()

-- 构建UI
local uiInstance = M.Build(UI)

-- 创建FPS按钮
local perfDrag, perfBtn = M.PerfButton.Create(UI, function()
    if uiInstance.IsVisible() then uiInstance.Close() else uiInstance.Open() end
end)

-- 关闭按钮
uiInstance.CloseBtn.MouseButton1Click:Connect(function() uiInstance.Close() end)

-- 点击外部关闭
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
print("  Snow UI v4.0 - Modular Global Table")
print("  Click FPS display to open menu")
print("============================================")