getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.Tabs = getgenv().SnowUI.Tabs or {}
local ST = {}
getgenv().SnowUI.Tabs.Sensitivity = ST

function ST.Create(parent, Colors, Utils, Config, Sensitivity, SavedConfig, sliderState)
    local scrollFrame
    local SensFill, SensHandle, SensValue, SensTrack
    
    local function createContentFrame(contentArea)
        scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, -16, 1, -16)
        scrollFrame.Position = UDim2.new(0, 8, 0, 8)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.BorderSizePixel = 0
        scrollFrame.ScrollBarThickness = 3
        scrollFrame.ScrollBarImageColor3 = Colors.Element
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollFrame.ZIndex = 22
        scrollFrame.Parent = contentArea
        
        local list = Instance.new("UIListLayout")
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Padding = UDim.new(0, 8)
        list.Parent = scrollFrame
        
        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 4)
        pad.PaddingLeft = UDim.new(0, 4)
        pad.PaddingRight = UDim.new(0, 4)
        pad.PaddingBottom = UDim.new(0, 4)
        pad.Parent = scrollFrame
        
        list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            pcall(function()
                scrollFrame.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 8)
            end)
        end)
    end
    
    local function UpdateSensitivity(value)
        local clamped = math.clamp(value, Config.SensitivityMin, Config.SensitivityMax)
        SavedConfig.sensitivity = clamped
        Sensitivity.Set(clamped)
        local r = (clamped - Config.SensitivityMin) / (Config.SensitivityMax - Config.SensitivityMin)
        if SensFill then SensFill.Size = UDim2.new(r, 0, 1, 0) end
        if SensHandle then SensHandle.Position = UDim2.new(r, -10, 0.5, -10) end
        if SensValue then SensValue.Text = string.format("%.1f", clamped) end
    end
    
    local function populate()
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 100)
        card.BackgroundColor3 = Colors.Element
        card.BorderSizePixel = 0
        card.ZIndex = 23
        card.Parent = scrollFrame
        local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 6); cc.Parent = card
        
        local tl = Instance.new("TextLabel")
        tl.Size = UDim2.new(0, 150, 0, 20)
        tl.Position = UDim2.new(0, 14, 0, 12)
        tl.BackgroundTransparency = 1
        tl.Text = "触摸灵敏度"
        tl.TextColor3 = Colors.TextDim
        tl.TextSize = 13
        tl.Font = Enum.Font.GothamBold
        tl.TextXAlignment = Enum.TextXAlignment.Left
        tl.ZIndex = 24
        tl.Parent = card
        
        SensValue = Instance.new("TextLabel")
        SensValue.Size = UDim2.new(0, 60, 0, 20)
        SensValue.Position = UDim2.new(1, -72, 0, 12)
        SensValue.BackgroundTransparency = 1
        SensValue.Text = string.format("%.1f", SavedConfig.sensitivity)
        SensValue.TextColor3 = Colors.Accent
        SensValue.TextSize = 14
        SensValue.Font = Enum.Font.GothamBold
        SensValue.TextXAlignment = Enum.TextXAlignment.Right
        SensValue.ZIndex = 24
        SensValue.Parent = card
        
        SensTrack = Instance.new("Frame")
        SensTrack.Size = UDim2.new(1, -24, 0, 8)
        SensTrack.Position = UDim2.new(0, 12, 0, 44)
        SensTrack.BackgroundColor3 = Colors.SliderTrack
        SensTrack.BorderSizePixel = 0
        SensTrack.ZIndex = 24
        SensTrack.Parent = card
        local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(0, 4); sc.Parent = SensTrack
        
        local ratio = (SavedConfig.sensitivity - Config.SensitivityMin) / (Config.SensitivityMax - Config.SensitivityMin)
        SensFill = Instance.new("Frame")
        SensFill.Size = UDim2.new(ratio, 0, 1, 0)
        SensFill.BackgroundColor3 = Colors.SliderFill
        SensFill.BorderSizePixel = 0
        SensFill.ZIndex = 25
        SensFill.Parent = SensTrack
        local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(0, 4); fc.Parent = SensFill
        
        SensHandle = Instance.new("TextButton")
        SensHandle.Size = UDim2.new(0, 20, 0, 20)
        SensHandle.Position = UDim2.new(ratio, -10, 0.5, -10)
        SensHandle.BackgroundColor3 = Color3.new(1, 1, 1)
        SensHandle.BorderSizePixel = 0
        SensHandle.Text = ""
        SensHandle.AutoButtonColor = false
        SensHandle.ZIndex = 26
        SensHandle.Parent = SensTrack
        local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(0, 10); hc.Parent = SensHandle
        
        local hs = Instance.new("UIStroke")
        hs.Color = Colors.Accent; hs.Thickness = 2; hs.Transparency = 0; hs.Parent = SensHandle
        
        for i, preset in ipairs(Config.SensitivityPresets) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 40, 0, 22)
            btn.Position = UDim2.new(0, 10 + (i-1)*46, 0, 64)
            btn.BackgroundColor3 = Colors.Base
            btn.BorderSizePixel = 0
            btn.Text = "x" .. string.format("%.1f", preset)
            btn.TextColor3 = Colors.TextDim
            btn.TextSize = 11
            btn.Font = Enum.Font.GothamMedium
            btn.AutoButtonColor = false
            btn.ZIndex = 24
            btn.Parent = card
            local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 4); bc.Parent = btn
            btn.MouseEnter:Connect(function() Utils.Tween(btn, {BackgroundColor3=Colors.Hover}, 0.15) end)
            btn.MouseLeave:Connect(function() Utils.Tween(btn, {BackgroundColor3=Colors.Base}, 0.15) end)
            btn.MouseButton1Click:Connect(function() UpdateSensitivity(preset) end)
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
                local mx = game:GetService("UserInputService"):GetMouseLocation().X
                local r = math.clamp((mx - SensTrack.AbsolutePosition.X) / SensTrack.AbsoluteSize.X, 0, 1)
                UpdateSensitivity(Config.SensitivityMin + (Config.SensitivityMax - Config.SensitivityMin) * r)
            end
        end)
    end
    
    return {createContentFrame = createContentFrame, populate = populate, update = UpdateSensitivity}
end