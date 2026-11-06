--!nocheck
--!nolint
--[[
    ============================================================================
    MOONHUB ELITE EDITION (v3.2) // RIVALS ENGINE
    Next-Generation Vibe-Coded Cheat Suite & UI Engine
    Specialized for Roblox Rivals & Universal Mobile/PC Executors

    Combined Architecture:
      - KiciaHook Native Snap-Lock & Rivals Weapon Controller Integration
      - Sleepy & UE Client-Side Map Desync / Floor Hide (Fake Being on Map)
      - Lethal Ragebot with Strict Wall Check Line-of-Sight Filtering
      - Device Spoofer (Auto PC / MouseKeyboard on Launch)
      - Ultra-Polished Obsidian & Neon Violet Cyber UI
      - Zero Unicode Emojis (Pure Typography, Zero Broken Tofu Boxes)
    ============================================================================
]]

-- ============================================================================
-- 1. SAFE ENVIRONMENT & CLONEREF SERVICES
-- ============================================================================
local function safeService(name)
    local s = game:GetService(name)
    return (cloneref and cloneref(s)) or s
end

local Players = safeService("Players")
local RunService = safeService("RunService")
local UserInputService = safeService("UserInputService")
local TweenService = safeService("TweenService")
local Lighting = safeService("Lighting")
local CollectionService = safeService("CollectionService")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    task.wait(0.1)
    LocalPlayer = Players.LocalPlayer
end

local Camera = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if workspace.CurrentCamera then
        Camera = workspace.CurrentCamera
    end
end)

local function isMobilePlatform()
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        return true
    end
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        return true
    end
    if UserInputService:GetLastInputType() == Enum.UserInputType.Touch then
        return true
    end
    return false
end

-- Safe UI Container (Bypasses mobile CoreGui tampering checks)
local function getSafeGuiHost()
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    if syn and syn.protect_gui then
        local coreGui = game:GetService("CoreGui")
        pcall(syn.protect_gui, coreGui)
        return coreGui
    end
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pg then return pg end
    local okCore, cg = pcall(function() return game:GetService("CoreGui") end)
    if okCore and cg then return cg end
    return LocalPlayer:WaitForChild("PlayerGui", 10)
end

-- Clean up any prior running instances
if getgenv().MoonHub and getgenv().MoonHub.Disconnect then
    pcall(function() getgenv().MoonHub.Disconnect() end)
end
if getgenv().KiciaHook and getgenv().KiciaHook.Disconnect then
    pcall(function() getgenv().KiciaHook.Disconnect() end)
end
if getgenv().HeadLock and getgenv().HeadLock.Disconnect then
    pcall(function() getgenv().HeadLock.Disconnect() end)
end

-- ============================================================================
-- 2. MOONHUB CONFIGURATION & GLOBAL STATE
-- ============================================================================
-- Aimbot Configuration (Kicia Snap-Lock)
getgenv().AimbotEnabled         = true
getgenv().AimbotMode            = "Lock"   -- "Lock" (Instant Snap), "Linear", "Spring"
getgenv().AimbotTargetPart      = "Head"   -- "Head", "Torso", "Closest"
getgenv().AimbotSpeed           = 5
getgenv().AimbotFOV             = 200
getgenv().AimbotWallCheck       = true
getgenv().AimbotTeamCheck       = false
getgenv().AimbotShowFOV         = false

-- Silent Aim Configuration (Bullet Redirection)
getgenv().SilentAimEnabled      = true
getgenv().SilentAimChance       = 100
getgenv().SilentAimHitbox       = "Head"
getgenv().SilentAimFOV          = 250
getgenv().SilentAimWallCheck    = true

-- Ragebot Configuration (Reverted to Step 27 Original Logic)
getgenv().RageEnabled            = false
getgenv().RageOrbitRadius        = 5
getgenv().RageOrbitSpeed         = 15
getgenv().RageAutoFire           = true
getgenv().RageTeleportMode       = false
getgenv().RageFireRate           = 0.05
getgenv().RageAntiHit            = true
getgenv().RageClampY             = true
getgenv().RageRoundCheck         = true
getgenv().RageWallbang           = true
getgenv().SilentAimWallbang     = true

-- Client Surface Desync / Fake Position (Sleepy & UE Logic)
getgenv().FakePositionEnabled   = false    -- Fake being on map while real hitbox is floor-hidden
getgenv().FakePositionDepth     = 5.8      -- Studs below surface
getgenv().FakePositionSurfaceCam= true     -- Elevates camera so view is 100% normal on surface
getgenv().FakePositionWalkMode  = true     -- Walks smoothly along virtual surface
getgenv().FakePositionAutoNoclip= true     -- Noclips character through floor geometry
getgenv().FakePositionZeroVelocity = true  -- Cancels physics bounce & flinging
getgenv().FakePositionPitchMode = "Down"   -- "Down" (-89 deg head hide), "Up", "Jitter", "Zero"
getgenv().FakePositionYawMode   = "Spin"   -- "Spin", "Backwards", "Jitter", "Sway"

-- Movement & Combat Defense
getgenv().AntiHitEnabled        = false
getgenv().AntiOOBEnabled        = false
getgenv().NoclipEnabled         = false
getgenv().FlightEnabled         = false
getgenv().FlightSpeed           = 75
getgenv().FlightMobileButtons   = true
getgenv().SpeedHackEnabled      = false
getgenv().SpeedHackValue        = 45
getgenv().JumpPowerEnabled      = false
getgenv().JumpPowerValue        = 100
getgenv().FullbrightEnabled     = false

-- Device Spoofer Configuration (Auto Enabled on Launch)
getgenv().DeviceSpoofEnabled    = true
getgenv().DeviceSpoofType       = "PC"     -- "PC", "Mobile", "Console", "VR"

-- Visuals / ESP
getgenv().ESPEnabled            = true
getgenv().ESPHealthNumber       = true     -- Kiciahook numerical health indicator
getgenv().ESPHealthBar          = false    -- Disabled by default in favor of Health Number
getgenv().ESPNames              = true
getgenv().ESPDistance           = true
getgenv().ChamsEnabled          = false
getgenv().TracersEnabled        = false

-- Internal Loop States
local cachedSilentTarget = nil
local cachedAimbotTarget = nil
local isInternalRaycast = false
local orbitAngle = 0
local lastRageFire = 0
local fpsValue = 60
local pingValue = 24
local lastFpsTime = tick()
local frameTally = 0

-- ============================================================================
-- 3. RIVALS CAMERA CONTROLLER DETECTION (Native Lock Integration)
-- ============================================================================
local rivalsCameraController = nil
local setRotationFn = nil

local function getRivalsCamera()
    if rivalsCameraController and setRotationFn then return rivalsCameraController end
    pcall(function()
        local ps = LocalPlayer:FindFirstChild("PlayerScripts")
        local ctrl = ps and ps:FindFirstChild("Controllers")
        local cc = ctrl and ctrl:FindFirstChild("CameraController")
        if cc then
            local required = require(cc)
            if required then
                rivalsCameraController = required
                local mt = getmetatable(required)
                if mt and type(mt.__index) == "table" and mt.__index.SetRotation then
                    setRotationFn = function(rot)
                        pcall(function() mt.__index.SetRotation(required, rot) end)
                    end
                elseif required.SetRotation then
                    setRotationFn = function(rot)
                        pcall(function() required:SetRotation(rot) end)
                    end
                end
            end
        end
    end)
    return rivalsCameraController
end

task.spawn(function()
    for _ = 1, 25 do
        if getRivalsCamera() then break end
        task.wait(0.4)
    end
end)

-- ============================================================================
-- 4. TARGETING & VISIBILITY VERIFICATION ENGINE
-- ============================================================================
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater = true

local function updateRayFilter()
    local ignore = {}
    if LocalPlayer.Character then
        table.insert(ignore, LocalPlayer.Character)
    end
    if Camera then
        table.insert(ignore, Camera)
    end
    rayParams.FilterDescendantsInstances = ignore
end

local function isPartVisible(part)
    if not part then return false end
    updateRayFilter()
    local origin = Camera.CFrame.Position
    local dir = part.Position - origin

    isInternalRaycast = true
    local res = workspace:Raycast(origin, dir, rayParams)
    isInternalRaycast = false

    if not res then return true end
    return res.Instance == part or part:IsAncestorOf(res.Instance) or res.Instance:IsDescendantOf(part.Parent)
end

local function isEnemy(player)
    if not getgenv().AimbotTeamCheck then return true end
    local myTeam = LocalPlayer.Team
    if not myTeam then return true end
    return player.Team ~= myTeam
end

local function getTargetPart(character, preference)
    preference = preference or "Head"
    if preference == "Head" then
        return character:FindFirstChild("Head")
    elseif preference == "Torso" then
        return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart")
    else
        return character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
    end
end

-- FOV Target Selection for Legit Aimbot & Silent Aim
local function findBestTarget(fovRadius, wallCheck, partPreference)
    local bestPart = nil
    local shortestDist = fovRadius or getgenv().AimbotFOV
    local center = Camera.ViewportSize / 2

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not isEnemy(player) then continue end
        local char = player.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        if char:FindFirstChildOfClass("ForceField") then continue end

        local targetPart = getTargetPart(char, partPreference)
        if not targetPart then continue end

        local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
        if not onScreen or screenPoint.Z <= 0 then continue end

        local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - center).Magnitude
        if dist >= shortestDist then continue end

        if wallCheck and not isPartVisible(targetPart) then continue end

        shortestDist = dist
        bestPart = targetPart
    end
    return bestPart
end

-- Original Step 27 Ragebot Target Selection (Closest Enemy Anywhere on Map)
local function getAnyTargetForRage()
    local closest = nil
    local shortest = math.huge
    local char = LocalPlayer.Character
    local myPos = char and char:FindFirstChild("HumanoidRootPart")
    if not myPos then return nil end
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not isEnemy(player) then continue end
        local character = player.Character
        if not character then continue end
        local head = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not head or not humanoid or humanoid.Health <= 0 then continue end
        local dist = (myPos.Position - head.Position).Magnitude
        if dist < shortest then
            shortest = dist
            closest = head
        end
    end
    return closest
end
local findRageTarget = getAnyTargetForRage

local function findGroundY(x, z, fallbackY)
    local origin = Vector3.new(x, fallbackY + 500, z)
    local dir = Vector3.new(0, -2000, 0)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = LocalPlayer.Character and {LocalPlayer.Character} or {}

    isInternalRaycast = true
    local result = workspace:Raycast(origin, dir, rp)
    isInternalRaycast = false

    if result then return result.Position.Y end
    return fallbackY
end
local getSafeFloorY = findGroundY

local function isRoundActive()
    if not getgenv().RageRoundCheck then return true end
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 or hum.WalkSpeed <= 0 then return false end
    if char:FindFirstChildOfClass("ForceField") then return false end
    return true
end

-- ============================================================================
-- 5. UE / KICIA MOBILE AIMBOT ENGINE (Zero-Flick Native Controller Integration)
-- ============================================================================
local function executeAimbotLock(targetPart, mode, speed)
    if not targetPart then return end
    local targetPos = targetPart.Position
    local camPos = Camera.CFrame.Position
    local lookVector = (targetPos - camPos).Unit

    -- Calculate Pitch and Yaw in radians
    local targetPitch = math.asin(math.clamp(lookVector.Y, -1, 1))
    local targetYaw = math.atan2(-lookVector.X, -lookVector.Z)
    local targetRot = Vector2.new(targetPitch, targetYaw)

    -- 1. Sync Rivals CameraController internal rotation (Eliminates mobile snapback)
    getRivalsCamera()
    if setRotationFn then
        setRotationFn(targetRot)
    elseif rivalsCameraController and rivalsCameraController.Rotation then
        pcall(function() rivalsCameraController.Rotation = targetRot end)
    end

    -- 2. Direct Camera Orientation (Instant Lock or Smooth Lerp)
    if mode == "Lock" then
        Camera.CFrame = CFrame.new(camPos, targetPos)
    else
        local curCF = Camera.CFrame
        local targetCF = CFrame.new(camPos, targetPos)
        local factor = math.clamp((speed or 10) * 0.08, 0.05, 1)
        Camera.CFrame = curCF:Lerp(targetCF, factor)
    end
end

-- ============================================================================
-- 6. SILENT AIM (Safe Metamethod Raycast Interception)
-- ============================================================================
local oldNamecall = nil

