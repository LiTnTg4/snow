-- 断腿系统
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local BrokenLegs = {}
local state = { r6 = false, r15 = false, r6Part = nil, r15Part = nil }

local function findPart(container, names)
    if not container then return nil end
    for _, name in ipairs(names) do
        local part = container:FindFirstChild(name)
        if part then return part end
    end
    return nil
end

local function createMeshPart(name)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = Vector3.new(0.832, 0.2496, 0.832)
    part.BrickColor = BrickColor.new("Medium stone grey")
    part.Material = Enum.Material.SmoothPlastic
    part.Anchored = true
    part.CanCollide = false
    part.Parent = workspace
    local m = Instance.new("SpecialMesh")
    m.MeshId = "http://www.roblox.com/asset/?id=902942096"
    m.TextureId = "http://www.roblox.com/asset/?id=902843398"
    m.Scale = Vector3.new(0.936, 0.9984, 0.936)
    m.Parent = part
    return part
end

function BrokenLegs.ToggleR6()
    state.r6 = not state.r6
    local player = Players.LocalPlayer
    if state.r6 then
        if player.Character then
            state.r6Part = createMeshPart("R6BrokenLeg")
        end
    else
        if state.r6Part then state.r6Part:Destroy(); state.r6Part = nil end
    end
    return state.r6
end

function BrokenLegs.ToggleR15()
    state.r15 = not state.r15
    local player = Players.LocalPlayer
    if state.r15 then
        if player.Character then
            state.r15Part = createMeshPart("R15BrokenLeg")
        end
    else
        if state.r15Part then state.r15Part:Destroy(); state.r15Part = nil end
    end
    return state.r15
end

function BrokenLegs.Init()
    local player = Players.LocalPlayer
    
    RunService.Heartbeat:Connect(function()
        local c = player.Character
        if not c then return end
        
        if state.r6 and state.r6Part then
            local upper = findPart(c, {"RightUpperLeg", "Right Leg"})
            if upper then state.r6Part.CFrame = upper.CFrame * CFrame.new(0, 0.7, 0) end
            local u = findPart(c, {"RightUpperLeg", "Right Leg"}); if u then u.Transparency = 1; u.CanCollide = false end
            local l = findPart(c, {"RightLowerLeg"}); if l then l.Transparency = 1; l.CanCollide = false end
            local f = findPart(c, {"RightFoot", "Right Foot"}); if f then f.Transparency = 1; f.CanCollide = false end
        end
        
        if state.r15 and state.r15Part then
            local upper = findPart(c, {"RightUpperLeg"})
            if upper then state.r15Part.CFrame = upper.CFrame * CFrame.new(0, 0.19, 0) end
            local u = findPart(c, {"RightUpperLeg"}); if u then u.Transparency = 1 end
            local l = findPart(c, {"RightLowerLeg"}); if l then l.Transparency = 1 end
            local f = findPart(c, {"RightFoot", "Right Foot"}); if f then f.Transparency = 1 end
        end
    end)
    
    player.CharacterAdded:Connect(function(c)
        task.wait(0.5)
        if state.r6 then state.r6Part = createMeshPart("R6BrokenLeg") end
        if state.r15 then state.r15Part = createMeshPart("R15BrokenLeg") end
    end)
end

return BrokenLegs