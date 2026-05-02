getgenv().SnowUI = getgenv().SnowUI or {}
local M = getgenv().SnowUI
local AccessoriesTab = {}

function AccessoriesTab.Create(parent, Colors, Utils, Toast, Accessories)
    local content
    local buttons = {}
    
    local function createContentFrame(contentArea)
        content = Instance.new("ScrollingFrame")
        content.Size = UDim2.new(1, -16, 1, -16)
        content.Position = UDim2.new(0, 8, 0, 8)
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.ScrollBarThickness = 3
        content.ScrollBarImageColor3 = Colors.Element
        content.CanvasSize = UDim2.new(0, 0, 0, 0)
        content.ZIndex = 22
        content.Parent = contentArea
        
        local list = Instance.new("UIListLayout")
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Padding = UDim.new(0, 8)
        list.Parent = content
        
        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 4)
        pad.PaddingLeft = UDim.new(0, 4)
        pad.PaddingRight = UDim.new(0, 4)
        pad.PaddingBottom = UDim.new(0, 4)
        pad.Parent = content
        
        content.List = list
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
            btn.Parent = content
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
        
        if content.List then
            content.List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                content.CanvasSize = UDim2.new(0, 0, 0, content.List.AbsoluteContentSize.Y + 8)
            end)
        end
    end
    
    local function refreshAll()
        for _, updateFn in pairs(buttons) do updateFn() end
    end
    
    return {createContentFrame=createContentFrame, populate=populate, refreshAll=refreshAll}
end

getgenv().SnowUI.Tabs = getgenv().SnowUI.Tabs or {}
getgenv().SnowUI.Tabs.Accessories = AccessoriesTab