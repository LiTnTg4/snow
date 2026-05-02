getgenv().SnowUI = getgenv().SnowUI or {}
local M = getgenv().SnowUI

local function BuildUI(container)
    local Config = M.Config
    local Utils = M.Utils
    local C = Config.Colors
    local D = Config.Defaults
    
    local Camera = workspace.CurrentCamera
    local ScreenW = Camera.ViewportSize.X
    local ScreenH = Camera.ViewportSize.Y
    local defaultW = math.clamp(math.floor(ScreenW * 0.45), D.MinWidth, D.MaxWidth)
    local defaultH = math.clamp(math.floor(ScreenH * 0.55), D.MinHeight, D.MaxHeight)
    
    local SavedConfig = {
        width = defaultW, height = defaultH,
        posX = nil, posY = nil,
        sensitivity = D.Sensitivity,
    }
    
    local menuVisible = false
    local dragState = {active=false, startMouse=Vector2.zero, startPos=Vector2.zero}
    local sliderState = {active=false}
    local currentTab = Config.TabIDs[1]
    local tabBtns = {}
    local tabContents = {}
    
    local function GetDefaultPos()
        return UDim2.new(0.5, -SavedConfig.width/2, 0.5, -SavedConfig.height/2)
    end
    local function GetSavedPos()
        return SavedConfig.posX and UDim2.new(0, SavedConfig.posX, 0, SavedConfig.posY) or GetDefaultPos()
    end
    
    local function SwitchTab(id)
        if currentTab == id then return end
        currentTab = id
        for tid, btn in pairs(tabBtns) do
            Utils.Tween(btn, {BackgroundColor3 = tid==id and C.Active or C.Panel, TextColor3 = tid==id and C.Text or C.TextDim})
        end
        for tid, content in pairs(tabContents) do content.Visible = (tid == id) end
    end
    
    -- 主面板
    local Panel = Instance.new("Frame")
    Panel.Size = UDim2.new(0, SavedConfig.width, 0, SavedConfig.height)
    Panel.Position = GetSavedPos()
    Panel.BackgroundColor3 = C.Base
    Panel.BorderSizePixel = 0
    Panel.Visible = false
    Panel.ZIndex = 20
    Panel.Parent = container
    local pc = Instance.new("UICorner"); pc.CornerRadius = UDim.new(0, 10); pc.Parent = Panel
    
    local ps = Instance.new("UIStroke")
    ps.Color = C.Border; ps.Thickness = 1; ps.Transparency = 0.4; ps.Parent = Panel
    
    -- 标题栏
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = C.Panel
    TitleBar.BorderSizePixel = 0
    TitleBar.ZIndex = 21
    TitleBar.Parent = Panel
    local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(0, 10); tc.Parent = TitleBar
    
    local tbFix = Instance.new("Frame")
    tbFix.Size = UDim2.new(1, 0, 0.5, 0)
    tbFix.Position = UDim2.new(0, 0, 0.5, 0)
    tbFix.BackgroundColor3 = C.Panel
    tbFix.BorderSizePixel = 0
    tbFix.ZIndex = 21
    tbFix.Parent = TitleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 120, 0, 20)
    titleLabel.Position = UDim2.new(0, 14, 0.5, -10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "控制面板"
    titleLabel.TextColor3 = C.Text
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 22
    titleLabel.Parent = TitleBar
    
    local NoticeBtn = Instance.new("TextButton")
    NoticeBtn.Size = UDim2.new(0, 56, 0, 26)
    NoticeBtn.Position = UDim2.new(1, -124, 0.5, -13)
    NoticeBtn.BackgroundColor3 = C.Warning
    NoticeBtn.BorderSizePixel = 0
    NoticeBtn.Text = "公告"
    NoticeBtn.TextColor3 = Color3.fromRGB(20, 20, 25)
    NoticeBtn.TextSize = 12
    NoticeBtn.Font = Enum.Font.GothamBold
    NoticeBtn.AutoButtonColor = false
    NoticeBtn.ZIndex = 22
    NoticeBtn.Parent = TitleBar
    local nc = Instance.new("UICorner"); nc.CornerRadius = UDim.new(0, 6); nc.Parent = NoticeBtn
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -38, 0.5, -14)
    CloseBtn.BackgroundColor3 = C.Element
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = C.TextDim
    CloseBtn.TextSize = 14
    CloseBtn.Font = Enum.Font.GothamMedium
    CloseBtn.AutoButtonColor = false
    CloseBtn.ZIndex = 22
    CloseBtn.Parent = TitleBar
    local clc = Instance.new("UICorner"); clc.CornerRadius = UDim.new(0, 14); clc.Parent = CloseBtn
    
    CloseBtn.MouseEnter:Connect(function() Utils.Tween(CloseBtn, {BackgroundColor3=C.Danger}, 0.15) end)
    CloseBtn.MouseLeave:Connect(function() Utils.Tween(CloseBtn, {BackgroundColor3=C.Element}, 0.15) end)
    
    -- 标签栏
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, 0, 0, 42)
    TabBar.Position = UDim2.new(0, 0, 0, 40)
    TabBar.BackgroundColor3 = C.Panel
    TabBar.BorderSizePixel = 0
    TabBar.ZIndex = 21
    TabBar.Parent = Panel
    
    local tabDiv = Instance.new("Frame")
    tabDiv.Size = UDim2.new(1, 0, 0, 1)
    tabDiv.Position = UDim2.new(0, 0, 1, -1)
    tabDiv.BackgroundColor3 = C.Border
    tabDiv.BorderSizePixel = 0
    tabDiv.ZIndex = 22
    tabDiv.Parent = TabBar
    
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, 0, 1, 0)
    TabContainer.Position = UDim2.new(0, 14, 0, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ZIndex = 22
    TabContainer.Parent = TabBar
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Parent = TabContainer
    
    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, 0, 1, -82)
    ContentArea.Position = UDim2.new(0, 0, 0, 82)
    ContentArea.BackgroundColor3 = C.Base
    ContentArea.BorderSizePixel = 0
    ContentArea.ZIndex = 21
    ContentArea.Parent = Panel
    
    -- 标签按钮 - 全部用Instance.new确保类型正确
    for i, id in ipairs(Config.TabIDs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 60, 0, 32)
        btn.BackgroundColor3 = i == 1 and C.Active or C.Panel
        btn.BorderSizePixel = 0
        btn.Text = Config.TabNames[i]
        btn.TextColor3 = i == 1 and C.Text or C.TextDim
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamMedium
        btn.AutoButtonColor = false
        btn.ZIndex = 22
        btn.Parent = TabContainer
        local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 6); bc.Parent = btn
        
        btn.MouseEnter:Connect(function() if id~=currentTab then Utils.Tween(btn,{BackgroundColor3=C.Hover},0.15) end end)
        btn.MouseLeave:Connect(function() if id~=currentTab then Utils.Tween(btn,{BackgroundColor3=C.Panel},0.15) end end)
        btn.MouseButton1Click:Connect(function() SwitchTab(id) end)
        tabBtns[id] = btn
    end
    
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.Size = UDim2.new(0, tabLayout.AbsoluteContentSize.X, 1, 0)
    end)
    
    -- 加载标签页
    local tabs = {}
    local TabsModule = M.Tabs
    
    tabs.functions = TabsModule.Functions.Create(ContentArea, C, Utils, M.Toast, M.Headless, M.BrokenLegs, M.Graphics, SwitchTab)
    tabs.functions.createContentFrame(ContentArea); tabs.functions.populate()
    
    tabs.fflag = TabsModule.FFlag.Create(ContentArea, C, Utils, M.Toast, M.FFlagTool)
    tabs.fflag.createContentFrame(ContentArea); tabs.fflag.populate()
    
    tabs.sensitivity = TabsModule.Sensitivity.Create(ContentArea, C, Utils, Config, M.Sensitivity, SavedConfig, sliderState)
    tabs.sensitivity.createContentFrame(ContentArea); tabs.sensitivity.populate()
    
    tabs.accessories = TabsModule.Accessories.Create(ContentArea, C, Utils, M.Toast, M.Accessories)
    tabs.accessories.createContentFrame(ContentArea); tabs.accessories.populate()
    
    tabs.settings = TabsModule.Settings.Create(ContentArea, C, Utils, M.Toast, D, SavedConfig, Panel, GetDefaultPos)
    tabs.settings.createContentFrame(ContentArea); tabs.settings.populate()
    
    -- 公告
    local notice = M.Notice.Create(Panel, C, Utils)
    NoticeBtn.MouseButton1Click:Connect(function()
        notice.setText("Snow UI v4.0\n\nFPS按钮点击打开菜单\n标题栏拖动移动\n模块化设计\n\n屏幕: "..ScreenW.."x"..ScreenH)
        notice.show()
    end)
    
    -- 拖动
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragState.active=true
            dragState.startMouse=game:GetService("UserInputService"):GetMouseLocation()
            dragState.startPos=Vector2.new(Panel.AbsolutePosition.X,Panel.AbsolutePosition.Y)
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragState.active and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local mouse=game:GetService("UserInputService"):GetMouseLocation()
            local delta=mouse-dragState.startMouse
            local nx=math.clamp(dragState.startPos.X+delta.X,0,ScreenW-Panel.AbsoluteSize.X)
            local ny=math.clamp(dragState.startPos.Y+delta.Y,0,ScreenH-40)
            Panel.Position=UDim2.new(0,nx,0,ny)
            SavedConfig.posX,SavedConfig.posY=nx,ny
        end
        if sliderState.active and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local mx=game:GetService("UserInputService"):GetMouseLocation().X
            local r=math.clamp((mx-sliderState.track.AbsolutePosition.X)/sliderState.track.AbsoluteSize.X,0,1)
            local v=sliderState.min+(sliderState.max-sliderState.min)*r
            sliderState.fill.Size=UDim2.new(r,0,1,0)
            sliderState.handle.Position=UDim2.new(r,-10,0.5,-10)
            sliderState.valueLabel.Text=string.format("%.1f",v)
            if sliderState.callback then sliderState.callback(v) end
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragState.active=false; sliderState.active=false
        end
    end)
    
    return {
        Panel=Panel, CloseBtn=CloseBtn, SavedConfig=SavedConfig, SwitchTab=SwitchTab,
        Open=function()
            menuVisible=true; Panel.Visible=true
            Panel.Position=GetSavedPos(); Panel.Size=UDim2.new(0,0,0,0)
            Utils.Tween(Panel,{Size=UDim2.new(0,SavedConfig.width,0,SavedConfig.height)},0.3,Enum.EasingStyle.Quart)
            tabs.sensitivity.update(SavedConfig.sensitivity)
            tabs.accessories.refreshAll(); tabs.settings.updateInputs()
        end,
        Close=function()
            menuVisible=false
            local t=Utils.Tween(Panel,{Size=UDim2.new(0,0,0,0)},0.2,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
            t.Completed:Connect(function() if not menuVisible then Panel.Visible=false end end)
        end,
        IsVisible=function() return menuVisible end,
    }
end

getgenv().SnowUI.Build = BuildUI