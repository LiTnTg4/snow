-- 主入口文件
-- 加载顺序：Config → Utils → Core模块 → UI模块

local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- 清理旧UI
local old = PlayerGui:FindFirstChild("MinimalUI")
if old then old:Destroy() end

-- 创建ScreenGui
local UI = Instance.new("ScreenGui")
UI.Name = "MinimalUI"
UI.Parent = PlayerGui
UI.ResetOnSpawn = false
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.IgnoreGuiInset = true

-- ==================== 加载模块 ====================

-- 基础模块
local Config = require(script.Config)
local Utils = require(script.Utils)

-- Core模块
local Sensitivity = require(script.Core.Sensitivity)
local Headless = require(script.Core.Headless)
local BrokenLegs = require(script.Core.BrokenLegs)
local Graphics = require(script.Core.Graphics)
local Accessories = require(script.Core.Accessories)

-- UI模块
local Toast = require(script.UI.Toast)
local PerfButton = require(script.UI.PerfButton)

-- FF模块
local FFlagTool = require(script.FF.FFlagTool)

-- ==================== 初始化Core系统 ====================
Sensitivity.Init()
Headless.Init()
BrokenLegs.Init()
Accessories.Init()

-- ==================== 全局工具引用 ====================
local C = Config.Colors
local D = Config.Defaults

local Camera = workspace.CurrentCamera
local ScreenW = Camera.ViewportSize.X
local ScreenH = Camera.ViewportSize.Y
local defaultW = math.clamp(math.floor(ScreenW * 0.45), D.MinWidth, D.MaxWidth)
local defaultH = math.clamp(math.floor(ScreenH * 0.55), D.MinHeight, D.MaxHeight)

local SavedConfig = {
    width = defaultW,
    height = defaultH,
    posX = nil,
    posY = nil,
    sensitivity = D.Sensitivity,
}

local menuVisible = false
local dragState = { active = false, startMouse = Vector2.zero, startPos = Vector2.zero }
local sliderState = { active = false }

-- ==================== 创建性能监控按钮 ====================
local function ToggleMenu()
    if menuVisible then CloseMenu() else OpenMenu() end
end

local perfDrag, perfBtn = PerfButton.Create(UI, ToggleMenu)

-- ==================== 主面板 ====================
local function GetDefaultPos()
    return UDim2.new(0.5, -SavedConfig.width/2, 0.5, -SavedConfig.height/2)
end

local function GetSavedPos()
    return SavedConfig.posX and UDim2.new(0, SavedConfig.posX, 0, SavedConfig.posY) or GetDefaultPos()
end

local Panel = Utils.Create("Frame", {
    Size = UDim2.new(0, SavedConfig.width, 0, SavedConfig.height),
    Position = GetSavedPos(),
    BackgroundColor3 = C.Base,
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 20,
    Parent = UI,
    Corner = 10,
})
Utils.Create("UIStroke", { Color = C.Border, Thickness = 1, Transparency = 0.4, Parent = Panel })

-- ==================== 标题栏 ====================
local TitleBar = Utils.Create("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = C.Panel,
    BorderSizePixel = 0,
    ZIndex = 21,
    Parent = Panel,
    Corner = 10,
})
Utils.Create("Frame", {
    Size = UDim2.new(1, 0, 0.5, 0),
    Position = UDim2.new(0, 0, 0.5, 0),
    BackgroundColor3 = C.Panel,
    BorderSizePixel = 0,
    ZIndex = 21,
    Parent = TitleBar,
})
Utils.Create("TextLabel", {
    Size = UDim2.new(0, 120, 0, 20),
    Position = UDim2.new(0, 14, 0.5, -10),
    BackgroundTransparency = 1,
    Text = "控制面板",
    TextColor3 = C.Text,
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 22,
    Parent = TitleBar,
})

