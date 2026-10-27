-- ╔══════════════════════════════════════════════════════════╗
-- ║   ULTIMATE RIVALS SCRIPT — Part 1/3                     ║
-- ╚══════════════════════════════════════════════════════════╝

-- AC BYPASS (setmetatable hook)
do
    if getgenv and getgenv().__GV_SetmtBP ~= game
        and hookfunction and newcclosure and getrenv then
        getgenv().__GV_SetmtBP = game
        local ok = pcall(function()
            local oldsetmt
            local rawget_, rawlen_, type_ = rawget, rawlen, type
            oldsetmt = hookfunction(getrenv().setmetatable, newcclosure(function(t, mt)
                if type_(mt) == "table" and rawget_(mt, "__mode") == "kv"
                   and type_(t) == "table" and rawlen_(t) == 4
                   and type_(rawget_(t, 1)) == "table"
                   and rawget_(t, 2) == 1
                   and rawget_(t, 3) == "String"
                   and type_(rawget_(t, 4)) == "userdata" then
                    return oldsetmt({ 1, 2, 3 }, {})
                end
                return oldsetmt(t, mt)
            end))
        end)
        if not ok then getgenv().__GV_SetmtBP = nil end
    end
end

repeat task.wait() until game:IsLoaded()

if game.GameId ~= 6035872082 then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Rivals Script",
        Text = "This script is only for Rivals!",
        Duration = 5
    })
    return
end

-- SERVICES
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local Lighting          = game:GetService("Lighting")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService       = game:GetService("HttpService")
local StarterGui        = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

-- SETTINGS
local Settings = {
    AimEnabled     = false,
    AimKey         = Enum.UserInputType.MouseButton2,
    AimFOV         = 150,
    AimSmooth      = 0.15,
    AimTargetPart  = "Head",
    AimTeamCheck   = true,
    AimWallCheck   = true,
    AimMaxDist     = 500,
    AimShowFOV     = true,
    AimFOVColor    = Color3.fromRGB(255, 60, 60),

    EspEnabled     = false,
    EspBoxes       = true,
    EspFilledBoxes = false,
    EspHealth      = true,
    EspNames       = true,
    EspDistance    = true,
    EspTracers     = false,
    EspSkeleton    = false,
    EspChams       = false,
    EspGlowChams   = false,
    EspTeamCheck   = true,
    EspMaxDist     = 500,
    EspColor       = Color3.fromRGB(0, 180, 255),
    EspChamsColor  = Color3.fromRGB(0, 255, 255),
    EspGlowColor   = Color3.fromRGB(0, 255, 255),
    EspBoxThick    = 1.5,
    EspLineThick   = 1,

    SpeedEnabled   = false,
    SpeedValue     = 50,
    JumpEnabled    = false,
    JumpValue      = 100,
    InfJump        = false,

    AntiFlash      = false,
    AntiSmoke      = false,
    AntiSpectate   = false,
    HitboxEnabled  = false,
    HitboxSize     = 10,

    NightMode      = false,
    FogEnabled     = false,
    FogDistance    = 1000,

    TracerColor1   = Color3.fromRGB(255, 105, 180),
    TracerColor2   = Color3.fromRGB(255, 255, 255),
    TracerFade     = 3,
    TracerWidth    = 0.06,
    TracerRainbow  = false,
}

-- UTILITIES
local function isTeammate(plr)
    if not plr or plr == LocalPlayer then return false end
    local myTeam    = LocalPlayer:GetAttribute("TeamID")
    local theirTeam = plr:GetAttribute("TeamID")
    if myTeam and theirTeam and myTeam ~= 0 and myTeam == theirTeam then
        return true
    end
    if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
        return true
    end
    return false
end

local function getChar(plr) return plr and plr.Character end

local function isAlive(plr)
    local c = getChar(plr)
    if not c then return false end
    local h = c:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

local function getTargetPart(plr, partName)
    local c = getChar(plr)
    if not c then return nil end
    return c:FindFirstChild(partName)
        or c:FindFirstChild("Head")
        or c:FindFirstChild("HumanoidRootPart")
end

-- ╔══════════════════════════════════════════════════════════╗
-- ║   ULTIMATE RIVALS SCRIPT — Part 2/3                     ║
-- ╚══════════════════════════════════════════════════════════╝

