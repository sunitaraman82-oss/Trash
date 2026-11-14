-- =====================================================================
-- ECLIPSE / SOURCE HYBRID (100% Accurate to Sources)
-- =====================================================================
local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Options = Library.Options
local Toggles = Library.Toggles
local isMobile = game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").KeyboardEnabled

Library.IsMobile = isMobile
Library.ShowCustomCursor = false
Library.ShowToggleFrameInKeybinds = isMobile
Library.MainColor       = Color3.fromRGB(18, 18, 20)
Library.BackgroundColor = Color3.fromRGB(10, 10, 12)
Library.AccentColor     = Color3.fromRGB(235, 64, 80)
Library.OutlineColor    = Color3.fromRGB(35, 35, 40)
Library.FontColor       = Color3.fromRGB(255, 255, 255)

local Window = Library:CreateWindow({
    Title = 'Eclipse',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2,
    NotifySide = 'Right',
    Resizable = true,
    UnlockMouseWhileOpen = true,
})

local Tabs = {
    Aimbot = Window:AddTab('Aimbot'),
    SilentAim = Window:AddTab('Silent Aim'),
    Ragebot = Window:AddTab('Ragebot'),
    Visuals = Window:AddTab('Visuals'),
    Settings = Window:AddTab('Settings'),
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if Workspace.CurrentCamera then Camera = Workspace.CurrentCamera end
end)

local function T(n) local t = Toggles[n]; return t and t.Value or false end
local function O(n) local o = Options[n]; return o and o.Value end

-- ==========================================
-- 1. AIMBOT TAB
-- ==========================================
local AimGroup = Tabs.Aimbot:AddLeftGroupbox('Aimbot')
AimGroup:AddToggle('Aimbot', { Text = 'Enable Aimbot', Default = false })
    :AddKeyPicker('AimbotKey', { Default = 'None', Mode = 'Toggle', SyncToggleState = true, Text = 'Aimbot' })
AimGroup:AddDropdown('HitPart', { Values = {'Random', 'Head', 'Torso'}, Default = 'Random', Text = 'Hit Part' })
AimGroup:AddSlider('AimbotFOV', { Text = 'FOV Size', Default = 500, Min = 20, Max = 2000, Rounding = 0 })
AimGroup:AddSlider('Smoothness', { Text = 'Smoothness', Default = 35, Min = 0, Max = 100, Rounding = 0 })
AimGroup:AddDropdown('AimbotMode', { Values = {'Lock', 'Linear', 'Spring', 'AI', 'SigmaMouse'}, Default = 'Lock', Text = 'Aim Mode' })
AimGroup:AddToggle('ShowFOVCircle', { Text = 'Show FOV Circle', Default = false })
AimGroup:AddToggle('TeamCheck', { Text = 'Team Check', Default = true })
AimGroup:AddToggle('WallCheck', { Text = 'Wall Check', Default = true })
AimGroup:AddToggle('MovementDetector', { Text = 'Movement Detector', Default = true })
AimGroup:AddSlider('MaxDistance', { Text = 'Max Distance', Default = 1200, Min = 100, Max = 3000, Rounding = 0 })

-- ==========================================
-- 2. SILENT AIM TAB
-- ==========================================
local SilentGroup = Tabs.SilentAim:AddLeftGroupbox('Silent Aim')
SilentGroup:AddToggle('SilentAim', { Text = 'Enable Silent Aim', Default = false })
    :AddKeyPicker('SilentAimKey', { Default = 'None', Mode = 'Toggle', SyncToggleState = true, Text = 'Silent Aim' })
SilentGroup:AddDropdown('SilentHitPart', { Values = {'Head', 'Torso', 'Random'}, Default = 'Head', Text = 'Hit Part' })
SilentGroup:AddSlider('SilentAimFOV', { Text = 'FOV Size', Default = 500, Min = 20, Max = 2000, Rounding = 0 })
SilentGroup:AddSlider('SilentAimHitChance', { Text = 'Hit Chance %', Default = 100, Min = 1, Max = 100, Rounding = 0 })
SilentGroup:AddToggle('SilentTeamCheck', { Text = 'Team Check', Default = true })
SilentGroup:AddToggle('SilentWallCheck', { Text = 'Wall Check', Default = true })

