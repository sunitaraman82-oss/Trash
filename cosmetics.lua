-- =========================================================
-- ECLIPSE — SKIN CHANGER / COSMETICS (PART 1/2)
-- =========================================================
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp                = Players.LocalPlayer

local function safeRequire(path, timeout)
    if not path then return nil end
    timeout = timeout or 5
    local start = tick()
    while tick() - start < timeout do
        local ok, result = pcall(require, path)
        if ok then return result end
        task.wait(0.2)
    end
    return nil
end
local function waitModule(root, names, timeout)
    timeout = timeout or 10
    local obj = root
    for _, n in ipairs(names) do
        if not obj then return nil end
        local ok, child = pcall(function() return obj:WaitForChild(n, timeout) end)
        obj = ok and child or nil
    end
    return obj
end
local function awaitGameLoaded(moduleInst, timeout)
    if not moduleInst or type(getloadedmodules) ~= "function" then return end
    local deadline = tick() + (timeout or 15)
    repeat
        local ok, loaded = pcall(getloadedmodules)
        if ok and type(loaded) == "table" then
            for _, m in ipairs(loaded) do
                if m == moduleInst then return end
            end
        end
        task.wait(0.1)
    until tick() >= deadline
end
local function loadGameModule(root, names)
    local inst = waitModule(root, names)
    awaitGameLoaded(inst, 15)
    return safeRequire(inst)
end

local Rivals = { Ready = false }
local function resolveAll(jobs, timeout)
    local pending = #jobs
    for _, job in ipairs(jobs) do
        task.spawn(function() pcall(job); pending = pending - 1 end)
    end
    local deadline = tick() + (timeout or 25)
    while pending > 0 and tick() < deadline do task.wait() end
    return pending == 0
end

resolveAll({
    function() Rivals.Util      = loadGameModule(ReplicatedStorage, {"Modules","Utility"}) end,
    function() Rivals.Fighter   = loadGameModule(lp.PlayerScripts,  {"Controllers","FighterController"}) end,
    function() Rivals.Enums     = loadGameModule(ReplicatedStorage, {"Modules","EnumLibrary"}) end,
    function() Rivals.Cosmetics = loadGameModule(ReplicatedStorage, {"Modules","CosmeticLibrary"}) end,
    function() Rivals.ItemLib   = loadGameModule(ReplicatedStorage, {"Modules","ItemLibrary"}) end,
})
Rivals.Ready = (Rivals.Util ~= nil and Rivals.Fighter ~= nil)

local Config = {
    GameVisuals = true,
    GVUnlockAll = true,
    GVUnlockWeapons = true,
    GVEveryone = false,
    GVBirthHook = true,
    GVFinisherClone = true,
}

local GameVisuals = {}
local M = { cvm=nil, ci=nil, pdc=nil, fctrl=nil, ilib=nil, cent=nil, cslot=nil, copts=nil, shop=nil }

local function moduleAt(path)
    local m = nil
    pcall(function() m = loadGameModule(lp.PlayerScripts, path) end)
    return m
end
local function repModuleAt(path)
    local m = nil
    pcall(function() m = loadGameModule(ReplicatedStorage, path) end)
    return m
end

local _resolving, _resolveAt, _optTries = false, 0, 0
local function resolveModules()
    if M.cvm ~= nil and M.ci ~= nil and M.pdc ~= nil and _optTries >= 3 then return end
    if _resolving then return end
    local now = tick()
    if now < _resolveAt then return end
    _resolveAt = now + 5
    _resolving = true
    if M.cvm == nil then
        M.cvm = moduleAt({"Modules","ClientReplicatedClasses","ClientFighter","ClientItem","ClientViewModel"})
    end
    if M.ci   == nil then M.ci   = moduleAt({"Modules","ClientReplicatedClasses","ClientFighter","ClientItem"}) end
    if M.cent == nil then M.cent = moduleAt({"Modules","ClientReplicatedClasses","ClientEntity"}) end
    if M.pdc  == nil then M.pdc  = moduleAt({"Controllers","PlayerDataController"}) end
    if _optTries < 3 then
        _optTries = _optTries + 1
        if M.cslot == nil then M.cslot = moduleAt({"Modules","CosmeticSlot"}) end
        if M.copts == nil then
            M.copts = moduleAt({"Modules","UserInterface","Equipment","Interface","Customize","Options"})
        end
        if M.shop  == nil then M.shop  = repModuleAt({"Modules","ShopLibrary"}) end
        if M.seasonLib == nil then M.seasonLib = repModuleAt({"Modules","SeasonLibrary"}) end
        if M.emoteCtl == nil then M.emoteCtl = moduleAt({"Controllers","EmoteController"}) end
    end
    if M.fctrl == nil then M.fctrl = Rivals.Fighter end
    if M.ilib  == nil then M.ilib  = Rivals.ItemLib end
    _resolving = false
