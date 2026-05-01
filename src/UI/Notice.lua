-- 公告弹窗模块
local Notice = {}

function Notice.Create(parent, Colors, Utils)
    local overlay = Utils.Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 100,
        Parent = parent,
    })
    
    local modal = Utils.Create("Frame", {
        Size = UDim2.new(0, 320, 0, 240),
        Position = UDim2.new(0.5, -160, 0.5, -120),
        BackgroundColor3 = Colors.Panel,
        BorderSizePixel = 0,
        ZIndex = 101,
        Parent = overlay,
        Corner = 10,
    })
    
    Utils.Create("UIStroke", {
        Color = Colors.Border,
        Thickness = 1,
        Transparency = 0.4,
        Parent = modal,
    })
    
    Utils.Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Colors.Panel,
        BorderSizePixel = 0,
        Text = "系统公告",
        TextColor3 = Colors.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        ZIndex = 102,
        Parent = modal,
        Corner = 10,
    })
    
    local closeBtn = Utils.Create("TextButton", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(1, -34, 0, 7),
        BackgroundColor3 = Colors.Element,
        BorderSizePixel = 0,
        Text = "X",
        TextColor3 = Colors.TextDim,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false,
        ZIndex = 103,
        Parent = modal,
        Corner = 13,
    })
    
    local contentLabel = Utils.Create("TextLabel", {
        Size = UDim2.new(1, -24, 1, -60),
        Position = UDim2.new(0, 12, 0, 50),
        BackgroundTransparency = 1,
        Text = "公告内容",
        TextColor3 = Colors.TextDim,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 102,
        Parent = modal,
    })
    
    local function show(text)
        contentLabel.Text = text or contentLabel.Text
        overlay.Visible = true
        Utils.Tween(overlay, { BackgroundTransparency = 0.5 }, 0.2)
    end
    
    local function hide()
        local t = Utils.Tween(overlay, { BackgroundTransparency = 1 }, 0.15)
        t.Completed:Connect(function() overlay.Visible = false end)
    end
    
    closeBtn.MouseButton1Click:Connect(hide)
    overlay.MouseButton1Click:Connect(hide)
    
    return {
        overlay = overlay,
        modal = modal,
        show = show,
        hide = hide,
        setText = function(text) contentLabel.Text = text end,
    }
end

return Notice