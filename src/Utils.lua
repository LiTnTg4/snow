getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.Utils = {}
local Utils = getgenv().SnowUI.Utils
local TweenService = game:GetService("TweenService")

function Utils.Create(className, props)
    local obj = Instance.new(className)
    for k, v in pairs(props) do
        if k == "Corner" then
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, v)
            c.Parent = obj
        else
            obj[k] = v
        end
    end
    return obj
end

function Utils.Tween(obj, props, duration, easing, direction)
    duration = duration or 0.2
    easing = easing or Enum.EasingStyle.Quart
    direction = direction or Enum.EasingDirection.Out
    local t = TweenService:Create(obj, TweenInfo.new(duration, easing, direction), props)
    t:Play()
    return t
end