local NoticeBtn = Utils.Create("TextButton", {
    Size = UDim2.new(0, 56, 0, 26),
    Position = UDim2.new(1, -124, 0.5, -13),
    BackgroundColor3 = C.Warning,
    BorderSizePixel = 0,
    Text = "公告",
    TextColor3 = Color3.fromRGB(20, 20, 25),
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 22,
    Parent = TitleBar,
    Corner = 6,
})

local CloseBtn = Utils.Create("TextButton", {
    Size = UDim2.new(0, 28, 0, 28),
    Position = UDim2.new(1, -38, 0.5, -14),
    BackgroundColor3 = C.Element,
    BorderSizePixel = 0,
    Text = "X",
    TextColor3 = C.TextDim,
    TextSize = 14,
    Font = Enum.Font.GothamMedium,
    AutoButtonColor = false,
    ZIndex = 22,
    Parent = TitleBar,
    Corner = 14,
})

CloseBtn.MouseEnter:Connect(function() Utils.Tween(CloseBtn, { BackgroundColor3 = C.Danger }, 0.15) end)
CloseBtn.MouseLeave:Connect(function() Utils.Tween(CloseBtn, { BackgroundColor3 = C.Element }, 0.15) end)

-- ==================== 标签栏 ====================
local TabBar = Utils.Create("Frame", {
    Size = UDim2.new(1, 0, 0, 42),
    Position = UDim2.new(0, 0, 0, 40),
    BackgroundColor3 = C.Panel,
    BorderSizePixel = 0,
    ZIndex = 21,
    Parent = Panel,
})
Utils.Create("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 1, -1),
    BackgroundColor3 = C.Border,
    BorderSizePixel = 0,
    ZIndex = 22,
    Parent = TabBar,
})

local TabContainer = Utils.Create("Frame", {
    Size = UDim2.new(0, 0, 1, 0),
    Position = UDim2.new(0, 14, 0, 0),
    BackgroundTransparency = 1,
    ZIndex = 22,
    Parent = TabBar,
})

local TabLayout = Utils.Create("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 6),
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Parent = TabContainer,
})

local ContentArea = Utils.Create("Frame", {
    Size = UDim2.new(1, 0, 1, -82),
    Position = UDim2.new(0, 0, 0, 82),
    BackgroundColor3 = C.Base,
    BorderSizePixel = 0,
    ZIndex = 21,
    Parent = Panel,
})

-- ==================== 标签系统 ====================
local currentTab = Config.TabIDs[1]
local tabBtns = {}
local tabContents = {}
local accessoryButtons = {}

local function SwitchTab(id)
    if currentTab == id then return end
    currentTab = id
    for tid, btn in pairs(tabBtns) do
        Utils.Tween(btn, {
            BackgroundColor3 = tid == id and C.Active or C.Panel,
            TextColor3 = tid == id and C.Text or C.TextDim,
        })
    end
    for tid, content in pairs(tabContents) do
        content.Visible = (tid == id)
    end
end

for i, id in ipairs(Config.TabIDs) do
    local btn = Utils.Create("TextButton", {
        Size = UDim2.new(0, 60, 0, 32),
        BackgroundColor3 = i == 1 and C.Active or C.Panel,
        BorderSizePixel = 0,
        Text = Config.TabNames[i],
        TextColor3 = i == 1 and C.Text or C.TextDim,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false,
        ZIndex = 22,
        Parent = TabContainer,
        Corner = 6,
    })
    btn.MouseEnter:Connect(function()
        if id ~= currentTab then Utils.Tween(btn, { BackgroundColor3 = C.Hover }, 0.15) end
    end)
    btn.MouseLeave:Connect(function()
        if id ~= currentTab then Utils.Tween(btn, { BackgroundColor3 = C.Panel }, 0.15) end
    end)
    btn.MouseButton1Click:Connect(function() SwitchTab(id) end)
    tabBtns[id] = btn
end

TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabContainer.Size = UDim2.new(0, TabLayout.AbsoluteContentSize.X, 1, 0)
end)

