getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.Headless = {}
local H = getgenv().SnowUI.Headless
local P = game:GetService("Players")
local active = true
function H.IsActive() return active end
function H.Toggle() active = not active
    if not active and P.LocalPlayer.Character then
        local hd = P.LocalPlayer.Character:FindFirstChild("Head")
        if hd then hd.Transparency = 0; hd.CanCollide = true end
    end
    return active
end
function H.Init()
    task.spawn(function() while true do task.wait(1) if not active then continue end
        pcall(function()
            local c = P.LocalPlayer.Character
            if c then local hd = c:FindFirstChild("Head")
                if hd and hd.Transparency~=1 then hd.Transparency=1; hd.CanCollide=false end
                local fc = c:FindFirstChild("Face"); if fc then fc:Destroy() end
            end
        end)
    end end)
    P.LocalPlayer.CharacterAdded:Connect(function(c) if not active then return end task.wait(0.5)
        pcall(function() local hd = c:FindFirstChild("Head"); if hd then hd.Transparency=1; hd.CanCollide=false end end)
    end)
    pcall(function() local c = P.LocalPlayer.Character; if c then local hd = c:FindFirstChild("Head"); if hd and hd.Transparency~=1 then hd.Transparency=1; hd.CanCollide=false end end end)
end