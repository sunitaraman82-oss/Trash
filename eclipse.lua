if _G.__NoamiUnload then pcall(_G.__NoamiUnload) end

do
    if getgenv and getgenv().__GV_SetmtBP ~= game
        and hookfunction and newcclosure and getrenv then
        getgenv().__GV_SetmtBP = game
        local ok = pcall(function()
            local old
            local rawget_, rawlen_, type_ = rawget, rawlen, type
            old = hookfunction(getrenv().setmetatable, newcclosure(function(t, mt)
                if type_(mt) == "table" and rawget_(mt, "__mode") == "kv"
                   and type_(t) == "table" and rawlen_(t) == 4
                   and type_(rawget_(t, 1)) == "table"
                   and rawget_(t, 2) == 1
                   and rawget_(t, 3) == "String"
                   and type_(rawget_(t, 4)) == "userdata" then
                    return old({ 1, 2, 3 }, {})
                end
                return old(t, mt)
            end))
        end)
        if not ok then getgenv().__GV_SetmtBP = nil end
    end
end

repeat task.wait() until game:IsLoaded()

if game.GameId ~= 6035872082 then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Rivals Script", Text = "This script is only for Rivals!", Duration = 5
    })
    return
end

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local Lighting          = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui        = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

local Conn = {}
local Draw = {}
local function track(c)  table.insert(Conn, c) return c end
local function td(d)     table.insert(Draw, d) return d end
local function untrack(d) local i = table.find(Draw, d); if i then table.remove(Draw, i) end end

local S = {
    AimEnabled=false, AimKey=Enum.UserInputType.MouseButton2, AimFOV=150,
    AimSmooth=15, AimTargetPart="Head", AimTeamCheck=true, AimWallCheck=true,
    AimMaxDist=500, AimShowFOV=true, AimFOVColor=Color3.fromRGB(255,60,60),
    AimPrediction=false,

    EspEnabled=false, EspBoxes=true, EspHealth=true, EspNames=true, EspDistance=true,
    EspTracers=false, EspSkeleton=false, EspTeamCheck=true, EspMaxDist=500,
    EspColor=Color3.fromRGB(0,180,255), EspLineThick=1,

    SpeedEnabled=false, SpeedValue=50, JumpEnabled=false, JumpValue=100, InfJump=false,

    AntiFlash=false, AntiSmoke=false, HitboxEnabled=false, HitboxSize=10,
    NightMode=false, FogEnabled=false, FogDistance=1000,

    TracerInstalled=false,
    TracerWidth=0.06, TracerFade=3,
}

local function isTeammate(plr)
    if not plr or plr == LocalPlayer then return false end
    local a, b = LocalPlayer:GetAttribute("TeamID"), plr:GetAttribute("TeamID")
    if a and b and a ~= 0 and a == b then return true end
    return plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team
end

local function isAlive(plr)
    local c = plr.Character
    if not c then return false end
    local h = c:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

local function getPart(plr, name)
    local c = plr.Character
    if not c then return nil end
    return c:FindFirstChild(name)
        or c:FindFirstChild("Head")
        or c:FindFirstChild("HumanoidRootPart")
end

local visParams = RaycastParams.new()
visParams.FilterType = Enum.RaycastFilterType.Exclude
visParams.IgnoreWater = true

local function isVisible(part)
    if not S.AimWallCheck or not part then return true end
    visParams.FilterDescendantsInstances = { LocalPlayer.Character, Camera }
    local origin = Camera.CFrame.Position
    local res = workspace:Raycast(origin, part.Position - origin, visParams)
    return res == nil or res.Instance:IsDescendantOf(part.Parent)
end

local FovCircle = td(Drawing.new("Circle"))
FovCircle.Thickness, FovCircle.Filled, FovCircle.NumSides, FovCircle.Transparency = 1.5, false, 64, 0.9
FovCircle.Visible = false

