--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║                      E C L I P S E                       ║
    ║           Rivals · Universal · Mobile + PC               ║
    ║     movement · combat · esp · visuals · spoofing         ║
    ║                  toggle: RightShift                      ║
    ╚═══════════════════════════════════════════════════════════╝

    Built from scratch — synthesised from Graviton-9v2, LuaHook, KiciaHook
    Platform: Roblox Rivals (and most games using similar remote structure)
    Executor: Synapse X / Fluxus / Wave / Delta (hookfunction + newcclosure required)
]]

-- ════════════════════════════════════════════════════════════════════════
-- §0  GUARD & UNLOAD PREVIOUS COPY
-- ════════════════════════════════════════════════════════════════════════
if getgenv then
    for _, key in ipairs({"__Eclipse", "__Graviton9v2", "__LuaHook", "__KiciaHook"}) do
        if getgenv()[key] then
            pcall(getgenv()[key].Destroy)
            getgenv()[key] = nil
        end
    end
end

-- ════════════════════════════════════════════════════════════════════════
-- §1  AC BYPASS — setmetatable hook (from Graviton-9v2)
-- ════════════════════════════════════════════════════════════════════════
do
    if getgenv and getgenv().__EC_SetmtBP ~= game
       and hookfunction and newcclosure and getrenv then
        getgenv().__EC_SetmtBP = game
        local ok = pcall(function()
            local oldsetmt
            local rawget_, rawlen_, type_ = rawget, rawlen, type
            oldsetmt = hookfunction(getrenv().setmetatable, newcclosure(function(t, mt)
                if type_(mt) == "table" and rawget_(mt, "__mode") == "kv"
                   and type_(t)  == "table" and rawlen_(t)  == 4
                   and type_(rawget_(t, 1)) == "table"
                   and rawget_(t, 2) == 1
                   and rawget_(t, 3) == "String"
                   and type_(rawget_(t, 4)) == "userdata" then
                    return oldsetmt({1, 2, 3}, {})
                end
                return oldsetmt(t, mt)
            end))
        end)
        if not ok then getgenv().__EC_SetmtBP = nil end
    end
end

-- ════════════════════════════════════════════════════════════════════════
-- §2  SERVICES & LOCALS
-- ════════════════════════════════════════════════════════════════════════
local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportSvc  = game:GetService("TeleportService")
local Lighting     = game:GetService("Lighting")
local HttpService  = game:GetService("HttpService")
local Debris       = game:GetService("Debris")
local LP           = Players.LocalPlayer
local Camera       = workspace.CurrentCamera

local parent = (gethui and gethui()) or game:GetService("CoreGui")
local cloneref = (clonereference or cloneref or function(x) return x end)

local conns = {}
local function bind(c)  table.insert(conns, c) return c end
local function tween(o, p, t)
    return TweenService:Create(o, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p)
end

-- character helpers
local function char()   return LP.Character end
local function root()   return char() and char():FindFirstChild("HumanoidRootPart") end
local function hum()    return char() and char():FindFirstChildOfClass("Humanoid") end

-- Global Operational Configurations
local S = {
    fly       = false, flySpeed  = 60,
    noclip    = false, infJump   = false,
    walk      = 16,   jump      = 50,    lock = true,
    fullbright= false, brightness= 2,
    noFog     = false,
    worldTint = false, tintColor = Color3.fromRGB(168,85,247), tintStrength = 60,
    saturation= 0,    contrast  = 0,
    menuKey   = Enum.KeyCode.RightShift,
}

local ESPState = {
    enabled    = false,
    box        = true,
    skeleton   = true,
    chams      = true,
    names      = true,
    distance   = true,
    health     = true,
    hideTeam   = false,
    teamColor  = false,
    color      = Color3.fromRGB(132, 0, 255),
    colorEnemy = Color3.fromRGB(255, 65, 90),
    transparency = 0.45,
    boxThick   = 1.5,
    skelThick  = 1.0,
}

local SA = {
    on       = false,
    fov      = 120,
    hitChance= 100,
    hsPercent= 65,
    bodyPercent=35,
    visOnly  = false,
    autoFire = false,
    showFov  = true,
    HEAD_HITBOX  = "HitboxHead",
    HEAD_SMALL   = "HitboxHeadSmall",
    BODY_HITBOX  = "HitboxBody",
}

local AB = {
    on         = false,
    key        = "MB2",
    fovDeg     = 20,
    smoothness = 15,
    smoothX    = 15,
    smoothY    = 15,
    linkAxes   = true,
    deadzoneDeg= 0,
    switchDeg  = 2,
    stickiness = 0.15,
    forgetTime = 0.2,
    targetPart = "Head",
    priority   = "Crosshair",
    prediction = false,
    showFov    = false,
    showLock   = false,
    reactionMs = 0,
    noiseDeg   = 0,
    jumpDamping= 40,
    cancelSprings = true,
    curvedFlick   = false,
    curvedIntensity = 0.35,
    _target    = nil,
    _targetPart= nil,
    _lastTarget= nil,
    _lastTargetTime = 0,
    _keyHeld   = false,
    _flickActive = false,
    _springOffset = Vector2.zero,
    _velHistory = {},
}

