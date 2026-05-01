-- 隐藏饰品系统
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Accessories = {}
local slotConfig = {
    { name = "头发", type = Enum.AccessoryType.Hair },
    { name = "帽子", type = Enum.AccessoryType.Hat },
    { name = "面部", type = Enum.AccessoryType.Face },
    { name = "颈部", type = Enum.AccessoryType.Neck },
    { name = "肩部", type = Enum.AccessoryType.Shoulder },
    { name = "胸部", type = Enum.AccessoryType.Front },
    { name = "背部", type = Enum.AccessoryType.Back },
    { name = "腰部", type = Enum.AccessoryType.Waist },
}

local visibility = {}
for _, config in ipairs(slotConfig) do
    visibility[config.type] = true
end

function Accessories.IsVisible(accType)
    return visibility[accType] ~= false
end

function Accessories.Toggle(accType)
    visibility[accType] = not visibility[accType]
    Accessories.ApplyType(accType, visibility[accType])
    return visibility[accType]
end

function Accessories.GetSlotConfig()
    return slotConfig
end

function Accessories.ApplyType(accType, isVisible)
    local player = Players.LocalPlayer
    local c = player.Character
    if not c then return end
    for _, child in pairs(c:GetChildren()) do
        if child:IsA("Accessory") and child.AccessoryType == accType then
            if child:FindFirstChild("Handle") then
                child.Handle.Transparency = isVisible and 0 or 1
            end
        end
    end
end

function Accessories.RefreshAll()
    local player = Players.LocalPlayer
    local c = player.Character
    if not c then return end
    for _, config in ipairs(slotConfig) do
        for _, child in pairs(c:GetChildren()) do
            if child:IsA("Accessory") and child.AccessoryType == config.type then
                if child:FindFirstChild("Handle") then
                    child.Handle.Transparency = visibility[config.type] and 0 or 1
                end
            end
        end
    end
end

function Accessories.Init()
    local player = Players.LocalPlayer
    
    -- 防篡改守护
    task.spawn(function()
        while true do
            local c = player.Character
            if c then
                for _, child in pairs(c:GetChildren()) do
                    if child:IsA("Accessory") and child:FindFirstChild("Handle") then
                        if not visibility[child.AccessoryType] and child.Handle.Transparency ~= 1 then
                            child.Handle.Transparency = 1
                        end
                    end
                end
            end
            RunService.Heartbeat:Wait()
        end
    end)
    
    player.CharacterAdded:Connect(function(c)
        c:WaitForChild("Head", 5)
        Accessories.RefreshAll()
        c.ChildAdded:Connect(function(child)
            if child:IsA("Accessory") then
                if not visibility[child.AccessoryType] then
                    child:WaitForChild("Handle", 2)
                    if child:FindFirstChild("Handle") then
                        child.Handle.Transparency = 1
                    end
                end
            end
        end)
    end)
    
    if player.Character then Accessories.RefreshAll() end
end

return Accessories