-- ==========================================
-- 3. RAGEBOT TAB
-- ==========================================
local RageGroup = Tabs.Ragebot:AddLeftGroupbox('Ragebot')
RageGroup:AddToggle('RagebotEnabled', { Text = 'Enable Ragebot', Default = false })
    :AddKeyPicker('RagebotKey', { Default = 'None', Mode = 'Toggle', SyncToggleState = true, Text = 'Ragebot' })
RageGroup:AddDropdown('RagebotWeapon', { Values = {'Auto', 'Primary', 'Secondary', 'Melee'}, Default = 'Auto', Text = 'Weapon' })
RageGroup:AddSlider('RageFireRate', { Text = 'Fire Rate', Default = 0.05, Min = 0.01, Max = 0.3, Rounding = 2 })
RageGroup:AddToggle('RageTeleportMode', { Text = 'Teleport Mode', Default = false })
RageGroup:AddSlider('RageOrbitRadius', { Text = 'Orbit Distance', Default = 5, Min = 2, Max = 25, Rounding = 0 })
RageGroup:AddSlider('RageOrbitSpeed', { Text = 'Orbit Speed', Default = 15, Min = 5, Max = 50, Rounding = 0 })
RageGroup:AddToggle('RageAutoFire', { Text = 'Auto Fire', Default = true })
RageGroup:AddToggle('RageAntiHit', { Text = 'Anti-Hit', Default = true })

-- Core Variables
local SpringState = { pos = Vector3.zero, vel = Vector3.zero, initialized = false }
local lastFrameTime = tick()
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5; FOVCircle.Color = Color3.fromRGB(255, 255, 255); FOVCircle.Filled = false; FOVCircle.Visible = false

-- Source Aimbot Logic
local function GetTarget(fovSize, targetPart, teamCheck, wallCheck)
    local closestTarget, shortestDistance = nil, fovSize / 2
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = { LocalPlayer.Character }
    
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetP = player.Character:FindFirstChild(targetPart)
            if not targetP and targetPart == "Head" then targetP = player.Character:FindFirstChild("HitboxHead") end
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local enemyHRP = player.Character:FindFirstChild("HumanoidRootPart")

            if targetP and humanoid and enemyHRP and humanoid.Health > 0 then
                local distance = (myHRP.Position - enemyHRP.Position).Magnitude
                if distance <= O('MaxDistance') then
                    local skip = false
                    if teamCheck and player.Team == LocalPlayer.Team then skip = true end
                    if not skip and wallCheck then
                        local result = Workspace:Raycast(Camera.CFrame.Position, (targetP.Position - Camera.CFrame.Position), rp)
                        if result and not player.Character:IsAncestorOf(result.Instance) then skip = true end
                    end
                    if not skip then
                        local sp, onScreen = Camera:WorldToViewportPoint(targetP.Position)
                        if onScreen then
                            local dist = (Vector2.new(sp.X, sp.Y) - screenCenter).Magnitude
                            if dist < shortestDistance then
                                shortestDistance = dist
                                closestTarget = player
                            end
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end

local function aimSpring(targetPos, dt)
    if not SpringState.initialized then
        SpringState.pos = Camera.CFrame.Position + Camera.CFrame.LookVector; SpringState.vel = Vector3.zero; SpringState.initialized = true
    end
    local s = math.clamp(O('Smoothness') / 100, 0.01, 1)
    local alpha = 1 - math.exp(-(1 + s * 15) * dt)
    SpringState.pos = SpringState.pos:Lerp(targetPos, alpha)
    return CFrame.new(Camera.CFrame.Position, SpringState.pos)
end

local function aimLinear(targetPos, dt)
    local s = math.clamp(O('Smoothness') / 100, 0.01, 1)
    local alpha = 1 - math.exp(-(1 + s * 34) * dt)
    return Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), math.clamp(alpha, 0.001, 1))
end

RunService:BindToRenderStep("EclipseAim", Enum.RenderPriority.Camera.Value + 1, function()
    local now = tick()
    local dt = math.clamp(now - lastFrameTime, 0, 0.1)
    lastFrameTime = now

    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = O('AimbotFOV') / 2
    FOVCircle.Visible = T('Aimbot') and T('ShowFOVCircle')

    if T('Aimbot') then
        if T('MovementDetector') then
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myHRP and myHRP.AssemblyLinearVelocity.Magnitude > 2 then return end
        end
        
        local target = GetTarget(O('AimbotFOV'), O('HitPart'), T('TeamCheck'), T('WallCheck'))
        if target and target.Character then
            local targetPart = target.Character:FindFirstChild(O('HitPart')) or target.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                if O('AimbotMode') == "Spring" then
                    Camera.CFrame = aimSpring(targetPart.Position, dt)
                elseif O('AimbotMode') == "Linear" then
                    Camera.CFrame = aimLinear(targetPart.Position, dt)
                else
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
                end
            end
        end
    end
end)
-- ==========================================
-- 4. VISUALS TAB (Exact Source ESP)
-- ==========================================
local ESPGroup = Tabs.Visuals:AddLeftGroupbox('ESP')
ESPGroup:AddToggle('EnableESP', { Text = 'Enable ESP', Default = false })
    :AddKeyPicker('ESPKey', { Default = 'None', Mode = 'Toggle', SyncToggleState = true, Text = 'ESP' })