local function getClosestTarget()
    local vp = Camera.ViewportSize
    local center = Vector2.new(vp.X / 2, vp.Y / 2)
    local camPos = Camera.CFrame.Position
    local ping = LocalPlayer:GetNetworkPing()
    local best, bestScore = nil, math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isAlive(plr) and not (S.AimTeamCheck and isTeammate(plr)) then
            local part = getPart(plr, S.AimTargetPart)
            if part then
                local dist = (part.Position - camPos).Magnitude
                if dist <= S.AimMaxDist and isVisible(part) then
                    local goal = part.Position
                    if S.AimPrediction then
                        goal = goal + part.AssemblyLinearVelocity * ping
                    end
                    local sp, on = Camera:WorldToViewportPoint(goal)
                    if on then
                        local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        local score = d + dist * 0.1
                        if d <= S.AimFOV and score < bestScore then
                            best, bestScore = plr, score
                        end
                    end
                end
            end
        end
    end
    return best
end

local aimHeld, aimDownAt = false, 0

track(UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if S.AimEnabled and input.UserInputType == S.AimKey then
        aimHeld = true; aimDownAt = tick()
    end
end))
track(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == S.AimKey then aimHeld = false end
end))
local EspGui = Instance.new("ScreenGui")
EspGui.Name = "UltimateEspOverlay"
EspGui.ResetOnSpawn = false
EspGui.IgnoreGuiInset = true
EspGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
EspGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local EspCache = {}

local BONE_PAIRS = {
    {"Head","UpperTorso"}, {"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"}, {"LeftUpperArm","LeftLowerArm"}, {"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"}, {"RightUpperArm","RightLowerArm"}, {"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"}, {"LeftUpperLeg","LeftLowerLeg"}, {"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"}, {"RightUpperLeg","RightLowerLeg"}, {"RightLowerLeg","RightFoot"},
}

local function createEsp(plr)
    if EspCache[plr] then return end

    local bill = Instance.new("BillboardGui")
    bill.Name = "ESP_Bill"; bill.AlwaysOnTop = true
    bill.Size = UDim2.new(0, 130, 0, 60)
    bill.StudsOffset = Vector3.new(0, 3.2, 0)
    bill.ResetOnSpawn = false
    bill.Parent = EspGui

    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, 0, 0.5, 0)
    name.BackgroundTransparency = 1
    name.TextColor3 = S.EspColor
    name.Font = Enum.Font.GothamBold
    name.TextSize = 13
    name.TextStrokeTransparency = 0.4
    name.TextStrokeColor3 = Color3.new()
    name.Parent = bill

    local hpBg = Instance.new("Frame")
    hpBg.Size = UDim2.new(0.8, 0, 0, 4)
    hpBg.Position = UDim2.new(0.1, 0, 0.55, 0)
    hpBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
    hpBg.BorderSizePixel = 0
    Instance.new("UICorner", hpBg).CornerRadius = UDim.new(1, 0)
    hpBg.Parent = bill

    local hpBar = Instance.new("Frame")
    hpBar.Size = UDim2.new(1, 0, 1, 0)
    hpBar.BackgroundColor3 = Color3.fromRGB(80,220,80)
    hpBar.BorderSizePixel = 0
    Instance.new("UICorner", hpBar).CornerRadius = UDim.new(1, 0)
    hpBar.Parent = hpBg

    local dist = Instance.new("TextLabel")
    dist.Size = UDim2.new(1, 0, 0.35, 0)
    dist.Position = UDim2.new(0, 0, 0.65, 0)
    dist.BackgroundTransparency = 1
    dist.TextColor3 = Color3.fromRGB(180,180,180)
    dist.Font = Enum.Font.Code
    dist.TextSize = 10
    dist.TextStrokeTransparency = 0.5
    dist.TextStrokeColor3 = Color3.new()
    dist.Parent = bill

    local box = Instance.new("BoxHandleAdornment")
    box.AlwaysOnTop = true; box.ZIndex = 5
    box.Size = Vector3.new(4.5, 6.5, 4.5)
    box.Color3 = S.EspColor; box.Transparency = 0.4
    box.Visible = false; box.Parent = EspGui

    local skel = {}
    for i = 1, #BONE_PAIRS do
        local line = td(Drawing.new("Line"))
        line.Thickness = 1; line.Color = S.EspColor; line.Visible = false
        skel[i] = line
    end

    local tracer = td(Drawing.new("Line"))
    tracer.Thickness = S.EspLineThick
    tracer.Color = S.EspColor
    tracer.Visible = false

    EspCache[plr] = {
        bill = bill, name = name, hpBar = hpBar, dist = dist,
        box = box, skel = skel, tracer = tracer,
    }