local function isWeaponRaycast(origin, direction)
    if direction.Magnitude < 40 then
        return false
    end
    -- Ground checks point almost straight down (-Y). Never touch them!
    if direction.Y < -0.85 * direction.Magnitude then
        return false
    end
    -- Weapon shots originate from the camera or held weapon
    local camPos = Camera.CFrame.Position
    if (origin - camPos).Magnitude > 25 then
        return false
    end
    return true
end

pcall(function()
    if hookmetamethod then
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod and getnamecallmethod()

            if (getgenv().SilentAimEnabled or getgenv().RageEnabled) and not isInternalRaycast then
                if (method == "Raycast" or method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay")
                    and (self == workspace or self == game:GetService("Workspace")) then

                    local args = {...}
                    local origin = args[1]
                    local direction = args[2]

                    if isWeaponRaycast(origin, direction) then
                        local target = cachedSilentTarget
                        if target and target.Parent then
                            local useWallbang = (getgenv().RageEnabled and getgenv().RageWallbang) or (getgenv().SilentAimEnabled and getgenv().SilentAimWallbang)

                            if useWallbang then
                                -- UE / KICIA PENETRATION SOLVER:
                                -- Positions raycast 0.8 studs directly in front of target head,
                                -- piercing straight through the head.
                                -- Bypasses 100% of walls, barriers, and geometry on the map!
                                local aimDir = (target.Position - origin).Unit
                                args[1] = target.Position - (aimDir * 0.8)
                                args[2] = aimDir * 2.5
                                if setnamecallmethod then setnamecallmethod(method) end
                                return oldNamecall(self, table.unpack(args))
                            else
                                local hitChance = (getgenv().RageEnabled and 100) or getgenv().SilentAimChance or 100
                                if hitChance >= 100 or math.random(1, 100) <= hitChance then
                                    local targetDir = (target.Position - origin).Unit * math.max(direction.Magnitude, 1000)
                                    args[2] = targetDir
                                    if setnamecallmethod then setnamecallmethod(method) end
                                    return oldNamecall(self, table.unpack(args))
                                end
                            end
                        end
                    end
                end
            end

            if setnamecallmethod then setnamecallmethod(method) end
            return oldNamecall(self, ...)
        end)
    end
end)

-- ============================================================================
-- 7. ANTI-HIT & ANTI-OUT OF BOUNDS (Defense)
-- ============================================================================
local HITBOX_NAMES = {
    "Head", "Torso", "UpperTorso", "LowerTorso",
    "Left Arm", "Right Arm", "Left Leg", "Right Leg",
    "LeftUpperArm", "LeftLowerArm", "LeftHand",
    "RightUpperArm", "RightLowerArm", "RightHand",
    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
    "RightUpperLeg", "RightLowerLeg", "RightFoot"
}

local function applyAntiHit()
    local char = LocalPlayer.Character
    if not char then return end
    for _, name in ipairs(HITBOX_NAMES) do
        local part = char:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            part.CanQuery = false
        end
    end
end

local function restoreAntiHit()
    local char = LocalPlayer.Character
    if not char then return end
    for _, name in ipairs(HITBOX_NAMES) do
        local part = char:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            part.CanQuery = true
        end
    end
end

local oobListeners = {}
local function applyAntiOOB(enable)
    for _, conn in ipairs(oobListeners) do
        pcall(function() conn:Disconnect() end)
    end
    oobListeners = {}

    if enable then
        local function neutralize(part)
            if part:IsA("BasePart") then
                pcall(function() part.CanTouch = false end)
            end
        end

        for _, tag in ipairs({"OutOfBoundsPart", "KillBrick", "OutOfBoundsSafePart"}) do
            for _, part in ipairs(CollectionService:GetTagged(tag)) do
                neutralize(part)
            end
            local conn = CollectionService:GetInstanceAddedSignal(tag):Connect(neutralize)
            table.insert(oobListeners, conn)
        end
    end
end

local function checkVoidRescue()
    if not getgenv().AntiOOBEnabled then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if hrp.Position.Y < -200 then
        local safeY = getSafeFloorY(hrp.Position.X, hrp.Position.Z, 10)
        hrp.CFrame = CFrame.new(hrp.Position.X, math.max(safeY + 3, 10), hrp.Position.Z)
        hrp.Velocity = Vector3.zero
        hrp.RotVelocity = Vector3.zero
    end
end

-- ============================================================================
-- 8. FULLBRIGHT
-- ============================================================================
local origLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient
}

local function applyFullbright(enable)
    pcall(function()
        if enable then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        else
            Lighting.Brightness = origLighting.Brightness
            Lighting.ClockTime = origLighting.ClockTime
            Lighting.FogEnd = origLighting.FogEnd
            Lighting.GlobalShadows = origLighting.GlobalShadows
            Lighting.Ambient = origLighting.Ambient
            Lighting.OutdoorAmbient = origLighting.OutdoorAmbient
        end
    end)
end

-- ============================================================================
-- 9. DEVICE SPOOFER (Rivals Controller & Platform Emulation)
-- ============================================================================
local DEVICE_MAP = {
    ["PC"]      = "MouseKeyboard",
    ["Desktop"] = "MouseKeyboard",
    ["Mobile"]  = "Touch",
    ["Console"] = "Gamepad",
    ["VR"]      = "VR"
}

local spoofControlsController = nil
local spoofFighterController = nil
local spoofReplicateControlsFn = nil
local spoofUpvalueIndex = nil
local spoofOriginalUpvalue = nil
local spoofHookApplied = false

local function findSpoofControllers()
    if spoofControlsController and spoofFighterController and spoofReplicateControlsFn then
        return true
    end

    pcall(function()
        local ps = LocalPlayer:FindFirstChild("PlayerScripts")
        if not ps then return end
        local ctrl = ps:FindFirstChild("Controllers")
        if not ctrl then return end
        local cc = ctrl:FindFirstChild("ControlsController")
        local fc = ctrl:FindFirstChild("FighterController")
        if cc and not spoofControlsController then
            spoofControlsController = require(cc)
        end
        if fc and not spoofFighterController then
            spoofFighterController = require(fc)
        end
    end)

    if spoofFighterController and not spoofReplicateControlsFn then
        pcall(function()
            spoofReplicateControlsFn = rawget(getmetatable(spoofFighterController).__index, "_ReplicateControls")
        end)
        if not spoofReplicateControlsFn then
            spoofReplicateControlsFn = spoofFighterController._ReplicateControls
        end
    end

    if spoofReplicateControlsFn and debug and debug.getupvalues and spoofControlsController and not spoofUpvalueIndex then
        pcall(function()
            for k, v in pairs(debug.getupvalues(spoofReplicateControlsFn)) do
                if v == spoofControlsController then
                    spoofUpvalueIndex = k
                    spoofOriginalUpvalue = v
                    break
                end
            end
        end)
    end

    return (spoofControlsController ~= nil or spoofFighterController ~= nil)
end

local function applyDeviceSpoof()
    if not getgenv().DeviceSpoofEnabled then return end
    findSpoofControllers()

    local targetType = getgenv().DeviceSpoofType or "PC"
    local mapped = DEVICE_MAP[targetType] or "MouseKeyboard"

    if spoofControlsController then
        pcall(function()
            spoofControlsController.CurrentControls = mapped
        end)
    end

    if spoofReplicateControlsFn and spoofUpvalueIndex and spoofOriginalUpvalue and debug and debug.setupvalue then
        pcall(function()
            debug.setupvalue(spoofReplicateControlsFn, spoofUpvalueIndex, setmetatable({}, {
                __index = function(t, k)
                    if k == "CurrentControls" then
                        if getgenv().DeviceSpoofEnabled then
                            return DEVICE_MAP[getgenv().DeviceSpoofType or "PC"] or "MouseKeyboard"
                        end
                        return spoofOriginalUpvalue.CurrentControls
                    end
                    return spoofOriginalUpvalue[k]
                end
            }))
            spoofHookApplied = true
        end)
    end

    pcall(function()
        if spoofFighterController and spoofFighterController._ReplicateControls then
            spoofFighterController:_ReplicateControls()
        elseif spoofReplicateControlsFn and spoofFighterController then
            spoofReplicateControlsFn(spoofFighterController)
        end
    end)
end

local function restoreDeviceSpoof()
    if spoofHookApplied and spoofReplicateControlsFn and spoofUpvalueIndex and spoofOriginalUpvalue and debug and debug.setupvalue then
        pcall(function()
            debug.setupvalue(spoofReplicateControlsFn, spoofUpvalueIndex, spoofOriginalUpvalue)
            spoofHookApplied = false
        end)
    end
    pcall(function()
        if spoofFighterController and spoofFighterController._ReplicateControls then
            spoofFighterController:_ReplicateControls()
        end
    end)
end

task.spawn(function()
    for _ = 1, 30 do
        if findSpoofControllers() then
            applyDeviceSpoof()
            break
        end
        task.wait(0.5)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if getgenv().DeviceSpoofEnabled then
        applyDeviceSpoof()
    end
end)

-- ============================================================================
-- 10. CLIENT SURFACE DESYNC / FLOOR HIDE (Sleepy & UE Logic)
-- ============================================================================
local fakePos = {
    Enabled = false,
    VirtualCF = nil,
    Depth = 5.8,
    SurfaceCamera = true,
    WalkMode = true,
    AutoNoclip = true,
    ZeroVelocity = true,
    PitchMode = "Down", -- "Down" (-89), "Up" (89), "Jitter", "Zero"
    YawMode = "Spin",   -- "Spin", "Backwards", "Jitter", "Sway"
    SpinAngle = 0,
    SwayAngle = 0,
    SwayDir = 1,
    JitterFlip = false
}

local function setFakePosition(state)
    if fakePos.Enabled == state then return end
    fakePos.Enabled = state
    getgenv().FakePositionEnabled = state

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if state then
        if hrp then
            fakePos.VirtualCF = hrp.CFrame
        end
    else
        if hrp and fakePos.VirtualCF then
            pcall(function()
                hrp.CFrame = fakePos.VirtualCF
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                hrp.Velocity = Vector3.zero
                hrp.RotVelocity = Vector3.zero
            end)
        end
        fakePos.VirtualCF = nil
    end
end

-- ============================================================================
-- 11. WEAPON AUTO-FIRING FOR RAGEBOT
-- ============================================================================
local function getToolRemote()
    local char = LocalPlayer.Character
    if not char then return nil end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return nil end
    for _, d in ipairs(tool:GetDescendants()) do
        if d:IsA("RemoteEvent") then return d end
    end
    for _, d in ipairs(tool:GetDescendants()) do
        if d:IsA("RemoteFunction") then return d end
    end
    return nil
end

local function fireAtTarget(head)
    local remote = getToolRemote()
    if not remote then return end
    local origin = Camera.CFrame.Position
    local direction = (head.Position - origin).Unit * 1000
    pcall(function() remote:FireServer(head.Position, direction) end)
    pcall(function() remote:FireServer(direction) end)
    pcall(function() remote:FireServer(head) end)
    pcall(function() remote:FireServer() end)
end

local function triggerWeaponFire()
    local char = LocalPlayer.Character
    if not char then return end

    -- 1. Standard Tool Activation (Client weapon fire)
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        pcall(function() tool:Activate() end)
    end

    -- 2. Rivals FighterState input hook
    if spoofFighterController then
        pcall(function()
            local fs = spoofFighterController.FighterState
            if fs and fs.Input then
                fs:Input("StartShooting")
            end
        end)
    end

    -- 3. Virtual Input & Mouse Simulation (PC ONLY - NEVER on Mobile)
    if not isMobilePlatform() then
        pcall(function()
            local vim = game:GetService("VirtualInputManager")
            if vim then
                vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.defer(function()
                    pcall(function()
                        vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    end)
                end)
            end
        end)

        pcall(function()
            if mouse1click then
                mouse1click()
            elseif mouse1press and mouse1release then
                mouse1press()
                task.defer(mouse1release)
            end
        end)
    end
end

