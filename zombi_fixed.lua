--==========================================================================
--  Zombie Killer - Mobile (God Mode Explosion Evasion + Anti-Aim)
--  Fixed: proper zombie type detection, explosion dodge range tuning,
--         GiantChombie slam dodge, HunterZombie leap dodge,
--         HelmetZombie head-aim fix, FlagZombie low-HP dodge
--==========================================================================
if getgenv().ZK_Unload then pcall(getgenv().ZK_Unload) end

local repS = cloneref(game:GetService("ReplicatedStorage"))
local plrs = cloneref(game:GetService("Players"))
local runS = cloneref(game:GetService("RunService"))
local ws   = cloneref(game:GetService("Workspace"))
local uis  = cloneref(game:GetService("UserInputService"))
local lplr = plrs.LocalPlayer
local PlayerGui = lplr:WaitForChild("PlayerGui")

local util = require(repS.Modules.Utility)
local enum = require(repS.Modules.EnumLibrary)
local FighterController = require(lplr.PlayerScripts.Controllers.FighterController)
local UseItemRemote = repS.Remotes.Replication.Fighter.UseItem
local RespawnRemote = repS.Remotes.Duels.RespawnNow

getgenv().Config = {
    Enabled        = true,
    FireRate       = 0.001,
    WeaponSlot     = "Primary",
    MaxDistance    = 1000,

    -- Anti-Explosion: dodges ExplosiveZombie blast at <15% HP
    AntiExplosion       = true,
    AntiExplosionHeight = 300,

    -- Desync: shift server-side origin when firing
    DesyncEnabled  = true,
    DesyncMode     = "offscreen",
    DesyncHeight   = 1.0,
    DesyncBack     = 2.0,

    -- Anti-Aim: spin server hitbox to break incoming attacks
    AntiAim        = true,
    AntiAimSpeed   = 360,

    -- Zombie-type specific dodges
    AntiSlam       = true,   -- GiantChombie slam dodge
    AntiLeap       = true,   -- HunterZombie leap dodge
    AimAtHelmet    = true,   -- HelmetZombie: aim at Head not ZombieHead

    -- Explosion dodge distance: only dodge if ExplosiveZombie within this range
    ExplosionDodgeRange = 60,
}

local slots = { Primary = 1, Secondary = 2, Melee = 3 }
local State = {
    unloaded      = false,
    lastFire      = 0,
    lastEquip     = 0,
    target        = nil,
    restoreConn   = nil,
    connections   = {},
    -- per-zombie-type tracking
    slamActive    = false,
    leapActive    = false,
}

-- Zombie type tags (matched against model Name or tag attributes)
-- Based on the decompiled client classes
local ZOMBIE_TYPES = {
    Explosive = "ExplosiveZombie",   -- blows up at low HP
    Flag      = "FlagZombie",        -- empowers nearby zombies
    Helmet    = "HelmetZombie",      -- helmeted, aim at head to dink
    Giant     = "GiantChombie",      -- slam attack
    Hunter    = "HunterZombie",      -- leap attack
}

local function track(c)
    table.insert(State.connections, c)
    return c
end

local function getZombieType(model)
    local name = model.Name
    for typeKey, typeName in pairs(ZOMBIE_TYPES) do
        if name:find(typeName) or name:find(typeKey) then
            return typeKey
        end
    end
    -- Fallback: check for type-specific children
    if model:FindFirstChild("ZombieHead") then
        -- Could be any zombie type with a ZombieHead
        return "Generic"
    end
    return "Generic"
end

--==========================================================================
--  Auto Respawn
--==========================================================================
track(lplr.CharacterAdded:Connect(function()
    task.wait(0.1)
    local char = lplr.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        pcall(function() RespawnRemote:FireServer() end)
    end
end))

--==========================================================================
--  Auto Equip Loop
--==========================================================================
track(task.spawn(function()
    while not State.unloaded do
        task.wait(0.5)
        if not getgenv().Config.Enabled then continue end
        if tick() - State.lastEquip < 0.5 then continue end
        State.lastEquip = tick()
        local lf = FighterController.LocalFighter
        if lf and not lf.EquippedItem then
            pcall(function() lf:EquipItem(slots[getgenv().Config.WeaponSlot] or 1) end)
        end
    end
end))

