local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Modules = require(ReplicatedStorage:WaitForChild("Modules"))
local CONSTANTS = require(Modules:WaitForChild("CONSTANTS"))
local utility = require(Modules:WaitForChild("utility"))
local ClientFighter = require(LocalPlayer.PlayerScripts.Controllers.ClientFighter)

local Remotes = require(ReplicatedStorage:WaitForChild("Remotes"))
local Replication = Remotes:WaitForChild("Replication")
local FighterRemote = Remotes:WaitForChild("Fighter")
local UseItemRemote = FighterRemote:WaitForChild("UseItem")

local IS_PRIVATE_SERVER = game.PlaceId == CONSTANTS.IS_PRIVATE_SERVER

local Ragebot = {}
Ragebot.__index = Ragebot

local function randomUnitVector()
    return Random.new():NextUnitVector()
end

local function generateGUID()
    return HttpService:GenerateGUID(false)
end

function Ragebot.new()
    local self = setmetatable({}, Ragebot)

    self.characters = {}
    self.duelCache = {}
    self.priorities = {}
    self.voidedPlayers = {}

    self.attackNum = 0
    self.heavyAttackNum = 0
    self.reloadCooldown = 0
    self.lastAttack = 0
    self.attackThread = nil
    self.reloadThreads = {}

    self.desync = {
        enabled = false,
        pitch = 0,
        yaw = 0,
        customPitch = 0,
        customYaw = 0,
        floorHide = false,
        physicsRep = nil,
    }

    self.status = {
        enabled = false,
        text = "",
        weapon = nil,
    }

    self.events = {
        force_cframe_change = Instance.new("BindableEvent"),
        ragebot_status = Instance.new("BindableEvent"),
    }

    self:trackCharacters()
    self:setupValidation()
    self:setupAntiAim()
    self:setupVoidPosition()
    self:setupVoidSpam()
    self:setupPriorityTargeting()
    self:setupIndicator()

    RunService.RenderStepped:Connect(function()
        if not Toggles.ragebot_enabled.Value then
            self.status.enabled = false
            return
        end
        self.status.enabled = true
    end)

    RunService.Heartbeat:Connect(function()
        if Toggles.ragebot_enabled.Value and Toggles.ragebot_void_spam.Value then
            if self.attackThread and coroutine.status(self.attackThread) ~= "dead" then
                return
            end
            self.attackThread = task.spawn(function()
                self:voidLoop()
            end)
        end
    end)

    return self
end

function Ragebot:trackCharacters()
    local function add(plr, char)
        self.characters[plr] = char
        self.duelCache[plr] = cloneref(char)
    end
    local function remove(plr)
        self.characters[plr] = nil
        self.duelCache[plr] = nil
        self.priorities[plr] = nil
        self.voidedPlayers[plr] = nil
    end
    local function hook(plr)
        if plr.Character then add(plr, plr.Character) end
        plr.CharacterAdded:Connect(function(char) add(plr, char) end)
        plr.CharacterRemoving:Connect(function() remove(plr) end)
    end
    for _, plr in ipairs(Players:GetPlayers()) do hook(plr) end
    Players.PlayerAdded:Connect(hook)
end

function Ragebot:setupValidation()
    local function hasFlag(char, name)
        local flag = char and char:FindFirstChild(name)
        return flag ~= nil
    end

    function self:isAlly(char)
        local flag = char and char:FindFirstChild("_is_ally")
        return flag ~= nil and flag.Value == true
    end

    function self:isAlive(char)
        local hum = char and char:FindFirstChild("Humanoid")
        return hum ~= nil and hum.Health > 0
    end

    function self:getClientFighter(char)
        local client = char and char:FindFirstChild("ClientFighter")
        return client or (char and char:GetAttribute("client_fighter"))
    end

    function self:getHitbox(char)
        local head = char and (char:FindFirstChild("HitboxHead") or char:FindFirstChild("Head"))
        return head or (char and char:FindFirstChild("HumanoidRootPart"))
    end

    function self:validateTarget(char)
        if not char then return false end
        if self:isAlly(char) then return false end
        if not self:isAlive(char) then return false end
        if not self:getClientFighter(char) then return false end
        if not hasFlag(char, "Health") then return false end
        return true
    end
end