ESPGroup:AddToggle('ESPBox', { Text = 'Box', Default = true })
ESPGroup:AddToggle('ESPNames', { Text = 'Names', Default = true })
ESPGroup:AddToggle('ESPHealth', { Text = 'Health Bar', Default = true })
ESPGroup:AddSlider('ESPMaxDist', { Text = 'Max Distance', Default = 500, Min = 50, Max = 2000, Rounding = 0 })
ESPGroup:AddToggle('ESPHighlight', { Text = 'Highlight', Default = false })
ESPGroup:AddSlider('ESPTextSize', { Text = 'Text Size', Default = 13, Min = 10, Max = 24, Rounding = 0 })

local ESPColors = Tabs.Visuals:AddLeftGroupbox('ESP Colors')
ESPColors:AddLabel('Visible Color'):AddColorPicker('ColorVisible', { Default = Color3.fromRGB(0, 255, 0) })
ESPColors:AddLabel('Hidden Color'):AddColorPicker('ColorHidden', { Default = Color3.fromRGB(255, 0, 0) })

local CoreGui = game:GetService("CoreGui")
local ESP_Cache = {}

-- FIXED: Using a ScreenGui instead of a Folder to prevent "Enabled is not a valid member" error
local ESP_ScreenGui = Instance.new("ScreenGui")
ESP_ScreenGui.Name = "EclipseESPHolder"
ESP_ScreenGui.Parent = CoreGui
ESP_ScreenGui.ResetOnSpawn = false

local function CreateESP(plr)
    if plr == LocalPlayer then return end
    
    local Folder = Instance.new("Folder")
    Folder.Name = plr.Name
    Folder.Parent = ESP_ScreenGui
    
    local Name = Instance.new("TextLabel", Folder)
    Name.BackgroundTransparency = 1; Name.TextColor3 = Color3.new(1,1,1); Name.Font = Enum.Font.Code; Name.TextStrokeTransparency = 0; Name.RichText = true
    
    local Box = Instance.new("Frame", Folder)
    Box.BackgroundColor3 = Color3.new(0,0,0); Box.BackgroundTransparency = 0.75; Box.BorderSizePixel = 0
    
    local Outline = Instance.new("UIStroke", Box)
    Outline.Color = Color3.new(1,1,1)
    
    local HealthBar = Instance.new("Frame", Folder)
    HealthBar.BackgroundColor3 = Color3.new(0,255,0); HealthBar.BorderSizePixel = 0
    
    local Chams = Instance.new("Highlight", Folder)
    Chams.FillTransparency = 0.5; Chams.OutlineTransparency = 0
    
    ESP_Cache[plr] = { Folder = Folder, Name = Name, Box = Box, Outline = Outline, HealthBar = HealthBar, Chams = Chams }
end

for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

