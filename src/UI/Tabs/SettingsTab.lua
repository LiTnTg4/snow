-- 设置标签页
local SettingsTab = {}

function SettingsTab.Create(parent, Colors, Utils, Toast, Defaults, SavedConfig, Panel, GetDefaultPos)
    local content, list = nil, nil
    local WInput, HInput = nil, nil
    
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
    
    local function ApplySize()
        local w = math.clamp(tonumber(WInput.Text) or SavedConfig.width, Defaults.MinWidth, Defaults.MaxWidth)
        local h = math.clamp(tonumber(HInput.Text) or SavedConfig.height, Defaults.MinHeight, Defaults.MaxHeight)
        SavedConfig.width, SavedConfig.height = w, h
        WInput.Text, HInput.Text = tostring(w), tostring(h)
        Panel.Size = UDim2.new(0, w, 0, h)
        Panel.Position = UDim2.new(0.5, -w/2, 0.5, -h/2)
        SavedConfig.posX, SavedConfig.posY = nil, nil
        Toast.Show("尺寸应用", w .. " x " .. h, 1.5)
    end
    
    local function populate()
        local Camera = workspace.CurrentCamera
        local ScreenW = Camera.ViewportSize.X
        local ScreenH = Camera.ViewportSize.Y
        
        local card = Utils.Create("Frame", {
            Size = UDim2.new(1, 0, 0, 160),
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
            Text = "自定义尺寸",
            TextColor3 = Colors.TextDim,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            ZIndex = 24,
            Parent = card,
        })
        
        Utils.Create("TextLabel", {
            Size = UDim2.new(1, -28, 0, 16),
            Position = UDim2.new(0, 14, 0, 34),
            BackgroundTransparency = 1,
            Text = "屏幕: " .. ScreenW .. "x" .. ScreenH,
            TextColor3 = Colors.TextMuted,
            TextSize = 10,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 24,
            Parent = card,
        })
        
        Utils.Create("TextLabel", {
            Size = UDim2.new(0, 40, 0, 16),
            Position = UDim2.new(0, 14, 0, 56),
            BackgroundTransparency = 1,
            Text = "宽度",
            TextColor3 = Colors.TextDim,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            ZIndex = 24,
            Parent = card,
        })
        
        WInput = Utils.Create("TextBox", {
            Size = UDim2.new(0, 90, 0, 30),
            Position = UDim2.new(0, 60, 0, 52),
            BackgroundColor3 = Colors.Base,
            BorderSizePixel = 0,
            Text = tostring(SavedConfig.width),
            TextColor3 = Colors.Text,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            ZIndex = 24,
            Parent = card,
            Corner = 4,
        })
        
        Utils.Create("TextLabel", {
            Size = UDim2.new(0, 40, 0, 16),
            Position = UDim2.new(0, 170, 0, 56),
            BackgroundTransparency = 1,
            Text = "高度",
            TextColor3 = Colors.TextDim,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            ZIndex = 24,
            Parent = card,
        })
        
        HInput = Utils.Create("TextBox", {
            Size = UDim2.new(0, 90, 0, 30),
            Position = UDim2.new(0, 210, 0, 52),
            BackgroundColor3 = Colors.Base,
            BorderSizePixel = 0,
            Text = tostring(SavedConfig.height),
            TextColor3 = Colors.Text,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            ZIndex = 24,
            Parent = card,
            Corner = 4,
        })
        
        Utils.Create("TextButton", {
            Size = UDim2.new(0, 90, 0, 32),
            Position = UDim2.new(0, 14, 0, 92),
            BackgroundColor3 = Colors.Accent,
            BorderSizePixel = 0,
            Text = "应用尺寸",
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
            ZIndex = 24,
            Parent = card,
            Corner = 4,
        }).MouseButton1Click:Connect(ApplySize)
        
        Utils.Create("TextButton", {
            Size = UDim2.new(0, 90, 0, 32),
            Position = UDim2.new(0, 112, 0, 92),
            BackgroundColor3 = Colors.Element,
            BorderSizePixel = 0,
            Text = "重置默认",
            TextColor3 = Colors.TextDim,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            AutoButtonColor = false,
            ZIndex = 24,
            Parent = card,
            Corner = 4,
        }).MouseButton1Click:Connect(function()
            local defaultW = math.clamp(math.floor(ScreenW * 0.45), Defaults.MinWidth, Defaults.MaxWidth)
            local defaultH = math.clamp(math.floor(ScreenH * 0.55), Defaults.MinHeight, Defaults.MaxHeight)
            SavedConfig.width, SavedConfig.height = defaultW, defaultH
            SavedConfig.posX, SavedConfig.posY = nil, nil
            WInput.Text, HInput.Text = tostring(defaultW), tostring(defaultH)
            Panel.Size = UDim2.new(0, defaultW, 0, defaultH)
            Panel.Position = GetDefaultPos()
            Toast.Show("尺寸重置", "已恢复默认", 1.5)
        end)
        
        list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 8)
        end)
    end
    
    return {
        createContentFrame = createContentFrame,
        populate = populate,
        updateInputs = function()
            WInput.Text = tostring(SavedConfig.width)
            HInput.Text = tostring(SavedConfig.height)
        end,
    }
end

return SettingsTab