--==========================================================================
--  Target Detection
--==========================================================================
local function getClosestTarget()
    local char = lplr.Character
    if not char then return nil end
    local myRoot = char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    local closest, closestDist = nil, getgenv().Config.MaxDistance
    local myPos = myRoot.Position

    for _, obj in ipairs(ws:GetDescendants()) do
        if obj:IsA("Model") and obj ~= char and not plrs:GetPlayerFromCharacter(obj) then
            local hum = obj:FindFirstChildWhichIsA("Humanoid")
            if hum and hum.Health > 0 then
                local root = obj:FindFirstChild("HumanoidRootPart")

                -- Determine correct aim part per zombie type
                -- HelmetZombie: use Head (the dink target)
                -- All others: prefer ZombieHead, fallback to Head
                local zombieType = getZombieType(obj)
                local head
                if zombieType == "Helmet" and getgenv().Config.AimAtHelmet then
                    head = obj:FindFirstChild("Head")
                else
                    head = obj:FindFirstChild("ZombieHead") or obj:FindFirstChild("Head")
                end

                if root and head then
                    local d = (myPos - root.Position).Magnitude
                    if d < closestDist then
                        closestDist = d
                        closest = {
                            Model       = obj,
                            Root        = root,
                            Head        = head,
                            Hum         = hum,
                            Distance    = d,
                            ZombieType  = zombieType,
                        }
                    end
                end
            end
        end
    end
    return closest
end

--==========================================================================
--  Desync CFrame
--==========================================================================
local function computeDesyncCFrame(target, myRoot)
    local root, head = target.Root, target.Head
    local cfg = getgenv().Config
    local offset

    if cfg.DesyncMode == "offscreen" then
        return CFrame.lookAt(root.Position + Vector3.new(0, 1000, 0), head.Position)
    elseif cfg.DesyncMode == "behind" then
        offset = CFrame.new(0, cfg.DesyncHeight, cfg.DesyncBack)
    elseif cfg.DesyncMode == "front" then
        offset = CFrame.new(0, cfg.DesyncHeight, -cfg.DesyncBack)
    else
        offset = CFrame.new(0, cfg.DesyncHeight + 2, 0)
    end

    return CFrame.lookAt((root.CFrame * offset).Position, head.Position)
end

--==========================================================================
--  Firing Logic + Anti-Aim
--==========================================================================
local function fireWithDesync(item, target)
    local char = lplr.Character
    if not char then return end
    local myRoot = char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local cfg = getgenv().Config
    local originPos, aimPos = myRoot.Position, target.Head.Position
    local oldCF  = myRoot.CFrame
    local oldVel = myRoot.Velocity
    local oldRotVel = myRoot.RotVelocity

    if cfg.DesyncEnabled then
        local desyncCF = computeDesyncCFrame(target, myRoot)
        originPos = desyncCF.Position
        myRoot.CFrame = desyncCF

        if State.restoreConn then State.restoreConn:Disconnect() end
        State.restoreConn = runS.RenderStepped:Connect(function()
            if myRoot and myRoot.Parent then
                myRoot.CFrame, myRoot.Velocity, myRoot.RotVelocity = oldCF, oldVel, oldRotVel
            end
            if State.restoreConn then State.restoreConn:Disconnect(); State.restoreConn = nil end
        end)
    end

    -- Anti-Aim: spin server hitbox
    if cfg.AntiAim and myRoot then
        local spinAngle = math.rad((tick() * cfg.AntiAimSpeed) % 360)
        myRoot.CFrame = CFrame.new(myRoot.Position)
            * CFrame.Angles(0, spinAngle, 0)
            * CFrame.Angles(math.rad(math.random(-90, 90)), 0, 0)

        if State.restoreConn then State.restoreConn:Disconnect() end
        State.restoreConn = runS.RenderStepped:Connect(function()
            if myRoot and myRoot.Parent then
                myRoot.CFrame, myRoot.Velocity, myRoot.RotVelocity = oldCF, oldVel, oldRotVel
            end
            if State.restoreConn then State.restoreConn:Disconnect(); State.restoreConn = nil end
        end)
    end

    local aimCF = CFrame.lookAt(originPos, aimPos)
    local rand = Vector3.new(
        (math.random() - 0.5) * 0.02,
        (math.random() - 0.5) * 0.02,
        (math.random() - 0.5) * 0.02
    )
    local objSpaceHead = target.Head.CFrame:ToObjectSpace(CFrame.new(aimPos + rand))

    local cameraData = {
        [utf8.char(1)] = {
            [utf8.char(0)] = util:EncodeCFrame(aimCF),
            [utf8.char(1)] = util:EncodeCFrame(target.Head.CFrame),
            [utf8.char(2)] = target.Head,
            [utf8.char(3)] = util:EncodeCFrame(objSpaceHead),
        }
    }

    pcall(function()
        UseItemRemote:FireServer(item:Get("ObjectID"), enum:ToEnum("StartShooting"), cameraData, nil)
    end)