-- ==================== Content Frame Helper ====================
local function CreateContentFrame()
    local frame = Utils.Create("ScrollingFrame", {
        Size = UDim2.new(1, -16, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.Element,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ZIndex = 22,
        Parent = ContentArea,
    })
    local list = Utils.Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = frame,
    })
    Utils.Create("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
        Parent = frame,
    })
    return frame, list
end

-- ==================== 功能标签页 ====================
local NormalContent, NormalList = CreateContentFrame()
NormalContent.Visible = true
tabContents[Config.TabIDs[1]] = NormalContent

local normalItems = {
    { title = "无头", desc = "隐藏角色头部和脸部", action = function()
        local active = Headless.Toggle()
        Toast.Show("无头", active and "已开启" or "已关闭", 2)
    end },
    { title = "R6断腿", desc = "仅R6角色可用", action = function()
        local active = BrokenLegs.ToggleR6()
        Toast.Show("R6断腿", active and "已开启" or "已关闭", 1.5)
    end },
    { title = "R15断腿", desc = "仅R15角色可用", action = function()
        local active = BrokenLegs.ToggleR15()
        Toast.Show("R15断腿", active and "已开启" or "已关闭", 1.5)
    end },
    { title = "画质简化", desc = "降低画质提升性能", action = function()
        local active = Graphics.Toggle()
        Toast.Show("画质简化", active and "已开启" or "已关闭", 1.5)
    end },
    { title = "隐藏饰品", desc = "在饰品标签页设置", action = function()
        SwitchTab("accessories")
        Toast.Show("隐藏饰品", "请在饰品标签页中选择", 2)
    end },
}

for _, item in ipairs(normalItems) do
    local card = Utils.Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = C.Element,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 23,
        Parent = NormalContent,
        Corner = 6,
    })
    Utils.Create("Frame", {
        Size = UDim2.new(0, 4, 1, -16),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundColor3 = C.Accent,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 24,
        Parent = card,
        Corner = 2,
    })
    Utils.Create("TextLabel", {
        Size = UDim2.new(0, 160, 0, 16),
        Position = UDim2.new(0, 24, 0, 8),
        BackgroundTransparency = 1,
        Text = item.title,
        TextColor3 = C.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 24,
        Parent = card,
    })
    Utils.Create("TextLabel", {
        Size = UDim2.new(0, 200, 0, 14),
        Position = UDim2.new(0, 24, 0, 26),
        BackgroundTransparency = 1,
        Text = item.desc,
        TextColor3 = C.TextMuted,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 24,
        Parent = card,
    })
    card.MouseEnter:Connect(function() Utils.Tween(card, { BackgroundColor3 = C.Hover }, 0.15) end)
    card.MouseLeave:Connect(function() Utils.Tween(card, { BackgroundColor3 = C.Element }, 0.15) end)
    card.MouseButton1Click:Connect(function()
        if item.action then item.action() end
        Utils.Tween(card, { BackgroundColor3 = C.Active }, 0.1)
        task.wait(0.1)
        Utils.Tween(card, { BackgroundColor3 = C.Hover }, 0.15)
    end)
end

NormalList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    NormalContent.CanvasSize = UDim2.new(0, 0, 0, NormalList.AbsoluteContentSize.Y + 8)
end)

-- ==================== FFlag 标签页 ====================
local FFlagContent, FFlagList = CreateContentFrame()
FFlagContent.Visible = false
tabContents[Config.TabIDs[2]] = FFlagContent

local FFlagCard = Utils.Create("Frame", {
    Size = UDim2.new(1, 0, 0, 240),
    BackgroundColor3 = C.Element,
    BorderSizePixel = 0,
    ZIndex = 23,
    Parent = FFlagContent,
    Corner = 6,
})

Utils.Create("TextLabel", {
    Size = UDim2.new(0, 200, 0, 20),
    Position = UDim2.new(0, 14, 0, 12),
    BackgroundTransparency = 1,
    Text = "FFlags.json 粘贴工具",
    TextColor3 = C.TextDim,
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 24,
    Parent = FFlagCard,
})

