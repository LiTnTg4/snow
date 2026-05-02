getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.Toast = {}
local T = getgenv().SnowUI.Toast
local P = game:GetService("Players")
local TS = game:GetService("TweenService")
function T.Show(title, msg, dur)
    dur = dur or 2
    local pg = P.LocalPlayer:WaitForChild("PlayerGui")
    local f = Instance.new("Frame"); f.Size=UDim2.new(0,260,0,60); f.Position=UDim2.new(0.5,-130,1,20); f.BackgroundColor3=Color3.fromRGB(20,20,26); f.BackgroundTransparency=1; f.BorderSizePixel=0; f.ZIndex=200; f.Parent=pg
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,8); c.Parent=f
    local s=Instance.new("UIStroke"); s.Color=Color3.fromRGB(100,130,255); s.Thickness=1; s.Transparency=0.5; s.Parent=f
    local tl=Instance.new("TextLabel"); tl.Size=UDim2.new(1,-20,0,22); tl.Position=UDim2.new(0,10,0,8); tl.BackgroundTransparency=1; tl.Text=title or "提示"; tl.TextColor3=Color3.fromRGB(255,255,255); tl.TextSize=14; tl.Font=Enum.Font.GothamBold; tl.ZIndex=201; tl.Parent=f
    local ml=Instance.new("TextLabel"); ml.Size=UDim2.new(1,-20,0,18); ml.Position=UDim2.new(0,10,0,32); ml.BackgroundTransparency=1; ml.Text=msg or ""; ml.TextColor3=Color3.fromRGB(180,180,190); ml.TextSize=12; ml.Font=Enum.Font.Gotham; ml.ZIndex=201; ml.Parent=f
    TS:Create(f,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Position=UDim2.new(0.5,-130,0.85,0),BackgroundTransparency=0.2}):Play()
    task.delay(dur,function() local tt=TS:Create(f,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Position=UDim2.new(0.5,-130,1,20),BackgroundTransparency=1}); tt.Completed:Connect(function() f:Destroy() end); tt:Play() end)
end