-- ============================================================================
-- 12. VIBE-CODED UI THEME & COMPONENT ENGINE
-- ============================================================================
local THEME = {
    BgDark       = Color3.fromRGB(11, 11, 16),       -- Obsidian Black
    BgPanel      = Color3.fromRGB(16, 16, 24),       -- Window Surface
    BgCard       = Color3.fromRGB(21, 21, 31),       -- Card Container
    BgCardHover  = Color3.fromRGB(27, 27, 40),       -- Interactive Card Hover
    BgItem       = Color3.fromRGB(29, 29, 44),       -- Controls / Inputs
    Border       = Color3.fromRGB(40, 40, 60),       -- Hairline Outline
    BorderGlow   = Color3.fromRGB(90, 52, 145),      -- Subtle Purple Glow
    Accent       = Color3.fromRGB(168, 85, 247),     -- Vibrant Neon Violet
    AccentDark   = Color3.fromRGB(126, 34, 206),     -- Deep Purple
    AccentLight  = Color3.fromRGB(192, 132, 252),    -- Lavender Accent
    AccentCyan   = Color3.fromRGB(56, 189, 248),     -- Electric Cyan
    Text         = Color3.fromRGB(248, 250, 252),    -- Pure White
    TextDim      = Color3.fromRGB(156, 163, 175),    -- Muted Platinum
    TextMuted    = Color3.fromRGB(100, 116, 139),    -- Slate Dark
    Success      = Color3.fromRGB(34, 197, 94),      -- Emerald Green
    Danger       = Color3.fromRGB(239, 68, 68),      -- Crimson Red
    ToggleOff    = Color3.fromRGB(36, 38, 52)        -- Dark Switch State
}

local guiHost = getSafeGuiHost()
local gui = Instance.new("ScreenGui")
gui.Name = "MoonHub_Elite"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 99999
pcall(function() gui.Parent = guiHost end)

-- Drawing & Visual Overlays
local espFolder = Instance.new("Folder")
espFolder.Name = "MH_ESP"
espFolder.Parent = gui

local chamsFolder = Instance.new("Folder")
chamsFolder.Name = "MH_Chams"
chamsFolder.Parent = gui

local tracersFolder = Instance.new("Folder")
tracersFolder.Name = "MH_Tracers"
tracersFolder.Parent = gui

-- FOV Circle
local fovCircle = Instance.new("Frame")
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.Visible = false
fovCircle.ZIndex = 5
fovCircle.Parent = gui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovCircle

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = THEME.Accent
fovStroke.Thickness = 1.2
fovStroke.Transparency = 0.3
fovStroke.Parent = fovCircle

local function updateFOVCircle()
    local diam = (getgenv().AimbotFOV or 200) * 2
    fovCircle.Size = UDim2.new(0, diam, 0, diam)
    local vp = Camera.ViewportSize
    fovCircle.Position = UDim2.new(0, vp.X / 2, 0, vp.Y / 2)
    fovCircle.Visible = getgenv().AimbotShowFOV
end

-- 2D Box ESP Cache
local espCache = {}

local function createESPRecord(player)
    local box = Instance.new("Frame")
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.ZIndex = 8
    box.Parent = espFolder

    local stroke = Instance.new("UIStroke")
    stroke.Color = THEME.Accent
    stroke.Thickness = 1.2
    stroke.Parent = box

    local name = Instance.new("TextLabel")
    name.BackgroundTransparency = 1
    name.TextColor3 = THEME.Text
    name.Font = Enum.Font.GothamBold
    name.TextSize = 11
    name.TextStrokeTransparency = 0.2
    name.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    name.Size = UDim2.new(1, 0, 0, 14)
    name.Position = UDim2.new(0, 0, 0, -16)
    name.ZIndex = 9
    name.Parent = box

    local dist = Instance.new("TextLabel")
    dist.BackgroundTransparency = 1
    dist.TextColor3 = THEME.TextDim
    dist.Font = Enum.Font.GothamMedium
    dist.TextSize = 10
    dist.TextStrokeTransparency = 0.2
    dist.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    dist.Size = UDim2.new(1, 0, 0, 14)
    dist.Position = UDim2.new(0, 0, 1, 2)
    dist.ZIndex = 9
    dist.Parent = box

    local hpBg = Instance.new("Frame")
    hpBg.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    hpBg.BorderSizePixel = 0
    hpBg.Size = UDim2.new(0, 3, 1, 0)
    hpBg.Position = UDim2.new(0, -6, 0, 0)
    hpBg.ZIndex = 8
    hpBg.Visible = false
    hpBg.Parent = box

    local hp = Instance.new("Frame")
    hp.BackgroundColor3 = THEME.Success
    hp.BorderSizePixel = 0
    hp.Size = UDim2.new(1, 0, 1, 0)
    hp.Position = UDim2.new(0, 0, 1, 0)
    hp.AnchorPoint = Vector2.new(0, 1)
    hp.ZIndex = 9
    hp.Parent = hpBg

    -- Kicia Hook Numerical Health Indicator
    local hpNum = Instance.new("TextLabel")
    hpNum.Name = "HealthNumber"
    hpNum.BackgroundTransparency = 1
    hpNum.TextColor3 = THEME.Success
    hpNum.Font = Enum.Font.GothamBold
    hpNum.TextSize = 10
    hpNum.TextStrokeTransparency = 0.2
    hpNum.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    hpNum.Size = UDim2.new(0, 32, 0, 12)
    hpNum.Position = UDim2.new(0, -36, 0, -1)
    hpNum.TextXAlignment = Enum.TextXAlignment.Right
    hpNum.ZIndex = 9
    hpNum.Parent = box

    return {box = box, name = name, dist = dist, hp = hp, hpBg = hpBg, hpNum = hpNum, player = player}
end

local function updateESP()
    if not getgenv().ESPEnabled then
        for _, d in pairs(espCache) do d.box.Visible = false end
        return
    end

    local active = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        if not isEnemy(p) then continue end
        local char = p.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then continue end

        local screenPoint, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if not onScreen then continue end

        active[p] = true
        local data = espCache[p]
        if not data then
            data = createESPRecord(p)
            espCache[p] = data
        end

        local head = char:FindFirstChild("Head")
        local topY = head and Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.7, 0)).Y or (screenPoint.Y - 20)
        local bottomY = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 2.5, 0)).Y
        local boxH = math.abs(bottomY - topY)
        local boxW = boxH * 0.65

        data.box.Size = UDim2.new(0, boxW, 0, boxH)
        data.box.Position = UDim2.new(0, screenPoint.X - boxW / 2, 0, topY)
        data.box.Visible = true

        data.name.Visible = getgenv().ESPNames
        data.name.Text = p.DisplayName or p.Name

        local dVal = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
        data.dist.Visible = getgenv().ESPDistance
        data.dist.Text = tostring(dVal) .. "m"

        local curHp = math.floor(hum.Health)
        local maxHp = math.floor(math.max(hum.MaxHealth, 1))
        local pct = math.clamp(hum.Health / maxHp, 0, 1)
        local hpColor = Color3.fromHSV(pct * 0.33, 0.85, 1)

        -- Health Number (Kicia Hook Style)
        if getgenv().ESPHealthNumber then
            data.hpNum.Visible = true
            data.hpNum.Text = tostring(curHp)
            data.hpNum.TextColor3 = hpColor
        else
            data.hpNum.Visible = false
        end

        -- Optional Health Bar
        if getgenv().ESPHealthBar then
            data.hpBg.Visible = true
            data.hp.Size = UDim2.new(1, 0, pct, 0)
            data.hp.BackgroundColor3 = hpColor
        else
            data.hpBg.Visible = false
        end
    end

    for p, d in pairs(espCache) do
        if not active[p] then d.box.Visible = false end
    end
end

-- Chams
local chamsCache = {}
local function updateChams()
    if not getgenv().ChamsEnabled then
        for _, hl in pairs(chamsCache) do hl.Enabled = false end
        return
    end

    local active = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        if not isEnemy(p) then continue end
        local char = p.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end

        active[p] = true
        local hl = chamsCache[p]
        if not hl then
            hl = Instance.new("Highlight")
            hl.FillColor = THEME.Accent
            hl.OutlineColor = THEME.AccentLight
            hl.FillTransparency = 0.45
            hl.OutlineTransparency = 0.1
            pcall(function() hl.Parent = chamsFolder end)
            chamsCache[p] = hl
        end
        hl.Adornee = char
        hl.Enabled = true
    end

    for p, hl in pairs(chamsCache) do
        if not active[p] then hl.Enabled = false end
    end
end

-- Tracers
local tracerCache = {}
local function updateTracers()
    if not getgenv().TracersEnabled then
        for _, line in pairs(tracerCache) do line.Visible = false end
        return
    end

    local vp = Camera.ViewportSize
    local origin = Vector2.new(vp.X / 2, vp.Y)
    local active = {}

    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        if not isEnemy(p) then continue end
        local char = p.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then continue end

        local screenPoint, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if not onScreen then continue end

        active[p] = true
        local line = tracerCache[p]
        if not line then
            line = Instance.new("Frame")
            line.BackgroundColor3 = THEME.Accent
            line.BorderSizePixel = 0
            line.AnchorPoint = Vector2.new(0.5, 0.5)
            line.ZIndex = 6
            line.Parent = tracersFolder
            tracerCache[p] = line
        end

        local p1 = origin
        local p2 = Vector2.new(screenPoint.X, screenPoint.Y)
        local length = (p2 - p1).Magnitude
        local center = (p1 + p2) / 2
        local angle = math.deg(math.atan2(p2.Y - p1.Y, p2.X - p1.X))

        line.Size = UDim2.new(0, length, 0, 1.2)
        line.Position = UDim2.new(0, center.X, 0, center.Y)
        line.Rotation = angle
        line.Visible = true
    end

    for p, line in pairs(tracerCache) do
        if not active[p] then line.Visible = false end
    end
end

-- Notifications
local notifContainer = Instance.new("Frame")
notifContainer.Size = UDim2.new(0, 270, 0, 320)
notifContainer.Position = UDim2.new(1, -280, 1, -20)
notifContainer.AnchorPoint = Vector2.new(0, 1)
notifContainer.BackgroundTransparency = 1
notifContainer.ZIndex = 300
notifContainer.Parent = gui

local notifLayout = Instance.new("UIListLayout")
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
notifLayout.Padding = UDim.new(0, 8)
notifLayout.Parent = notifContainer

local function sendNotification(title, message, duration)
    duration = duration or 3
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 56)
    card.Position = UDim2.new(1, 60, 0, 0)
    card.BackgroundColor3 = THEME.BgCard
    card.BorderSizePixel = 0
    card.ZIndex = 301
    card.Parent = notifContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = THEME.Border
    stroke.Thickness = 1
    stroke.Parent = card

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 1, -16)
    accentBar.Position = UDim2.new(0, 8, 0, 8)
    accentBar.BackgroundColor3 = THEME.Accent
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 302
    accentBar.Parent = card

    local acCorner = Instance.new("UICorner")
    acCorner.CornerRadius = UDim.new(1, 0)
    acCorner.Parent = accentBar

    local tLabel = Instance.new("TextLabel")
    tLabel.Size = UDim2.new(1, -28, 0, 18)
    tLabel.Position = UDim2.new(0, 18, 0, 9)
    tLabel.BackgroundTransparency = 1
    tLabel.Text = title
    tLabel.TextColor3 = THEME.Text
    tLabel.Font = Enum.Font.GothamBold
    tLabel.TextSize = 12
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.ZIndex = 302
    tLabel.Parent = card

    local mLabel = Instance.new("TextLabel")
    mLabel.Size = UDim2.new(1, -28, 0, 16)
    mLabel.Position = UDim2.new(0, 18, 0, 28)
    mLabel.BackgroundTransparency = 1
    mLabel.Text = message
    mLabel.TextColor3 = THEME.TextDim
    mLabel.Font = Enum.Font.Gotham
    mLabel.TextSize = 11
    mLabel.TextXAlignment = Enum.TextXAlignment.Left
    mLabel.ZIndex = 302
    mLabel.Parent = card

    TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()

    task.delay(duration, function()
        local tw = TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 60, 0, 0)
        })
        tw:Play()
        tw.Completed:Connect(function() card:Destroy() end)
    end)
end

-- Draggable Utility
local function makeDraggable(handle, frame)
    local dragging = false
    local dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            local conn
            conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if conn then conn:Disconnect() end
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ============================================================================
-- 13. MASTER VIBE-CODED MAIN WINDOW CREATION
-- ============================================================================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 620, 0, 420)
mainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
mainFrame.BackgroundColor3 = THEME.BgPanel
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 100
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = THEME.Border
mainStroke.Thickness = 1.2
mainStroke.Parent = mainFrame

-- Top Glowing Gradient Line
local topGlow = Instance.new("Frame")
topGlow.Size = UDim2.new(1, 0, 0, 3)
topGlow.Position = UDim2.new(0, 0, 0, 0)
topGlow.BorderSizePixel = 0
topGlow.ZIndex = 106
topGlow.Parent = mainFrame

