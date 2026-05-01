-- 饰品标签页
local AccessoriesTab = {}

function AccessoriesTab.Create(parent, Colors, Utils, Toast, Accessories)
    local content, list = nil, nil
    local buttons = {}
    
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
    
    local function populate()
        local slotConfig = Accessories.GetSlotConfig()
        
        for _, config in ipairs(slotConfig) do
            local btn = Utils.Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Color3.fromRGB(100, 180, 100),
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 23,
                Parent = content,
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
            
            buttons[config.type] = updateBtn
            updateBtn()
        end
        
        list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 8)
        end)
    end
    
    local function refreshAll()
        for _, updateFn in pairs(buttons) do
            updateFn()
        end
    end
    
    return {
        createContentFrame = createContentFrame,
        populate = populate,
        refreshAll = refreshAll,
    }
end

return AccessoriesTab