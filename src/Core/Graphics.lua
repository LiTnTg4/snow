getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.Graphics = {}
local Graphics = getgenv().SnowUI.Graphics
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local active = false
local savedMaterials = {}

function Graphics.IsActive() return active end

function Graphics.Toggle()
    active = not active
    if active then Graphics.Enable() else Graphics.Disable() end
    return active
end

function Graphics.Enable()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnabled = false
        for _, v in Lighting:GetChildren() do if v:IsA("PostEffect") then v.Enabled = false end end
    end)
    pcall(function()
        local ugs = game:GetService("UserSettings"):GetService("UserGameSettings")
        ugs.GraphicsQuality = Enum.GraphicsQuality.Level01
        ugs.RenderScale = 0.2
        ugs.Shadows = false
        ugs.TextureQuality = Enum.TextureQuality.Level01
    end)
    savedMaterials = {}
    local player = Players.LocalPlayer
    for _, o in ipairs(workspace:GetDescendants()) do
        pcall(function()
            if o:IsA("BasePart") and o.Parent ~= player.Character then
                savedMaterials[o] = o.Material
                o.Material = Enum.Material.Plastic
            end
            if o:IsA("Texture") or o:IsA("Decal") then o:Destroy() end
            if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") then o:Destroy() end
        end)
    end
end

function Graphics.Disable()
    pcall(function() Lighting.GlobalShadows = true; Lighting.FogEnabled = true end)
    pcall(function()
        local ugs = game:GetService("UserSettings"):GetService("UserGameSettings")
        ugs.GraphicsQuality = Enum.GraphicsQuality.Automatic
        ugs.RenderScale = 1; ugs.Shadows = true; ugs.TextureQuality = Enum.TextureQuality.Automatic
    end)
    for o, m in pairs(savedMaterials) do pcall(function() if o and o.Parent then o.Material = m end end) end
    savedMaterials = {}
end