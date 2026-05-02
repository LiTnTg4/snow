getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.PerfButton = {}
local PB = getgenv().SnowUI.PerfButton
local RS = game:GetService("RunService")
local St = game:GetService("Stats")
function PB.Create(parent, onClick)
    local cam = workspace.CurrentCamera
    local function gs() local vs=cam.ViewportSize; return math.max(0.8,math.min(1.5,vs.Y/1080)) end
    local scale = gs()
    local df = Instance.new("Frame"); df.Size=UDim2.new(0,0,0,28*scale); df.Position=UDim2.new(0.5,0,0.1,0); df.BackgroundTransparency=1; df.Active=true; df.Draggable=true; df.ZIndex=10; df.Parent=parent
    local f = Instance.new("Frame"); f.Size=UDim2.new(1,0,1,0); f.BackgroundColor3=Color3.fromRGB(20,20,20); f.BackgroundTransparency=0.1; f.BorderSizePixel=0; f.Parent=df; Instance.new("UICorner",f).CornerRadius=UDim.new(0,10)
    local bd = Instance.new("UIStroke"); bd.Thickness=1; bd.Color=Color3.fromRGB(255,255,255); bd.Transparency=0.3; bd.Parent=f
    local btn = Instance.new("TextButton"); btn.BackgroundTransparency=1; btn.Text="FPS:060 PING:088ms"; btn.TextColor3=Color3.fromRGB(255,255,255); btn.TextSize=math.floor(14*scale); btn.Font=Enum.Font.Gotham; btn.TextXAlignment=Enum.TextXAlignment.Left; btn.TextYAlignment=Enum.TextYAlignment.Center; btn.Size=UDim2.new(1,0,1,0); btn.ZIndex=12; btn.Parent=f
    local function us() local tb=btn.TextBounds; df.Size=UDim2.new(0,tb.X+math.floor(12*scale),0,tb.Y+math.floor(10*scale)) end; us()
    local fc=0; local lt=os.clock()
    RS.RenderStepped:Connect(function() local now=os.clock(); local dt=now-lt; if dt>=1 then local fps=math.floor(fc/dt); local ping=0; pcall(function() ping=math.floor(St.Network.ServerStatsItem["Data Ping"]:GetValue()) end); btn.Text=string.format("FPS:%03d PING:%03dms",fps,ping); us(); fc=0; lt=now end; fc=fc+1 end)
    cam:GetPropertyChangedSignal("ViewportSize"):Connect(function() scale=gs(); bd.Thickness=math.max(1,math.floor(1*scale)); btn.TextSize=math.floor(14*scale); us() end)
    btn.MouseButton1Click:Connect(function() if onClick then onClick() end end)
    return df, btn
end