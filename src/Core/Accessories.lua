getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.Accessories = {}
local A = getgenv().SnowUI.Accessories
local P = game:GetService("Players")
local RS = game:GetService("RunService")
local sc = getgenv().SnowUI.Config and getgenv().SnowUI.Config.SlotTypes or {{name="头发",type=Enum.AccessoryType.Hair},{name="帽子",type=Enum.AccessoryType.Hat},{name="面部",type=Enum.AccessoryType.Face},{name="颈部",type=Enum.AccessoryType.Neck},{name="肩部",type=Enum.AccessoryType.Shoulder},{name="胸部",type=Enum.AccessoryType.Front},{name="背部",type=Enum.AccessoryType.Back},{name="腰部",type=Enum.AccessoryType.Waist}}
local vis = {}
for _,c in ipairs(sc) do vis[c.type]=true end
function A.IsVisible(t) return vis[t]~=false end
function A.GetSlotConfig() return sc end
function A.Toggle(t) vis[t]=not vis[t]; A.ApplyType(t,vis[t]); return vis[t] end
function A.ApplyType(t,v) local c=P.LocalPlayer.Character; if not c then return end for _,ch in pairs(c:GetChildren()) do if ch:IsA("Accessory") and ch.AccessoryType==t then pcall(function() local h=ch:FindFirstChild("Handle"); if h then h.Transparency=v and 0 or 1 end end) end end end
function A.RefreshAll() local c=P.LocalPlayer.Character; if not c then return end for _,cfg in ipairs(sc) do for _,ch in pairs(c:GetChildren()) do if ch:IsA("Accessory") and ch.AccessoryType==cfg.type then pcall(function() local h=ch:FindFirstChild("Handle"); if h then h.Transparency=vis[cfg.type] and 0 or 1 end end) end end end end
function A.Init()
    task.spawn(function() while true do pcall(function() local c=P.LocalPlayer.Character; if c then for _,ch in pairs(c:GetChildren()) do if ch:IsA("Accessory") then local h=ch:FindFirstChild("Handle"); if h and not vis[ch.AccessoryType] and h.Transparency~=1 then h.Transparency=1 end end end end end) RS.Heartbeat:Wait() end end)
    P.LocalPlayer.CharacterAdded:Connect(function(c) task.wait(0.5) A.RefreshAll() c.ChildAdded:Connect(function(ch) if ch:IsA("Accessory") then if not vis[ch.AccessoryType] then task.wait(0.5) pcall(function() local h=ch:FindFirstChild("Handle"); if h then h.Transparency=1 end end) end end end) end)
    if P.LocalPlayer.Character then A.RefreshAll() end
end