local FFlagInput = Utils.Create("TextBox", {
    Size = UDim2.new(1, -28, 0, 140),
    Position = UDim2.new(0, 14, 0, 40),
    BackgroundColor3 = C.Base,
    BorderSizePixel = 0,
    Text = "",
    PlaceholderText = "粘贴 FFlags.json 内容...",
    PlaceholderColor3 = C.TextMuted,
    TextColor3 = C.Text,
    TextSize = 12,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    ClearTextOnFocus = false,
    ZIndex = 24,
    Parent = FFlagCard,
    Corner = 4,
})

local BtnContainer = Utils.Create("Frame", {
    Size = UDim2.new(1, -28, 0, 34),
    Position = UDim2.new(0, 14, 0, 190),
    BackgroundTransparency = 1,
    ZIndex = 24,
    Parent = FFlagCard,
})

Utils.Create("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 6),
    Parent = BtnContainer,
})

-- 应用按钮
local ApplyBtn = Utils.Create("TextButton", {
    Size = UDim2.new(0, 100, 1, 0),
    BackgroundColor3 = C.Success,
    BorderSizePixel = 0,
    Text = "应用FFlags",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 25,
    Parent = BtnContainer,
    Corner = 4,
})
ApplyBtn.MouseButton1Click:Connect(function()
    local ok, result = FFlagTool.Apply(FFlagInput.Text)
    if ok then
        Toast.Show("FFlag应用", "已应用 " .. result .. " 个", 2)
    else
        Toast.Show("FFlag错误", result, 2)
    end
end)

-- 保存按钮
local SaveBtn = Utils.Create("TextButton", {
    Size = UDim2.new(0, 100, 1, 0),
    BackgroundColor3 = Color3.fromRGB(33, 150, 243),
    BorderSizePixel = 0,
    Text = "保存当前",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 25,
    Parent = BtnContainer,
    Corner = 4,
})
SaveBtn.MouseButton1Click:Connect(function()
    if FFlagInput.Text ~= "" then
        FFlagTool.Save(FFlagInput.Text)
        Toast.Show("FFlag保存", "已保存", 2)
    else
        Toast.Show("保存失败", "没有内容", 1.5)
    end
end)

-- 加载按钮
local LoadBtn = Utils.Create("TextButton", {
    Size = UDim2.new(0, 100, 1, 0),
    BackgroundColor3 = C.Warning,
    BorderSizePixel = 0,
    Text = "加载上次",
    TextColor3 = Color3.fromRGB(20, 20, 25),
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 25,
    Parent = BtnContainer,
    Corner = 4,
})
LoadBtn.MouseButton1Click:Connect(function()
    local content = FFlagTool.Load()
    if content then
        FFlagInput.Text = content
        Toast.Show("FFlag加载", "已加载", 2)
    else
        Toast.Show("FFlag", "无保存文件", 2)
    end
end)

task.delay(0.3, function()
    local content = FFlagTool.Load()
    if content then FFlagInput.Text = content end
end)

-- ==================== 灵敏度标签页 ====================
local SensContent, SensList = CreateContentFrame()
SensContent.Visible = false
tabContents[Config.TabIDs[3]] = SensContent

local SensCard = Utils.Create("Frame", {
    Size = UDim2.new(1, 0, 0, 100),
    BackgroundColor3 = C.Element,
    BorderSizePixel = 0,
    ZIndex = 23,
    Parent = SensContent,
    Corner = 6,
})

Utils.Create("TextLabel", {
    Size = UDim2.new(0, 150, 0, 20),
    Position = UDim2.new(0, 14, 0, 12),
    BackgroundTransparency = 1,
    Text = "触摸灵敏度",
    TextColor3 = C.TextDim,
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 24,
    Parent = SensCard,
})