end

--==========================================================================
--  ANTI-EXPLOSION  (ExplosiveZombie: ZombieExplosionEffect)
--  Triggers when target HP < 15% AND within ExplosionDodgeRange
--==========================================================================
local currentlyDodging = false

local function dodgeExplosion(target)
    local cfg = getgenv().Config
    if currentlyDodging or not cfg.AntiExplosion then return end
    local char = lplr.Character
    if not char then return end
    local myRoot = char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    -- Only dodge if the explosive zombie is close enough to hurt us
    if target and target.Root then
        local dist = (myRoot.Position - target.Root.Position).Magnitude
        if dist > cfg.ExplosionDodgeRange then return end
    end

    currentlyDodging = true
    local originalCF = myRoot.CFrame

    myRoot.CFrame = originalCF + Vector3.new(0, cfg.AntiExplosionHeight, 0)

    task.delay(0.15, function()
        if myRoot and myRoot.Parent then
            myRoot.CFrame = originalCF
        end
        currentlyDodging = false
    end)
end

--==========================================================================
--  ANTI-SLAM  (GiantChombie: SlamEffect)
--  When GiantChombie is targeted, teleport up during slam timing window
--==========================================================================
local function dodgeSlam(target)
    if not getgenv().Config.AntiSlam then return end
    if State.slamActive then return end
    local char = lplr.Character
    if not char then return end
    local myRoot = char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    -- GiantChombie slam: the slam lands ~1.5s after wind-up
    -- We detect it by checking if the GiantChombie is within slam range
    -- (server replicates SlamEffect at ~v19 seconds delay = ~0.6-1s)
    local slamRange = 50
    if target and target.Root then
        local dist = (myRoot.Position - target.Root.Position).Magnitude
        if dist > slamRange then return end
    end

    State.slamActive = true
    local originalCF = myRoot.CFrame
    myRoot.CFrame = originalCF + Vector3.new(0, 200, 0)

    task.delay(0.4, function()
        if myRoot and myRoot.Parent then
            myRoot.CFrame = originalCF
        end
        State.slamActive = false
    end)
end

--==========================================================================
--  ANTI-LEAP  (HunterZombie: HunterLeapEffect)
--  When Hunter is detected leaping (health changes fast), dodge sideways
--==========================================================================
local function dodgeLeap(target)
    if not getgenv().Config.AntiLeap then return end
    if State.leapActive then return end
    local char = lplr.Character
    if not char then return end
    local myRoot = char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local leapRange = 80
    if target and target.Root then
        local dist = (myRoot.Position - target.Root.Position).Magnitude
        if dist > leapRange then return end
    end

    State.leapActive = true
    local originalCF = myRoot.CFrame
    -- Dodge sideways to break leap tracking
    local sideDir = myRoot.CFrame.RightVector * 20
    myRoot.CFrame = originalCF + sideDir + Vector3.new(0, 15, 0)

    task.delay(0.3, function()
        if myRoot and myRoot.Parent then
            myRoot.CFrame = originalCF
        end
        State.leapActive = false
    end)
end

