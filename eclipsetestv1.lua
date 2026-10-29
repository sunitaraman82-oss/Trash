-- ════════════════════════════════════════════════════════════════════════
-- §1  CORE GUARD & EXECUTOR SHIM
-- ════════════════════════════════════════════════════════════════════════
if getgenv then
    local prev = getgenv().__Eclipse
    if prev and type(prev) == "table" and type(prev.Destroy) == "function" then
        pcall(prev.Destroy)
    end
    getgenv().__Eclipse = nil
end

local Env = {}
do
    local function sf(name)
        local ok, v = pcall(function() return getfenv(0)[name] end)
        if ok and type(v) == "function" then return v end
        return nil
    end

    Env.getgenv     = sf("getgenv")     or function() return _G end
    Env.getrenv     = sf("getrenv")
    Env.gethui      = sf("gethui")      or function() return game:GetService("CoreGui") end
    Env.cloneref    = sf("cloneref")    or function(x) return x end

    Env.setidentity = sf("setthreadidentity") or sf("setidentity")
    Env.getidentity = sf("getthreadidentity") or sf("getidentity") or function() return 8 end

    Env.hookfunc    = sf("hookfunction")
    Env.newcc       = sf("newcclosure")
    Env.hookmeta    = sf("hookmetamethod")
    Env.getnamecall = sf("getnamecallmethod")

    Env.getconst    = sf("getconstants") or (debug and debug.getconstants)
    Env.setconst    = sf("setconstant")  or (debug and debug.setconstant)
    Env.getproto    = sf("getproto")     or (debug and debug.getproto)
    Env.getprotos   = sf("getprotos")    or (debug and debug.getprotos)

    Env.writefile   = sf("writefile")
    Env.readfile    = sf("readfile")
    Env.isfile      = sf("isfile")
    Env.isfolder    = sf("isfolder")
    Env.makefolder  = sf("makefolder")
    Env.listfiles   = sf("listfiles")
    Env.delfile     = sf("delfile")

    Env.CAN_HOOK    = (Env.hookfunc and Env.newcc) ~= nil
    Env.CAN_META    = (Env.hookmeta and Env.getnamecall) ~= nil
    Env.CAN_CONST   = (Env.getconst and Env.setconst) ~= nil
    Env.CAN_PROTOS  = (Env.getproto and Env.getprotos) ~= nil
    Env.CAN_FS      = (Env.writefile and Env.readfile and Env.isfile and Env.makefolder) ~= nil

    function Env.withIdentity(level, fn)
        if not Env.setidentity then return fn() end
        local old = Env.getidentity()
        pcall(Env.setidentity, level)
        local result = table.pack(pcall(fn))
        pcall(Env.setidentity, old)
        if not result[1] then error(result[2], 0) end
        return table.unpack(result, 2, result.n)
    end

    Env.HUDParent = (function()
        local ok, h = pcall(Env.gethui)
        if ok and h then return h end
        return game:GetService("CoreGui")
    end)()
end
-- ════════════════════════════════════════════════════════════════════════
-- §2  MODULE REGISTRY
-- ════════════════════════════════════════════════════════════════════════
local Eclipse = {
    version = "2.0.0",
    Env     = Env,
    _defs   = {},
    _cache  = {},
}

function Eclipse.define(name, factory)
    assert(type(name) == "string" and name ~= "", "Eclipse.define: name required")
    assert(type(factory) == "function", "Eclipse.define: factory required")
    Eclipse._defs[name] = factory
end

function Eclipse.require(name)
    local cached = Eclipse._cache[name]
    if cached ~= nil then return cached end
    local factory = Eclipse._defs[name]
    if not factory then
        error(("Eclipse.require: unknown module '%s'"):format(name), 2)
    end
    local value = factory()
    Eclipse._cache[name] = value
    return value
end
-- ════════════════════════════════════════════════════════════════════════
-- §3  SERVICES (Signal & Trove)
-- ════════════════════════════════════════════════════════════════════════
local Services = {}
Eclipse.define("services", function() return Services end)