-- AIMBOT
local FovCircle = Drawing.new("Circle")
FovCircle.Thickness    = 1.5
FovCircle.Color        = Settings.AimFOVColor
FovCircle.Filled       = false
FovCircle.NumSides     = 64
FovCircle.Visible      = false
FovCircle.Transparency = 0.9

local aimHeld, aimDownAt = false, 0

local function isVisible(part)
    if not Settings.AimWallCheck then return true end
    if not part then return false end
    local origin = Camera.CFrame.Position
    local dir    = part.Position - origin
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { LocalPlayer.Character, Camera }
    params.IgnoreWater = true
    local res = workspace:Raycast(origin, dir, params)
    if not res then return true end
    return res.Instance:IsDescendantOf(part.Parent)
end

local function getClosestTarget()
    local best, bestDist = nil, math.huge
    local vp = Camera.ViewportSize
    local center = Vector2.new(vp.X / 2, vp.Y / 2)
    local camPos = Camera.CFrame.Position

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isAlive(plr) then
            if not (Settings.AimTeamCheck and isTeammate(plr)) then
                local part = getTargetPart(plr, Settings.AimTargetPart)
                if part then
                    local dist3D = (part.Position - camPos).Magnitude
                    if dist3D <= Settings.AimMaxDist then
                        if isVisible(part) then
                            local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                            if onScreen then
                                local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                                if d <= Settings.AimFOV and d < bestDist then
                                    best, bestDist = plr, d
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

-- ESP
local EspGui = Instance.new("ScreenGui")
EspGui.Name = "UltimateEspOverlay"
EspGui.ResetOnSpawn = false
EspGui.IgnoreGuiInset = true
EspGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
EspGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local EspCache = {}

local function createEspObjects(plr)
    if EspCache[plr] then return end

    local bill = Instance.new("BillboardGui")
    bill.Name = "ESP_Bill"
    bill.AlwaysOnTop = true
    bill.Size = UDim2.new(0, 130, 0, 60)
    bill.StudsOffset = Vector3.new(0, 3.2, 0)
    bill.ResetOnSpawn = false
    bill.Parent = EspGui

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, 0, 0.5, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.TextColor3 = Settings.EspColor
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 13
    nameLbl.TextStrokeTransparency = 0.4
    nameLbl.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLbl.Parent = bill

    local hpBg = Instance.new("Frame")
    hpBg.Size = UDim2.new(0.8, 0, 0, 4)
    hpBg.Position = UDim2.new(0.1, 0, 0.55, 0)
    hpBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    hpBg.BorderSizePixel = 0
    Instance.new("UICorner", hpBg).CornerRadius = UDim.new(1, 0)
    hpBg.Parent = bill

    local hpBar = Instance.new("Frame")
    hpBar.Size = UDim2.new(1, 0, 1, 0)
    hpBar.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
    hpBar.BorderSizePixel = 0
    Instance.new("UICorner", hpBar).CornerRadius = UDim.new(1, 0)
    hpBar.Parent = hpBg

    local distLbl = Instance.new("TextLabel")
    distLbl.Size = UDim2.new(1, 0, 0.35, 0)
    distLbl.Position = UDim2.new(0, 0, 0.65, 0)
    distLbl.BackgroundTransparency = 1
    distLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    distLbl.Font = Enum.Font.Code
    distLbl.TextSize = 10
    distLbl.TextStrokeTransparency = 0.5
    distLbl.TextStrokeColor3 = Color3.new(0, 0, 0)
    distLbl.Parent = bill

    local box = Instance.new("BoxHandleAdornment")
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Size = Vector3.new(4.5, 6.5, 4.5)
    box.Color3 = Settings.EspColor
    box.Transparency = 0
    box.Visible = false
    box.Parent = EspGui

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Settings.EspChamsColor
    highlight.FillTransparency = 0.7
    highlight.OutlineColor = Settings.EspChamsColor
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = false
    highlight.Parent = EspGui

    local glow = Instance.new("Highlight")
    glow.FillColor = Settings.EspGlowColor
    glow.FillTransparency = 0.8
    glow.OutlineColor = Settings.EspGlowColor
    glow.OutlineTransparency = 0
    glow.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    glow.Enabled = false
    glow.Parent = EspGui

    local tracer = Drawing.new("Line")
    tracer.Thickness = Settings.EspLineThick
    tracer.Visible = false
    tracer.Color = Settings.EspColor

    local skeleton = {}
    for i = 1, 14 do
        local line = Drawing.new("Line")
        line.Thickness = 1.5
        line.Color = Settings.EspColor
        line.Visible = false
        skeleton[i] = line
    end

    EspCache[plr] = {
        bill = bill, nameLbl = nameLbl,
        hpBg = hpBg, hpBar = hpBar,
        distLbl = distLbl, box = box,
        highlight = highlight, glow = glow,
        tracer = tracer, skeleton = skeleton
    }
