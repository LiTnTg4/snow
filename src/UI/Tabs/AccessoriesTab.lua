getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.Tabs = getgenv().SnowUI.Tabs or {}
local AT = {}
getgenv().SnowUI.Tabs.Accessories = AT

function AT.Create(parent, Colors, Utils, Toast, Accessories)
    local scrollFrame
    local buttons = {}
    
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
    
    local function populate()
        local slotConfig = Accessories.GetSlotConfig()
        for _, config in ipairs(slotConfig) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
            btn.BorderSizePixel = 0
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.ZIndex = 23
            btn.Parent = scrollFrame
            local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 6); bc.Parent = btn
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = "显示: " .. config.name
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 14
            label.Font = Enum.Font.GothamMedium
            label.ZIndex = 24
            label.Parent = btn
            
            local function updateBtn()
                local isVisible = Accessories.IsVisible(config.type)
                btn.BackgroundColor3 = isVisible and Color3.fromRGB(100, 180, 100) or Color3.fromRGB(180, 100, 100)
                label.Text = (isVisible and "显示: " or "隐藏: ") .. config.name
            end
            
            btn.MouseButton1Click:Connect(function()
                Accessories.Toggle(config.type)
                updateBtn()
                Toast.Show(config.name, Accessories.IsVisible(config.type) and "已显示" or "已隐藏", 1.5)
            end)
            
            buttons[config.type] = updateBtn
            updateBtn()
        end
    end
    
    local function refreshAll()
        for _, fn in pairs(buttons) do fn() end
    end
    
    return {createContentFrame = createContentFrame, populate = populate, refreshAll = refreshAll}
end