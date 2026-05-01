-- 无头系统
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Headless = {}
local active = true

function Headless.IsActive()
    return active
end

function Headless.Toggle()
    active = not active
    local player = Players.LocalPlayer
    if not active and player.Character then
        local head = player.Character:FindFirstChild("Head")
        if head then head.Transparency = 0; head.CanCollide = true end
    end
    return active
end

function Headless.Init()
    local player = Players.LocalPlayer
    
    task.spawn(function()
        while true do
            task.wait(1)
            if not active then continue end
            local c = player.Character
            if c then
                local head = c:FindFirstChild("Head")
                if head and head.Transparency ~= 1 then
                    head.Transparency = 1; head.CanCollide = false
                end
                local face = c:FindFirstChild("Face")
                if face then face:Destroy() end
            end
        end
    end)
    
    task.spawn(function()
        while true do
            task.wait(1)
            if not active then continue end
            local c = player.Character
            if c then
                for _, obj in c:GetDescendants() do
                    if obj:IsA("Decal") and obj.Name:lower():find("face") then obj:Destroy() end
                    if obj:IsA("Texture") and obj.Name:lower():find("face") then obj:Destroy() end
                end
            end
        end
    end)
    
    player.CharacterAdded:Connect(function(c)
        if not active then return end
        task.wait(0.5)
        local head = c:FindFirstChild("Head")
        if head then head.Transparency = 1; head.CanCollide = false end
    end)
    
    if player.Character then
        local head = player.Character:FindFirstChild("Head")
        if head and head.Transparency ~= 1 then head.Transparency = 1; head.CanCollide = false end
    end
end

return Headless