-- 3.1 Signal
local Signal = {}
Signal.__index = Signal
function Signal.new() return setmetatable({ _handlers = {} }, Signal) end
function Signal:Connect(fn)
    local h = { fn = fn, connected = true }
    table.insert(self._handlers, h)
    return {
        Connected = true,
        Disconnect = function(conn)
            if not h.connected then return end
            h.connected = false
            conn.Connected = false
            local i = table.find(self._handlers, h)
            if i then table.remove(self._handlers, i) end
        end,
    }
end
function Signal:Fire(...)
    for _, h in ipairs(table.clone(self._handlers)) do
        if h.connected then task.spawn(h.fn, ...) end
    end
end
Services.Signal = Signal

-- 3.2 Trove
local Trove = {}
Trove.__index = Trove
function Trove.new(name) return setmetatable({ _name = name, _items = {} }, Trove) end
local function cleanItem(o)
    local t = typeof(o)
    if t == "RBXScriptConnection" then pcall(function() o:Disconnect() end)
    elseif t == "Instance" then pcall(function() o:Destroy() end)
    elseif type(o) == "function" then pcall(o)
    elseif type(o) == "table" then
        if type(o.Destroy) == "function" then pcall(o.Destroy, o)
        elseif type(o.Disconnect) == "function" then pcall(o.Disconnect, o) end
    end
end
function Trove:Add(item) table.insert(self._items, item) return item end
function Trove:Connect(sig, fn) return self:Add(sig:Connect(fn)) end
function Trove:Clean()
    local items = self._items
    self._items = {}
    for i = #items, 1, -1 do cleanItem(items[i]) end
end
Trove.Destroy = Trove.Clean
Services.Trove = Trove

-- 3.3 Helpers
local connections = {}
function Services.bind(c) table.insert(connections, c) return c end
function Services.tween(obj, props, time)
    game:GetService("TweenService"):Create(obj, TweenInfo.new(time or 0.15, Enum.EasingStyle.Quad), props):Play()
end
function Services.char() return game:GetService("Players").LocalPlayer.Character end
function Services.root()
    local c = Services.char()
    return c and c:FindFirstChild("HumanoidRootPart")
end
function Services.hum()
    local c = Services.char()
    return c and c:FindFirstChildOfClass("Humanoid")
end
-- ════════════════════════════════════════════════════════════════════════
-- §4  THEME & FONTS
-- ════════════════════════════════════════════════════════════════════════
local Theme = {
    bg     = Color3.fromRGB(4,   3,   7),
    side   = Color3.fromRGB(7,   5,  11),
    card   = Color3.fromRGB(10,  8,  15),
    row    = Color3.fromRGB(16, 13,  24),
    stroke = Color3.fromRGB(26, 21,  38),
    text   = Color3.fromRGB(242,238, 255),
    sub    = Color3.fromRGB(120,108, 150),
    off    = Color3.fromRGB(28, 23,  40),
    accent = Color3.fromRGB(132,  0, 255),
    alt    = Color3.fromRGB(200, 50, 200),
    presets = {
        Color3.fromRGB(132,  0, 255),
        Color3.fromRGB(56,  189, 248),
        Color3.fromRGB(52,  211, 153),
        Color3.fromRGB(251, 113, 133),
        Color3.fromRGB(250, 204,  21),
    },
}

local Fonts = {
    title = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Regular),
    body  = Font.new("rbxasset://fonts/families/Jura.json",     Enum.FontWeight.Medium),
    bold  = Font.new("rbxasset://fonts/families/Jura.json",     Enum.FontWeight.Bold),
    mono  = Font.fromEnum(Enum.Font.Code),
}

local accentObjects, accentHooks = {}, {}
local function trackAccent(obj, prop)
    obj[prop] = Theme.accent
    table.insert(accentObjects, { obj = obj, prop = prop })
    return obj
end
function Theme.setAccent(color)
    Theme.accent = color
    for _, v in ipairs(accentObjects) do
        if v.obj.Parent then v.obj[v.prop] = color end
    end
    for _, fn in ipairs(accentHooks) do pcall(fn, color) end
end

Eclipse.Theme = Theme
Eclipse.Fonts = Fonts
Eclipse.define("theme", function() return { Theme = Theme, Fonts = Fonts, trackAccent = trackAccent } end)
-- ════════════════════════════════════════════════════════════════════════
-- §5  HOOK REGISTRY & CONSTPATCH
-- ════════════════════════════════════════════════════════════════════════
local Hooks = {
    _restores = {}, _metahooks = {}, _consts = {}, _namecalls = {}
}

