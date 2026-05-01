-- 灵敏度标签页
local SensitivityTab = {}

function SensitivityTab.Create(parent, Colors, Utils, Config, Sensitivity, SavedConfig, sliderState)
    local content, list = nil, nil
    local SensFill, SensHandle, SensValue, SensTrack = nil, nil, nil, nil
    
    local function createContentFrame(contentArea)
        content = Utils.Create("ScrollingFrame", {
            Size = UDim2.new(1, -16, 1, -16),
            Position = UDim2.new(0, 8, 0, 8),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Colors.Element,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ZIndex = 22,
            Parent = contentArea,
        })
        list = Utils.Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            Parent = content,
        })
        Utils.Create("UIPadding", {
            PaddingTop = UDim.new(0, 4),
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 4),
            Parent = content,
        })
    end
    
    local function UpdateSensitivity(value)
        local clamped = math.clamp(value, Config.SensitivityMin, Config.SensitivityMax)
        SavedConfig.sensitivity = clamped
        Sensitivity.Set(clamped)
        local r = (clamped - Config.SensitivityMin) / (Config.SensitivityMax - Config.SensitivityMin)
        SensFill.Size = UDim2.new(r, 0, 1, 0)
        SensHandle.Position = UDim2.new(r, -10, 0.5, -10)
        SensValue.Text = string.format("%.1f", clamped)
    end
    
    local function populate()
        local card = Utils.Create("Frame", {
            Size = UDim2.new(1, 0, 0, 100),
            BackgroundColor3 = Colors.Element,
            BorderSizePixel = 0,
            ZIndex = 23,
            Parent = content,
            Corner = 6,
        })
        
        Utils.Create("TextLabel", {
            Size = UDim2.new(0, 150, 0, 20),
            Position = UDim2.new(0, 14, 0, 12),
            BackgroundTransparency = 1,
            Text = "触摸灵敏度",
            TextColor3 = Colors.TextDim,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 24,
            Parent = card,
        })
        
        SensValue = Utils.Create("TextLabel", {
            Size = UDim2.new(0, 60, 0, 20),
            Position = UDim2.new(1, -72, 0, 12),
            BackgroundTransparency = 1,
            Text = string.format("%.1f", SavedConfig.sensitivity),
            TextColor3 = Colors.Accent,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 24,
            Parent = card,
        })
        
        SensTrack = Utils.Create("Frame", {
            Size = UDim2.new(1, -24, 0, 8),
            Position = UDim2.new(0, 12, 0, 44),
            BackgroundColor3 = Colors.SliderTrack,
            BorderSizePixel = 0,
            ZIndex = 24,
            Parent = card,
            Corner = 4,
        })
        
        local ratio = (SavedConfig.sensitivity - Config.SensitivityMin) / (Config.SensitivityMax - Config.SensitivityMin)
        SensFill = Utils.Create("Frame", {
            Size = UDim2.new(ratio, 0, 1, 0),
            BackgroundColor3 = Colors.SliderFill,
            BorderSizePixel = 0,
            ZIndex = 25,
            Parent = SensTrack,
            Corner = 4,
        })
        
        SensHandle = Utils.Create("TextButton", {
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
        Utils.Create("UIStroke", { Color = Colors.Accent, Thickness = 2, Transparency = 0, Parent = SensHandle })
        
        for i, preset in ipairs(Config.SensitivityPresets) do
            local btn = Utils.Create("TextButton", {
                Size = UDim2.new(0, 40, 0, 22),
                Position = UDim2.new(0, 10 + (i-1)*46, 0, 64),
                BackgroundColor3 = Colors.Base,
                BorderSizePixel = 0,
                Text = "x" .. string.format("%.1f", preset),
                TextColor3 = Colors.TextDim,
                TextSize = 11,
                Font = Enum.Font.GothamMedium,
                AutoButtonColor = false,
                ZIndex = 24,
                Parent = card,
                Corner = 4,
            })
            btn.MouseEnter:Connect(function() Utils.Tween(btn, { BackgroundColor3 = Colors.Hover }, 0.15) end)
            btn.MouseLeave:Connect(function() Utils.Tween(btn, { BackgroundColor3 = Colors.Base }, 0.15) end)
            btn.MouseButton1Click:Connect(function() UpdateSensitivity(preset) end)
        end
        
        -- 滑块事件
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
        
        list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 8)
        end)
    end
    
    return {
        createContentFrame = createContentFrame,
        populate = populate,
        update = UpdateSensitivity,
    }
end

return SensitivityTab