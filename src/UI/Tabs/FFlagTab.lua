-- FFlag标签页
local FFlagTab = {}

function FFlagTab.Create(parent, Colors, Utils, Toast, FFlagTool)
    local content, list = nil, nil
    local fflagInput = nil
    
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
        local card = Utils.Create("Frame", {
            Size = UDim2.new(1, 0, 0, 240),
            BackgroundColor3 = Colors.Element,
            BorderSizePixel = 0,
            ZIndex = 23,
            Parent = content,
            Corner = 6,
        })
        
        Utils.Create("TextLabel", {
            Size = UDim2.new(0, 200, 0, 20),
            Position = UDim2.new(0, 14, 0, 12),
            BackgroundTransparency = 1,
            Text = "FFlags.json 粘贴工具",
            TextColor3 = Colors.TextDim,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 24,
            Parent = card,
        })
        
        fflagInput = Utils.Create("TextBox", {
            Size = UDim2.new(1, -28, 0, 140),
            Position = UDim2.new(0, 14, 0, 40),
            BackgroundColor3 = Colors.Base,
            BorderSizePixel = 0,
            Text = "",
            PlaceholderText = "粘贴 FFlags.json 内容...",
            PlaceholderColor3 = Colors.TextMuted,
            TextColor3 = Colors.Text,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            ClearTextOnFocus = false,
            ZIndex = 24,
            Parent = card,
            Corner = 4,
        })
        
        local btnContainer = Utils.Create("Frame", {
            Size = UDim2.new(1, -28, 0, 34),
            Position = UDim2.new(0, 14, 0, 190),
            BackgroundTransparency = 1,
            ZIndex = 24,
            Parent = card,
        })
        Utils.Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
            Parent = btnContainer,
        })
        
        local function createBtn(text, color, action)
            local btn = Utils.Create("TextButton", {
                Size = UDim2.new(0, 100, 1, 0),
                BackgroundColor3 = color,
                BorderSizePixel = 0,
                Text = text,
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                AutoButtonColor = false,
                ZIndex = 25,
                Parent = btnContainer,
                Corner = 4,
            })
            btn.MouseButton1Click:Connect(action)
            return btn
        end
        
        createBtn("应用FFlags", Colors.Success, function()
            local ok, result = FFlagTool.Apply(fflagInput.Text)
            if ok then
                Toast.Show("FFlag应用", "已应用 " .. result .. " 个", 2)
            else
                Toast.Show("FFlag错误", result, 2)
            end
        end)
        
        createBtn("保存当前", Color3.fromRGB(33, 150, 243), function()
            if fflagInput.Text ~= "" then
                FFlagTool.Save(fflagInput.Text)
                Toast.Show("FFlag保存", "已保存", 2)
            else
                Toast.Show("保存失败", "没有内容", 1.5)
            end
        end)
        
        createBtn("加载上次", Colors.Warning, function()
            local content = FFlagTool.Load()
            if content then
                fflagInput.Text = content
                Toast.Show("FFlag加载", "已加载", 2)
            else
                Toast.Show("FFlag", "无保存文件", 2)
            end
        end)
        
        -- 自动加载
        task.delay(0.3, function()
            local saved = FFlagTool.Load()
            if saved then fflagInput.Text = saved end
        end)
        
        list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 8)
        end)
    end
    
    return {
        createContentFrame = createContentFrame,
        populate = populate,
    }
end

return FFlagTab