function Ragebot:setupAntiAim()
    local self = self

    function self:applyDesync(cframe, hrp, rep)
        if rep then
            rep.CFrame = cframe
        end
        if hrp then
            self.events.force_cframe_change:Fire(hrp, cframe)
        end
    end

    function self:unbindAntiAim()
        pcall(function()
            RunService:UnbindFromRenderStep("RagebotAntiAim")
        end)
    end

    function self:desyncCFrame(hrp)
        local base = hrp.CFrame
        local yaw = math.rad(self.desync.yaw)
        local pitch = math.rad(self.desync.pitch)
        local customYaw = math.rad(self.desync.customYaw)
        local customPitch = math.rad(self.desync.customPitch)
        return CFrame.new(base.Position)
            * CFrame.Angles(0, yaw + customYaw, 0)
            * CFrame.Angles(pitch + customPitch, 0, 0)
    end

    RunService:BindToRenderStep("RagebotAntiAim", Enum.RenderPriority.Camera.Value, function()
        if not Toggles.ragebot_enabled.Value then
            self:unbindAntiAim()
            return
        end
        local character = LocalPlayer.Character
        if not character then return end
        local hrp = character:WaitForChild("HumanoidRootPart")
        if not hrp then return end

        self.desync.enabled = Toggles.anti_aim_enabled.Value
        self.desync.pitch = Options.anti_aim_pitch.Value
        self.desync.yaw = Options.anti_aim_yaw.Value
        self.desync.customPitch = Options.anti_aim_custom_pitch.Value
        self.desync.customYaw = Options.anti_aim_custom_yaw.Value
        self.desync.floorHide = Toggles.anti_aim_floor_hide.Value

        local rep = character:FindFirstChild("PhysicsRepRootPart") or hrp
        self.desync.physicsRep = rep

        if not self.desync.enabled then
            rep.CFrame = hrp.CFrame
            return
        end

        if self.desync.floorHide and hrp.Position.Y < 8 then
            self:applyDesync(hrp.CFrame * CFrame.new(0, -3, 0), hrp, rep)
            return
        end

        self:applyDesync(self:desyncCFrame(hrp), hrp, rep)
    end)
end

function Ragebot:setupVoidPosition()
    local self = self
    local cache = {}

    local function collectBarriers()
        local barriers = {}
        local map = workspace:FindFirstChild("Map")
        local barrierFolder = map and map:FindFirstChild("Barriers")
        if barrierFolder then
            for _, part in ipairs(barrierFolder:GetChildren()) do
                if part:IsA("BasePart") then
                    table.insert(barriers, part)
                end
            end
        end
        return barriers
    end

    local function collectSpawns()
        local positions = {}
        local spawns = workspace:FindFirstChild("Spawns")
        if not spawns then return positions end
        for _, obj in ipairs(spawns:GetDescendants()) do
            if obj:IsA("Model") then
                local pos = obj:FindFirstChild("Position")
                if pos and pos:IsA("Vector3Value") then
                    table.insert(positions, pos.Value)
                end
            elseif obj:IsA("BasePart") then
                table.insert(positions, obj.Position)
            end
        end
        return positions
    end

    function self:getVoidPosition()
        local now = tick()
        if cache.expire and now < cache.expire and cache.position then
            return cache.position
        end

        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Whitelist
        params.FilterDescendantsInstances = collectBarriers()
        params.BruteForceAllSlow = true

        local candidates = collectSpawns()
        for _, origin in ipairs(candidates) do
            local from = origin + Vector3.new(0, 2, 0)
            local result = workspace:Raycast(from, Vector3.new(0, -500, 0), params)
            if result then
                local hit = result.Position
                if hit.Y < 0 then
                    cache.position = hit
                    cache.expire = now + 1
                    return hit
                end
            end
        end

        if cache.position then
            return cache.position
        end
        return nil
    end

    function self:voidPositionOrFallback()
        return self:getVoidPosition() or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position)
    end
end

