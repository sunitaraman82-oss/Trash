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
--     Neutralises the Rivals AC that sniffs for weak-table fingerprints
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
    TweenService:Create(o, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p):Play()
end

-- character helpers
local function char()   return LP.Character end
local function root()   return char() and char():FindFirstChild("HumanoidRootPart") end
local function hum()    return char() and char():FindFirstChildOfClass("Humanoid") end

-- ════════════════════════════════════════════════════════════════════════
-- §3  CONST-PATCH ENGINE (from LuaHook)
--     Fingerprint-based bytecode constant patcher for deeper AC bypass.
--     Allows patching numeric/string constants inside loaded functions
--     without touching decompiled code — survives most obfuscation passes.
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

    function ConstPatch.available()
        if not HAVE_CONST then return false, "no debug.getconstants/setconstant" end
        if not HAVE_PROTOS then return true, "no getprotos — scan='protos' sources will fail" end
        return true, "ok"
    end

    ConstPatch.revertAll() -- clean up any leftovers from previous runs
end

-- ════════════════════════════════════════════════════════════════════════
-- §4  MOBILE DETECTION ENGINE (from KiciaHook)
--     Accurate IsMobile/IsTablet detection that handles PreferredInput,
--     LastInputType, TouchEnabled, and console (TenFoot) correctly.
-- ════════════════════════════════════════════════════════════════════════
local Platform = {}
do
    local function isLargeViewport()
        local vp = Camera.ViewportSize
        return math.min(vp.X, vp.Y) > 500
    end

    local _forceMobile, _forceTablet = nil, nil

    local function detectMobile(ignoreSize)
        if _forceMobile ~= nil then return _forceMobile end
        if UIS.PreferredInput == Enum.PreferredInput.Touch then return true end
        if UIS.PreferredInput == Enum.PreferredInput.KeyboardAndMouse
           or UIS.PreferredInput == Enum.PreferredInput.Gamepad then return false end
        local last = UIS:GetLastInputType()
        if last == Enum.UserInputType.Touch then return true end
        if last == Enum.UserInputType.MouseButton1
           or last == Enum.UserInputType.MouseButton2
           or last == Enum.UserInputType.MouseMovement
           or last == Enum.UserInputType.Keyboard then return false end
        return UIS.TouchEnabled and not UIS.KeyboardEnabled
    end

    local _tabletCache = nil

    function Platform.IsMobile()     return detectMobile() end
    function Platform.HasTouch()     return UIS.TouchEnabled end
    function Platform.WantsMobileButtons() return Platform.HasTouch() or Platform.IsMobile() end
    function Platform.IsTablet()
        if _tabletCache == nil then _tabletCache = isLargeViewport(detectMobile()) end
        return _tabletCache
    end
    function Platform.ForceMobile(v, tablet)
        _forceMobile = v == true
        _forceTablet = tablet == true
        _tabletCache = nil
    end

    -- update tablet cache if viewport changes
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
    accent = Color3.fromRGB(132,  0, 255),   -- Eclipse violet
    simple = false,
}
local LOGO_ALT  = Color3.fromRGB(200, 50, 200)
local ACCENTS   = {
    Color3.fromRGB(132,  0, 255),  -- eclipse violet (default)
    Color3.fromRGB(56,  189, 248), -- cyan
    Color3.fromRGB(52,  211, 153), -- mint
    Color3.fromRGB(251, 113, 133), -- rose
    Color3.fromRGB(250, 204,  21), -- gold
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
    for _, f in ipairs(accentHooks) do f() end
end

local function new(class, props, p)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    o.Parent = p
    return o
end
local function corner(o, r)
    return new("UICorner", {CornerRadius = UDim.new(0, T.simple and math.min(r or 8, 3) or (r or 8))}, o)
end
local function stroke(o, c)
    return new("UIStroke", {Color = c or T.stroke, Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, o)
end
local function mkText(p, props)
    local t = new("TextLabel", {BackgroundTransparency=1, FontFace=F.body, TextSize=16,
        TextColor3=T.text, TextXAlignment=Enum.TextXAlignment.Left}, p)
    for k, v in pairs(props) do t[k] = v end
    if t.AutomaticSize == Enum.AutomaticSize.None and not t.TextScaled then
        new("UITextSizeConstraint", {MaxTextSize=t.TextSize, MinTextSize=math.min(8,t.TextSize)}, t)
        t.TextWrapped = false; t.TextScaled = true
    end
    return t
end
local function isPress(i)
    return i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch
end
local function isMove(i)
    return i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch
end

-- ════════════════════════════════════════════════════════════════════════
-- §6  MAIN GUI WINDOW
-- ════════════════════════════════════════════════════════════════════════
local UI = {scale = 1.25, height = 460, minHeight = 460}
local gui = new("ScreenGui", {Name="Eclipse", ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling, IgnoreGuiInset=true}, parent)

local function fitScale()
    local vp = Camera.ViewportSize
    return math.max(0.3, math.min(UI.scale, vp.X*0.95/610, vp.Y*0.95/UI.height))
end

local dim = new("Frame", {Size=UDim2.fromScale(1,1), BackgroundColor3=Color3.new(0,0,0),
    BackgroundTransparency=1, BorderSizePixel=0, ZIndex=0}, gui)
new("UIGradient", {Transparency=NumberSequence.new({
    NumberSequenceKeypoint.new(0,0.15),
    NumberSequenceKeypoint.new(0.5,0),
    NumberSequenceKeypoint.new(1,0.15)}), Rotation=90}, dim)

local main = new("CanvasGroup", {
    Size = UDim2.fromOffset(610, UI.height),
    AnchorPoint = Vector2.new(0.5,0.5),
    Position = UDim2.fromScale(0.5,0.5),
    BackgroundColor3 = T.bg,
    GroupTransparency = 1,
    Visible = false,
    ZIndex = 2,
}, gui)
corner(main, 12); stroke(main)
local mainScale = new("UIScale", {Scale = fitScale() * 0.96}, main)
local glow = A(new("Frame", {Size=UDim2.new(1,0,0,2), BorderSizePixel=0, ZIndex=5}, main), "BackgroundColor3")
new("UIGradient", {Transparency=NumberSequence.new({
    NumberSequenceKeypoint.new(0,1),
    NumberSequenceKeypoint.new(0.5,0),
    NumberSequenceKeypoint.new(1,1)})}, glow)

-- Title bar
local titleBar = new("Frame", {Size=UDim2.new(1,0,0,38), BackgroundColor3=T.side, BorderSizePixel=0}, main)
new("Frame", {Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1), BackgroundColor3=T.stroke, BorderSizePixel=0}, titleBar)
local logo = mkText(titleBar, {
    Text = '<font color="#8400ff">ECLIPSE</font>',
    RichText = true,
    AutomaticSize = Enum.AutomaticSize.X,
    Size = UDim2.fromOffset(0,38),
    AnchorPoint = Vector2.new(0.5,0),
    Position = UDim2.new(0.5,0,0,0),
    FontFace = F.title,
    TextSize = 20,
})

-- Sidebar
local side = new("Frame", {
    Size=UDim2.new(0,60,1,-38),
    Position=UDim2.fromOffset(0,38),
    BackgroundColor3=T.side,
    BorderSizePixel=0,
}, main)
new("Frame", {Size=UDim2.new(0,1,1,0), Position=UDim2.new(1,-1,0,0), BackgroundColor3=T.stroke, BorderSizePixel=0}, side)

-- Animated gradient border
do
    local border = main:FindFirstChildOfClass("UIStroke")
    if border then
        border.Color     = Color3.new(1,1,1)
        border.Thickness = 1.5
        local g = new("UIGradient", {Transparency=NumberSequence.new({
            NumberSequenceKeypoint.new(0,0.1),
            NumberSequenceKeypoint.new(0.5,0.65),
            NumberSequenceKeypoint.new(1,0.1)})}, border)
        local function paintBorder()
            g.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, T.accent),
                ColorSequenceKeypoint.new(0.5, LOGO_ALT),
                ColorSequenceKeypoint.new(1, T.accent)})
        end
        paintBorder()
        table.insert(accentHooks, paintBorder)
        bind(RunService.Heartbeat:Connect(function() g.Rotation = (os.clock() * 50) % 360 end))
    end
end

-- ════════════════════════════════════════════════════════════════════════
-- §7  NOTIFICATIONS
-- ════════════════════════════════════════════════════════════════════════
local UIFX = {notifyOn = true}
local _notifyHolder, _notifyScale, _notifyCount, _notifyLive = nil, nil, 0, {}
do
    _notifyHolder = new("Frame", {
        AnchorPoint=Vector2.new(1,1),
        Position=UDim2.new(1,-18,1,-18),
        Size=UDim2.fromOffset(260,320),
        BackgroundTransparency=1, ZIndex=30}, gui)
    new("UIListLayout", {VerticalAlignment=Enum.VerticalAlignment.Bottom,
        Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder}, _notifyHolder)
    _notifyScale = new("UIScale", {Scale=math.min(fitScale(),1.3)}, _notifyHolder)

    function UIFX.notify(msg)
        if not UIFX.notifyOn then return end
        _notifyCount = _notifyCount + 1
        _notifyScale.Scale = math.min(fitScale(), 1.3)
        local slot = new("Frame", {Size=UDim2.new(1,0,0,40), BackgroundTransparency=1,
            LayoutOrder=_notifyCount, ZIndex=30}, _notifyHolder)
        local box = new("Frame", {Size=UDim2.fromScale(1,1), Position=UDim2.fromOffset(290,0),
            BackgroundColor3=T.card, ZIndex=30}, slot)
        corner(box,10)
        new("UIStroke", {Color=T.accent, Transparency=0.55}, box)
        local bar = new("Frame", {Size=UDim2.new(0,3,1,-16), Position=UDim2.fromOffset(9,8),
            BackgroundColor3=T.accent, BorderSizePixel=0, ZIndex=31}, box)
        corner(bar,2)
        mkText(box, {Text=msg, Size=UDim2.new(1,-32,1,0), Position=UDim2.fromOffset(22,0),
            TextSize=13, ZIndex=31, TextTruncate=Enum.TextTruncate.AtEnd})
        local prog = new("Frame", {Size=UDim2.new(1,-20,0,2), Position=UDim2.new(0,10,1,-4),
            BackgroundColor3=LOGO_ALT, BorderSizePixel=0, ZIndex=31}, box)
        corner(prog,1)
        table.insert(_notifyLive, slot)
        if #_notifyLive > 5 then
            local old = table.remove(_notifyLive, 1)
            if old.Parent then old:Destroy() end
        end
        TweenService:Create(box, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Position=UDim2.fromOffset(0,0)}):Play()
        TweenService:Create(prog, TweenInfo.new(2.8, Enum.EasingStyle.Linear),
            {Size=UDim2.new(0,0,0,2)}):Play()
        task.delay(2.8, function()
            if not slot.Parent then return end
            TweenService:Create(box, TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
                {Position=UDim2.fromOffset(290,0)}):Play()
            task.wait(0.3)
            local i = table.find(_notifyLive, slot); if i then table.remove(_notifyLive, i) end
            slot:Destroy()
        end)
    end
end

-- ════════════════════════════════════════════════════════════════════════
-- §8  SCROLLABLE CONTENT AREA + CARD / ROW SYSTEM
-- ════════════════════════════════════════════════════════════════════════
-- content area right of sidebar
local content = new("Frame", {
    Size=UDim2.new(1,-60,1,-38),
    Position=UDim2.fromOffset(60,38),
    BackgroundTransparency=1,
    ClipsDescendants=true,
}, main)

-- nav buttons in sidebar
local navBtns = {}
local current = ""