end

local function removeEsp(plr)
    local d = EspCache[plr]
    if not d then return end
    if d.bill then d.bill:Destroy() end
    if d.box then d.box:Destroy() end
    for _, l in ipairs(d.skel) do l:Remove(); untrack(l) end
    d.tracer:Remove(); untrack(d.tracer)
    EspCache[plr] = nil
end

local function hookPlayer(plr)
    if plr == LocalPlayer then return end
    track(plr.CharacterAdded:Connect(function()
        task.wait(0.5)
        if S.EspEnabled then createEsp(plr) end
    end))
    track(plr.CharacterRemoving:Connect(function()
        local d = EspCache[plr]
        if d then
            d.bill.Enabled = false
            d.box.Visible = false
            for _, l in ipairs(d.skel) do l.Visible = false end
            d.tracer.Visible = false
        end
    end))
end
for _, plr in ipairs(Players:GetPlayers()) do hookPlayer(plr) end
track(Players.PlayerAdded:Connect(hookPlayer))
track(Players.PlayerRemoving:Connect(removeEsp))

local function renderEsp()
    if not S.EspEnabled then
        for _, d in pairs(EspCache) do
            d.bill.Enabled = false; d.box.Visible = false
            for _, l in ipairs(d.skel) do l.Visible = false end
            d.tracer.Visible = false
        end
        return
    end

    local localChar = LocalPlayer.Character
    local localHrp = localChar and localChar:FindFirstChild("HumanoidRootPart")
    local vp = Camera.ViewportSize
    local bottom = Vector2.new(vp.X / 2, vp.Y)

    for plr, d in pairs(EspCache) do
        local char = plr.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")

        local ok = char and hrp and hum and hum.Health > 0
        if ok and S.EspTeamCheck and isTeammate(plr) then ok = false end
        if ok and localHrp then
            ok = (hrp.Position - localHrp.Position).Magnitude <= S.EspMaxDist
        end

        if not ok then
            d.bill.Enabled = false; d.box.Visible = false
            for _, l in ipairs(d.skel) do l.Visible = false end
            d.tracer.Visible = false
            continue
        end

        d.bill.Adornee = hrp
        d.bill.Enabled = true
        d.name.Text = plr.DisplayName
        d.name.TextColor3 = S.EspColor
        d.name.Visible = S.EspNames

        d.hpBg.Visible = S.EspHealth
        if S.EspHealth then
            local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
            d.hpBar.Size = UDim2.new(pct, 0, 1, 0)
            d.hpBar.BackgroundColor3 = Color3.fromHSV(pct * 0.33, 0.9, 1)
        end

        d.dist.Visible = S.EspDistance
        if S.EspDistance and localHrp then
            d.dist.Text = math.floor((hrp.Position - localHrp.Position).Magnitude) .. " studs"
        end

        d.box.Visible = S.EspBoxes
        if S.EspBoxes then
            d.box.Adornee = hrp; d.box.Color3 = S.EspColor
        end

        if S.EspSkeleton then
            for i, pair in ipairs(BONE_PAIRS) do
                local p1, p2 = char:FindFirstChild(pair[1]), char:FindFirstChild(pair[2])
                local line = d.skel[i]
                if p1 and p2 then
                    local s1, o1 = Camera:WorldToViewportPoint(p1.Position)
                    local s2, o2 = Camera:WorldToViewportPoint(p2.Position)
                    if o1 and o2 then
                        line.From = Vector2.new(s1.X, s1.Y)
                        line.To   = Vector2.new(s2.X, s2.Y)
                        line.Color = S.EspColor
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            end
        else
            for _, l in ipairs(d.skel) do l.Visible = false end
        end

        if S.EspTracers then
            local head = char:FindFirstChild("Head") or hrp
            local sp, on = Camera:WorldToViewportPoint(head.Position)
            if on then
                d.tracer.From = bottom
                d.tracer.To   = Vector2.new(sp.X, sp.Y)
                d.tracer.Color = S.EspColor
                d.tracer.Thickness = S.EspLineThick
                d.tracer.Visible = true
            else
                d.tracer.Visible = false
            end
        else
            d.tracer.Visible = false
        end
    end
