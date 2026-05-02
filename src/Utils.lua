getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.Utils = {}
local U = getgenv().SnowUI.Utils
local TS = game:GetService("TweenService")
function U.Create(className, props)
    local obj = Instance.new(className)
    for k, v in pairs(props) do
        if k == "Corner" then local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, v); c.Parent = obj
        else pcall(function() obj[k] = v end) end
    end
    return obj
end
function U.Tween(obj, props, duration, easing, direction)
    local t = TS:Create(obj, TweenInfo.new(duration or 0.2, easing or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out), props)
    t:Play(); return t
end