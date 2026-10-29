-- ════════════════════════════════════════════════════════════════════════
-- §1  CORE GUARD & ENV PROBE
-- ════════════════════════════════════════════════════════════════════════
if getgenv().__Eclipse then
    pcall(function() getgenv().__Eclipse.Destroy() end)
    getgenv().__Eclipse = nil
end

local Env = {
    hookfunc = hookfunction, newcc = newcclosure, hookmeta = hookmetamethod,
    getnamecall = getnamecallmethod, getrenv = getrenv, gethui = gethui,
    cloneref = cloneref, setidentity = setthreadidentity, getidentity = getthreadidentity,
    setconst = setconstant, getconst = getconstants, writefile = writefile,
    readfile = readfile, isfile = isfile, isfolder = isfolder,
    makefolder = makefolder, listfiles = listfiles,
}
Env.CAN_HOOK = (Env.hookfunc and Env.newcc) ~= nil
Env.CAN_FS = (Env.writefile and Env.isfile) ~= nil
Env.HUDParent = (Env.gethui and Env.gethui()) or game:GetService("CoreGui")

-- ════════════════════════════════════════════════════════════════════════
-- §2  SERVICES
-- ════════════════════════════════════════════════════════════════════════
local LP = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ════════════════════════════════════════════════════════════════════════
-- §3  THEME & UI FACTORY
-- ════════════════════════════════════════════════════════════════════════
local T = {
    bg = Color3.fromRGB(13, 11, 18), side = Color3.fromRGB(18, 15, 25), card = Color3.fromRGB(24, 20, 33),
    stroke = Color3.fromRGB(45, 38, 60), text = Color3.fromRGB(240, 235, 255), sub = Color3.fromRGB(140, 130, 165),
    off = Color3.fromRGB(35, 30, 48), accent = Color3.fromRGB(145, 70, 255)
}
local F = {
    title = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Regular),
    body = Font.new("rbxasset://fonts/families/Jura.json", Enum.FontWeight.Medium),
    bold = Font.new("rbxasset://fonts/families/Jura.json", Enum.FontWeight.Bold),
}

local UI = {}
local LayoutCounter = setmetatable({}, { __mode = "k" })

function UI.new(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end
function UI.nextLayout(parent)
    local n = (LayoutCounter[parent] or 0) + 1
    LayoutCounter[parent] = n
    return n
end
function UI.corner(obj, radius) return UI.new("UICorner", { CornerRadius = UDim.new(0, radius or 8) }, obj) end
function UI.stroke(obj, color, thickness) return UI.new("UIStroke", { Color = color or T.stroke, Thickness = thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, obj) end

-- ════════════════════════════════════════════════════════════════════════
-- §4  MAIN WINDOW
-- ════════════════════════════════════════════════════════════════════════
local gui = UI.new("ScreenGui", { Name = "EclipseUI", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true }, Env.HUDParent)

local function fitScale()
    local vp = Camera.ViewportSize
    return math.max(0.4, math.min(1.2, vp.X * 0.95 / 620, vp.Y * 0.95 / 480))
end

local main = UI.new("Frame", {
    Size = UDim2.fromOffset(620, 480), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
    BackgroundColor3 = T.bg, Visible = true, ZIndex = 2,
}, gui)
UI.corner(main, 12); UI.stroke(main)
local mainScale = UI.new("UIScale", { Scale = fitScale() }, main)

-- Title Bar
local titleBar = UI.new("Frame", { Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = T.side, BorderSizePixel = 0, ZIndex = 3 }, main)
UI.corner(titleBar, 12)
UI.new("Frame", {Size = UDim2.new(1,0,0,12), Position = UDim2.new(0,0,1,-12), BackgroundColor3 = T.side, BorderSizePixel = 0, ZIndex = 3}, titleBar)
UI.new("TextLabel", { Text = 'ECLIPSE', Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, FontFace = F.title, TextSize = 22, TextColor3 = T.text, ZIndex = 4 }, titleBar)

-- Sidebar
local side = UI.new("Frame", { Size = UDim2.new(0, 70, 1, -42), Position = UDim2.fromOffset(0, 42), BackgroundColor3 = T.side, BorderSizePixel = 0, ZIndex = 3 }, main)
UI.new("Frame", { Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, 0, 0, 0), BackgroundColor3 = T.stroke, BorderSizePixel = 0, ZIndex = 3 }, side)
UI.new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center }, side)
UI.new("UIPadding", { PaddingTop = UDim.new(0, 10) }, side)