end

local function applyMovement()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if S.SpeedEnabled then
        if hum.WalkSpeed ~= S.SpeedValue then hum.WalkSpeed = S.SpeedValue end
    elseif hum.WalkSpeed ~= 16 then
        hum.WalkSpeed = 16
    end

    if S.JumpEnabled and hum.JumpPower ~= S.JumpValue then
        hum.JumpPower = S.JumpValue; hum.UseJumpPower = true
    end
end
track(RunService.Stepped:Connect(applyMovement))

track(UserInputService.JumpRequest:Connect(function()
    if S.InfJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))

local guiCache, guiCacheDirty = {}, true
local function invalidateGuiCache() guiCacheDirty = true end
track(LocalPlayer.PlayerGui.ChildAdded:Connect(invalidateGuiCache))
track(LocalPlayer.PlayerGui.ChildRemoved:Connect(invalidateGuiCache))

local function refreshGuiCache()
    table.clear(guiCache)
    for _, g in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
        if g:IsA("ScreenGui") or g:IsA("BillboardGui") then
            for _, d in ipairs(g:GetDescendants()) do
                if d:IsA("Frame") or d:IsA("ImageLabel") or d:IsA("ImageButton") then
                    local n = d.Name:lower()
                    if n:find("flash") or n:find("blind") or n:find("stun") or n:find("whiteout") then
                        table.insert(guiCache, d)
                    end
                end
            end
        end
    end
    guiCacheDirty = false
end

local function clearFlash()
    if not S.AntiFlash then return end
    if guiCacheDirty then refreshGuiCache() end
    for _, d in ipairs(guiCache) do
        if d.Parent then
            if d.Visible then d.Visible = false end
            if d:IsA("Frame") and d.BackgroundTransparency < 1 then d.BackgroundTransparency = 1 end
            if d:IsA("ImageLabel") or d:IsA("ImageButton") then
                if d.ImageTransparency < 1 then d.ImageTransparency = 1 end
            end
        end
    end
end

local function clearSmoke()
    if not S.AntiSmoke then return end
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.Name == "Smoke Grenade" and obj:IsA("Model") then
            for _, child in ipairs(obj:GetDescendants()) do
                if child:IsA("ParticleEmitter") then child.Enabled = false end
                if child:IsA("BasePart") then child.Transparency = 1 end
            end
        end
    end
end

local function applyNight()
    if S.NightMode then
        Lighting.TimeOfDay = "00:00:00"; Lighting.Brightness = 1
        Lighting.Ambient = Color3.fromRGB(20,20,30)
        Lighting.OutdoorAmbient = Color3.fromRGB(10,10,20)
    else
        Lighting.TimeOfDay = "14:00:00"; Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(128,128,128)
        Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
    end
end
local function applyFog()
    if S.FogEnabled then Lighting.FogStart = 0; Lighting.FogEnd = S.FogDistance
    else Lighting.FogEnd = 100000 end
end

local originalSizes = {}
local function restoreHitboxes()
    for part, size in pairs(originalSizes) do
        if part and part.Parent then part.Size = size end
    end
    table.clear(originalSizes)