end

local function removeEsp(plr)
    local d = EspCache[plr]
    if not d then return end
    if d.bill      then d.bill:Destroy() end
    if d.box       then d.box:Destroy() end
    if d.highlight then d.highlight:Destroy() end
    if d.glow      then d.glow:Destroy() end
    if d.tracer    then d.tracer:Remove() end
    if d.skeleton then
        for _, l in ipairs(d.skeleton) do l:Remove() end
    end
    EspCache[plr] = nil
end

local BONE_PAIRS = {
    {"Head","UpperTorso"}, {"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"}, {"LeftUpperArm","LeftLowerArm"}, {"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"}, {"RightUpperArm","RightLowerArm"}, {"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"}, {"LeftUpperLeg","LeftLowerLeg"}, {"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"}, {"RightUpperLeg","RightLowerLeg"}, {"RightLowerLeg","RightFoot"},
}

local function updateSkeleton(data, char)
    if not Settings.EspSkeleton then
        for _, l in ipairs(data.skeleton) do l.Visible = false end
        return
    end
    for i, pair in ipairs(BONE_PAIRS) do
        local p1, p2 = char:FindFirstChild(pair[1]), char:FindFirstChild(pair[2])
        local line = data.skeleton[i]
        if p1 and p2 and line then
            local s1, o1 = Camera:WorldToViewportPoint(p1.Position)
            local s2, o2 = Camera:WorldToViewportPoint(p2.Position)
            if o1 and o2 then
                line.From = Vector2.new(s1.X, s1.Y)
                line.To   = Vector2.new(s2.X, s2.Y)
                line.Color = Settings.EspColor
                line.Visible = true
            else
                line.Visible = false
            end
        elseif line then
            line.Visible = false
        end
    end
end

local function updateAllEsp()
    local localChar = LocalPlayer.Character
    local localHrp  = localChar and localChar:FindFirstChild("HumanoidRootPart")
    local vp        = Camera.ViewportSize
    local screenCenter = Vector2.new(vp.X / 2, vp.Y)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if not EspCache[plr] then createEspObjects(plr) end
            local data = EspCache[plr]
            if not data then continue end

            local char = plr.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            local hum  = char and char:FindFirstChildOfClass("Humanoid")

            local enabled = Settings.EspEnabled and char and hrp and hum and hum.Health > 0
            if enabled and Settings.EspTeamCheck and isTeammate(plr) then
                enabled = false
            end
            if enabled and localHrp then
                enabled = (hrp.Position - localHrp.Position).Magnitude <= Settings.EspMaxDist
            end

            data.bill.Enabled      = enabled
            data.box.Visible       = enabled and Settings.EspBoxes
            data.highlight.Enabled = enabled and Settings.EspChams
            data.glow.Enabled      = enabled and Settings.EspGlowChams
            data.tracer.Visible    = false

            if enabled then
                data.bill.Adornee = hrp
                data.nameLbl.Visible  = Settings.EspNames
                data.nameLbl.Text     = plr.DisplayName
                data.nameLbl.TextColor3 = Settings.EspColor
                data.hpBg.Visible     = Settings.EspHealth
                data.distLbl.Visible  = Settings.EspDistance

                if Settings.EspHealth then
                    local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                    data.hpBar.Size = UDim2.new(pct, 0, 1, 0)
                    data.hpBar.BackgroundColor3 = Color3.new(
                        math.clamp(2 * (1 - pct), 0, 1),
                        math.clamp(2 * pct, 0, 1), 0.1
                    )
                end

                if Settings.EspDistance and localHrp then
                    local dist = math.floor((hrp.Position - localHrp.Position).Magnitude)
                    data.distLbl.Text = dist .. " studs"
                end

                if Settings.EspBoxes then
                    data.box.Adornee = hrp
                    data.box.Color3 = Settings.EspColor
                end

                if Settings.EspChams then
                    data.highlight.Adornee = char
                    data.highlight.FillColor = Settings.EspChamsColor
                    data.highlight.OutlineColor = Settings.EspChamsColor
                end

                if Settings.EspGlowChams then
                    data.glow.Adornee = char
                    data.glow.FillColor = Settings.EspGlowColor
                    data.glow.OutlineColor = Settings.EspGlowColor
                end

                if Settings.EspTracers then
                    local head = char:FindFirstChild("Head") or hrp
                    local sp, on = Camera:WorldToViewportPoint(head.Position)
                    if on then
                        data.tracer.From = screenCenter
                        data.tracer.To   = Vector2.new(sp.X, sp.Y)
                        data.tracer.Color = Settings.EspColor
                        data.tracer.Thickness = Settings.EspLineThick
                        data.tracer.Visible = true
                    end
                end

                updateSkeleton(data, char)
            else
                for _, l in ipairs(data.skeleton) do l.Visible = false end
            end
        end
    end