-- Content Container
local content = UI.new("Frame", { Size = UDim2.new(1, -70, 1, -42), Position = UDim2.fromOffset(70, 42), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 2 }, main)

-- ════════════════════════════════════════════════════════════════════════
-- §5  PAGE ROUTER & COMPONENTS
-- ════════════════════════════════════════════════════════════════════════
local PAGES, navBtns, currentPage = {}, {}, ""

local function makePageScroll()
    local sf = UI.new("ScrollingFrame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = T.accent, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0), Visible = false, ZIndex = 2 }, content)
    UI.new("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14), PaddingTop = UDim.new(0, 14), PaddingBottom = UDim.new(0, 14) }, sf)
    UI.new("UIListLayout", { Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder }, sf)
    return sf
end

function UI.selectPage(name)
    if not PAGES[name] then return end
    for n, pg in pairs(PAGES) do
        local active = (n == name); pg.scroll.Visible = active
        if active then 
            task.defer(function() 
                local layout = pg.scroll:FindFirstChildOfClass("UIListLayout") 
                if layout then pg.scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y) end 
            end) 
        end
    end
    currentPage = name
    for n, btn in pairs(navBtns) do 
        btn.TextColor3 = (n == name) and T.accent or T.sub 
        btn.BackgroundTransparency = (n == name) and 0.85 or 1
    end
end

local function addPage(name, text, icon)
    local scroll = makePageScroll(); PAGES[name] = { scroll = scroll }
    local btn = UI.new("TextButton", { 
        Text = text, Size = UDim2.new(1, -10, 0, 50), BackgroundColor3 = T.accent, BackgroundTransparency = 1,
        BorderSizePixel = 0, FontFace = F.bold, TextSize = 11, TextColor3 = T.sub 
    }, side)
    UI.corner(btn, 8)
    navBtns[name] = btn
    btn.MouseButton1Click:Connect(function() UI.selectPage(name) end)
    return scroll
end

function UI.card(scroll, title)
    local c = UI.new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = T.card, BorderSizePixel = 0, LayoutOrder = UI.nextLayout(scroll) }, scroll)
    UI.corner(c, 8); UI.stroke(c)
    UI.new("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10) }, c)
    local body = UI.new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1 }, c)
    UI.new("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, body)
    UI.new("TextLabel", { Text = title:upper(), Size = UDim2.new(1, 0, 0, 18), TextSize = 12, TextColor3 = T.sub, FontFace = F.bold, BackgroundTransparency = 1, LayoutOrder = UI.nextLayout(body) }, body)

    local api = {}
    
    function api.toggle(label, default, cb)
        local state = default
        local row = UI.new("Frame", { Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, LayoutOrder = UI.nextLayout(body) }, body)
        UI.new("TextLabel", { Text = label, Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, FontFace = F.body, TextSize = 15, TextColor3 = T.text, TextXAlignment = Enum.TextXAlignment.Left }, row)
        
        local sw = UI.new("TextButton", { Size = UDim2.fromOffset(42, 22), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = state and T.accent or T.off, AutoButtonColor = false, Text = "" }, row)
        UI.corner(sw, 11)
        local knob = UI.new("Frame", { Size = UDim2.fromOffset(16, 16), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(state and 0.7 or 0.3, 0.5), BackgroundColor3 = Color3.new(1,1,1) }, sw)
        UI.corner(knob, 8)
        
        local function paint() 
            TweenService:Create(sw, TweenInfo.new(0.15), {BackgroundColor3 = state and T.accent or T.off}):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), {Position = UDim2.fromScale(state and 0.7 or 0.3, 0.5)}):Play()
        end
        paint(); if cb then pcall(cb, state) end
        sw.MouseButton1Click:Connect(function() state = not state; paint(); if cb then pcall(cb, state) end end)
    end

    function api.slider(label, min, max, default, cb)
        local state = default
        local row = UI.new("Frame", { Size = UDim2.new(1, 0, 0, 46), BackgroundTransparency = 1, LayoutOrder = UI.nextLayout(body) }, body)
        UI.new("TextLabel", { Text = label, Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, FontFace = F.body, TextSize = 14, TextColor3 = T.text }, row)
        local valLbl = UI.new("TextLabel", { Text = tostring(state), Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, FontFace = F.body, TextSize = 14, TextColor3 = T.accent, TextXAlignment = Enum.TextXAlignment.Right }, row)
        
        local track = UI.new("TextButton", { Size = UDim2.new(1, 0, 0, 12), Position = UDim2.fromOffset(0, 26), BackgroundColor3 = T.off, AutoButtonColor = false, Text = "" }, row)
        UI.corner(track, 6)
        local fill = UI.new("Frame", { Size = UDim2.fromScale((state - min) / (max - min), 1), BackgroundColor3 = T.accent, BorderSizePixel = 0 }, track)
        UI.corner(fill, 6)
        
        local sliding = false
        local function update(x)
            local alpha = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            state = math.floor(min + (max - min) * alpha)
            fill.Size = UDim2.fromScale(alpha, 1)
            valLbl.Text = tostring(state)
            if cb then pcall(cb, state) end
        end
        track.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = true; update(input.Position.X) end end)
        UIS.InputChanged:Connect(function(input) if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input.Position.X) end end)
        UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end end)
    end

    function api.textbox(label, default, cb)
        local row = UI.new("Frame", { Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1, LayoutOrder = UI.nextLayout(body) }, body)
        UI.new("TextLabel", { Text = label, Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, FontFace = F.body, TextSize = 14, TextColor3 = T.text }, row)
        local box = UI.new("TextBox", { Size = UDim2.new(1, 0, 0, 26), Position = UDim2.fromOffset(0, 20), BackgroundColor3 = T.off, FontFace = F.body, TextSize = 14, TextColor3 = T.text, Text = default, PlaceholderText = "Enter...", ClearTextOnFocus = false }, row)
        UI.corner(box, 6); UI.stroke(box, T.stroke)
        box.FocusLost:Connect(function() if cb then pcall(cb, box.Text) end end)
    end
    
    function api.button(label, cb)
        local btn = UI.new("TextButton", { Text = label, Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = T.off, FontFace = F.bold, TextSize = 14, TextColor3 = T.text, LayoutOrder = UI.nextLayout(body), AutoButtonColor = false }, body)
        UI.corner(btn, 6); UI.stroke(btn)
        btn.MouseButton1Click:Connect(function() pcall(cb) end)
    end
    return api