local tgCorner = Instance.new("UICorner")
tgCorner.CornerRadius = UDim.new(0, 10)
tgCorner.Parent = topGlow

local tgGradient = Instance.new("UIGradient")
tgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, THEME.AccentCyan),
    ColorSequenceKeypoint.new(0.5, THEME.Accent),
    ColorSequenceKeypoint.new(1, THEME.AccentDark)
})
tgGradient.Parent = topGlow

-- Sidebar Rail
local rail = Instance.new("Frame")
rail.Size = UDim2.new(0, 150, 1, 0)
rail.BackgroundColor3 = THEME.BgDark
rail.BorderSizePixel = 0
rail.ZIndex = 101
rail.Parent = mainFrame

local railCorner = Instance.new("UICorner")
railCorner.CornerRadius = UDim.new(0, 10)
railCorner.Parent = rail

local railDivider = Instance.new("Frame")
railDivider.Size = UDim2.new(0, 1, 1, 0)
railDivider.Position = UDim2.new(1, -1, 0, 0)
railDivider.BackgroundColor3 = THEME.Border
railDivider.BorderSizePixel = 0
railDivider.ZIndex = 102
railDivider.Parent = rail

-- Brand Header inside Rail
local brandFrame = Instance.new("Frame")
brandFrame.Size = UDim2.new(1, 0, 0, 54)
brandFrame.BackgroundTransparency = 1
brandFrame.ZIndex = 102
brandFrame.Parent = rail

local emblem = Instance.new("Frame")
emblem.Size = UDim2.new(0, 24, 0, 24)
emblem.Position = UDim2.new(0, 12, 0, 15)
emblem.BackgroundColor3 = THEME.BgItem
emblem.BorderSizePixel = 0
emblem.ZIndex = 103
emblem.Parent = brandFrame
local ec = Instance.new("UICorner")
ec.CornerRadius = UDim.new(0, 6)
ec.Parent = emblem
local es = Instance.new("UIStroke")
es.Color = THEME.Accent
es.Thickness = 1.2
es.Parent = emblem

local emLabel = Instance.new("TextLabel")
emLabel.Size = UDim2.new(1, 0, 1, 0)
emLabel.BackgroundTransparency = 1
emLabel.Text = "M"
emLabel.TextColor3 = THEME.AccentLight
emLabel.Font = Enum.Font.GothamBold
emLabel.TextSize = 13
emLabel.ZIndex = 104
emLabel.Parent = emblem

local brandTitle = Instance.new("TextLabel")
brandTitle.Size = UDim2.new(1, -44, 0, 18)
brandTitle.Position = UDim2.new(0, 42, 0, 12)
brandTitle.BackgroundTransparency = 1
brandTitle.Text = "MOONHUB"
brandTitle.TextColor3 = THEME.Text
brandTitle.Font = Enum.Font.GothamBold
brandTitle.TextSize = 14
brandTitle.TextXAlignment = Enum.TextXAlignment.Left
brandTitle.ZIndex = 103
brandTitle.Parent = brandFrame

local brandTag = Instance.new("TextLabel")
brandTag.Size = UDim2.new(1, -44, 0, 14)
brandTag.Position = UDim2.new(0, 42, 0, 30)
brandTag.BackgroundTransparency = 1
brandTag.Text = "RIVALS // v3.2"
brandTag.TextColor3 = THEME.Accent
brandTag.Font = Enum.Font.GothamMedium
brandTag.TextSize = 9
brandTag.TextXAlignment = Enum.TextXAlignment.Left
brandTag.ZIndex = 103
brandTag.Parent = brandFrame

-- Tab List Container
local tabList = Instance.new("ScrollingFrame")
tabList.Size = UDim2.new(1, 0, 1, -125)
tabList.Position = UDim2.new(0, 0, 0, 58)
tabList.BackgroundTransparency = 1
tabList.BorderSizePixel = 0
tabList.ScrollBarThickness = 2
tabList.ScrollBarImageColor3 = THEME.Accent
tabList.ScrollBarImageTransparency = 0.6
tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
tabList.ZIndex = 102
tabList.Parent = rail

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 4)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabList

local tabPad = Instance.new("UIPadding")
tabPad.PaddingLeft = UDim.new(0, 8)
tabPad.PaddingRight = UDim.new(0, 8)
tabPad.PaddingTop = UDim.new(0, 4)
tabPad.Parent = tabList

-- Player Status Profile at bottom of rail
local userCard = Instance.new("Frame")
userCard.Size = UDim2.new(1, -16, 0, 52)
userCard.Position = UDim2.new(0, 8, 1, -60)
userCard.BackgroundColor3 = THEME.BgCard
userCard.BorderSizePixel = 0
userCard.ZIndex = 102
userCard.Parent = rail

local ucc = Instance.new("UICorner")
ucc.CornerRadius = UDim.new(0, 8)
ucc.Parent = userCard

local ucs = Instance.new("UIStroke")
ucs.Color = THEME.Border
ucs.Thickness = 1
ucs.Parent = userCard

local userAvatar = Instance.new("ImageLabel")
userAvatar.Size = UDim2.new(0, 32, 0, 32)
userAvatar.Position = UDim2.new(0, 8, 0.5, -16)
userAvatar.BackgroundColor3 = THEME.BgItem
userAvatar.BorderSizePixel = 0
userAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=48&h=48"
userAvatar.ZIndex = 103
userAvatar.Parent = userCard
local uac = Instance.new("UICorner")
uac.CornerRadius = UDim.new(1, 0)
uac.Parent = userAvatar

local userName = Instance.new("TextLabel")
userName.Size = UDim2.new(1, -48, 0, 16)
userName.Position = UDim2.new(0, 46, 0, 9)
userName.BackgroundTransparency = 1
userName.Text = LocalPlayer.DisplayName or LocalPlayer.Name
userName.TextColor3 = THEME.Text
userName.Font = Enum.Font.GothamBold
userName.TextSize = 11
userName.TextXAlignment = Enum.TextXAlignment.Left
userName.TextTruncate = Enum.TextTruncate.AtEnd
userName.ZIndex = 103
userName.Parent = userCard

local userStatus = Instance.new("TextLabel")
userStatus.Size = UDim2.new(1, -48, 0, 14)
userStatus.Position = UDim2.new(0, 46, 0, 26)
userStatus.BackgroundTransparency = 1
userStatus.Text = "[ ACTIVE ]"
userStatus.TextColor3 = THEME.Success
userStatus.Font = Enum.Font.GothamMedium
userStatus.TextSize = 9
userStatus.TextXAlignment = Enum.TextXAlignment.Left
userStatus.ZIndex = 103
userStatus.Parent = userCard

-- Top Bar / Header Area
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, -150, 0, 50)
topBar.Position = UDim2.new(0, 150, 0, 0)
topBar.BackgroundTransparency = 1
topBar.Active = true
topBar.ZIndex = 102
topBar.Parent = mainFrame

makeDraggable(topBar, mainFrame)

local headerTitle = Instance.new("TextLabel")
headerTitle.Size = UDim2.new(0, 180, 0, 24)
headerTitle.Position = UDim2.new(0, 18, 0, 14)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "Aimbot"
headerTitle.TextColor3 = THEME.Text
headerTitle.Font = Enum.Font.GothamBold
headerTitle.TextSize = 16
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.ZIndex = 103
headerTitle.Parent = topBar

-- Top Telemetry Pills (FPS / Ping / Spoof Tag)
local telemetryFrame = Instance.new("Frame")
telemetryFrame.Size = UDim2.new(0, 210, 0, 24)
telemetryFrame.Position = UDim2.new(1, -280, 0, 13)
telemetryFrame.BackgroundTransparency = 1
telemetryFrame.ZIndex = 103
telemetryFrame.Parent = topBar

local telLayout = Instance.new("UIListLayout")
telLayout.FillDirection = Enum.FillDirection.Horizontal
telLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
telLayout.Padding = UDim.new(0, 6)
telLayout.Parent = telemetryFrame

local function makeChip(parent, text, col)
    local chip = Instance.new("Frame")
    chip.Size = UDim2.new(0, 62, 1, 0)
    chip.BackgroundColor3 = THEME.BgCard
    chip.BorderSizePixel = 0
    chip.ZIndex = 104
    chip.Parent = parent
    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 6)
    cc.Parent = chip
    local cs = Instance.new("UIStroke")
    cs.Color = THEME.Border
    cs.Thickness = 1
    cs.Parent = chip

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = col
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.ZIndex = 105
    lbl.Parent = chip
    return lbl
end

local fpsChip = makeChip(telemetryFrame, "60 FPS", THEME.AccentCyan)
local pingChip = makeChip(telemetryFrame, "24 MS", THEME.AccentLight)
local modeChip = makeChip(telemetryFrame, "PC", THEME.Success)

-- Window Controls (Minimize & Close)
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -62, 0, 12)
minBtn.BackgroundColor3 = THEME.BgCard
minBtn.TextColor3 = THEME.TextDim
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.BorderSizePixel = 0
minBtn.AutoButtonColor = false
minBtn.ZIndex = 104
minBtn.Parent = topBar
local mbc = Instance.new("UICorner")
mbc.CornerRadius = UDim.new(0, 6)
mbc.Parent = minBtn
local mbs = Instance.new("UIStroke")
mbs.Color = THEME.Border
mbs.Thickness = 1
mbs.Parent = minBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -32, 0, 12)
closeBtn.BackgroundColor3 = THEME.BgCard
closeBtn.TextColor3 = THEME.TextDim
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 11
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 104
closeBtn.Parent = topBar
local cbc = Instance.new("UICorner")
cbc.CornerRadius = UDim.new(0, 6)
cbc.Parent = closeBtn
local cbs = Instance.new("UIStroke")
cbs.Color = THEME.Border
cbs.Thickness = 1
cbs.Parent = closeBtn

minBtn.MouseEnter:Connect(function() minBtn.TextColor3 = THEME.Text end)
minBtn.MouseLeave:Connect(function() minBtn.TextColor3 = THEME.TextDim end)
closeBtn.MouseEnter:Connect(function()
    closeBtn.BackgroundColor3 = THEME.Danger
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)
closeBtn.MouseLeave:Connect(function()
    closeBtn.BackgroundColor3 = THEME.BgCard
    closeBtn.TextColor3 = THEME.TextDim
end)

-- Content Pages Host
local pagesContainer = Instance.new("Frame")
pagesContainer.Size = UDim2.new(1, -150, 1, -52)
pagesContainer.Position = UDim2.new(0, 150, 0, 52)
pagesContainer.BackgroundTransparency = 1
pagesContainer.ZIndex = 102
pagesContainer.Parent = mainFrame

-- Mobile Menu Floating Pill
local mobileMenuPill = Instance.new("Frame")
mobileMenuPill.Size = UDim2.new(0, 105, 0, 32)
mobileMenuPill.Position = UDim2.new(0.5, -52, 0, 18)
mobileMenuPill.BackgroundColor3 = THEME.BgPanel
mobileMenuPill.BorderSizePixel = 0
mobileMenuPill.ZIndex = 200
mobileMenuPill.Active = true
mobileMenuPill.Parent = gui

local mmpCorner = Instance.new("UICorner")
mmpCorner.CornerRadius = UDim.new(0, 8)
mmpCorner.Parent = mobileMenuPill

local mmpStroke = Instance.new("UIStroke")
mmpStroke.Color = THEME.Accent
mmpStroke.Thickness = 1.4
mmpStroke.Parent = mobileMenuPill

local mmpText = Instance.new("TextLabel")
mmpText.Size = UDim2.new(1, 0, 1, 0)
mmpText.BackgroundTransparency = 1
mmpText.Text = "MOONHUB"
mmpText.TextColor3 = THEME.Text
mmpText.Font = Enum.Font.GothamBold
mmpText.TextSize = 11
mmpText.ZIndex = 201
mmpText.Parent = mobileMenuPill

local isMenuOpen = true
local function toggleMenu()
    isMenuOpen = not isMenuOpen
    mainFrame.Visible = isMenuOpen
    if isMenuOpen then
        mmpStroke.Color = THEME.Accent
        mmpText.TextColor3 = THEME.Text
    else
        mmpStroke.Color = THEME.Border
        mmpText.TextColor3 = THEME.TextDim
    end
end

minBtn.MouseButton1Click:Connect(toggleMenu)
closeBtn.MouseButton1Click:Connect(toggleMenu)

local pillDragging = false
local pillDragStart, pillStartPos, pillMoved

