getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.PerfButton = {}
local PerfButton = getgenv().SnowUI.PerfButton
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

function PerfButton.Create(parent, onClick)
    local camera = workspace.CurrentCamera
    
    local function getScale()
        local vs = camera.ViewportSize
        return math.max(0.8, math.min(1.5, vs.Y / 1080))
    end
    
    local scale = getScale()
    
    local dragFrame = Instance.new("Frame")
    dragFrame.Size = UDim2.new(0, 0, 0, 28 * scale)
    dragFrame.Position = UDim2.new(0.5, 0, 0.1, 0)
    dragFrame.BackgroundTransparency = 1
    dragFrame.Active = true
    dragFrame.Draggable = true
    dragFrame.ZIndex = 10
    dragFrame.Parent = parent
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = dragFrame
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    
    local border = Instance.new("UIStroke")
    border.Thickness = 1; border.Color = Color3.fromRGB(255, 255, 255); border.Transparency = 0.3
    border.Parent = frame
    
    local button = Instance.new("TextButton")
    button.BackgroundTransparency = 1
    button.Text = "FPS:060 PING:088ms"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = math.floor(14 * scale)
    button.Font = Enum.Font.Gotham
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.TextYAlignment = Enum.TextYAlignment.Center
    button.Size = UDim2.new(1, 0, 1, 0)
    button.ZIndex = 12
    button.Parent = frame
    
    local function updateSize()
        local tb = button.TextBounds
        dragFrame.Size = UDim2.new(0, tb.X + math.floor(12 * scale), 0, tb.Y + math.floor(10 * scale))
    end
    updateSize()
    
    local fc = 0; local lastTime = os.clock()
    RunService.RenderStepped:Connect(function()
        local now = os.clock(); local delta = now - lastTime
        if delta >= 1 then
            local fps = math.floor(fc / delta)
            local ping = 0
            pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
            button.Text = string.format("FPS:%03d PING:%03dms", fps, ping)
            updateSize(); fc = 0; lastTime = now
        end
        fc = fc + 1
    end)
    
    camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        scale = getScale()
        border.Thickness = math.max(1, math.floor(1 * scale))
        button.TextSize = math.floor(14 * scale)
        updateSize()
    end)
    
    button.MouseButton1Click:Connect(function() if onClick then onClick() end end)
    
    return dragFrame, button
end