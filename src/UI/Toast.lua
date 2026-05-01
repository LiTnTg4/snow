-- Toast通知系统
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Toast = {}

function Toast.Show(title, message, duration)
    duration = duration or 2
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 260, 0, 60)
    frame.Position = UDim2.new(0.5, -130, 1, 20)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ZIndex = 200
    frame.Parent = playerGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 130, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 22)
    titleLabel.Position = UDim2.new(0, 10, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "提示"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 201
    titleLabel.Parent = frame
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -20, 0, 18)
    msgLabel.Position = UDim2.new(0, 10, 0, 32)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message or ""
    msgLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
    msgLabel.TextSize = 12
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.ZIndex = 201
    msgLabel.Parent = frame
    
    -- 入场
    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -130, 0.85, 0),
        BackgroundTransparency = 0.2,
    }):Play()
    
    -- 出场
    task.delay(duration, function()
        local t = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -130, 1, 20),
            BackgroundTransparency = 1,
        })
        t.Completed:Connect(function() frame:Destroy() end)
        t:Play()
    end)
end

return Toast