mobileMenuPill.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        pillDragging = true
        pillMoved = false
        pillDragStart = input.Position
        pillStartPos = mobileMenuPill.Position

        local conn
        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                pillDragging = false
                if conn then conn:Disconnect() end
                if not pillMoved then
                    toggleMenu()
                end
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if pillDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - pillDragStart
        if delta.Magnitude > 4 then pillMoved = true end
        mobileMenuPill.Position = UDim2.new(
            pillStartPos.X.Scale,
            pillStartPos.X.Offset + delta.X,
            pillStartPos.Y.Scale,
            pillStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.RightControl then
        toggleMenu()
    end
end)

-- ============================================================================
-- MOBILE FLIGHT FLOATING CONTROLS
-- ============================================================================
local flightWidget = Instance.new("Frame")
flightWidget.Name = "MoonHub_FlightWidget"
flightWidget.Size = UDim2.new(0, 52, 0, 130)
flightWidget.Position = UDim2.new(1, -74, 0.45, 0)
flightWidget.BackgroundColor3 = THEME.BgCard
flightWidget.BorderSizePixel = 0
flightWidget.ZIndex = 250
flightWidget.Active = true
flightWidget.Visible = false
flightWidget.Parent = gui

local fwc = Instance.new("UICorner")
fwc.CornerRadius = UDim.new(0, 10)
fwc.Parent = flightWidget

local fws = Instance.new("UIStroke")
fws.Color = THEME.Border
fws.Thickness = 1.2
fws.Parent = flightWidget

local flightDragHeader = Instance.new("TextLabel")
flightDragHeader.Name = "DragHeader"
flightDragHeader.Size = UDim2.new(1, 0, 0, 18)
flightDragHeader.Position = UDim2.new(0, 0, 0, 2)
flightDragHeader.BackgroundTransparency = 1
flightDragHeader.Text = ":::"
flightDragHeader.TextColor3 = THEME.TextDim
flightDragHeader.Font = Enum.Font.GothamBold
flightDragHeader.TextSize = 12
flightDragHeader.ZIndex = 251
flightDragHeader.Parent = flightWidget

local flyUpBtn = Instance.new("TextButton")
flyUpBtn.Name = "FlyUp"
flyUpBtn.Size = UDim2.new(0, 42, 0, 48)
flyUpBtn.Position = UDim2.new(0.5, -21, 0, 22)
flyUpBtn.BackgroundColor3 = THEME.BgItem
flyUpBtn.BorderSizePixel = 0
flyUpBtn.ZIndex = 252
flyUpBtn.Text = "^"
flyUpBtn.TextColor3 = THEME.Accent
flyUpBtn.Font = Enum.Font.GothamBold
flyUpBtn.TextSize = 22
flyUpBtn.AutoButtonColor = false
flyUpBtn.Parent = flightWidget

local upCorner = Instance.new("UICorner")
upCorner.CornerRadius = UDim.new(0, 8)
upCorner.Parent = flyUpBtn

local flyDownBtn = Instance.new("TextButton")
flyDownBtn.Name = "FlyDown"
flyDownBtn.Size = UDim2.new(0, 42, 0, 48)
flyDownBtn.Position = UDim2.new(0.5, -21, 0, 74)
flyDownBtn.BackgroundColor3 = THEME.BgItem
flyDownBtn.BorderSizePixel = 0
flyDownBtn.ZIndex = 252
flyDownBtn.Text = "v"
flyDownBtn.TextColor3 = THEME.Accent
flyDownBtn.Font = Enum.Font.GothamBold
flyDownBtn.TextSize = 16
flyDownBtn.AutoButtonColor = false
flyDownBtn.Parent = flightWidget

local downCorner = Instance.new("UICorner")
downCorner.CornerRadius = UDim.new(0, 8)
downCorner.Parent = flyDownBtn

local flyAscending = false
local flyDescending = false

local function updateFlightWidgetVisibility()
    flightWidget.Visible = getgenv().FlightEnabled and getgenv().FlightMobileButtons
    if not flightWidget.Visible then
        flyAscending = false
        flyDescending = false
        flyUpBtn.BackgroundColor3 = THEME.BgItem
        flyUpBtn.TextColor3 = THEME.Accent
        flyDownBtn.BackgroundColor3 = THEME.BgItem
        flyDownBtn.TextColor3 = THEME.Accent
    end
end

flyUpBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        flyAscending = true
        flyUpBtn.BackgroundColor3 = THEME.Accent
        flyUpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

flyUpBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        flyAscending = false
        flyUpBtn.BackgroundColor3 = THEME.BgItem
        flyUpBtn.TextColor3 = THEME.Accent
    end
end)

flyDownBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        flyDescending = true
        flyDownBtn.BackgroundColor3 = THEME.Accent
        flyDownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

flyDownBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        flyDescending = false
        flyDownBtn.BackgroundColor3 = THEME.BgItem
        flyDownBtn.TextColor3 = THEME.Accent
    end
end)

makeDraggable(flightDragHeader, flightWidget)

-- Tab Builder
local pages = {}
local tabButtons = {}
local tabOrder = 0

local function createTab(tabName, tag)
    tabOrder = tabOrder + 1
    local order = tabOrder
    tag = tag or string.sub(string.upper(tabName), 1, 3)

    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 34)
    tabBtn.BackgroundColor3 = THEME.BgItem
    tabBtn.BackgroundTransparency = 1
    tabBtn.BorderSizePixel = 0
    tabBtn.AutoButtonColor = false
    tabBtn.Text = ""
    tabBtn.LayoutOrder = order
    tabBtn.ZIndex = 103
    tabBtn.Parent = tabList

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabBtn

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 0, 18)
    indicator.Position = UDim2.new(0, 4, 0.5, -9)
    indicator.BackgroundColor3 = THEME.Accent
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    indicator.ZIndex = 104
    indicator.Parent = tabBtn
    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(1, 0)
    indCorner.Parent = indicator

    local tagBadge = Instance.new("TextLabel")
    tagBadge.Size = UDim2.new(0, 28, 0, 16)
    tagBadge.Position = UDim2.new(0, 12, 0.5, -8)
    tagBadge.BackgroundColor3 = THEME.BgCard
    tagBadge.TextColor3 = THEME.AccentLight
    tagBadge.Text = "[" .. tag .. "]"
    tagBadge.Font = Enum.Font.Code
    tagBadge.TextSize = 9
    tagBadge.BorderSizePixel = 0
    tagBadge.ZIndex = 104
    tagBadge.Parent = tabBtn
    local tbc = Instance.new("UICorner")
    tbc.CornerRadius = UDim.new(0, 4)
    tbc.Parent = tagBadge

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -48, 1, 0)
    textLabel.Position = UDim2.new(0, 46, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = tabName
    textLabel.TextColor3 = THEME.TextDim
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.TextSize = 12
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.ZIndex = 104
    textLabel.Parent = tabBtn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -12)
    page.Position = UDim2.new(0, 10, 0, 6)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = THEME.Accent
    page.ScrollBarImageTransparency = 0.4
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false
    page.ZIndex = 102
    page.Parent = pagesContainer

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 10)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Parent = page

    local pagePad = Instance.new("UIPadding")
    pagePad.PaddingRight = UDim.new(0, 6)
    pagePad.PaddingTop = UDim.new(0, 4)
    pagePad.PaddingBottom = UDim.new(0, 14)
    pagePad.Parent = page

    pages[tabName] = page
    tabButtons[tabName] = {
        btn = tabBtn,
        text = textLabel,
        indicator = indicator,
        tag = tagBadge
    }

    local function selectTab()
        for name, p in pairs(pages) do p.Visible = (name == tabName) end
        for name, data in pairs(tabButtons) do
            local isSel = (name == tabName)
            data.indicator.Visible = isSel
            if isSel then
                data.btn.BackgroundColor3 = THEME.BgItem
                data.btn.BackgroundTransparency = 0
                data.text.TextColor3 = THEME.Text
                data.tag.TextColor3 = THEME.Accent
                headerTitle.Text = name
            else
                data.btn.BackgroundTransparency = 1
                data.text.TextColor3 = THEME.TextDim
                data.tag.TextColor3 = THEME.TextMuted
            end
        end
    end

    tabBtn.MouseButton1Click:Connect(selectTab)
    tabBtn.MouseEnter:Connect(function()
        if headerTitle.Text ~= tabName then
            tabBtn.BackgroundTransparency = 0.5
            textLabel.TextColor3 = THEME.Text
        end
    end)
    tabBtn.MouseLeave:Connect(function()
        if headerTitle.Text ~= tabName then
            tabBtn.BackgroundTransparency = 1
            textLabel.TextColor3 = THEME.TextDim
        end
    end)

    return page, selectTab
end

-- ============================================================================
-- 14. COMPONENT BUILDERS (Toggles, Sliders, Dropdowns, Buttons)
-- ============================================================================
local function makeSection(parent, title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 0)
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.BackgroundColor3 = THEME.BgCard
    section.BorderSizePixel = 0
    section.ZIndex = 103
    section.Parent = parent

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 8)
    sCorner.Parent = section

    local sStroke = Instance.new("UIStroke")
    sStroke.Color = THEME.Border
    sStroke.Thickness = 1
    sStroke.Parent = section

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundTransparency = 1
    header.ZIndex = 104
    header.Parent = section

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 6, 0, 6)
    dot.Position = UDim2.new(0, 12, 0.5, -3)
    dot.BackgroundColor3 = THEME.Accent
    dot.BorderSizePixel = 0
    dot.ZIndex = 105
    dot.Parent = header
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot

    local hLabel = Instance.new("TextLabel")
    hLabel.Size = UDim2.new(1, -28, 1, 0)
    hLabel.Position = UDim2.new(0, 24, 0, 0)
    hLabel.BackgroundTransparency = 1
    hLabel.Text = string.upper(title)
    hLabel.TextColor3 = THEME.Text
    hLabel.Font = Enum.Font.GothamBold
    hLabel.TextSize = 11
    hLabel.TextXAlignment = Enum.TextXAlignment.Left
    hLabel.ZIndex = 105
    hLabel.Parent = header

    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, -16, 0, 1)
    divider.Position = UDim2.new(0, 8, 0, 30)
    divider.BackgroundColor3 = THEME.Border
    divider.BorderSizePixel = 0
    divider.ZIndex = 104
    divider.Parent = section

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.Position = UDim2.new(0, 0, 0, 34)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.ZIndex = 104
    container.Parent = section

    local cLayout = Instance.new("UIListLayout")
    cLayout.Padding = UDim.new(0, 6)
    cLayout.SortOrder = Enum.SortOrder.LayoutOrder
    cLayout.Parent = container

    local cPad = Instance.new("UIPadding")
    cPad.PaddingLeft = UDim.new(0, 10)
    cPad.PaddingRight = UDim.new(0, 10)
    cPad.PaddingTop = UDim.new(0, 4)
    cPad.PaddingBottom = UDim.new(0, 10)
    cPad.Parent = container

    return container
end

-- Vibe-Coded Animated Toggle
local function makeToggle(parent, label, getter, setter)
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, 0, 0, 30)
    row.BackgroundColor3 = THEME.BgItem
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    row.AutoButtonColor = false
    row.Text = ""
    row.ZIndex = 105
    row.Parent = parent

    local tLabel = Instance.new("TextLabel")
    tLabel.Size = UDim2.new(1, -55, 1, 0)
    tLabel.Position = UDim2.new(0, 4, 0, 0)
    tLabel.BackgroundTransparency = 1
    tLabel.Text = label
    tLabel.TextColor3 = getter() and THEME.Text or THEME.TextDim
    tLabel.Font = Enum.Font.GothamMedium
    tLabel.TextSize = 12
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.ZIndex = 106
    tLabel.Parent = row

    local pill = Instance.new("Frame")
    pill.Size = UDim2.new(0, 36, 0, 18)
    pill.Position = UDim2.new(1, -40, 0.5, -9)
    pill.BackgroundColor3 = getter() and THEME.Accent or THEME.ToggleOff
    pill.BorderSizePixel = 0
    pill.ZIndex = 106
    pill.Parent = row
    local pc = Instance.new("UICorner")
    pc.CornerRadius = UDim.new(1, 0)
    pc.Parent = pill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = getter() and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = getter() and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 145, 160)
    knob.BorderSizePixel = 0
    knob.ZIndex = 107
    knob.Parent = pill
    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = knob

    local function updateVisual(val)
        local targetPill = val and THEME.Accent or THEME.ToggleOff
        local targetKnobPos = val and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        local targetKnobCol = val and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 145, 160)
        local targetTextCol = val and THEME.Text or THEME.TextDim

        TweenService:Create(pill, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { BackgroundColor3 = targetPill }):Play()
        TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { Position = targetKnobPos, BackgroundColor3 = targetKnobCol }):Play()
        tLabel.TextColor3 = targetTextCol
    end

    row.MouseButton1Click:Connect(function()
        local nextVal = not getter()
        setter(nextVal)
        updateVisual(nextVal)
    end)

    return row
