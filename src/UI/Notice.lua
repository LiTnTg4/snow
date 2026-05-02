getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.Notice = {}
local N = getgenv().SnowUI.Notice

function N.Create(parent, Colors, Utils)
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
    local ms = Instance.new("UIStroke"); ms.Color = Colors.Border; ms.Thickness = 1; ms.Transparency = 0.4; ms.Parent = modal
    
    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1, 0, 0, 40)
    tl.BackgroundColor3 = Colors.Panel
    tl.BorderSizePixel = 0
    tl.Text = "系统公告"
    tl.TextColor3 = Colors.Text
    tl.TextSize = 14
    tl.Font = Enum.Font.GothamBold
    tl.ZIndex = 102
    tl.Parent = modal
    local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(0, 10); tc.Parent = tl
    
    local cb = Instance.new("TextButton")
    cb.Size = UDim2.new(0, 26, 0, 26)
    cb.Position = UDim2.new(1, -34, 0, 7)
    cb.BackgroundColor3 = Colors.Element
    cb.BorderSizePixel = 0
    cb.Text = "X"
    cb.TextColor3 = Colors.TextDim
    cb.TextSize = 12
    cb.Font = Enum.Font.GothamMedium
    cb.AutoButtonColor = false
    cb.ZIndex = 103
    cb.Parent = modal
    local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 13); cc.Parent = cb
    
    local cl = Instance.new("TextLabel")
    cl.Size = UDim2.new(1, -24, 1, -60)
    cl.Position = UDim2.new(0, 12, 0, 50)
    cl.BackgroundTransparency = 1
    cl.Text = "公告内容"
    cl.TextColor3 = Colors.TextDim
    cl.TextSize = 13
    cl.Font = Enum.Font.Gotham
    cl.TextWrapped = true
    cl.TextXAlignment = Enum.TextXAlignment.Left
    cl.ZIndex = 102
    cl.Parent = modal
    
    local function show(text)
        cl.Text = text or cl.Text
        overlay.Visible = true
        Utils.Tween(overlay, {BackgroundTransparency = 0.5}, 0.2)
    end
    local function hide()
        local t = Utils.Tween(overlay, {BackgroundTransparency = 1}, 0.15)
        t.Completed:Connect(function() overlay.Visible = false end)
    end
    cb.MouseButton1Click:Connect(hide)
    overlay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then hide() end
    end)
    return {show = show, hide = hide, setText = function(text) cl.Text = text end}
end