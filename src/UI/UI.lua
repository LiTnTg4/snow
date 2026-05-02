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
    local Panel = Utils.Create("Frame", {
        Size=UDim2.new(0,SavedConfig.width,0,SavedConfig.height),Position=GetSavedPos(),
        BackgroundColor3=C.Base,BorderSizePixel=0,Visible=false,ZIndex=20,Parent=container,Corner=10,
    })
    Utils.Create("UIStroke", {Color=C.Border,Thickness=1,Transparency=0.4,Parent=Panel})
    
    -- 标题栏
    local TitleBar = Utils.Create("Frame", {
        Size=UDim2.new(1,0,0,40),BackgroundColor3=C.Panel,BorderSizePixel=0,ZIndex=21,Parent=Panel,Corner=10,
    })
    Utils.Create("Frame", {Size=UDim2.new(1,0,0.5,0),Position=UDim2.new(0,0,0.5,0),BackgroundColor3=C.Panel,BorderSizePixel=0,ZIndex=21,Parent=TitleBar})
    Utils.Create("TextLabel", {Size=UDim2.new(0,120,0,20),Position=UDim2.new(0,14,0.5,-10),BackgroundTransparency=1,Text="控制面板",TextColor3=C.Text,TextSize=14,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=22,Parent=TitleBar})
    
    local NoticeBtn = Utils.Create("TextButton", {Size=UDim2.new(0,56,0,26),Position=UDim2.new(1,-124,0.5,-13),BackgroundColor3=C.Warning,BorderSizePixel=0,Text="公告",TextColor3=Color3.fromRGB(20,20,25),TextSize=12,Font=Enum.Font.GothamBold,AutoButtonColor=false,ZIndex=22,Parent=TitleBar,Corner=6})
    local CloseBtn = Utils.Create("TextButton", {Size=UDim2.new(0,28,0,28),Position=UDim2.new(1,-38,0.5,-14),BackgroundColor3=C.Element,BorderSizePixel=0,Text="X",TextColor3=C.TextDim,TextSize=14,Font=Enum.Font.GothamMedium,AutoButtonColor=false,ZIndex=22,Parent=TitleBar,Corner=14})
    CloseBtn.MouseEnter:Connect(function() Utils.Tween(CloseBtn,{BackgroundColor3=C.Danger},0.15) end)
    CloseBtn.MouseLeave:Connect(function() Utils.Tween(CloseBtn,{BackgroundColor3=C.Element},0.15) end)
    
    -- 标签栏
    local TabBar = Utils.Create("Frame", {Size=UDim2.new(1,0,0,42),Position=UDim2.new(0,0,0,40),BackgroundColor3=C.Panel,BorderSizePixel=0,ZIndex=21,Parent=Panel})
    Utils.Create("Frame", {Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundColor3=C.Border,BorderSizePixel=0,ZIndex=22,Parent=TabBar})
    local TabContainer = Utils.Create("Frame", {Size=UDim2.new(0,0,1,0),Position=UDim2.new(0,14,0,0),BackgroundTransparency=1,ZIndex=22,Parent=TabBar})
    Utils.Create("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6),VerticalAlignment=Enum.VerticalAlignment.Center,Parent=TabContainer})
    
    local ContentArea = Utils.Create("Frame", {Size=UDim2.new(1,0,1,-82),Position=UDim2.new(0,0,0,82),BackgroundColor3=C.Base,BorderSizePixel=0,ZIndex=21,Parent=Panel})
    
    -- 标签按钮
    for i, id in ipairs(Config.TabIDs) do
        local btn = Utils.Create("TextButton", {
            Size=UDim2.new(0,60,0,32),BackgroundColor3=i==1 and C.Active or C.Panel,BorderSizePixel=0,
            Text=Config.TabNames[i],TextColor3=i==1 and C.Text or C.TextDim,TextSize=13,
            Font=Enum.Font.GothamMedium,AutoButtonColor=false,ZIndex=22,Parent=TabContainer,Corner=6,
        })
        btn.MouseEnter:Connect(function() if id~=currentTab then Utils.Tween(btn,{BackgroundColor3=C.Hover},0.15) end end)
        btn.MouseLeave:Connect(function() if id~=currentTab then Utils.Tween(btn,{BackgroundColor3=C.Panel},0.15) end end)
        btn.MouseButton1Click:Connect(function() SwitchTab(id) end)
        tabBtns[id] = btn
    end
    
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
        notice.setText("Snow UI v4.0\n\n模块化设计\n按住标题栏拖动\nFPS按钮点击打开\n\n屏幕: "..ScreenW.."x"..ScreenH)
        notice.show()
    end)
    
    -- 拖动
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragState.active=true; dragState.startMouse=game:GetService("UserInputService"):GetMouseLocation()
            dragState.startPos=Vector2.new(Panel.AbsolutePosition.X,Panel.AbsolutePosition.Y)
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragState.active and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local mouse=game:GetService("UserInputService"):GetMouseLocation()
            local delta=mouse-dragState.startMouse
            local nx=math.clamp(dragState.startPos.X+delta.X,0,ScreenW-Panel.AbsoluteSize.X)
            local ny=math.clamp(dragState.startPos.Y+delta.Y,0,ScreenH-40)
            Panel.Position=UDim2.new(0,nx,0,ny); SavedConfig.posX,SavedConfig.posY=nx,ny
        end
        if sliderState.active and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local mx=game:GetService("UserInputService"):GetMouseLocation().X
            local r=math.clamp((mx-sliderState.track.AbsolutePosition.X)/sliderState.track.AbsoluteSize.X,0,1)
            local v=sliderState.min+(sliderState.max-sliderState.min)*r
            sliderState.fill.Size=UDim2.new(r,0,1,0); sliderState.handle.Position=UDim2.new(r,-10,0.5,-10)
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
        Panel=Panel,CloseBtn=CloseBtn,SavedConfig=SavedConfig,SwitchTab=SwitchTab,
        Open=function()
            menuVisible=true; Panel.Visible=true; Panel.Position=GetSavedPos(); Panel.Size=UDim2.new(0,0,0,0)
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