end

-- Touch-Friendly Precision Slider
local function makeSlider(parent, label, getter, setter, step, min, max, unit)
    unit = unit or ""
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 46)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ZIndex = 105
    frame.Parent = parent

    local tLabel = Instance.new("TextLabel")
    tLabel.Size = UDim2.new(1, -70, 0, 16)
    tLabel.Position = UDim2.new(0, 4, 0, 2)
    tLabel.BackgroundTransparency = 1
    tLabel.Text = label
    tLabel.TextColor3 = THEME.Text
    tLabel.Font = Enum.Font.GothamMedium
    tLabel.TextSize = 12
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.ZIndex = 106
    tLabel.Parent = frame

    local valBadge = Instance.new("Frame")
    valBadge.Size = UDim2.new(0, 60, 0, 16)
    valBadge.Position = UDim2.new(1, -64, 0, 2)
    valBadge.BackgroundColor3 = THEME.BgItem
    valBadge.BorderSizePixel = 0
    valBadge.ZIndex = 106
    valBadge.Parent = frame
    local vbc = Instance.new("UICorner")
    vbc.CornerRadius = UDim.new(0, 4)
    vbc.Parent = valBadge

    local valText = Instance.new("TextLabel")
    valText.Size = UDim2.new(1, 0, 1, 0)
    valText.BackgroundTransparency = 1
    valText.Text = tostring(getter()) .. (unit ~= "" and (" " .. unit) or "")
    valText.TextColor3 = THEME.AccentLight
    valText.Font = Enum.Font.GothamBold
    valText.TextSize = 10
    valText.ZIndex = 107
    valText.Parent = valBadge

    -- Stepper Minus Button (Touch-Friendly)
    local minusBtn = Instance.new("TextButton")
    minusBtn.Size = UDim2.new(0, 22, 0, 18)
    minusBtn.Position = UDim2.new(0, 4, 0, 24)
    minusBtn.BackgroundColor3 = THEME.BgItem
    minusBtn.TextColor3 = THEME.TextDim
    minusBtn.Text = "[-]"
    minusBtn.Font = Enum.Font.Code
    minusBtn.TextSize = 11
    minusBtn.BorderSizePixel = 0
    minusBtn.AutoButtonColor = false
    minusBtn.ZIndex = 106
    minusBtn.Parent = frame
    local mc = Instance.new("UICorner")
    mc.CornerRadius = UDim.new(0, 4)
    mc.Parent = minusBtn

    -- Stepper Plus Button (Touch-Friendly)
    local plusBtn = Instance.new("TextButton")
    plusBtn.Size = UDim2.new(0, 22, 0, 18)
    plusBtn.Position = UDim2.new(1, -26, 0, 24)
    plusBtn.BackgroundColor3 = THEME.BgItem
    plusBtn.TextColor3 = THEME.TextDim
    plusBtn.Text = "[+]"
    plusBtn.Font = Enum.Font.Code
    plusBtn.TextSize = 11
    plusBtn.BorderSizePixel = 0
    plusBtn.AutoButtonColor = false
    plusBtn.ZIndex = 106
    plusBtn.Parent = frame
    local plc = Instance.new("UICorner")
    plc.CornerRadius = UDim.new(0, 4)
    plc.Parent = plusBtn

    -- Slider Drag Track
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -66, 0, 8)
    track.Position = UDim2.new(0, 33, 0, 29)
    track.BackgroundColor3 = THEME.ToggleOff
    track.BorderSizePixel = 0
    track.ZIndex = 106
    track.Parent = frame
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(1, 0)
    tc.Parent = track

    local initPct = math.clamp((getter() - min) / (max - min), 0, 1)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(initPct, 0, 1, 0)
    fill.BackgroundColor3 = THEME.Accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 107
    fill.Parent = track
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(1, 0)
    fc.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(initPct, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 108
    knob.Parent = track
    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = knob

    local function applyVal(v)
        v = math.clamp(v, min, max)
        setter(v)
        local pct = math.clamp((v - min) / (max - min), 0, 1)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, 0, 0.5, 0)
        valText.Text = tostring(v) .. (unit ~= "" and (" " .. unit) or "")
    end

    local sliding = false
    local function handleSlide(posX)
        local trackPos = track.AbsolutePosition.X
        local trackWidth = track.AbsoluteSize.X
        if trackWidth <= 0 then return end
        local rawPct = math.clamp((posX - trackPos) / trackWidth, 0, 1)
        local rawVal = min + (max - min) * rawPct
        local stepped = math.floor((rawVal / step) + 0.5) * step
        applyVal(stepped)
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            handleSlide(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            handleSlide(input.Position.X)
        end
    end)

    minusBtn.MouseButton1Click:Connect(function() applyVal(getter() - step) end)
    plusBtn.MouseButton1Click:Connect(function() applyVal(getter() + step) end)

    return frame
end

-- Vibe-Coded Dropdown Chip
local function makeDropdown(parent, label, options, getter, setter)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 32)
    frame.BackgroundTransparency = 1
    frame.ZIndex = 105
    frame.Parent = parent

    local tLabel = Instance.new("TextLabel")
    tLabel.Size = UDim2.new(0, 115, 1, 0)
    tLabel.Position = UDim2.new(0, 4, 0, 0)
    tLabel.BackgroundTransparency = 1
    tLabel.Text = label
    tLabel.TextColor3 = THEME.Text
    tLabel.Font = Enum.Font.GothamMedium
    tLabel.TextSize = 12
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.ZIndex = 106
    tLabel.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 125, 0, 24)
    btn.Position = UDim2.new(1, -129, 0.5, -12)
    btn.BackgroundColor3 = THEME.BgItem
    btn.TextColor3 = THEME.AccentLight
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Text = "[ " .. tostring(getter()) .. " ]"
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.ZIndex = 106
    btn.Parent = frame

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = btn

    local bs = Instance.new("UIStroke")
    bs.Color = THEME.Border
    bs.Thickness = 1
    bs.Parent = btn

    btn.MouseButton1Click:Connect(function()
        local cur = getter()
        local nextOpt = options[1]
        for i, opt in ipairs(options) do
            if opt == cur then
                nextOpt = options[i + 1] or options[1]
                break
            end
        end
        setter(nextOpt)
        btn.Text = "[ " .. tostring(nextOpt) .. " ]"
        TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = THEME.BgCardHover }):Play()
        task.delay(0.12, function()
            TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = THEME.BgItem }):Play()
        end)
    end)

    btn.MouseEnter:Connect(function()
        btn.TextColor3 = THEME.Text
        bs.Color = THEME.Accent
    end)
    btn.MouseLeave:Connect(function()
        btn.TextColor3 = THEME.AccentLight
        bs.Color = THEME.Border
    end)

    return frame
end

-- Vibe-Coded Action Button
local function makeButton(parent, label, btnText, onClick, isDanger)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 32)
    frame.BackgroundTransparency = 1
    frame.ZIndex = 105
    frame.Parent = parent

    local tLabel = Instance.new("TextLabel")
    tLabel.Size = UDim2.new(1, -115, 1, 0)
    tLabel.Position = UDim2.new(0, 4, 0, 0)
    tLabel.BackgroundTransparency = 1
    tLabel.Text = label
    tLabel.TextColor3 = THEME.Text
    tLabel.Font = Enum.Font.GothamMedium
    tLabel.TextSize = 12
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.ZIndex = 106
    tLabel.Parent = frame

    local actionBtn = Instance.new("TextButton")
    actionBtn.Size = UDim2.new(0, 100, 0, 24)
    actionBtn.Position = UDim2.new(1, -104, 0.5, -12)
    actionBtn.BackgroundColor3 = isDanger and THEME.Danger or THEME.BgItem
    actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    actionBtn.Font = Enum.Font.GothamBold
    actionBtn.TextSize = 11
    actionBtn.Text = btnText
    actionBtn.BorderSizePixel = 0
    actionBtn.AutoButtonColor = false
    actionBtn.ZIndex = 106
    actionBtn.Parent = frame

    local ac = Instance.new("UICorner")
    ac.CornerRadius = UDim.new(0, 6)
    ac.Parent = actionBtn

    local as = Instance.new("UIStroke")
    as.Color = isDanger and THEME.Danger or THEME.Border
    as.Thickness = 1
    as.Parent = actionBtn

    actionBtn.MouseButton1Click:Connect(function() pcall(onClick) end)

    actionBtn.MouseEnter:Connect(function()
        actionBtn.BackgroundColor3 = isDanger and Color3.fromRGB(255, 70, 70) or THEME.Accent
    end)
    actionBtn.MouseLeave:Connect(function()
        actionBtn.BackgroundColor3 = isDanger and THEME.Danger or THEME.BgItem
    end)

    return frame
end

-- ============================================================================
-- 15. BUILD HUB PAGES & FULL SUITE CONTROLS
-- ============================================================================
local aimbotPage, selectAimbot     = createTab("Aimbot", "AIM")
local silentPage                  = createTab("Silent Aim", "SIL")
local ragebotPage                 = createTab("Ragebot", "RAG")
local desyncPage                  = createTab("Client Desync", "DSY")
local visualsPage                 = createTab("Visuals", "VIS")
local movementPage                = createTab("Movement", "MOV")
local miscPage                    = createTab("Misc & Spoof", "MSC")
local settingsPage                = createTab("Settings", "SET")

selectAimbot()

-- TAB 1: AIMBOT
local aimSecActivation = makeSection(aimbotPage, "Aimbot Activation")
makeToggle(aimSecActivation, "Enable Aimbot", function() return getgenv().AimbotEnabled end, function(v) getgenv().AimbotEnabled = v end)
makeDropdown(aimSecActivation, "Aim Mode", {"Lock", "Linear", "Spring"}, function() return getgenv().AimbotMode end, function(v) getgenv().AimbotMode = v end)
makeDropdown(aimSecActivation, "Target Part", {"Head", "Torso", "Closest"}, function() return getgenv().AimbotTargetPart end, function(v) getgenv().AimbotTargetPart = v end)

local aimSecSettings = makeSection(aimbotPage, "Smoothing & Targeting")
makeSlider(aimSecSettings, "Smoothing Speed", function() return getgenv().AimbotSpeed end, function(v) getgenv().AimbotSpeed = v end, 1, 1, 15, "spd")
makeSlider(aimSecSettings, "FOV Radius", function() return getgenv().AimbotFOV end, function(v) getgenv().AimbotFOV = v end, 10, 10, 800, "px")
makeToggle(aimSecSettings, "Draw FOV Circle", function() return getgenv().AimbotShowFOV end, function(v) getgenv().AimbotShowFOV = v end)
makeToggle(aimSecSettings, "Wall Check (Visible Only)", function() return getgenv().AimbotWallCheck end, function(v) getgenv().AimbotWallCheck = v end)
makeToggle(aimSecSettings, "Team Check", function() return getgenv().AimbotTeamCheck end, function(v) getgenv().AimbotTeamCheck = v end)

-- TAB 2: SILENT AIM
local silentSecCore = makeSection(silentPage, "Silent Aim Core")
makeToggle(silentSecCore, "Enable Silent Aim", function() return getgenv().SilentAimEnabled end, function(v) getgenv().SilentAimEnabled = v end)
makeSlider(silentSecCore, "Hit Chance", function() return getgenv().SilentAimChance end, function(v) getgenv().SilentAimChance = v end, 5, 5, 100, "%")
makeDropdown(silentSecCore, "Target Hitbox", {"Head", "Torso"}, function() return getgenv().SilentAimHitbox end, function(v) getgenv().SilentAimHitbox = v end)
makeSlider(silentSecCore, "Target FOV", function() return getgenv().SilentAimFOV end, function(v) getgenv().SilentAimFOV = v end, 10, 10, 800, "px")
makeToggle(silentSecCore, "Wall Check", function() return getgenv().SilentAimWallCheck end, function(v) getgenv().SilentAimWallCheck = v end)

local silentSecDef = makeSection(silentPage, "Combat Defense")
makeToggle(silentSecDef, "Anti-Hit (Hitbox Query Bypass)", function()
    return getgenv().AntiHitEnabled
end, function(v)
    getgenv().AntiHitEnabled = v
    if v then applyAntiHit() else restoreAntiHit() end
end)

