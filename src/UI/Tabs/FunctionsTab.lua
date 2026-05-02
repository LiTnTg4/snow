getgenv().SnowUI = getgenv().SnowUI or {}
local M = getgenv().SnowUI
local FunctionsTab = {}

function FunctionsTab.Create(parent, Colors, Utils, Toast, Headless, BrokenLegs, Graphics, SwitchTabFn)
    local content, list = nil, nil
    
    local function createContentFrame(contentArea)
        content = Utils.Create("ScrollingFrame", {
            Size = UDim2.new(1, -16, 1, -16), Position = UDim2.new(0, 8, 0, 8),
            BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
            ScrollBarImageColor3 = Colors.Element, CanvasSize = UDim2.new(0, 0, 0, 0),
            ZIndex = 22, Parent = contentArea,
        })
        list = Utils.Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = content})
        Utils.Create("UIPadding", {PaddingTop=UDim.new(0,4),PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,4),PaddingBottom=UDim.new(0,4), Parent = content})
    end
    
    local function populate()
        local items = {
            {title="无头",desc="隐藏角色头部和脸部",action=function()
                local active = Headless.Toggle(); Toast.Show("无头", active and "已开启" or "已关闭", 2)
            end},
            {title="R6断腿",desc="仅R6角色可用",action=function()
                local active = BrokenLegs.ToggleR6(); Toast.Show("R6断腿", active and "已开启" or "已关闭", 1.5)
            end},
            {title="R15断腿",desc="仅R15角色可用",action=function()
                local active = BrokenLegs.ToggleR15(); Toast.Show("R15断腿", active and "已开启" or "已关闭", 1.5)
            end},
            {title="画质简化",desc="降低画质提升性能",action=function()
                local active = Graphics.Toggle(); Toast.Show("画质简化", active and "已开启" or "已关闭", 1.5)
            end},
            {title="隐藏饰品",desc="在饰品标签页设置",action=function()
                SwitchTabFn("accessories"); Toast.Show("隐藏饰品", "请在饰品标签页中选择", 2)
            end},
        }
        
        for _, item in ipairs(items) do
            local card = Utils.Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 48), BackgroundColor3 = Colors.Element,
                BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 23, Parent = content, Corner = 6,
            })
            Utils.Create("Frame", {Size=UDim2.new(0,4,1,-16),Position=UDim2.new(0,12,0,8),BackgroundColor3=Colors.Accent,BackgroundTransparency=0.5,BorderSizePixel=0,ZIndex=24,Parent=card,Corner=2})
            Utils.Create("TextLabel", {Size=UDim2.new(0,160,0,16),Position=UDim2.new(0,24,0,8),BackgroundTransparency=1,Text=item.title,TextColor3=Colors.Text,TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=24,Parent=card})
            Utils.Create("TextLabel", {Size=UDim2.new(0,200,0,14),Position=UDim2.new(0,24,0,26),BackgroundTransparency=1,Text=item.desc,TextColor3=Colors.TextMuted,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=24,Parent=card})
            card.MouseEnter:Connect(function() Utils.Tween(card, {BackgroundColor3=Colors.Hover}, 0.15) end)
            card.MouseLeave:Connect(function() Utils.Tween(card, {BackgroundColor3=Colors.Element}, 0.15) end)
            card.MouseButton1Click:Connect(function()
                if item.action then item.action() end
                Utils.Tween(card, {BackgroundColor3=Colors.Active}, 0.1)
                task.wait(0.1); Utils.Tween(card, {BackgroundColor3=Colors.Hover}, 0.15)
            end)
        end
        
        list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 8)
        end)
    end
    
    return {createContentFrame = createContentFrame, populate = populate}
end

getgenv().SnowUI.Tabs = getgenv().SnowUI.Tabs or {}
getgenv().SnowUI.Tabs.Functions = FunctionsTab