--==========================================================================
--  Main Heartbeat Loop
--==========================================================================
track(runS.Heartbeat:Connect(function()
    if State.unloaded or not getgenv().Config.Enabled then return end

    local target = State.target
    if target and target.Model and target.Model.Parent and target.Hum then
        local hp    = target.Hum.Health
        local maxHp = target.Hum.MaxHealth
        local ztype = target.ZombieType

        -- ExplosiveZombie: dodge when below 15% HP (about to blow)
        if (ztype == "Explosive" or ztype == "Generic") and hp > 0 and hp < (maxHp * 0.15) then
            dodgeExplosion(target)
        end

        -- GiantChombie: dodge slam when below 50% HP (more aggressive)
        if ztype == "Giant" and hp > 0 and hp < (maxHp * 0.5) then
            dodgeSlam(target)
        end

        -- HunterZombie: dodge leap when below 70% HP (they leap often)
        if ztype == "Hunter" and hp > 0 and hp < (maxHp * 0.7) then
            dodgeLeap(target)
        end

        -- FlagZombie: treat like explosive (EmpowerOtherEntityEffect can buff enemies)
        -- Just prioritise killing it fast — no special dodge needed
    end

    local lf = FighterController.LocalFighter
    if not lf or not lf.EquippedItem then return end

    local newTarget = getClosestTarget()
    State.target = newTarget
    if not newTarget then return end

    if tick() - State.lastFire < getgenv().Config.FireRate then return end
    State.lastFire = tick()
    fireWithDesync(lf.EquippedItem, newTarget)
end))

--==========================================================================
--  Custom Mobile UI
--==========================================================================
local gui = Instance.new("ScreenGui")
gui.Name = "ZK_CustomUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.fromOffset(290, 580)
mainFrame.Position = UDim2.new(0.5, -145, 0.5, -290)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 180, 80)
stroke.Thickness = 1.5
stroke.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Zombie Killer"
title.TextColor3 = Color3.fromRGB(80, 180, 80)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(32, 32)
closeBtn.Position = UDim2.new(1, -38, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BorderSizePixel = 0
closeBtn.Parent = mainFrame
Instance.new("UICorner").Parent = closeBtn
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -50)
scroll.Position = UDim2.fromOffset(10, 45)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 180, 80)
scroll.Parent = mainFrame

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 10)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = scroll

local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.fromOffset(50, 50)
floatBtn.Position = UDim2.new(0, 20, 0.5, 0)
floatBtn.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
floatBtn.Text = "ZK"
floatBtn.TextColor3 = Color3.new(1, 1, 1)
floatBtn.Font = Enum.Font.GothamBold
floatBtn.TextSize = 18
floatBtn.BorderSizePixel = 0
floatBtn.Draggable = true
floatBtn.Parent = gui
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(1, 0)

floatBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Section header helper
local function addHeader(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = "── " .. text .. " ──"
    lbl.TextColor3 = Color3.fromRGB(80, 180, 80)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.Parent = scroll
end

-- UI Helpers
local function addToggle(text, getter, setter)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 35)
    row.BackgroundTransparency = 1
    row.Parent = scroll

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(50, 26)
    btn.Position = UDim2.new(1, -50, 0.5, -13)
    btn.BackgroundColor3 = getter() and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(60, 60, 65)
    btn.Text = getter() and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = row
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    btn.MouseButton1Click:Connect(function()
        setter(not getter())
        btn.Text = getter() and "ON" or "OFF"
        btn.BackgroundColor3 = getter() and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(60, 60, 65)
    end)
end