-- TAB 3: RAGEBOT (Original Step 27 Logic)
local rageSecCore = makeSection(ragebotPage, "Ragebot Execution")
makeToggle(rageSecCore, "Enable Ragebot", function() return getgenv().RageEnabled end, function(v)
    getgenv().RageEnabled = v
    if v and getgenv().RageAntiHit then applyAntiHit() end
end)
makeToggle(rageSecCore, "Teleport Mode (Random vs Orbit)", function() return getgenv().RageTeleportMode end, function(v) getgenv().RageTeleportMode = v end)
makeSlider(rageSecCore, "Orbit Distance", function() return getgenv().RageOrbitRadius end, function(v) getgenv().RageOrbitRadius = v end, 1, 2, 25, "studs")
makeSlider(rageSecCore, "Orbit Speed", function() return getgenv().RageOrbitSpeed end, function(v) getgenv().RageOrbitSpeed = v end, 1, 5, 50, "spd")
makeToggle(rageSecCore, "Clamp to Safe Floor", function() return getgenv().RageClampY end, function(v) getgenv().RageClampY = v end)

local rageSecFire = makeSection(ragebotPage, "Auto Weapon Fire")
makeToggle(rageSecFire, "Auto Fire Weapon", function() return getgenv().RageAutoFire end, function(v) getgenv().RageAutoFire = v end)
makeSlider(rageSecFire, "Fire Rate", function() return getgenv().RageFireRate end, function(v) getgenv().RageFireRate = v end, 0.01, 0.01, 0.3, "s")
makeToggle(rageSecFire, "Wallbang (Shoot Through Walls)", function() return getgenv().RageWallbang end, function(v) getgenv().RageWallbang = v end)

local rageSecDef = makeSection(ragebotPage, "Combat Defense")
makeToggle(rageSecDef, "Anti-Hit (Godmode)", function() return getgenv().RageAntiHit end, function(v)
    getgenv().RageAntiHit = v
    if v then applyAntiHit() else restoreAntiHit() end
end)
makeToggle(rageSecDef, "Round State Check", function() return getgenv().RageRoundCheck end, function(v) getgenv().RageRoundCheck = v end)

-- TAB 4: CLIENT DESYNC / FLOOR HIDE (Sleepy & UE Logic)
local dsySecCore = makeSection(desyncPage, "Surface Desync (Fake On Map)")
makeToggle(dsySecCore, "Enable Fake Position (Floor Hide)", function() return getgenv().FakePositionEnabled end, function(v)
    setFakePosition(v)
end)
makeToggle(dsySecCore, "Surface Camera Elevation", function() return getgenv().FakePositionSurfaceCam end, function(v) getgenv().FakePositionSurfaceCam = v end)
makeSlider(dsySecCore, "Underground Depth", function() return getgenv().FakePositionDepth end, function(v) getgenv().FakePositionDepth = v end, 0.5, 1, 15, "studs")
makeToggle(dsySecCore, "Walk Along Surface (WASD)", function() return getgenv().FakePositionWalkMode end, function(v) getgenv().FakePositionWalkMode = v end)
makeToggle(dsySecCore, "Auto Noclip Character", function() return getgenv().FakePositionAutoNoclip end, function(v) getgenv().FakePositionAutoNoclip = v end)
makeToggle(dsySecCore, "Zero Velocity Suppression", function() return getgenv().FakePositionZeroVelocity end, function(v) getgenv().FakePositionZeroVelocity = v end)

local dsySecAngles = makeSection(desyncPage, "Anti-Aim Desync Angles")
makeDropdown(dsySecAngles, "Head Pitch Mode", {"Down", "Up", "Jitter", "Zero"}, function() return getgenv().FakePositionPitchMode end, function(v)
    getgenv().FakePositionPitchMode = v
    fakePos.PitchMode = v
end)
makeDropdown(dsySecAngles, "Body Yaw Mode", {"Spin", "Backwards", "Jitter", "Sway"}, function() return getgenv().FakePositionYawMode end, function(v)
    getgenv().FakePositionYawMode = v
    fakePos.YawMode = v
end)

-- TAB 5: VISUALS
local visSecESP = makeSection(visualsPage, "Player ESP")
makeToggle(visSecESP, "Enable Box ESP", function() return getgenv().ESPEnabled end, function(v) getgenv().ESPEnabled = v end)
makeToggle(visSecESP, "Health Number (Kicia Style)", function() return getgenv().ESPHealthNumber end, function(v) getgenv().ESPHealthNumber = v end)
makeToggle(visSecESP, "Health Bar", function() return getgenv().ESPHealthBar end, function(v) getgenv().ESPHealthBar = v end)
makeToggle(visSecESP, "Display Names", function() return getgenv().ESPNames end, function(v) getgenv().ESPNames = v end)
makeToggle(visSecESP, "Distance Text", function() return getgenv().ESPDistance end, function(v) getgenv().ESPDistance = v end)

local visSecChams = makeSection(visualsPage, "Chams & Tracers")
makeToggle(visSecChams, "Chams Highlights", function() return getgenv().ChamsEnabled end, function(v) getgenv().ChamsEnabled = v end)
makeToggle(visSecChams, "Snapline Tracers", function() return getgenv().TracersEnabled end, function(v) getgenv().TracersEnabled = v end)

-- TAB 6: MOVEMENT
local moveSecFlight = makeSection(movementPage, "3D Flight (Mobile & PC)")
makeToggle(moveSecFlight, "Enable Flight", function() return getgenv().FlightEnabled end, function(v)
    getgenv().FlightEnabled = v
    if updateFlightWidgetVisibility then updateFlightWidgetVisibility() end
    if not v and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.AssemblyLinearVelocity = Vector3.zero end
    end
end)
makeSlider(moveSecFlight, "Flight Speed", function() return getgenv().FlightSpeed end, function(v) getgenv().FlightSpeed = v end, 5, 10, 300, "spd")
makeToggle(moveSecFlight, "Mobile Flight Buttons", function() return getgenv().FlightMobileButtons end, function(v)
    getgenv().FlightMobileButtons = v
    if updateFlightWidgetVisibility then updateFlightWidgetVisibility() end
end)

local moveSecSafety = makeSection(movementPage, "Collision & Safety")
makeToggle(moveSecSafety, "Anti-Out of Bounds", function()
    return getgenv().AntiOOBEnabled
end, function(v)
    getgenv().AntiOOBEnabled = v
    applyAntiOOB(v)
end)
makeToggle(moveSecSafety, "Safe Noclip (Floor Clamped)", function() return getgenv().NoclipEnabled end, function(v) getgenv().NoclipEnabled = v end)

local moveSecPhysics = makeSection(movementPage, "Speed & Jump Modifiers")
makeToggle(moveSecPhysics, "Speed Hack (Velocity Boost)", function() return getgenv().SpeedHackEnabled end, function(v)
    getgenv().SpeedHackEnabled = v
    if not v and LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 16 end
    end
end)
makeSlider(moveSecPhysics, "WalkSpeed", function() return getgenv().SpeedHackValue end, function(v) getgenv().SpeedHackValue = v end, 5, 16, 300, "spd")

makeToggle(moveSecPhysics, "Jump Power (Velocity Impulse)", function() return getgenv().JumpPowerEnabled end, function(v)
    getgenv().JumpPowerEnabled = v
    if not v and LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.JumpPower = 50 end
    end
end)
makeSlider(moveSecPhysics, "JumpPower", function() return getgenv().JumpPowerValue end, function(v) getgenv().JumpPowerValue = v end, 5, 30, 300, "pwr")

-- TAB 7: MISC & SPOOFER
local miscSecSpoof = makeSection(miscPage, "Device Spoofer")
makeToggle(miscSecSpoof, "Enable Device Spoofer", function() return getgenv().DeviceSpoofEnabled end, function(v)
    getgenv().DeviceSpoofEnabled = v
    if v then applyDeviceSpoof() else restoreDeviceSpoof() end
end)
makeDropdown(miscSecSpoof, "Spoofed Device", {"PC", "Mobile", "Console", "VR"}, function() return getgenv().DeviceSpoofType end, function(v)
    getgenv().DeviceSpoofType = v
    if getgenv().DeviceSpoofEnabled then applyDeviceSpoof() end
    if modeChip then modeChip.Text = tostring(v) end
end)
makeButton(miscSecSpoof, "Replicate Controls", "Re-Apply", function()
    applyDeviceSpoof()
    sendNotification("Device Spoofer", "Replicated " .. tostring(getgenv().DeviceSpoofType) .. " to server", 2)
end)

local miscSecUtils = makeSection(miscPage, "Utilities & Defense")
makeToggle(miscSecUtils, "Anti-Hit (Godmode)", function()
    return getgenv().AntiHitEnabled
end, function(v)
    getgenv().AntiHitEnabled = v
    if v then applyAntiHit() else restoreAntiHit() end
end)
makeButton(miscSecUtils, "Server Rejoin", "Rejoin", function()
    pcall(function()
        local ts = game:GetService("TeleportService")
        ts:Teleport(game.PlaceId, LocalPlayer)
    end)
end)

-- TAB 8: SETTINGS
local setSecWorld = makeSection(settingsPage, "World & Lighting")
makeToggle(setSecWorld, "Fullbright", function() return getgenv().FullbrightEnabled end, function(v)
    getgenv().FullbrightEnabled = v
    applyFullbright(v)
end)

local setSecMgmt = makeSection(settingsPage, "Script Management")
makeButton(setSecMgmt, "Unload MoonHub", "Unload", function()
    if getgenv().MoonHub and getgenv().MoonHub.Disconnect then
        getgenv().MoonHub.Disconnect()
    end
end, true)