end

-- MOVEMENT
local function applyMovement()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if Settings.SpeedEnabled then
        if hum.WalkSpeed ~= Settings.SpeedValue then hum.WalkSpeed = Settings.SpeedValue end
    else
        if hum.WalkSpeed ~= 16 then hum.WalkSpeed = 16 end
    end

    if Settings.JumpEnabled then
        if hum.JumpPower ~= Settings.JumpValue then
            hum.JumpPower = Settings.JumpValue
            hum.UseJumpPower = true
        end
    end
end

UserInputService.JumpRequest:Connect(function()
    if Settings.InfJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- MISC
local function clearFlashbang()
    if not Settings.AntiFlash then return end
    for _, g in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
        for _, d in ipairs(g:GetDescendants()) do
            if d:IsA("Frame") or d:IsA("ImageLabel") then
                local n = d.Name:lower()
                if n:find("flash") or n:find("blind") or n:find("stun") or n:find("whiteout") then
                    d.Visible = false
                end
            end
        end
    end
end

local function clearSmoke()
    if not Settings.AntiSmoke then return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Smoke Grenade" and obj:IsA("Model") then
            for _, child in ipairs(obj:GetDescendants()) do
                if child:IsA("ParticleEmitter") then child.Enabled = false end
                if child:IsA("BasePart") or child:IsA("Decal") then child.Transparency = 1 end
            end
        end
    end
end

local function applyNightMode()
    if Settings.NightMode then
        Lighting.TimeOfDay = "00:00:00"
        Lighting.Brightness = 1
        Lighting.Ambient = Color3.fromRGB(20, 20, 30)
        Lighting.OutdoorAmbient = Color3.fromRGB(10, 10, 20)
    else
        Lighting.TimeOfDay = "14:00:00"
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end

local function applyFog()
    if Settings.FogEnabled then
        Lighting.FogStart = 0
        Lighting.FogEnd = Settings.FogDistance
    else
        Lighting.FogEnd = 100000
    end
end

-- HITBOX EXPANDER
local originalSizes = {}

local function restoreHitboxes()
    for part, size in pairs(originalSizes) do
        if part and part.Parent then part.Size = size end
    end
    originalSizes = {}
end

local function updateHitboxes()
    if not Settings.HitboxEnabled then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isAlive(plr) and not isTeammate(plr) then
            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if not originalSizes[hrp] then originalSizes[hrp] = hrp.Size end
                hrp.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                hrp.Transparency = 0.5
                hrp.CanCollide = false
            end
        end
    end
end

-- TRACERS
local Tracers = {}
local tracerOrig = nil

local function installTracers()
    local fighterCtrl = LocalPlayer.PlayerScripts.Controllers:FindFirstChild("FighterController")
    if not fighterCtrl then return end
    local module = require(fighterCtrl)
    if module._ShootEffect and not tracerOrig then
        tracerOrig = module._ShootEffect
        module._ShootEffect = function(self, results)
            tracerOrig(self, results)
            local muzzle = self.ViewModel:GetMuzzlePosition()
            for _, res in pairs(results) do
                local pos = res[utf8.char(0)]
                if pos then
                    local a0 = Instance.new("Attachment")
                    a0.WorldPosition = muzzle
                    a0.Parent = workspace.Terrain
                    local a1 = Instance.new("Attachment")
                    a1.WorldPosition = pos
                    a1.Parent = workspace.Terrain
                    local beam = Instance.new("Beam")
                    beam.Attachment0 = a0
                    beam.Attachment1 = a1
                    beam.Width0 = Settings.TracerWidth
                    beam.Width1 = Settings.TracerWidth * 0.5
                    beam.FaceCamera = true
                    beam.Color = ColorSequence.new(Settings.TracerColor1, Settings.TracerColor2)
                    beam.Transparency = NumberSequence.new(0)
                    beam.LightEmission = 1
                    beam.Parent = workspace.Terrain
                    table.insert(Tracers, {beam = beam, a0 = a0, a1 = a1, born = tick()})
                end
            end
        end
    end
end

local function updateTracers()
    local now = tick()
    for i = #Tracers, 1, -1 do
        local t = Tracers[i]
        local age = now - t.born
        if age > Settings.TracerFade then
            t.beam:Destroy(); t.a0:Destroy(); t.a1:Destroy()
            table.remove(Tracers, i)
        else
            local alpha = age / Settings.TracerFade
            t.beam.Transparency = NumberSequence.new(alpha)
            if Settings.TracerRainbow then
                t.beam.Color = ColorSequence.new(Color3.fromHSV((now * 0.5) % 1, 1, 1))
            end
        end
    end
end

-- INPUT
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if Settings.AimEnabled and input.UserInputType == Settings.AimKey then
        aimHeld = true
        aimDownAt = tick()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Settings.AimKey then
        aimHeld = false
    end
end)

