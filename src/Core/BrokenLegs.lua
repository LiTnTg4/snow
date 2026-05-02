getgenv().SnowUI = getgenv().SnowUI or {}
getgenv().SnowUI.BrokenLegs = {}
local B = getgenv().SnowUI.BrokenLegs
local P = game:GetService("Players")
local RS = game:GetService("RunService")
local st = {r6=false, r15=false, r6p=nil, r15p=nil}
local function fp(c,n) if not c then return nil end for _,nm in ipairs(n) do local p=c:FindFirstChild(nm); if p then return p end end return nil end
local function mp(nm) local p=Instance.new("Part"); p.Name=nm; p.Size=Vector3.new(0.832,0.2496,0.832); p.BrickColor=BrickColor.new("Medium stone grey"); p.Material=Enum.Material.SmoothPlastic; p.Anchored=true; p.CanCollide=false; p.Parent=workspace; local m=Instance.new("SpecialMesh"); m.MeshId="http://www.roblox.com/asset/?id=902942096"; m.TextureId="http://www.roblox.com/asset/?id=902843398"; m.Scale=Vector3.new(0.936,0.9984,0.936); m.Parent=p; return p end
function B.ToggleR6() st.r6=not st.r6; if st.r6 then if P.LocalPlayer.Character then st.r6p=mp("R6BrokenLeg") end else if st.r6p then st.r6p:Destroy(); st.r6p=nil end end return st.r6 end
function B.ToggleR15() st.r15=not st.r15; if st.r15 then if P.LocalPlayer.Character then st.r15p=mp("R15BrokenLeg") end else if st.r15p then st.r15p:Destroy(); st.r15p=nil end end return st.r15 end
function B.Init()
    RS.Heartbeat:Connect(function() local c=P.LocalPlayer.Character; if not c then return end
        if st.r6 and st.r6p then local u=fp(c,{"RightUpperLeg","Right Leg"}); if u then st.r6p.CFrame=u.CFrame*CFrame.new(0,0.7,0) end
            local uu=fp(c,{"RightUpperLeg","Right Leg"}); if uu then uu.Transparency=1; uu.CanCollide=false end
            local ll=fp(c,{"RightLowerLeg"}); if ll then ll.Transparency=1; ll.CanCollide=false end
            local ff=fp(c,{"RightFoot","Right Foot"}); if ff then ff.Transparency=1; ff.CanCollide=false end end
        if st.r15 and st.r15p then local u=fp(c,{"RightUpperLeg"}); if u then st.r15p.CFrame=u.CFrame*CFrame.new(0,0.19,0) end
            local uu=fp(c,{"RightUpperLeg"}); if uu then uu.Transparency=1 end
            local ll=fp(c,{"RightLowerLeg"}); if ll then ll.Transparency=1 end
            local ff=fp(c,{"RightFoot","Right Foot"}); if ff then ff.Transparency=1 end end
    end)
    P.LocalPlayer.CharacterAdded:Connect(function(c) task.wait(0.5) if st.r6 then st.r6p=mp("R6BrokenLeg") end if st.r15 then st.r15p=mp("R15BrokenLeg") end end)
end