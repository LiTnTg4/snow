getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.Accessories = {}
local Accessories = getgenv().SnowUI.Accessories
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local slotConfig = getgenv().SnowUI.Config and getgenv().SnowUI.Config.SlotTypes or {
    {name="头发",type=Enum.AccessoryType.Hair},{name="帽子",type=Enum.AccessoryType.Hat},
    {name="面部",type=Enum.AccessoryType.Face},{name="颈部",type=Enum.AccessoryType.Neck},
    {name="肩部",type=Enum.AccessoryType.Shoulder},{name="胸部",type=Enum.AccessoryType.Front},
    {name="背部",type=Enum.AccessoryType.Back},{name="腰部",type=Enum.AccessoryType.Waist},
}

local visibility = {}
for _, config in ipairs(slotConfig) do visibility[config.type] = true end

function Accessories.IsVisible(accType) return visibility[accType] ~= false end
function Accessories.GetSlotConfig() return slotConfig end

function Accessories.Toggle(accType)
    visibility[accType] = not visibility[accType]
    Accessories.ApplyType(accType, visibility[accType])
    return visibility[accType]
end

function Accessories.ApplyType(accType, isVisible)
    local c = Players.LocalPlayer.Character
    if not c then return end
    for _, child in pairs(c:GetChildren()) do
        if child:IsA("Accessory") and child.AccessoryType == accType then
            pcall(function()
                local handle = child:FindFirstChild("Handle")
                if handle then
                    handle.Transparency = isVisible and 0 or 1
                end
            end)
        end
    end
end

function Accessories.RefreshAll()
    local c = Players.LocalPlayer.Character
    if not c then return end
    for _, config in ipairs(slotConfig) do
        for _, child in pairs(c:GetChildren()) do
            if child:IsA("Accessory") and child.AccessoryType == config.type then
                pcall(function()
                    local handle = child:FindFirstChild("Handle")
                    if handle then
                        handle.Transparency = visibility[config.type] and 0 or 1
                    end
                end)
            end
        end
    end
end

function Accessories.Init()
    local player = Players.LocalPlayer
    task.spawn(function()
        while true do
            pcall(function()
                local c = player.Character
                if c then
                    for _, child in pairs(c:GetChildren()) do
                        if child:IsA("Accessory") then
                            local handle = child:FindFirstChild("Handle")
                            if handle and not visibility[child.AccessoryType] and handle.Transparency ~= 1 then
                                handle.Transparency = 1
                            end
                        end
                    end
                end
            end)
            RunService.Heartbeat:Wait()
        end
    end)
    player.CharacterAdded:Connect(function(c)
        task.wait(0.5)
        Accessories.RefreshAll()
        c.ChildAdded:Connect(function(child)
            if child:IsA("Accessory") then
                if not visibility[child.AccessoryType] then
                    task.wait(0.5)
                    pcall(function()
                        local handle = child:FindFirstChild("Handle")
                        if handle then handle.Transparency = 1 end
                    end)
                end
            end
        end)
    end)
    if player.Character then Accessories.RefreshAll() end
end