end
local function updateHitboxes()
    if not S.HitboxEnabled then
        if next(originalSizes) then restoreHitboxes() end
        return
    end
    local s = S.HitboxSize
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isAlive(plr) and not isTeammate(plr) then
            local char = plr.Character
            for _, name in ipairs({"HitboxHead", "HitboxBody"}) do
                local part = char and char:FindFirstChild(name)
                if part and part:IsA("BasePart") then
                    if not originalSizes[part] then originalSizes[part] = part.Size end
                    part.Size = Vector3.new(s, s, s)
                    part.Transparency = 0.6
                    part.CanCollide = false
                end
            end
        end
    end
end

local Tracers = {}
local TRACER_MAX = 200

local function tryInstallTracers()
    if S.TracerInstalled then return true end
    local ok = pcall(function()
        local ctrl = LocalPlayer.PlayerScripts.Controllers:FindFirstChild("FighterController")
        if not ctrl then error("no controller") end
        local m = require(ctrl)
        if type(m._ShootEffect) ~= "function" then error("no effect") end
        if m._ShootEffect.__noami_hooked then S.TracerInstalled = true; return end

        local orig = m._ShootEffect
        m._ShootEffect = function(self, results)
            orig(self, results)
            pcall(function()
                local muzzle = self.ViewModel:GetMuzzlePosition()
                for _, res in pairs(results) do
                    local pos = res[utf8.char(0)]
                    if pos then
                        local a0 = Instance.new("Attachment"); a0.WorldPosition = muzzle; a0.Parent = workspace.Terrain
                        local a1 = Instance.new("Attachment"); a1.WorldPosition = pos;    a1.Parent = workspace.Terrain
                        local beam = Instance.new("Beam")
                        beam.Attachment0, beam.Attachment1 = a0, a1
                        beam.Width0, beam.Width1 = S.TracerWidth, S.TracerWidth * 0.5
                        beam.FaceCamera = true
                        beam.Color = ColorSequence.new(S.EspColor, Color3.new(1,1,1))
                        beam.Transparency = NumberSequence.new(0)
                        beam.LightEmission = 1
                        beam.Parent = workspace.Terrain
                        table.insert(Tracers, {beam = beam, a0 = a0, a1 = a1, born = tick()})
                        if #Tracers > TRACER_MAX then
                            local old = table.remove(Tracers, 1)
                            old.beam:Destroy(); old.a0:Destroy(); old.a1:Destroy()
                        end
                    end
                end
            end)
        end
        m._ShootEffect.__noami_hooked = true
        S.TracerInstalled = true
    end)
    return ok and S.TracerInstalled
end

task.spawn(function()
    for _ = 1, 60 do
        if tryInstallTracers() then break end
        task.wait(1)
    end
end)

local function updateTracers()
    if #Tracers == 0 then return end
    local now = tick()
    for i = #Tracers, 1, -1 do
        local t = Tracers[i]
        local age = now - t.born
        if age > S.TracerFade then
            t.beam:Destroy(); t.a0:Destroy(); t.a1:Destroy()
            table.remove(Tracers, i)
        else
            t.beam.Transparency = NumberSequence.new(age / S.TracerFade)
        end
    end
end

local lastSlow = 0
track(RunService.RenderStepped:Connect(function(dt)
    local vp = Camera.ViewportSize
    FovCircle.Position = Vector2.new(vp.X / 2, vp.Y / 2)
    FovCircle.Radius = S.AimFOV
    FovCircle.Color = S.AimFOVColor
    FovCircle.Visible = S.AimEnabled and S.AimShowFOV and aimHeld

    if S.AimEnabled and aimHeld and (tick() - aimDownAt) > 0.02 then
        local target = getClosestTarget()
        if target then
            local part = getPart(target, S.AimTargetPart)
            if part then
                local goal = part.Position
                if S.AimPrediction then
                    goal = goal + part.AssemblyLinearVelocity * LocalPlayer:GetNetworkPing()
                end
                Camera.CFrame = Camera.CFrame:Lerp(
                    CFrame.new(Camera.CFrame.Position, goal),
                    1 - math.clamp(S.AimSmooth / 100, 0, 0.95)
                )
            end
        end
    end

    renderEsp()
    updateTracers()

    local now = tick()
    if now - lastSlow > 0.1 then
        lastSlow = now
        clearFlash()
        clearSmoke()
        updateHitboxes()
    end
end))
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
    Title = "Ultimate Rivals", Footer = "Perf Rewrite | v6",
    NotifySide = "Right", ShowCustomCursor = true,
})