RunService.RenderStepped:Connect(function()
    if not T('EnableESP') then
        for _, v in pairs(ESP_Cache) do 
            v.Name.Visible = false
            v.Box.Visible = false
            v.HealthBar.Visible = false
            v.Chams.Enabled = false
        end
        return
    end
    
    for plr, ui in pairs(ESP_Cache) do
        if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            ui.Name.Visible = false; ui.Box.Visible = false; ui.HealthBar.Visible = false; ui.Chams.Enabled = false
            continue
        end
        
        local HRP = plr.Character.HumanoidRootPart
        local Humanoid = plr.Character:FindFirstChild("Humanoid")
        if not Humanoid or Humanoid.Health <= 0 then 
            ui.Name.Visible = false; ui.Box.Visible = false; ui.HealthBar.Visible = false; ui.Chams.Enabled = false
            continue 
        end
        
        local Pos, OnScreen = Camera:WorldToViewportPoint(HRP.Position)
        local Dist = (Camera.CFrame.Position - HRP.Position).Magnitude / 3.57
        
        if OnScreen and Dist <= O('ESPMaxDist') then
            local Size = HRP.Size.Y
            local scaleFactor = (Size * Camera.ViewportSize.Y) / (Pos.Z * 2)
            local w, h = 3 * scaleFactor, 4.5 * scaleFactor
            
            ui.Box.Visible = T('ESPBox')
            ui.Box.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
            ui.Box.Size = UDim2.new(0, w, 0, h)
            
            ui.Name.Visible = T('ESPNames')
            ui.Name.Text = plr.Name
            ui.Name.TextSize = O('ESPTextSize')
            ui.Name.Position = UDim2.new(0, Pos.X, 0, Pos.Y - h / 2 - 15)
            
            ui.HealthBar.Visible = T('ESPHealth')
            local health = Humanoid.Health / Humanoid.MaxHealth
            ui.HealthBar.Position = UDim2.new(0, Pos.X - w / 2 - 5, 0, Pos.Y - h / 2 + h * (1 - health))
            ui.HealthBar.Size = UDim2.new(0, 2, 0, h * health)
            
            ui.Chams.Enabled = T('ESPHighlight')
            ui.Chams.Adornee = plr.Character
        else
            ui.Name.Visible = false; ui.Box.Visible = false; ui.HealthBar.Visible = false; ui.Chams.Enabled = false
        end
    end
end)
-- ==========================================
-- 5. SETTINGS TAB
-- ==========================================
local Settings = Tabs.Settings:AddLeftGroupbox('Menu')
Settings:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightShift', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('Eclipse')
SaveManager:SetFolder('Eclipse/configs')
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

-- ==========================================
-- EXACT SOURCE RAGEBOT
-- ==========================================
local lastFire = 0
RunService.Heartbeat:Connect(function()
    if not T('RagebotEnabled') then return end
    
    local target = GetTarget(O('AimbotFOV'), "Head", T('TeamCheck'), T('WallCheck'))
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = target.Character.HumanoidRootPart
        local myChar = LocalPlayer.Character
        if not myChar then return end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end

        if O('RageTeleportMode') then
            local dist = O('RageOrbitRadius')
            local speed = O('RageOrbitSpeed')
            local angle = tick() * speed
            local newPos = hrp.Position + Vector3.new(math.cos(angle) * dist, 3, math.sin(angle) * dist)
            myHRP.CFrame = CFrame.new(newPos, hrp.Position)
        end
        
        if O('RageAutoFire') and tick() - lastFire > O('RageFireRate') then
            lastFire = tick()
            local tool = myChar:FindFirstChildWhichIsA("Tool")
            if tool then pcall(function() tool:Activate() end) end
        end
    end
end)

-- ==========================================
-- EXACT SOURCE SILENT AIM HOOK
-- ==========================================
local function safeRequire(path, timeout)
    local start = tick()
    while tick() - start < (timeout or 5) do
        local ok, result = pcall(require, path)
        if ok then return result end
        task.wait(0.2)
    end
    return nil
end

