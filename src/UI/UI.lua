getgenv().SnowUI = getgenv().SnowUI or {}
local M = getgenv().SnowUI

local function BuildUI(container)
    local Config, Utils = M.Config, M.Utils
    local C, D = Config.Colors, Config.Defaults
    local Camera = workspace.CurrentCamera
    local SW, SH = Camera.ViewportSize.X, Camera.ViewportSize.Y
    local dW = math.clamp(math.floor(SW*0.45), D.MinWidth, D.MaxWidth)
    local dH = math.clamp(math.floor(SH*0.55), D.MinHeight, D.MaxHeight)
    
    local SavedConfig = {width=dW, height=dH, posX=nil, posY=nil, sensitivity=D.Sensitivity}
    local menuVisible, currentTab = false, Config.TabIDs[1]
    local dragState = {active=false, startMouse=Vector2.zero, startPos=Vector2.zero}
    local sliderState = {active=false}
    local tabBtns, tabFrames = {}, {}
    
    local function GetDefaultPos() return UDim2.new(0.5, -SavedConfig.width/2, 0.5, -SavedConfig.height/2) end
    local function GetSavedPos() return SavedConfig.posX and UDim2.new(0, SavedConfig.posX, 0, SavedConfig.posY) or GetDefaultPos() end
    local function SwitchTab(id)
        if currentTab == id then return end; currentTab = id
        for tid, btn in pairs(tabBtns) do Utils.Tween(btn, {BackgroundColor3=tid==id and C.Active or C.Panel, TextColor3=tid==id and C.Text or C.TextDim}) end
        for tid, frame in pairs(tabFrames) do frame.Visible = (tid == id) end
    end
    
    local Panel = Instance.new("Frame"); Panel.Size=UDim2.new(0,SavedConfig.width,0,SavedConfig.height); Panel.Position=GetSavedPos(); Panel.BackgroundColor3=C.Base; Panel.BorderSizePixel=0; Panel.Visible=false; Panel.ZIndex=20; Panel.Parent=container
    local pc=Instance.new("UICorner"); pc.CornerRadius=UDim.new(0,10); pc.Parent=Panel
    local ps=Instance.new("UIStroke"); ps.Color=C.Border; ps.Thickness=1; ps.Transparency=0.4; ps.Parent=Panel
    
    local TitleBar = Instance.new("Frame"); TitleBar.Size=UDim2.new(1,0,0,40); TitleBar.BackgroundColor3=C.Panel; TitleBar.BorderSizePixel=0; TitleBar.ZIndex=21; TitleBar.Parent=Panel
    local tc=Instance.new("UICorner"); tc.CornerRadius=UDim.new(0,10); tc.Parent=TitleBar
    local tbFix=Instance.new("Frame"); tbFix.Size=UDim2.new(1,0,0.5,0); tbFix.Position=UDim2.new(0,0,0.5,0); tbFix.BackgroundColor3=C.Panel; tbFix.BorderSizePixel=0; tbFix.ZIndex=21; tbFix.Parent=TitleBar
    local tl=Instance.new("TextLabel"); tl.Size=UDim2.new(0,120,0,20); tl.Position=UDim2.new(0,14,0.5,-10); tl.BackgroundTransparency=1; tl.Text="控制面板"; tl.TextColor3=C.Text; tl.TextSize=14; tl.Font=Enum.Font.GothamBold; tl.TextXAlignment=Enum.TextXAlignment.Left; tl.ZIndex=22; tl.Parent=TitleBar
    local NoticeBtn = Instance.new("TextButton"); NoticeBtn.Size=UDim2.new(0,56,0,26); NoticeBtn.Position=UDim2.new(1,-124,0.5,-13); NoticeBtn.BackgroundColor3=C.Warning; NoticeBtn.BorderSizePixel=0; NoticeBtn.Text="公告"; NoticeBtn.TextColor3=Color3.fromRGB(20,20,25); NoticeBtn.TextSize=12; NoticeBtn.Font=Enum.Font.GothamBold; NoticeBtn.AutoButtonColor=false; NoticeBtn.ZIndex=22; NoticeBtn.Parent=TitleBar
    local nc=Instance.new("UICorner"); nc.CornerRadius=UDim.new(0,6); nc.Parent=NoticeBtn
    local CloseBtn = Instance.new("TextButton"); CloseBtn.Size=UDim2.new(0,28,0,28); CloseBtn.Position=UDim2.new(1,-38,0.5,-14); CloseBtn.BackgroundColor3=C.Element; CloseBtn.BorderSizePixel=0; CloseBtn.Text="X"; CloseBtn.TextColor3=C.TextDim; CloseBtn.TextSize=14; CloseBtn.Font=Enum.Font.GothamMedium; CloseBtn.AutoButtonColor=false; CloseBtn.ZIndex=22; CloseBtn.Parent=TitleBar
    local clc=Instance.new("UICorner"); clc.CornerRadius=UDim.new(0,14); clc.Parent=CloseBtn
    CloseBtn.MouseEnter:Connect(function() Utils.Tween(CloseBtn,{BackgroundColor3=C.Danger},0.15) end)
    CloseBtn.MouseLeave:Connect(function() Utils.Tween(CloseBtn,{BackgroundColor3=C.Element},0.15) end)
    
    local TabBar = Instance.new("Frame"); TabBar.Size=UDim2.new(1,0,0,42); TabBar.Position=UDim2.new(0,0,0,40); TabBar.BackgroundColor3=C.Panel; TabBar.BorderSizePixel=0; TabBar.ZIndex=21; TabBar.Parent=Panel
    local tabDiv=Instance.new("Frame"); tabDiv.Size=UDim2.new(1,0,0,1); tabDiv.Position=UDim2.new(0,0,1,-1); tabDiv.BackgroundColor3=C.Border; tabDiv.BorderSizePixel=0; tabDiv.ZIndex=22; tabDiv.Parent=TabBar
    local TabContainer = Instance.new("Frame"); TabContainer.Size=UDim2.new(0,0,1,0); TabContainer.Position=UDim2.new(0,14,0,0); TabContainer.BackgroundTransparency=1; TabContainer.ZIndex=22; TabContainer.Parent=TabBar
    local tabLayout=Instance.new("UIListLayout"); tabLayout.FillDirection=Enum.FillDirection.Horizontal; tabLayout.SortOrder=Enum.SortOrder.LayoutOrder; tabLayout.Padding=UDim.new(0,6); tabLayout.VerticalAlignment=Enum.VerticalAlignment.Center; tabLayout.Parent=TabContainer
    local ContentArea = Instance.new("Frame"); ContentArea.Size=UDim2.new(1,0,1,-82); ContentArea.Position=UDim2.new(0,0,0,82); ContentArea.BackgroundColor3=C.Base; ContentArea.BorderSizePixel=0; ContentArea.ZIndex=21; ContentArea.ClipsDescendants=true; ContentArea.Parent=Panel
    
    for i, id in ipairs(Config.TabIDs) do
        local btn = Instance.new("TextButton"); btn.Size=UDim2.new(0,60,0,32); btn.BackgroundColor3=i==1 and C.Active or C.Panel; btn.BorderSizePixel=0; btn.Text=Config.TabNames[i]; btn.TextColor3=i==1 and C.Text or C.TextDim; btn.TextSize=13; btn.Font=Enum.Font.GothamMedium; btn.AutoButtonColor=false; btn.ZIndex=22; btn.Parent=TabContainer
        local bc=Instance.new("UICorner"); bc.CornerRadius=UDim.new(0,6); bc.Parent=btn
        btn.MouseEnter:Connect(function() if id~=currentTab then Utils.Tween(btn,{BackgroundColor3=C.Hover},0.15) end end)
        btn.MouseLeave:Connect(function() if id~=currentTab then Utils.Tween(btn,{BackgroundColor3=C.Panel},0.15) end end)
        btn.MouseButton1Click:Connect(function() SwitchTab(id) end)
        tabBtns[id] = btn
    end
    
    local TabsModule = M.Tabs
    local tabs = {}
    
    local normalFrame = Instance.new("Frame"); normalFrame.Size=UDim2.new(1,0,1,0); normalFrame.BackgroundTransparency=1; normalFrame.Visible=true; normalFrame.ZIndex=22; normalFrame.Parent=ContentArea; tabFrames["normal"]=normalFrame
    tabs.functions = TabsModule.Functions.Create(normalFrame, C, Utils, M.Toast, M.Headless, M.BrokenLegs, M.Graphics, SwitchTab)
    tabs.functions.createContentFrame(normalFrame); tabs.functions.populate()
    
    local ffFrame = Instance.new("Frame"); ffFrame.Size=UDim2.new(1,0,1,0); ffFrame.BackgroundTransparency=1; ffFrame.Visible=false; ffFrame.ZIndex=22; ffFrame.Parent=ContentArea; tabFrames["ff"]=ffFrame
    tabs.fflag = TabsModule.FFlag.Create(ffFrame, C, Utils, M.Toast, M.FFlagTool)
    tabs.fflag.createContentFrame(ffFrame); tabs.fflag.populate()
    
    local sensFrame = Instance.new("Frame"); sensFrame.Size=UDim2.new(1,0,1,0); sensFrame.BackgroundTransparency=1; sensFrame.Visible=false; sensFrame.ZIndex=22; sensFrame.Parent=ContentArea; tabFrames["sensitivity"]=sensFrame
    tabs.sensitivity = TabsModule.Sensitivity.Create(sensFrame, C, Utils, Config, M.Sensitivity, SavedConfig, sliderState)
    tabs.sensitivity.createContentFrame(sensFrame); tabs.sensitivity.populate()
    
    local accFrame = Instance.new("Frame"); accFrame.Size=UDim2.new(1,0,1,0); accFrame.BackgroundTransparency=1; accFrame.Visible=false; accFrame.ZIndex=22; accFrame.Parent=ContentArea; tabFrames["accessories"]=accFrame
    tabs.accessories = TabsModule.Accessories.Create(accFrame, C, Utils, M.Toast, M.Accessories)
    tabs.accessories.createContentFrame(accFrame); tabs.accessories.populate()
    
    local setFrame = Instance.new("Frame"); setFrame.Size=UDim2.new(1,0,1,0); setFrame.BackgroundTransparency=1; setFrame.Visible=false; setFrame.ZIndex=22; setFrame.Parent=ContentArea; tabFrames["settings"]=setFrame
    tabs.settings = TabsModule.Settings.Create(setFrame, C, Utils, M.Toast, D, SavedConfig, Panel, GetDefaultPos)
    tabs.settings.createContentFrame(setFrame); tabs.settings.populate()
    
    local notice = M.Notice.Create(Panel, C, Utils)
    NoticeBtn.MouseButton1Click:Connect(function() notice.setText("Snow UI v4.0\n\nFPS按钮点击打开菜单\n标题栏拖动移动\n\n屏幕: "..SW.."x"..SH); notice.show() end)
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragState.active=true; dragState.startMouse=game:GetService("UserInputService"):GetMouseLocation(); dragState.startPos=Vector2.new(Panel.AbsolutePosition.X,Panel.AbsolutePosition.Y)
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragState.active and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local mouse=game:GetService("UserInputService"):GetMouseLocation(); local delta=mouse-dragState.startMouse
            Panel.Position=UDim2.new(0,math.clamp(dragState.startPos.X+delta.X,0,SW-Panel.AbsoluteSize.X),0,math.clamp(dragState.startPos.Y+delta.Y,0,SH-40))
            SavedConfig.posX,SavedConfig.posY=Panel.AbsolutePosition.X,Panel.AbsolutePosition.Y
        end
        if sliderState.active and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local mx=game:GetService("UserInputService"):GetMouseLocation().X; local r=math.clamp((mx-sliderState.track.AbsolutePosition.X)/sliderState.track.AbsoluteSize.X,0,1)
            local v=sliderState.min+(sliderState.max-sliderState.min)*r
            sliderState.fill.Size=UDim2.new(r,0,1,0); sliderState.handle.Position=UDim2.new(r,-10,0.5,-10); sliderState.valueLabel.Text=string.format("%.1f",v)
            if sliderState.callback then sliderState.callback(v) end
        end
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragState.active=false; sliderState.active=false end
    end)
    
    return {
        Panel=Panel, CloseBtn=CloseBtn, SavedConfig=SavedConfig, SwitchTab=SwitchTab,
        Open=function() menuVisible=true; Panel.Visible=true; Panel.Position=GetSavedPos(); Panel.Size=UDim2.new(0,0,0,0); Utils.Tween(Panel,{Size=UDim2.new(0,SavedConfig.width,0,SavedConfig.height)},0.3,Enum.EasingStyle.Quart); tabs.sensitivity.update(SavedConfig.sensitivity); tabs.accessories.refreshAll(); tabs.settings.updateInputs() end,
        Close=function() menuVisible=false; local t=Utils.Tween(Panel,{Size=UDim2.new(0,0,0,0)},0.2,Enum.EasingStyle.Quart,Enum.EasingDirection.In); t.Completed:Connect(function() if not menuVisible then Panel.Visible=false end end) end,
        IsVisible=function() return menuVisible end,
    }
end
getgenv().SnowUI.Build = BuildUI