local function makePageScroll()
    local sf = new("ScrollingFrame", {
        Size=UDim2.fromScale(1,1),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ScrollBarThickness=3,
        ScrollBarImageColor3=T.accent,
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        CanvasSize=UDim2.new(0,0,0,0),
    }, content)
    new("UIPadding", {PaddingLeft=UDim.new(0,12), PaddingRight=UDim.new(0,12),
        PaddingTop=UDim.new(0,10), PaddingBottom=UDim.new(0,10)}, sf)
    new("UIListLayout", {Padding=UDim.new(0,10), SortOrder=Enum.SortOrder.LayoutOrder}, sf)
    sf.Visible = false
    return sf
end

local PAGES = {}

local function selectPage(name)
    if PAGES[name] then
        for n, pg in pairs(PAGES) do
            pg.scroll.Visible = n == name
        end
        current = name
        for n, btn in pairs(navBtns) do
            tween(btn, {TextColor3 = n == name and T.accent or T.sub})
        end
    end
end

local function addPage(name, icon)
    local scroll = makePageScroll()
    PAGES[name] = {scroll=scroll}

    -- sidebar button
    local btn = new("TextButton", {
        Text = icon or "•",
        Size = UDim2.fromOffset(60,48),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        FontFace=F.body,
        TextSize=20,
        TextColor3=T.sub,
    }, side)
    local lbl = mkText(side, {
        Text = name,
        Size = UDim2.new(0,60,0,14),
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextColor3 = T.sub,
    })
    navBtns[name] = btn
    bind(btn.MouseButton1Click:Connect(function() selectPage(name) end))
    bind(btn.MouseEnter:Connect(function()
        if current ~= name then tween(btn, {TextColor3=T.text}) end
    end))
    bind(btn.MouseLeave:Connect(function()
        if current ~= name then tween(btn, {TextColor3=T.sub}) end
    end))
    return scroll
end

-- card builder — returns api with toggle/slider/button/note
local CONTROLS = {}
local function reg(id, getf, setf) CONTROLS[id] = {get=getf, set=setf} end