-- ============================================================================
-- 16. CORE ENGINE LOOPS (Heartbeat & RenderStepped)
-- ============================================================================
local heartbeatConn = RunService.Heartbeat:Connect(function(dt)
    -- 1. Silent Aim Target Caching
    if getgenv().RageEnabled and getgenv().RageGlobalSilent then
        cachedSilentTarget = findRageTarget()
    elseif getgenv().SilentAimEnabled then
        cachedSilentTarget = findBestTarget(getgenv().SilentAimFOV, getgenv().SilentAimWallCheck, getgenv().SilentAimHitbox)
    else
        cachedSilentTarget = nil
    end

    -- 2. Aimbot Target Caching
    if getgenv().AimbotEnabled and not getgenv().RageEnabled then
        cachedAimbotTarget = findBestTarget(getgenv().AimbotFOV, getgenv().AimbotWallCheck, getgenv().AimbotTargetPart)
    else
        cachedAimbotTarget = nil
    end

    -- 3. Character Modifiers & Flight Engine
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        local cam = workspace.CurrentCamera

        -- 3D Flight (Mobile Virtual Joystick + PC Keyboard + On-Screen Touch Buttons)
        if getgenv().FlightEnabled and not fakePos.Enabled and hrp and hum and cam and hum.Health > 0 then
            local moveDir = Vector3.zero

            -- PC Keyboard Flight
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end

            -- Mobile Virtual Joystick Flight (Projected in 3D along Camera Orientation)
            if hum.MoveDirection.Magnitude > 0.05 then
                local camCF = cam.CFrame
                local flatLook = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z)
                local flatRight = Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z)
                if flatLook.Magnitude > 0.001 and flatRight.Magnitude > 0.001 then
                    local fwdDot = hum.MoveDirection:Dot(flatLook.Unit)
                    local rightDot = hum.MoveDirection:Dot(flatRight.Unit)
                    moveDir = moveDir + (camCF.LookVector * fwdDot) + (camCF.RightVector * rightDot)
                else
                    moveDir = moveDir + hum.MoveDirection
                end
            end

            -- Mobile Touch Buttons (Fly Up / Fly Down)
            if flyAscending then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if flyDescending then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end

            -- Apply Velocity or Hover Lock
            if moveDir.Magnitude > 0.02 then
                hrp.AssemblyLinearVelocity = moveDir.Unit * getgenv().FlightSpeed
            else
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
        elseif hrp and hum and hum.Health > 0 then
            -- Speed Hack Velocity Boost (Bypasses Rivals MechanicsController WalkSpeed Overrides)
            if getgenv().SpeedHackEnabled and not getgenv().RageEnabled and not fakePos.Enabled then
                hum.WalkSpeed = getgenv().SpeedHackValue
                if hum.MoveDirection.Magnitude > 0.05 then
                    local targetVel = hum.MoveDirection.Unit * getgenv().SpeedHackValue
                    hrp.AssemblyLinearVelocity = Vector3.new(targetVel.X, hrp.AssemblyLinearVelocity.Y, targetVel.Z)
                end
            end

            if getgenv().JumpPowerEnabled then
                hum.JumpPower = getgenv().JumpPowerValue
                hum.UseJumpPower = true
            end
        end

        if getgenv().AntiHitEnabled or (getgenv().RageEnabled and getgenv().RageAntiHit) then
            applyAntiHit()
        end

        checkVoidRescue()
    end

    -- 4. Client Surface Desync / Floor Hide (Sleepy & UE Logic)
    if fakePos.Enabled then
        local cChar = LocalPlayer.Character
        local cHrp = cChar and cChar:FindFirstChild("HumanoidRootPart")
        local cHum = cChar and cChar:FindFirstChildOfClass("Humanoid")
        if cHrp and cHum and cHum.Health > 0 then
            if not fakePos.VirtualCF then
                fakePos.VirtualCF = cHrp.CFrame
            end

            local cam = workspace.CurrentCamera
            local camLook = cam and cam.CFrame.LookVector or Vector3.new(0, 0, -1)
            local camYaw = math.atan2(-camLook.X, -camLook.Z)
            local surfaceRot = CFrame.Angles(0, camYaw, 0)

            -- Move along virtual surface with player input
            if fakePos.WalkMode then
                local moveDir = cHum.MoveDirection
                if moveDir.Magnitude > 0 then
                    local speed = cHum.WalkSpeed * (getgenv().SpeedHackEnabled and (getgenv().SpeedHackValue / 16) or 1)
                    local deltaPos = moveDir * (speed * dt)
                    fakePos.VirtualCF = CFrame.new(fakePos.VirtualCF.Position + deltaPos) * surfaceRot
                else
                    fakePos.VirtualCF = CFrame.new(fakePos.VirtualCF.Position) * surfaceRot
                end
            else
                fakePos.VirtualCF = CFrame.new(fakePos.VirtualCF.Position) * surfaceRot
            end

            local depth = getgenv().FakePositionDepth or fakePos.Depth
            local undergroundPos = fakePos.VirtualCF.Position - Vector3.new(0, depth, 0)

            -- Calculate Pitch & Yaw Desync
            local pAngle = 0
            if fakePos.PitchMode == "Down" then
                pAngle = -89
            elseif fakePos.PitchMode == "Up" then
                pAngle = 89
            elseif fakePos.PitchMode == "Jitter" then
                fakePos.JitterFlip = not fakePos.JitterFlip
                pAngle = fakePos.JitterFlip and -89 or 89
            end

            local yOffset = 0
            if fakePos.YawMode == "Spin" then
                fakePos.SpinAngle = (fakePos.SpinAngle + 25) % 360
                yOffset = fakePos.SpinAngle
            elseif fakePos.YawMode == "Backwards" then
                yOffset = 180
            elseif fakePos.YawMode == "Jitter" then
                fakePos.JitterFlip = not fakePos.JitterFlip
                yOffset = fakePos.JitterFlip and 135 or -135
            elseif fakePos.YawMode == "Sway" then
                fakePos.SwayAngle = fakePos.SwayAngle + (10 * fakePos.SwayDir)
                if math.abs(fakePos.SwayAngle) > 60 then fakePos.SwayDir = -fakePos.SwayDir end
                yOffset = 180 + fakePos.SwayAngle
            end

            local desyncRot = CFrame.Angles(math.rad(pAngle), math.rad(yOffset), 0)

            if fakePos.AutoNoclip then
                for _, p in ipairs(cChar:GetDescendants()) do
                    if p:IsA("BasePart") and p.CanCollide then
                        p.CanCollide = false
                    end
                end
            end

            if fakePos.ZeroVelocity then
                cHrp.AssemblyLinearVelocity = Vector3.zero
                cHrp.AssemblyAngularVelocity = Vector3.zero
                cHrp.Velocity = Vector3.zero
                cHrp.RotVelocity = Vector3.zero
            end

            cHrp.CFrame = CFrame.new(undergroundPos) * surfaceRot * desyncRot
        end
    end

    -- 5. Ragebot Operations (Reverted to Step 27 Original Logic)
    if getgenv().RageEnabled then
        local rChar = LocalPlayer.Character
        local rHrp = rChar and rChar:FindFirstChild("HumanoidRootPart")
        local rHum = rChar and rChar:FindFirstChildOfClass("Humanoid")
        if rHrp and rHum and rHum.Health > 0 then
            if rHrp.Position.Y < -5000 then
                rHrp.CFrame = CFrame.new(0, 50, 0)
            elseif isRoundActive() then
                local target = getAnyTargetForRage()
                if target then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)

                    local targetPos = target.Position
                    local finalPos

                    if getgenv().RageTeleportMode then
                        local rx = math.random(-getgenv().RageOrbitRadius, getgenv().RageOrbitRadius)
                        local rz = math.random(-getgenv().RageOrbitRadius, getgenv().RageOrbitRadius)
                        finalPos = targetPos + Vector3.new(rx, 3, rz)
                    else
                        orbitAngle = orbitAngle + math.rad(getgenv().RageOrbitSpeed)
                        local offset = Vector3.new(
                            math.cos(orbitAngle) * getgenv().RageOrbitRadius,
                            3,
                            math.sin(orbitAngle) * getgenv().RageOrbitRadius
                        )
                        finalPos = targetPos + offset
                    end

                    if getgenv().RageClampY then
                        local groundY = findGroundY(finalPos.X, finalPos.Z, targetPos.Y)
                        if finalPos.Y < groundY + 3 then
                            finalPos = Vector3.new(finalPos.X, groundY + 3, finalPos.Z)
                        end
                        local capY = targetPos.Y + 20
                        if finalPos.Y > capY then
                            finalPos = Vector3.new(finalPos.X, capY, finalPos.Z)
                        end
                    end

                    rHrp.CFrame = CFrame.new(finalPos, targetPos)
                    rHrp.Velocity = Vector3.zero
                    rHrp.RotVelocity = Vector3.zero
                    rHrp.AssemblyLinearVelocity = Vector3.zero
                    rHrp.AssemblyAngularVelocity = Vector3.zero

                    if getgenv().RageAntiHit then
                        applyAntiHit()
                    end

                    if getgenv().RageAutoFire then
                        local now = tick()
                        if now - lastRageFire >= getgenv().RageFireRate then
                            lastRageFire = now
                            fireAtTarget(target)
                            triggerWeaponFire()
                        end
                    end
                end
            end
        end
    end
end)

pcall(function() RunService:UnbindFromRenderStep("MoonHub_CameraLock") end)
RunService:BindToRenderStep("MoonHub_CameraLock", Enum.RenderPriority.Camera.Value + 1, function()
    -- UE / Kicia Mobile & PC Zero-Flick Aimbot Lock
    if getgenv().AimbotEnabled and not getgenv().RageEnabled and cachedAimbotTarget then
        executeAimbotLock(cachedAimbotTarget, getgenv().AimbotMode, getgenv().AimbotSpeed)
    end
end)

local renderConn = RunService.RenderStepped:Connect(function()
    -- 1. Surface Camera Elevation for Fake Position (Floor Hide)
    if fakePos.Enabled and getgenv().FakePositionSurfaceCam then
        local cam = workspace.CurrentCamera
        local depth = getgenv().FakePositionDepth or fakePos.Depth
        if cam and depth > 0 then
            cam.CFrame = cam.CFrame + Vector3.new(0, depth, 0)
        end
    end

    -- 3. Visuals Tick
    updateESP()
    updateChams()
    updateTracers()
    updateFOVCircle()

    -- 4. Telemetry Watermark & Top Bar Chips
    frameTally = frameTally + 1
    local now = tick()
    if now - lastFpsTime >= 1 then
        fpsValue = math.floor(frameTally / (now - lastFpsTime))
        frameTally = 0
        lastFpsTime = now

        pcall(function()
            local stats = game:GetService("Stats")
            local net = stats and stats:FindFirstChild("Network")
            local serverStats = net and net:FindFirstChild("ServerStatsItem")
            local pingItem = serverStats and serverStats:FindFirstChild("Data Ping")
            if pingItem then
                pingValue = math.floor(pingItem:GetValue())
            end
        end)

        if fpsChip then fpsChip.Text = tostring(fpsValue) .. " FPS" end
        if pingChip then pingChip.Text = tostring(pingValue) .. " MS" end
        if modeChip then modeChip.Text = tostring(getgenv().DeviceSpoofType or "PC") end
    end
end)

-- Physics Pre-Step Collision Handler (Safe Noclip with Floor Clamping)
local steppedConn = RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    -- Safe Noclip Execution
    if getgenv().NoclipEnabled or (fakePos.Enabled and getgenv().FakePositionAutoNoclip) then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end

        -- Ground Clamp Protection: Prevents falling through floors into the void
        -- Active when Safe Noclip is on and player is not using 3D Flight or Desync Floor-Hide
        if getgenv().NoclipEnabled and not getgenv().FlightEnabled and not fakePos.Enabled then
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = { char }
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            rayParams.IgnoreWater = true

            local probeOrigin = hrp.Position + Vector3.new(0, 1, 0)
            local groundRay = workspace:Raycast(probeOrigin, Vector3.new(0, -12, 0), rayParams)
            if groundRay then
                local floorY = groundRay.Position.Y
                local targetY = floorY + 3.0

                -- When sinking below floor, clamp root part to surface and cancel downward velocity
                if hrp.Position.Y <= targetY then
                    hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z) * (hrp.CFrame - hrp.Position)
                    if hrp.AssemblyLinearVelocity.Y < 0 then
                        hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
                    end
                    if hum:GetState() == Enum.HumanoidStateType.Freefall then
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end
            end
        end
    end
end)

-- Direct Jump Impulse (Bypasses Rivals MechanicsController Jump Suppressions)
local jumpConn = UserInputService.JumpRequest:Connect(function()
    if not getgenv().JumpPowerEnabled or fakePos.Enabled or getgenv().FlightEnabled then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hrp and hum and hum.Health > 0 then
        local curVel = hrp.AssemblyLinearVelocity
        hrp.AssemblyLinearVelocity = Vector3.new(curVel.X, getgenv().JumpPowerValue, curVel.Z)
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ============================================================================
-- 17. CLEAN UNLOAD & RESTORATION
-- ============================================================================
local function disconnectAll()
    pcall(function() heartbeatConn:Disconnect() end)
    pcall(function() renderConn:Disconnect() end)
    pcall(function() steppedConn:Disconnect() end)
    pcall(function() jumpConn:Disconnect() end)
    pcall(function() RunService:UnbindFromRenderStep("MoonHub_CameraLock") end)
    pcall(function() flightWidget:Destroy() end)

    if fakePos.Enabled then
        setFakePosition(false)
    end

    restoreAntiHit()
    restoreDeviceSpoof()
    applyAntiOOB(false)
    applyFullbright(false)

    if oldNamecall and hookmetamethod then
        pcall(function() hookmetamethod(game, "__namecall", oldNamecall) end)
    end

    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end

    pcall(function() gui:Destroy() end)

    getgenv().AimbotEnabled         = false
    getgenv().SilentAimEnabled      = false
    getgenv().RageEnabled           = false
    getgenv().FakePositionEnabled   = false
    getgenv().AntiHitEnabled        = false
    getgenv().AntiOOBEnabled        = false
    getgenv().ESPEnabled            = false
    getgenv().ESPHealthNumber       = false
    getgenv().ESPHealthBar          = false
    getgenv().ChamsEnabled          = false
    getgenv().TracersEnabled        = false
    getgenv().AimbotShowFOV         = false
    getgenv().NoclipEnabled         = false
    getgenv().FlightEnabled         = false
    getgenv().FlightMobileButtons   = false
    getgenv().SpeedHackEnabled      = false
    getgenv().JumpPowerEnabled      = false
    getgenv().FullbrightEnabled     = false
    getgenv().DeviceSpoofEnabled    = false

    print("[MoonHub] Unloaded and restored successfully.")
end

getgenv().MoonHub = {
    Disconnect = disconnectAll
}
getgenv().KiciaHook = getgenv().MoonHub
getgenv().HeadLock = getgenv().MoonHub

sendNotification("MoonHub Elite", "v3.2 loaded. Tap [ MOONHUB ] or press RightShift", 4)
print("[MoonHub] Elite v3.2 successfully loaded.")