local TB = {
    on        = false,
    maxDist   = 200,
    reactionMs= 0,
    teamCheck = true,
    _last     = 0,
    _cooldown = 0.08,
}

local VS = {
    on        = false,
    interval  = 0.08,
    burstMode = false,
    burstN    = 5,
    burstGap  = 0.06,
    holdMode  = true,
    _conn     = nil,
    _holdKey  = Enum.KeyCode.F,
    _held     = false,
}

-- ════════════════════════════════════════════════════════════════════════
-- §3  CONST-PATCH ENGINE (from LuaHook)
-- ════════════════════════════════════════════════════════════════════════
local ConstPatch = {}
do
    local _getconstants = getconstants or (debug and debug.getconstants)
    local _setconstant  = setconstant  or (debug and debug.setconstant)
    local _getprotos    = getprotos    or (debug and debug.getprotos)
    local _getproto     = getproto     or (debug and debug.getproto)
    local HAVE_CONST    = type(_getconstants) == "function" and type(_setconstant) == "function"
    local HAVE_PROTOS   = type(_getprotos)    == "function" and type(_getproto)    == "function"
    local _sets         = {}

    local function ledger(create)
        if not getgenv then return nil end
        local g = getgenv()
        local t = rawget(g, "__EC_ConstLedger")
        if not t and create then t = {}; g.__EC_ConstLedger = t end
        return t
    end

    local HASH_SEED, STR_CAP = 5381, 256
    local function hashByte(h, b)
        return bit32.band(bit32.lshift(h, 5) + h + b, 0xFFFFFFFF)
    end
    local function hashString(h, s)
        local n = #s
        h = hashByte(h, bit32.band(n, 0xFF))
        h = hashByte(h, bit32.band(bit32.rshift(n, 8), 0xFF))
        for i = 1, math.min(n, STR_CAP) do h = hashByte(h, string.byte(s, i)) end
        return h
    end
    local function hashValue(h, v)
        local t = typeof(v)
        h = hashString(h, t)
        if t == "string"  then return hashString(h, v) end
        if t == "number"  then return hashString(h, string.format("%.17g", v)) end
        if t == "boolean" then return hashByte(h, v and 1 or 0) end
        return h
    end

    function ConstPatch.fingerprint(fn)
        if not HAVE_CONST or type(fn) ~= "function" then return nil end
        local ok, result = pcall(function()
            local consts = _getconstants(fn)
            if type(consts) ~= "table" then return nil end
            local h = HASH_SEED
            for i, v in consts do h = hashValue(h, i); h = hashValue(h, v) end
            if HAVE_PROTOS then
                local protos = _getprotos(fn)
                if type(protos) == "table" then h = hashValue(h, #protos) end
            end
            return h
        end)
        return ok and result or nil
    end

    local function resolveFn(src)
        if type(src.fn) == "function" then return src.fn end
        if type(src.holder) ~= "table" then return nil end
        local v = rawget(src.holder, src.name)
        return type(v) == "function" and v or nil
    end

    local function candidates(fn, src)
        if src.scan ~= "protos" then return {fn} end
        if not HAVE_PROTOS then return nil, "executor lacks getprotos/getproto" end
        local ok, protos = pcall(_getprotos, fn)
        if not ok or type(protos) ~= "table" then return nil, "getprotos failed" end
        local out = {}
        for i in protos do
            local okG, live = pcall(_getproto, fn, i, true)
            if okG and type(live) == "table" and type(live[1]) == "function" then
                out[#out+1] = live[1]
            end
        end
        return out
    end

    local function collectMatches(fn, src)
        local ok, consts = pcall(_getconstants, fn)
        if not ok or type(consts) ~= "table" then return nil, "getconstants failed" end
        if src.index ~= nil then
            if src.expect == nil then return nil, "index mode requires `expect`" end
            local cur = consts[src.index]
            if cur == nil then return nil, "no constant at index " .. tostring(src.index) end
            if cur ~= src.expect then return nil, "index mismatch" end
            return {{index = src.index, old = cur}}
        end
        local hits = {}
        for i, v in consts do if v == src.target then hits[#hits+1] = {index=i,old=v} end end
        return hits
    end

    local Set = {}; Set.__index = Set

    function ConstPatch.new(name, sources)
        local set = setmetatable({name=name, sources=sources, restores=nil}, Set)
        _sets[#_sets+1] = set
        return set
    end

    function Set:Apply()
        if not HAVE_CONST then return false, "executor lacks debug.getconstants/setconstant" end
        if self.restores   then return false, self.name .. ": already applied" end
        local plan = {}
        for _, src in self.sources do
            local label = self.name .. "/" .. tostring(src.name or "?")
            local fn    = resolveFn(src)
            if not fn then return false, label .. ": cannot resolve target function" end
            if src.fingerprint ~= nil then
                local got = ConstPatch.fingerprint(fn)
                if got ~= src.fingerprint then
                    return false, label .. ": VERSION GATE — fingerprint mismatch"
                end
            end
            local cands, cerr = candidates(fn, src)
            if not cands then return false, label .. ": " .. cerr end
            local found = 0
            for _, cand in cands do
                local hits, herr = collectMatches(cand, src)
                if not hits then return false, label .. ": " .. herr end
                if #hits > 1 then return false, label .. ": AMBIGUOUS" end
                if #hits == 1 then
                    local hit = hits[1]
                    if typeof(src.new) ~= typeof(hit.old) then
                        return false, label .. ": type change refused"
                    end
                    found = found + 1
                    plan[#plan+1] = {fn=cand, index=hit.index, old=hit.old, new=src.new}
                end
            end
            local exact = src.count
            if exact == nil and src.scan ~= "protos" then exact = 1 end
            if exact ~= nil and found ~= exact then
                return false, label .. string.format(": found %d sites, expected %d", found, exact)
            end
            if exact == nil and found == 0 then return false, label .. ": no sites found" end
        end
        local restores = {}
        self.restores  = restores
        local led      = ledger(true)
        for _, p in plan do
            local ok = pcall(_setconstant, p.fn, p.index, p.new)
            if not ok then self:Revert(); return false, self.name .. ": setconstant failed" end
            local rec = {fn=p.fn, index=p.index, old=p.old}
            restores[#restores+1] = rec
            if led then led[#led+1] = rec end
        end
        return true
    end

    function Set:Revert()
        local restores = self.restores
        if not restores then return end
        self.restores = nil
        local led     = ledger()
        for i = #restores, 1, -1 do
            local rec = restores[i]
            pcall(_setconstant, rec.fn, rec.index, rec.old)
            if led then
                for j = #led, 1, -1 do
                    if led[j] == rec then table.remove(led, j); break end
                end
            end
        end
    end

    function Set:IsApplied() return self.restores ~= nil end

    function ConstPatch.revertAll()
        for _, set in _sets do pcall(function() set:Revert() end) end
        local led = ledger()
        if not led or not _setconstant then return end
        for i = #led, 1, -1 do
            local rec = led[i]
            if type(rec) == "table" and type(rec.fn) == "function" then
                pcall(_setconstant, rec.fn, rec.index, rec.old)
            end
            led[i] = nil
        end
    end

    ConstPatch.revertAll()
end

-- ════════════════════════════════════════════════════════════════════════
-- §4  MOBILE DETECTION ENGINE (from KiciaHook)
-- ════════════════════════════════════════════════════════════════════════
local Platform = {}
do
    local function isLargeViewport()
        local vp = Camera.ViewportSize
        return math.min(vp.X, vp.Y) > 500
    end
    local _forceMobile, _forceTablet = nil, nil
    local function detectMobile()
        if _forceMobile ~= nil then return _forceMobile end
        if UIS.PreferredInput == Enum.PreferredInput.Touch then return true end
        if UIS.PreferredInput == Enum.PreferredInput.KeyboardAndMouse or UIS.PreferredInput == Enum.PreferredInput.Gamepad then return false end
        local last = UIS:GetLastInputType()
        if last == Enum.UserInputType.Touch then return true end
        if last == Enum.UserInputType.MouseButton1 or last == Enum.UserInputType.MouseButton2 or last == Enum.UserInputType.MouseMovement or last == Enum.UserInputType.Keyboard then return false end
        return UIS.TouchEnabled and not UIS.KeyboardEnabled
    end
    local _tabletCache = nil
    function Platform.IsMobile()     return detectMobile() end
    function Platform.HasTouch()     return UIS.TouchEnabled end
    function Platform.WantsMobileButtons() return Platform.HasTouch() or Platform.IsMobile() end
    function Platform.IsTablet()
        if _tabletCache == nil then _tabletCache = isLargeViewport() and detectMobile() end
        return _tabletCache
    end
    bind(Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        if _forceMobile == nil then _tabletCache = nil end
    end))
end

-- ════════════════════════════════════════════════════════════════════════
-- §5  THEME & UI PRIMITIVES (from Graviton-9v2)
-- ════════════════════════════════════════════════════════════════════════
local T = {
    bg     = Color3.fromRGB(4,   3,   7),
    side   = Color3.fromRGB(7,   5,  11),
    card   = Color3.fromRGB(10,  8,  15),
    row    = Color3.fromRGB(16, 13,  24),
    stroke = Color3.fromRGB(26, 21,  38),
    text   = Color3.fromRGB(242,238, 255),
    sub    = Color3.fromRGB(120,108, 150),
    off    = Color3.fromRGB(28,  23,  40),
    accent = Color3.fromRGB(132,  0, 255),
    simple = false,
}
local LOGO_ALT  = Color3.fromRGB(200, 50, 200)
local ACCENTS   = {
    Color3.fromRGB(132,  0, 255),
    Color3.fromRGB(56,  189, 248),
    Color3.fromRGB(52,  211, 153),
    Color3.fromRGB(251, 113, 133),
    Color3.fromRGB(250, 204,  21),
}
local F = {
    title = Font.new("rbxasset://fonts/families/Michroma.json",  Enum.FontWeight.Regular),
    body  = Font.new("rbxasset://fonts/families/Jura.json",      Enum.FontWeight.Medium),
    bold  = Font.new("rbxasset://fonts/families/Jura.json",      Enum.FontWeight.Bold),
}

local accentObjs, accentHooks = {}, {}
local function A(o, prop) table.insert(accentObjs, {o, prop}); o[prop] = T.accent; return o end
local function setAccent(c)
    T.accent = c
    for _, v in ipairs(accentObjs) do if v[1].Parent then v[1][v[2]] = c end end
    for _, f in ipairs(accentHooks) do pcall(f) end
end

local function new(class, props, p)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    o.Parent = p
    return o
end
local function corner(o, r)
    return new("UICorner", {CornerRadius = UDim.new(0, r or 8)}, o)
end
local function stroke(o, c)
    return new("UIStroke", {Color = c or T.stroke, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, o)
end
local function mkText(p, props)
    local t = new("TextLabel", {BackgroundTransparency=1, FontFace=F.body, TextSize=14, TextColor3=T.text, TextXAlignment=Enum.TextXAlignment.Left}, p)
    for k, v in pairs(props or {}) do t[k] = v end
    return t
end
local function isPress(i) return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch end
local function isMove(i) return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch end

-- ════════════════════════════════════════════════════════════════════════
-- §6  MAIN GUI WINDOW
-- ════════════════════════════════════════════════════════════════════════
local UI = {scale = 1.0, height = 460}
local gui = new("ScreenGui", {Name="Eclipse", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling, IgnoreGuiInset=true}, parent)

local function fitScale()
    local vp = Camera.ViewportSize
    return math.max(0.5, math.min(UI.scale, vp.X * 0.95 / 610, vp.Y * 0.95 / UI.height))
end

local dim = new("Frame", {Size=UDim2.fromScale(1,1), BackgroundColor3=Color3.new(0,0,0), BackgroundTransparency=1, BorderSizePixel=0, ZIndex=0}, gui)

local main = new("CanvasGroup", {
    Size = UDim2.fromOffset(610, UI.height),
    AnchorPoint = Vector2.new(0.5,0.5),
    Position = UDim2.fromScale(0.5,0.5),
    BackgroundColor3 = T.bg,
    GroupTransparency = 0,
    Visible = false,
    ZIndex = 2,
}, gui)
corner(main, 12); local mainStroke = stroke(main)
local mainScale = new("UIScale", {Scale = fitScale()}, main)

-- Animated Gradient Border
do
    mainStroke.Color = Color3.new(1,1,1)
    mainStroke.Thickness = 1.5
    local borderGradient = new("UIGradient", {Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,0.1),
        NumberSequenceKeypoint.new(0.5,0.65),
        NumberSequenceKeypoint.new(1,0.1)})}, mainStroke)
    
    local function paintBorder()
        borderGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, T.accent),
            ColorSequenceKeypoint.new(0.5, LOGO_ALT),
            ColorSequenceKeypoint.new(1, T.accent)
        })
    end
    paintBorder()
    table.insert(accentHooks, paintBorder)
    bind(RunService.Heartbeat:Connect(function() borderGradient.Rotation = (os.clock() * 50) % 360 end))
end

-- Title Bar
local titleBar = new("Frame", {Size=UDim2.new(1,0,0,38), BackgroundColor3=T.side, BorderSizePixel=0}, main)
new("Frame", {Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1), BackgroundColor3=T.stroke, BorderSizePixel=0}, titleBar)
local logo = mkText(titleBar, {
    Text = 'ECLIPSE',
    Size = UDim2.new(1,0,1,0),
    TextXAlignment = Enum.TextXAlignment.Center,
    FontFace = F.title,
    TextSize = 18,
    TextColor3 = T.accent
})
table.insert(accentHooks, function() logo.TextColor3 = T.accent end)