local function makeCard(scroll, title)
    local c = new("Frame", {
        Size=UDim2.new(1,0,0,0),
        AutomaticSize=Enum.AutomaticSize.Y,
        BackgroundColor3=T.card,
        BorderSizePixel=0,
        LayoutOrder = #scroll:GetChildren(),
    }, scroll)
    corner(c, 8)
    local cs = stroke(c)
    new("UIPadding", {PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10),
        PaddingTop=UDim.new(0,8), PaddingBottom=UDim.new(0,8)}, c)
    local body = new("Frame", {Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
        BackgroundTransparency=1}, c)
    new("UIListLayout", {Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder}, body)
    -- card hover
    bind(c.MouseEnter:Connect(function()
        if not T.simple then tween(cs, {Color=T.accent:Lerp(T.stroke,0.55)}, 0.2) end
    end))
    bind(c.MouseLeave:Connect(function() tween(cs, {Color=T.stroke}, 0.25) end))

    -- title row
    mkText(body, {Text=title:upper(), Size=UDim2.new(1,0,0,18), TextSize=11,
        TextColor3=T.sub, FontFace=F.bold, LayoutOrder=0})

    local api = {}
    api.frame = c; api.body = body

    local function rowFrame(h)
        return new("Frame", {Size=UDim2.new(1,0,0,h or 26),
            BackgroundTransparency=1, LayoutOrder=#body:GetChildren()}, body)
    end

    function api.toggle(label, default, cb)
        local state = default
        local row   = rowFrame(26)
        local lbl   = mkText(row, {Text=label, Size=UDim2.new(1,-44,1,0), TextSize=14})
        local sw    = new("TextButton", {Size=UDim2.fromOffset(38,20),
            AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,0,0.5,0),
            BackgroundColor3=T.off, AutoButtonColor=false, Text="", BorderSizePixel=0}, row)
        corner(sw,10)
        local knob = new("Frame", {Size=UDim2.fromOffset(14,14), AnchorPoint=Vector2.new(0.5,0.5),
            Position=UDim2.fromScale(state and 0.73 or 0.27, 0.5),
            BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0}, sw)
        corner(knob,8)
        local function paint(anim)
            local f = anim and tween or function(o,p) for k,v in pairs(p) do o[k]=v end end
            f(sw,  {BackgroundColor3 = state and T.accent or T.off})
            f(knob,{Position = UDim2.fromScale(state and 0.73 or 0.27, 0.5)})
        end
        paint(false)
        local t = {}
        function t.set(v, silent) state=v; paint(true); if not silent then cb(v) end end
        function t.get() return state end
        table.insert(accentHooks, function() paint(false) end)
        bind(sw.MouseButton1Click:Connect(function()
            t.set(not state)
            UIFX.notify(label .. " → " .. (state and "ON" or "OFF"))
        end))
        reg(title .. "/" .. label, t.get, function(v) if v ~= state then t.set(v) end end)
        return t
    end

    function api.slider(label, mn, mx, default, cb, suffix, step)
        local cur   = default
        local s     = suffix or ""
        local st    = step or 1
        local row   = rowFrame(42)
        mkText(row, {Text=label, Size=UDim2.new(0.6,0,0,16), TextSize=13})
        local valLbl = mkText(row, {Text=tostring(cur)..s,
            AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,0,0,0),
            Size=UDim2.new(0.38,0,0,16), TextSize=13,
            TextXAlignment=Enum.TextXAlignment.Right})
        local track = new("TextButton", {Size=UDim2.new(1,0,0,14), Position=UDim2.fromOffset(0,22),
            BackgroundColor3=T.row, AutoButtonColor=false, Text="", BorderSizePixel=0}, row)
        corner(track,4)
        local ts = stroke(track); ts.Transparency=1
        local fill = new("Frame", {Size=UDim2.new(0,0,1,0), BackgroundColor3=T.accent,
            BorderSizePixel=0}, track)
        corner(fill,4)
        local fillGrad = new("UIGradient", {}, fill)
        local function paintFill()
            fillGrad.Color = T.simple and ColorSequence.new(T.accent)
                or ColorSequence.new(T.accent, T.accent:Lerp(LOGO_ALT, 0.7))
        end
        paintFill()
        table.insert(accentHooks, paintFill)
        local function setVal(v)
            v = math.clamp(math.floor((v - mn) / st + 0.5) * st + mn, mn, mx)
            cur = v
            valLbl.Text = tostring(v) .. s
            fill.Size   = UDim2.new(math.clamp((v - mn) / (mx - mn), 0, 1), 0, 1, 0)
            cb(v)
        end
        setVal(default)
        local function fromX(x)
            setVal(mn + (mx - mn) * math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1))
        end
        local sliding = false
        bind(track.InputBegan:Connect(function(i) if isPress(i) then sliding=true; fromX(i.Position.X) end end))
        bind(UIS.InputChanged:Connect(function(i) if sliding and isMove(i) then fromX(i.Position.X) end end))
        bind(UIS.InputEnded:Connect(function(i) if isPress(i) then sliding=false end end))
        bind(track.MouseEnter:Connect(function() tween(ts, {Transparency=0.5}) end))
        bind(track.MouseLeave:Connect(function() tween(ts, {Transparency=1}) end))
        reg(title.."/"..label, function() return cur end, setVal)
        local s2 = {}
        function s2.set(v) setVal(v) end
        function s2.get() return cur end
        return s2
    end

    function api.button(label, cb)
        local row = rowFrame(26)
        local b   = new("TextButton", {Size=UDim2.fromScale(1,1), Text=label,
            BackgroundColor3=T.row, FontFace=F.body, TextSize=14,
            TextColor3=T.text, AutoButtonColor=false, BorderSizePixel=0}, row)
        corner(b,6)
        local bs = stroke(b)
        bind(b.MouseEnter:Connect(function() tween(bs,{Color=T.accent}) end))
        bind(b.MouseLeave:Connect(function() tween(bs,{Color=T.stroke}) end))
        bind(b.MouseButton1Click:Connect(function() cb(b) end))
        return b
    end

    function api.note(txt)
        local lbl = mkText(body, {Text=txt, Size=UDim2.new(1,0,0,14),
            TextSize=11, TextColor3=T.sub, LayoutOrder=#body:GetChildren()})
        return lbl
    end

    function api.colorButton(label, default, cb)
        local col = default
        local row = rowFrame(26)
        mkText(row, {Text=label, Size=UDim2.new(1,-30,1,0), TextSize=14})
        local swatch = new("TextButton", {Size=UDim2.fromOffset(24,24),
            AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,0,0.5,0),
            BackgroundColor3=col, AutoButtonColor=false, Text="", BorderSizePixel=0}, row)
        corner(swatch,6)
        local s2 = {}
        function s2.set(c) col=c; swatch.BackgroundColor3=c; cb(c) end
        function s2.get() return col end
        return s2
    end

    function api.swatches(label, colors, cb)
        mkText(body, {Text=label, Size=UDim2.new(1,0,0,14),
            TextSize=11, TextColor3=T.sub, LayoutOrder=#body:GetChildren()})
        local row = new("Frame", {Size=UDim2.new(1,0,0,26), BackgroundTransparency=1,
            LayoutOrder=#body:GetChildren()}, body)
        local list = new("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal,
            Padding=UDim.new(0,6)}, row)
        for _, c in ipairs(colors) do
            local sw = new("TextButton", {Size=UDim2.fromOffset(22,22),
                BackgroundColor3=c, AutoButtonColor=false, Text="", BorderSizePixel=0}, row)
            corner(sw,5)
            bind(sw.MouseButton1Click:Connect(function() cb(c) end))
        end
    end

    return api
end

-- ════════════════════════════════════════════════════════════════════════
-- §9  PAGES
-- ════════════════════════════════════════════════════════════════════════
local pgMovement = addPage("move",   "🏃")
local pgCombat   = addPage("combat", "⚔")
local pgESP      = addPage("esp",    "👁")
local pgVisuals  = addPage("visuals","🌈")
local pgSpoof    = addPage("spoof",  "🎭")
local pgSettings = addPage("menu",   "⚙")

-- ════════════════════════════════════════════════════════════════════════
-- §10  MOVEMENT — fly · noclip · infinite jump · walkspeed · jumppower
--      Fly uses LinearVelocity + AlignOrientation for smooth physics-based flight
--      that doesn't fight the character controller
-- ════════════════════════════════════════════════════════════════════════
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

local flyAtt, flyLV, flyAO = nil, nil, nil
local function stopFly()
    for _, o in ipairs({flyLV, flyAO, flyAtt}) do if o then pcall(function() o:Destroy() end) end end
    flyAtt, flyLV, flyAO = nil, nil, nil
end
local function startFly()
    stopFly()
    local r = root(); if not r then return end
    flyAtt = new("Attachment", {}, r)
    flyLV  = new("LinearVelocity", {
        Attachment0 = flyAtt,
        MaxForce    = math.huge,
        VelocityConstraintMode = Enum.VelocityConstraintMode.Vector,
        RelativeTo  = Enum.ActuatorRelativeTo.World,
        VectorVelocity = Vector3.zero,
    }, r)
    flyAO = new("AlignOrientation", {
        Attachment0 = flyAtt,
        Mode        = Enum.OrientationAlignmentMode.OneAttachment,
        RigidityEnabled = true,
    }, r)
end

-- fly-up / fly-down held flags (keyboard + mobile)
local flyUpHeld, flyDownHeld = false, false

-- Mobile fly thumbstick state
local FLYSTICK = {active=false, dir=Vector2.zero, touchId=nil}

bind(UIS.JumpRequest:Connect(function()
    if S.infJump then
        local h = hum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))
bind(LP.CharacterAdded:Connect(function()
    task.wait(0.3)
    if S.fly then startFly() end
end))

-- Movement step
local GP = {on=false, start=35, ramp=0.6, fly=true, held=0, useCurve=false, curve=4}
local GP_CURVES = {
    {"linear",    function(a) return a end},
    {"ease in",   function(a) return a*a end},
    {"ease out",  function(a) return 1-(1-a)^2 end},
    {"smooth",    function(a) return a*a*(3-2*a) end},
    {"spring",    function(a) local t=1-a; return 1-t*t*(2.5*t-1.5) end},
}
GP.CURVES = GP_CURVES

local function gpRamp()
    if not GP.on then return 1 end
    local s0 = GP.start / 100
    local a  = math.clamp(GP.held / GP.ramp, 0, 1)
    return s0 + (1 - s0) * GP.CURVES[GP.curve][2](a)
end

bind(RunService.RenderStepped:Connect(function(dt)
    -- gamepad ramp
    local moving = false
    if GP.on then
        local mv2 = UIS:GetKeysPressed()
        for _, k in ipairs(mv2) do
            if k == Enum.KeyCode.W or k == Enum.KeyCode.A
                or k == Enum.KeyCode.S or k == Enum.KeyCode.D then
                moving = true; break
            end
        end
        if not moving and S.fly then moving = true end
        if moving then GP.held = math.min(GP.held + dt, GP.ramp)
        else GP.held = 0 end
    end

    -- walkspeed / jumppower enforcement
    local h = hum()
    if h and S.lock then
        local want = S.walk
        if S.fly and flyLV then want = math.max(want, S.flySpeed * 1.5) end
        if math.abs(h.WalkSpeed - want) > 0.01 then h.WalkSpeed = want end
        if h.UseJumpPower then
            if h.JumpPower ~= S.jump then h.JumpPower = S.jump end
        else
            if h.JumpHeight ~= S.jump / 20 then h.JumpHeight = S.jump / 20 end
        end
    end

    -- fly
    if S.fly and flyLV then
        local cf  = Camera.CFrame
        local fwd = -cf.LookVector
        local rt  = cf.RightVector
        local up  = Vector3.new(0,1,0)
        local dir = Vector3.zero

        -- keyboard
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + fwd end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - fwd end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - rt  end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + rt  end
        if UIS:IsKeyDown(Enum.KeyCode.Space) or flyUpHeld   then dir = dir + up  end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or flyDownHeld then dir = dir - up end

        -- mobile thumbstick
        if FLYSTICK.active and FLYSTICK.dir.Magnitude > 0.05 then
            local sd  = FLYSTICK.dir
            local stickContrib = fwd * (-sd.Y) + rt * sd.X
            dir = dir + stickContrib
        end

        local spd  = S.flySpeed * (GP.fly and gpRamp() or 1)
        flyLV.VectorVelocity = dir.Magnitude > 0 and dir.Unit * spd or Vector3.zero
        local lv = flyLV.VectorVelocity
        if lv.Magnitude > 0.01 and flyAO then
            flyAO.CFrame = CFrame.lookAt(Vector3.zero, lv)
        end
    end

    -- noclip
    if S.noclip then
        local ch = char()
        if ch then
            for _, p in ipairs(ch:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
end))

-- Movement UI
do
    local fl  = makeCard(pgMovement, "flight")
    local flyT = fl.toggle("fly", false, function(v)
        S.fly = v
        if v then startFly() else stopFly() end
    end)
    fl.slider("speed", 10, 300, 60, function(v) S.flySpeed = v end, " st/s")
    fl.note("wasd · space up · ctrl down · mobile thumbstick shown when active")

    local nc = makeCard(pgMovement, "collision")
    local noclipT = nc.toggle("noclip", false, function(v)
        S.noclip = v
        if not v and char() then
            for _, n in ipairs({"HumanoidRootPart","Torso","UpperTorso","LowerTorso"}) do
                local p = char():FindFirstChild(n); if p then p.CanCollide=true end
            end
        end
    end)
    local ijT = nc.toggle("infinite jump", false, function(v) S.infJump = v end)

    local hu = makeCard(pgMovement, "humanoid")
    local wsS = hu.slider("walkspeed",  16, 250, 16,  function(v) S.walk = v end)
    local jpS = hu.slider("jumppower",  50, 300, 50,  function(v) S.jump = v end)
    hu.toggle("lock values", true, function(v) S.lock = v end)
    hu.button("reset to default", function() wsS.set(16); jpS.set(50) end)

    local gpc = makeCard(pgMovement, "gamepad mode")
    local gpT = gpc.toggle("gamepad mode", false, function(v) GP.on = v end)
    gpc.slider("start speed",  10, 90,  35, function(v) GP.start = v end, "%")
    gpc.slider("ramp time", 0.1, 2.0, 0.6, function(v) GP.ramp  = v end, " s", 0.1)
    gpc.toggle("apply to fly", true, function(v) GP.fly = v end)
    gpc.note("starts at start% speed, ramps to 100% over ramp time")
end

-- ════════════════════════════════════════════════════════════════════════
-- §11  PLAYER ESP — Drawing-based 2D box + skeleton + HP bar + chams
--      Chams via Highlight (AlwaysOnTop).
--      Drawing.new renders independent of camera so ESP works through walls.
-- ════════════════════════════════════════════════════════════════════════
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

local SKEL_PAIRS = {
    {"Head","UpperTorso"},  {"Head","Torso"},
    {"UpperTorso","LowerTorso"}, {"Torso","HumanoidRootPart"},
    {"UpperTorso","RightUpperArm"}, {"RightUpperArm","RightLowerArm"}, {"RightLowerArm","RightHand"},
    {"UpperTorso","LeftUpperArm"},  {"LeftUpperArm","LeftLowerArm"},   {"LeftLowerArm","LeftHand"},
    {"LowerTorso","RightUpperLeg"}, {"RightUpperLeg","RightLowerLeg"}, {"RightLowerLeg","RightFoot"},
    {"LowerTorso","LeftUpperLeg"},  {"LeftUpperLeg","LeftLowerLeg"},   {"LeftLowerLeg","LeftFoot"},
}

local tracked = {}

local function mkLine(thick, col)
    local ok, l = pcall(Drawing.new, "Line")
    if not ok then l={Visible=false,Thickness=1,Color=Color3.new(1,1,1),Transparency=1,ZIndex=2,From=Vector2.zero,To=Vector2.zero} end
    l.Visible=false; l.Thickness=thick or 1; l.Color=col or Color3.new(1,1,1); l.Transparency=1; l.ZIndex=2
    return l
end
local function mkDrawText(size, col)
    local ok, t = pcall(Drawing.new, "Text")
    if not ok then t={Visible=false,Size=13,Color=Color3.new(1,1,1),Outline=true,OutlineColor=Color3.new(0,0,0),Center=true,Font=3,Transparency=1,ZIndex=3} end
    t.Visible=false; t.Size=size or 13; t.Color=col or Color3.new(1,1,1); t.Outline=true
    t.OutlineColor=Color3.new(0,0,0); t.Center=true; t.Font=3; t.Transparency=1; t.ZIndex=3
    return t
end
local function mkSquare()
    local r = Drawing.new("Square")
    r.Visible=false; r.Filled=true; r.ZIndex=1; r.Color=Color3.new(0,0,0); r.Transparency=0.5
    return r
end

local function makeDrawings(col)
    local d = {}
    d.box = {mkLine(ESPState.boxThick,col), mkLine(ESPState.boxThick,col),
             mkLine(ESPState.boxThick,col), mkLine(ESPState.boxThick,col)}
    d.skel = {}
    for i=1,#SKEL_PAIRS do d.skel[i]=mkLine(ESPState.skelThick,col) end
    d.label    = mkDrawText(13, col)
    d.distLabel= mkDrawText(11, Color3.fromRGB(200,200,200))
    d.hpLabel  = mkDrawText(11, Color3.fromRGB(80,255,100))
    d.hpBarBg  = mkSquare(); d.hpBar = Drawing.new("Square")
    d.hpBar.Visible=false; d.hpBar.Filled=true; d.hpBar.ZIndex=2; d.hpBar.Transparency=1
    d.highlight= nil
    return d
end

local function destroyDrawings(d)
    if not d then return end
    if d.highlight then pcall(function() d.highlight:Destroy() end); d.highlight=nil end
    if d.box  then for _,l in ipairs(d.box)  do pcall(function() l:Remove() end) end end
    if d.skel then for _,l in ipairs(d.skel) do pcall(function() l:Remove() end) end end
    for _, k in ipairs({"label","distLabel","hpLabel","hpBarBg","hpBar"}) do
        if d[k] then pcall(function() d[k]:Remove() end) end
    end
end

local function hideAll(d)
    if not d then return end
    if d.highlight then pcall(function() d.highlight.Enabled=false end) end
    if d.box  then for _,l in ipairs(d.box)  do pcall(function() l.Visible=false end) end end
    if d.skel then for _,l in ipairs(d.skel) do pcall(function() l.Visible=false end) end end
    for _, k in ipairs({"label","distLabel","hpLabel","hpBarBg","hpBar"}) do
        if d[k] then pcall(function() d[k].Visible=false end) end
    end
end

local function attachHighlight(plr, d)
    local ch = plr.Character; if not ch then return end
    if d.highlight then pcall(function() d.highlight:Destroy() end) end
    local hl = Instance.new("Highlight")
    hl.Name           = "EclipseESPHL"
    hl.Adornee        = ch
    hl.DepthMode      = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillColor      = ESPState.color
    hl.OutlineColor   = ESPState.color:Lerp(Color3.new(1,1,1), 0.3)
    hl.FillTransparency = ESPState.transparency
    hl.OutlineTransparency = 0
    hl.Enabled        = false
    hl.Parent         = ch
    d.highlight       = hl
end

local function espColor(plr)
    if ESPState.teamColor then
        local tc = plr.TeamColor; if tc then return tc.Color end
    end
    return ESPState.color
end

local function trackPlayer(plr)
    if plr == LP or tracked[plr] then return end
    local col = espColor(plr)
    local d   = makeDrawings(col)
    tracked[plr] = d
    task.spawn(function()
        if plr.Character then attachHighlight(plr, d) end
        d.charConn = bind(plr.CharacterAdded:Connect(function()
            task.wait(0.1); attachHighlight(plr, d)
        end))
    end)
end

local function untrackPlayer(plr)
    local d = tracked[plr]; if not d then return end
    if d.charConn then pcall(function() d.charConn:Disconnect() end) end
    destroyDrawings(d)
    tracked[plr] = nil
end

for _, plr in ipairs(Players:GetPlayers()) do trackPlayer(plr) end
bind(Players.PlayerAdded:Connect(trackPlayer))
bind(Players.PlayerRemoving:Connect(untrackPlayer))

local function w2s(pos)
    local sp, vis = Camera:WorldToViewportPoint(pos)
    if not vis or sp.Z <= 0 then return nil end
    return Vector2.new(sp.X, sp.Y)
end

local function charBounds(ch)
    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
    local any = false
    for _, p in ipairs(ch:GetDescendants()) do
        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
            local cf, hs = p.CFrame, p.Size * 0.5
            for _, sx in ipairs({-1,1}) do for _, sy in ipairs({-1,1}) do for _, sz in ipairs({-1,1}) do
                local s = w2s(cf:PointToWorldSpace(Vector3.new(sx*hs.X,sy*hs.Y,sz*hs.Z)))
                if s then
                    minX=math.min(minX,s.X); minY=math.min(minY,s.Y)
                    maxX=math.max(maxX,s.X); maxY=math.max(maxY,s.Y)
                    any=true
                end
            end end end
        end
    end
    if not any then return nil end
    return Vector2.new(minX,minY), Vector2.new(maxX,maxY)
end

local function drawBox(lines, tl, br, col, thick)
    local tr=Vector2.new(br.X,tl.Y); local bl=Vector2.new(tl.X,br.Y)
    local segs={{tl,tr},{tr,br},{br,bl},{bl,tl}}
    for i,seg in ipairs(segs) do
        lines[i].From=seg[1]; lines[i].To=seg[2]; lines[i].Color=col
        lines[i].Thickness=thick; lines[i].Visible=true
    end
end

bind(RunService.RenderStepped:Connect(function()
    if not ESPState.enabled then
        for _, d in pairs(tracked) do hideAll(d) end; return
    end
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    for plr, d in pairs(tracked) do
        local ch  = plr.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        local h2  = ch and ch:FindFirstChildOfClass("Humanoid")
        if not (ch and hrp and h2) or h2.Health <= 0
           or (ESPState.hideTeam and plr.Team == LP.Team) then
            hideAll(d); continue
        end
        local col   = espColor(plr)
        local dist  = myRoot and math.floor((hrp.Position - myRoot.Position).Magnitude + 0.5) or 0
        local hp    = h2.Health
        local maxHp = h2.MaxHealth
        local hpFrac= maxHp > 0 and math.clamp(hp / maxHp, 0, 1) or 0
        -- chams
        if d.highlight then
            d.highlight.Enabled           = ESPState.chams
            d.highlight.FillColor         = col
            d.highlight.OutlineColor      = col:Lerp(Color3.new(1,1,1), 0.3)
            d.highlight.FillTransparency  = ESPState.transparency
        end
        -- box
        local tl, br = charBounds(ch)
        if tl and br and ESPState.box then
            local pad=2
            local ptl=tl-Vector2.new(pad,pad); local pbr=br+Vector2.new(pad,pad)
            drawBox(d.box, ptl, pbr, col, ESPState.boxThick)
            -- HP bar (left)
            if ESPState.health then
                local barW=3; local barX=ptl.X-barW-2; local barH=pbr.Y-ptl.Y; local hpH=barH*hpFrac
                local hpCol=Color3.fromHSV(hpFrac*0.33, 0.9, 1)
                d.hpBarBg.Position=Vector2.new(barX,ptl.Y); d.hpBarBg.Size=Vector2.new(barW,barH); d.hpBarBg.Visible=true
                d.hpBar.Position=Vector2.new(barX,ptl.Y+(barH-hpH)); d.hpBar.Size=Vector2.new(barW,hpH)
                d.hpBar.Color=hpCol; d.hpBar.Visible=true
                d.hpLabel.Text=math.floor(hp+0.5).." hp"
                d.hpLabel.Position=Vector2.new(pbr.X+5, ptl.Y+(pbr.Y-ptl.Y)*0.5-6); d.hpLabel.Visible=true
            else
                d.hpBarBg.Visible=false; d.hpBar.Visible=false; d.hpLabel.Visible=false
            end
            -- name / distance
            local midX=(ptl.X+pbr.X)*0.5
            if ESPState.names then
                d.label.Text=plr.DisplayName; d.label.Color=col
                d.label.Position=Vector2.new(midX, ptl.Y-15); d.label.Visible=true
            else d.label.Visible=false end
            if ESPState.distance then
                d.distLabel.Text=dist.."m"; d.distLabel.Position=Vector2.new(midX, pbr.Y+2)
                d.distLabel.Visible=true
            else d.distLabel.Visible=false end
        else
            if d.box then for _,l in ipairs(d.box) do l.Visible=false end end
            d.label.Visible=false; d.distLabel.Visible=false
            d.hpBarBg.Visible=false; d.hpBar.Visible=false; d.hpLabel.Visible=false
        end
        -- skeleton
        if ESPState.skeleton then
            for i, pair in ipairs(SKEL_PAIRS) do
                local pa=ch:FindFirstChild(pair[1]); local pb=ch:FindFirstChild(pair[2])
                local sa=pa and w2s(pa.Position); local sb=pb and w2s(pb.Position)
                if sa and sb and d.skel[i] then
                    d.skel[i].From=sa; d.skel[i].To=sb; d.skel[i].Color=col
                    d.skel[i].Thickness=ESPState.skelThick; d.skel[i].Visible=true
                elseif d.skel[i] then d.skel[i].Visible=false end
            end
        else if d.skel then for _,l in ipairs(d.skel) do l.Visible=false end end end
    end
end))

bind({Disconnect=function() for plr,_ in pairs(tracked) do untrackPlayer(plr) end end})

-- ESP UI
do
    local em = makeCard(pgESP, "player ESP")
    em.note("2D box · skeleton · HP bar · name · distance · chams")
    em.toggle("enabled",          false, function(v) ESPState.enabled    = v end)
    em.toggle("box",              true,  function(v) ESPState.box        = v end)
    em.toggle("skeleton",         true,  function(v) ESPState.skeleton   = v end)
    em.toggle("chams (highlight)",true,  function(v) ESPState.chams      = v end)
    em.toggle("names",            true,  function(v) ESPState.names      = v end)
    em.toggle("distance",         true,  function(v) ESPState.distance   = v end)
    em.toggle("health bar",       true,  function(v) ESPState.health     = v end)
    em.toggle("hide teammates",   false, function(v) ESPState.hideTeam   = v end)
    em.toggle("team color",       false, function(v) ESPState.teamColor  = v end)
    local es = makeCard(pgESP, "ESP style")
    es.colorButton("color",          ESPState.color,       function(c) ESPState.color       = c end)
    es.slider("fill transparency", 0, 100, 45, function(v) ESPState.transparency  = v/100 end, "%")
    es.slider("box thickness",  0.5, 5,  1.5, function(v) ESPState.boxThick      = v     end, " px", 0.5)
    es.slider("skeleton thick", 0.5, 4,  1.0, function(v) ESPState.skelThick     = v     end, " px", 0.5)
    es.swatches("color presets", {
        Color3.fromRGB(132,0,255), Color3.fromRGB(56,189,248),
        Color3.fromRGB(255,65,90), Color3.fromRGB(80,255,120),
        Color3.fromRGB(255,200,50)}, function(c) ESPState.color=c end)
end

-- ════════════════════════════════════════════════════════════════════════
-- §12  SILENT AIM
--      Hooks RemoteEvent.FireServer on the UseItem/StartShooting remote.
--      Replaces camdata's encoded hit part and direction with the
--      target's head/body hitbox using the same encoding Rivals expects.
--      hit chance · headshot% · body% · vis check · FOV · auto-shoot
-- ════════════════════════════════════════════════════════════════════════
local SA = {
    on       = false,
    fov      = 120,
    hitChance= 100,
    hsPercent= 65,
    bodyPercent=35,
    visOnly  = false,
    autoFire = false,
    showFov  = true,
    -- constants for Rivals hitbox naming
    HEAD_HITBOX  = "HitboxHead",
    HEAD_SMALL   = "HitboxHeadSmall",
    BODY_HITBOX  = "HitboxBody",
}

local saOldFire, saFovCircle = nil, nil

local function getPlayers()
    local out = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hm  = plr.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hm and hm.Health > 0 then table.insert(out, plr.Character) end
        end
    end
    return out
end

local function saGetTarget()
    local mp   = UIS:GetMouseLocation()
    local best, bestD = nil, SA.fov
    for _, ch in ipairs(getPlayers()) do
        local hrp = ch:FindFirstChild("HumanoidRootPart"); if not hrp then continue end
        local sp, vis = Camera:WorldToViewportPoint(hrp.Position)
        if not vis or sp.Z <= 0 then continue end
        if SA.visOnly then
            local rp = RaycastParams.new()
            rp.FilterType = Enum.RaycastFilterType.Exclude
            rp.FilterDescendantsInstances = {LP.Character}
            local dir    = (hrp.Position - Camera.CFrame.Position)
            local ray    = workspace:Raycast(Camera.CFrame.Position, dir, rp)
            local hitCh  = ray and ray.Instance and ray.Instance:FindFirstAncestorOfClass("Model")
            if hitCh ~= ch then continue end
        end
        local d = (Vector2.new(sp.X, sp.Y) - mp).Magnitude
        if d < bestD then best, bestD = ch, d end
    end
    return best
end

-- draw FOV circle
bind(RunService.RenderStepped:Connect(function()
    if not SA.on or not SA.showFov then
        if saFovCircle then saFovCircle.Visible = false end; return
    end
    if not saFovCircle then
        saFovCircle = Drawing.new("Circle")
        saFovCircle.Filled=false; saFovCircle.Thickness=1
        saFovCircle.Color=Color3.new(1,1,1); saFovCircle.Visible=false
    end
    local mp = UIS:GetMouseLocation()
    saFovCircle.Position=mp; saFovCircle.Radius=SA.fov; saFovCircle.Visible=true
end))

task.spawn(function()
    -- find UseItem remote (spawns on match load)
    local rem
    for _ = 1, 300 do
        rem = game:GetService("ReplicatedStorage"):FindFirstChild("UseItem", true)
        if rem then break end
        task.wait(0.1)
    end
    if not rem or not hookfunction or not newcclosure then return end

    saOldFire = hookfunction(rem.FireServer, newcclosure(function(self, obj, action, camdata, ...)
        if SA.on then
            -- detect StartShooting action (0x1A byte OR "StartShooting" enum)
            local isShot = false
            pcall(function()
                local startEnum = nil
                local RS = game:GetService("ReplicatedStorage")
                local elib_mod = RS:FindFirstChild("Modules",true) and RS.Modules:FindFirstChild("EnumLibrary")
                if elib_mod then
                    local ok, elib = pcall(require, elib_mod)
                    if ok and elib then
                        local ok2, v = pcall(function() return elib:ToEnum("StartShooting") end)
                        if ok2 and v then startEnum = v end
                    end
                end
                if startEnum then
                    isShot = (action == startEnum)
                else
                    -- fallback: first byte heuristic
                    if type(action) == "string" then
                        isShot = (string.byte(action,1) == 0x1A) or (string.byte(action,1) == 0x22)
                    end
                end
            end)

            if isShot then
                if math.random(1,100) > SA.hitChance then
                    return saOldFire(self, obj, action, camdata, ...)
                end
                local target = saGetTarget()
                if target then
                    local roll = math.random(1,100)
                    local hitbox
                    if roll <= SA.hsPercent then
                        hitbox = target:FindFirstChild(SA.HEAD_HITBOX)
                            or target:FindFirstChild(SA.HEAD_SMALL)
                            or target:FindFirstChild(SA.BODY_HITBOX)
                    elseif roll <= SA.hsPercent + SA.bodyPercent then
                        hitbox = target:FindFirstChild(SA.BODY_HITBOX)
                    end
                    if hitbox and type(camdata) == "table" and camdata["\x01"] then
                        local inner = camdata["\x01"]
                        -- encode new direction CFrame (Rivals CameraData encoding)
                        local function encodeCF(cf)
                            local rx,ry,rz = cf:ToOrientation()
                            return {["\x00"]=cf.X,["\x01"]=cf.Y,["\x02"]=cf.Z,
                                    ["\x03"]=rx,["\x04"]=ry,["\x05"]=rz}
                        end
                        pcall(function()
                            inner["\x01"] = encodeCF(CFrame.lookAt(Camera.CFrame.Position, hitbox.Position))
                            inner["\x02"] = hitbox
                            inner["\x03"] = Vector3.zero
                        end)
                    end
                end
            end
        end
        return saOldFire(self, obj, action, camdata, ...)
    end))
end)

-- Silent Aim UI
do
    local sa = makeCard(pgCombat, "silent aim")
    sa.note("hooks UseItem remote — redirects shots to target within fov")
    sa.toggle("enabled",                false, function(v) SA.on         = v end)
    sa.slider("fov radius",  10, 500, 120,     function(v) SA.fov        = v end, " px")
    sa.slider("hit chance",   0, 100, 100,     function(v) SA.hitChance  = v end, "%")
    sa.slider("headshot %",   0, 100,  65,     function(v) SA.hsPercent  = v end, "%")
    sa.slider("body %",       0, 100,  35,     function(v) SA.bodyPercent= v end, "%")
    sa.toggle("visible only",           false, function(v) SA.visOnly    = v end)
    sa.toggle("show fov circle",        true,  function(v) SA.showFov   = v end)
    sa.swatches("fov color", {
        Color3.fromRGB(255,255,255), Color3.fromRGB(132,0,255),
        Color3.fromRGB(255,65,90),   Color3.fromRGB(80,255,120)},
        function(c) if saFovCircle then saFovCircle.Color=c end end)
end

-- ════════════════════════════════════════════════════════════════════════
-- §13  AIMBOT — camera-space mouse steering with smoothness + prediction
--      Uses UIS mouse delta approach: each frame we compute the angular
--      error to target and push the camera toward it, respecting FOV limit,
--      smoothness, stickiness, and an optional curved flick snap.
--      Linked-axis mode keeps X/Y proportional. Jump damping reduces
--      overcorrection when target is airborne.
-- ════════════════════════════════════════════════════════════════════════
local AB = {
    on         = false,
    key        = "MB2",
    fovDeg     = 20,
    smoothness = 15,   -- higher = slower / smoother (pixels/frame coefficient)
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
    -- state
    _target    = nil,
    _targetPart= nil,
    _lastTarget= nil,
    _lastTargetTime = 0,
    _keyHeld   = false,
    _flickActive = false,
    _springOffset = Vector2.zero,
    _velHistory = {},
}

local AB_FOV_CIRCLE = nil

local function abKeyDown()
    if AB.key == "MB2" then return UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) end
    local ok, kc = pcall(function() return Enum.KeyCode[AB.key] end)
    return ok and UIS:IsKeyDown(kc) or false
end

local function abPickPart(ch, mode)
    if mode == "Head" then return ch:FindFirstChild("Head") or ch:FindFirstChild("HumanoidRootPart") end
    if mode == "HumanoidRootPart" then return ch:FindFirstChild("HumanoidRootPart") end
    if mode == "Best" then
        -- prefer head if it's closer to center
        local head = ch:FindFirstChild("Head")
        local hrp  = ch:FindFirstChild("HumanoidRootPart")
        if not head then return hrp end
        local mp = UIS:GetMouseLocation()
        local function dist2d(part)
            local sp,vis = Camera:WorldToViewportPoint(part.Position)
            if not vis or sp.Z <= 0 then return math.huge end
            return (Vector2.new(sp.X,sp.Y) - mp).Magnitude
        end
        return dist2d(head) <= dist2d(hrp) and head or hrp
    end
    return ch:FindFirstChild("HumanoidRootPart")
end

local function abSelectTarget()
    local vp     = Camera.ViewportSize
    local center = Vector2.new(vp.X*0.5, vp.Y*0.5)
    local fovPx  = math.tan(math.rad(AB.fovDeg)) * Camera.ViewportSize.Y * 0.5
    local best, bestPart, bestScore = nil, nil, math.huge
    local sticky = AB._lastTarget
    local stickyBonus = AB.stickiness
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local ch  = plr.Character
            local hm2 = ch:FindFirstChildOfClass("Humanoid")
            if not (hm2 and hm2.Health > 0) then continue end
            local part = abPickPart(ch, AB.targetPart)
            if not part then continue end
            local sp, vis = Camera:WorldToViewportPoint(part.Position)
            if not vis or sp.Z <= 0 then continue end
            local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
            if d <= fovPx then
                local score = d
                if plr == sticky then score = score * (1 - stickyBonus) end
                if score < bestScore then bestScore=score; best=plr; bestPart=part end
            end
        end
    end
    return best, bestPart
end

bind(RunService.RenderStepped:Connect(function(dt)
    AB._keyHeld = abKeyDown()
    if not AB.on or not AB._keyHeld then
        AB._target=nil; AB._targetPart=nil
        if AB_FOV_CIRCLE then AB_FOV_CIRCLE.Visible=false end
        return
    end

    -- reaction delay
    if AB.reactionMs > 0 then task.wait(AB.reactionMs / 1000) end

    -- fov circle
    if AB.showFov then
        if not AB_FOV_CIRCLE then
            AB_FOV_CIRCLE = Drawing.new("Circle")
            AB_FOV_CIRCLE.Filled=false; AB_FOV_CIRCLE.NumSides=64; AB_FOV_CIRCLE.Thickness=1
        end
        local fovPx = math.tan(math.rad(AB.fovDeg)) * Camera.ViewportSize.Y * 0.5
        local vp = Camera.ViewportSize
        AB_FOV_CIRCLE.Position=Vector2.new(vp.X*0.5, vp.Y*0.5)
        AB_FOV_CIRCLE.Radius=fovPx; AB_FOV_CIRCLE.Visible=true
        AB_FOV_CIRCLE.Color=T.accent
    elseif AB_FOV_CIRCLE then AB_FOV_CIRCLE.Visible=false end

    -- target selection
    local tgt, part = abSelectTarget()
    if not tgt or not part then
        AB._target=nil; AB._targetPart=nil; return
    end

    -- forget stale target
    if tgt == AB._lastTarget then
        AB._lastTargetTime = tick()
    else
        if tick() - AB._lastTargetTime > AB.forgetTime then
            AB._lastTarget = tgt; AB._lastTargetTime = tick()
        end
    end
    AB._target=tgt; AB._targetPart=part

    -- prediction: extrapolate position by velocity
    local targetPos = part.Position
    if AB.prediction then
        local hrp = tgt.Character and tgt.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local vel = hrp.AssemblyLinearVelocity
            local dist = (targetPos - Camera.CFrame.Position).Magnitude
            local latency = dist / 800  -- approx server-client latency compensation
            targetPos = targetPos + vel * latency
        end
    end

    -- add noise
    if AB.noiseDeg > 0 then
        local ang = math.rad(AB.noiseDeg)
        targetPos = targetPos + Vector3.new(
            (math.random()-0.5)*2*ang,
            (math.random()-0.5)*2*ang,
            (math.random()-0.5)*2*ang)
    end

    -- camera push toward target
    local sp, vis = Camera:WorldToViewportPoint(targetPos)
    if not vis or sp.Z <= 0 then return end

    local vp  = Camera.ViewportSize
    local cx, cy = vp.X*0.5, vp.Y*0.5
    local tx, ty = sp.X - cx, sp.Y - cy

    -- deadzone
    if AB.deadzoneDeg > 0 then
        local dz = math.tan(math.rad(AB.deadzoneDeg)) * vp.Y * 0.5
        if tx*tx + ty*ty < dz*dz then return end
    end

    -- smoothness
    local sx = AB.linkAxes and AB.smoothness or AB.smoothX
    local sy = AB.linkAxes and AB.smoothness or AB.smoothY
    -- curved flick: snap harder when far, ease in close
    local dist2d = math.sqrt(tx*tx + ty*ty)
    local factor = 1
    if AB.curvedFlick then
        factor = 1 + AB.curvedIntensity * math.clamp(dist2d / 200, 0, 1)
    end
    local dx = tx / (sx * factor) * (60 * dt)
    local dy = ty / (sy * factor) * (60 * dt)

    -- jump damping: reduce Y aim speed if target is airborne
    if AB.jumpDamping > 0 then
        local h3 = tgt.Character and tgt.Character:FindFirstChildOfClass("Humanoid")
        if h3 and h3:GetState() == Enum.HumanoidStateType.Freefall then
            dy = dy * (1 - AB.jumpDamping / 100)
        end
    end

    -- spring cancel: subtract existing camera angular velocity
    if AB.cancelSprings then
        local cv = Camera.CFrame
        local nextPos = cv.Position + cv.LookVector * 0.1
        local dCam = (Camera.CFrame.Position - nextPos)
        dx = dx - dCam.X * 0.5
        dy = dy + dCam.Y * 0.5
    end

    -- apply via mousemoverel
    if mousemoverel then
        pcall(mousemoverel, dx, dy)
    elseif UIS.MouseEnabled then
        -- fallback: camera CFrame nudge (no mousemoverel available)
        local cf = Camera.CFrame
        local px = math.rad(-dy * 0.06); local py = math.rad(-dx * 0.06)
        Camera.CFrame = cf * CFrame.Angles(px, py, 0)
    end
end))

-- Aimbot UI
do
    local ab = makeCard(pgCombat, "aimbot")
    ab.note("smooth mouse-based camera aimbot · hold key to activate")
    ab.toggle("enabled",            false, function(v) AB.on          = v end)
    ab.slider("fov (degrees)", 1, 180, 20, function(v) AB.fovDeg      = v end, "°")
    ab.slider("smoothness",    1, 100, 15, function(v) AB.smoothness  = v; AB.smoothX=v; AB.smoothY=v end)
    ab.slider("jump damping",  0, 100, 40, function(v) AB.jumpDamping = v end, "%")
    ab.slider("stickiness",    0, 100, 15, function(v) AB.stickiness  = v/100 end, "%")
    ab.slider("reaction (ms)", 0, 500,  0, function(v) AB.reactionMs  = v end, " ms")
    ab.slider("noise",         0,  10,  0, function(v) AB.noiseDeg    = v end, "°", 0.5)
    ab.toggle("prediction",         false, function(v) AB.prediction  = v end)
    ab.toggle("curved flick",       false, function(v) AB.curvedFlick = v end)
    ab.toggle("cancel springs",     true,  function(v) AB.cancelSprings=v end)
    ab.toggle("show fov circle",    false, function(v) AB.showFov     = v end)
    ab.note("key = MB2 (hold right-click). change key in settings.")
end

-- ════════════════════════════════════════════════════════════════════════
-- §14  TRIGGERBOT — fires when crosshair is directly over an enemy hitbox
--      Uses Raycasting from camera instead of 2D checks for reliability.
-- ════════════════════════════════════════════════════════════════════════
local TB = {
    on        = false,
    maxDist   = 200,
    reactionMs= 0,
    teamCheck = true,
    _last     = 0,
    _cooldown = 0.08,
}

bind(RunService.Heartbeat:Connect(function()
    if not TB.on then return end
    local now = tick()
    if now - TB._last < TB._cooldown then return end
    local ch = LP.Character; if not ch then return end
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = {ch}
    local camCF = Camera.CFrame
    local result = workspace:Raycast(camCF.Position, camCF.LookVector * TB.maxDist, rp)
    if not result or not result.Instance then return end
    local model = result.Instance:FindFirstAncestorOfClass("Model")
    if not model then return end
    local plr = Players:GetPlayerFromCharacter(model)
    if not plr or plr == LP then return end
    if TB.teamCheck and plr.Team == LP.Team then return end
    -- fire
    TB._last = now
    if TB.reactionMs > 0 then task.wait(TB.reactionMs / 1000) end
    -- simulate click via UseItem remote if available
    local rem = game:GetService("ReplicatedStorage"):FindFirstChild("UseItem", true)
    if rem then
        pcall(function()
            local item = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
            if item then rem:FireServer(item) end
        end)
    end
    -- fallback: mouse click sim
    if mouse1click then pcall(mouse1click) end
end))

-- Triggerbot UI
do
    local tb = makeCard(pgCombat, "triggerbot")
    tb.note("raycast from crosshair — fires when aimed directly at enemy")
    tb.toggle("enabled",              false, function(v) TB.on          = v end)
    tb.slider("max distance", 50, 500, 200, function(v) TB.maxDist     = v end, " st")
    tb.slider("reaction (ms)", 0, 500,  0,  function(v) TB.reactionMs  = v end, " ms")
    tb.slider("cooldown (ms)", 20, 500, 80, function(v) TB._cooldown   = v/1000 end, " ms")
    tb.toggle("team check",          true,  function(v) TB.teamCheck   = v end)
end

-- ════════════════════════════════════════════════════════════════════════
-- §15  VOID SPAM — rapid-fire remote spam for Rivals void mechanic
-- ════════════════════════════════════════════════════════════════════════
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

local function getVoidRemote()
    local RS = game:GetService("ReplicatedStorage")
    -- common Rivals void remote paths
    local candidates_paths = {
        {"Remotes","Void"}, {"Remotes","VoidPlayer"},
        {"Remotes","Replication","Fighter","VoidEffect"},
    }
    for _, path in ipairs(candidates_paths) do
        local r = RS
        for _, seg in ipairs(path) do r = r:FindFirstChild(seg); if not r then break end end
        if r and (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) then return r end
    end
    return nil
end

local function fireVoid()
    local rem = getVoidRemote(); if not rem then return end
    if rem:IsA("RemoteEvent")    then pcall(function() rem:FireServer() end) end
    if rem:IsA("RemoteFunction") then pcall(function() rem:InvokeServer() end) end
end

local function startVoidSpam()
    if VS._conn then return end
    VS._conn = RunService.Heartbeat:Connect(function()
        if not VS.on then return end
        if VS.holdMode and not VS._held then return end
        if VS.burstMode then
            task.spawn(function()
                for _=1,VS.burstN do fireVoid(); task.wait(VS.burstGap) end
            end)
        else
            fireVoid()
        end
        task.wait(VS.interval)
    end)
end
local function stopVoidSpam()
    if VS._conn then VS._conn:Disconnect(); VS._conn=nil end
end

bind(UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == VS._holdKey then VS._held = true end
end))
bind(UIS.InputEnded:Connect(function(i)
    if i.KeyCode == VS._holdKey then VS._held = false end
end))

-- Void spam UI
do
    local vs = makeCard(pgCombat, "void spam")
    vs.note("rapid-fires the Rivals void remote")
    local vsT = vs.toggle("void spam", false, function(v)
        VS.on = v
        if v then startVoidSpam() else stopVoidSpam() end
    end)
    vs.slider("fire interval",  1,200,  8, function(v) VS.interval  = v/100 end, " ms")
    vs.toggle("burst mode",         false, function(v) VS.burstMode = v end)
    vs.slider("burst count",    1, 20,   5, function(v) VS.burstN   = v end)
    vs.slider("burst gap",      1, 20,   6, function(v) VS.burstGap = v/100 end, " ms")
    vs.toggle("hold mode (F key)", true,  function(v) VS.holdMode  = v end)
end

-- ════════════════════════════════════════════════════════════════════════
-- §16  VISUALS — lighting presets, self skin, crosshair, speed blur
-- ════════════════════════════════════════════════════════════════════════

-- Lighting presets (from LuaHook)
local LIGHT_ORIG, LIGHT_CLONES = nil, {}
local LIGHT_PROPS = {"Brightness","ExposureCompensation","GlobalShadows","ShadowSoftness",
    "EnvironmentDiffuseScale","EnvironmentSpecularScale","ClockTime","OutdoorAmbient",
    "Ambient","FogEnd","FogStart","FogColor","ColorShift_Top","ColorShift_Bottom"}

local function snapshotLighting()
    if LIGHT_ORIG then return end
    LIGHT_ORIG = {}
    for _, p in ipairs(LIGHT_PROPS) do
        local ok, v = pcall(function() return Lighting[p] end)
        if ok then LIGHT_ORIG[p] = v end
    end
    for _, c in ipairs(Lighting:GetChildren()) do
        if not c:GetAttribute("EC_Custom") then
            local ok, cl = pcall(function() return c:Clone() end)
            if ok and cl then table.insert(LIGHT_CLONES, cl) end
        end
    end
end
local function clearLightCustom()
    for _, c in ipairs(Lighting:GetChildren()) do
        if c:GetAttribute("EC_Custom") then c:Destroy() end
    end
end
local function restoreLighting()
    if not LIGHT_ORIG then return end
    clearLightCustom()
    for k, v in pairs(LIGHT_ORIG) do pcall(function() Lighting[k] = v end) end
    local exist = {}; for _, c in ipairs(Lighting:GetChildren()) do exist[c.Name]=true end
    for _, cl in ipairs(LIGHT_CLONES) do
        if not exist[cl.Name] then cl:Clone().Parent=Lighting end
    end
end
local function newFX(cls, props)
    local f = Instance.new(cls)
    f:SetAttribute("EC_Custom", true)
    for k, v in pairs(props) do f[k]=v end
    f.Parent = Lighting; return f
end

local function applyFullbright()
    snapshotLighting()
    clearLightCustom()
    Lighting.Brightness = S.brightness; Lighting.GlobalShadows = false
    Lighting.EnvironmentDiffuseScale = 1; Lighting.EnvironmentSpecularScale = 1
    Lighting.FogEnd = 100000; Lighting.ClockTime = 14
end

local PRESETS = {}
PRESETS.Cyberpunk = function()
    snapshotLighting(); clearLightCustom()
    Lighting.Brightness=2.6; Lighting.ExposureCompensation=0.5; Lighting.GlobalShadows=false
    Lighting.ClockTime=0; Lighting.OutdoorAmbient=Color3.fromRGB(120,80,165)
    Lighting.Ambient=Color3.fromRGB(80,55,120)
    newFX("Atmosphere", {Density=0.3, Offset=0.3, Color=Color3.fromRGB(160,70,215),
        Decay=Color3.fromRGB(75,200,240), Glare=2.2, Haze=1})
    newFX("BloomEffect", {Intensity=1.15, Size=24, Threshold=0.72})
    newFX("ColorCorrectionEffect", {Brightness=0.04, Contrast=0.2, Saturation=0.45,
        TintColor=Color3.fromRGB(220,195,255)})
end
PRESETS.Anime = function()
    snapshotLighting(); clearLightCustom()
    Lighting.Brightness=2.3; Lighting.GlobalShadows=false; Lighting.ClockTime=15
    Lighting.OutdoorAmbient=Color3.fromRGB(150,140,170); Lighting.Ambient=Color3.fromRGB(95,85,120)
    newFX("Atmosphere", {Density=0.28, Offset=0.35, Color=Color3.fromRGB(255,200,230),
        Decay=Color3.fromRGB(150,195,255), Glare=1, Haze=0.8})
    newFX("BloomEffect", {Intensity=1.0, Size=26, Threshold=0.8})
    newFX("ColorCorrectionEffect", {Brightness=0.03, Contrast=0.14, Saturation=0.32,
        TintColor=Color3.fromRGB(255,228,242)})
end
PRESETS.Sunset = function()
    snapshotLighting(); clearLightCustom()
    Lighting.Brightness=2.3; Lighting.ExposureCompensation=0.4; Lighting.GlobalShadows=false
    Lighting.ClockTime=17.75; Lighting.OutdoorAmbient=Color3.fromRGB(185,115,80)
    newFX("Atmosphere", {Density=0.38, Offset=0.55, Color=Color3.fromRGB(255,150,80),
        Decay=Color3.fromRGB(255,105,60), Glare=1.8, Haze=1.6})
    newFX("BloomEffect", {Intensity=0.9, Size=24, Threshold=0.78})
    newFX("ColorCorrectionEffect", {Brightness=0.03, Contrast=0.16, Saturation=0.32,
        TintColor=Color3.fromRGB(255,195,150)})
end
PRESETS.Vaporwave = function()
    snapshotLighting(); clearLightCustom()
    Lighting.Brightness=2.3; Lighting.ExposureCompensation=0.4; Lighting.GlobalShadows=false
    Lighting.ClockTime=18.4; Lighting.OutdoorAmbient=Color3.fromRGB(150,90,165)
    newFX("Atmosphere", {Density=0.34, Offset=0.4, Color=Color3.fromRGB(255,130,205),
        Decay=Color3.fromRGB(110,200,255), Glare=1.8, Haze=1.3})
    newFX("BloomEffect", {Intensity=1.05, Size=26, Threshold=0.74})
    newFX("ColorCorrectionEffect", {Brightness=0.04, Contrast=0.18, Saturation=0.38,
        TintColor=Color3.fromRGB(255,205,240)})
end
PRESETS.Void = function()
    snapshotLighting(); clearLightCustom()
    Lighting.Brightness=2.0; Lighting.GlobalShadows=false; Lighting.ClockTime=0
    Lighting.OutdoorAmbient=Color3.fromRGB(85,95,135); Lighting.Ambient=Color3.fromRGB(55,62,95)
    newFX("Atmosphere", {Density=0.45, Offset=0.5, Color=Color3.fromRGB(70,80,130),
        Decay=Color3.fromRGB(40,50,100), Glare=0.5, Haze=2})
    newFX("ColorCorrectionEffect", {Brightness=-0.05, Contrast=0.25, Saturation=-0.3,
        TintColor=Color3.fromRGB(180,190,230)})
end

-- Color correction state
local CC_INST = nil
local function getCC()
    if CC_INST and CC_INST.Parent then return CC_INST end
    CC_INST = Instance.new("ColorCorrectionEffect")
    CC_INST.Name = "Eclipse_CC"; CC_INST:SetAttribute("EC_Custom",true)
    CC_INST.Parent = Lighting
    return CC_INST
end

bind(RunService.RenderStepped:Connect(function()
    -- fullbright reassertion
    if S.fullbright then
        pcall(function()
            Lighting.Brightness = S.brightness
            Lighting.GlobalShadows = false
        end)
    end
    -- no-fog reassertion
    if S.noFog then pcall(function() Lighting.FogEnd = 100000 end) end
    -- world tint
    local cc = getCC()
    if S.worldTint then
        local str = S.tintStrength / 100
        cc.Enabled = true
        cc.Saturation = S.saturation / 100
        cc.Contrast   = S.contrast   / 100
        cc.TintColor  = S.tintColor
    else
        cc.Enabled    = false
        cc.Saturation = S.saturation / 100
        cc.Contrast   = S.contrast   / 100
    end
end))

-- Self skin
local SKIN = {on=false, mat=1, color=Color3.fromRGB(132,0,255), rainbow=true}
local SKIN_MATS = {
    {"forcefield", Enum.Material.ForceField},
    {"neon",       Enum.Material.Neon},
    {"glass",      Enum.Material.Glass},
    {"foil",       Enum.Material.Foil},
}
local SKIN_ORIG, SKIN_CHAR = {}, nil
local function restoreSkin()
    for part, o in pairs(SKIN_ORIG) do
        if part.Parent then pcall(function() part.Material,part.Color=o[1],o[2] end) end
    end
    table.clear(SKIN_ORIG)
end

-- Crosshair
local XH = {on=false,arms=4,length=10,thick=2,gap=6,spin=90,opacity=90,dot=true,outline=true,rainbow=false,dynamic=true,color=Color3.fromRGB(132,0,255)}
local xhHolder = new("Frame", {Size=UDim2.fromOffset(1,1),AnchorPoint=Vector2.new(0.5,0.5),
    Position=UDim2.fromScale(0.5,0.5),BackgroundTransparency=1,Visible=false,ZIndex=1}, gui)
local xhArms, xhKick = {}, 0
local xhDot = new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),BorderSizePixel=0,ZIndex=2},xhHolder)
new("UICorner",{CornerRadius=UDim.new(0.5,0)},xhDot)