local SensValue = Utils.Create("TextLabel", {
    Size = UDim2.new(0, 60, 0, 20),
    Position = UDim2.new(1, -72, 0, 12),
    BackgroundTransparency = 1,
    Text = string.format("%.1f", SavedConfig.sensitivity),
    TextColor3 = C.Accent,
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Right,
    ZIndex = 24,
    Parent = SensCard,
})

local SensTrack = Utils.Create("Frame", {
    Size = UDim2.new(1, -24, 0, 8),
    Position = UDim2.new(0, 12, 0, 44),
    BackgroundColor3 = C.SliderTrack,
    BorderSizePixel = 0,
    ZIndex = 24,
    Parent = SensCard,
    Corner = 4,
})

local ratio = (SavedConfig.sensitivity - Config.SensitivityMin) / (Config.SensitivityMax - Config.SensitivityMin)
local SensFill = Utils.Create("Frame", {
    Size = UDim2.new(ratio, 0, 1, 0),
    BackgroundColor3 = C.SliderFill,
    BorderSizePixel = 0,
    ZIndex = 25,
    Parent = SensTrack,
    Corner = 4,
})

local SensHandle = Utils.Create("TextButton", {
    Size = UDim2.new(0, 20, 0, 20),
    Position = UDim2.new(ratio, -10, 0.5, -10),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0,
    Text = "",
    AutoButtonColor = false,
    ZIndex = 26,
    Parent = SensTrack,
    Corner = 10,
})
Utils.Create("UIStroke", { Color = C.Accent, Thickness = 2, Transparency = 0, Parent = SensHandle })

for i, preset in ipairs(Config.SensitivityPresets) do
    local btn = Utils.Create("TextButton", {
        Size = UDim2.new(0, 40, 0, 22),
        Position = UDim2.new(0, 10 + (i-1)*46, 0, 64),
        BackgroundColor3 = C.Base,
        BorderSizePixel = 0,
        Text = "x" .. string.format("%.1f", preset),
        TextColor3 = C.TextDim,
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false,
        ZIndex = 24,
        Parent = SensCard,
        Corner = 4,
    })
    btn.MouseEnter:Connect(function() Utils.Tween(btn, { BackgroundColor3 = C.Hover }, 0.15) end)
    btn.MouseLeave:Connect(function() Utils.Tween(btn, { BackgroundColor3 = C.Base }, 0.15) end)
    btn.MouseButton1Click:Connect(function() UpdateSensitivity(preset) end)
end

function UpdateSensitivity(value)
    local clamped = math.clamp(value, Config.SensitivityMin, Config.SensitivityMax)
    SavedConfig.sensitivity = clamped
    Sensitivity.Set(clamped)
    local r = (clamped - Config.SensitivityMin) / (Config.SensitivityMax - Config.SensitivityMin)
    SensFill.Size = UDim2.new(r, 0, 1, 0)
    SensHandle.Position = UDim2.new(r, -10, 0.5, -10)
    SensValue.Text = string.format("%.1f", clamped)
end

SensHandle.MouseButton1Down:Connect(function()
    sliderState.active = true
    sliderState.track = SensTrack
    sliderState.fill = SensFill
    sliderState.handle = SensHandle
    sliderState.valueLabel = SensValue
    sliderState.min = Config.SensitivityMin
    sliderState.max = Config.SensitivityMax
    sliderState.callback = function(v) UpdateSensitivity(v) end
end)

SensTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouseX = game:GetService("UserInputService"):GetMouseLocation().X
        local r = math.clamp((mouseX - SensTrack.AbsolutePosition.X) / SensTrack.AbsoluteSize.X, 0, 1)
        UpdateSensitivity(Config.SensitivityMin + (Config.SensitivityMax - Config.SensitivityMin) * r)
    end
end)

SensList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SensContent.CanvasSize = UDim2.new(0, 0, 0, SensList.AbsoluteContentSize.Y + 8)
end)

-- ==================== 饰品标签页 ====================
local AccContent, AccList = CreateContentFrame()
AccContent.Visible = false
tabContents[Config.TabIDs[4]] = AccContent