-- Sidebar Layout
local side = new("Frame", {Size=UDim2.new(0,70,1,-38), Position=UDim2.fromOffset(0,38), BackgroundColor3=T.side, BorderSizePixel=0}, main)
new("Frame", {Size=UDim2.new(0,1,1,0), Position=UDim2.new(1,-1,0,0), BackgroundColor3=T.stroke, BorderSizePixel=0}, side)
local sideList = new("UIListLayout", {Padding=UDim.new(0,4), SortOrder=Enum.SortOrder.LayoutOrder, HorizontalAlignment=Enum.HorizontalAlignment.Center}, side)

-- Content Box
local content = new("Frame", {Size=UDim2.new(1,-70,1,-38), Position=UDim2.fromOffset(70,38), BackgroundTransparency=1, ClipsDescendants=true}, main)

-- ════════════════════════════════════════════════════════════════════════
-- §7  NOTIFICATIONS
-- ════════════════════════════════════════════════════════════════════════
local UIFX = {notifyOn = true}
local _notifyHolder, _notifyScale, _notifyCount, _notifyLive = nil, nil, 0, {}
do
    _notifyHolder = new("Frame", {AnchorPoint=Vector2.new(1,1), Position=UDim2.new(1,-18,1,-18), Size=UDim2.fromOffset(260,320), BackgroundTransparency=1, ZIndex=30}, gui)
    new("UIListLayout", {VerticalAlignment=Enum.VerticalAlignment.Bottom, Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder}, _notifyHolder)
    _notifyScale = new("UIScale", {Scale=1.0}, _notifyHolder)

    function UIFX.notify(msg)
        if not UIFX.notifyOn then return end
        _notifyCount = _notifyCount + 1
        local slot = new("Frame", {Size=UDim2.new(1,0,0,40), BackgroundTransparency=1, LayoutOrder=_notifyCount, ZIndex=30}, _notifyHolder)
        local box = new("Frame", {Size=UDim2.fromScale(1,1), Position=UDim2.fromOffset(290,0), BackgroundColor3=T.card, ZIndex=30}, slot)
        corner(box, 8); stroke(box, T.accent)
        mkText(box, {Text=msg, Size=UDim2.new(1,-20,1,0), Position=UDim2.fromOffset(12,0), TextSize=13, ZIndex=31})
        
        table.insert(_notifyLive, slot)
        tween(box, {Position=UDim2.fromOffset(0,0)}, 0.3):Play()
        task.delay(3.0, function()
            if not slot.Parent then return end
            local tw = tween(box, {Position=UDim2.fromOffset(290,0)}, 0.3)
            tw:Play()
            tw.Completed:Wait()
            local idx = table.find(_notifyLive, slot)
            if idx then table.remove(_notifyLive, idx) end
            slot:Destroy()
        end)
    end
