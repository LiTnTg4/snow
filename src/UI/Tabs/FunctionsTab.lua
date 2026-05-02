getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.Tabs = getgenv().SnowUI.Tabs or {}
local FT = {}
getgenv().SnowUI.Tabs.Functions = FT

function FT.Create(parent, Colors, Utils, Toast, Headless, BrokenLegs, Graphics, SwitchTabFn)
    local scrollFrame
    
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
        local items = {
            {title="无头",desc="隐藏角色头部和脸部",action=function() Headless.Toggle(); Toast.Show("无头", Headless.IsActive() and "已开启" or "已关闭", 2) end},
            {title="R6断腿",desc="仅R6角色可用",action=function() local a=BrokenLegs.ToggleR6(); Toast.Show("R6断腿", a and "已开启" or "已关闭", 1.5) end},
            {title="R15断腿",desc="仅R15角色可用",action=function() local a=BrokenLegs.ToggleR15(); Toast.Show("R15断腿", a and "已开启" or "已关闭", 1.5) end},
            {title="画质简化",desc="降低画质提升性能",action=function() local a=Graphics.Toggle(); Toast.Show("画质简化", a and "已开启" or "已关闭", 1.5) end},
            {title="隐藏饰品",desc="在饰品标签页设置",action=function() SwitchTabFn("accessories"); Toast.Show("隐藏饰品", "请在饰品标签页中选择", 2) end},
        }
        for _, item in ipairs(items) do
            local card = Instance.new("TextButton")
            card.Size = UDim2.new(1, 0, 0, 48)
            card.BackgroundColor3 = Colors.Element
            card.BorderSizePixel = 0
            card.Text = ""
            card.AutoButtonColor = false
            card.ZIndex = 23
            card.Parent = scrollFrame
            local cr = Instance.new("UICorner"); cr.CornerRadius = UDim.new(0, 6); cr.Parent = card
            
            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(0, 4, 1, -16)
            bar.Position = UDim2.new(0, 12, 0, 8)
            bar.BackgroundColor3 = Colors.Accent
            bar.BackgroundTransparency = 0.5
            bar.BorderSizePixel = 0
            bar.ZIndex = 24
            bar.Parent = card
            local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 2); bc.Parent = bar
            
            local tl = Instance.new("TextLabel")
            tl.Size = UDim2.new(0, 160, 0, 16)
            tl.Position = UDim2.new(0, 24, 0, 8)
            tl.BackgroundTransparency = 1
            tl.Text = item.title
            tl.TextColor3 = Colors.Text
            tl.TextSize = 13
            tl.Font = Enum.Font.GothamBold
            tl.TextXAlignment = Enum.TextXAlignment.Left
            tl.ZIndex = 24
            tl.Parent = card
            
            local dl = Instance.new("TextLabel")
            dl.Size = UDim2.new(0, 200, 0, 14)
            dl.Position = UDim2.new(0, 24, 0, 26)
            dl.BackgroundTransparency = 1
            dl.Text = item.desc
            dl.TextColor3 = Colors.TextMuted
            dl.TextSize = 11
            dl.Font = Enum.Font.Gotham
            dl.TextXAlignment = Enum.TextXAlignment.Left
            dl.ZIndex = 24
            dl.Parent = card
            
            card.MouseEnter:Connect(function() Utils.Tween(card, {BackgroundColor3=Colors.Hover}, 0.15) end)
            card.MouseLeave:Connect(function() Utils.Tween(card, {BackgroundColor3=Colors.Element}, 0.15) end)
            card.MouseButton1Click:Connect(function()
                if item.action then item.action() end
                Utils.Tween(card, {BackgroundColor3=Colors.Active}, 0.1)
                task.wait(0.1)
                Utils.Tween(card, {BackgroundColor3=Colors.Hover}, 0.15)
            end)
        end
    end
    
    return {createContentFrame = createContentFrame, populate = populate}
end