end
-- ════════════════════════════════════════════════════════════════════════
-- §6  GLOBAL STATE
-- ════════════════════════════════════════════════════════════════════════
local S = {
    aimbot = false, aimbotFov = 120, aimbotSmooth = 10, aimbotHitPart = "Head", showFov = true,
    silentAim = false, silentHitChance = 100, silentFov = 150, triggerbot = false, teamCheck = true, ragebot = false,
    noSpread = false, rapidFire = false,
    walkSpeed = 16, jumpPower = 50, fly = false, flySpeed = 60, noclip = false, infiniteJump = false,
    esp = false, espBox = true, espNames = true, espHealth = true, espTeam = false,
    noScopeOverlay = false, noGunTracers = false, noFlashbang = false, noCameraShake = false,
    customFov = false, fovValue = 70,
    nameSpoof = false, spoofedName = "Eclipse", levelSpoof = false, spoofedLevel = 999, deviceSpoof = false
}

-- ════════════════════════════════════════════════════════════════════════
-- §7  FEATURE LOOPS
-- ════════════════════════════════════════════════════════════════════════
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1; fovCircle.Color = T.accent; fovCircle.Filled = false; fovCircle.Visible = false

RunService.RenderStepped:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    -- Aimbot
    if S.aimbot and hrp and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local closest, dist = nil, S.aimbotFov
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and (not S.teamCheck or p.Team ~= LP.Team) then
                local targetHrp = p.Character.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetHrp.Position)
                if onScreen then
                    local d = (Vector2.new(screenPos.X, screenPos.Y) - UIS:GetMouseLocation()).Magnitude
                    if d < dist then closest, dist = p.Character, d end
                end
            end
        end
        if closest then
            local targetPart = closest:FindFirstChild(S.aimbotHitPart) or closest:FindFirstChild("HumanoidRootPart")
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, targetPart.Position), 1 / S.aimbotSmooth)
        end
    end
    
    -- FOV Circle
    if (S.aimbot or S.silentAim) and S.showFov then
        fovCircle.Visible = true; fovCircle.Radius = S.aimbotFov; fovCircle.Position = UIS:GetMouseLocation()
    else fovCircle.Visible = false end

    -- Movement
    if hum then
        hum.WalkSpeed = S.walkSpeed
        if hum.UseJumpPower then hum.JumpPower = S.jumpPower else hum.JumpHeight = S.jumpPower / 20 end
    end
    if hrp and S.fly then
        local moveDir = Vector3.zero
        local camCF = Camera.CFrame
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += camCF.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= camCF.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= camCF.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += camCF.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.yAxis end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.yAxis end
        hrp.Velocity = moveDir * S.flySpeed
    end
    if S.noclip and char then
        for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
    if S.customFov then Camera.FieldOfView = S.fovValue end