local Tabs = {
    Aimbot  = Window:AddTab("Aimbot", "crosshair"),
    Visuals = Window:AddTab("Visuals", "eye"),
    Movement = Window:AddTab("Movement", "run"),
    World   = Window:AddTab("World", "globe"),
    Misc    = Window:AddTab("Misc", "sparkles"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

local aimGroup = Tabs.Aimbot:AddLeftGroupbox("Aimbot", "crosshair")
aimGroup:AddToggle("A_Enabled", {Text="Enable Aimbot", Default=false, Callback=function(v) S.AimEnabled=v end})
aimGroup:AddSlider("A_FOV", {Text="FOV Radius", Default=150, Min=30, Max=600, Rounding=0, Callback=function(v) S.AimFOV=v end})
aimGroup:AddSlider("A_Smooth", {Text="Smoothing %", Default=15, Min=1, Max=90, Rounding=0, Callback=function(v) S.AimSmooth=v end})
aimGroup:AddSlider("A_MaxD", {Text="Max Distance", Default=500, Min=50, Max=1000, Rounding=0, Suffix=" studs", Callback=function(v) S.AimMaxDist=v end})
aimGroup:AddDropdown("A_Part", {Text="Target Part", Values={"Head","UpperTorso","HumanoidRootPart"}, Default="Head", Multi=false, Callback=function(v) S.AimTargetPart=v end})
aimGroup:AddDropdown("A_Key", {Text="Activation Key", Values={"MouseButton2","MouseButton1","E","Q"}, Default="MouseButton2", Multi=false, Callback=function(v)
    local map = {MouseButton2=Enum.UserInputType.MouseButton2, MouseButton1=Enum.UserInputType.MouseButton1}
    S.AimKey = map[v] or Enum.UserInputType.MouseButton2
end})
aimGroup:AddToggle("A_Pred", {Text="Velocity Prediction", Default=false, Callback=function(v) S.AimPrediction=v end})

local aimChecks = Tabs.Aimbot:AddRightGroupbox("Checks", "shield")
aimChecks:AddToggle("A_Team",  {Text="Team Check", Default=true, Callback=function(v) S.AimTeamCheck=v end})
aimChecks:AddToggle("A_Wall",  {Text="Wall Check", Default=true, Callback=function(v) S.AimWallCheck=v end})
aimChecks:AddToggle("A_ShowFOV", {Text="Show FOV Circle", Default=true, Callback=function(v) S.AimShowFOV=v end})
aimChecks:AddLabel("FOV Color"):AddColorPicker("A_FOVColor", {
    Default = Color3.fromRGB(255,60,60),
    Callback = function(c) S.AimFOVColor = c; FovCircle.Color = c end,
})

local espGroup = Tabs.Visuals:AddLeftGroupbox("Player ESP", "eye")
espGroup:AddToggle("E_Enabled", {Text="Enable ESP", Default=false, Callback=function(v)
    S.EspEnabled = v
    if v then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then createEsp(plr) end
        end
    else
        for plr in pairs(EspCache) do removeEsp(plr) end
    end
end})
espGroup:AddToggle("E_Boxes", {Text="Boxes", Default=true, Callback=function(v) S.EspBoxes=v end})
espGroup:AddToggle("E_Health", {Text="Health Bars", Default=true, Callback=function(v) S.EspHealth=v end})
espGroup:AddToggle("E_Names", {Text="Names", Default=true, Callback=function(v) S.EspNames=v end})
espGroup:AddToggle("E_Dist", {Text="Distance", Default=true, Callback=function(v) S.EspDistance=v end})
espGroup:AddToggle("E_Tracers", {Text="Tracers", Default=false, Callback=function(v) S.EspTracers=v end})
espGroup:AddToggle("E_Skel", {Text="Skeleton", Default=false, Callback=function(v) S.EspSkeleton=v end})
espGroup:AddToggle("E_Team", {Text="Team Check", Default=true, Callback=function(v) S.EspTeamCheck=v end})
espGroup:AddSlider("E_MaxD", {Text="Max Distance", Default=500, Min=50, Max=2000, Rounding=0, Suffix=" studs", Callback=function(v) S.EspMaxDist=v end})
espGroup:AddSlider("E_Line", {Text="Line Thickness", Default=1, Min=1, Max=5, Rounding=0, Callback=function(v) S.EspLineThick=v end})

local espColors = Tabs.Visuals:AddRightGroupbox("Colors", "palette")
espColors:AddLabel("Main Color"):AddColorPicker("E_Color", {
    Default = Color3.fromRGB(0,180,255),
    Callback = function(c)
        S.EspColor = c
        for _, d in pairs(EspCache) do
            d.name.TextColor3 = c; d.box.Color3 = c
            for _, l in ipairs(d.skel) do l.Color = c end
            d.tracer.Color = c
        end
    end,
})

local mv = Tabs.Movement:AddLeftGroupbox("Movement", "run")
mv:AddToggle("M_SpeedE", {Text="Enable Speed", Default=false, Callback=function(v) S.SpeedEnabled=v end})
mv:AddSlider("M_SpeedV", {Text="WalkSpeed", Default=50, Min=16, Max=300, Rounding=0, Callback=function(v) S.SpeedValue=v end})
mv:AddToggle("M_JumpE", {Text="Enable JumpPower", Default=false, Callback=function(v) S.JumpEnabled=v end})
mv:AddSlider("M_JumpV", {Text="JumpPower", Default=100, Min=50, Max=300, Rounding=0, Callback=function(v) S.JumpValue=v end})
mv:AddToggle("M_InfJump", {Text="Infinite Jump", Default=false, Callback=function(v) S.InfJump=v end})

local wg = Tabs.World:AddLeftGroupbox("World", "globe")
wg:AddToggle("W_Night", {Text="Night Mode", Default=false, Callback=function(v) S.NightMode=v; applyNight() end})
wg:AddToggle("W_FogE", {Text="Custom Fog", Default=false, Callback=function(v) S.FogEnabled=v; applyFog() end})
wg:AddSlider("W_FogD", {Text="Fog Distance", Default=1000, Min=100, Max=10000, Rounding=0, Callback=function(v) S.FogDistance=v; applyFog() end})

local mg = Tabs.Misc:AddLeftGroupbox("Misc", "sparkles")
mg:AddToggle("X_Flash", {Text="Anti Flashbang", Default=false, Callback=function(v) S.AntiFlash=v; invalidateGuiCache() end})
mg:AddToggle("X_Smoke", {Text="Anti Smoke", Default=false, Callback=function(v) S.AntiSmoke=v end})
mg:AddToggle("X_HitboxE", {Text="Hitbox Expander", Default=false, Callback=function(v) S.HitboxEnabled=v; if not v then restoreHitboxes() end end})
mg:AddSlider("X_HitboxS", {Text="Hitbox Size", Default=10, Min=1, Max=30, Rounding=1, Callback=function(v) S.HitboxSize=v end})

local tg = Tabs.Misc:AddRightGroupbox("Bullet Tracers", "zap")
tg:AddSlider("T_Width", {Text="Tracer Width", Default=6, Min=1, Max=20, Rounding=0, Callback=function(v) S.TracerWidth=v/100 end})
tg:AddSlider("T_Fade", {Text="Fade Time", Default=3, Min=1, Max=10, Rounding=0, Suffix="s", Callback=function(v) S.TracerFade=v end})
tg:AddButton({Text="Reinstall Tracer Hook", Func=function()
    S.TracerInstalled = false
    tryInstallTracers()
end})

SaveManager:SetLibrary(Library)
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("UltimateRivals")