local function syncXHArms()
    while #xhArms < XH.arms do
        local a = new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),BorderSizePixel=0,ZIndex=2},xhHolder)
        new("UICorner",{CornerRadius=UDim.new(0,1)},a)
        table.insert(xhArms,{f=a,st=new("UIStroke",{Color=Color3.new(0,0,0),Thickness=1},a)})
    end
    while #xhArms > XH.arms do table.remove(xhArms).f:Destroy() end
end

bind(UIS.InputBegan:Connect(function(i,gp)
    if not gp and XH.on and XH.dynamic and i.UserInputType==Enum.UserInputType.MouseButton1 then xhKick=1 end
end))

bind(RunService.RenderStepped:Connect(function(dt)
    -- crosshair render
    xhHolder.Visible = XH.on
    if not XH.on then return end
    if #xhArms ~= XH.arms then syncXHArms() end
    local t2 = os.clock(); xhKick = math.max(0, xhKick - dt*4)
    local col = XH.rainbow and Color3.fromHSV((t2*0.2)%1, 0.75, 1) or XH.color
    local tr  = 1 - XH.opacity/100
    local gap = XH.gap + xhKick*8
    local rot = (t2 * XH.spin) % 360
    if #xhArms ~= XH.arms then syncXHArms() end
    for i2, arm in ipairs(xhArms) do
        local ang   = math.rad((i2-1) * (360 / #xhArms) + rot)
        local cx,cy = 0,0
        local mx    = cx + math.cos(ang) * (gap + XH.length + XH.length*0.5)
        local my    = cy + math.sin(ang) * (gap + XH.length + XH.length*0.5)
        local ax    = math.cos(ang) * XH.length
        local ay    = math.sin(ang) * XH.length
        arm.f.Size            = UDim2.fromOffset(XH.length, XH.thick)
        arm.f.Rotation        = math.deg(ang)
        arm.f.BackgroundColor3 = col
        arm.f.BackgroundTransparency = tr
        arm.f.Position        = UDim2.fromOffset(
            cx + math.cos(ang)*(gap+XH.length*0.5),
            cy + math.sin(ang)*(gap+XH.length*0.5))
        arm.st.Enabled = XH.outline
    end
    xhDot.Size = UDim2.fromOffset(XH.thick*1.5, XH.thick*1.5)
    xhDot.BackgroundColor3 = col
    xhDot.BackgroundTransparency = XH.dot and tr or 1

    -- self skin
    local ch2 = char()
    if SKIN.on and ch2 then
        if SKIN_CHAR ~= ch2 then table.clear(SKIN_ORIG); SKIN_CHAR=ch2 end
        local mat = SKIN_MATS[SKIN.mat][2]
        local sc  = SKIN.rainbow and Color3.fromHSV((t2*0.2)%1, 0.7, 1) or SKIN.color
        for _, p in ipairs(ch2:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                if not SKIN_ORIG[p] then SKIN_ORIG[p]={p.Material,p.Color} end
                p.Material=mat; p.Color=sc
            end
        end
    elseif next(SKIN_ORIG) then restoreSkin() end
end))

-- Speed blur
local speedBlurEff = new("BlurEffect", {Name="EclipseSpeedBlur", Size=0, Enabled=false}, Lighting)
local SPEEDBLUR = {on=false, max=10}
local curBlur = 0
bind(RunService.RenderStepped:Connect(function(dt)
    local r2 = root()
    if r2 and SPEEDBLUR.on then
        local tgt = math.clamp((r2.AssemblyLinearVelocity.Magnitude - 30) / 120, 0, 1) * SPEEDBLUR.max
        curBlur = curBlur + (tgt - curBlur) * math.min(1, dt*8)
        speedBlurEff.Enabled = curBlur > 0.2; speedBlurEff.Size = curBlur
    else
        curBlur = 0; speedBlurEff.Enabled = false
    end
end))

-- Visuals UI
do
    -- Lighting
    local li = makeCard(pgVisuals, "lighting")
    li.toggle("fullbright",        false, function(v) S.fullbright=v; if not v then restoreLighting() end end)
    li.slider("brightness",     0,10, 2,  function(v) S.brightness=v end, nil, 0.5)
    li.toggle("no fog",            false, function(v) S.noFog=v end)
    li.note("brightness applies while fullbright is on")
    local PNAMES = {"Cyberpunk","Anime","Sunset","Vaporwave","Void"}
    for _, pn in ipairs(PNAMES) do
        li.button(pn, function() PRESETS[pn]() UIFX.notify("preset → "..pn) end)
    end
    li.button("restore lighting", function() restoreLighting() end)

    -- World color
    local wc = makeCard(pgVisuals, "world color")
    wc.toggle("world tint",        false, function(v) S.worldTint=v end)
    wc.slider("strength",      0,100,60,  function(v) S.tintStrength=v end, "%")
    wc.colorButton("tint color", S.tintColor, function(c) S.tintColor=c end)
    wc.slider("saturation", -100,100, 0,  function(v) S.saturation=v end, "%")
    wc.slider("contrast",   -100,100, 0,  function(v) S.contrast=v end, "%")

    -- Self skin
    local sk = makeCard(pgVisuals, "self skin")
    sk.toggle("skin",              false, function(v) SKIN.on=v; if not v then restoreSkin() end end)
    local matBtns = sk.button("material: "..SKIN_MATS[1][1], function(b)
        SKIN.mat = SKIN.mat % #SKIN_MATS + 1; b.Text="material: "..SKIN_MATS[SKIN.mat][1]
    end)
    sk.toggle("rainbow",           true,  function(v) SKIN.rainbow=v end)
    sk.colorButton("skin color", SKIN.color, function(c) SKIN.color=c end)
    sk.note("rainbow overrides color picker")

    -- Speed blur
    local sb = makeCard(pgVisuals, "screen fx")
    sb.toggle("speed blur",        false, function(v) SPEEDBLUR.on=v end)
    sb.slider("max blur",       2, 24, 10, function(v) SPEEDBLUR.max=v end)

    -- Crosshair
    local cx = makeCard(pgVisuals, "crosshair")
    cx.toggle("crosshair",         false, function(v) XH.on=v end)
    cx.slider("arms",           2,  8,  4, function(v) XH.arms=v end)
    cx.slider("arm length",     2, 40, 10, function(v) XH.length=v end, " px")
    cx.slider("thickness",      1,  6,  2, function(v) XH.thick=v end, " px", 0.5)
    cx.slider("center gap",     0, 30,  6, function(v) XH.gap=v end, " px")
    cx.slider("spin speed", -360,360, 90, function(v) XH.spin=v end, "°/s", 10)
    cx.slider("opacity",       10,100, 90, function(v) XH.opacity=v end, "%")
    cx.toggle("center dot",        true,  function(v) XH.dot=v end)
    cx.toggle("outline",           true,  function(v) XH.outline=v end)
    cx.toggle("expand on click",   true,  function(v) XH.dynamic=v end)
    cx.toggle("rainbow",           false, function(v) XH.rainbow=v end)
    cx.colorButton("color", XH.color, function(c) XH.color=c end)
    cx.swatches("presets", {
        Color3.fromRGB(132,0,255), Color3.fromRGB(56,189,248),
        Color3.fromRGB(255,65,90), Color3.fromRGB(255,255,255)},
        function(c) XH.color=c end)
end

-- ════════════════════════════════════════════════════════════════════════
-- §17  SPOOF — display name, username, avatar, badges, currency
-- ════════════════════════════════════════════════════════════════════════
local SS = {
    nameOn=false, nameVal="Eclipse",
    dispOn=false, dispVal="Eclipse",
    -- Rivals-specific spoof hooks are live-injected after modules resolve
}

do
    -- Spoof display name via ScreenGui text override
    local function applyNameSpoof(obj)
        if not SS.dispOn then return end
        pcall(function()
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                if tostring(obj.Text) == LP.Name or tostring(obj.Text) == LP.DisplayName then
                    obj.Text = SS.dispVal
                end
            end
        end)
    end

    local sp = makeCard(pgSpoof, "display name")
    sp.toggle("spoof display name", false, function(v) SS.dispOn=v end)
    local dnBox = sp.button("enter spoof name → " .. SS.dispVal, function(b)
        -- In a real executor environment you'd use a textbox widget here
        -- For now the button cycles through presets as a demo
        SS.dispVal = SS.dispVal == "Eclipse" and "Herobrine" or "Eclipse"
        b.Text = "enter spoof name → " .. SS.dispVal
        UIFX.notify("display name → " .. SS.dispVal)
    end)
    sp.note("replaces your name in local ScreenGuis · server may differ")
end

-- ════════════════════════════════════════════════════════════════════════
-- §18  CONFIG — save/load to files if executor supports it
-- ════════════════════════════════════════════════════════════════════════
local CFG_DIR = "Eclipse"
local AUTOLOAD = CFG_DIR .. "/autoload.txt"
local HAS_FS   = typeof(writefile)=="function" and typeof(readfile)=="function"
               and typeof(listfiles)=="function" and typeof(isfile)=="function"
               and typeof(isfolder)=="function"  and typeof(makefolder)=="function"

if HAS_FS then
    pcall(function() if not isfolder(CFG_DIR) then makefolder(CFG_DIR) end end)
end

local function cfgSnapshot()
    local t = {}
    for id, ctrl in pairs(CONTROLS) do
        local ok, v = pcall(ctrl.get)
        if ok then
            if type(v) == "boolean" or type(v) == "number" then t[id]=v end
            if typeof(v) == "Color3" then t[id]={c={v.R,v.G,v.B}} end
        end
    end
    return t
end

local function cfgApply(data)
    if type(data) ~= "table" then return end
    for id, v in pairs(data) do
        local ctrl = CONTROLS[id]
        if ctrl then
            pcall(function()
                if type(v) == "table" and v.c then
                    ctrl.set(Color3.new(v.c[1],v.c[2],v.c[3]))
                else
                    ctrl.set(v)
                end
            end)
        end
    end
end

do
    local mn = makeCard(pgSettings, "config")
    if HAS_FS then
        local nameHolder = {name=""}
        mn.button("save config", function()
            local n = nameHolder.name ~= "" and nameHolder.name or "default"
            local ok = pcall(function()
                writefile(CFG_DIR.."/"..n..".json", HttpService:JSONEncode(cfgSnapshot()))
            end)
            UIFX.notify(ok and "saved → "..n or "save failed")
        end)
        mn.button("load config", function()
            local n = nameHolder.name ~= "" and nameHolder.name or "default"
            local ok, data = pcall(function()
                return HttpService:JSONDecode(readfile(CFG_DIR.."/"..n..".json"))
            end)
            if ok then cfgApply(data); UIFX.notify("loaded → "..n)
            else UIFX.notify("load failed") end
        end)
        mn.button("set as autoload", function()
            local n = nameHolder.name ~= "" and nameHolder.name or "default"
            pcall(function() writefile(AUTOLOAD, n) end)
            UIFX.notify("autoload → "..n)
        end)
        mn.note("configs saved to game/Eclipse/")

        -- autoload on start
        pcall(function()
            if isfile(AUTOLOAD) then
                local n = readfile(AUTOLOAD):gsub("\n",""):gsub("\r","")
                if n ~= "" then
                    task.wait(1)
                    local ok, data = pcall(function()
                        return HttpService:JSONDecode(readfile(CFG_DIR.."/"..n..".json"))
                    end)
                    if ok then cfgApply(data); UIFX.notify("autoloaded → "..n) end
                end
            end
        end)
    else
        mn.note("filesystem not available — config disabled")
    end
end

-- ════════════════════════════════════════════════════════════════════════
-- §19  SETTINGS — accent, opacity, ui size, keybind, notifications
-- ════════════════════════════════════════════════════════════════════════
do
    local mn = makeCard(pgSettings, "menu")
    mn.swatches("accent color", ACCENTS, function(c) setAccent(c) end)
    mn.slider("opacity", 60, 100, 100, function(v)
        main.GroupTransparency = 1 - v/100
    end, "%")
    mn.slider("ui size", 50, 250, 125, function(v)
        UI.scale = v/100; mainScale.Scale = fitScale()
    end, "%")
    mn.toggle("notifications", true, function(v) UIFX.notifyOn = v end)

    local sv = makeCard(pgSettings, "system")
    sv.button("recenter window", function() main.Position = UDim2.fromScale(0.5,0.5) end)
    sv.button("rejoin", function()
        pcall(function() TeleportSvc:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP) end)
    end)
    sv.button("disable all", function()
        for id, ctrl in pairs(CONTROLS) do
            if type(ctrl.get()) == "boolean" and ctrl.get() then
                pcall(function() ctrl.set(false) end)
            end
        end
        UIFX.notify("all features disabled")
    end)
    sv.button("unload Eclipse", function()
        if getgenv and getgenv().__Eclipse then getgenv().__Eclipse.Destroy() end
    end)

    bind(Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        mainScale.Scale = fitScale()
    end))
end

-- ════════════════════════════════════════════════════════════════════════
-- §20  WINDOW DRAG (PC + Mobile touch)
-- ════════════════════════════════════════════════════════════════════════
do
    local dragging, dragStart, startOff = false, nil, nil
    local function begin(i)
        if not isPress(i) then return end
        dragging  = true
        dragStart = i.Position
        startOff  = Vector2.new(main.Position.X.Offset, main.Position.Y.Offset)
    end
    local function offsets() return Vector2.new(main.Position.X.Offset, main.Position.Y.Offset) end

    bind(titleBar.InputBegan:Connect(begin))
    bind(UIS.InputChanged:Connect(function(i)
        if dragging and isMove(i) then
            local delta = Vector2.new(i.Position.X - dragStart.X, i.Position.Y - dragStart.Y)
            local sc    = mainScale.Scale > 0 and mainScale.Scale or 1
            local newOff= startOff + delta / sc
            local vp    = Camera.ViewportSize
            local hw, hh = main.AbsoluteSize.X*0.5, main.AbsoluteSize.Y*0.5
            newOff = Vector2.new(
                math.clamp(newOff.X, hw - vp.X*0.5, vp.X*0.5 - hw),
                math.clamp(newOff.Y, hh - vp.Y*0.5, vp.Y*0.5 - hh))
            main.Position = UDim2.fromOffset(newOff.X, newOff.Y)
                + UDim2.fromScale(0.5, 0.5)
        end
    end))
    bind(UIS.InputEnded:Connect(function(i) if isPress(i) then dragging=false end end))
end

-- ════════════════════════════════════════════════════════════════════════
-- §21  MOBILE SUPPORT (from Graviton-9v2 + KiciaHook)
--      Draggable hamburger button to toggle menu.
--      On-screen fly thumbstick (appears when fly is active + touch detected).
--      Fly Up/Down vertical buttons.
-- ════════════════════════════════════════════════════════════════════════
local opened = false
local function setOpen(v)
    opened = v
    main.Visible = v
    if v then mainScale.Scale = fitScale() end
    tween(main, {GroupTransparency = v and 0 or 1}, 0.2)
    tween(dim,  {BackgroundTransparency = v and (1 - 45/100) or 1}, 0.2)
    if not v then task.delay(0.25, function() if not opened then main.Visible=false end end) end
end

-- keyboard toggle
bind(UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == S.menuKey then setOpen(not opened) end
end))