end

local NONE_COSMETIC   = "NONE_COSMETIC"
local RANDOM_COSMETIC = "RANDOM_COSMETIC"
local REBUILD_COOLDOWN = 1.5
local captureInstall, captureRestore
local saveSoon, saveDrain

local _log = {}
local function note(msg)
    if #_log > 50 then table.remove(_log, 1) end
    table.insert(_log, msg)
end

local ENUM = {}
local function enumOf(key)
    if ENUM[key] ~= nil then return ENUM[key] end
    local e = nil
    pcall(function() e = Rivals.Enums:ToEnum(key) end)
    ENUM[key] = e
    return e
end

GameVisuals.Choices = {}
local function selectionFor(itemName) return GameVisuals.Choices[itemName] end
local _maskTarget, _maskInner, _maskConn = nil, nil, nil
local _spoof = {}
local _favOverride = {}
local _rsPatch, _captured, _captureBound = {}, 0, 0
local DECOY, _lastFn = nil, nil

local function maskActive()
    if _maskTarget == nil then return false end
    local cur = nil
    pcall(function() cur = M.pdc.CurrentData end)
    return cur == _maskTarget
end
local function maskRemove()
    if _maskTarget == nil then return end
    local target, inner = _maskTarget, _maskInner
    _maskTarget, _maskInner = nil, nil
    pcall(function() rawset(target, "Data", inner) end)
end
local function maskInstall()
    resolveModules()
    if M.pdc == nil then return false, "PlayerDataController did not resolve" end
    local cur = nil
    pcall(function() cur = M.pdc.CurrentData end)
    if cur == nil then return false, "no CurrentData yet (still loading)" end
    if cur == _maskTarget then return true, nil end
    maskRemove()
    local inner = rawget(cur, "Data")
    if type(inner) ~= "table" then return false, "CurrentData.Data is not a table" end
    local proxy = setmetatable({}, {
        __index = function(_, k)
            local p = _spoof[k]
            if p ~= nil then return p(inner[k]) end
            return inner[k]
        end,
        __newindex = function(_, k, v) inner[k] = v end,
        __iter = function() return next, inner end,
        __len  = function() return #inner end,
    })
    rawset(cur, "Data", proxy)
    _maskTarget, _maskInner = cur, inner
    return true, nil
end
local function refresh(key)
    pcall(function()
        local cur = M.pdc.CurrentData
        if cur ~= nil then cur:Replicate(key) end
    end)
end
local function refreshAll()
    refresh("CosmeticInventory"); refresh("FavoritedCosmetics")
    refresh("WeaponInventory"); refresh("EquippedEmotes")
end
local function everyCosmetic(real)
    local out = {}
    if type(real) == "table" then for k, v in pairs(real) do out[k] = v end end
    pcall(function()
        local cos = Rivals.Cosmetics.Cosmetics
        if type(cos) ~= "table" then return end
        for name in pairs(cos) do if out[name] == nil then out[name] = true end end
    end)
    return out
end
local function everyFavorite(real)
    local out = {}
    if type(real) == "table" then for k, v in pairs(real) do out[k] = v end end
    for weapon, marks in pairs(_favOverride) do
        local merged = {}
        if type(out[weapon]) == "table" then for k, v in pairs(out[weapon]) do merged[k] = v end end
        for k, v in pairs(marks) do merged[k] = v end
        out[weapon] = merged
    end
    return out
end
local function mergeChoices(entry, weapon)
    local slot = GameVisuals.Choices[weapon]
    if slot == nil then return entry end
    for _, kind in pairs({ "Skin", "Charm", "Wrap", "Finisher" }) do
        local sel = slot[kind]
        if sel ~= nil then entry[kind] = sel end
    end
    return entry
end
local function ownableWeapons()
    local out = {}
    pcall(function()
        if M.shop == nil or type(M.shop.GetReleasedOwnableWeapons) ~= "function" then return end
        local list = M.shop:GetReleasedOwnableWeapons()
        if type(list) ~= "table" then return end
        for _, name in pairs(list) do
            if type(name) == "string" then table.insert(out, name) end
        end
    end)
    return out
end
local function weaponInventory(real)
    local out, seen = {}, {}
    if type(real) == "table" then
        for i, entry in pairs(real) do
            if type(entry) == "table" then
                local copy = {}
                for k, v in pairs(entry) do copy[k] = v end
                if type(copy.Name) == "string" then
                    seen[copy.Name] = true
                    mergeChoices(copy, copy.Name)
                end
                out[i] = copy
            else out[i] = entry end
        end
    end
    if Config.GVUnlockWeapons == true then
        for _, wname in pairs(ownableWeapons()) do
            if not seen[wname] then
                seen[wname] = true
                table.insert(out, mergeChoices({ Name = wname, Level = 1, XP = 0, IsFavorited = false }, wname))
            end
        end
    end
    return out