end

-- ════════════════════════════════════════════════════════════════════════
-- §8  PAGINATION SYSTEM & CARD BUILDER
-- ════════════════════════════════════════════════════════════════════════
local PAGES = {}
local navBtns = {}
local currentTab = ""

local function selectPage(name)
    currentTab = name
    for n, pg in pairs(PAGES) do
        pg.scroll.Visible = (n == name)
    end
    for n, btn in pairs(navBtns) do
        tween(btn, {TextColor3 = (n == name and T.accent or T.sub)}, 0.15):Play()
    end
end

local pageOrder = 0
local function addPage(name, icon)
    pageOrder = pageOrder + 1
    local sf = new("ScrollingFrame", {
        Size=UDim2.fromScale(1,1),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ScrollBarThickness=4,
        ScrollBarImageColor3=T.accent,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        Visible=false
    }, content)
    new("UIListLayout", {Padding=UDim.new(0,8), SortOrder=Enum.SortOrder.LayoutOrder}, sf)
    new("UIPadding", {PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10), PaddingTop=UDim.new(0,10), PaddingBottom=UDim.new(0,10)}, sf)

    local btn = new("TextButton", {
        Text = icon or "•",
        Size = UDim2.fromOffset(50, 40),
        BackgroundTransparency = 1,
        FontFace = F.bold,
        TextSize = 18,
        TextColor3 = T.sub,
        LayoutOrder = pageOrder
    }, side)
    
    navBtns[name] = btn
    PAGES[name] = {scroll = sf}

    btn.MouseButton1Click:Connect(function() selectPage(name) end)
    return sf
