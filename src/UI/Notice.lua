getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.Notice = {}
local Notice = getgenv().SnowUI.Notice

function Notice.Create(parent, Colors, Utils)
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 1
    overlay.Visible = false
    overlay.ZIndex = 100
    overlay.Parent = parent
    
    local modal = Instance.new("Frame")
    modal.Size = UDim2.new(0, 320, 0, 240)
    modal.Position = UDim2.new(0.5, -160, 0.5, -120)
    modal.BackgroundColor3 = Colors.Panel
    modal.BorderSizePixel = 0
    modal.ZIndex = 101
    modal.Parent = overlay
    local mc = Instance.new("UICorner"); mc.CornerRadius = UDim.new(0, 10); mc.Parent = modal
    
    local ms = Instance.new("UIStroke")
    ms.Color = Colors.Border; ms.Thickness = 1; ms.Transparency = 0.4; ms.Parent = modal
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.BackgroundColor3 = Colors.Panel
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "系统公告"
    titleLabel.TextColor3 = Colors.Text
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.ZIndex = 102
    titleLabel.Parent = modal
    local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(0, 10); tc.Parent = titleLabel
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -34, 0, 7)
    closeBtn.BackgroundColor3 = Colors.Element
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Colors.TextDim
    closeBtn.TextSize = 12
    closeBtn.Font = Enum.Font.GothamMedium
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 103
    closeBtn.Parent = modal
    local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 13); cc.Parent = closeBtn
    
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(1, -24, 1, -60)
    contentLabel.Position = UDim2.new(0, 12, 0, 50)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = "公告内容"
    contentLabel.TextColor3 = Colors.TextDim
    contentLabel.TextSize = 13
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextWrapped = true
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.ZIndex = 102
    contentLabel.Parent = modal
    
    local function show(text)
        contentLabel.Text = text or contentLabel.Text
        overlay.Visible = true
        Utils.Tween(overlay, {BackgroundTransparency = 0.5}, 0.2)
    end
    local function hide()
        local t = Utils.Tween(overlay, {BackgroundTransparency = 1}, 0.15)
        t.Completed:Connect(function() overlay.Visible = false end)
    end
    
    closeBtn.MouseButton1Click:Connect(hide)
    overlay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then hide() end
    end)
    
    return {show = show, hide = hide, setText = function(text) contentLabel.Text = text end}
end