-- mobile hamburger button
if Platform.WantsMobileButtons() then
    local mbBtn = new("TextButton", {
        Text = "☰",
        Size = UDim2.fromOffset(44, 44),
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.fromOffset(12, 12),
        BackgroundColor3 = T.card,
        FontFace = F.body, TextSize = 22,
        TextColor3 = T.accent,
        AutoButtonColor = false,
        ZIndex = 20,
    }, gui)
    corner(mbBtn, 10)
    A(new("UIStroke",{Thickness=1},mbBtn),"Color")
    table.insert(accentHooks, function() mbBtn.TextColor3 = T.accent end)

    -- drag-to-reposition button
    local mbDrag, mbDragStart, mbBtnStart = false, nil, nil
    bind(mbBtn.InputBegan:Connect(function(i)
        if isPress(i) then
            mbDrag=true; mbDragStart=i.Position
            mbBtnStart=Vector2.new(mbBtn.Position.X.Offset,mbBtn.Position.Y.Offset)
        end
    end))
    bind(UIS.InputChanged:Connect(function(i)
        if mbDrag and isMove(i) then
            local delta=Vector2.new(i.Position.X-mbDragStart.X,i.Position.Y-mbDragStart.Y)
            local newPos=mbBtnStart+delta
            local vp=Camera.ViewportSize
            newPos=Vector2.new(math.clamp(newPos.X,0,vp.X-50),math.clamp(newPos.Y,0,vp.Y-50))
            mbBtn.Position=UDim2.fromOffset(newPos.X,newPos.Y)
        end
    end))
    bind(UIS.InputEnded:Connect(function(i)
        if isPress(i) and mbDrag then
            local delta=Vector2.new(i.Position.X-mbDragStart.X,i.Position.Y-mbDragStart.Y)
            if delta.Magnitude < 8 then setOpen(not opened) end
            mbDrag=false
        end
    end))

    -- fly thumbstick (shown when fly is active)
    local STICK_FRAME = new("Frame", {
        Size=UDim2.fromOffset(120,120),
        AnchorPoint=Vector2.new(0.5,1),
        Position=UDim2.new(0.2, 0, 1, -24),
        BackgroundColor3=Color3.fromRGB(0,0,0),
        BackgroundTransparency=0.65,
        Visible=false, ZIndex=10,
    }, gui)
    corner(STICK_FRAME, 60)
    new("UIStroke",{Color=T.accent,Transparency=0.3,Thickness=2},STICK_FRAME)
    local STICK_KNOB = new("Frame", {
        Size=UDim2.fromOffset(44,44),
        AnchorPoint=Vector2.new(0.5,0.5),
        Position=UDim2.fromScale(0.5,0.5),
        BackgroundColor3=T.accent,
        ZIndex=11,
    }, STICK_FRAME)
    corner(STICK_KNOB, 22)
    table.insert(accentHooks, function()
        new("UIStroke",{Color=T.accent,Transparency=0.3,Thickness=2},STICK_FRAME)
        STICK_KNOB.BackgroundColor3=T.accent
    end)

    -- vertical fly buttons
    local function makeVBtn(label, yOff)
        local b = new("TextButton", {
            Text=label,
            Size=UDim2.fromOffset(44,44),
            AnchorPoint=Vector2.new(1,1),
            Position=UDim2.new(1,-12,1,yOff),
            BackgroundColor3=T.card,
            FontFace=F.bold, TextSize=20,
            TextColor3=T.accent, AutoButtonColor=false,
            ZIndex=10, Visible=false,
        }, gui)
        corner(b,10)
        new("UIStroke",{Color=T.accent,Transparency=0.4,Thickness=1.5},b)
        return b
    end
    local flyUpBtn   = makeVBtn("↑", -72)
    local flyDownBtn = makeVBtn("↓", -22)

    bind(flyUpBtn.InputBegan:Connect(function(i)   if isPress(i) then flyUpHeld=true  end end))
    bind(flyUpBtn.InputEnded:Connect(function(i)   if isPress(i) then flyUpHeld=false end end))
    bind(flyDownBtn.InputBegan:Connect(function(i) if isPress(i) then flyDownHeld=true  end end))
    bind(flyDownBtn.InputEnded:Connect(function(i) if isPress(i) then flyDownHeld=false end end))

    -- thumbstick touch tracking
    bind(UIS.TouchStarted:Connect(function(touch, gp)
        if gp or not S.fly then return end
        local absPos = STICK_FRAME.AbsolutePosition
        local absSize= STICK_FRAME.AbsoluteSize
        local tx, ty = touch.Position.X, touch.Position.Y
        if tx>=absPos.X and tx<=absPos.X+absSize.X
            and ty>=absPos.Y and ty<=absPos.Y+absSize.Y then
            FLYSTICK.active=true; FLYSTICK.touchId=touch
        end
    end))
    bind(UIS.TouchMoved:Connect(function(touch,gp)
        if gp or not FLYSTICK.active or touch~=FLYSTICK.touchId then return end
        local absPos  = STICK_FRAME.AbsolutePosition
        local absSize = STICK_FRAME.AbsoluteSize
        local cx      = absPos.X + absSize.X*0.5
        local cy      = absPos.Y + absSize.Y*0.5
        local dx      = (touch.Position.X - cx) / (absSize.X*0.45)
        local dy      = (touch.Position.Y - cy) / (absSize.Y*0.45)
        FLYSTICK.dir  = Vector2.new(
            math.clamp(dx,-1,1), math.clamp(dy,-1,1))
        STICK_KNOB.Position = UDim2.fromScale(
            0.5 + FLYSTICK.dir.X*0.3,
            0.5 + FLYSTICK.dir.Y*0.3)
    end))
    bind(UIS.TouchEnded:Connect(function(touch,gp)
        if touch==FLYSTICK.touchId then
            FLYSTICK.active=false; FLYSTICK.dir=Vector2.zero; FLYSTICK.touchId=nil
            STICK_KNOB.Position=UDim2.fromScale(0.5,0.5)
        end
    end))

    -- show/hide thumbstick + vertical buttons when fly is active
    bind(RunService.RenderStepped:Connect(function()
        local showFly = S.fly and Platform.WantsMobileButtons()
        STICK_FRAME.Visible = showFly
        flyUpBtn.Visible    = showFly
        flyDownBtn.Visible  = showFly
    end))
