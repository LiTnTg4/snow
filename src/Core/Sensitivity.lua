getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.Sensitivity = {}
local Sensitivity = getgenv().SnowUI.Sensitivity
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local currentSensitivity = 1

function Sensitivity.Set(value)
    currentSensitivity = math.clamp(value, 0.1, 10)
end

function Sensitivity.Get()
    return currentSensitivity
end

function Sensitivity.Init()
    local player = Players.LocalPlayer
    local playerScripts = player:FindFirstChild("PlayerScripts")
    if playerScripts then
        local playerModule = playerScripts:FindFirstChild("PlayerModule")
        if playerModule then
            local cameraModule = playerModule:FindFirstChild("CameraModule")
            if cameraModule then
                local cameraInput = cameraModule:FindFirstChild("CameraInput")
                if cameraInput then
                    local camInputModule = require(cameraInput)
                    local orig = camInputModule.getRotation
                    camInputModule.getRotation = function(dr)
                        local rot = orig(dr)
                        if UserInputService.TouchEnabled then return rot * currentSensitivity end
                        return rot
                    end
                    return
                end
            end
        end
    end
    local oldIndex = hookmetamethod(game, "__index", function(self, key)
        if self == UserInputService and key == "MouseDelta" and UserInputService.TouchEnabled then
            return oldIndex(self, key) * currentSensitivity
        end
        return oldIndex(self, key)
    end)
end