function Ragebot:setupVoidSpam()
    local self = self

    local function getEquippedItem(character)
        return character and character:FindFirstChild("EquippedItem")
    end

    local function getRotationCFrame(part)
        return part and part.CFrame.Rotation or CFrame.new()
    end

    local function getAnimationKeys(item)
        local viewModel = item and item.ViewModel
        return viewModel and viewModel:GetAnimationKeys() or {}
    end

    local function hasRiotShield(character)
        local item = getEquippedItem(character)
        return item and item.Name == "Riot Shield" or false
    end

    local function equipItem(character, itemName)
        return pcall(function()
            local item = getEquippedItem(character)
            if item and item.EquipItem then
                item:EquipItem(itemName)
            end
        end)
    end

    local function fireUseItem(payload)
        return pcall(function()
            UseItemRemote:FireServer(payload)
        end)
    end

    function self:voidSpamMelee(target)
        local myChar = LocalPlayer.Character
        local item = getEquippedItem(myChar)
        if not item then return false end
        if item.Info and item.Info.Type ~= "Melee" then return false end

        local now = tick()
        local cooldown = item.Info and item.Info.HeavyAttackCooldown or 0.2
        if now - self.lastAttack < cooldown then
            return false
        end
        self.lastAttack = now

        self.heavyAttackNum = self.heavyAttackNum + 1

        local hitbox = self:getHitbox(target)
        if not hitbox then return false end

        local aimPos = hitbox.Position + randomUnitVector() * 0.35
        local rotation = getRotationCFrame(hasRiotShield(target) and hitbox or target)

        local ok = fireUseItem({
            id = generateGUID(),
            objectId = HttpService:GenerateGUID(false),
            item = Options.ragebot_weapon.Value,
            position = aimPos,
            heavyAttackNum = self.heavyAttackNum,
            animationKeys = getAnimationKeys(item),
            rotation = rotation,
            one = Vector3.one,
            startAiming = true,
            packed = { "\x00", "\x01", "\x02", "\x03" },
        })

        if ok then
            pcall(function()
                item:StartAiming(aimPos)
            end)
            pcall(function()
                item:HeavyAttack(aimPos)
            end)
            self.status.text = string.format("stabbing %s in %s... (void)", target.Name, tostring(aimPos))
        else
            self.status.text = "void... (backstabbing)"
        end
        return ok
    end

    function self:voidSpamRanged(target)
        local myChar = LocalPlayer.Character
        local item = getEquippedItem(myChar)
        if not item then return false end
        if item.Info and item.Info.Type ~= "Gun" then return false end

        self.attackNum = self.attackNum + 1

        local hitbox = self:getHitbox(target)
        if not hitbox then return false end

        local aimPos = hitbox.Position + randomUnitVector() * 0.5
        local rotation = getRotationCFrame(hasRiotShield(target) and hitbox or target)

        local ok = fireUseItem({
            id = generateGUID(),
            objectId = HttpService:GenerateGUID(false),
            item = Options.ragebot_weapon.Value,
            position = aimPos,
            attackNum = self.attackNum,
            animationKeys = getAnimationKeys(item),
            rotation = rotation,
            one = Vector3.one,
            packed = { "\x00", "\x01", "\x02", "\x03" },
        })

        if ok then
            pcall(function()
                item:StartShooting(aimPos)
            end)
            self.status.text = "void spamming... (attacking " .. target.Name .. ")"
        else
            self.status.text = "void..."
        end
        return ok
    end

    function self:voidLoop()
        if not Toggles.ragebot_enabled.Value then return end
        if not Toggles.ragebot_void_spam.Value then return end

        local myChar = LocalPlayer.Character
        if not myChar then return end

        local item = getEquippedItem(myChar)
        if not item then
            self.status.text = "no usable item(s)... (void)"
            equipItem(myChar, Options.ragebot_weapon.Value)
            return
        end

        local target = self:getPriorityTarget()
        if not target then return end

        local weaponType = item.Info and item.Info.Type
        local data = item.Data
        local ammo = data and data.Ammo
        local reserve = data and data.AmmoReserve
        local now = tick()

        if weaponType == "Gun" then
            if ammo and ammo <= 0 then
                if reserve and reserve > 0 then
                    if now > self.reloadCooldown then
                        self.status.text = "reloading..."
                        pcall(function()
                            item:StartReloading()
                        end)
                        self.reloadCooldown = now + 0.4
                        table.insert(self.reloadThreads, tick())
                    end
                    return
                end
                local settings = Options.ragebot_settings.Value or {}
                if settings["swap weapons when empty"] then
                    equipItem(myChar, Options.ragebot_weapon.Value)
                    self.status.text = "swap weapons when empty"
                end
                return
            end

            if item.Name == "Revolver" then
                self.attackNum = self.attackNum + 1
                local hitbox = self:getHitbox(target)
                local aimPos = hitbox.Position + randomUnitVector() * 0.5
                fireUseItem({
                    id = generateGUID(),
                    item = Options.ragebot_weapon.Value,
                    position = aimPos,
                    attackNum = self.attackNum,
                    animationKeys = getAnimationKeys(item),
                    rotation = getRotationCFrame(hitbox),
                })
                self.status.text = "killing " .. target.Name .. " (Revolver)"
                return
            end

            self:voidSpamRanged(target)
            return
        end

        if weaponType == "Melee" then
            self:voidSpamMelee(target)
            return
        end

        equipItem(myChar, Options.ragebot_weapon.Value)
        self.status.text = "void..."
    end

    RunService.RenderStepped:Connect(function()
        if not Toggles.ragebot_enabled.Value then return end
        if not Toggles.ragebot_void_spam.Value then return end
        local myChar = LocalPlayer.Character
        if not myChar then return end
        local item = getEquippedItem(myChar)
        if not item then return end
        local weaponType = item.Info and item.Info.Type
        if weaponType ~= "Gun" and weaponType ~= "Melee" then
            self.status.text = "no usable item(s)... (void)"
        end
    end)