function Hooks.installSetmetatableBypass()
    if not (Env.CAN_HOOK and Env.getrenv) then return false, "requires hookfunction+getrenv" end
    local ok, err = pcall(function()
        local original = Env.getrenv().setmetatable
        local wrapped = Env.hookfunc(original, Env.newcc(function(t, mt)
            if type(mt) == "table" and rawget(mt, "__mode") == "kv"
                and type(t) == "table" and rawlen(t) == 4
                and type(rawget(t, 1)) == "table" and rawget(t, 2) == 1
                and rawget(t, 3) == "String" and type(rawget(t, 4)) == "userdata" then
                return original({1, 2, 3}, {})
            end
            return original(t, mt)
        end))
        Hooks._restores.setmt = { original = original, wrapped = wrapped }
    end)
    return ok, err
end

function Hooks.hookMeta(object, method, handler)
    if not Env.CAN_META then return false, "requires hookmetamethod" end
    local ok, err = pcall(function()
        local original
        original = Env.hookmeta(object, method, Env.newcc(function(...)
            local args = table.pack(...)
            local result = handler(original, args)
            if result ~= nil then return result end
            return original(table.unpack(args, 1, args.n))
        end))
        table.insert(Hooks._metahooks, { object = object, method = method, original = original })
    end)
    return ok, err
end

function Hooks.hookFunction(original, handler)
    if not Env.CAN_HOOK then return original, "requires hookfunction" end
    local wrapped = Env.hookfunc(original, Env.newcc(handler))
    table.insert(Hooks._restores, { original = original, wrapped = wrapped })
    return wrapped
end

function Hooks.teardown()
    for i = #Hooks._consts, 1, -1 do pcall(Env.setconst, Hooks._consts[i].fn, Hooks._consts[i].index, Hooks._consts[i].old) end
    for i = #Hooks._metahooks, 1, -1 do pcall(function() Env.hookmeta(Hooks._metahooks[i].object, Hooks._metahooks[i].method, Hooks._metahooks[i].original) end) end
    for i = #Hooks._restores, 1, -1 do pcall(function() Env.hookfunc(Hooks._restores[i].wrapped, Hooks._restores[i].original) end) end
    if Hooks._restores.setmt then pcall(function() Env.hookfunc(Hooks._restores.setmt.wrapped, Hooks._restores.setmt.original) end) end
    table.clear(Hooks._consts); table.clear(Hooks._metahooks); table.clear(Hooks._restores)
end

-- ConstPatch (Fingerprint-based)
local ConstPatch = { _sets = {}, _ledger = {} }
do
    local getconst, setconst = Env.getconst, Env.setconst
    if Env.CAN_CONST then
        function ConstPatch.patch(fn, index, oldVal, newVal)
            if getconst(fn)[index] == oldVal then
                pcall(setconst, fn, index, newVal)
                table.insert(ConstPatch._ledger, { fn = fn, index = index, old = oldVal })
                return true
            end
            return false
        end
        function ConstPatch.revertAll()
            for i = #ConstPatch._ledger, 1, -1 do
                pcall(setconst, ConstPatch._ledger[i].fn, ConstPatch._ledger[i].index, ConstPatch._ledger[i].old)
            end
            table.clear(ConstPatch._ledger)
        end
    else
        function ConstPatch.patch() return false end
        function ConstPatch.revertAll() end
    end
end