local slotConfig = Accessories.GetSlotConfig()
for _, config in ipairs(slotConfig) do
    local btn = Utils.Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(100, 180, 100),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 23,
        Parent = AccContent,
        Corner = 6,
    })
    local label = Utils.Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "显示: " .. config.name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        ZIndex = 24,
        Parent = btn,
    })
    
    local function updateBtn()
        local isVisible = Accessories.IsVisible(config.type)
        btn.BackgroundColor3 = isVisible and Color3.fromRGB(100, 180, 100) or Color3.fromRGB(180, 100, 100)
        label.Text = (isVisible and "显示: " or "隐藏: ") .. config.name
    end
    
    btn.MouseButton1Click:Connect(function()
        local nowVisible = Accessories.Toggle(config.type)
        updateBtn()
        Toast.Show(config.name, nowVisible and "已显示" or "已隐藏", 1.5)
    end)
    
    accessoryButtons[config.type] = { frame = btn, update = updateBtn }
    updateBtn()
end

AccList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    AccContent.CanvasSize = UDim2.new(0, 0, 0, AccList.AbsoluteContentSize.Y + 8)
end)

-- ==================== 设置标签页 ====================
local SettingsContent, SettingsList = CreateContentFrame()
SettingsContent.Visible = false
tabContents[Config.TabIDs[5]] = SettingsContent

local SizeCard = Utils.Create("Frame", {
    Size = UDim2.new(1, 0, 0, 160),
    BackgroundColor3 = C.Element,
    BorderSizePixel = 0,
    ZIndex = 23,
    Parent = SettingsContent,
    Corner = 6,
})

Utils.Create("TextLabel", {
    Size = UDim2.new(0, 150, 0, 20),
    Position = UDim2.new(0, 14, 0, 12),
    BackgroundTransparency = 1,
    Text = "自定义尺寸",
    TextColor3 = C.TextDim,
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    ZIndex = 24,
    Parent = SizeCard,
})

Utils.Create("TextLabel", {
    Size = UDim2.new(1, -28, 0, 16),
    Position = UDim2.new(0, 14, 0, 34),
    BackgroundTransparency = 1,
    Text = "屏幕: " .. ScreenW .. "x" .. ScreenH,
    TextColor3 = C.TextMuted,
    TextSize = 10,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 24,
    Parent = SizeCard,
})

Utils.Create("TextLabel", {
    Size = UDim2.new(0, 40, 0, 16),
    Position = UDim2.new(0, 14, 0, 56),
    BackgroundTransparency = 1,
    Text = "宽度",
    TextColor3 = C.TextDim,
    TextSize = 11,
    Font = Enum.Font.Gotham,
    ZIndex = 24,
    Parent = SizeCard,
})

local WInput = Utils.Create("TextBox", {
    Size = UDim2.new(0, 90, 0, 30),
    Position = UDim2.new(0, 60, 0, 52),
    BackgroundColor3 = C.Base,
    BorderSizePixel = 0,
    Text = tostring(SavedConfig.width),
    TextColor3 = C.Text,
    TextSize = 12,
    Font = Enum.Font.Gotham,
    ZIndex = 24,
    Parent = SizeCard,
    Corner = 4,
})

Utils.Create("TextLabel", {
    Size = UDim2.new(0, 40, 0, 16),
    Position = UDim2.new(0, 170, 0, 56),
    BackgroundTransparency = 1,
    Text = "高度",
    TextColor3 = C.TextDim,
    TextSize = 11,
    Font = Enum.Font.Gotham,
    ZIndex = 24,
    Parent = SizeCard,
})

local HInput = Utils.Create("TextBox", {
    Size = UDim2.new(0, 90, 0, 30),
    Position = UDim2.new(0, 210, 0, 52),
    BackgroundColor3 = C.Base,
    BorderSizePixel = 0,
    Text = tostring(SavedConfig.height),
    TextColor3 = C.Text,
    TextSize = 12,
    Font = Enum.Font.Gotham,
    ZIndex = 24,
    Parent = SizeCard,
    Corner = 4,
})