local function addSlider(text, min, max, getter, setter, isFloat)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 50)
    row.BackgroundTransparency = 1
    row.Parent = scroll

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. tostring(getter())
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 8)
    bar.Position = UDim2.new(0, 0, 0, 32)
    bar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    bar.BorderSizePixel = 0
    bar.Parent = row
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.fromScale((getter() - min) / (max - min), 1)
    fill.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
    fill.BorderSizePixel = 0
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = bar

    local dragging = false
    local function update(input)
        local p = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local v = min + (max - min) * p
        if not isFloat then v = math.floor(v) else v = tonumber(string.format("%.3f", v)) end
        setter(v)
        fill.Size = UDim2.fromScale(p, 1)
        lbl.Text = text .. ": " .. tostring(v)
    end

    btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(i)
        end
    end)
    track(uis.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            update(i)
        end
    end))
    track(uis.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
end

local function addDropdown(text, options, getter, setter)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 50)
    row.BackgroundTransparency = 1
    row.Parent = scroll

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 26)
    btn.Position = UDim2.new(0, 0, 0, 22)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.Text = tostring(getter())
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = row
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local currentIndex = 1
    for i, v in ipairs(options) do if v == getter() then currentIndex = i break end end

    btn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex % #options + 1
        setter(options[currentIndex])
        btn.Text = tostring(options[currentIndex])
    end)
end

-- Build UI
addHeader("General")
addToggle("Enable Auto-Shoot",        function() return getgenv().Config.Enabled      end, function(v) getgenv().Config.Enabled      = v end)
addDropdown("Weapon Slot", {"Primary","Secondary","Melee"}, function() return getgenv().Config.WeaponSlot end, function(v) getgenv().Config.WeaponSlot = v end)
addSlider("Fire Rate (sec)", 0.00, 0.2, function() return getgenv().Config.FireRate    end, function(v) getgenv().Config.FireRate    = v end, true)
addSlider("Max Distance",    50, 2000,  function() return getgenv().Config.MaxDistance end, function(v) getgenv().Config.MaxDistance = v end, false)

addHeader("Desync")
addToggle("Desync (Safe Shooting)",   function() return getgenv().Config.DesyncEnabled end, function(v) getgenv().Config.DesyncEnabled = v end)
addDropdown("Desync Mode", {"offscreen","behind","front","above"}, function() return getgenv().Config.DesyncMode end, function(v) getgenv().Config.DesyncMode = v end)
addSlider("Desync Height", 0, 10,  function() return getgenv().Config.DesyncHeight end, function(v) getgenv().Config.DesyncHeight = v end, true)
addSlider("Desync Back",  -5, 10,  function() return getgenv().Config.DesyncBack   end, function(v) getgenv().Config.DesyncBack   = v end, true)

addHeader("Anti-Aim")
addToggle("Anti-Aim (Spin Hitbox)",   function() return getgenv().Config.AntiAim      end, function(v) getgenv().Config.AntiAim      = v end)
addSlider("Anti-Aim Speed", 100, 1000, function() return getgenv().Config.AntiAimSpeed end, function(v) getgenv().Config.AntiAimSpeed = v end, false)

addHeader("Zombie Type Dodges")
addToggle("Anti-Explosion (ExplosiveZombie)", function() return getgenv().Config.AntiExplosion end, function(v) getgenv().Config.AntiExplosion = v end)
addSlider("Explosion Dodge Dist", 20, 200, function() return getgenv().Config.ExplosionDodgeRange end, function(v) getgenv().Config.ExplosionDodgeRange = v end, false)
addSlider("Explosion Dodge Height", 50, 600, function() return getgenv().Config.AntiExplosionHeight end, function(v) getgenv().Config.AntiExplosionHeight = v end, false)
addToggle("Anti-Slam (GiantChombie)", function() return getgenv().Config.AntiSlam     end, function(v) getgenv().Config.AntiSlam     = v end)
addToggle("Anti-Leap (HunterZombie)", function() return getgenv().Config.AntiLeap     end, function(v) getgenv().Config.AntiLeap     = v end)
addToggle("Aim Head (HelmetZombie)",  function() return getgenv().Config.AimAtHelmet  end, function(v) getgenv().Config.AimAtHelmet  = v end)

scroll.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y)

--==========================================================================
--  Unload
--==========================================================================
getgenv().ZK_Unload = function()
    if State.unloaded then return end
    State.unloaded = true
    for _, c in ipairs(State.connections) do pcall(function() c:Disconnect() end) end
    State.connections = {}
    if State.restoreConn then State.restoreConn:Disconnect() end
    if gui then gui:Destroy() end
end

print("[ZK] Loaded! Anti-Aim, Anti-Slam, Anti-Leap active.")