local Rivals = { Ready = false }
task.spawn(function()
    Rivals.Util = safeRequire(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"), 10)
    Rivals.Fighter = safeRequire(LocalPlayer.PlayerScripts:WaitForChild("Controllers"):WaitForChild("FighterController"), 10)
    Rivals.Gun = safeRequire(LocalPlayer.PlayerScripts:WaitForChild("Modules"):WaitForChild("ItemTypes"):WaitForChild("Gun"), 10)
    Rivals.Ready = (Rivals.Util ~= nil and Rivals.Fighter ~= nil)
end)

local function lookCF(fromPos, toPos)
    local dir = toPos - fromPos
    if dir.Magnitude < 1e-4 then dir = Vector3.new(0, -1, 0) end
    return CFrame.lookAt(fromPos, fromPos + dir)
end

function hookGunModule()
    if not Rivals.Ready or not Rivals.Gun then return end
    if shared._EC_GunOrig then pcall(function() Rivals.Gun.StartShooting = shared._EC_GunOrig end) end
    local oldStart = Rivals.Gun.StartShooting
    shared._EC_GunOrig = oldStart
    
    Rivals.Gun.StartShooting = function(self, ...)
        local results = { oldStart(self, ...) }
        pcall(function()
            if not self.ClientFighter or not self.ClientFighter.IsLocalPlayer then return end
            if not T('SilentAim') then return end
            local camData = results[3]
            if not camData or typeof(camData) ~= "table" then return end
            
            local target = GetTarget(O('SilentAimFOV'), O('SilentHitPart'), T('SilentTeamCheck'), T('SilentWallCheck'))
            if target and target.Character then
                local hitPart = target.Character:FindFirstChild(O('SilentHitPart')) or target.Character:FindFirstChild("HumanoidRootPart")
                if hitPart then
                    if math.random(1, 100) <= O('SilentAimHitChance') then
                        local eyeCF = lookCF(Camera.CFrame.Position, hitPart.Position)
                        camData[utf8.char(0)] = Rivals.Util:EncodeCFrame(eyeCF)
                        camData[utf8.char(1)] = Rivals.Util:EncodeCFrame(eyeCF)
                        camData[utf8.char(2)] = hitPart
                        camData[utf8.char(3)] = Rivals.Util:EncodeCFrame(CFrame.new(0,0,0))
                        results[4] = true
                    end
                end
            end
        end)
        return unpack(results)
    end
end

task.spawn(function()
    for _ = 1, 30 do
        if Rivals.Gun and Rivals.Ready then break end
        task.wait(1)
    end
    if Rivals.Ready and Rivals.Gun then hookGunModule() end
end)
-- ==========================================
-- EXACT SOURCE SKIN CHANGER
-- ==========================================
task.spawn(function()
    local rs = game:GetService("ReplicatedStorage")
    local http = game:GetService("HttpService")
    local plr = game:GetService("Players").LocalPlayer

    local function waitFor(getter)
        local deadline = os.clock() + 90
        while os.clock() < deadline do
            local ok, value = pcall(getter)
            if ok and value then return value end
            task.wait(0.5)
        end
    end

    local scripts = plr:WaitForChild("PlayerScripts")
    local lib = waitFor(function() return require(rs.Modules.CosmeticLibrary) end)
    local replicated = waitFor(function() return require(rs.Modules.ReplicatedClass) end)
    local vmClass = waitFor(function() return require(scripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ClientViewModel) end)
    local pdc = waitFor(function() return require(scripts.Controllers.PlayerDataController) end)
    local viewModels = waitFor(function() return scripts.Assets.ViewModels end)
    local classes = waitFor(function() return scripts.Modules.ViewModels end)
    local equipRemote = waitFor(function() return rs.Remotes.Data.EquipCosmetic end)

    if not (lib and replicated and vmClass and pdc and viewModels and classes and equipRemote) then return end

    local folder = "EclipseHub"
    local file = folder .. "/Rivals Cosmetics.json"
    local slots = { Skin = true, Wrap = true, Charm = true, Finisher = true }
    local added, saved, alive, swaps, swapping, moduleCache, modelCache = {}, {}, true, {}, nil, {}, {}
    local oldGet = replicated.Get
    local oldVmGet = rawget(vmClass, "Get")

    local function get(key)
        local ok, v = pcall(pdc.CurrentData.Get, pdc.CurrentData, key)
        return ok and v or nil
    end

    waitFor(function() return get("CosmeticInventory") and get("WeaponInventory") end)

    local function flush()
        pcall(function()
            if not isfolder(folder) then makefolder(folder) end
            writefile(file, http:JSONEncode(saved))
        end)
    end

    local function find(weapon)
        local list = get("WeaponInventory")
        if not list then return end
        for _, w in pairs(list) do if w.Name == weapon then return w end end
    end

    local inv = get("CosmeticInventory")
    for name in pairs(lib.Cosmetics) do
        if inv and inv[name] == nil then inv[name] = true; added[name] = true end
    end

    pcall(function()
        if isfile(file) then saved = http:JSONDecode(readfile(file)) end
    end)

    for weapon, picks in pairs(saved) do
        local w = find(weapon)
        if w then
            for slot, entry in pairs(picks) do
                if slots[slot] and lib.Cosmetics[entry.Name] then w[slot] = entry end
            end
        end
    end

    local function baseOf(name)
        local cosmetic = lib.Cosmetics[name]
        if cosmetic and cosmetic.Type == "Skin" and cosmetic.ItemName then return cosmetic.ItemName end
        return name
    end

    local function moduleOf(name)
        local cached = moduleCache[name]
        if cached == nil then
            local found = classes:FindFirstChild(name, true)
            cached = found and found:IsA("ModuleScript") and found or false
            moduleCache[name] = cached
        end
        return cached or nil
    end

    local function hasModel(name)
        local cached = modelCache[name]
        if cached == nil then
            cached = viewModels:FindFirstChild(name, true) ~= nil
            modelCache[name] = cached
        end
        return cached
    end

    local function installSwap(weapon)
        if swaps[weapon] then return end
        local defaultModule = moduleOf(weapon)
        if not defaultModule then return end
        local ok, class = pcall(require, defaultModule)
        if not ok or type(class) ~= "table" or type(rawget(class, "new")) ~= "function" then return end
        local origNew = class.new
        swaps[weapon] = { class = class, origNew = origNew }
        class.new = function(...)
            local picks = alive and saved[weapon]
            local skin = picks and picks.Skin
            local skinModule = skin and moduleOf(skin.Name)
            if skinModule and not swapping and hasModel(skin.Name) and (skinModule.Parent == defaultModule.Parent or skinModule.Parent == defaultModule) then
                local loaded, skinClass = pcall(require, skinModule)
                if loaded and type(skinClass) == "table" and type(skinClass.new) == "function" then
                    swapping = { weapon = weapon, skin = skin.Name }
                    local built, object = pcall(skinClass.new, ...)
                    swapping = nil
                    if built then return object end
                end
            end
            return origNew(...)
        end
    end

    for weapon, picks in pairs(saved) do
        if picks.Skin then installSwap(weapon) end
    end

    replicated.Get = function(self, key)
        if alive and slots[key] then
            local data = rawget(self, "Data")
            local picks = data and saved[baseOf(data.Name)]
            local entry = picks and picks[key]
            if entry ~= nil then return entry end
        end
        return oldGet(self, key)
    end

    vmClass.Get = function(self, key)
        if alive and key == "Name" then
            local data = rawget(self, "Data")
            if data then
                local weapon = baseOf(data.Name)
                if swapping and swapping.weapon == weapon then return swapping.skin end
                local picks = saved[weapon]
                local skin = picks and picks.Skin
                if skin and not moduleOf(skin.Name) and hasModel(skin.Name) and (data.Name == weapon or not moduleOf(data.Name)) then
                    return skin.Name
                end
            end
        end
        return (oldVmGet or replicated.Get)(self, key)
    end

    local function refreshHeld(weapon, slot)
        if slot ~= "Wrap" and slot ~= "Charm" then return end
        for _, obj in ipairs(getgc(true)) do
            if type(obj) == "table" and type(rawget(obj, "Data")) == "table" and rawget(obj, "ClientItem") and rawget(obj, "Model") and baseOf(obj.Data.Name) == weapon then
                local entry = saved[weapon] and saved[weapon][slot]
                obj.Data[slot] = entry
                local signal = obj._value_changed_events and obj._value_changed_events[slot]
                if signal then pcall(signal.Fire, signal, entry) end
                if slot == "Wrap" and obj._UpdateWrap then pcall(obj._UpdateWrap, obj) end
            end
        end
    end

    local function equip(weapon, slot, name, extra)
        local w = find(weapon)
        if not w then return false end
        local entry
        if name then entry = { Name = name, Inverted = slot == "Wrap" and extra and extra.IsInverted or nil } end
        w[slot] = entry
        saved[weapon] = saved[weapon] or {}
        saved[weapon][slot] = entry
        if slot == "Skin" and entry then installSwap(weapon) end
        flush()
        refreshHeld(weapon, slot)
        return true
    end

    getgenv().RivalsEquipHandler = function(self, ...)
        if not alive or self ~= equipRemote then return false end
        local weapon, slot, name, extra = ...
        return slots[slot] and (name == nil or lib.Cosmetics[name]) and equip(weapon, slot, name, extra) or false
    end

    if not getgenv().RivalsNamecallOriginal then
        getgenv().RivalsNamecallOriginal = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local handler = getgenv().RivalsEquipHandler
            if handler and not checkcaller() and getnamecallmethod() == "FireServer" and handler(self, ...) then return end
            return getgenv().RivalsNamecallOriginal(self, ...)
        end))
    end

    getgenv().RivalsCosmeticsCleanup = function()
        alive = false
        getgenv().RivalsEquipHandler = nil
        replicated.Get = oldGet
        vmClass.Get = oldVmGet
        for _, swap in pairs(swaps) do swap.class.new = swap.origNew end
        local cur = get("CosmeticInventory")
        if cur then for name in pairs(added) do cur[name] = nil end end
        getgenv().RivalsCosmeticsCleanup = nil
    end
end)