local function ApplySize()
    local w = math.clamp(tonumber(WInput.Text) or SavedConfig.width, D.MinWidth, D.MaxWidth)
    local h = math.clamp(tonumber(HInput.Text) or SavedConfig.height, D.MinHeight, D.MaxHeight)
    SavedConfig.width, SavedConfig.height = w, h
    WInput.Text, HInput.Text = tostring(w), tostring(h)
    Panel.Size = UDim2.new(0, w, 0, h)
    Panel.Position = UDim2.new(0.5, -w/2, 0.5, -h/2)
    SavedConfig.posX, SavedConfig.posY = nil, nil
    Toast.Show("尺寸应用", w .. " x " .. h, 1.5)
end

Utils.Create("TextButton", {
    Size = UDim2.new(0, 90, 0, 32),
    Position = UDim2.new(0, 14, 0, 92),
    BackgroundColor3 = C.Accent,
    BorderSizePixel = 0,
    Text = "应用尺寸",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 24,
    Parent = SizeCard,
    Corner = 4,
}).MouseButton1Click:Connect(ApplySize)

Utils.Create("TextButton", {
    Size = UDim2.new(0, 90, 0, 32),
    Position = UDim2.new(0, 112, 0, 92),
    BackgroundColor3 = C.Element,
    BorderSizePixel = 0,
    Text = "重置默认",
    TextColor3 = C.TextDim,
    TextSize = 12,
    Font = Enum.Font.Gotham,
    AutoButtonColor = false,
    ZIndex = 24,
    Parent = SizeCard,
    Corner = 4,
}).MouseButton1Click:Connect(function()
    SavedConfig.width, SavedConfig.height = defaultW, defaultH
    SavedConfig.posX, SavedConfig.posY = nil, nil
    WInput.Text, HInput.Text = tostring(defaultW), tostring(defaultH)
    Panel.Size = UDim2.new(0, defaultW, 0, defaultH)
    Panel.Position = GetDefaultPos()
    Toast.Show("尺寸重置", "已恢复默认", 1.5)
end)

SettingsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SettingsContent.CanvasSize = UDim2.new(0, 0, 0, SettingsList.AbsoluteContentSize.Y + 8)
end)

-- ==================== 公告弹窗 ====================
local NoticeOverlay = Utils.Create("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 100,
    Parent = Panel,
})

local NoticeModal = Utils.Create("Frame", {
    Size = UDim2.new(0, 320, 0, 240),
    Position = UDim2.new(0.5, -160, 0.5, -120),
    BackgroundColor3 = C.Panel,
    BorderSizePixel = 0,
    ZIndex = 101,
    Parent = NoticeOverlay,
    Corner = 10,
})
Utils.Create("UIStroke", { Color = C.Border, Thickness = 1, Transparency = 0.4, Parent = NoticeModal })

Utils.Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = C.Panel,
    BorderSizePixel = 0,
    Text = "系统公告",
    TextColor3 = C.Text,
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    ZIndex = 102,
    Parent = NoticeModal,
    Corner = 10,
})

local NClose = Utils.Create("TextButton", {
    Size = UDim2.new(0, 26, 0, 26),
    Position = UDim2.new(1, -34, 0, 7),
    BackgroundColor3 = C.Element,
    BorderSizePixel = 0,
    Text = "X",
    TextColor3 = C.TextDim,
    TextSize = 12,
    Font = Enum.Font.GothamMedium,
    AutoButtonColor = false,
    ZIndex = 103,
    Parent = NoticeModal,
    Corner = 13,
})

Utils.Create("TextLabel", {
    Size = UDim2.new(1, -24, 1, -60),
    Position = UDim2.new(0, 12, 0, 50),
    BackgroundTransparency = 1,
    Text = "控制面板 v4.0\n\nFPS监控按钮 | 点击打开菜单\n所有功能模块化设计\nGitHub: 你的仓库地址\n\n屏幕: " .. ScreenW .. "x" .. ScreenH,
    TextColor3 = C.TextDim,
    TextSize = 13,
    Font = Enum.Font.Gotham,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 102,
    Parent = NoticeModal,
})

