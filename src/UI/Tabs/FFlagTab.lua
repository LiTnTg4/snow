getgenv().SnowUI = getgenv().SnowUI or {}
local M = getgenv().SnowUI
local FFlagTab = {}

function FFlagTab.Create(parent, Colors, Utils, Toast, FFlagTool)
    local content, list, fflagInput = nil, nil, nil
    
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
        
        list = Instance.new("UIListLayout")
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Padding = UDim.new(0, 8)
        list.Parent = content
        
        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 4)
        pad.PaddingLeft = UDim.new(0, 4)
        pad.PaddingRight = UDim.new(0, 4)
        pad.PaddingBottom = UDim.new(0, 4)
        pad.Parent = content
    end
    
    local function populate()
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 240)
        card.BackgroundColor3 = Colors.Element
        card.BorderSizePixel = 0
        card.ZIndex = 23
        card.Parent = content
        local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 6); cc.Parent = card
        
        local tl = Instance.new("TextLabel")
        tl.Size = UDim2.new(0, 200, 0, 20)
        tl.Position = UDim2.new(0, 14, 0, 12)
        tl.BackgroundTransparency = 1
        tl.Text = "FFlags.json 粘贴工具"
        tl.TextColor3 = Colors.TextDim
        tl.TextSize = 13
        tl.Font = Enum.Font.GothamBold
        tl.TextXAlignment = Enum.TextXAlignment.Left
        tl.ZIndex = 24
        tl.Parent = card
        
        fflagInput = Instance.new("TextBox")
        fflagInput.Size = UDim2.new(1, -28, 0, 140)
        fflagInput.Position = UDim2.new(0, 14, 0, 40)
        fflagInput.BackgroundColor3 = Colors.Base
        fflagInput.BorderSizePixel = 0
        fflagInput.PlaceholderText = "粘贴 FFlags.json 内容..."
        fflagInput.PlaceholderColor3 = Colors.TextMuted
        fflagInput.TextColor3 = Colors.Text
        fflagInput.TextSize = 12
        fflagInput.Font = Enum.Font.Gotham
        fflagInput.TextXAlignment = Enum.TextXAlignment.Left
        fflagInput.TextYAlignment = Enum.TextYAlignment.Top
        fflagInput.TextWrapped = true
        fflagInput.ClearTextOnFocus = false
        fflagInput.ZIndex = 24
        fflagInput.Parent = card
        local ic = Instance.new("UICorner"); ic.CornerRadius = UDim.new(0, 4); ic.Parent = fflagInput
        
        local btnContainer = Instance.new("Frame")
        btnContainer.Size = UDim2.new(1, -28, 0, 34)
        btnContainer.Position = UDim2.new(0, 14, 0, 190)
        btnContainer.BackgroundTransparency = 1
        btnContainer.ZIndex = 24
        btnContainer.Parent = card
        
        local bl = Instance.new("UIListLayout")
        bl.FillDirection = Enum.FillDirection.Horizontal
        bl.SortOrder = Enum.SortOrder.LayoutOrder
        bl.Padding = UDim.new(0, 6)
        bl.Parent = btnContainer
        
        local function createBtn(text, color, action)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 100, 1, 0)
            btn.BackgroundColor3 = color
            btn.BorderSizePixel = 0
            btn.Text = text
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextSize = 12
            btn.Font = Enum.Font.GothamBold
            btn.AutoButtonColor = false
            btn.ZIndex = 25
            btn.Parent = btnContainer
            local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 4); bc.Parent = btn
            btn.MouseButton1Click:Connect(action)
        end
        
        createBtn("应用FFlags", Colors.Success, function()
            local ok, result = FFlagTool.Apply(fflagInput.Text)
            if ok then Toast.Show("FFlag应用", "已应用 "..result.." 个", 2) else Toast.Show("FFlag错误", result, 2) end
        end)
        createBtn("保存当前", Color3.fromRGB(33,150,243), function()
            if fflagInput.Text~="" then FFlagTool.Save(fflagInput.Text); Toast.Show("FFlag保存","已保存",2) else Toast.Show("保存失败","没有内容",1.5) end
        end)
        createBtn("加载上次", Colors.Warning, function()
            local saved = FFlagTool.Load()
            if saved then fflagInput.Text = saved; Toast.Show("FFlag加载","已加载",2) else Toast.Show("FFlag","无保存文件",2) end
        end)
        
        task.delay(0.3, function() local s=FFlagTool.Load(); if s then fflagInput.Text=s end end)
        
        list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            content.CanvasSize = UDim2.new(0,0,0,list.AbsoluteContentSize.Y+8)
        end)
    end
    
    return {createContentFrame=createContentFrame, populate=populate}
end

getgenv().SnowUI.Tabs = getgenv().SnowUI.Tabs or {}
getgenv().SnowUI.Tabs.FFlag = FFlagTab