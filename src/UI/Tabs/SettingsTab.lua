getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.Tabs = getgenv().SnowUI.Tabs or {}
local ST2 = {}
getgenv().SnowUI.Tabs.Settings = ST2

function ST2.Create(parent, Colors, Utils, Toast, Defaults, SavedConfig, Panel, GetDefaultPos)
    local scrollFrame
    local WInput, HInput
    
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
        
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 160)
        card.BackgroundColor3 = Colors.Element
        card.BorderSizePixel = 0
        card.ZIndex = 23
        card.Parent = scrollFrame
        local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 6); cc.Parent = card
        
        local tl = Instance.new("TextLabel")
        tl.Size = UDim2.new(0, 150, 0, 20)
        tl.Position = UDim2.new(0, 14, 0, 12)
        tl.BackgroundTransparency = 1
        tl.Text = "自定义尺寸"
        tl.TextColor3 = Colors.TextDim
        tl.TextSize = 13
        tl.Font = Enum.Font.GothamBold
        tl.ZIndex = 24
        tl.Parent = card
        
        local info = Instance.new("TextLabel")
        info.Size = UDim2.new(1, -28, 0, 16)
        info.Position = UDim2.new(0, 14, 0, 34)
        info.BackgroundTransparency = 1
        info.Text = "屏幕: " .. ScreenW .. "x" .. ScreenH
        info.TextColor3 = Colors.TextMuted
        info.TextSize = 10
        info.Font = Enum.Font.Gotham
        info.TextXAlignment = Enum.TextXAlignment.Left
        info.ZIndex = 24
        info.Parent = card
        
        local wl = Instance.new("TextLabel")
        wl.Size = UDim2.new(0, 40, 0, 16)
        wl.Position = UDim2.new(0, 14, 0, 56)
        wl.BackgroundTransparency = 1
        wl.Text = "宽度"
        wl.TextColor3 = Colors.TextDim
        wl.TextSize = 11
        wl.Font = Enum.Font.Gotham
        wl.ZIndex = 24
        wl.Parent = card
        
        WInput = Instance.new("TextBox")
        WInput.Size = UDim2.new(0, 90, 0, 30)
        WInput.Position = UDim2.new(0, 60, 0, 52)
        WInput.BackgroundColor3 = Colors.Base
        WInput.BorderSizePixel = 0
        WInput.Text = tostring(SavedConfig.width)
        WInput.TextColor3 = Colors.Text
        WInput.TextSize = 12
        WInput.Font = Enum.Font.Gotham
        WInput.ZIndex = 24
        WInput.Parent = card
        local wc = Instance.new("UICorner"); wc.CornerRadius = UDim.new(0, 4); wc.Parent = WInput
        
        local hl = Instance.new("TextLabel")
        hl.Size = UDim2.new(0, 40, 0, 16)
        hl.Position = UDim2.new(0, 170, 0, 56)
        hl.BackgroundTransparency = 1
        hl.Text = "高度"
        hl.TextColor3 = Colors.TextDim
        hl.TextSize = 11
        hl.Font = Enum.Font.Gotham
        hl.ZIndex = 24
        hl.Parent = card
        
        HInput = Instance.new("TextBox")
        HInput.Size = UDim2.new(0, 90, 0, 30)
        HInput.Position = UDim2.new(0, 210, 0, 52)
        HInput.BackgroundColor3 = Colors.Base
        HInput.BorderSizePixel = 0
        HInput.Text = tostring(SavedConfig.height)
        HInput.TextColor3 = Colors.Text
        HInput.TextSize = 12
        HInput.Font = Enum.Font.Gotham
        HInput.ZIndex = 24
        HInput.Parent = card
        local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(0, 4); hc.Parent = HInput
        
        local applyBtn = Instance.new("TextButton")
        applyBtn.Size = UDim2.new(0, 90, 0, 32)
        applyBtn.Position = UDim2.new(0, 14, 0, 92)
        applyBtn.BackgroundColor3 = Colors.Accent
        applyBtn.BorderSizePixel = 0
        applyBtn.Text = "应用尺寸"
        applyBtn.TextColor3 = Color3.new(1, 1, 1)
        applyBtn.TextSize = 12
        applyBtn.Font = Enum.Font.GothamBold
        applyBtn.AutoButtonColor = false
        applyBtn.ZIndex = 24
        applyBtn.Parent = card
        local ac = Instance.new("UICorner"); ac.CornerRadius = UDim.new(0, 4); ac.Parent = applyBtn
        applyBtn.MouseButton1Click:Connect(ApplySize)
        
        local resetBtn = Instance.new("TextButton")
        resetBtn.Size = UDim2.new(0, 90, 0, 32)
        resetBtn.Position = UDim2.new(0, 112, 0, 92)
        resetBtn.BackgroundColor3 = Colors.Element
        resetBtn.BorderSizePixel = 0
        resetBtn.Text = "重置默认"
        resetBtn.TextColor3 = Colors.TextDim
        resetBtn.TextSize = 12
        resetBtn.Font = Enum.Font.Gotham
        resetBtn.AutoButtonColor = false
        resetBtn.ZIndex = 24
        resetBtn.Parent = card
        local rc = Instance.new("UICorner"); rc.CornerRadius = UDim.new(0, 4); rc.Parent = resetBtn
        resetBtn.MouseButton1Click:Connect(function()
            local dW = math.clamp(math.floor(ScreenW * 0.45), Defaults.MinWidth, Defaults.MaxWidth)
            local dH = math.clamp(math.floor(ScreenH * 0.55), Defaults.MinHeight, Defaults.MaxHeight)
            SavedConfig.width, SavedConfig.height = dW, dH
            SavedConfig.posX, SavedConfig.posY = nil, nil
            WInput.Text, HInput.Text = tostring(dW), tostring(dH)
            Panel.Size = UDim2.new(0, dW, 0, dH)
            Panel.Position = GetDefaultPos()
            Toast.Show("尺寸重置", "已恢复默认", 1.5)
        end)
    end
    
    return {
        createContentFrame = createContentFrame,
        populate = populate,
        updateInputs = function()
            if WInput then WInput.Text = tostring(SavedConfig.width) end
            if HInput then HInput.Text = tostring(SavedConfig.height) end
        end,
    }
end