NoticeBtn.MouseButton1Click:Connect(function()
    NoticeOverlay.Visible = true
    Utils.Tween(NoticeOverlay, { BackgroundTransparency = 0.5 }, 0.2)
end)

NClose.MouseButton1Click:Connect(function()
    local t = Utils.Tween(NoticeOverlay, { BackgroundTransparency = 1 }, 0.15)
    t.Completed:Connect(function() NoticeOverlay.Visible = false end)
end)

-- ==================== 打开/关闭 ====================
function OpenMenu()
    menuVisible = true
    Panel.Visible = true
    Panel.Position = GetSavedPos()
    Panel.Size = UDim2.new(0, 0, 0, 0)
    Utils.Tween(Panel, {
        Size = UDim2.new(0, SavedConfig.width, 0, SavedConfig.height),
    }, 0.3, Enum.EasingStyle.Quart)
    WInput.Text, HInput.Text = tostring(SavedConfig.width), tostring(SavedConfig.height)
    UpdateSensitivity(SavedConfig.sensitivity)
    for _, data in pairs(accessoryButtons) do data.update() end
end

function CloseMenu()
    menuVisible = false
    local t = Utils.Tween(Panel, { Size = UDim2.new(0, 0, 0, 0) }, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    t.Completed:Connect(function()
        if not menuVisible then Panel.Visible = false end
    end)
end

-- ==================== 拖动系统 ====================
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragState.active = true
        dragState.startMouse = game:GetService("UserInputService"):GetMouseLocation()
        dragState.startPos = Vector2.new(Panel.AbsolutePosition.X, Panel.AbsolutePosition.Y)
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragState.active and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mouse = game:GetService("UserInputService"):GetMouseLocation()
        local delta = mouse - dragState.startMouse
        local newX = math.clamp(dragState.startPos.X + delta.X, 0, ScreenW - Panel.AbsoluteSize.X)
        local newY = math.clamp(dragState.startPos.Y + delta.Y, 0, ScreenH - 40)
        Panel.Position = UDim2.new(0, newX, 0, newY)
        SavedConfig.posX, SavedConfig.posY = newX, newY
    end
    
    if sliderState.active and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mouseX = game:GetService("UserInputService"):GetMouseLocation().X
        local r = math.clamp((mouseX - sliderState.track.AbsolutePosition.X) / sliderState.track.AbsoluteSize.X, 0, 1)
        local v = sliderState.min + (sliderState.max - sliderState.min) * r
        sliderState.fill.Size = UDim2.new(r, 0, 1, 0)
        sliderState.handle.Position = UDim2.new(r, -10, 0.5, -10)
        sliderState.valueLabel.Text = string.format("%.1f", v)
        if sliderState.callback then sliderState.callback(v) end
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragState.active = false
        sliderState.active = false
    end
end)

CloseBtn.MouseButton1Click:Connect(CloseMenu)

-- 点击外部关闭
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and menuVisible and not dragState.active and not sliderState.active then
        local pos = game:GetService("UserInputService"):GetMouseLocation()
        local objs = PlayerGui:GetGuiObjectsAtPosition(pos.X, pos.Y)
        local inside = false
        for _, obj in ipairs(objs) do
            if obj == Panel or obj:IsDescendantOf(Panel) or obj == perfDrag or obj:IsDescendantOf(perfDrag) then
                inside = true
                break
            end
        end
        if not inside then CloseMenu() end
    end
end)

-- ==================== 完成 ====================
print("============================================")
print("  Universal UI v4.0 - Modular")
print("  Screen: " .. ScreenW .. "x" .. ScreenH)
print("  Modules loaded: " .. #Config.TabIDs .. " tabs")
print("============================================")