-- MAIN LOOPS
RunService.RenderStepped:Connect(function()
    local vp = Camera.ViewportSize
    FovCircle.Position = Vector2.new(vp.X / 2, vp.Y / 2)
    FovCircle.Radius   = Settings.AimFOV
    FovCircle.Color    = Settings.AimFOVColor
    FovCircle.Visible  = Settings.AimEnabled and Settings.AimShowFOV and aimHeld

    if Settings.AimEnabled and aimHeld and (tick() - aimDownAt) > 0.02 then
        local target = getClosestTarget()
        if target then
            local part = getTargetPart(target, Settings.AimTargetPart)
            if part then
                Camera.CFrame = Camera.CFrame:Lerp(
                    CFrame.new(Camera.CFrame.Position, part.Position),
                    1 - math.clamp(Settings.AimSmooth, 0, 0.95)
                )
            end
        end
    end

    updateAllEsp()
    updateHitboxes()
    updateTracers()
    clearFlashbang()
    clearSmoke()
end)

RunService.Heartbeat:Connect(function()
    applyMovement()
end)

-- PLAYER MANAGEMENT
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(function()
            task.wait(1)
            if Settings.EspEnabled then createEspObjects(plr) end
        end)
        plr.CharacterRemoving:Connect(function() removeEsp(plr) end)
    end
end
Players.PlayerAdded:Connect(function(plr)
    if plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(function()
            task.wait(1)
            if Settings.EspEnabled then createEspObjects(plr) end
        end)
        plr.CharacterRemoving:Connect(function() removeEsp(plr) end)
    end
end)
Players.PlayerRemoving:Connect(removeEsp)

-- ╔══════════════════════════════════════════════════════════╗
-- ║   ULTIMATE RIVALS SCRIPT — Part 3/3                     ║
-- ╚══════════════════════════════════════════════════════════╝