end
local function applyMaskFields()
    if Config.GVUnlockAll == true then _spoof.CosmeticInventory = everyCosmetic
    else _spoof.CosmeticInventory = nil end
    if Config.GVUnlockAll == true or next(_favOverride) ~= nil then
        _spoof.FavoritedCosmetics = everyFavorite
    else _spoof.FavoritedCosmetics = nil end
    if next(GameVisuals.Choices) ~= nil or Config.GVUnlockWeapons == true then
        _spoof.WeaponInventory = weaponInventory
    else _spoof.WeaponInventory = nil end
end
local function maskNeeded()
    return Config.GVUnlockAll == true or Config.GVUnlockWeapons == true
        or next(GameVisuals.Choices) ~= nil or next(_favOverride) ~= nil
end
local function watchPlayerData()
    if _maskConn ~= nil then return end
    pcall(function()
        local sig = M.pdc.PlayerDataAdded
        if sig == nil then return end
        _maskConn = sig:Connect(function()
            if not maskNeeded() then return end
            task.defer(function()
                if maskInstall() then applyMaskFields(); refreshAll() end
            end)
        end)
    end)
end
local function syncMask()
    applyMaskFields()
    if not maskNeeded() then maskRemove(); refreshAll(); return true, nil end
    local ok, why = maskInstall()
    if not ok then return false, why end
    watchPlayerData(); refreshAll(); return true, nil
end

function GameVisuals.setUnlockAll(on)
    Config.GVUnlockAll = (on == true)
    local ok, why = syncMask()
    if ok then note("unlock all " .. tostring(Config.GVUnlockAll))
    else note("unlock all: " .. tostring(why)) end
end
function GameVisuals.setUnlockWeapons(on)
    Config.GVUnlockWeapons = (on == true)
    local ok, why = syncMask()
    if ok then note("unlock weapons " .. tostring(Config.GVUnlockWeapons))
    else note("unlock weapons: " .. tostring(why)) end
end

local function cloneCosmetic(name, ctype, inverted)
    local base = nil
    pcall(function() base = Rivals.Cosmetics.Cosmetics[name] end)
    if type(base) ~= "table" then return nil end
    local data = {}
    for k, v in pairs(base) do data[k] = v end
    data.Name = name
    if data.Type == nil then data.Type = ctype end
    data.Seed = math.random(1, 1000000)
    local id = enumOf(name)
    if id ~= nil then data.Enum = id; data.ObjectID = id end
    if inverted == true then data.Inverted = true end
    return data
end