end)

-- ESP Loop
local espCache = {}
RunService.RenderStepped:Connect(function()
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if S.esp and onScreen and (S.espTeam or p.Team ~= LP.Team) then
                if not espCache[p] then
                    espCache[p] = { box = Drawing.new("Square"), name = Drawing.new("Text"), hp = Drawing.new("Square") }
                    espCache[p].box.Thickness = 1; espCache[p].box.Color = T.accent; espCache[p].box.Filled = false
                    espCache[p].name.Size = 14; espCache[p].name.Center = true; espCache[p].name.Outline = true; espCache[p].name.Color = Color3.new(1,1,1)
                    espCache[p].hp.Filled = true
                end
                local d = espCache[p]
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local hpPct = hum.Health / hum.MaxHealth
                local height = 70
                
                d.box.Visible = S.espBox; d.box.Size = Vector2.new(height/2, height); d.box.Position = Vector2.new(screenPos.X - height/4, screenPos.Y - height/2)
                d.name.Visible = S.espNames; d.name.Text = p.Name; d.name.Position = Vector2.new(screenPos.X, screenPos.Y - height/2 - 16)
                d.hp.Visible = S.espHealth; d.hp.Size = Vector2.new(2, height * hpPct); d.hp.Position = Vector2.new(screenPos.X - height/4 - 4, screenPos.Y + height/2 - height*hpPct); d.hp.Color = Color3.fromRGB(255 * (1-hpPct), 255 * hpPct, 0)
            elseif espCache[p] then
                for _, obj in pairs(espCache[p]) do obj.Visible = false end
            end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if S.infiniteJump then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ════════════════════════════════════════════════════════════════════════
-- §8  BUILD UI
-- ════════════════════════════════════════════════════════════════════════
local pgCombat = addPage("combat", "Combat")
local pgMove = addPage("move", "Movement")
local pgVisual = addPage("visuals", "Visuals")
local pgSpoof = addPage("spoof", "Spoof")
local pgSettings = addPage("settings", "Settings")

-- COMBAT
local c1 = UI.card(pgCombat, "Aimbot")
c1.toggle("Aimbot Enabled", S.aimbot, function(v) S.aimbot = v end)
c1.slider("Aimbot Smoothness", 1, 50, S.aimbotSmooth, function(v) S.aimbotSmooth = v end)
c1.slider("FOV Size", 10, 500, S.aimbotFov, function(v) S.aimbotFov = v end)
c1.toggle("Show FOV Circle", S.showFov, function(v) S.showFov = v end)

local c2 = UI.card(pgCombat, "Silent Aim / Trigger")
c2.toggle("Silent Aim", S.silentAim, function(v) S.silentAim = v end)
c2.slider("Hit Chance", 0, 100, S.silentHitChance, function(v) S.silentHitChance = v end)
c2.toggle("Triggerbot", S.triggerbot, function(v) S.triggerbot = v end)
c2.toggle("Team Check", S.teamCheck, function(v) S.teamCheck = v end)
c2.toggle("Ragebot (Bypass)", S.ragebot, function(v) S.ragebot = v end)

local c3 = UI.card(pgCombat, "Weapon Mods")
c3.toggle("No Bullet Spread", S.noSpread, function(v) S.noSpread = v end)
c3.toggle("Rapid Fire", S.rapidFire, function(v) S.rapidFire = v end)

-- MOVEMENT
local c4 = UI.card(pgMove, "Movement")
c4.slider("WalkSpeed", 16, 250, S.walkSpeed, function(v) S.walkSpeed = v end)
c4.slider("Jump Power", 50, 300, S.jumpPower, function(v) S.jumpPower = v end)
c4.toggle("Flight", S.fly, function(v) S.fly = v end)
c4.slider("Flight Speed", 10, 300, S.flySpeed, function(v) S.flySpeed = v end)
c4.toggle("Noclip", S.noclip, function(v) S.noclip = v end)
c4.toggle("Infinite Double Jumps", S.infiniteJump, function(v) S.infiniteJump = v end)

-- VISUALS
local c5 = UI.card(pgVisual, "ESP / Visuals")
c5.toggle("ESP Enabled", S.esp, function(v) S.esp = v end)
c5.toggle("ESP Box", S.espBox, function(v) S.espBox = v end)
c5.toggle("ESP Names", S.espNames, function(v) S.espNames = v end)
c5.toggle("ESP Health Bar", S.espHealth, function(v) S.espHealth = v end)
c5.toggle("ESP Show Teammates", S.espTeam, function(v) S.espTeam = v end)

local c6 = UI.card(pgVisual, "Overlay Removals")
c6.toggle("No Scope Overlay", S.noScopeOverlay, function(v) S.noScopeOverlay = v end)
c6.toggle("No Gun Tracers", S.noGunTracers, function(v) S.noGunTracers = v end)
c6.toggle("No Flashbang Effect", S.noFlashbang, function(v) S.noFlashbang = v end)
c6.toggle("No Camera Shake", S.noCameraShake, function(v) S.noCameraShake = v end)

local c7 = UI.card(pgVisual, "Camera Effects")
c7.toggle("Custom Camera FOV", S.customFov, function(v) S.customFov = v end)
c7.slider("FOV Value (50-130)", 50, 130, S.fovValue, function(v) S.fovValue = v end)

-- SPOOF
local c8 = UI.card(pgSpoof, "Identity Spoof")
c8.toggle("Name Spoof", S.nameSpoof, function(v) S.nameSpoof = v end)
c8.textbox("Spoofed Name", S.spoofedName, function(v) S.spoofedName = v end)
c8.toggle("Level Spoof", S.levelSpoof, function(v) S.levelSpoof = v end)
c8.slider("Spoofed Level", 1, 999, S.spoofedLevel, function(v) S.spoofedLevel = v end)
c8.toggle("Device Spoof", S.deviceSpoof, function(v) S.deviceSpoof = v end)

-- SETTINGS
local c9 = UI.card(pgSettings, "UI Settings")
c9.button("Toggle Accent Color", function()
    T.accent = (T.accent == Color3.fromRGB(145, 70, 255)) and Color3.fromRGB(56, 189, 248) or Color3.fromRGB(145, 70, 255)
    fovCircle.Color = T.accent
    UI.selectPage(currentPage)
end)
c9.button("Unload Eclipse", function()
    if getgenv().__Eclipse then getgenv().__Eclipse.Destroy() end
end)

-- ════════════════════════════════════════════════════════════════════════
-- §9  BOOT & DRAG SYSTEM
-- ════════════════════════════════════════════════════════════════════════
UI.selectPage("combat")

local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = main.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local api = {}
function api.Destroy()
    pcall(function() gui:Destroy() end)
    pcall(function() fovCircle:Remove() end)
    for _, d in pairs(espCache) do for _, obj in pairs(d) do pcall(function() obj:Remove() end) end end
    getgenv().__Eclipse = nil
end
getgenv().__Eclipse = api
print("[Eclipse] Loaded! All features synced to UI.")