getgenv().SnowUI = getgenv().SnowUI or {}
local M = getgenv().SnowUI
local FunctionsTab = {}

function FunctionsTab.Create(parent, Colors, Utils, Toast, Headless, BrokenLegs, Graphics, SwitchTabFn)
    local content
    
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
        
        -- 存储list引用用于更新CanvasSize
        content.List = list
    end
    
    local function populate()
        local items = {
            {title="无头",desc="隐藏角色头部和脸部",action=function()
                Headless.Toggle(); Toast.Show("无头", Headless.IsActive() and "已开启" or "已关闭", 2)
            end},
            {title="R6断腿",desc="仅R6角色可用",action=function()
                local a = BrokenLegs.ToggleR6(); Toast.Show("R6断腿", a and "已开启" or "已关闭", 1.5)
            end},
            {title="R15断腿",desc="仅R15角色可用",action=function()
                local a = BrokenLegs.ToggleR15(); Toast.Show("R15断腿", a and "已开启" or "已关闭", 1.5)
            end},
            {title="画质简化",desc="降低画质提升性能",action=function()
                local a = Graphics.Toggle(); Toast.Show("画质简化", a and "已开启" or "已关闭", 1.5)
            end},
            {title="隐藏饰品",desc="在饰品标签页设置",action=function()
                SwitchTabFn("accessories"); Toast.Show("隐藏饰品", "请在饰品标签页中选择", 2)
            end},
        }
        
        for _, item in ipairs(items) do
            local card = Instance.new("TextButton")
            card.Size = UDim2.new(1, 0, 0, 48)
            card.BackgroundColor3 = Colors.Element
            card.BorderSizePixel = 0
            card.Text = ""
            card.AutoButtonColor = false
            card.ZIndex = 23
            card.Parent = content
            local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 6); cc.Parent = card
            
            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(0, 4, 1, -16)
            bar.Position = UDim2.new(0, 12, 0, 8)
            bar.BackgroundColor3 = Colors.Accent
            bar.BackgroundTransparency = 0.5
            bar.BorderSizePixel = 0
            bar.ZIndex = 24
            bar.Parent = card
            local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 2); bc.Parent = bar
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(0, 160, 0, 16)
            title.Position = UDim2.new(0, 24, 0, 8)
            title.BackgroundTransparency = 1
            title.Text = item.title
            title.TextColor3 = Colors.Text
            title.TextSize = 13
            title.Font = Enum.Font.GothamBold
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.ZIndex = 24
            title.Parent = card
            
            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(0, 200, 0, 14)
            desc.Position = UDim2.new(0, 24, 0, 26)
            desc.BackgroundTransparency = 1
            desc.Text = item.desc
            desc.TextColor3 = Colors.TextMuted
            desc.TextSize = 11
            desc.Font = Enum.Font.Gotham
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.ZIndex = 24
            desc.Parent = card
            
            card.MouseEnter:Connect(function() Utils.Tween(card, {BackgroundColor3=Colors.Hover}, 0.15) end)
            card.MouseLeave:Connect(function() Utils.Tween(card, {BackgroundColor3=Colors.Element}, 0.15) end)
            card.MouseButton1Click:Connect(function()
                if item.action then item.action() end
                Utils.Tween(card, {BackgroundColor3=Colors.Active}, 0.1)
                task.wait(0.1)
                Utils.Tween(card, {BackgroundColor3=Colors.Hover}, 0.15)
            end)
        end
        
        if content.List then
            content.List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                content.CanvasSize = UDim2.new(0, 0, 0, content.List.AbsoluteContentSize.Y + 8)
            end)
        end
    end
    
    return {createContentFrame = createContentFrame, populate = populate}
end

getgenv().SnowUI.Tabs = getgenv().SnowUI.Tabs or {}
getgenv().SnowUI.Tabs.Functions = FunctionsTab