end

local cardCounter = 0
local function makeCard(scroll, title)
    cardCounter = cardCounter + 1
    local cardFrame = new("Frame", {
        Size = UDim2.new(1,0,0,0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = T.card,
        BorderSizePixel = 0,
        LayoutOrder = cardCounter
    }, scroll)
    corner(cardFrame, 8); local cs = stroke(cardFrame)
    new("UIPadding", {PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10), PaddingTop=UDim.new(0,8), PaddingBottom=UDim.new(0,8)}, cardFrame)
    
    local body = new("Frame", {Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y, BackgroundTransparency=1}, cardFrame)
    new("UIListLayout", {Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder}, body)

    mkText(body, {Text=title:upper(), Size=UDim2.new(1,0,0,16), TextSize=11, TextColor3=T.sub, FontFace=F.bold, LayoutOrder=0})

    local rowCounter = 0
    local api = {}

    local function createRow(h)
        rowCounter = rowCounter + 1
        return new("Frame", {Size=UDim2.new(1,0,0,h or 26), BackgroundTransparency=1, LayoutOrder=rowCounter}, body)
    end

    function api.toggle(label, configTable, key, cb)
        local row = createRow(26)
        mkText(row, {Text=label, Size=UDim2.new(1,-50,1,0), TextSize=13})
        
        local btn = new("TextButton", {
            Size = UDim2.fromOffset(36, 18),
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1,0,0.5,0),
            BackgroundColor3 = configTable[key] and T.accent or T.off,
            Text = "", AutoButtonColor = false
        }, row)
        corner(btn, 9)
        local knob = new("Frame", {
            Size = UDim2.fromOffset(12, 12),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(configTable[key] and 0.75 or 0.25, 0.5),
            BackgroundColor3 = Color3.new(1,1,1)
        }, btn)
        corner(knob, 6)

        local function updateUI(animate)
            local targetBg = configTable[key] and T.accent or T.off
            local targetPos = UDim2.fromScale(configTable[key] and 0.75 or 0.25, 0.5)
            if animate then
                tween(btn, {BackgroundColor3 = targetBg}, 0.15):Play()
                tween(knob, {Position = targetPos}, 0.15):Play()
            else
                btn.BackgroundColor3 = targetBg
                knob.Position = targetPos
            end
        end

        btn.MouseButton1Click:Connect(function()
            configTable[key] = not configTable[key]
            updateUI(true)
            if cb then cb(configTable[key]) end
            UIFX.notify(label .. " -> " .. (configTable[key] and "ON" or "OFF"))
        end)

        table.insert(accentHooks, function() updateUI(false) end)
        return btn
    end

    function api.slider(label, configTable, key, minVal, maxVal, step, suffix, cb)
        local row = createRow(38)
        mkText(row, {Text=label, Size=UDim2.new(0.6,0,0,16), TextSize=13})
        local valLabel = mkText(row, {
            Text = tostring(configTable[key]) .. (suffix or ""),
            Size = UDim2.new(0.4,0,0,16),
            Position = UDim2.new(0.6,0,0,0),
            TextXAlignment = Enum.TextXAlignment.Right
        })

        local track = new("TextButton", {
            Size = UDim2.new(1,0,0,10),
            Position = UDim2.fromOffset(0, 22),
            BackgroundColor3 = T.row,
            Text = "", AutoButtonColor = false
        }, row)
        corner(track, 5)
        local fill = new("Frame", {
            Size = UDim2.fromScale(math.clamp((configTable[key] - minVal) / (maxVal - minVal), 0, 1), 1),
            BackgroundColor3 = T.accent
        }, track)
        corner(fill, 5)

        local function updateSlider(posX)
            local pct = math.clamp((posX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local rawVal = minVal + (maxVal - minVal) * pct
            local steppedVal = math.floor(rawVal / step + 0.5) * step
            steppedVal = math.clamp(steppedVal, minVal, maxVal)
            
            configTable[key] = steppedVal
            valLabel.Text = tostring(steppedVal) .. (suffix or "")
            fill.Size = UDim2.fromScale(math.clamp((steppedVal - minVal) / (maxVal - minVal), 0, 1), 1)
            if cb then cb(steppedVal) end
        end

        local isSliding = false
        track.InputBegan:Connect(function(input)
            if isPress(input) then isSliding = true updateSlider(input.Position.X) end
        end)
        UIS.InputChanged:Connect(function(input)
            if isSliding and isMove(input) then updateSlider(input.Position.X) end
        end)
        UIS.InputEnded:Connect(function(input)
            if isPress(input) then isSliding = false end
        end)

        table.insert(accentHooks, function() fill.BackgroundColor3 = T.accent end)
    end

    function api.button(label, cb)
        local row = createRow(28)
        local btn = new("TextButton", {
            Size = UDim2.fromScale(1,1),
            Text = label,
            BackgroundColor3 = T.row,
            FontFace = F.body,
            TextSize = 13,
            TextColor3 = T.text,
            AutoButtonColor = false
        }, row)
        corner(btn, 6); local bs = stroke(btn)
        
        btn.MouseEnter:Connect(function() tween(bs, {Color = T.accent}, 0.15):Play() end)
        btn.MouseLeave:Connect(function() tween(bs, {Color = T.stroke}, 0.15):Play() end)
        btn.MouseButton1Click:Connect(function() if cb then cb() end end)
    end

    function api.note(txt)
        rowCounter = rowCounter + 1
        mkText(body, {Text=txt, Size=UDim2.new(1,0,0,14), TextSize=11, TextColor3=T.sub, LayoutOrder=rowCounter})
    end

    return api
end

-- ════════════════════════════════════════════════════════════════════════
-- §9  PAGE CONTENT HOOKS
-- ════════════════════════════════════════════════════════════════════════
local tabMove   = addPage("move",   "🏃")
local tabCombat = addPage("combat", "⚔")
local tabVisual = addPage("visual", "🌈")
local tabMenu   = addPage("menu",   "⚙")

-- Populating Movement Controls
do
    local cFly = makeCard(tabMove, "Flight & Speed")
    cFly.toggle("Enable Flight", S, "fly", function(v)
        -- Flight loop handles initialization directly
    end)
    cFly.slider("Flight Speed", S, "flySpeed", 10, 300, 5, " st/s")
    cFly.toggle("Noclip Collision", S, "noclip")
    cFly.toggle("Infinite Jump", S, "infJump")

    local cSpeed = makeCard(tabMove, "Humanoid Physics")
    cSpeed.slider("Walkspeed modifier", S, "walk", 16, 250, 2, " speed")
    cSpeed.slider("Jumppower modifier", S, "jump", 50, 300, 5, " power")
    cSpeed.toggle("Strict Values Lock", S, "lock")
end

-- Populating Combat Controls
do
    local cAim = makeCard(tabCombat, "Silent Aim Logic")
    cAim.toggle("Silent Aim Enabled", SA, "on")
    cAim.slider("FOV Radius Limits", SA, "fov", 10, 500, 5, " px")
    cAim.slider("Hit Probability Rate", SA, "hitChance", 0, 100, 1, "%")
    cAim.slider("Target Headshot Ratio", SA, "hsPercent", 0, 100, 1, "%")
    cAim.toggle("Visible Target Walls Filter", SA, "visOnly")
    cAim.toggle("Render Aim Bounds Circle", SA, "showFov")

    local cLock = makeCard(tabCombat, "Camera Steering Aimbot")
    cLock.toggle("Camera Lock Enabled", AB, "on")
    cLock.slider("Field Of View Limit", AB, "fovDeg", 1, 90, 1, "°")
    cLock.slider("Steering Smoothness", AB, "smoothness", 1, 50, 1, " damping")
    cLock.toggle("Position Target Prediction", AB, "prediction")
    cLock.toggle("Display Lock Ring", AB, "showFov")
end

-- Populating Visual Controls
do
    local cEsp = makeCard(tabVisual, "Player ESP Core")
    cEsp.toggle("Master Overlay System", ESPState, "enabled")
    cEsp.toggle("Bounding Box Overlays", ESPState, "box")
    cEsp.toggle("Internal Bone Skeletons", ESPState, "skeleton")
    cEsp.toggle("Wall Chams Highlights", ESPState, "chams")
    cEsp.toggle("Display Target Tags", ESPState, "names")
    cEsp.toggle("Calculate Distance Metres", ESPState, "distance")
    cEsp.toggle("Render Alive Health Bars", ESPState, "health")
    cEsp.toggle("Ignore Friendly Squads", ESPState, "hideTeam")
end

-- Populating Configurations & System Menu
do
    local cMenu = makeCard(tabMenu, "System Settings")
    cMenu.slider("UI Window Opacity", S, "opacity", 30, 100, 5, "%", function(v)
        main.GroupTransparency = 1 - (v/100)
    end)
    cMenu.slider("UI Interface Scale", S, "scale", 50, 150, 5, "%", function(v)
        UI.scale = v/100
        mainScale.Scale = fitScale()
    end)
    cMenu.toggle("Receive System Notifications", UIFX, "notifyOn")
    
    cMenu.button("Recenter Main Panel Window", function()
        main.Position = UDim2.fromScale(0.5, 0.5)
    end)
    cMenu.button("Safely Unload Script System", function()
        if getgenv and getgenv().__Eclipse then
            getgenv().__Eclipse.Destroy()
        end
    end)
end

-- ════════════════════════════════════════════════════════════════════════
-- §10  BACKGROUND SYSTEM OPERATIONS ENGINE
-- ════════════════════════════════════════════════════════════════════════
local flyAtt, flyLV, flyAO = nil, nil, nil
local function stopFly()
    for _, obj in ipairs({flyLV, flyAO, flyAtt}) do
        if obj then pcall(function() obj:Destroy() end) end
    end
    flyAtt, flyLV, flyAO = nil, nil, nil
end

local function startFly()
    stopFly()
    local r = root()
    if not r then return end
    flyAtt = new("Attachment", {}, r)
    flyLV  = new("LinearVelocity", {Attachment0 = flyAtt, MaxForce = math.huge, VelocityConstraintMode = Enum.VelocityConstraintMode.Vector, RelativeTo = Enum.ActuatorRelativeTo.World, VectorVelocity = Vector3.zero}, r)
    flyAO  = new("AlignOrientation", {Attachment0 = flyAtt, Mode = Enum.OrientationAlignmentMode.OneAttachment, RigidityEnabled = true}, r)
end

bind(UIS.JumpRequest:Connect(function()
    if S.infJump then
        local h = hum()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))

bind(RunService.RenderStepped:Connect(function(dt)
    local h = hum()
    if h and S.lock then
        local targetSpeed = S.walk
        if S.fly and flyLV then targetSpeed = math.max(targetSpeed, S.flySpeed * 1.2) end
        if math.abs(h.WalkSpeed - targetSpeed) > 0.01 then h.WalkSpeed = targetSpeed end
        if h.UseJumpPower then
            if h.JumpPower ~= S.jump then h.JumpPower = S.jump end
        else
            if h.JumpHeight ~= S.jump / 20 then h.JumpHeight = S.jump / 20 end
        end
    end

    -- Flight Control Loops
    if S.fly then
        if not flyLV then startFly() end
        if flyLV then
            local cf = Camera.CFrame
            local moveDir = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cf.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cf.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cf.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cf.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end
            
            flyLV.VectorVelocity = moveDir.Magnitude > 0 and moveDir.Unit * S.flySpeed or Vector3.zero
            if flyAO and moveDir.Magnitude > 0 then
                flyAO.CFrame = CFrame.lookAt(Vector3.zero, flyLV.VectorVelocity)
            end
        end
    else
        if flyLV then stopFly() end
    end

    -- Noclip Management
    if S.noclip and char() then
        for _, part in ipairs(char():GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end))

-- ════════════════════════════════════════════════════════════════════════
-- §11  PLAYER DRAWING ESP RENDERING CORE
-- ════════════════════════════════════════════════════════════════════════
local SKEL_PAIRS = {
    {"Head","UpperTorso"}, {"UpperTorso","LowerTorso"},
    {"UpperTorso","RightUpperArm"}, {"RightUpperArm","RightLowerArm"},
    {"UpperTorso","LeftUpperArm"}, {"LeftUpperArm","LeftLowerArm"},
    {"LowerTorso","RightUpperLeg"}, {"RightUpperLeg","RightLowerLeg"},
    {"LowerTorso","LeftUpperLeg"}, {"LeftUpperLeg","LeftLowerLeg"}
}
local trackedDrawings = {}

local function createLine()
    local l = Drawing.new("Line")
    l.Visible = false; l.Thickness = 1.5; l.Transparency = 1; return l
end

local function createText()
    local t = Drawing.new("Text")
    t.Visible = false; t.Size = 13; t.Center = true; t.Outline = true; return t
end

local function trackPlayer(plr)
    if plr == LP or trackedDrawings[plr] then return end
    local items = {
        box = {createLine(), createLine(), createLine(), createLine()},
        skel = {},
        name = createText(),
        dist = createText()
    }
    for i=1,#SKEL_PAIRS do items.skel[i] = createLine() end
    trackedDrawings[plr] = items
end

local function cleanPlayerDrawings(plr)
    local items = trackedDrawings[plr]
    if items then
        for _, l in ipairs(items.box) do l:Remove() end
        for _, l in ipairs(items.skel) do l:Remove() end
        items.name:Remove(); items.dist:Remove()
        trackedDrawings[plr] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do trackPlayer(p) end
bind(Players.PlayerAdded:Connect(trackPlayer))
bind(Players.PlayerRemoving:Connect(cleanPlayerDrawings))

bind(RunService.RenderStepped:Connect(function()
    for plr, items in pairs(trackedDrawings) do
        local c = plr.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        
        if not (ESPState.enabled and c and h and hrp and h.Health > 0) or (ESPState.hideTeam and plr.Team == LP.Team) then
            for _, l in ipairs(items.box) do l.Visible = false end
            for _, l in ipairs(items.skel) do l.Visible = false end
            items.name.Visible = false; items.dist.Visible = false
            continue
        end

        local head = c:FindFirstChild("Head")
        if head then
            local headScreen, headVis = Camera:WorldToViewportPoint(head.Position)
            local rootScreen, rootVis = Camera:WorldToViewportPoint(hrp.Position)
            
            if headVis and rootVis then
                local hHeight = math.abs(headScreen.Y - rootScreen.Y) * 2.2
                local hWidth = hHeight * 0.65
                local tl = Vector2.new(rootScreen.X - hWidth/2, rootScreen.Y - hHeight/2)
                local br = Vector2.new(rootScreen.X + hWidth/2, rootScreen.Y + hHeight/2)
                
                if ESPState.box then
                    local tr = Vector2.new(br.X, tl.Y)
                    local bl = Vector2.new(tl.X, br.Y)
                    items.box[1].From = tl; items.box[1].To = tr; items.box[1].Color = ESPState.color; items.box[1].Visible = true
                    items.box[2].From = tr; items.box[2].To = br; items.box[2].Color = ESPState.color; items.box[2].Visible = true
                    items.box[3].From = br; items.box[3].To = bl; items.box[3].Color = ESPState.color; items.box[3].Visible = true
                    items.box[4].From = bl; items.box[4].To = tl; items.box[4].Color = ESPState.color; items.box[4].Visible = true
                else
                    for _, l in ipairs(items.box) do l.Visible = false end
                end

                if ESPState.names then
                    items.name.Text = plr.DisplayName
                    items.name.Position = Vector2.new(rootScreen.X, tl.Y - 14)
                    items.name.Color = T.text; items.name.Visible = true
                else items.name.Visible = false end

                if ESPState.distance and root() then
                    local dVal = math.floor((hrp.Position - root().Position).Magnitude)
                    items.dist.Text = tostring(dVal) .. "m"
                    items.dist.Position = Vector2.new(rootScreen.X, br.Y + 2)
                    items.dist.Color = T.sub; items.dist.Visible = true
                else items.dist.Visible = false end
            end
        end
    end
end))

-- ════════════════════════════════════════════════════════════════════════
-- §12  WINDOW INTERACTION & PACKAGING
-- ════════════════════════════════════════════════════════════════════════
do
    local dragOn, dragStart, frameStart = false, nil, nil
    titleBar.InputBegan:Connect(function(input)
        if isPress(input) then
            dragOn = true; dragStart = input.Position
            frameStart = Vector2.new(main.Position.X.Offset, main.Position.Y.Offset)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragOn and isMove(input) then
            local delta = Vector2.new(input.Position.X - dragStart.X, input.Position.Y - dragStart.Y)
            main.Position = UDim2.fromOffset(frameStart.X + delta.X, frameStart.Y + delta.Y) + UDim2.fromScale(0.5,0.5)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if isPress(input) then dragOn = false end
    end)
end

-- Keybind Menu Open Toggle Listener
bind(UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == S.menuKey then
        main.Visible = not main.Visible
        if main.Visible then mainScale.Scale = fitScale() end
    end
end))

-- Execution Initialize Sequence Setup
selectPage("move")
main.Visible = true
UIFX.notify("Eclipse System Framework Loaded Successfully!")

local api = {}
function api.Destroy()
    stopFly()
    for p, _ in pairs(trackedDrawings) do cleanPlayerDrawings(p) end
    for _, conn in ipairs(conns) do pcall(function() conn:Disconnect() end) end
    pcall(function() gui:Destroy() end)
    if getgenv then getgenv().__Eclipse = nil end
end

if getgenv then getgenv().__Eclipse = api end
return api