Eclipse.Hooks = Hooks
Eclipse.ConstPatch = ConstPatch
Eclipse.define("hooks", function() return Hooks end)
-- ════════════════════════════════════════════════════════════════════════
-- §6  CONFIG & FILE SYSTEM
-- ════════════════════════════════════════════════════════════════════════
local Config = { CONTROLS = {}, memory = {}, HAS_FS = Env.CAN_FS }
do
    local HttpService = game:GetService("HttpService")
    local FOLDER = "Eclipse"
    if Config.HAS_FS then pcall(function() if not Env.isfolder(FOLDER) then Env.makefolder(FOLDER) end end) end

    function Config.register(id, getter, setter) Config.CONTROLS[id] = { get = getter, set = setter } end
    function Config.snapshot()
        local data = {}
        for id, ctrl in pairs(Config.CONTROLS) do
            local ok, v = pcall(ctrl.get)
            if ok and v ~= nil then
                if type(v) == "boolean" or type(v) == "number" then data[id] = v
                elseif typeof(v) == "Color3" then data[id] = { c = { v.R, v.G, v.B } } end
            end
        end
        return HttpService:JSONEncode(data)
    end
    function Config.apply(json)
        local ok, data = pcall(function() return HttpService:JSONDecode(json) end)
        if not ok then return false end
        for id, v in pairs(data) do
            local ctrl = Config.CONTROLS[id]
            if ctrl then pcall(function()
                if type(v) == "table" and v.c then ctrl.set(Color3.new(v.c[1], v.c[2], v.c[3])) else ctrl.set(v) end
            end) end
        end
        return true
    end
    function Config.save(name)
        local json = Config.snapshot()
        if Config.HAS_FS then return pcall(Env.writefile, FOLDER .. "/" .. name .. ".json", json) end
        Config.memory[name] = json; return true
    end
    function Config.load(name)
        local json
        if Config.HAS_FS then
            local ok, r = pcall(function() return Env.isfile(FOLDER .. "/" .. name .. ".json") and Env.readfile(FOLDER .. "/" .. name .. ".json") end)
            json = ok and r or nil
        else json = Config.memory[name] end
        if json then return Config.apply(json) end
        return false
    end
end
Eclipse.Config = Config
Eclipse.define("config", function() return Config end)
-- ════════════════════════════════════════════════════════════════════════
-- §7  UI PRIMITIVES
-- ════════════════════════════════════════════════════════════════════════
local UI = {}
Eclipse.define("ui", function() return UI end)

do
    local LayoutCounter = setmetatable({}, { __mode = "k" })
    
    function UI.nextLayoutOrder(parent)
        local n = (LayoutCounter[parent] or 0) + 1
        LayoutCounter[parent] = n
        return n
    end

    function UI.new(class, props, parent)
        local o = Instance.new(class)
        for k, v in pairs(props or {}) do o[k] = v end
        if parent then o.Parent = parent end
        return o
    end

    function UI.corner(obj, radius)
        return UI.new("UICorner", { CornerRadius = UDim.new(0, radius or 8) }, obj)
    end

    function UI.stroke(obj, color, thickness)
        return UI.new("UIStroke", { Color = color or Theme.stroke, Thickness = thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, obj)
    end

    function UI.text(parent, props)
        local t = UI.new("TextLabel", {
            BackgroundTransparency = 1, FontFace = Fonts.body, TextSize = 16, TextColor3 = Theme.text, TextXAlignment = Enum.TextXAlignment.Left
        }, parent)
        for k, v in pairs(props) do t[k] = v end
        return t
    end
end
-- ════════════════════════════════════════════════════════════════════════
-- §8  BOOTSTRAP & PUBLIC API
-- ════════════════════════════════════════════════════════════════════════
local BootReport = {}

do
    if Env.CAN_HOOK then
        local ok, err = Hooks.installSetmetatableBypass()
        BootReport.setmetatable_bypass = ok and "ok" or ("skipped: " .. tostring(err))
    else
        BootReport.setmetatable_bypass = "skipped: no hookfunction"
    end
    BootReport.hookfunction   = Env.CAN_HOOK   and "yes" or "no"
    BootReport.hookmetamethod = Env.CAN_META   and "yes" or "no"
    BootReport.constants      = Env.CAN_CONST  and "yes" or "no"
    BootReport.filesystem     = Env.CAN_FS     and "yes" or "no"
end

print(("[Eclipse v%s] foundation ready"):format(Eclipse.version))
for k, v in pairs(BootReport) do print(("  %-22s %s"):format(k, tostring(v))) end

local api = {}
function api.Destroy()
    pcall(Hooks.teardown)
    pcall(ConstPatch.revertAll)
    -- Additional cleanup will be added in Part 2
    if Env.getgenv().__Eclipse == api then Env.getgenv().__Eclipse = nil end
end

Env.getgenv().__Eclipse = api
return api