end

function Ragebot:setupPriorityTargeting()
    local self = self

    function self:addPriority(player, level)
        self.priorities[player] = level
        if Toggles.ragebot_priority_notification.Value then
            Library:Notify("added " .. player.Name .. " to ragebot priority", 2)
        end
    end

    function self:removePriority(player)
        self.priorities[player] = nil
    end

    function self:markVoided(player)
        self.voidedPlayers[player] = true
    end

    function self:unmarkVoided(player)
        self.voidedPlayers[player] = nil
    end

    function self:getPriorityTarget()
        local cam = workspace.CurrentCamera
        local origin = cam and cam.CFrame.Position
        if not origin then return nil end

        local best, bestScore = nil, math.huge
        for player, char in pairs(self.characters) do
            if player ~= LocalPlayer then
                if not self:validateTarget(char) then continue end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - origin).Magnitude
                    local priority = self.priorities[player] or 0
                    local weight = 500
                    if priority > 0 then
                        weight = weight + priority * 100
                    end
                    local score = dist - weight
                    if self.voidedPlayers[player] then
                        score = score - 10000
                    end
                    if score < bestScore then
                        bestScore = score
                        best = char
                    end
                end
            end
        end
        return best
    end
end

function Ragebot:setupIndicator()
    local self = self
    local lastUpdate = 0

    RunService.RenderStepped:Connect(function()
        local now = tick()
        if now - lastUpdate < 0.1 then return end
        lastUpdate = now

        self.status.enabled = Toggles.ragebot_enabled.Value
        if not self.status.enabled then
            self.status.text = ""
            return
        end

        local myChar = LocalPlayer.Character
        if not myChar then return end
        local item = myChar:FindFirstChild("EquippedItem")
        local weaponType = item and item.Info and item.Info.Type

        if weaponType == "Gun" then
            self.status.text = "ragebot"
            self.status.weapon = item.Name
        elseif weaponType == "Melee" then
            local name = item.Name or "Knife"
            self.status.text = "ragebot: " .. name
            self.status.weapon = item
        else
            self.status.text = "invalid weapons for ragebot"
            self.status.weapon = nil
        end

        if Toggles.indicator_ragebot.Value then
            local style = Options.indicator_ragebot_style.Value
            self.events.ragebot_status:Fire(self.status.text)
        end
    end)
end

function Ragebot:setPriority(player, level)
    return self:addPriority(player, level)
end

function Ragebot:getState()
    return {
        enabled = self.status.enabled,
        text = self.status.text,
        weapon = self.status.weapon,
        priorityTarget = self:getPriorityTarget(),
    }
end

function Ragebot:getPriorityList()
    local list = {}
    for player, level in pairs(self.priorities) do
        table.insert(list, { player = player, priority = level })
    end
    return list
end

function Ragebot:getVoidedPlayers()
    local list = {}
    for player in pairs(self.voidedPlayers) do
        table.insert(list, player)
    end
    return list
end

return Ragebot
