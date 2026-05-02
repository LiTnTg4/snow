getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.Graphics = {}
local G = getgenv().SnowUI.Graphics
local P = game:GetService("Players")
local L = game:GetService("Lighting")
local active = false
local sm = {}
function G.IsActive() return active end
function G.Toggle() active=not active; if active then G.Enable() else G.Disable() end; return active end
function G.Enable()
    pcall(function() L.GlobalShadows=false; L.FogEnabled=false; for _,v in L:GetChildren() do if v:IsA("PostEffect") then v.Enabled=false end end end)
    pcall(function() local u=game:GetService("UserSettings"):GetService("UserGameSettings"); u.GraphicsQuality=Enum.GraphicsQuality.Level01; u.RenderScale=0.2; u.Shadows=false; u.TextureQuality=Enum.TextureQuality.Level01 end)
    sm={}
    for _,o in ipairs(workspace:GetDescendants()) do pcall(function() if o:IsA("BasePart") and o.Parent~=P.LocalPlayer.Character then sm[o]=o.Material; o.Material=Enum.Material.Plastic end if o:IsA("Texture") or o:IsA("Decal") then o:Destroy() end if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") then o:Destroy() end end) end
end
function G.Disable()
    pcall(function() L.GlobalShadows=true; L.FogEnabled=true end)
    pcall(function() local u=game:GetService("UserSettings"):GetService("UserGameSettings"); u.GraphicsQuality=Enum.GraphicsQuality.Automatic; u.RenderScale=1; u.Shadows=true; u.TextureQuality=Enum.TextureQuality.Automatic end)
    for o,m in pairs(sm) do pcall(function() if o and o.Parent then o.Material=m end end) end; sm={}
end