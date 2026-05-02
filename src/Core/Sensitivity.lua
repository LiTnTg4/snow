getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.Sensitivity = {}
local S = getgenv().SnowUI.Sensitivity
local UIS = game:GetService("UserInputService")
local P = game:GetService("Players")
local cur = 1
function S.Set(v) cur = math.clamp(v, 0.1, 10) end
function S.Get() return cur end
function S.Init()
    local ps = P.LocalPlayer:FindFirstChild("PlayerScripts")
    if ps then
        local pm = ps:FindFirstChild("PlayerModule")
        if pm then
            local cm = pm:FindFirstChild("CameraModule")
            if cm then
                local ci = cm:FindFirstChild("CameraInput")
                if ci then
                    local cim = require(ci)
                    local orig = cim.getRotation
                    cim.getRotation = function(dr)
                        local rot = orig(dr)
                        if UIS.TouchEnabled then return rot * cur end
                        return rot
                    end
                    return
                end
            end
        end
    end
    pcall(function()
        local oi = hookmetamethod(game, "__index", function(self, key)
            if self == UIS and key == "MouseDelta" and UIS.TouchEnabled then return oi(self, key) * cur end
            return oi(self, key)
        end)
    end)
end