-- UI
local Library      = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
    Title = "Ultimate Rivals",
    Footer = "AC-Bypassed | v5",
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Aimbot  = Window:AddTab("Aimbot", "crosshair"),
    Visuals = Window:AddTab("Visuals", "eye"),
    Movement = Window:AddTab("Movement", "run"),
    World   = Window:AddTab("World", "globe"),
    Misc    = Window:AddTab("Misc", "sparkles"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

-- Aimbot Tab
local AimGroup = Tabs.Aimbot:AddLeftGroupbox("Aimbot", "crosshair")
AimGroup:AddToggle("AimEnabled", { Text = "Enable Aimbot", Default = false, Callback = function(v) Settings.AimEnabled = v end })
AimGroup:AddSlider("AimFOV",     { Text = "FOV Radius", Default = 150, Min = 30, Max = 600, Rounding = 0, Callback = function(v) Settings.AimFOV = v end })
AimGroup:AddSlider("AimSmooth",  { Text = "Smoothing", Default = 15, Min = 1, Max = 90, Rounding = 0, Suffix = "%", Callback = function(v) Settings.AimSmooth = v / 100 end })
AimGroup:AddSlider("AimMaxDist", { Text = "Max Distance", Default = 500, Min = 50, Max = 1000, Rounding = 0, Suffix = " studs", Callback = function(v) Settings.AimMaxDist = v end })
AimGroup:AddDropdown("AimPart",  { Text = "Target Part", Values = {"Head","UpperTorso","HumanoidRootPart"}, Default = "Head", Multi = false, Callback = function(v) Settings.AimTargetPart = v end })
AimGroup:AddDropdown("AimKey",   { Text = "Activation Key", Values = {"MouseButton2","MouseButton1","E","Q"}, Default = "MouseButton2", Multi = false, Callback = function(v)
    local map = { MouseButton2 = Enum.UserInputType.MouseButton2, MouseButton1 = Enum.UserInputType.MouseButton1 }
    Settings.AimKey = map[v] or Enum.UserInputType.MouseButton2
end })

local AimChecks = Tabs.Aimbot:AddRightGroupbox("Checks", "shield")
AimChecks:AddToggle("AimTeamCheck", { Text = "Team Check", Default = true, Callback = function(v) Settings.AimTeamCheck = v end })
AimChecks:AddToggle("AimWallCheck", { Text = "Wall Check", Default = true, Callback = function(v) Settings.AimWallCheck = v end })
AimChecks:AddToggle("AimShowFOV",   { Text = "Show FOV Circle", Default = true, Callback = function(v) Settings.AimShowFOV = v end })
AimChecks:AddLabel("FOV Circle Color"):AddColorPicker("AimFOVColor", {
    Default = Color3.fromRGB(255, 60, 60),
    Callback = function(c) Settings.AimFOVColor = c; FovCircle.Color = c end
})

-- Visuals Tab
local EspGroup = Tabs.Visuals:AddLeftGroupbox("Player ESP", "eye")
EspGroup:AddToggle("EspEnabled", {
    Text = "Enable ESP", Default = false,
    Callback = function(v)
        Settings.EspEnabled = v
        if not v then
            for plr in pairs(EspCache) do removeEsp(plr) end
        else
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then createEspObjects(plr) end
            end
        end
    end
})
EspGroup:AddToggle("EspBoxes",    { Text = "Boxes", Default = true, Callback = function(v) Settings.EspBoxes = v end })
EspGroup:AddToggle("EspHealth",   { Text = "Health Bars", Default = true, Callback = function(v) Settings.EspHealth = v end })
EspGroup:AddToggle("EspNames",    { Text = "Names", Default = true, Callback = function(v) Settings.EspNames = v end })
EspGroup:AddToggle("EspDistance", { Text = "Distance", Default = true, Callback = function(v) Settings.EspDistance = v end })
EspGroup:AddToggle("EspTracers",  { Text = "Tracers", Default = false, Callback = function(v) Settings.EspTracers = v end })
EspGroup:AddToggle("EspSkeleton", { Text = "Skeleton", Default = false, Callback = function(v) Settings.EspSkeleton = v end })
EspGroup:AddToggle("EspChams",    { Text = "Chams (Highlight)", Default = false, Callback = function(v) Settings.EspChams = v end })
EspGroup:AddToggle("EspGlowChams",{ Text = "Glow Chams", Default = false, Callback = function(v) Settings.EspGlowChams = v end })
EspGroup:AddToggle("EspTeamCheck",{ Text = "Team Check", Default = true, Callback = function(v) Settings.EspTeamCheck = v end })
EspGroup:AddSlider("EspMaxDist",  { Text = "Max Distance", Default = 500, Min = 50, Max = 2000, Rounding = 0, Suffix = " studs", Callback = function(v) Settings.EspMaxDist = v end })
EspGroup:AddSlider("EspLineThick",{ Text = "Line Thickness", Default = 1, Min = 1, Max = 5, Rounding = 0, Callback = function(v) Settings.EspLineThick = v end })

local EspColors = Tabs.Visuals:AddRightGroupbox("ESP Colors", "palette")
EspColors:AddLabel("Main Color"):AddColorPicker("EspColor",      { Default = Color3.fromRGB(0,180,255), Callback = function(c) Settings.EspColor = c end })
EspColors:AddLabel("Chams Color"):AddColorPicker("EspChamsColor",{ Default = Color3.fromRGB(0,255,255), Callback = function(c) Settings.EspChamsColor = c end })
EspColors:AddLabel("Glow Color"):AddColorPicker("EspGlowColor",  { Default = Color3.fromRGB(0,255,255), Callback = function(c) Settings.EspGlowColor = c end })

-- Movement Tab
local MoveGroup = Tabs.Movement:AddLeftGroupbox("Movement", "run")
MoveGroup:AddToggle("SpeedEnabled", { Text = "Enable Speed", Default = false, Callback = function(v) Settings.SpeedEnabled = v end })
MoveGroup:AddSlider("SpeedValue",   { Text = "WalkSpeed", Default = 50, Min = 16, Max = 300, Rounding = 0, Callback = function(v) Settings.SpeedValue = v end })
MoveGroup:AddToggle("JumpEnabled",  { Text = "Enable JumpPower", Default = false, Callback = function(v) Settings.JumpEnabled = v end })
MoveGroup:AddSlider("JumpValue",    { Text = "JumpPower", Default = 100, Min = 50, Max = 300, Rounding = 0, Callback = function(v) Settings.JumpValue = v end })
MoveGroup:AddToggle("InfJump",      { Text = "Infinite Jump", Default = false, Callback = function(v) Settings.InfJump = v end })

-- World Tab
local WorldGroup = Tabs.World:AddLeftGroupbox("World", "globe")
WorldGroup:AddToggle("NightMode",   { Text = "Night Mode", Default = false, Callback = function(v) Settings.NightMode = v; applyNightMode() end })
WorldGroup:AddToggle("FogEnabled",  { Text = "Custom Fog", Default = false, Callback = function(v) Settings.FogEnabled = v; applyFog() end })
WorldGroup:AddSlider("FogDistance", { Text = "Fog Distance", Default = 1000, Min = 100, Max = 10000, Rounding = 0, Callback = function(v) Settings.FogDistance = v; applyFog() end })

-- Misc Tab
local MiscGroup = Tabs.Misc:AddLeftGroupbox("Misc", "sparkles")
MiscGroup:AddToggle("AntiFlash",     { Text = "Anti Flashbang", Default = false, Callback = function(v) Settings.AntiFlash = v end })
MiscGroup:AddToggle("AntiSmoke",     { Text = "Anti Smoke", Default = false, Callback = function(v) Settings.AntiSmoke = v end })
MiscGroup:AddToggle("AntiSpectate",  { Text = "Anti Spectate", Default = false, Callback = function(v) Settings.AntiSpectate = v end })
MiscGroup:AddToggle("HitboxEnabled", { Text = "Hitbox Expander", Default = false, Callback = function(v) Settings.HitboxEnabled = v; if not v then restoreHitboxes() end end })
MiscGroup:AddSlider("HitboxSize",    { Text = "Hitbox Size", Default = 10, Min = 1, Max = 30, Rounding = 1, Callback = function(v) Settings.HitboxSize = v end })

local TracerGroup = Tabs.Misc:AddRightGroupbox("Bullet Tracers", "zap")
TracerGroup:AddToggle("TracerRainbow", { Text = "Rainbow Tracers", Default = false, Callback = function(v) Settings.TracerRainbow = v end })
TracerGroup:AddSlider("TracerWidth",   { Text = "Tracer Width", Default = 6, Min = 1, Max = 20, Rounding = 0, Callback = function(v) Settings.TracerWidth = v / 100 end })
TracerGroup:AddSlider("TracerFade",    { Text = "Fade Time", Default = 3, Min = 1, Max = 10, Rounding = 0, Suffix = "s", Callback = function(v) Settings.TracerFade = v end })
TracerGroup:AddButton({ Text = "Install Tracer Hook", Func = installTracers })

-- UI Settings
SaveManager:SetLibrary(Library)
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("UltimateRivals")
SaveManager:SetFolder("UltimateRivals/configs")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])

Library:Notify({ Title = "Ultimate Rivals", Description = "Loaded. Use with caution.", Time = 5 })