local function randomCosmetic(ctype, weapon, inverted)
    local pool = {}
    pcall(function()
        local cos = Rivals.Cosmetics.Cosmetics
        local inv = M.pdc and M.pdc:Get("CosmeticInventory")
        if type(cos) ~= "table" then return end
        for name, entry in pairs(cos) do
            if type(entry) == "table" and entry.Type == ctype and entry.Hidden ~= true then
                local owned = true
                pcall(function() owned = Rivals.Cosmetics:OwnsCosmetic(inv, name, weapon) and true or false end)
                if owned and (ctype ~= "Skin" or entry.ItemName == weapon) then
                    table.insert(pool, name)
                end
            end
        end
    end)
    if #pool == 0 then return nil end
    return cloneCosmetic(pool[math.random(#pool)], ctype, inverted)
end

local function resolveSel(weapon, ctype)
    local slot = GameVisuals.Choices[weapon]
    local sel = slot and slot[ctype]
    if sel == nil then return nil end
    if sel.Name == NONE_COSMETIC then return nil end
    if sel.Name == RANDOM_COSMETIC then
        if sel.Resolved == nil then
            sel.Resolved = randomCosmetic(ctype, weapon, sel.Inverted)
        end
        return sel.Resolved
    end
    return sel
end

local function hasIntent(weapon, ctype)
    local slot = GameVisuals.Choices[weapon]
    return slot ~= nil and slot[ctype] ~= nil
end

local function buildPayload(weapon, dst, key)
    if hasIntent(weapon, "Skin") then
        local s = resolveSel(weapon, "Skin")
        dst[key("Name")] = (s ~= nil) and s.Name or weapon
    end
    if hasIntent(weapon, "Wrap") then dst[key("Wrap")] = resolveSel(weapon, "Wrap") end
    if hasIntent(weapon, "Charm") then dst[key("Charm")] = resolveSel(weapon, "Charm") end
    return dst
end
local function identityKey(k) return k end
local HOOKS = {}

local function hookField(tbl, key, make)
    if tbl == nil then return false end
    local orig = nil
    pcall(function() orig = tbl[key] end)
    if type(orig) ~= "function" then return false end
    for _, h in pairs(HOOKS) do if h.tbl == tbl and h.key == key then return true end end
    local inherited = false
    pcall(function() inherited = (rawget(tbl, key) == nil) end)
    local ok = false
    pcall(function() tbl[key] = make(orig); ok = true end)
    if not ok then return false end
    table.insert(HOOKS, { tbl = tbl, key = key, orig = orig, inherited = inherited })
    return true
end
local function hooksRestore()
    for i = #HOOKS, 1, -1 do
        local h = HOOKS[i]
        pcall(function()
            if h.inherited then h.tbl[h.key] = nil
            else h.tbl[h.key] = h.orig end
        end)
        HOOKS[i] = nil
    end
end
local function origOf(tbl, key)
    if tbl == nil then return nil end
    for _, h in pairs(HOOKS) do
        if h.tbl == tbl and h.key == key then return h.orig end
    end
    local fn = nil
    pcall(function() fn = tbl[key] end)
    return fn
end
local function ownedByUs(item)
    local owner = nil
    pcall(function() owner = item.ClientFighter.Player end)
    if owner == lp then return true end
    if Config.GVEveryone == true and owner ~= nil then return true end
    return false
end
local function enumKey(k)
    local e = enumOf(k)
    if e ~= nil then return e end
    return k
end
local function styleSerial(serial, weapon)
    if type(serial) ~= "table" or type(weapon) ~= "string" then return false end
    if selectionFor(weapon) == nil then return false end
    local touched = false
    pcall(function()
        local dk = enumOf("Data")
        local slot = nil
        if dk ~= nil and type(serial[dk]) == "table" then slot = serial[dk]
        elseif type(serial.Data) == "table" then slot = serial.Data end
        if slot == nil then return end
        buildPayload(weapon, slot, enumKey)
        touched = true
    end)
    return touched
end

local _building = nil
local _oidWeapon, _oidAt = {}, 0
local function atIdentity2(fn)
    local prev = 8
    if getthreadidentity ~= nil then pcall(function() prev = getthreadidentity() end) end
    local setter = setthreadidentity
    if setter == nil then setter = setidentity end
    if setter ~= nil then pcall(setter, 2) end
    local ok, err = pcall(fn)
    if setter ~= nil then pcall(setter, prev) end
    return ok, err
end
local FINISHER_FOLDER = nil
local function finisherFolder()
    if FINISHER_FOLDER == nil then
        pcall(function() FINISHER_FOLDER = ReplicatedStorage.Modules.Finishers end)
    end
    return FINISHER_FOLDER
end
local function cloneCharacter(model)
    local copy = nil
    pcall(function()
        local was = model.Archivable
        model.Archivable = true
        copy = model:Clone()
        model.Archivable = was
    end)
    return copy
end
local function hideCorpse(model)
    pcall(function()
        for _, d in pairs(model:GetDescendants()) do
            if d:IsA("BasePart") then d.Transparency = 1
            elseif d:IsA("Decal") then d:Destroy()
            elseif d:IsA("BillboardGui") then d.Enabled = false end
        end
    end)
end
local _finisherCopies = setmetatable({}, { __mode = "k" })
local function playFinisherOnClone(ent, model, mod, isFinal, killer, serial)
    local copy = cloneCharacter(model)
    if copy == nil then return false end
    local hum, root = nil, nil
    pcall(function()
        hum  = copy:FindFirstChildOfClass("Humanoid")
        root = copy:FindFirstChild("HumanoidRootPart")
    end)
    if hum == nil or root == nil then pcall(function() copy:Destroy() end); return false end
    hideCorpse(model)
    pcall(function()
        for _, d in pairs(copy:GetDescendants()) do
            if d:IsA("BillboardGui") or d:IsA("SurfaceGui") or d:IsA("Highlight") then d:Destroy() end
        end
    end)
    local ok = false
    pcall(function()
        root.AssemblyLinearVelocity = Vector3.zero
        hum.Health = 0
        local parts = {}
        for _, c in pairs(copy:GetChildren()) do
            if c:IsA("BasePart") then
                pcall(function() c.CollisionGroup = "Players" end)
                table.insert(parts, c)
            end
        end
        for i = 1, #parts do
            for j = i + 1, #parts do
                local nc = Instance.new("NoCollisionConstraint")
                nc.Part0 = parts[i]; nc.Part1 = parts[j]; nc.Parent = parts[i]
            end
        end
        copy:PivotTo(model:GetPivot())
        copy.Parent = model.Parent
        ok = true
    end)
    if not ok then pcall(function() copy:Destroy() end); return false end
    pcall(function()
        model.Destroying:Once(function()
            if copy.Parent ~= nil then copy:Destroy() end
        end)
    end)
    local prevCopy = rawget(_finisherCopies, ent)
    if prevCopy ~= nil and prevCopy ~= copy and prevCopy.Parent ~= nil then
        pcall(function() prevCopy:Destroy() end)
    end
    rawset(_finisherCopies, ent, copy)
    local fin = nil
    atIdentity2(function()
        local prev = rawget(ent, "_current_finisher")
        if prev ~= nil then pcall(prev.Destroy, prev) end
        fin = mod.new(hum, isFinal, killer)
        rawset(ent, "_current_finisher", fin)
        fin:SetSerial(serial)
        task.spawn(function() pcall(fin.PlayServer, fin) end)
        task.spawn(function() pcall(fin.PlayClient, fin) end)
    end)
    if fin == nil then pcall(function() copy:Destroy() end); return false end
    return true
end

local function hooksInstall()
    resolveModules()
    if Config.GVBirthHook == false then return false, "birth hook disabled in config" end
    local n = 0
    if hookField(M.ci, "_CreateViewModel", function(orig)
        return function(item, serial)
            local weapon = nil
            pcall(function() weapon = item.Name end)
            local mine = ownedByUs(item)
            _building = mine and weapon or nil
            if mine and weapon ~= nil then pcall(styleSerial, serial, weapon) end
            local ok, res = pcall(orig, item, serial)
            _building = nil
            if not ok then error(res, 0) end
            return res
        end
    end) then n = n + 1 end
    if hookField(M.cvm, "new", function(orig)
        return function(serial, item)
            local weapon = _building
            if weapon == nil and item ~= nil then
                pcall(function() if ownedByUs(item) then weapon = item.Name end end)
            end
            if weapon ~= nil then pcall(styleSerial, serial, weapon) end
            local vm = orig(serial, item)
            if vm ~= nil and weapon ~= nil and resolveSel(weapon, "Wrap") ~= nil then
                local upd = nil
                pcall(function() upd = M.cvm._UpdateWrap end)
                if type(upd) == "function" then
                    task.spawn(function()
                        pcall(upd, vm)
                        task.wait(0.1)
                        if rawget(vm, "_destroyed") ~= true then pcall(upd, vm) end
                    end)
                end
            end
            return vm
        end
    end) then n = n + 1 end
    if hookField(M.cvm, "GetWrap", function(orig)
        return function(vm)
            local weapon, mine = nil, false
            pcall(function()
                local item = vm.ClientItem
                weapon = item.Name
                mine = ownedByUs(item)
            end)
            if mine and weapon ~= nil and hasIntent(weapon, "Wrap") then
                return resolveSel(weapon, "Wrap")
            end
            return orig(vm)
        end
    end) then n = n + 1 end
    if hookField(M.fctrl, "GetWrap", function(orig)
        return function(ctrl, oid)
            local res = orig(ctrl, oid)
            if res ~= nil then return res end
            local weapon = _oidWeapon and _oidWeapon[tostring(oid)] or nil
            if weapon == nil then return nil end
            return resolveSel(weapon, "Wrap")
        end
    end) then n = n + 1 end
    if hookField(M.ilib, "GetViewModelImageFromWeaponData", function(orig)
        return function(lib, wdata, hires)
            if type(wdata) == "table" and type(wdata.Name) == "string" then
                local skin = resolveSel(wdata.Name, "Skin")
                if skin ~= nil then
                    local img = nil
                    pcall(function()
                        local info = lib.ViewModels[skin.Name]
                        if info ~= nil then
                            img = hires and info.ImageHighResolution or info.Image
                            if img == nil then img = info.Image end
                        end
                    end)
                    if img ~= nil then return img end
                end
            end
            return orig(lib, wdata, hires)
        end
    end) then n = n + 1 end
    if hookField(M.cent, "ReplicateFromServer", function(orig)
        return function(ent, action, ...)
            if action ~= "FinisherEffect" then return orig(ent, action, ...) end
            local args = { ... }
            local killer = args[3]
            local isUs = false
            pcall(function()
                if typeof(killer) == "Instance" then isUs = (killer == lp)
                elseif type(killer) == "number" then isUs = (killer == lp.UserId)
                elseif type(killer) == "string" then isUs = (killer:lower() == lp.Name:lower()) end
            end)
            if not isUs then return orig(ent, action, ...) end
            local held = nil
            pcall(function()
                local lf = Rivals.Fighter and Rivals.Fighter.LocalFighter
                local it = lf and lf.EquippedItem
                if it ~= nil then held = it.Name end
            end)
            local fin, weapon = nil, nil
            local atkW = GameVisuals.lastWeapon
            for _, w in pairs({ atkW, held }) do
                if fin == nil and type(w) == "string" then
                    fin = resolveSel(w, "Finisher")
                    if fin ~= nil then weapon = w end
                end
            end
            if fin == nil then
                for w in pairs(GameVisuals.Choices) do
                    if fin == nil then
                        fin = resolveSel(w, "Finisher")
                        if fin ~= nil then weapon = w end
                    end
                end
            end
            if fin == nil then return orig(ent, action, ...) end
            local rendered = false
            pcall(function() rendered = ent:IsRendered() end)
            if not rendered then return orig(ent, action, ...) end
            local mod, model = nil, nil
            pcall(function()
                local folder = finisherFolder()
                local node = folder and folder:FindFirstChild(tostring(fin.Name)) or nil
                if node ~= nil then atIdentity2(function() mod = require(node) end) end
                model = rawget(ent, "Model")
            end)
            if type(mod) ~= "table" or type(mod.new) ~= "function" or model == nil then
                return orig(ent, action, ...)
            end
            if Config.GVFinisherClone == false then return orig(ent, action, ...) end
            if playFinisherOnClone(ent, model, mod, args[2], args[3], args[4]) then return end
            return orig(ent, action, ...)
        end
    end) then n = n + 1 end
    if n == 0 then return false, "no hook target resolved" end
    return true, n
end

local function rebuildOidMap()
    local now = tick()
    if now < _oidAt then return end
    _oidAt = now + 5
    pcall(function()
        local f = Rivals.Fighter:GetFighter(lp)
        if f == nil or type(f.Items) ~= "table" then return end
        for _, item in pairs(f.Items) do
            local oid = nil
            pcall(function() oid = item:Get("ObjectID") end)
            if oid ~= nil then _oidWeapon[tostring(oid)] = item.Name end
        end
    end)
end

local _rebuildAt = setmetatable({}, { __mode = "k" })
local _forceRebuild = false
local _rebuildFails = setmetatable({}, { __mode = "k" })
local _rebuildSeen  = setmetatable({}, { __mode = "k" })

local function liveTriple(vm)
    local name, charm, wrap = nil, nil, nil
    pcall(function()
        local src = rawget(vm, "Data")
        if type(src) ~= "table" then return end
        name = src.Name; charm = src.Charm; wrap = src.Wrap
    end)
    return name, charm, wrap
end
local function sameSub(a, b)
    if a == nil and b == nil then return true end
    if a == nil or b == nil then return false end
    return a.Name == b.Name
end
local INTENT_OF = { Name = "Skin", Charm = "Charm", Wrap = "Wrap" }
local function wants(base, dataKey) return hasIntent(base, INTENT_OF[dataKey]) end
local function rebuildPayload(base, vm)
    local liveName, liveCharm, liveWrap = liveTriple(vm)
    local raw = {}
    if hasIntent(base, "Skin") then
        local s = resolveSel(base, "Skin")
        raw[enumKey("Name")] = (s ~= nil) and s.Name or base
    else raw[enumKey("Name")] = liveName or base end
    if hasIntent(base, "Charm") then
        raw[enumKey("Charm")] = resolveSel(base, "Charm")
    else raw[enumKey("Charm")] = liveCharm end
    if hasIntent(base, "Wrap") then
        raw[enumKey("Wrap")] = resolveSel(base, "Wrap")
    else raw[enumKey("Wrap")] = liveWrap end
    return raw
end
local function payloadKeysAreEnums(raw)
    for _, k in pairs({ "Name", "Charm", "Wrap" }) do
        if rawget(raw, k) ~= nil and enumOf(k) ~= k then return false, k end
    end
    return true, nil
end
local function adoptViewModel(item, fresh, arms)
    pcall(function() rawset(item, "ViewModel", fresh) end)
    if arms ~= nil then
        atIdentity2(function() M.cvm.SetArmsData(fresh, table.unpack(arms, 1, arms.n)) end)
    end
    atIdentity2(function() M.cvm.Equip(fresh, true) end)
end
local function usableReplacement(fresh, vm)
    if fresh == nil or fresh == vm then return false end
    local ok = false
    pcall(function()
        ok = (rawget(fresh, "_destroyed") ~= true) and (rawget(fresh, "Model") ~= nil)
    end)
    return ok
end
local function tryBuild(create, item, serial, vm)
    local fresh = nil
    atIdentity2(function() fresh = create(item, serial) end)
    if fresh == nil then pcall(function() fresh = rawget(item, "ViewModel") end) end
    if usableReplacement(fresh, vm) then return fresh end
    return nil
end
local function dropViewModel(drop, vm)
    pcall(function()
        if rawget(vm, "_destroyed") ~= true then atIdentity2(function() drop(vm) end) end
    end)
end
local function armsDataOf(item)
    local packed = nil
    pcall(function()
        local f = item.ClientFighter
        if f == nil then return end
        local get = f.GetArmsData
        if type(get) ~= "function" then return end
        packed = table.pack(get(f))
    end)
    return packed
end
local function rebuildViewModel(item, base, vm)
    if Config.GVBirthHook == false then return false, "style at construction is off", false end
    local now = tick()
    if not _forceRebuild and now < (_rebuildAt[item] or 0) then return false, nil, true end
    local fails = _rebuildFails[item]
    if not _forceRebuild and fails ~= nil and fails >= 3 and _rebuildSeen[item] == vm then
        return false, "constructor keeps refusing", false
    end
    local create = origOf(M.ci, "_CreateViewModel")
    if type(create) ~= "function" then return false, "_CreateViewModel missing", false end
    local drop = nil
    pcall(function() drop = M.cvm.Destroy end)
    if type(drop) ~= "function" then return false, "Destroy missing", false end
    local equip = nil
    pcall(function() equip = M.cvm.Equip end)
    if type(equip) ~= "function" then return false, "Equip missing", false end
    local raw = rebuildPayload(base, vm)
    local keysOk, badKey = payloadKeysAreEnums(raw)
    if not keysOk then return false, "no enum for '" .. tostring(badKey) .. "'", false end
    _rebuildAt[item] = now + REBUILD_COOLDOWN
    local arms = armsDataOf(item)
    local serial = { Data = raw }
    local prevField = nil
    pcall(function() prevField = rawget(item, "ViewModel") end)
    pcall(function() rawset(item, "ViewModel", nil) end)
    local fresh = tryBuild(create, item, serial, vm)
    if fresh ~= nil then
        adoptViewModel(item, fresh, arms)
        dropViewModel(drop, vm)
        _rebuildFails[item] = nil; _rebuildSeen[item] = nil
        return true, nil, false
    end
    pcall(function() rawset(item, "ViewModel", prevField) end)
    _rebuildFails[item] = (fails or 0) + 1
    _rebuildSeen[item] = vm
    return false, "constructor refused", false
end
local function writeData(obj, raw, base)
    if obj == nil then return false end
    local wrote = false
    for _, key in pairs({ "Name", "Charm", "Wrap" }) do
        if wants(base, key) then
            local ok = false
            pcall(function() obj:SetReplicate(key, raw[key]); ok = true end)
            if not ok then
                pcall(function()
                    local d = rawget(obj, "Data")
                    if type(d) == "table" then d[key] = raw[key]; ok = true end
                end)
            end
            if ok then wrote = true end
        end
    end
    return wrote
end
local function applyWrapLive(vm, wrap)
    local data = nil
    pcall(function() data = rawget(vm, "Data") end)
    if type(data) ~= "table" then return false end
    local upd = nil
    pcall(function() upd = M.cvm._UpdateWrap end)
    if type(upd) ~= "function" then return false end
    rawset(data, "Wrap", wrap)
    atIdentity2(function() upd(vm) end)
    return true
end
local function applyToItem(item, base)
    local vm = nil
    pcall(function() vm = item.ViewModel end)
    if vm == nil then return false end
    local sel = selectionFor(base)
    if sel == nil then return true end
    local curName, curCharm, curWrap = liveTriple(vm)
    if curName == nil then return false end
    local raw = buildPayload(base, { Name = base }, identityKey)
    if raw == nil then raw = { Name = base } end
    if wants(base, "Wrap") and not sameSub(curWrap, raw.Wrap) then
        applyWrapLive(vm, raw.Wrap)
    end
    local needName  = wants(base, "Name")  and curName ~= raw.Name
    local needCharm = wants(base, "Charm") and not sameSub(curCharm, raw.Charm)
    if not needName and not needCharm then return true end
    local rok, rwhy, transient = rebuildViewModel(item, base, vm)
    writeData(item, raw, base)
    if transient ~= true then
        local nowVm = nil
        pcall(function() nowVm = item.ViewModel end)
        writeData(nowVm or vm, raw, base)
    end
    return true
end
local function itemsOf(player)
    local items = nil
    pcall(function()
        local f = Rivals.Fighter:GetFighter(player)
        if f ~= nil and type(f.Items) == "table" then items = f.Items end
    end)
    if items == nil then
        pcall(function()
            local map = Rivals.Fighter._player_to_fighter
            local f = map and map[player]
            if f ~= nil and type(f.Items) == "table" then items = f.Items end
        end)
    end
    return items
end
local function applyToPlayer(player)
    local items = itemsOf(player)
    if items == nil then return 0 end
    local n = 0
    for _, item in pairs(items) do
        if type(item) == "table" then
            local base = nil
            pcall(function() base = item.Name end)
            if type(base) == "string" and selectionFor(base) ~= nil then
                if applyToItem(item, base) then n = n + 1 end
            end
        end
    end
    return n
end

function GameVisuals.apply()
    if Config.GameVisuals ~= true then return 0 end
    resolveModules(); rebuildOidMap()
    local n = applyToPlayer(lp)
    if Config.GVEveryone == true then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp then n = n + applyToPlayer(p) end
        end
    end
    return n
end

local function noneSlot()
    return { Skin = { Name = NONE_COSMETIC }, Charm = { Name = NONE_COSMETIC },
             Wrap = { Name = NONE_COSMETIC }, Finisher = { Name = NONE_COSMETIC } }
end

function GameVisuals.restore()
    for weapon in pairs(GameVisuals.Choices) do GameVisuals.Choices[weapon] = noneSlot() end
    _forceRebuild = true
    pcall(GameVisuals.apply)
    _forceRebuild = false
    GameVisuals.Choices = {}
    pcall(syncMask)
end

local _conn, _last, _loaded = nil, 0, false
function GameVisuals.enable()
    Config.GameVisuals = true
    resolveModules()
    hooksInstall()
    syncMask()
    if _conn ~= nil then return end
    _conn = RunService.Heartbeat:Connect(function()
        if Config.GameVisuals ~= true then return end
        local now = tick()
        if now - _last < 0.35 then return end
        _last = now
        if #HOOKS == 0 and Config.GVBirthHook ~= false then pcall(hooksInstall) end
        if _captureBound < 2 and Config.GVBirthHook ~= false then pcall(captureInstall) end
        if maskNeeded() and not maskActive() then pcall(syncMask) end
        pcall(GameVisuals.apply)
    end)
end

function GameVisuals.disable()
    Config.GameVisuals = false
    _loaded = false
    if _conn ~= nil then _conn:Disconnect(); _conn = nil end
    if _maskConn ~= nil then pcall(function() _maskConn:Disconnect() end); _maskConn = nil end
    captureRestore()
    for weapon in pairs(GameVisuals.Choices) do GameVisuals.Choices[weapon] = noneSlot() end
    _forceRebuild = true
    pcall(applyToPlayer, lp)
    _forceRebuild = false
    GameVisuals.Choices = {}
    hooksRestore()
    _favOverride = {}
    _spoof.CosmeticInventory  = nil
    _spoof.FavoritedCosmetics = nil
    _spoof.WeaponInventory    = nil
    maskRemove()
end

local _weapon = nil
GameVisuals.lastWeapon = nil
function GameVisuals.setWeapon(name)
    if name == nil or name == "None" then _weapon = nil else _weapon = name end
    GameVisuals.lastWeapon = _weapon
end

local function heldItemName()
    local base = nil
    pcall(function()
        local lf = Rivals.Fighter and Rivals.Fighter.LocalFighter
        local it = lf and lf.EquippedItem
        if it ~= nil then base = it.Name end
    end)
    if type(base) == "string" then return base end
    return _weapon
end

function GameVisuals.setFor(weapon, kind, name, inverted)
    if type(weapon) ~= "string" or type(kind) ~= "string" then return end
    local slot = GameVisuals.Choices[weapon]
    if slot == nil then slot = {}; GameVisuals.Choices[weapon] = slot end
    if name == nil or name == "None" or name == NONE_COSMETIC then
        slot[kind] = { Name = NONE_COSMETIC }
    elseif name == "Random" or name == RANDOM_COSMETIC then
        slot[kind] = { Name = RANDOM_COSMETIC, Type = kind, Inverted = inverted == true }
    else
        local rec = cloneCosmetic(name, kind, inverted)
        if rec == nil then return end
        slot[kind] = rec
    end
    GameVisuals.lastWeapon = weapon
    pcall(syncMask)
    pcall(GameVisuals.apply)
end

function GameVisuals.setSkin(label)
    if label == nil or label == "None" then
        if _weapon ~= nil then GameVisuals.setFor(_weapon, "Skin", nil) end
        return
    end
    if label == "Random" then
        local w = _weapon or heldItemName()
        if w == nil then return end
        GameVisuals.setFor(w, "Skin", "Random")
        return
    end
    local item = string.match(label, "^(.-) %| ")
    local skin = string.match(label, " | (.*)$") or label
    if item then
        GameVisuals.setFor(item, "Skin", skin)
    end
end

function GameVisuals.setOn(kind, name)
    local base = _weapon or heldItemName()
    if base == nil then return end
    GameVisuals.setFor(base, kind, name, false)
end
function GameVisuals.setCharm(name)    GameVisuals.setOn("Charm", name)    end
function GameVisuals.setWrap(name)     GameVisuals.setOn("Wrap", name)     end
function GameVisuals.setFinisher(name) GameVisuals.setOn("Finisher", name) end

-- =========================================================
-- PUBLIC API & INIT
-- =========================================================
_G["EclipseCosmetics"] = {
    Config = Config,
    GameVisuals = GameVisuals,
    enable = function() GameVisuals.enable() end,
    disable = function() GameVisuals.disable() end,
    setSkin = function(weapon, skin) GameVisuals.setFor(weapon, "Skin", skin) end,
    setWrap = function(weapon, wrap) GameVisuals.setFor(weapon, "Wrap", wrap) end,
    setCharm = function(weapon, charm) GameVisuals.setFor(weapon, "Charm", charm) end,
    setFinisher = function(weapon, finisher) GameVisuals.setFor(weapon, "Finisher", finisher) end,
    unlockAll = function(on) GameVisuals.setUnlockAll(on) end,
    unlockWeapons = function(on) GameVisuals.setUnlockWeapons(on) end,
}

GameVisuals.enable()