end

-- ════════════════════════════════════════════════════════════════════════
-- §22  SELECT FIRST PAGE & OPEN
-- ════════════════════════════════════════════════════════════════════════
selectPage("move")

-- delayed open
task.delay(0.5, function()
    setOpen(true)
    UIFX.notify("Eclipse loaded 👁 — " .. (Platform.IsMobile() and "Mobile" or "PC") .. " mode")
end)

-- ════════════════════════════════════════════════════════════════════════
-- §23  DESTROY / UNLOAD
-- ════════════════════════════════════════════════════════════════════════
local api = {}
function api.Destroy()
    -- revert all patches
    ConstPatch.revertAll()
    -- restore hooks
    if saOldFire then
        local rem = game:GetService("ReplicatedStorage"):FindFirstChild("UseItem", true)
        if rem then pcall(function() hookfunction(rem.FireServer, saOldFire) end) end
    end
    -- restore skin
    restoreSkin()
    -- restore lighting
    restoreLighting()
    -- clean up drawings
    for plr, _ in pairs(tracked) do untrackPlayer(plr) end
    if saFovCircle  then pcall(function() saFovCircle:Remove()  end) end
    if AB_FOV_CIRCLE then pcall(function() AB_FOV_CIRCLE:Remove() end) end
    -- stop void spam
    stopVoidSpam()
    -- disconnect all
    for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    -- destroy gui
    pcall(function() gui:Destroy() end)
    pcall(function() speedBlurEff:Destroy() end)
    -- clear genv
    if getgenv then getgenv().__Eclipse = nil end
end

if getgenv then
    getgenv().__Eclipse = api
end

return api
