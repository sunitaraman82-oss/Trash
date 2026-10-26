-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack

pcall(function()
	if not setthreadidentity then
		return
	end

	setthreadidentity(7)
end)

local game_ = game

local function v3(p1)
	local ok, result = pcall(function()
		return game_:GetService(p1)
	end)

	if not (ok and result) then
		return nil
	end

	local cloneref_ = cloneref

	if not cloneref_ then
		return cloneref_ or result
	end

	cloneref_ = cloneref(result)

	return cloneref_ or result
end

local newcclosure_ = newcclosure or function(p2)
	return p2
end

pcall(function()
	local getrenv_ = getrenv

	if getrenv_ then
		getrenv_ = getrenv()
	end

	local debug

	if getrenv_ then
		debug = getrenv_.debug

		if debug then
			local info = getrenv_.debug.info

			debug = type(info) == "function"

			if debug then
				debug = checkcaller

				if debug then
					debug = newcclosure
				end
			end
		end
	else
		debug = getrenv_
	end

	if not debug then
		return
	end

	local info = getrenv_.debug.info

	if setreadonly then
		pcall(setreadonly, getrenv_.debug, false)
	end

	getrenv_.debug.info = newcclosure(function(...)
		if checkcaller() then
			return info(...)
		else
			return info(...)
		end
	end)

	if not setreadonly then
		return
	end

	pcall(setreadonly, getrenv_.debug, true)
end)

local Players = v3("Players")
local TweenService = v3("TweenService")
local CoreGui = v3("CoreGui")
local Workspace = v3("Workspace")
local Lighting = v3("Lighting")
local RunService = v3("RunService")
local UserInputService = v3("UserInputService")
local ReplicatedStorage = v3("ReplicatedStorage")
local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo3 = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local t1 = {
	title = "NextGen",
	width = 390,
	titleH = 46,
	tabBarH = 38,
	statusH = 26,
	rowHeight = 38,
	rowGap = 6,
	padding = 9,
	sectionH = 28,
	dividerH = 12,
	colorBg = Color3.fromRGB(12, 14, 20),
	colorBar = Color3.fromRGB(18, 20, 29),
	colorRow = Color3.fromRGB(22, 25, 36),
	colorRowHover = Color3.fromRGB(30, 35, 52),
	colorStroke = Color3.fromRGB(36, 42, 60),
	colorStrokeLight = Color3.fromRGB(52, 60, 88),
	colorStrokeActive = Color3.fromRGB(0, 210, 255),
	colorOn = Color3.fromRGB(0, 220, 255),
	colorOnGlow = Color3.fromRGB(0, 160, 230),
	colorOff = Color3.fromRGB(36, 40, 56),
	colorOffKnob = Color3.fromRGB(120, 128, 155),
	colorKnob = Color3.fromRGB(255, 255, 255),
	colorText = Color3.fromRGB(238, 242, 255),
	colorTextDim = Color3.fromRGB(128, 136, 165),
	colorBtn = Color3.fromRGB(28, 33, 48),
	colorBtnHover = Color3.fromRGB(42, 50, 74),
	colorSection = Color3.fromRGB(0, 215, 255),
	colorDivider = Color3.fromRGB(32, 38, 54),
	colorTabActive = Color3.fromRGB(255, 255, 255),
	colorTabBgActive = Color3.fromRGB(28, 34, 52),
	colorTabInactive = Color3.fromRGB(120, 128, 155),
	colorStatusBg = Color3.fromRGB(15, 17, 25),
	colorStatusText = Color3.fromRGB(110, 120, 150),
	colorAccentGlow = Color3.fromRGB(0, 180, 240),
	ENEMY_COLOR = Color3.fromRGB(255, 60, 60),
	TEAM_COLOR = Color3.fromRGB(40, 240, 120),
	NPC_COLOR = Color3.fromRGB(170, 175, 190),
	LOOT_COLOR = Color3.fromRGB(240, 190, 60),
	MINE_COLOR = Color3.fromRGB(255, 140, 40),
	FILL_TRANSPARENCY = 0.5,
	OUTLINE_TRANSPARENCY = 0
}
local t2 = {
	{
		name = "PLAYER ESP",
		default = false,
		tag = "PLAYER_ESP"
	},
	{
		name = "FRIEND ESP",
		default = false,
		tag = "FRIEND_ESP"
	},
	{
		name = "NPC ESP",
		default = false,
		tag = "NPC_ESP"
	},
	{
		name = "CORPSE ESP",
		default = false,
		tag = "CORPSE_ESP"
	},
	{
		name = "MINES ESP",
		default = false,
		tag = "MINES_ESP"
	},
	{
		name = "BOSS TRACKER",
		default = false,
		tag = "BOSS_TRACKER"
	}
}
local t3 = {
	{
		name = "LOOT ESP",
		default = false,
		tag = "LOOT_ESP"
	}
}
local t4 = {
	{
		name = "AIMBOT",
		default = false,
		tag = "AIMBOT"
	},
	{
		name = "NO RECOIL",
		default = false,
		tag = "NO_RECOIL"
	}
}
local t5 = {
	{
		name = "FAST RUN",
		default = false,
		tag = "FAST_RUN"
	},
	{
		name = "INFINITY JUMP (Risky)",
		default = false,
		tag = "INFINITY_JUMP"
	}
}
local t6 = {
	{
		name = "NO VISOR & FLASH",
		default = false,
		tag = "NO_VISOR"
	},
	{
		name = "STATS GUI",
		default = true,
		tag = "STATS_GUI"
	},
	{
		name = "INVENTORY CHECKER",
		default = false,
		tag = "INV_CHECKER"
	},
	{
		name = "ZOOM",
		default = false,
		tag = "ZOOM"
	}
}
local t7 = {
	{
		name = "ALWAYS DAY",
		default = false,
		tag = "ALWAYS_DAY"
	},
	{
		name = "NO FOG",
		default = false,
		tag = "NO_FOG"
	},
	{
		name = "FULLBRIGHT",
		default = false,
		tag = "FULLBRIGHT"
	}
}
local t8 = {}
local t9 = {
	GrenadeTrap = true,
	MON50 = true,
	PMN2 = true
}

local function v32(p3, p4)
	p3.Active = true

	local function v33()
		os.clock()
		p4()
	end

	p3.MouseButton1Click:Connect(v33)
	pcall(function()
		p3.Activated:Connect(v33)
	end)
end

local t10 = {
	{
		name = "CashRegister",
		default = false,
		tag = "CashRegister"
	},
	{
		name = "FilingCabinet",
		default = false,
		tag = "FilingCabinet"
	},
	{
		name = "Fridge",
		default = false,
		tag = "Fridge"
	},
	{
		name = "GrenadeCrate",
		default = false,
		tag = "GrenadeCrate"
	},
	{
		name = "HiddenCache",
		default = false,
		tag = "HiddenCache"
	},
	{
		name = "KGBBag",
		default = false,
		tag = "KGBBag"
	},
	{
		name = "LargeABPOPABox",
		default = true,
		tag = "LargeABPOPABox"
	},
	{
		name = "LargeMilitaryBox",
		default = true,
		tag = "LargeMilitaryBox"
	},
	{
		name = "LargeShippingCrate",
		default = false,
		tag = "LargeShippingCrate"
	},
	{
		name = "MedBag",
		default = false,
		tag = "MedBag"
	},
	{
		name = "MilitaryCrate",
		default = false,
		tag = "MilitaryCrate"
	},
	{
		name = "ModificationStation",
		default = false,
		tag = "ModificationStation"
	},
	{
		name = "PC",
		default = false,
		tag = "PC"
	},
	{
		name = "Safe",
		default = false,
		tag = "Safe"
	},
	{
		name = "SatchelBag",
		default = false,
		tag = "SatchelBag"
	},
	{
		name = "SerumContainer",
		default = false,
		tag = "SerumContainer"
	},
	{
		name = "SmallMilitaryBox",
		default = false,
		tag = "SmallMilitaryBox"
	},
	{
		name = "SmallShippingCrate",
		default = false,
		tag = "SmallShippingCrate"
	},
	{
		name = "SportBag",
		default = false,
		tag = "SportBag"
	}
}

local function v35()
	local s1 = ""

	for _ = 1, math.random(16, 28) do
		local random = math.random

		s1 = s1 .. string.char(random(1, 250))
	end

	return s1
end
local function v39(p5, p6)
	local u40 = false
	local u41 = nil
	local Position = nil
	local Position2 = nil

	local function v44(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u40 = true
		Position = input.Position
		Position2 = p6.Position

		local connection = nil

		connection = input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u40 = false

			if not connection then
				return
			end

			connection:Disconnect()
			connection = nil
		end)
	end

	p5.InputBegan:Connect(v44)

	local function v46(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u41 = input
	end

	p5.InputChanged:Connect(v46)
	UserInputService.InputChanged:Connect(function(input)
		local v47

		if input == u41 then
			v47 = u40
		else
			v47 = false
		end

		if not v47 then
			return
		end

		local v48 = input.Position - Position

		p6.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v48.X, Position2.Y.Scale, Position2.Y.Offset + v48.Y)
	end)
	UserInputService.InputEnded:Connect(function(input)
		local _ = input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
	end)
end

local t11 = {
	{
		name = "SMART AIMBOT",
		default = true,
		tag = "AIMBOT_SMART"
	},
	{
		name = "IGNORE FRIENDS",
		default = false,
		tag = "AIMBOT_IGNORE_FRIENDS"
	},
	{
		name = "IGNORE NPC",
		default = true,
		tag = "AIMBOT_IGNORE_NPC"
	},
	{
		name = "SHOW FOV",
		default = true,
		tag = "AIMBOT_SHOW_FOV"
	}
}

for _, v in ipairs({
	t2,
	t3,
	t4,
	t5,
	t6,
	t7
}) do
	for _, v2 in ipairs(v) do
		t8[v2.tag] = true
	end
end

t8.PLAYER_ESP_BOX = true
t8.PLAYER_ESP_NAME = true
t8.PLAYER_ESP_DISTANCE = true
t8.PLAYER_ESP_HEALTH = true

local t12 = {
	{
		name = "Anton",
		zone = "Sawmill",
		location = "Sawmill"
	},
	{
		name = "Dozer",
		zone = "Factory",
		location = "Factory"
	},
	{
		name = "Whisper",
		zone = "Whisper",
		location = "Whisper",
		special = "DodgeStamina"
	},
	{
		name = "Death",
		zone = "Death",
		location = "Death"
	},
	{
		name = "MI24V",
		zone = "HeliAirfield",
		location = "HeliAirfield",
		special = "Chassis"
	}
}
local t13 = {
	{
		key = "Primary",
		label = "PRI"
	},
	{
		key = "Secondary",
		label = "SEC"
	},
	{
		key = "Holster",
		label = "HOL"
	},
	{
		key = "Helmet",
		label = "HELM"
	},
	{
		key = "Vest",
		label = "VEST"
	},
	{
		key = "Backpack",
		label = "BAG"
	},
	{
		key = "Rig",
		label = "RIG"
	},
	{
		key = "Mask",
		label = "MASK"
	},
	{
		key = "Pouch1",
		label = "PCH"
	},
	{
		key = "Pouch2",
		label = "PCH"
	},
	{
		key = "Pouch3",
		label = "PCH"
	},
	{
		key = "Gear",
		label = "GEAR"
	}
}
local t14 = {
	FOV_COLOR = Color3.fromRGB(0, 255, 0),
	FOV_LOCKED_COLOR = Color3.fromRGB(255, 0, 0),
	FOV_THICKNESS = 2,
	FOV_TRANSPARENCY = 0.8,
	SWIPE_THRESHOLD = 5,
	SWITCH_COOLDOWN = 0.15,
	DIRECTION_TOLERANCE = 0.3,
	BULLET_SPEED = 3299,
	DRAG = 0.013,
	GRAVITY = 4.6,
	AIM_SMOOTHNESS = 1,
	PREDICTION_MULTIPLIER = 1,
	MIN_PREDICTION_DISTANCE = 10
}

local function createFrame(p7, p8, p9)
	local Frame = Instance.new("Frame")

	Frame.Name = v35()
	Frame.Size = UDim2.new(0, 220, 0, 88)
	Frame.Position = UDim2.new(0, 18, 1, -18)
	Frame.AnchorPoint = Vector2.new(0, 1)
	Frame.BackgroundColor3 = t1.colorBg
	Frame.BorderSizePixel = 0
	Frame.Active = true
	Frame.Draggable = false
	Frame.Visible = p9.STATS_GUI == true
	Frame.Parent = p7
	v39(Frame, Frame)

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, 12)
	UICorner.Parent = Frame

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = Color3.fromRGB(255, 255, 255)
	UIStroke.Thickness = 1.2
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Parent = Frame

	local UIGradient = Instance.new("UIGradient")

	UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 240, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(45, 135, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 75, 255)) })
	UIGradient.Rotation = 45
	UIGradient.Parent = UIStroke

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Name = v35()
	ImageLabel.Size = UDim2.new(0, 52, 0, 52)
	ImageLabel.Position = UDim2.new(0, 12, 0.5, -26)
	ImageLabel.BackgroundColor3 = t1.colorRow
	ImageLabel.BorderSizePixel = 0
	ImageLabel.Parent = Frame

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(0, 10)
	UICorner2.Parent = ImageLabel

	local UIStroke2 = Instance.new("UIStroke")

	UIStroke2.Thickness = 1.2
	UIStroke2.Color = t1.colorOn
	UIStroke2.Parent = ImageLabel
	task.spawn(function()
		local ok, image, result = pcall(function()
			return Players:GetUserThumbnailAsync(p8.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		end)

		if not (ok and result) then
			return
		end

		ImageLabel.Image = image
	end)

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = v35()
	TextLabel.Size = UDim2.new(0, 70, 0, 18)
	TextLabel.Position = UDim2.new(0, 74, 0, 14)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "KILLS: 0"
	TextLabel.TextColor3 = t1.colorOn
	TextLabel.TextSize = 11.5
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Parent = Frame

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Name = v35()
	TextLabel2.Size = UDim2.new(0, 70, 0, 18)
	TextLabel2.Position = UDim2.new(0, 148, 0, 14)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = "DEATHS: 0"
	TextLabel2.TextColor3 = Color3.fromRGB(255, 120, 120)
	TextLabel2.TextSize = 11.5
	TextLabel2.Font = Enum.Font.GothamBold
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.Parent = Frame

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Name = v35()
	TextLabel3.Size = UDim2.new(0, 70, 0, 18)
	TextLabel3.Position = UDim2.new(0, 74, 0, 36)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = "K/D: 0.00"
	TextLabel3.TextColor3 = t1.colorText
	TextLabel3.TextSize = 11.5
	TextLabel3.Font = Enum.Font.GothamBold
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel3.Parent = Frame

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Name = v35()
	TextLabel4.Size = UDim2.new(0, 70, 0, 18)
	TextLabel4.Position = UDim2.new(0, 148, 0, 36)
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Text = "TIME: 0.0h"
	TextLabel4.TextColor3 = t1.colorTextDim
	TextLabel4.TextSize = 11.5
	TextLabel4.Font = Enum.Font.Gotham
	TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel4.Parent = Frame

	local TextLabel5 = Instance.new("TextLabel")

	TextLabel5.Name = v35()
	TextLabel5.Size = UDim2.new(1, -80, 0, 16)
	TextLabel5.Position = UDim2.new(0, 74, 0, 58)
	TextLabel5.BackgroundTransparency = 1
	TextLabel5.Text = tostring(p8.DisplayName or p8.Name)
	TextLabel5.TextColor3 = t1.colorTextDim
	TextLabel5.TextSize = 10
	TextLabel5.Font = Enum.Font.GothamBold
	TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel5.Parent = Frame
	task.spawn(function()
		while true do
			local function v74()
				if not (Frame and Frame.Visible) then
					return
				end

				local Players2 = ReplicatedStorage:FindFirstChild("Players")

				if not Players2 then
					TextLabel4.Text = "Err: No RS.Players"

					return
				end

				local v76 = Players2:FindFirstChild(p8.Name)

				if not v76 then
					local v77 = TextLabel4
					local Name = p8.Name

					v77.Text = "Err: No " .. tostring(Name)

					return
				end

				local Journey = v76:FindFirstChild("Journey")
				local WipeStatistics

				if Journey then
					WipeStatistics = Journey:FindFirstChild("WipeStatistics")
				else
					WipeStatistics = nil
				end

				local attribute, attribute2, attribute3, v84

				if WipeStatistics then
					if WipeStatistics then
						attribute = WipeStatistics:GetAttribute("Kills") or 0
						attribute2 = WipeStatistics:GetAttribute("Deaths") or 0
						attribute3 = WipeStatistics:GetAttribute("TimePlayed") or 0
						v84 = attribute / math.max(1, attribute2)
						TextLabel.Text = "KILLS: " .. tostring(attribute)
						TextLabel2.Text = "DEATHS: " .. tostring(attribute2)
						TextLabel3.Text = string.format("K/D: %.2f", v84)
						TextLabel4.Text = string.format("TIME: %.1fh", attribute3 / 3600)
					else
						TextLabel4.Text = "Err: No WipeStats"
					end

					return
				end

				local GetDescendants = v76.GetDescendants

				for _, v in ipairs(GetDescendants(v76)) do
					if string.find(string.lower(v.Name), "wipestatistics") then
						WipeStatistics = v

						break
					end
				end

				if WipeStatistics then
					attribute = WipeStatistics:GetAttribute("Kills") or 0
					attribute2 = WipeStatistics:GetAttribute("Deaths") or 0
					attribute3 = WipeStatistics:GetAttribute("TimePlayed") or 0
					v84 = attribute / math.max(1, attribute2)
					TextLabel.Text = "KILLS: " .. tostring(attribute)
					TextLabel2.Text = "DEATHS: " .. tostring(attribute2)
					TextLabel3.Text = string.format("K/D: %.2f", v84)
					TextLabel4.Text = string.format("TIME: %.1fh", attribute3 / 3600)
				else
					TextLabel4.Text = "Err: No WipeStats"
				end
			end

			local ok = pcall(v74)

			if not ok then
				TextLabel4.Text = "--"
			end

			task.wait(1)
		end
	end)

	return Frame
end
local function v90(p10)
	local Frame = Instance.new("Frame")

	Frame.Name = v35()
	Frame.Size = UDim2.new(0, t1.width, 0, 240)
	Frame.Position = UDim2.new(0.5, 15, 0.5, -120)
	Frame.BackgroundColor3 = t1.colorBg
	Frame.BorderSizePixel = 0
	Frame.Active = true
	Frame.Draggable = false
	Frame.Visible = false
	Frame.Parent = p10

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, 14)
	UICorner.Parent = Frame

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Thickness = 1.2
	UIStroke.Color = Color3.fromRGB(255, 255, 255)
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Parent = Frame

	local UIGradient = Instance.new("UIGradient")

	UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 240, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(45, 135, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 75, 255)) })
	UIGradient.Rotation = 45
	UIGradient.Parent = UIStroke

	local Frame2 = Instance.new("Frame")

	Frame2.Name = v35()
	Frame2.Size = UDim2.new(1, 0, 0, t1.titleH)
	Frame2.Position = UDim2.new(0, 0, 0, 0)
	Frame2.BackgroundColor3 = t1.colorBar
	Frame2.BorderSizePixel = 0
	Frame2.Parent = Frame

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(0, 14)
	UICorner2.Parent = Frame2

	local Frame3 = Instance.new("Frame")

	Frame3.Name = v35()
	Frame3.Size = UDim2.new(1, 0, 0, 14)
	Frame3.Position = UDim2.new(0, 0, 1, -14)
	Frame3.BackgroundColor3 = t1.colorBar
	Frame3.BorderSizePixel = 0
	Frame3.ZIndex = 1
	Frame3.Parent = Frame2

	local Frame4 = Instance.new("Frame")

	Frame4.Name = v35()
	Frame4.Size = UDim2.new(1, 0, 0, 1)
	Frame4.Position = UDim2.new(0, 0, 0, t1.titleH)
	Frame4.BackgroundColor3 = t1.colorDivider
	Frame4.BorderSizePixel = 0
	Frame4.ZIndex = 2
	Frame4.Parent = Frame
	v39(Frame2, Frame)

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = v35()
	TextLabel.Size = UDim2.new(1, -50, 1, 0)
	TextLabel.Position = UDim2.new(0, 14, 0, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "⚙  Player ESP Info Tags"
	TextLabel.TextColor3 = t1.colorText
	TextLabel.TextSize = 14
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Parent = Frame2

	local TextButton = Instance.new("TextButton")

	TextButton.Name = v35()
	TextButton.Size = UDim2.new(0, 28, 0, 28)
	TextButton.Position = UDim2.new(1, -38, 0.5, -14)
	TextButton.BackgroundColor3 = t1.colorBtn
	TextButton.Text = "X"
	TextButton.TextColor3 = t1.colorTextDim
	TextButton.TextSize = 12
	TextButton.Font = Enum.Font.GothamBold
	TextButton.BorderSizePixel = 0
	TextButton.AutoButtonColor = false
	TextButton.Parent = Frame2

	local UICorner3 = Instance.new("UICorner")

	UICorner3.CornerRadius = UDim.new(0, 7)
	UICorner3.Parent = TextButton

	local UIStroke2 = Instance.new("UIStroke")

	UIStroke2.Thickness = 1
	UIStroke2.Color = t1.colorStroke
	UIStroke2.Parent = TextButton
	TextButton.MouseEnter:Connect(function()
		local v103 = TweenService
		local v104 = TextButton
		local v105 = tweenInfo
		local color3 = Color3.fromRGB

		v103.Create(v103, v104, v105, {
			BackgroundColor3 = color3(70, 30, 40)
		}):Play()

		local v107 = TweenService
		local v108 = TextButton
		local v109 = tweenInfo
		local color32 = Color3.fromRGB

		v107.Create(v107, v108, v109, {
			TextColor3 = color32(255, 100, 120)
		}):Play()
	end)

	local MouseLeave = TextButton.MouseLeave

	MouseLeave.Connect(MouseLeave, function()
		local v112 = TweenService
		local v113 = TextButton
		local v114 = tweenInfo
		local v115 = t1

		v112.Create(v112, v113, v114, {
			BackgroundColor3 = v115.colorBtn
		}):Play()

		local v116 = TweenService
		local v117 = TextButton
		local v118 = tweenInfo
		local t15 = {
			TextColor3 = t1.colorTextDim
		}

		v116.Create(v116, v117, v118, t15):Play()
	end)
	v32(TextButton, function()
		Frame.Visible = false
	end)

	local Frame5 = Instance.new("Frame")

	Frame5.Name = v35()
	Frame5.Size = UDim2.new(1, 0, 1, -(t1.titleH + 1))
	Frame5.Position = UDim2.new(0, 0, 0, t1.titleH + 1)
	Frame5.BackgroundTransparency = 1
	Frame5.BorderSizePixel = 0
	Frame5.ClipsDescendants = true
	Frame5.Parent = Frame

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.Parent = Frame5
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, t1.rowGap)
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local UIPadding = Instance.new("UIPadding")

	UIPadding.Parent = Frame5
	UIPadding.PaddingTop = UDim.new(0, t1.padding)
	UIPadding.PaddingBottom = UDim.new(0, t1.padding)

	return Frame, Frame5
end
local function createFrame2(p11, p12)
	local Frame = Instance.new("Frame")

	Frame.Name = v35()
	Frame.Size = UDim2.new(0, 250, 0, 258)
	Frame.Position = UDim2.new(0, 18, 0, 70)
	Frame.BackgroundColor3 = t1.colorBg
	Frame.BorderSizePixel = 0
	Frame.Active = true
	Frame.Draggable = false
	Frame.Visible = p12.BOSS_TRACKER == true
	Frame.Parent = p11

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, 12)
	UICorner.Parent = Frame

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = Color3.fromRGB(255, 255, 255)
	UIStroke.Thickness = 1.2
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Parent = Frame

	local UIGradient = Instance.new("UIGradient")

	UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 240, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(130, 80, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 65, 125)) })
	UIGradient.Rotation = 45
	UIGradient.Parent = UIStroke

	local Frame2 = Instance.new("Frame")

	Frame2.Name = v35()
	Frame2.Size = UDim2.new(1, 0, 0, 34)
	Frame2.BackgroundTransparency = 1
	Frame2.BorderSizePixel = 0
	Frame2.Parent = Frame
	v39(Frame2, Frame)
	v39(Frame, Frame)

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = v35()
	TextLabel.Size = UDim2.new(0, 20, 0, 20)
	TextLabel.Position = UDim2.new(0, 10, 0.5, -10)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "⚔️"
	TextLabel.TextSize = 13
	TextLabel.Parent = Frame2

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Name = v35()
	TextLabel2.Size = UDim2.new(0, 140, 1, 0)
	TextLabel2.Position = UDim2.new(0, 34, 0, 0)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = "BOSS TRACKER"
	TextLabel2.TextColor3 = t1.colorText
	TextLabel2.TextSize = 12
	TextLabel2.Font = Enum.Font.GothamBold
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.Parent = Frame2

	local Frame3 = Instance.new("Frame")

	Frame3.Name = v35()
	Frame3.Size = UDim2.new(0, 72, 0, 20)
	Frame3.Position = UDim2.new(1, -80, 0.5, -10)
	Frame3.BackgroundColor3 = t1.colorBar
	Frame3.BorderSizePixel = 0
	Frame3.Parent = Frame2

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(0, 6)
	UICorner2.Parent = Frame3

	local UIStroke2 = Instance.new("UIStroke")

	UIStroke2.Thickness = 1
	UIStroke2.Color = t1.colorStroke
	UIStroke2.Parent = Frame3

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Name = v35()
	TextLabel3.Size = UDim2.new(1, 0, 1, 0)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = "0/5 ALIVE"
	TextLabel3.TextColor3 = t1.colorTextDim
	TextLabel3.TextSize = 9.5
	TextLabel3.Font = Enum.Font.GothamBold
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Center
	TextLabel3.Parent = Frame3

	local Frame4 = Instance.new("Frame")

	Frame4.Name = v35()
	Frame4.Size = UDim2.new(1, 0, 0, 1)
	Frame4.Position = UDim2.new(0, 0, 0, 34)
	Frame4.BackgroundColor3 = t1.colorDivider
	Frame4.BorderSizePixel = 0
	Frame4.Parent = Frame

	local Frame5 = Instance.new("Frame")

	Frame5.Name = v35()
	Frame5.Size = UDim2.new(1, 0, 1, -35)
	Frame5.Position = UDim2.new(0, 0, 0, 35)
	Frame5.BackgroundTransparency = 1
	Frame5.BorderSizePixel = 0
	Frame5.Parent = Frame

	local UIPadding = Instance.new("UIPadding")

	UIPadding.PaddingTop = UDim.new(0, 6)
	UIPadding.PaddingBottom = UDim.new(0, 6)
	UIPadding.PaddingLeft = UDim.new(0, 8)
	UIPadding.PaddingRight = UDim.new(0, 8)
	UIPadding.Parent = Frame5

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.Parent = Frame5

	local t16 = {}

	for i, v in ipairs(t12) do
		local Frame6 = Instance.new("Frame")

		Frame6.Name = v35()
		Frame6.Size = UDim2.new(1, 0, 0, 38)
		Frame6.BackgroundColor3 = t1.colorRow
		Frame6.BorderSizePixel = 0
		Frame6.LayoutOrder = i
		Frame6.Parent = Frame5

		local UICorner3 = Instance.new("UICorner")

		UICorner3.CornerRadius = UDim.new(0, 8)
		UICorner3.Parent = Frame6

		local UIStroke3 = Instance.new("UIStroke")

		UIStroke3.Thickness = 1
		UIStroke3.Color = t1.colorStroke
		UIStroke3.Parent = Frame6

		local TextLabel4 = Instance.new("TextLabel")

		TextLabel4.Name = v35()
		TextLabel4.Size = UDim2.new(0, 95, 0, 15)
		TextLabel4.Position = UDim2.new(0, 10, 0, 5)
		TextLabel4.BackgroundTransparency = 1
		TextLabel4.Text = v.name
		TextLabel4.TextColor3 = t1.colorText
		TextLabel4.TextSize = 11.5
		TextLabel4.Font = Enum.Font.GothamBold
		TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel4.Parent = Frame6

		local TextLabel5 = Instance.new("TextLabel")

		TextLabel5.Name = v35()
		TextLabel5.Size = UDim2.new(0, 95, 0, 13)
		TextLabel5.Position = UDim2.new(0, 10, 0, 19)
		TextLabel5.BackgroundTransparency = 1
		TextLabel5.Text = v.location
		TextLabel5.TextColor3 = t1.colorTextDim
		TextLabel5.TextSize = 9
		TextLabel5.Font = Enum.Font.Gotham
		TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel5.Parent = Frame6

		local TextLabel6 = Instance.new("TextLabel")

		TextLabel6.Name = v35()
		TextLabel6.Size = UDim2.new(1, -115, 0, 16)
		TextLabel6.Position = UDim2.new(0, 105, 0, 6)
		TextLabel6.BackgroundTransparency = 1
		TextLabel6.Text = "Dead"
		TextLabel6.TextColor3 = Color3.fromRGB(255, 75, 75)
		TextLabel6.TextSize = 11
		TextLabel6.Font = Enum.Font.GothamBold
		TextLabel6.TextXAlignment = Enum.TextXAlignment.Right
		TextLabel6.Parent = Frame6

		local Frame7 = Instance.new("Frame")

		Frame7.Name = v35()
		Frame7.Size = UDim2.new(1, -20, 0, 2.5)
		Frame7.Position = UDim2.new(0, 10, 1, -5)
		Frame7.BackgroundColor3 = Color3.fromRGB(30, 34, 48)
		Frame7.BorderSizePixel = 0
		Frame7.Parent = Frame6

		local UICorner4 = Instance.new("UICorner")

		UICorner4.CornerRadius = UDim.new(0, 2)
		UICorner4.Parent = Frame7

		local Frame8 = Instance.new("Frame")

		Frame8.Name = v35()
		Frame8.Size = UDim2.new(0, 0, 1, 0)
		Frame8.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
		Frame8.BorderSizePixel = 0
		Frame8.Parent = Frame7

		local UICorner5 = Instance.new("UICorner")

		UICorner5.CornerRadius = UDim.new(0, 2)
		UICorner5.Parent = Frame8
		Frame6.MouseEnter:Connect(function()
			local v152 = TweenService
			local v153 = Frame6
			local v154 = tweenInfo
			local t17 = {
				BackgroundColor3 = t1.colorRowHover
			}

			v152.Create(v152, v153, v154, t17):Play()

			local v156 = TweenService
			local v157 = UIStroke3
			local v158 = tweenInfo
			local v159 = t1

			v156.Create(v156, v157, v158, {
				Color = v159.colorStrokeLight
			}):Play()
		end)
		Frame6.MouseLeave:Connect(function()
			local v160 = TweenService
			local v161 = Frame6
			local v162 = tweenInfo
			local v163 = t1

			v160.Create(v160, v161, v162, {
				BackgroundColor3 = v163.colorRow
			}):Play()

			local v164 = TweenService
			local v165 = UIStroke3
			local v166 = tweenInfo
			local t18 = {
				Color = t1.colorStroke
			}

			v164.Create(v164, v165, v166, t18):Play()
		end)
		t16[v.name] = {
			def = v,
			card = Frame6,
			stroke = UIStroke3,
			statusLbl = TextLabel6,
			barFill = Frame8
		}
	end

	task.spawn(function()
		while true do
			local function v168()
				if not (Frame and Frame.Visible) then
					return
				end

				local AiZones = Workspace

				if AiZones then
					AiZones = Workspace:FindFirstChild("AiZones")
				end

				local v170, v171, v172 = ipairs(t12)
				local n1 = 0

				while true do
					local v174

					v172, v174 = v170(v171, v172)

					if not v172 then
						break
					end

					local v175 = t16[v174.name]

					if v175 then
						local v176 = false
						local n2 = 0
						local n3 = 100
						local n4 = 0

						if AiZones then
							local v180 = AiZones:FindFirstChild(v174.zone)

							if v180 then
								local v181 = v180:FindFirstChild(v174.name)
								local isModel

								if v181 then
									isModel = v181:IsA("Model") or v181:IsA("PVInstance")
								else
									isModel = v181
								end

								if isModel then
									local ok, result = pcall(function()
										return v181:GetPivot()
									end)

									if ok then
										if result then
											result = result.Position.Y <= -100
										end
									else
										result = ok
									end

									if not result then
										if v174.special == "Chassis" then
											local Chassis = v181:FindFirstChild("Chassis")

											if Chassis then
												local attribute = Chassis:GetAttribute("Health")
												local attribute2 = Chassis:GetAttribute("MaxHealth")
												local v188

												if attribute then
													if attribute2 then
														v188 = attribute2 > 0
													else
														v188 = attribute2
													end
												else
													v188 = attribute
												end

												if v188 then
													local v189 = math.floor(attribute)

													n2 = math.max(0, v189)
													n3 = math.max(1, (math.floor(attribute2)))

													local v190 = n2 / n3 * 100
													local v191 = math.floor(v190)

													n4 = math.clamp(v191, 0, 100)

													if n2 > 0 then
														v176 = true
													end
												end
											end
										elseif v174.special == "DodgeStamina" then
											local Humanoid = v181:FindFirstChild("Humanoid")

											if Humanoid then
												local attribute = Humanoid:GetAttribute("DodgeStamina")
												local attribute2 = Humanoid:GetAttribute("MaxDodgeStamina")
												local v195

												if attribute then
													if attribute2 then
														v195 = attribute2 > 0
													else
														v195 = attribute2
													end
												else
													v195 = attribute
												end

												if v195 then
													local v196 = math.floor(attribute)

													n2 = math.max(0, v196)
													n3 = math.max(1, (math.floor(attribute2)))

													local v197 = n2 / n3 * 100
													local v198 = math.floor(v197)

													n4 = math.clamp(v198, 0, 100)

													if n2 > 0 then
														v176 = true
													end
												end
											end
										else
											local Humanoid = v181:FindFirstChild("Humanoid")

											if Humanoid then
												local Health = Humanoid.Health or 0
												local v201 = math.floor(Health)

												n2 = math.max(0, v201)

												local max = math.max
												local MaxHealth = Humanoid.MaxHealth or 100

												n3 = max(1, (math.floor(MaxHealth)))

												local v204 = n2 / n3 * 100
												local v205 = math.floor(v204)

												n4 = math.clamp(v205, 0, 100)

												if n2 > 0 then
													v176 = true
												end
											end
										end
									end
								end
							end
						end

						if v176 then
							n1 = n1 + 1
							v175.statusLbl.Text = string.format("%d/%d (%d%%)", n2, n3, n4)
							v175.statusLbl.TextColor3 = Color3.fromRGB(40, 240, 120)
							v175.barFill.Size = UDim2.new(n4 / 100, 0, 1, 0)
							v175.barFill.BackgroundColor3 = Color3.fromRGB(40, 240, 120)
						else
							v175.statusLbl.Text = "Dead"
							v175.statusLbl.TextColor3 = Color3.fromRGB(255, 75, 75)
							v175.barFill.Size = UDim2.new(0, 0, 1, 0)
							v175.barFill.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
						end
					end
				end

				if n1 > 0 then
					local v206 = TextLabel3
					local v207 = tostring(n1)
					local v208 = #t12

					v206.Text = v207 .. "/" .. tostring(v208) .. " ALIVE"
					TextLabel3.TextColor3 = t1.colorOn
					UIStroke2.Color = t1.colorOnGlow
				else
					TextLabel3.Text = "ALL DEAD"
					TextLabel3.TextColor3 = t1.colorTextDim
					UIStroke2.Color = t1.colorStroke
				end
			end

			pcall(v168)
			task.wait(0.5)
		end
	end)

	return Frame
end
local function v209(p13)
	if p13 then
		local tostring_ = tostring
		local Name

		if typeof(p13) == "EnumItem" then
			Name = p13.Name
		else
			Name = false
		end

		local v212 = tostring_(Name or p13)

		if v212 == "LeftShift" then
			return "LSHIFT"
		elseif v212 == "RightShift" then
			return "RSHIFT"
		elseif v212 == "LeftControl" then
			return "LCTRL"
		elseif v212 == "RightControl" then
			return "RCTRL"
		elseif v212 == "LeftAlt" then
			return "LALT"
		elseif v212 == "RightAlt" then
			return "RALT"
		elseif v212 == "CapsLock" then
			return "CAPS"
		elseif v212 == "PageUp" then
			return "PGUP"
		elseif v212 == "PageDown" then
			return "PGDN"
		elseif v212 == "MouseButton1" then
			return "LMB"
		elseif v212 == "MouseButton2" then
			return "RMB"
		elseif v212 == "MouseButton3" then
			return "MMB"
		elseif v212 == "MouseButton4" then
			return "MB4"
		elseif v212 == "MouseButton5" then
			return "MB5"
		elseif v212:find("MouseButton") then
			local v213 = v212:gsub("MouseButton", "MB")

			return v213.upper(v213)
		else
			return v212.upper(v212)
		end
	else
		return "NONE"
	end
end
local function createFrame3(p14, p15, p16)
	local Frame = Instance.new("Frame")

	Frame.Name = v35()
	Frame.Size = UDim2.new(0, 366, 0, 556)
	Frame.Position = UDim2.new(1, -386, 0, 70)
	Frame.BackgroundColor3 = t1.colorBg
	Frame.BorderSizePixel = 0
	Frame.Active = true
	Frame.Draggable = false
	Frame.Visible = p16.INV_CHECKER == true
	Frame.Parent = p14

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, 12)
	UICorner.Parent = Frame

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = Color3.fromRGB(255, 255, 255)
	UIStroke.Thickness = 1.2
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Parent = Frame

	local UIGradient = Instance.new("UIGradient")

	UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 240, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(45, 135, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 75, 255)) })
	UIGradient.Rotation = 45
	UIGradient.Parent = UIStroke

	local Frame2 = Instance.new("Frame")

	Frame2.Name = v35()
	Frame2.Size = UDim2.new(1, 0, 0, 35)
	Frame2.BackgroundTransparency = 1
	Frame2.BorderSizePixel = 0
	Frame2.Parent = Frame
	v39(Frame2, Frame)
	v39(Frame, Frame)

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = v35()
	TextLabel.Size = UDim2.new(0, 180, 1, 0)
	TextLabel.Position = UDim2.new(0, 14, 0, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "INVENTORY CHECKER"
	TextLabel.TextColor3 = t1.colorText
	TextLabel.TextSize = 12
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Parent = Frame2

	local Frame3 = Instance.new("Frame")

	Frame3.Name = v35()
	Frame3.Size = UDim2.new(0, 96, 0, 22)
	Frame3.Position = UDim2.new(1, -108, 0.5, -11)
	Frame3.BackgroundColor3 = t1.colorBar
	Frame3.BorderSizePixel = 0
	Frame3.Parent = Frame2

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(0, 6)
	UICorner2.Parent = Frame3

	local UIStroke2 = Instance.new("UIStroke")

	UIStroke2.Thickness = 1
	UIStroke2.Color = t1.colorStroke
	UIStroke2.Parent = Frame3

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Name = v35()
	TextLabel2.Size = UDim2.new(1, 0, 1, 0)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = "$0"
	TextLabel2.TextColor3 = Color3.fromRGB(255, 215, 0)
	TextLabel2.TextSize = 10
	TextLabel2.Font = Enum.Font.GothamBold
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Center
	TextLabel2.Parent = Frame3

	local Frame4 = Instance.new("Frame")

	Frame4.Name = v35()
	Frame4.Size = UDim2.new(1, 0, 0, 1)
	Frame4.Position = UDim2.new(0, 0, 0, 35)
	Frame4.BackgroundColor3 = t1.colorDivider
	Frame4.BorderSizePixel = 0
	Frame4.Parent = Frame

	local Frame5 = Instance.new("Frame")

	Frame5.Name = v35()
	Frame5.Size = UDim2.new(1, -24, 0, 46)
	Frame5.Position = UDim2.new(0, 12, 0, 43)
	Frame5.BackgroundColor3 = t1.colorBar
	Frame5.BorderSizePixel = 0
	Frame5.Parent = Frame

	local UICorner3 = Instance.new("UICorner")

	UICorner3.CornerRadius = UDim.new(0, 8)
	UICorner3.Parent = Frame5

	local UIStroke3 = Instance.new("UIStroke")

	UIStroke3.Thickness = 1
	UIStroke3.Color = t1.colorStroke
	UIStroke3.Parent = Frame5

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Name = v35()
	ImageLabel.Size = UDim2.new(0, 32, 0, 32)
	ImageLabel.Position = UDim2.new(0, 8, 0.5, -16)
	ImageLabel.BackgroundColor3 = t1.colorRow
	ImageLabel.BorderSizePixel = 0
	ImageLabel.Parent = Frame5

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0, 6)
	UICorner4.Parent = ImageLabel

	local UIStroke4 = Instance.new("UIStroke")

	UIStroke4.Thickness = 1
	UIStroke4.Color = t1.colorStrokeLight
	UIStroke4.Parent = ImageLabel

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Name = v35()
	TextLabel3.Size = UDim2.new(1, 0, 1, 0)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = "👤"
	TextLabel3.TextSize = 16
	TextLabel3.Parent = ImageLabel

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Name = v35()
	TextLabel4.Size = UDim2.new(1, -130, 0, 16)
	TextLabel4.Position = UDim2.new(0, 48, 0, 6)
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Text = "No Target In Range"
	TextLabel4.TextColor3 = t1.colorText
	TextLabel4.TextSize = 12
	TextLabel4.Font = Enum.Font.GothamBold
	TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel4.Parent = Frame5

	local TextLabel5 = Instance.new("TextLabel")

	TextLabel5.Name = v35()
	TextLabel5.Size = UDim2.new(1, -130, 0, 14)
	TextLabel5.Position = UDim2.new(0, 48, 0, 24)
	TextLabel5.BackgroundTransparency = 1
	TextLabel5.Text = "Aim at player or corpse to inspect"
	TextLabel5.TextColor3 = t1.colorTextDim
	TextLabel5.TextSize = 9.5
	TextLabel5.Font = Enum.Font.Gotham
	TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel5.Parent = Frame5

	local Frame6 = Instance.new("Frame")

	Frame6.Name = v35()
	Frame6.Size = UDim2.new(0, 68, 0, 20)
	Frame6.Position = UDim2.new(1, -76, 0.5, -10)
	Frame6.BackgroundColor3 = t1.colorRow
	Frame6.BorderSizePixel = 0
	Frame6.Parent = Frame5

	local UICorner5 = Instance.new("UICorner")

	UICorner5.CornerRadius = UDim.new(0, 4)
	UICorner5.Parent = Frame6

	local UIStroke5 = Instance.new("UIStroke")

	UIStroke5.Thickness = 1
	UIStroke5.Color = t1.colorStroke
	UIStroke5.Parent = Frame6

	local TextLabel6 = Instance.new("TextLabel")

	TextLabel6.Name = v35()
	TextLabel6.Size = UDim2.new(1, 0, 1, 0)
	TextLabel6.BackgroundTransparency = 1
	TextLabel6.Text = "IDLE"
	TextLabel6.TextColor3 = t1.colorTextDim
	TextLabel6.TextSize = 8.5
	TextLabel6.Font = Enum.Font.GothamBold
	TextLabel6.TextXAlignment = Enum.TextXAlignment.Center
	TextLabel6.Parent = Frame6

	local TextLabel7 = Instance.new("TextLabel")

	TextLabel7.Name = v35()
	TextLabel7.Size = UDim2.new(1, -24, 0, 14)
	TextLabel7.Position = UDim2.new(0, 12, 0, 97)
	TextLabel7.BackgroundTransparency = 1
	TextLabel7.Text = "EQUIPPED GEAR"
	TextLabel7.TextColor3 = t1.colorSection
	TextLabel7.TextSize = 9.5
	TextLabel7.Font = Enum.Font.GothamBold
	TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel7.Parent = Frame

	local Frame7 = Instance.new("Frame")

	Frame7.Name = v35()
	Frame7.Size = UDim2.new(1, -24, 0, 110)
	Frame7.Position = UDim2.new(0, 12, 0, 115)
	Frame7.BackgroundTransparency = 1
	Frame7.BorderSizePixel = 0
	Frame7.Parent = Frame

	local UIGridLayout = Instance.new("UIGridLayout")

	UIGridLayout.CellSize = UDim2.new(0, 52, 0, 52)
	UIGridLayout.CellPadding = UDim2.new(0, 6, 0, 6)
	UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIGridLayout.Parent = Frame7

	local t19 = {}

	for i = 1, 12 do
		local Frame8 = Instance.new("Frame")

		Frame8.Name = v35()
		Frame8.LayoutOrder = i
		Frame8.Size = UDim2.new(0, 52, 0, 52)
		Frame8.BackgroundColor3 = t1.colorRow
		Frame8.BorderSizePixel = 0
		Frame8.Parent = Frame7

		local UICorner6 = Instance.new("UICorner")

		UICorner6.CornerRadius = UDim.new(0, 8)
		UICorner6.Parent = Frame8

		local UIStroke6 = Instance.new("UIStroke")

		UIStroke6.Thickness = 1
		UIStroke6.Color = t1.colorStroke
		UIStroke6.Parent = Frame8

		local TextLabel8 = Instance.new("TextLabel")

		TextLabel8.Name = v35()
		TextLabel8.Size = UDim2.new(1, -6, 0, 11)
		TextLabel8.Position = UDim2.new(0, 3, 0, 2)
		TextLabel8.BackgroundTransparency = 1

		local s2 = "Text"
		local label = t13[i]

		if label then
			label = t13[i].label
		end

		TextLabel8[s2] = label or ""
		TextLabel8.TextColor3 = t1.colorTextDim
		TextLabel8.TextSize = 8
		TextLabel8.Font = Enum.Font.GothamBold
		TextLabel8.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel8.Parent = Frame8

		local ImageLabel2 = Instance.new("ImageLabel")

		ImageLabel2.Name = v35()
		ImageLabel2.Size = UDim2.new(0, 38, 0, 38)
		ImageLabel2.Position = UDim2.new(0.5, -19, 0.5, -15)
		ImageLabel2.BackgroundTransparency = 1
		ImageLabel2.Image = ""
		ImageLabel2.Visible = false
		ImageLabel2.Parent = Frame8

		local TextLabel9 = Instance.new("TextLabel")

		TextLabel9.Name = v35()
		TextLabel9.Size = UDim2.new(1, -6, 0, 11)
		TextLabel9.Position = UDim2.new(0, 2, 1, -12)
		TextLabel9.BackgroundTransparency = 1
		TextLabel9.Text = ""
		TextLabel9.TextColor3 = t1.colorOn
		TextLabel9.TextSize = 8
		TextLabel9.Font = Enum.Font.GothamBold
		TextLabel9.TextXAlignment = Enum.TextXAlignment.Right
		TextLabel9.Parent = Frame8
		t19[i] = {
			frame = Frame8,
			stroke = UIStroke6,
			badge = TextLabel8,
			img = ImageLabel2,
			sub = TextLabel9
		}
	end

	local Frame8 = Instance.new("Frame")

	Frame8.Name = v35()
	Frame8.Size = UDim2.new(1, 0, 0, 1)
	Frame8.Position = UDim2.new(0, 0, 0, 233)
	Frame8.BackgroundColor3 = t1.colorDivider
	Frame8.BorderSizePixel = 0
	Frame8.Parent = Frame

	local Frame9 = Instance.new("Frame")

	Frame9.Name = v35()
	Frame9.Size = UDim2.new(1, -24, 0, 14)
	Frame9.Position = UDim2.new(0, 12, 0, 241)
	Frame9.BackgroundTransparency = 1
	Frame9.BorderSizePixel = 0
	Frame9.Parent = Frame

	local TextLabel8 = Instance.new("TextLabel")

	TextLabel8.Name = v35()
	TextLabel8.Size = UDim2.new(0, 180, 1, 0)
	TextLabel8.BackgroundTransparency = 1
	TextLabel8.Text = "BACKPACK & CONTAINERS"
	TextLabel8.TextColor3 = t1.colorSection
	TextLabel8.TextSize = 9.5
	TextLabel8.Font = Enum.Font.GothamBold
	TextLabel8.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel8.Parent = Frame9

	local TextLabel9 = Instance.new("TextLabel")

	TextLabel9.Name = v35()
	TextLabel9.Size = UDim2.new(0, 100, 1, 0)
	TextLabel9.Position = UDim2.new(1, -100, 0, 0)
	TextLabel9.BackgroundTransparency = 1
	TextLabel9.Text = "0 items"
	TextLabel9.TextColor3 = t1.colorTextDim
	TextLabel9.TextSize = 9.5
	TextLabel9.Font = Enum.Font.Gotham
	TextLabel9.TextXAlignment = Enum.TextXAlignment.Right
	TextLabel9.Parent = Frame9

	local ScrollingFrame = Instance.new("ScrollingFrame")

	ScrollingFrame.Name = v35()
	ScrollingFrame.Size = UDim2.new(1, -24, 0, 286)
	ScrollingFrame.Position = UDim2.new(0, 12, 0, 259)
	ScrollingFrame.BackgroundTransparency = 1
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.ScrollBarThickness = 2
	ScrollingFrame.ScrollBarImageColor3 = t1.colorOn
	ScrollingFrame.ScrollBarImageTransparency = 0.3
	ScrollingFrame.Active = true
	ScrollingFrame.ScrollingEnabled = true
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollingFrame.ClipsDescendants = true
	ScrollingFrame.Parent = Frame

	local UIGridLayout2 = Instance.new("UIGridLayout")

	UIGridLayout2.CellSize = UDim2.new(0, 52, 0, 52)
	UIGridLayout2.CellPadding = UDim2.new(0, 6, 0, 6)
	UIGridLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Left
	UIGridLayout2.SortOrder = Enum.SortOrder.LayoutOrder
	UIGridLayout2.Parent = ScrollingFrame

	local TextLabel10 = Instance.new("TextLabel")

	TextLabel10.Name = v35()
	TextLabel10.Size = UDim2.new(1, 0, 0, 60)
	TextLabel10.Position = UDim2.new(0, 0, 0.5, -30)
	TextLabel10.BackgroundTransparency = 1
	TextLabel10.Text = "No items in backpack or containers."
	TextLabel10.TextColor3 = t1.colorTextDim
	TextLabel10.TextSize = 10.5
	TextLabel10.Font = Enum.Font.Gotham
	TextLabel10.TextXAlignment = Enum.TextXAlignment.Center
	TextLabel10.Visible = true
	TextLabel10.Parent = ScrollingFrame
	UIGridLayout2.GetPropertyChangedSignal(UIGridLayout2, "AbsoluteContentSize"):Connect(function()
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIGridLayout2.AbsoluteContentSize.Y + 6)
	end)

	local t20 = {}

	for i = 1, 60 do
		local Frame10 = Instance.new("Frame")

		Frame10.Name = v35()
		Frame10.Size = UDim2.new(0, 52, 0, 52)
		Frame10.BackgroundColor3 = t1.colorRow
		Frame10.BorderSizePixel = 0
		Frame10.Visible = false
		Frame10.Parent = ScrollingFrame

		local UICorner6 = Instance.new("UICorner")

		UICorner6.CornerRadius = UDim.new(0, 8)
		UICorner6.Parent = Frame10

		local UIStroke6 = Instance.new("UIStroke")

		UIStroke6.Thickness = 1
		UIStroke6.Color = t1.colorStroke
		UIStroke6.Parent = Frame10

		local ImageLabel2 = Instance.new("ImageLabel")

		ImageLabel2.Name = v35()
		ImageLabel2.Size = UDim2.new(0, 40, 0, 40)
		ImageLabel2.Position = UDim2.new(0.5, -20, 0.5, -20)
		ImageLabel2.BackgroundTransparency = 1
		ImageLabel2.Parent = Frame10

		local TextLabel11 = Instance.new("TextLabel")

		TextLabel11.Name = v35()
		TextLabel11.Size = UDim2.new(1, -6, 0, 12)
		TextLabel11.Position = UDim2.new(0, 2, 1, -14)
		TextLabel11.BackgroundTransparency = 1
		TextLabel11.Text = ""
		TextLabel11.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel11.TextSize = 8.5
		TextLabel11.Font = Enum.Font.GothamBold
		TextLabel11.TextXAlignment = Enum.TextXAlignment.Right
		TextLabel11.Parent = Frame10
		t20[i] = {
			cell = Frame10,
			img = ImageLabel2,
			qty = TextLabel11,
			stroke = UIStroke6
		}
	end

	local function v266(p17)
		local v267 = math.floor(p17 or 0)
		local v268 = tostring(v267)

		repeat
			local v269

			v268, v269 = string.gsub(v268, "^(-?%d+)(%d%d%d)", "%1,%2")
		until v269 == 0

		return v268
	end

	local u270 = nil
	local n5 = 0

	task.spawn(function()
		while true do
			pcall(function()
				if not (Frame and Frame.Visible) then
					return
				end

				local CurrentCamera = Workspace.CurrentCamera

				if not CurrentCamera then
					return
				end

				local vector2 = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
				local ipairs_ = ipairs
				local v275, v276, v277 = ipairs_(Players:GetPlayers())
				local n6 = 550
				local v279 = nil

				while true do
					local v280

					v277, v280 = v275(v276, v277)

					if not v277 then
						break
					end

					local v281

					if v280 == p15 then
						v281 = false
					else
						v281 = v280.Character
					end

					local Magnitude

					if v281 then
						local Head = v280.Character:FindFirstChild("Head") or v280.Character:FindFirstChild("HumanoidRootPart")

						ipairs_ = v280.Character

						local Humanoid = ipairs_:FindFirstChild("Humanoid")

						if Head then
							if Humanoid then
								Humanoid = Humanoid.Health > 0
							end
						else
							Humanoid = Head
						end

						if Humanoid then
							local v285

							ipairs_, v285 = CurrentCamera:WorldToViewportPoint(Head.Position)

							if v285 then
								v285 = ipairs_.Z > 0
							end

							if v285 then
								Magnitude = (Vector2.new(ipairs_.X, ipairs_.Y) - vector2).Magnitude

								if Magnitude < n6 then
									ipairs_ = Magnitude
								else
									v280 = v279
									ipairs_ = Magnitude
									Magnitude = n6
								end
							else
								v280 = v279
								Magnitude = n6
							end
						else
							v280 = v279
							Magnitude = n6
						end
					else
						v280 = v279
						Magnitude = n6
					end

					v279 = v280
					n6 = Magnitude
				end

				local DroppedItems = Workspace:FindFirstChild("DroppedItems")

				if DroppedItems then
					local GetChildren = DroppedItems.GetChildren

					for _, v in ipairs(GetChildren(DroppedItems)) do
						local isModel = v:IsA("Model")

						if isModel then
							isModel = v.FindFirstChild(v, "Humanoid")

							if isModel then
								isModel = v:FindFirstChild("Head")
							end
						end

						if isModel then
							local v291, v292 = CurrentCamera:WorldToViewportPoint(v.Head.Position)

							if v292 then
								v292 = v291.Z > 0
							end

							if v292 then
								local Magnitude = (Vector2.new(v291.X, v291.Y) - vector2).Magnitude

								if Magnitude < n6 then
									v279 = v
									n6 = Magnitude
								end
							end
						end
					end
				end

				if v279 then
					u270 = v279
					n5 = tick()
				elseif tick() - n5 < 3 then
					v279 = u270
				else
					u270 = nil
				end

				if not v279 then
					TextLabel4.Text = "No Target In Range"
					TextLabel5.Text = "Aim at player or corpse to inspect"
					TextLabel6.Text = "IDLE"
					TextLabel6.TextColor3 = t1.colorTextDim
					UIStroke5.Color = t1.colorStroke
					ImageLabel.Visible = false
					TextLabel3.Visible = true
					TextLabel3.Text = "👤"
					TextLabel2.Text = "$0"
					TextLabel9.Text = "0 items"
					TextLabel10.Visible = true
					TextLabel10.Text = "Aim at a player or corpse to view items."

					for i = 1, 12 do
						t19[i].img.Visible = false
						t19[i].sub.Text = ""
						t19[i].stroke.Color = t1.colorStroke

						if t19[i].badge then
							local badge = t19[i].badge
							local s3 = "Text"
							local label = t13[i]

							if label then
								label = t13[i].label
							end

							badge[s3] = label or ""
							t19[i].badge.TextColor3 = t1.colorTextDim
						end
					end

					for i = 1, 60 do
						t20[i].cell.Visible = false
					end

					return
				end

				local v299 = false
				local Name = v279.Name
				local n7 = 0
				local Character = p15.Character

				if Character then
					Character = Character:FindFirstChild("HumanoidRootPart")
				end

				local Players2

				if v279:IsA("Player") then
					Players2 = ReplicatedStorage:FindFirstChild("Players")

					if Players2 then
						Players2 = ReplicatedStorage.Players:FindFirstChild(v279.Name)
					end

					if Players2 then
						Players2 = Players2:FindFirstChild("Inventory")
					end

					local Character2 = v279.Character

					if Character2 then
						Character2 = v279.Character:FindFirstChild("HumanoidRootPart") and Character
					end

					if Character2 then
						local Magnitude = (v279.Character.HumanoidRootPart.Position - Character.Position).Magnitude

						n7 = math.floor(Magnitude)
					end

					TextLabel6.Text = "PLAYER"
					TextLabel6.TextColor3 = t1.colorOn
					UIStroke5.Color = t1.colorOn
					task.spawn(function()
						local function v306()
							return Players:GetUserThumbnailAsync(v279.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
						end

						local ok, image = pcall(v306)

						if not (ok and image) then
							return
						end

						ImageLabel.Image = image
						ImageLabel.Visible = true
						TextLabel3.Visible = false
					end)
				else
					v299 = true
					Players2 = v279:FindFirstChild("Inventory")

					local Head = v279:FindFirstChild("Head") or v279:FindFirstChild("HumanoidRootPart")

					if Head and Character then
						local Magnitude = (Head.Position - Character.Position).Magnitude

						n7 = math.floor(Magnitude)
					end

					TextLabel6.Text = "CORPSE"
					TextLabel6.TextColor3 = Color3.fromRGB(255, 120, 120)
					UIStroke5.Color = Color3.fromRGB(255, 80, 80)
					ImageLabel.Visible = false
					TextLabel3.Visible = true
					TextLabel3.Text = "💀"
				end

				TextLabel4.Text = Name
				TextLabel5.Text = (v299 and "[CORPSE] • " or v299 or "[ALIVE] • ") .. tostring(n7) .. " studs"

				if not Players2 then
					TextLabel10.Visible = true
					TextLabel10.Text = "Inventory data not yet replicated."

					return
				end

				local v311 = ReplicatedStorage
				local v312 = v311.FindFirstChild(v311, "ItemsList")
				local n8 = 0
				local t21 = {}
				local t22 = {}
				local n9 = 0

				for _, child in ipairs(Players2.GetChildren(Players2)) do
					local Name2 = child.Name
					local v320 = tostring(Name2)
					local v321 = v320:lower()
					local attribute = child:GetAttribute("Slot") or ""
					local v323 = tostring(attribute):lower()
					local ItemProperties

					if v312 then
						ItemProperties = v312:FindFirstChild(v320)
					else
						ItemProperties = v312
					end

					if ItemProperties then
						ItemProperties = ItemProperties:FindFirstChild("ItemProperties")
					end

					local ItemIcon

					if ItemProperties then
						ItemIcon = ItemProperties:FindFirstChild("ItemIcon")

						if ItemIcon then
							ItemIcon = ItemProperties.ItemIcon.Image
						end
					else
						ItemIcon = ItemProperties
					end

					local v326 = child:FindFirstChild("Attachments") and #child.Attachments:GetChildren() or 0
					local v327 = child:FindFirstChild("Inventory") ~= nil
					local v328 = v323:find("clothing") ~= nil
					local v329 = nil
					local n10 = 99
					local colorStrokeLight = t1.colorStrokeLight
					local colorTextDim = t1.colorTextDim

					if v328 then
						if v323:find("backpack") or (v323.find(v323, "bag") or (v323:find("pack") or (v321:find("backpack") or (v321:find("bag") or (v321.find(v321, "pack") or (v321:find("rucksack") or (v321:find("satchel") or (v321:find("duffle") or (v321:find("berkut") or (v321:find("trizip") or (v321:find("pilgrim") or (v321:find("attack") or (v321.find(v321, "scavbag") or (v321:find("daypack") or (v321:find("t20") or (v321:find("beta2") or (v321:find("f5") or (v321:find("paratus") or v321:find("ryukzak"))))))))))))))))))) then
							colorStrokeLight = t1.colorStrokeLight
							colorTextDim = Color3.fromRGB(140, 210, 255)
							v329 = "BAG"
							n10 = 50
						else
							local v333 = not v327

							if v333 then
								v333 = v323 == "headgear" or (v323:find("head") or (v323:find("helm") or (v321.find(v321, "helm") or (v321:find("altyn") or (v321:find("kiver") or (v321:find("sfera") or (v321:find("sphera") or (v321:find("6b47") or (v321:find("zsh") or (v321:find("maska") or (v321:find("vityaz") or (v321:find("ops%-core") or (v321:find("opscore") or (v321:find("mich") or (v321:find("shlem") or (v321:find("ssh") or (v321:find("fast_") or (v321.find(v321, "fast mt") or (v321:find("fastmt") or (v321:find("cap_") or (v321:find("hat_") or (v321:find("beret") or (v321:find("beanie") or (v321:find("ushanka") or (v321:find("panama") or (v321:find("boonie") or v321:find("bandana")))))))))))))))))))))))))))
							end

							if v333 then
								local v334 = v326 > 0

								v329 = "HELM"
								n10 = 30

								if v334 then
									v334 = t1.colorOn
								end

								colorStrokeLight = v334 or t1.colorStrokeLight
								colorTextDim = Color3.fromRGB(100, 220, 255)
							else
								local v335 = not v327

								if v335 then
									v335 = v323:find("mask") or (v323:find("face") or (v321:find("mask") or (v321:find("pmk") or (v321:find("gp5") or (v321:find("gp%-5") or (v321:find("respirator") or (v321:find("balaclava") or (v321:find("gasmask") or (v321:find("goggles") or (v321:find("glasses") or v321:find("shemagh")))))))))))
								end

								if v335 then
									v329 = "MASK"

									local v336 = v326 > 0

									n10 = 60

									if v336 then
										v336 = t1.colorOn
									end

									colorStrokeLight = v336 or t1.colorStrokeLight
									colorTextDim = Color3.fromRGB(200, 180, 255)
								else
									local v337 = v323 == "armor"

									if not v337 then
										v337 = v323 == "vest"

										if not v337 then
											v337 = v323:find("armor")

											if not v337 then
												v337 = v323:find("body")

												if not v337 then
													v337 = v321:find("armor")

													if not v337 then
														v337 = v321:find("defender")

														if not v337 then
															v337 = v321:find("trooper")

															if not v337 then
																v337 = v321:find("paca")

																if not v337 then
																	v337 = v321:find("6b43")

																	if not v337 then
																		v337 = v321:find("6b23")

																		if not v337 then
																			v337 = v321:find("6b13")

																			if not v337 then
																				v337 = v321:find("zhuk")

																				if not v337 then
																					v337 = v321:find("plate")

																					if not v337 then
																						v337 = v321:find("carrier")

																						if not v337 then
																							v337 = v321:find("korund")

																							if not v337 then
																								v337 = v321.find(v321, "slick")

																								if not v337 then
																									v337 = v321:find("iotv")

																									if not v337 then
																										v337 = v321:find("gen4")

																										if not v337 then
																											v337 = v321:find("redut")

																											if not v337 then
																												v337 = v321:find("fort")

																												if not v337 then
																													v337 = v321:find("gzhel")

																													if not v337 then
																														v337 = v321:find("thor")

																														if not v337 then
																															v337 = v321:find("bronik")

																															if not v337 then
																																v337 = v321:find("vest")

																																if v337 then
																																	v337 = not v321:find("chestrig")
																																end
																															end
																														end
																													end
																												end
																											end
																										end
																									end
																								end
																							end
																						end
																					end
																				end
																			end
																		end
																	end
																end
															end
														end
													end
												end
											end
										end
									end

									if v337 then
										colorStrokeLight = t1.colorStrokeLight
										colorTextDim = Color3.fromRGB(120, 200, 255)
										v329 = "VEST"
										n10 = 40
									elseif v323:find("rig") or (v323:find("belt") or (v321:find("rig") or (v321:find("chestrig") or (v321:find("warbelt") or (v321:find("belt") or (v321:find("tarzan") or (v321:find("alpha") or (v321:find("triton") or (v321:find("d3cr") or (v321:find("haley") or (v321:find("mk3") or (v321:find("commando") or (v321:find("chicom") or (v321:find("banker") or (v321.find(v321, "azimut") or (v321:find("sobr") or (v321:find("pouch") or (v321:find("pocket") or v321:find("razgruz"))))))))))))))))))) then
										if v321:find("pouch") or v321:find("pocket") then
											colorTextDim = Color3.fromRGB(180, 220, 180)
											v329 = "PCH"
											n10 = 58
										else
											colorTextDim = Color3.fromRGB(150, 220, 200)
											v329 = "RIG"
											n10 = 55
										end

										colorStrokeLight = t1.colorStrokeLight
									else
										colorStrokeLight = t1.colorStrokeLight
										colorTextDim = t1.colorTextDim
										v329 = "GEAR"
										n10 = 70
									end
								end
							end
						end
					elseif v323:find("holster") or (v323:find("pistol") or (v323:find("melee") or (v321:find("knife") or (v321.find(v321, "axe") or (v321:find("crowbar") or (v321:find("hatchet") or (v321:find("machete") or (v321:find("bayonet") or (v321.find(v321, "glock") or (v321:find("makarov") or (v321:find("stechkin") or (v321:find("beretta") or (v321:find("colt") or (v321:find("deagle") or (v321:find("revolver") or (v321:find("grach") or (v321:find("pl%-15") or (v321:find("p226") or (v321.find(v321, "usp") or (v321 == "pm" or (v321 == "tt" and true or v321 == "aps"))))))))))))))))))))) then
						colorStrokeLight = t1.colorOn
						colorTextDim = Color3.fromRGB(255, 200, 80)
						v329 = "HOL"
						n10 = 25
					elseif v323:find("sec") or v323 == "slot2" then
						colorStrokeLight = t1.colorOn
						colorTextDim = t1.colorOn
						v329 = "SEC"
						n10 = 20
					elseif v323:find("pri") or v323 == "slot1" then
						colorStrokeLight = t1.colorOn
						colorTextDim = t1.colorOn
						v329 = "PRI"
						n10 = 10
					elseif child:FindFirstChild("Attachments") or (child:GetAttribute("Recoil") or child:GetAttribute("MuzzleVelocity")) then
						n8 = n8 + 1

						if n8 == 1 then
							n10 = 10
							v329 = "PRI"
						elseif n8 == 2 then
							n10 = 20
							v329 = "SEC"
						else
							n10 = 25
							v329 = "HOL"
						end

						colorStrokeLight = t1.colorOn
						colorTextDim = t1.colorOn
					end

					if v329 then
						table.insert(t22, {
							cat = v329,
							sortPriority = n10,
							name = v320,
							icon = ItemIcon,
							attCount = v326,
							strokeCol = colorStrokeLight,
							badgeCol = colorTextDim
						})
					end

					local Inventory = child:FindFirstChild("Inventory")
					local v339

					if Inventory then
						v339 = child.Name ~= "KeyChain"
					else
						v339 = Inventory
					end

					if v339 then
						for _, child2 in ipairs(Inventory.GetChildren(Inventory)) do
							local Child2Name

							if v312 then
								Child2Name = v312:FindFirstChild(child2.Name)
							else
								Child2Name = v312
							end

							local ItemProperties2

							if Child2Name then
								ItemProperties2 = Child2Name:FindFirstChild("ItemProperties")

								if ItemProperties2 then
									ItemProperties2 = Child2Name.ItemProperties:FindFirstChild("ItemIcon")

									if ItemProperties2 then
										ItemProperties2 = Child2Name.ItemProperties.ItemIcon.Image
									end
								end
							else
								ItemProperties2 = Child2Name
							end

							local n11 = 0
							local attribute2 = child2:GetAttribute("Amount") or 1

							if child2.Name == "Rubles" then
								n11 = attribute2
							else
								local ItemProperties3

								if Child2Name then
									ItemProperties3 = Child2Name:FindFirstChild("ItemProperties")
								else
									ItemProperties3 = Child2Name
								end

								if ItemProperties3 then
									n11 = Child2Name.ItemProperties:GetAttribute("Price") or 1

									local attribute3 = Child2Name.ItemProperties:GetAttribute("ItemType") or ""

									if n11 >= 10 then
										if attribute3 == "Extra" then
											n11 = n11 * 0.4
										elseif attribute3 == "Ammo" then
											n11 = n11 * attribute2 * 0.7
										elseif attribute3 == "Clothing" then
											n11 = n11 * 0.35
										elseif attribute3 == "Medical" then
											n11 = n11 * 0.75
										elseif attribute3 == "Barter" then
											n11 = n11 * 0.4
										end
									end
								end
							end

							n9 = n9 + n11
							table.insert(t21, {
								name = child2.Name,
								amount = attribute2,
								icon = ItemProperties2,
								price = math.floor(n11)
							})
						end
					end
				end

				TextLabel2.Text = "$" .. v266(n9)

				local v348 = TextLabel9
				local v349 = #t21

				v348.Text = tostring(v349) .. " items"
				table.sort(t22, function(p18, p19)
					return p18.sortPriority < p19.sortPriority
				end)

				for i = 1, 12 do
					local v351 = t19[i]
					local v352 = t22[i]

					if v352 then
						v351.badge.Text = v352.cat
						v351.badge.TextColor3 = v352.badgeCol

						local icon = v352.icon

						if icon then
							icon = v352.icon ~= ""
						end

						if icon then
							v351.img.Image = v352.icon
							v351.img.Visible = true
						else
							v351.img.Visible = false
							v351.img.Image = ""
						end

						local sub = v351.sub
						local s4 = "Text"
						local v356 = v352.attCount > 0

						if v356 then
							local attCount = v352.attCount

							v356 = "+" .. tostring(attCount)
						end

						sub[s4] = v356 or ""
						v351.stroke.Color = v352.strokeCol
					else
						local badge = v351.badge
						local s5 = "Text"
						local label = t13[i]

						if label then
							label = t13[i].label
						end

						badge[s5] = label or ""
						v351.badge.TextColor3 = t1.colorTextDim
						v351.img.Visible = false
						v351.img.Image = ""
						v351.sub.Text = ""
						v351.stroke.Color = t1.colorStroke
					end
				end

				if #t21 == 0 then
					TextLabel10.Visible = true
					TextLabel10.Text = "No items in backpack or containers."

					for i = 1, 60 do
						t20[i].cell.Visible = false
					end
				else
					TextLabel10.Visible = false

					for i = 1, 60 do
						local v363 = t21[i]
						local v364 = t20[i]

						if v363 then
							v364.cell.Visible = true

							if v363.icon then
								v364.img.Image = v363.icon
								v364.img.Visible = true
							else
								v364.img.Visible = false
							end

							local amount = v363.amount

							if amount then
								amount = v363.amount > 1
							end

							if amount then
								if v363.amount >= 1000 then
									local qty = v364.qty
									local v367 = v363.amount / 1000

									qty.Text = math.floor(v367) .. "K"
								else
									local qty = v364.qty
									local amount2 = v363.amount

									qty.Text = "x" .. tostring(amount2)
								end
							else
								v364.qty.Text = ""
							end
						else
							v364.cell.Visible = false
						end
					end
				end
			end)

			local Visible = Frame

			if Visible then
				Visible = Frame.Visible
			end

			if Visible then
				task.wait(0.12)
			else
				task.wait(0.2)
			end
		end
	end)

	return Frame
end

local v371 = nil

local function v372()
	local value1 = 8795350
	local LocalPlayer = Players

	if LocalPlayer then
		LocalPlayer = Players.LocalPlayer
	end

	local t24 = {
		value1 = LocalPlayer
	}

	while not t24.value1 do
		value1 = task.wait
		value1(0.1)

		if Players then
			value1 = Players.LocalPlayer
			t24.value1 = value1
		end
	end

	v35()
	LocalPlayer = v35()
	t24.value2 = nil

	local function v377()
		t24.value2 = gethui and gethui() or CoreGui
	end

	pcall(v377)

	if not t24.value2 then
		return
	end

	v377 = function(p20)
		if not p20 then
			return
		end

		pcall(function()
			local v379 = p20

			for _, child in ipairs(v379.GetChildren(v379)) do
				if child:IsA("ScreenGui") then
					local v382 = false

					for _, descendant in ipairs(child:GetDescendants()) do
						local isTextLabel = descendant:IsA("TextLabel")

						if isTextLabel then
							isTextLabel = descendant.Text == "NextGen"

							if not isTextLabel then
								local find = string.find
								local Text = descendant.Text

								isTextLabel = find(tostring(Text), "KILLS:")

								if not isTextLabel then
									local find2 = string.find
									local Text2 = descendant.Text

									isTextLabel = find2(tostring(Text2), "BOSS TRACKER")

									if not isTextLabel then
										local find3 = string.find
										local Text3 = descendant.Text

										isTextLabel = find3(tostring(Text3), "INVENTORY CHECKER")
									end
								end
							end
						end

						if isTextLabel then
							v382 = true

							break
						end
					end

					if v382 then
						child:Destroy()
					end
				end
			end
		end)
	end
	v377(t24.value2)

	local v392 = CoreGui

	if v392 then
		v392 = CoreGui ~= t24.value2
	end

	if v392 then
		v377(CoreGui)
	end

	local t25 = {
		value1 = {},
		value2 = 17.4,
		value3 = 9,
		value4 = false,
		value5 = {}
	}

	for _, v in ipairs(t10) do
		t25.value5[v.tag] = v.default
	end

	t25.value6 = {}

	local function v395(p21)
		if not t25.value6[p21] then
			return
		end

		local v396 = t25.value6[p21]

		t25.value6[p21] = nil

		local function v397(p22)
			if not p22 then
				return
			end

			pcall(function()
				if p22.Remove then
					p22:Remove()

					return
				end

				if not p22.Destroy then
					return
				end

				p22:Destroy()
			end)
		end

		v397(v396.Box)
		v397(v396.Name)
		v397(v396.HealthBg)
		v397(v396.HealthBar)
		v397(v396.HealthText)
	end

	function t25.value7(p23)
		if not p23 or p23 == t24.value1 then
			return
		end

		if t25.value6[p23] then
			v395(p23)
		end

		if not (Drawing and Drawing.new) then
			return
		end

		pcall(function()
			local Square = Drawing.new("Square")

			Square.Visible = false
			Square.Color = Color3.fromRGB(0, 255, 0)
			Square.Thickness = 1
			Square.Filled = false
			Square.Transparency = 1
			pcall(function()
				Square.ZIndex = 1
			end)

			local Text = Drawing.new("Text")

			Text.Visible = false
			Text.Color = Color3.fromRGB(240, 245, 255)
			Text.Size = 15
			Text.Center = true
			Text.Outline = true
			pcall(function()
				Text.ZIndex = 2
			end)

			local Square2 = Drawing.new("Square")

			Square2.Visible = false
			Square2.Color = Color3.fromRGB(0, 0, 0)
			Square2.Filled = true
			Square2.Thickness = 1
			Square2.Transparency = 1
			pcall(function()
				Square2.ZIndex = 1
			end)

			local Square3 = Drawing.new("Square")

			Square3.Visible = false
			Square3.Color = Color3.fromRGB(0, 255, 0)
			Square3.Filled = true
			Square3.Thickness = 1
			Square3.Transparency = 1
			pcall(function()
				Square3.ZIndex = 2
			end)

			local Text2 = Drawing.new("Text")

			Text2.Visible = false
			Text2.Color = Color3.fromRGB(255, 255, 255)
			Text2.Size = 14
			Text2.Center = true
			Text2.Outline = true
			pcall(function()
				Text2.ZIndex = 2
			end)
			t25.value6[p23] = {
				Box = Square,
				Name = Text,
				HealthBg = Square2,
				HealthBar = Square3,
				HealthText = Text2
			}
		end)
	end

	local UIGradient = t1

	v392 = t1.padding + 7.5 * (t1.rowHeight + t1.rowGap) + t1.padding
	t25.value8 = UIGradient.titleH + t1.tabBarH + v392 + t1.statusH + 3
	t25.value9 = {}
	t25.value10 = false
	t25.value11 = {}
	t25.value12 = {}
	t25.value13 = {}
	t25.value14 = {}
	t25.value15 = {}
	t25.value16 = {}
	t25.value17 = nil
	t25.value18 = nil
	t25.value19 = nil
	t25.value20 = nil
	t25.value21 = nil
	t25.value22 = nil
	t25.value23 = nil
	t25.value24 = nil
	UIGradient, v392, v377 = ipairs(t2)

	local function v404()
		for _, v in pairs(t25.value6) do
			pcall(function()
				if v.Box then
					v.Box.Visible = false
				end

				if v.Name then
					v.Name.Visible = false
				end

				if v.HealthBg then
					v.HealthBg.Visible = false
				end

				if v.HealthBar then
					v.HealthBar.Visible = false
				end

				if not v.HealthText then
					return
				end

				v.HealthText.Visible = false
			end)
		end
	end

	while true do
		v377, v1046 = UIGradient(v392, v377)

		if not v377 then
			break
		end

		t25.value9[v1046.tag] = v1046.default
	end

	local UICorner

	UICorner, UIGradient, v392 = ipairs(t3)

	while true do
		v392, v377 = UICorner(UIGradient, v392)

		if not v392 then
			break
		end

		t25.value9[v377.tag] = v377.default
	end

	UICorner, UIGradient, v392 = ipairs(t4)

	while true do
		v392, v377 = UICorner(UIGradient, v392)

		if not v392 then
			break
		end

		t25.value9[v377.tag] = v377.default
	end

	UICorner, UIGradient, v392 = ipairs(t5)

	while true do
		v392, v377 = UICorner(UIGradient, v392)

		if not v392 then
			break
		end

		t25.value9[v377.tag] = v377.default
	end

	UICorner, UIGradient, v392 = ipairs(t6)

	while true do
		v392, v377 = UICorner(UIGradient, v392)

		if not v392 then
			break
		end

		t25.value9[v377.tag] = v377.default
	end

	UICorner, UIGradient, v392 = ipairs(t7)

	while true do
		v392, v377 = UICorner(UIGradient, v392)

		if not v392 then
			break
		end

		t25.value9[v377.tag] = v377.default
	end

	t25.value9.AIMBOT_CIRCLE_SIZE = 150
	t25.value9.INF_JUMP_POWER = 25
	t25.value9.PLAYER_ESP_BOX = false
	t25.value9.PLAYER_ESP_DISTANCE = false
	t25.value9.PLAYER_ESP_HEALTH = false
	t25.value9.PLAYER_ESP_NAME = false

	for _, v in ipairs(t11) do
		t25.value9[v.tag] = v.default
	end

	t25.value25 = Instance.new("ScreenGui")
	t25.value25.Name = v35()
	t25.value25.ResetOnSpawn = false
	t25.value25.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	t25.value25.DisplayOrder = 999999999
	t25.value25.Parent = t24.value2
	t25.value26 = nil
	t25.value27 = nil
	t25.value28 = nil
	t25.value29 = nil
	t25.value30 = false

	function t25.value31()
		if not t25.value29 then
			return false
		end

		if UserInputService:GetFocusedTextBox() then
			return false
		end

		local u410 = false

		pcall(function()
			local value29 = t25.value29

			if typeof(value29) ~= "EnumItem" then
				return
			end

			local EnumType = t25.value29.EnumType
			local v413 = tostring(EnumType)

			if v413 == "Enum.KeyCode" and true or v413 == "KeyCode" then
				u410 = UserInputService:IsKeyDown(t25.value29)

				return
			end

			if not (v413 == "Enum.UserInputType" and true or v413 == "UserInputType") then
				return
			end

			u410 = UserInputService:IsMouseButtonPressed(t25.value29)
		end)

		return u410 or t25.value30
	end

	t25.value32 = nil
	t25.value33 = false
	t25.value34 = false
	t25.value35 = nil

	local function v414()
		local Players2 = ReplicatedStorage:FindFirstChild("Players")
		local Settings, Settings2

		if not Players2 then
			if Players2 then
				Settings = Players2:FindFirstChild("Settings")
			else
				Settings = Players2
			end

			if Settings then
				Settings2 = Players2.Settings

				return Settings2.FindFirstChild(Settings2, "GameplaySettings")
			else
				return nil
			end
		end

		Players2 = ReplicatedStorage.Players:FindFirstChild(t24.value1.Name)

		if Players2 then
			Settings = Players2:FindFirstChild("Settings")
		else
			Settings = Players2
		end

		if Settings then
			Settings2 = Players2.Settings

			return Settings2.FindFirstChild(Settings2, "GameplaySettings")
		else
			return nil
		end
	end
	local function v418(p24)
		pcall(function()
			local v419 = v414()

			if not v419 then
				return
			end

			local attribute = v419:GetAttribute("DefaultFOV")
			local v421

			if attribute then
				if attribute > 30 then
					v421 = not t25.value35
				else
					v421 = false
				end
			else
				v421 = attribute
			end

			if v421 then
				t25.value35 = attribute
			end

			v419:SetAttribute("DefaultFOV", p24)
		end)

		local function v422()
			local CurrentCamera = Workspace.CurrentCamera

			if not CurrentCamera then
				return
			end

			local v424

			if CurrentCamera.FieldOfView > 30 then
				v424 = not t25.value35
			else
				v424 = false
			end

			if v424 then
				t25.value35 = CurrentCamera.FieldOfView
			end

			CurrentCamera.FieldOfView = p24
		end

		pcall(v422)
	end
	local function v425()
		if not t25.value32 then
			return false
		end

		if UserInputService:GetFocusedTextBox() then
			return false
		end

		local u426 = nil

		local function v427()
			local value32 = t25.value32

			if typeof(value32) ~= "EnumItem" then
				return
			end

			local EnumType = t25.value32.EnumType
			local v430 = tostring(EnumType)

			if v430 == "Enum.KeyCode" and true or v430 == "KeyCode" then
				u426 = UserInputService:IsKeyDown(t25.value32)

				return
			end

			if not (v430 == "Enum.UserInputType" and true or v430 == "UserInputType") then
				return
			end

			u426 = UserInputService:IsMouseButtonPressed(t25.value32)
		end

		u426 = false
		pcall(v427)

		return u426 or t25.value33
	end

	t25.value36 = Instance.new("Frame")
	t25.value36.Name = v35()
	t25.value36.Size = UDim2.new(0, t1.width, 0, t25.value8)
	t25.value36.Position = UDim2.new(0.5, -t1.width / 2, 0.5, -t25.value8 / 2)
	t25.value36.BackgroundColor3 = t1.colorBg
	t25.value36.BorderSizePixel = 0
	t25.value36.Active = true
	t25.value36.Draggable = false
	t25.value36.ClipsDescendants = true
	t25.value36.Parent = t25.value25
	UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 14)
	UICorner.Parent = t25.value36
	UICorner = Instance.new("UIStroke")

	local t23 = {
		value1 = v35()
	}

	UICorner.Name = t23.value1
	UICorner.Thickness = 1.2
	t23.value1 = Color3.fromRGB(255, 255, 255)
	UICorner.Color = t23.value1
	UICorner.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UICorner.Parent = t25.value36
	UIGradient = Instance.new("UIGradient")
	t23.value1 = ColorSequence.new
	t23.value3 = { ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 240, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(45, 135, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 75, 255)) }
	t23.value2 = t23.value1(t23.value3)
	UIGradient.Color = t23.value2
	UIGradient.Rotation = 45
	UIGradient.Parent = UICorner
	t23.value1 = Instance.new("Frame")
	t23.value3 = v35()
	t23.value1.Name = t23.value3
	t23.value3 = UDim2.new(1, 0, 0, t1.titleH)
	t23.value1.Size = t23.value3
	t23.value2 = UDim2.new
	t23.value3 = t23.value2(0, 0, 0, 0)
	t23.value1.Position = t23.value3
	t23.value2 = t1.colorBar
	t23.value1.BackgroundColor3 = t23.value2
	t23.value1.BorderSizePixel = 0
	t23.value1.Parent = t25.value36
	t23.value2 = Instance.new("UICorner")
	UICorner = UDim.new(0, 14)
	t23.value2.CornerRadius = UICorner
	t23.value2.Parent = t23.value1
	t23.value3 = Instance.new("Frame")
	t25.value37 = t23.value3
	t25.value37.Name = v35()
	t25.value37.Size = UDim2.new(1, 0, 0, 14)
	t25.value37.Position = UDim2.new(0, 0, 1, -14)
	t25.value37.BackgroundColor3 = t1.colorBar
	t25.value37.BorderSizePixel = 0
	t25.value37.ZIndex = 1
	t25.value37.Parent = t23.value1
	t23.value3 = Instance.new("Frame")
	t25.value38 = t23.value3
	t25.value38.Name = v35()
	t25.value38.Size = UDim2.new(1, 0, 0, 1)
	t25.value38.Position = UDim2.new(0, 0, 0, t1.titleH)
	t25.value38.BackgroundColor3 = t1.colorDivider
	t25.value38.BorderSizePixel = 0
	t25.value38.ZIndex = 2
	t25.value38.Parent = t25.value36
	v39(t23.value1, t25.value36)
	t23.value3 = Instance.new("Frame")
	UICorner = v35()
	t23.value3.Name = UICorner
	UICorner = UDim2.new(0, 8, 0, 8)
	t23.value3.Size = UICorner
	UICorner = UDim2.new(0, 14, 0.5, -4)
	t23.value3.Position = UICorner
	UICorner = t1.colorOn
	t23.value3.BackgroundColor3 = UICorner
	t23.value3.BorderSizePixel = 0
	t23.value3.Parent = t23.value1
	UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = t23.value3
	UICorner = Instance.new("TextLabel")
	UICorner.Name = v35()
	UICorner.Size = UDim2.new(0, 70, 1, 0)
	UICorner.Position = UDim2.new(0, 28, 0, 0)
	UICorner.BackgroundTransparency = 1
	UICorner.Text = t1.title
	UICorner.TextColor3 = t1.colorText
	UICorner.TextSize = 16
	UICorner.Font = Enum.Font.GothamBold
	UICorner.TextXAlignment = Enum.TextXAlignment.Left
	UICorner.Parent = t23.value1
	UICorner = Instance.new("Frame")
	UICorner.Name = v35()
	UICorner.Size = UDim2.new(0, 36, 0, 18)
	UICorner.Position = UDim2.new(0, 100, 0.5, -9)
	UICorner.BackgroundColor3 = t1.colorRow
	UICorner.BorderSizePixel = 0
	UICorner.Parent = t23.value1
	UIGradient = Instance.new("UICorner")
	UIGradient.CornerRadius = UDim.new(0, 5)
	UIGradient.Parent = UICorner
	UIGradient = Instance.new("UIStroke")
	UIGradient.Thickness = 1
	UIGradient.Color = t1.colorStroke
	UIGradient.Parent = UICorner
	UIGradient = Instance.new("TextLabel")
	UIGradient.Name = v35()
	UIGradient.Size = UDim2.new(1, 0, 1, 0)
	UIGradient.BackgroundTransparency = 1
	UIGradient.Text = "v2.1"
	UIGradient.TextColor3 = t1.colorOn
	UIGradient.TextSize = 10
	UIGradient.Font = Enum.Font.GothamBold
	UIGradient.Parent = UICorner
	UICorner = Instance.new("Frame")
	UICorner.Name = v35()
	UICorner.Size = UDim2.new(0, 56, 0, 20)
	UICorner.Position = UDim2.new(1, -104, 0.5, -10)
	UICorner.BackgroundColor3 = t1.colorBg
	UICorner.BorderSizePixel = 0
	UICorner.Parent = t23.value1
	UIGradient = Instance.new("UICorner")
	UIGradient.CornerRadius = UDim.new(0, 5)
	UIGradient.Parent = UICorner
	UIGradient = Instance.new("UIStroke")
	UIGradient.Thickness = 1
	UIGradient.Color = t1.colorStroke
	UIGradient.Parent = UICorner
	UIGradient = Instance.new("TextLabel")
	UIGradient.Name = v35()
	UIGradient.Size = UDim2.new(1, 0, 1, 0)
	UIGradient.BackgroundTransparency = 1
	UIGradient.Text = "RSHIFT"
	UIGradient.TextColor3 = t1.colorTextDim
	UIGradient.TextSize = 9
	UIGradient.Font = Enum.Font.GothamBold
	UIGradient.Parent = UICorner
	t25.value39 = Instance.new("TextButton")
	t25.value39.Name = v35()
	t25.value39.Size = UDim2.new(0, 28, 0, 28)
	t25.value39.Position = UDim2.new(1, -40, 0.5, -14)
	t25.value39.BackgroundColor3 = t1.colorBtn
	t25.value39.Text = "▲"
	t25.value39.TextColor3 = t1.colorText
	t25.value39.TextSize = 12
	t25.value39.Font = Enum.Font.GothamBold
	t25.value39.BorderSizePixel = 0
	t25.value39.AutoButtonColor = false
	t25.value39.Parent = t23.value1
	UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 7)
	UICorner.Parent = t25.value39
	t25.value40 = Instance.new("UIStroke")
	t25.value40.Thickness = 1
	t25.value40.Color = t1.colorStroke
	t25.value40.Parent = t25.value39
	t25.value39.MouseEnter:Connect(function()
		local v431 = TweenService
		local value39 = t25.value39
		local v433 = tweenInfo
		local v434 = t1

		v431.Create(v431, value39, v433, {
			BackgroundColor3 = v434.colorBtnHover
		}):Play()
		TweenService:Create(t25.value40, tweenInfo, {
			Color = t1.colorStrokeLight
		}):Play()
	end)
	t25.value39.MouseLeave:Connect(function()
		local v435 = TweenService
		local value39 = t25.value39
		local v437 = tweenInfo
		local v438 = t1

		v435.Create(v435, value39, v437, {
			BackgroundColor3 = v438.colorBtn
		}):Play()

		local v439 = TweenService
		local value40 = t25.value40
		local v441 = tweenInfo
		local v442 = t1

		v439.Create(v439, value40, v441, {
			Color = v442.colorStroke
		}):Play()
	end)
	t25.value41 = Instance.new("Frame")
	t25.value41.Name = v35()
	t25.value41.Size = UDim2.new(1, 0, 0, t1.tabBarH)
	t25.value41.Position = UDim2.new(0, 0, 0, t1.titleH + 1)
	t25.value41.BackgroundColor3 = t1.colorBar
	t25.value41.BorderSizePixel = 0
	t25.value41.Parent = t25.value36
	UICorner = Instance.new("Frame")
	UICorner.Name = v35()
	UICorner.Size = UDim2.new(1, -16, 1, -8)
	UICorner.Position = UDim2.new(0, 8, 0, 4)
	UICorner.BackgroundColor3 = t1.colorBg
	UICorner.BorderSizePixel = 0
	UICorner.Parent = t25.value41
	UIGradient = Instance.new("UICorner")
	UIGradient.CornerRadius = UDim.new(0, 8)
	UIGradient.Parent = UICorner
	UIGradient = Instance.new("UIStroke")
	UIGradient.Thickness = 1
	UIGradient.Color = t1.colorStroke
	UIGradient.Parent = UICorner
	t25.value42 = {
		"ESP",
		"LOOT",
		"AIM",
		"MOVE",
		"WORLD"
	}
	t25.value43 = {}
	t25.value44 = {}

	local function v443()
		local value34 = t25.value9.ZOOM == true

		if not value34 then
			value34 = t25.value32

			if value34 then
				value34 = v425()
			end
		end

		if value34 == t25.value34 then
			return
		end

		t25.value34 = value34

		if t25.value34 then
			v418(10)

			return
		end

		v418(t25.value35 or 90)
	end

	for i, v in ipairs(t25.value42) do
		v1062 = Instance.new("TextButton")
		v1062.Name = v35()
		v1062.Size = UDim2.new(1 / #t25.value42, 0, 1, 0)
		v467 = UDim2.new
		v462 = t25.value42
		v1062.Position = v467((i - 1) / #v462, 0, 0, 0)
		v462 = "BackgroundColor3"
		v467 = i == 1

		if v467 then
			v467 = t1.colorTabBgActive
		end

		v1062[v462] = v467 or Color3.fromRGB(0, 0, 0)
		v1062.BackgroundTransparency = i == 1 and 0 or 1
		v1062.Text = v
		v462 = "TextColor3"
		v467 = i == 1

		if v467 then
			v467 = t1.colorTabActive
		end

		v1062[v462] = v467 or t1.colorTabInactive
		v1062.TextSize = 11
		v1062.Font = Enum.Font.GothamBold
		v1062.BorderSizePixel = 0
		v1062.Active = true
		v1062.ZIndex = 5
		v1062.AutoButtonColor = false
		v1062.Parent = UICorner
		v462 = Instance.new("UICorner")
		v462.CornerRadius = UDim.new(0, 6)
		v462.Parent = v1062
		t25.value43[i] = v1062
	end

	t25.value45 = Instance.new("Frame")
	t25.value45.Name = v35()
	t25.value45.Size = UDim2.new(1 / #t25.value42, -8, 0, 2)
	t25.value45.Position = UDim2.new(0, 4, 1, -3)
	t25.value45.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	t25.value45.BorderSizePixel = 0
	t25.value45.Active = false
	t25.value45.ZIndex = 10
	t25.value45.Parent = UICorner

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(1, 0)
	UICorner2.Parent = t25.value45
	UICorner2 = Instance.new("UIGradient")
	UICorner2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 240, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 150, 255)) })
	UICorner2.Parent = t25.value45
	t25.value46 = Instance.new("Frame")
	t25.value46.Name = v35()
	t25.value46.Size = UDim2.new(1, 0, 0, 1)
	t25.value46.Position = UDim2.new(0, 0, 0, t1.titleH + t1.tabBarH + 1)
	t25.value46.BackgroundColor3 = t1.colorDivider
	t25.value46.BorderSizePixel = 0
	t25.value46.Parent = t25.value36
	UICorner2 = t1.titleH + t1.tabBarH + 2

	for i, v in ipairs(t25.value42) do
		local ScrollingFrame = Instance.new("ScrollingFrame")

		ScrollingFrame.Name = v35()
		ScrollingFrame.Size = UDim2.new(1, 0, 1, -(UICorner2 + t1.statusH))
		ScrollingFrame.Position = UDim2.new(0, 0, 0, UICorner2)
		ScrollingFrame.BackgroundTransparency = 1
		ScrollingFrame.BorderSizePixel = 0
		ScrollingFrame.ScrollBarThickness = 3
		ScrollingFrame.ScrollBarImageColor3 = t1.colorOn
		ScrollingFrame.Active = true
		ScrollingFrame.ScrollingEnabled = true
		ScrollingFrame.Visible = i == 1
		ScrollingFrame.Parent = t25.value36

		local UIListLayout = Instance.new("UIListLayout")

		UIListLayout.Parent = ScrollingFrame
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, t1.rowGap)
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		v = Instance.new("UIPadding")
		v.Parent = ScrollingFrame
		v.PaddingTop = UDim.new(0, t1.padding)
		v.PaddingBottom = UDim.new(0, t1.padding)
		UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + t1.padding * 2)
		end)
		t25.value44[i] = ScrollingFrame
	end

	t25.value47 = Instance.new("Frame")
	t25.value47.Name = v35()
	t25.value47.Size = UDim2.new(1, 0, 0, t1.statusH)
	t25.value47.Position = UDim2.new(0, 0, 1, -t1.statusH)
	t25.value47.BackgroundColor3 = t1.colorStatusBg
	t25.value47.BorderSizePixel = 0
	t25.value47.Parent = t25.value36
	UICorner2 = Instance.new("UICorner")
	UICorner2.CornerRadius = UDim.new(0, 14)
	UICorner2.Parent = t25.value47
	UICorner2 = Instance.new("Frame")
	UICorner2.Name = v35()
	UICorner2.Size = UDim2.new(1, 0, 0, 14)
	UICorner2.Position = UDim2.new(0, 0, 0, 0)
	UICorner2.BackgroundColor3 = t1.colorStatusBg
	UICorner2.BorderSizePixel = 0
	UICorner2.ZIndex = 1
	UICorner2.Parent = t25.value47
	UICorner2 = Instance.new("Frame")
	UICorner2.Name = v35()
	UICorner2.Size = UDim2.new(1, 0, 0, 1)
	UICorner2.Position = UDim2.new(0, 0, 0, 0)
	UICorner2.BackgroundColor3 = t1.colorDivider
	UICorner2.BorderSizePixel = 0
	UICorner2.ZIndex = 2
	UICorner2.Parent = t25.value47
	UICorner2 = Instance.new("Frame")
	UICorner2.Name = v35()
	UICorner2.Size = UDim2.new(0, 6, 0, 6)
	UICorner2.Position = UDim2.new(0, 12, 0.5, -3)
	UICorner2.BackgroundColor3 = t1.colorOn
	UICorner2.BorderSizePixel = 0
	UICorner2.ZIndex = 2
	UICorner2.Parent = t25.value47

	local UICorner3 = Instance.new("UICorner")

	UICorner3.CornerRadius = UDim.new(1, 0)
	UICorner3.Parent = UICorner2
	t25.value48 = Instance.new("TextLabel")
	t25.value48.Name = v35()
	UICorner2 = t25.value48
	t23.value5 = "L\f="
	UICorner3 = UDim2.new
	t23.value5 = "gL\3"
	UICorner2.Size = UICorner3(0, 150, 1, 0)
	t25.value48.Position = UDim2.new(0, 24, 0, 0)
	UICorner2 = t25.value48
	t23.value5 = "$%\23 њ\194uk\249\198P\134r\""
	UICorner2.BackgroundTransparency = 1
	t25.value48.Text = "1 active features"
	t25.value48.TextColor3 = t1.colorStatusText
	t25.value48.TextSize = 10
	UICorner2 = t25.value48
	UICorner3 = Enum.Font
	t23.value5 = "R\16\255{U\197\4I\240\208"
	UICorner2.Font = UICorner3.GothamBold
	t25.value48.TextXAlignment = Enum.TextXAlignment.Left
	t25.value48.ZIndex = 2
	t25.value48.Parent = t25.value47
	t25.value49 = Instance.new("Folder")
	t25.value49.Name = LocalPlayer
	t25.value49.Parent = t25.value25
	t25.value50 = nil
	t25.value51 = nil
	UICorner2 = function()
		local v453, v454 = v90(t25.value25)

		t25.value50 = v453
		t25.value51 = v454
	end
	pcall(UICorner2)
	UICorner2 = function()
		t25.value26 = createFrame(t25.value25, t24.value1, t25.value9)
	end
	pcall(UICorner2)
	UICorner2 = function()
		t25.value27 = createFrame2(t25.value25, t25.value9)
	end
	pcall(UICorner2)
	pcall(function()
		t25.value28 = createFrame3(t25.value25, t24.value1, t25.value9)
	end)

	local function v455()
		local n12 = 0

		for k, _ in pairs(t8) do
			if t25.value9[k] == true then
				n12 = n12 + 1
			end
		end

		t25.value48.Text = tostring(n12) .. " active features"
	end

	v455()
	t25.value52 = 1

	local function v459(p25)
		if p25 ~= t25.value52 then
			t25.value52 = p25

			local _ = p25

			for i, v in ipairs(t25.value43) do
				local visible = i == p25
				local v464 = TweenService
				local v465 = tweenInfo
				local s6 = "TextColor3"
				local colorTabActive

				if visible then
					colorTabActive = t1.colorTabActive
				else
					colorTabActive = visible
				end

				local colorTabInactive = colorTabActive or t1.colorTabInactive
				local s7 = "BackgroundColor3"
				local colorTabBgActive

				if visible then
					colorTabBgActive = t1.colorTabBgActive
				else
					colorTabBgActive = visible
				end

				local color3 = colorTabBgActive or Color3.fromRGB(0, 0, 0)

				v464.Create(v464, v, v465, {
					[s6] = colorTabInactive,
					[s7] = color3,
					BackgroundTransparency = visible and 0 or 1
				}):Play()
				t25.value44[i].Visible = visible
			end

			local v472 = TweenService
			local value45 = t25.value45
			local v474 = tweenInfo2
			local uDim2New = UDim2.new
			local v476 = (p25 - 1) / #t25.value42

			v472.Create(v472, value45, v474, {
				Position = uDim2New(v476, 4, 1, -3)
			}):Play()
		end
	end

	for i, v in ipairs(t25.value43) do
		v.MouseEnter:Connect(function()
			if i == t25.value52 then
				return
			end

			TweenService:Create(v, tweenInfo, {
				BackgroundTransparency = 0.5,
				BackgroundColor3 = Color3.fromRGB(22, 26, 38),
				TextColor3 = Color3.fromRGB(200, 210, 235)
			}):Play()
		end)
		v1062 = v.MouseLeave

		function t23.value4()
			if i == t25.value52 then
				return
			end

			local v479 = TweenService
			local v480 = v
			local v481 = tweenInfo
			local Color3_ = Color3

			v479.Create(v479, v480, v481, {
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3_.fromRGB(0, 0, 0),
				TextColor3 = t1.colorTabInactive
			}):Play()
		end
		function t23.value6()
			v459(i)
		end

		v1062:Connect(t23.value4)
		t23.value4 = v
		v32(t23.value4, t23.value6)
	end

	function t25.value53(p26)
		if not p26 or p26.UserId == t24.value1.UserId then
			return false
		end

		if t25.value14[p26.UserId] ~= nil then
			return t25.value14[p26.UserId]
		end

		local function v483()
			return t24.value1:IsFriendsWith(p26.UserId)
		end

		local ok, result = pcall(v483)

		if ok then
			t25.value14[p26.UserId] = result

			return result
		else
			return false
		end
	end

	local function v486(p27)
		if not p27 then
			return nil
		end

		if t25.value12[p27] then
			return t25.value12[p27]
		end

		local Highlight = Instance.new("Highlight")

		Highlight.Name = v35()
		Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		Highlight.OutlineTransparency = t1.OUTLINE_TRANSPARENCY
		Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		Highlight.Parent = t25.value49
		t25.value12[p27] = Highlight

		local connection = nil

		connection = p27.AncestryChanged:Connect(function(_, parent)
			if parent then
				return
			end

			if t25.value12[p27] then
				local function v489()
					t25.value12[p27]:Destroy()
				end

				pcall(v489)
				t25.value12[p27] = nil
			end

			if p27:IsA("Model") then
				local Humanoid = p27:FindFirstChildOfClass("Humanoid")
				local v491

				if Humanoid then
					v491 = t25.value16[Humanoid]
				else
					v491 = Humanoid
				end

				if v491 then
					t25.value16[Humanoid]:Disconnect()
					t25.value16[Humanoid] = nil
				end

				t25.value15[p27] = nil
			end

			if t25.value13[p27] then
				local v492 = p27

				t25.value13[v492]:Disconnect()
				t25.value13[p27] = nil
			end

			if not connection then
				return
			end

			connection:Disconnect()
		end)
		t25.value13[p27] = connection

		return t25.value12[p27]
	end

	t25.value54 = nil

	function t25.value55(p28)
		if t25.value12[p28] then
			local function v493()
				t25.value12[p28]:Destroy()
			end

			pcall(v493)
			t25.value12[p28] = nil
		end

		if not t25.value13[p28] then
			return
		end

		t25.value13[p28]:Disconnect()
		t25.value13[p28] = nil
	end

	UICorner2 = function(p29)
		local function v494()
			if p29 == t24.value1 then
				return
			end

			local Character = p29.Character

			if not Character then
				return
			end

			if not Character:FindFirstChild("HumanoidRootPart") then
				return
			end

			local FRIEND_ESP = t25.value53(p29)
			local TEAM_COLOR, s8, v499, ENEMY_COLOR, s9, v502

			if FRIEND_ESP then
			elseif FRIEND_ESP then
				TEAM_COLOR = t1.TEAM_COLOR
				s8 = "FRIEND_ESP"

				if Character then
					if t25.value9[s8] then
						v499 = v486(Character)

						if v499 then
							v499.Adornee = Character
							v499.FillColor = TEAM_COLOR
							v499.FillTransparency = t1.FILL_TRANSPARENCY

							return
						else
							return
						end
					else
						t25.value55(Character)

						return
					end
				else
					return
				end
			elseif t25.value9.PLAYER_ESP then
				ENEMY_COLOR = t1.ENEMY_COLOR
				s9 = "PLAYER_ESP"

				if Character then
					if t25.value9[s9] then
						v502 = v486(Character)

						if v502 then
							v502.Adornee = Character
							v502.FillColor = ENEMY_COLOR
							v502.FillTransparency = t1.FILL_TRANSPARENCY

							return
						else
							return
						end
					else
						t25.value55(Character)

						return
					end
				else
					return
				end
			else
				t25.value55(Character)

				return
			end

			FRIEND_ESP = t25.value9.FRIEND_ESP

			if FRIEND_ESP then
				TEAM_COLOR = t1.TEAM_COLOR
				s8 = "FRIEND_ESP"

				if Character then
					if t25.value9[s8] then
						v499 = v486(Character)

						if v499 then
							v499.Adornee = Character
							v499.FillColor = TEAM_COLOR
							v499.FillTransparency = t1.FILL_TRANSPARENCY

							return
						else
							return
						end
					else
						t25.value55(Character)

						return
					end
				else
					return
				end
			elseif t25.value9.PLAYER_ESP then
				ENEMY_COLOR = t1.ENEMY_COLOR
				s9 = "PLAYER_ESP"

				if Character then
					if t25.value9[s9] then
						v502 = v486(Character)

						if v502 then
							v502.Adornee = Character
							v502.FillColor = ENEMY_COLOR
							v502.FillTransparency = t1.FILL_TRANSPARENCY

							return
						else
							return
						end
					else
						t25.value55(Character)

						return
					end
				else
					return
				end
			else
				t25.value55(Character)

				return
			end
		end

		local _ = pcall(v494)
	end
	t25.value56 = nil
	t25.value57 = UICorner2

	function t25.value54(p30)
		local v505 = nil

		local function v506()
			if not (v505 and v505.Parent) then
				return
			end

			if t9[v505.Name] then
				if t25.value9.MINES_ESP then
					local v507 = v505
					local s10 = "MINES_ESP"
					local MINE_COLOR = t1.MINE_COLOR

					if v507 then
						if t25.value9[s10] then
							local v510 = v486(v507)

							if v510 then
								v510.Adornee = v507
								v510.FillColor = MINE_COLOR
								v510.FillTransparency = t1.FILL_TRANSPARENCY

								return
							else
								return
							end
						else
							t25.value55(v507)

							return
						end
					else
						return
					end
				else
					t25.value55(v505)

					return
				end
			end

			if t25.value5[v505.Name] ~= nil then
				local LOOT_ESP = t25.value9.LOOT_ESP
				local v512, s11, LOOT_COLOR, v515

				if LOOT_ESP then
				elseif LOOT_ESP then
					v512 = v505
					s11 = "LOOT_ESP"
					LOOT_COLOR = t1.LOOT_COLOR

					if v512 then
						if t25.value9[s11] then
							v515 = v486(v512)

							if v515 then
								v515.Adornee = v512
								v515.FillColor = LOOT_COLOR
								v515.FillTransparency = t1.FILL_TRANSPARENCY

								return
							else
								return
							end
						else
							t25.value55(v512)

							return
						end
					else
						return
					end
				else
					t25.value55(v505)

					return
				end

				LOOT_ESP = t25.value5[v505.Name] == true

				if LOOT_ESP then
					v512 = v505
					s11 = "LOOT_ESP"
					LOOT_COLOR = t1.LOOT_COLOR

					if v512 then
						if t25.value9[s11] then
							v515 = v486(v512)

							if v515 then
								v515.Adornee = v512
								v515.FillColor = LOOT_COLOR
								v515.FillTransparency = t1.FILL_TRANSPARENCY

								return
							else
								return
							end
						else
							t25.value55(v512)

							return
						end
					else
						return
					end
				else
					t25.value55(v505)

					return
				end
			end

			local isModel = v505:IsA("Model")

			if isModel then
				isModel = v505:FindFirstChildOfClass("Humanoid")
			end

			if not (isModel and not Players:GetPlayerFromCharacter(v505)) then
				return
			end

			local AncestryChanged = v505
			local Humanoid = AncestryChanged:FindFirstChildOfClass("Humanoid")

			if Humanoid then
				local v519 = not t25.value16[Humanoid]
			end

			if v536 then
				local connection = nil

				connection = Humanoid.HealthChanged:Connect(function()
					if v505.Parent then
						t25.value54(v505)

						return
					end

					if not connection then
						t25.value16[Humanoid] = nil

						return
					end

					connection:Disconnect()
					t25.value16[Humanoid] = nil
				end)
				t25.value16[Humanoid] = connection

				local connection2 = nil

				AncestryChanged = v505.AncestryChanged
				connection2 = AncestryChanged:Connect(function(_, p31)
					if p31 then
						return
					end

					if t25.value16[Humanoid] then
						t25.value16[Humanoid]:Disconnect()
						t25.value16[Humanoid] = nil
					end

					t25.value15[v505] = nil

					if not connection2 then
						return
					end

					connection2:Disconnect()
				end)
			end

			if Humanoid.Health <= 0 or (string.find(string.lower(v505.Name), "corpse") ~= nil or (string.find(string.lower(v505.Name), "dead") ~= nil or v505:FindFirstChildOfClass("ProximityPrompt") ~= nil)) then
				t25.value15[v505] = nil

				if t25.value9.CORPSE_ESP then
					local v522 = v505
					local s12 = "CORPSE_ESP"
					local LOOT_COLOR = t1.LOOT_COLOR

					if v522 then
						if t25.value9[s12] then
							local v525 = v486(v522)

							if v525 then
								v525.Adornee = v522
								v525.FillColor = LOOT_COLOR
								v525.FillTransparency = t1.FILL_TRANSPARENCY

								return
							else
								return
							end
						else
							t25.value55(v522)

							return
						end
					else
						return
					end
				else
					t25.value55(v505)

					return
				end
			end

			local Head = v505:FindFirstChild("Head")

			if Head then
				Head = v505:FindFirstChild("HumanoidRootPart")
			end

			if Head then
				t25.value15[v505] = true
			else
				t25.value15[v505] = nil
			end

			if t25.value9.NPC_ESP then
				local v527 = v505
				local s13 = "NPC_ESP"
				local NPC_COLOR = t1.NPC_COLOR

				if v527 then
					if t25.value9[s13] then
						local v530 = v486(v527)

						if v530 then
							v530.Adornee = v527
							v530.FillColor = NPC_COLOR
							v530.FillTransparency = t1.FILL_TRANSPARENCY

							return
						else
							return
						end
					else
						t25.value55(v527)

						return
					end
				else
					return
				end
			end

			t25.value55(v505)
		end

		v505 = p30

		local _ = pcall(v506)
	end

	UICorner2 = function()
		t25.value56 = Drawing.new("Circle")

		if not t25.value56 then
			return
		end

		t25.value56.Visible = false
		t25.value56.Color = t14.FOV_COLOR
		t25.value56.Thickness = t14.FOV_THICKNESS
		t25.value56.Transparency = 1 - t14.FOV_TRANSPARENCY
		t25.value56.Filled = false
		t25.value56.Radius = t25.value9.AIMBOT_CIRCLE_SIZE
	end

	function t25.value58()
		local v533, v534, v535 = ipairs(Players:GetPlayers())

		while true do
			local v537

			v535, v537 = v533(v534, v535)

			if not v535 then
				break
			end

			t25.value57(v537)
		end

		local Character = t24.value1.Character

		if Character then
			Character = t24.value1.Character:FindFirstChild("HumanoidRootPart")
		end

		local min, v539, v540, v541, v542, Position

		if not Character then
			v563 = Workspace:GetDescendants()

			for i = 1, #v563, 200 do
				min = math.min
				v539 = #v563
				v540 = i

				for i2 = i, min(i + 200 - 1, v539) do
					v541 = v563[i2]
					v542 = true

					if Character then
						Position = nil

						if v541:IsA("BasePart") then
							Position = v541.Position
						elseif v541:IsA("Model") then
							if v541.PrimaryPart then
								Position = v541.PrimaryPart.Position
							elseif v541:FindFirstChild("HumanoidRootPart") then
								Position = v541:FindFirstChild("HumanoidRootPart").Position
							end
						end

						if Position then
							Position = (Position - Character).Magnitude > 2500
						end

						if Position then
							v542 = false
						end
					end

					if v542 then
						t25.value54(v541)
					else
						t25.value55(v541)
					end
				end

				if i + 200 <= #v563 then
					task.wait()
				end
			end

			return
		end

		Character = Character.Position

		local descendants = Workspace:GetDescendants()

		for i = 1, #descendants, 200 do
			min = math.min
			v539 = #descendants
			v540 = i

			for i2 = i, min(i + 200 - 1, v539) do
				v541 = descendants[i2]
				v542 = true

				if Character then
					Position = nil

					if v541:IsA("BasePart") then
						Position = v541.Position
					elseif v541:IsA("Model") then
						if v541.PrimaryPart then
							Position = v541.PrimaryPart.Position
						elseif v541:FindFirstChild("HumanoidRootPart") then
							Position = v541:FindFirstChild("HumanoidRootPart").Position
						end
					end

					if Position then
						Position = (Position - Character).Magnitude > 2500
					end

					if Position then
						v542 = false
					end
				end

				if v542 then
					t25.value54(v541)
				else
					t25.value55(v541)
				end
			end

			if i + 200 <= #descendants then
				task.wait()
			end
		end
	end

	t25.value59 = false
	t25.value60 = nil
	t25.value61 = 0
	t25.value56 = nil
	pcall(UICorner2)

	function t25.value62()
		return Workspace.CurrentCamera
	end

	local function v549()
		if t25.value56 then
			local v550 = t25.value62()

			if v550 then
				local ViewportSize = v550.ViewportSize

				t25.value56.Position = Vector2.new(ViewportSize.X / 2, ViewportSize.Y / 2)

				return
			else
				return
			end
		end
	end
	local function v552()
		local v553, v554, v555 = ipairs(Players:GetPlayers())
		local t26 = {}

		while true do
			local v557

			v555, v557 = v553(v554, v555)

			if not v555 then
				break
			end

			local v558

			if v557 == t24.value1 then
				v558 = false
			else
				v558 = v557.Character
			end

			if v558 then
				local AIMBOT_IGNORE_FRIENDS = t25.value9.AIMBOT_IGNORE_FRIENDS

				if AIMBOT_IGNORE_FRIENDS then
					AIMBOT_IGNORE_FRIENDS = t25.value53(v557)
				end

				if not AIMBOT_IGNORE_FRIENDS then
					local Character = v557.Character

					table.insert(t26, Character)
				end
			end
		end

		if t25.value9.AIMBOT_IGNORE_NPC then
			return t26
		end

		local pairs_ = pairs

		for k, _ in pairs_(t25.value15) do
			local Parent = k.Parent

			if Parent then
				Parent = k:FindFirstChild("Humanoid")

				if Parent then
					Parent = k:FindFirstChild("HumanoidRootPart")

					if Parent then
						Parent = k:FindFirstChild("Head")
					end
				end
			end

			if Parent then
				pairs_ = table.insert
				pairs_(t26, k)
			else
				pairs_ = t25.value15
				pairs_[k] = nil
			end
		end

		return t26
	end
	local function v565()
		local v566 = t25.value62()

		if v566 then
			local ViewportSize = v566.ViewportSize
			local vector2 = Vector2.new(ViewportSize.X / 2, ViewportSize.Y / 2)
			local v569 = v552()
			local huge = math.huge
			local v571 = nil

			for _, v in ipairs(v569) do
				local Humanoid = v:FindFirstChildOfClass("Humanoid")
				local HumanoidRootPart = v:FindFirstChild("HumanoidRootPart")
				local Head = v:FindFirstChild("Head")

				if Humanoid then
					if HumanoidRootPart then
						if Head then
							Humanoid = Humanoid.Health > 0
						else
							Humanoid = Head
						end
					else
						Humanoid = HumanoidRootPart
					end
				end

				if Humanoid then
					local v577, v578 = v566:WorldToViewportPoint(HumanoidRootPart.Position)

					if v578 then
						local Magnitude = (Vector2.new(v577.X, v577.Y) - vector2).Magnitude

						if Magnitude <= t25.value9.AIMBOT_CIRCLE_SIZE and Magnitude < huge then
							v571 = Head
							huge = Magnitude
						end
					end
				end
			end

			return v571
		else
			return nil
		end
	end

	function t25.value63(p32)
		local v580 = t25.value62()

		if v580 then
			if t25.value60 and t25.value60.Parent then
				local HumanoidRootPart = t25.value60.Parent:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart then
					local v582, v583 = v580:WorldToViewportPoint(HumanoidRootPart.Position)

					if v583 then
						local vector2 = Vector2.new(v582.X, v582.Y)
						local Unit = p32.Unit
						local vector22 = Vector2.new(v580.ViewportSize.X / 2, v580.ViewportSize.Y / 2)
						local v587 = v552()
						local huge = math.huge
						local v589 = nil

						for _, v in ipairs(v587) do
							local Humanoid = v:FindFirstChildOfClass("Humanoid")
							local Head = v:FindFirstChild("Head")
							local v594 = v.FindFirstChild(v, "HumanoidRootPart")

							if Humanoid then
								if Head then
									if v594 then
										if Humanoid.Health > 0 then
											Humanoid = Head ~= t25.value60
										else
											Humanoid = false
										end
									else
										Humanoid = v594
									end
								else
									Humanoid = Head
								end
							end

							if Humanoid then
								local v595, v596 = v580:WorldToViewportPoint(v594.Position)

								if v596 then
									local vector23 = Vector2.new(v595.X, v595.Y)

									if (vector23 - vector22).Magnitude <= t25.value9.AIMBOT_CIRCLE_SIZE then
										local v598 = vector23 - vector2
										local Magnitude = v598.Magnitude

										if Magnitude > 0 and (Unit:Dot(v598.Unit) > t14.DIRECTION_TOLERANCE and Magnitude < huge) then
											v589 = Head
											huge = Magnitude
										end
									end
								end
							end
						end

						if not v589 then
							return
						end

						t25.value60 = v589
						t25.value61 = tick()

						return
					else
						return
					end
				else
					return
				end
			else
				return
			end
		end
	end

	UICorner2 = UserInputService.InputBegan
	UICorner3 = UICorner2.Connect
	t23.value7 = 28276634170223
	UICorner3(UICorner2, function(p33, p34)
		if p34 or not t25.value9.AIMBOT then
			return
		end

		if p33.UserInputType ~= Enum.UserInputType.MouseButton2 then
			return
		end

		t25.value60 = v565()

		if not t25.value60 then
			return
		end

		t25.value59 = true
	end)
	UserInputService.InputEnded:Connect(function(input, _)
		if not t25.value9.AIMBOT then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.MouseButton2 then
			return
		end

		t25.value59 = false
		t25.value60 = nil

		if not t25.value56 then
			return
		end

		t25.value56.Color = t14.FOV_COLOR
	end)
	UserInputService.InputChanged:Connect(function(input, gameProcessed)
		if gameProcessed or not t25.value9.AIMBOT then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		local value59 = t25.value59

		if value59 then
			value59 = t25.value60
		end

		if not value59 then
			return
		end

		if tick() - t25.value61 < t14.SWITCH_COOLDOWN then
			return
		end

		local vector2 = Vector2.new(input.Delta.X, input.Delta.Y)

		if not (vector2.Magnitude > t14.SWIPE_THRESHOLD) then
			return
		end

		t25.value63(vector2)
	end)
	UICorner2 = UserInputService.InputBegan
	UICorner3 = function(p35, p36)
		if p36 then
			p36 = p35.UserInputType == Enum.UserInputType.Keyboard
		end

		if p36 and UserInputService:GetFocusedTextBox() then
			return
		end

		if t25.value29 then
			local v602 = false
			local v603 = p35.KeyCode ~= Enum.KeyCode.Unknown

			if v603 then
				v603 = p35.KeyCode == t25.value29

				if not v603 then
					local Name = p35.KeyCode.Name
					local v605 = tostring(Name)
					local Name2 = t25.value29.Name

					v603 = v605 == tostring(Name2)
				end
			end

			local v607

			if v603 then
				v607 = true
			else
				local v608 = p35.UserInputType == t25.value29

				if not v608 then
					local Name = p35.UserInputType.Name
					local v610 = tostring(Name)
					local Name2 = t25.value29.Name

					v608 = v610 == tostring(Name2)
				end

				v607 = v608 and true or v602
			end

			if v607 and t25.value28 then
				local visible = t25.value9.INV_CHECKER == true

				if not visible then
					visible = t25.value29

					if visible then
						visible = t25.value31()
					end
				end

				if t25.value28.Visible ~= visible then
					t25.value28.Visible = visible
				end
			end
		end

		if not t25.value32 then
			return
		end

		local v613 = false
		local v614 = p35.KeyCode ~= Enum.KeyCode.Unknown

		if v614 then
			v614 = p35.KeyCode == t25.value32

			if not v614 then
				local Name = p35.KeyCode.Name
				local v616 = tostring(Name)
				local Name2 = t25.value32.Name

				v614 = v616 == tostring(Name2)
			end
		end

		local v618

		if v614 then
			v618 = true
		else
			local v619 = p35.UserInputType == t25.value32

			if not v619 then
				local Name = p35.UserInputType.Name
				local v621 = tostring(Name)
				local Name2 = t25.value32.Name

				v619 = v621 == tostring(Name2)
			end

			v618 = v619 and true or v613
		end

		if not v618 then
			return
		end

		v443()
	end

	local Connect = UICorner2.Connect

	t23.value7 = 4632139434093
	Connect(UICorner2, UICorner3)
	UICorner2 = UserInputService.InputEnded
	UICorner2.Connect(UICorner2, function(p37, _)
		if t25.value29 then
			local v624 = false
			local v625 = p37.KeyCode ~= Enum.KeyCode.Unknown

			if v625 then
				v625 = p37.KeyCode == t25.value29

				if not v625 then
					local Name = p37.KeyCode.Name
					local v627 = tostring(Name)
					local Name2 = t25.value29.Name

					v625 = v627 == tostring(Name2)
				end
			end

			if v625 then
				v624 = true
			else
				local v629 = p37.UserInputType == t25.value29

				if not v629 then
					local Name = p37.UserInputType.Name
					local v631 = tostring(Name)
					local Name2 = t25.value29.Name

					v629 = v631 == tostring(Name2)
				end

				if v629 then
					v624 = true
				end
			end

			if v624 and t25.value28 then
				local visible = t25.value9.INV_CHECKER == true

				if not visible then
					visible = t25.value29

					if visible then
						visible = t25.value31()
					end
				end

				if t25.value28.Visible ~= visible then
					t25.value28.Visible = visible
				end
			end
		else
		end

		if not t25.value32 then
			return
		end

		local v634 = false
		local v635 = p37.KeyCode ~= Enum.KeyCode.Unknown

		if v635 then
			v635 = p37.KeyCode == t25.value32

			if not v635 then
				local Name = p37.KeyCode.Name
				local v637 = tostring(Name)
				local Name2 = t25.value32.Name

				v635 = v637 == tostring(Name2)
			end
		end

		local v639

		if v635 then
			v639 = true
		else
			local v640 = p37.UserInputType == t25.value32

			if not v640 then
				local Name = p37.UserInputType.Name
				local v642 = tostring(Name)
				local Name2 = t25.value32.Name

				v640 = v642 == tostring(Name2)
			end

			v639 = v640 and true or v634
		end

		if not v639 then
			return
		end

		v443()
	end)
	RunService.RenderStepped:Connect(unpack_({ newcclosure_(function()
			if t25.value29 and t25.value28 then
				local visible = t25.value9.INV_CHECKER == true

				if not visible then
					visible = t25.value29

					if visible then
						visible = t25.value31()
					end
				end

				if t25.value28.Visible ~= visible then
					t25.value28.Visible = visible
				end
			end

			if t25.value32 then
				v443()
			end

			local value34 = t25.value34

			if value34 then
				value34 = Workspace.CurrentCamera
			end

			if not value34 then
				return
			end

			Workspace.CurrentCamera.FieldOfView = 10
		end) }))
	t25.value64 = 3299
	t25.value65 = 4.6
	t25.value66 = -60 * math.log(0.987)

	function t25.value67(p38)
		if p38 <= 0 then
			return 0
		else
			local v646 = t25.value66 * p38 / t25.value64
			local v647 = 1 - (v646 >= 0.95 and 0.95 or v646)
			local v648 = -math.log(v647) / t25.value66

			return math.max(v648, 0)
		end
	end

	local function v649(p39, p40, p41)
		local Magnitude = (p40 - p39).Magnitude
		local Magnitude2 = (p40 + p41 * t25.value67(Magnitude) - p39).Magnitude
		local v652 = t25.value67(Magnitude2) * (t14.PREDICTION_MULTIPLIER or 1)
		local v653 = p40 + p41 * v652
		local n13

		if v652 <= 0 then
			n13 = 0
		else
			local v655 = t25.value66 * v652

			if v655 < 0.005 then
				n13 = 0.5 * t25.value65 * v652 * v652 * (1 + 0.33333333333333 * v655)
			else
				n13 = t25.value65 / (t25.value66 * t25.value66) * (math.exp(v655) - 1 - v655)
			end
		end

		local v656 = p41.Y * v652
		local v657 = math.clamp(v656, -2.5, 3.5)

		return Vector3.new(v653.X, p40.Y + v657 + n13, v653.Z)
	end

	function t25.value68()
		if t25.value24 then
			return
		end

		local t27 = { newcclosure_(function()
				local v659 = t25.value62()

				if not v659 then
					return
				end

				local value56 = v549

				value56()

				if t25.value56 then
					t25.value56.Visible = t25.value9.AIMBOT_SHOW_FOV
					value56 = t25.value56
					value56.Radius = t25.value9.AIMBOT_CIRCLE_SIZE
				end

				local value59 = t25.value59

				if value59 then
					value59 = t25.value60

					if value59 then
						value59 = t25.value60.Parent

						if value59 then
							value59 = t25.value60.Parent:FindFirstChild("Humanoid")
						end
					end
				end

				if value59 then
					if not (t25.value60.Parent.Humanoid.Health > 0) then
						t25.value60 = v565()

						if t25.value60 or not t25.value56 then
							return
						else
							t25.value56.Color = t14.FOV_COLOR

							return
						end
					end

					local Position = v659.CFrame.Position
					local Position2 = t25.value60.Position
					local HumanoidRootPart = t25.value60.Parent:FindFirstChild("HumanoidRootPart")
					local AIMBOT_SMART

					if HumanoidRootPart then
						AIMBOT_SMART = t25.value9.AIMBOT_SMART
					else
						AIMBOT_SMART = HumanoidRootPart
					end

					if AIMBOT_SMART and (Position - Position2).Magnitude > (t14.MIN_PREDICTION_DISTANCE or 10) then
						Position2 = v649(Position, Position2, HumanoidRootPart.AssemblyLinearVelocity)
					end

					local cFrame = CFrame.lookAt(Position, Position2)

					v659.CFrame = v659.CFrame:Lerp(cFrame, t14.AIM_SMOOTHNESS)

					local value562 = t25.value56

					if value562 then
					elseif value562 then
						t25.value56.Color = t14.FOV_LOCKED_COLOR

						return
					else
						return
					end

					value562 = t25.value9.AIMBOT_SHOW_FOV

					if value562 then
						t25.value56.Color = t14.FOV_LOCKED_COLOR

						return
					else
						return
					end
				else
					if not t25.value56 then
						return
					end

					t25.value56.Color = t14.FOV_COLOR
				end
			end) }

		t25.value24 = RunService.RenderStepped:Connect(unpack_(t27))
	end
	function t25.value69()
		if t25.value23 then
			return
		end

		local AmmoTypes = ReplicatedStorage:FindFirstChild("AmmoTypes")

		if AmmoTypes then
			for _, child in ipairs(AmmoTypes:GetChildren()) do
				if child:GetAttribute("Drag") ~= 0 then
					child:SetAttribute("Drag", 0)
				end

				if child:GetAttribute("MuzzleVelocity") ~= 3299 then
					child:SetAttribute("MuzzleVelocity", 3299)
				end

				if child:GetAttribute("ProjectileWidth") ~= 1 then
					child:SetAttribute("ProjectileWidth", 1)
				end

				if child:GetAttribute("RecoilStrength") ~= 0 then
					child:SetAttribute("RecoilStrength", 0)
				end

				if child:GetAttribute("ProjectileDrop") ~= 0 then
					child:SetAttribute("ProjectileDrop", 0)
				end
			end
		end

		local t28 = { newcclosure_(function()
				local Character = t24.value1.Character

				if Character then
					Character = t24.value1.Character:FindFirstChild("HumanoidRootPart")
				end

				if Character and t24.value1.Character.HumanoidRootPart:GetAttribute("Recoil") ~= 0 then
					t24.value1.Character.HumanoidRootPart:SetAttribute("Recoil", 0)
				end

				if not t24.value1.Character then
					return
				end

				local ipairs_ = ipairs
				local Character2 = t24.value1.Character

				for _, child in ipairs_(Character2.GetChildren(Character2)) do
					if child:GetAttribute("Recoil") ~= 0 then
						child:SetAttribute("Recoil", 0)
					end

					local Attachments = child:FindFirstChild("Attachments")

					if Attachments then
						for _, descendant in ipairs(Attachments.GetDescendants(Attachments)) do
							if descendant:IsA("Configuration") or descendant:IsA("ValueBase") then
								if descendant:GetAttribute("Recoil") then
									descendant:SetAttribute("Recoil", 0)
								end

								if descendant:GetAttribute("HRecoilMod") then
									descendant:SetAttribute("HRecoilMod", 0)
								end

								if descendant:GetAttribute("VRecoilMod") then
									descendant:SetAttribute("VRecoilMod", 0)
								end
							end
						end
					end
				end
			end) }

		t25.value23 = RunService.RenderStepped:Connect(unpack_(t28))
	end
	function t25.value70()
		if not t25.value23 then
			return
		end

		t25.value23:Disconnect()
	end

	UICorner2 = function(p42, p43)
		local Frame = Instance.new("Frame")

		Frame.Name = v35()
		Frame.Size = UDim2.new(1, -16, 0, t1.sectionH)
		Frame.BackgroundTransparency = 1
		Frame.Parent = p42

		local Frame2 = Instance.new("Frame")

		Frame2.Name = v35()
		Frame2.Size = UDim2.new(0, 3, 0, 14)
		Frame2.Position = UDim2.new(0, 4, 0.5, -7)
		Frame2.BackgroundColor3 = t1.colorSection
		Frame2.BorderSizePixel = 0
		Frame2.Parent = Frame

		local UICorner4 = Instance.new("UICorner")

		UICorner4.CornerRadius = UDim.new(1, 0)
		UICorner4.Parent = Frame2

		local TextLabel = Instance.new("TextLabel")

		TextLabel.Name = v35()
		TextLabel.Size = UDim2.new(1, -20, 1, 0)
		TextLabel.Position = UDim2.new(0, 14, 0, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = p43
		TextLabel.TextColor3 = t1.colorSection
		TextLabel.TextSize = 10.5
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.Parent = Frame
	end
	UICorner3 = function(p44)
		local Frame = Instance.new("Frame")

		Frame.Name = v35()
		Frame.Size = UDim2.new(1, -16, 0, t1.dividerH)
		Frame.BackgroundTransparency = 1
		Frame.Parent = p44

		local Frame2 = Instance.new("Frame")

		Frame2.Name = v35()
		Frame2.Size = UDim2.new(1, -20, 0, 1)
		Frame2.Position = UDim2.new(0, 10, 0.5, 0)
		Frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame2.BorderSizePixel = 0
		Frame2.Parent = Frame

		local UIGradient2 = Instance.new("UIGradient")

		UIGradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t1.colorDivider), ColorSequenceKeypoint.new(0.5, t1.colorStrokeLight), ColorSequenceKeypoint.new(1, t1.colorDivider) })
		UIGradient2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.9), NumberSequenceKeypoint.new(0.5, 0.2), NumberSequenceKeypoint.new(1, 0.9) })
		UIGradient2.Parent = Frame2
	end
	Connect = function(p45, p46)
		local Frame = Instance.new("Frame")

		Frame.Name = v35()
		Frame.Size = UDim2.new(1, -16, 0, t1.rowHeight)
		Frame.BackgroundColor3 = t1.colorRow
		Frame.BorderSizePixel = 0
		Frame.Parent = p45

		local UICorner4 = Instance.new("UICorner")

		UICorner4.CornerRadius = UDim.new(0, 8)
		UICorner4.Parent = Frame

		local UIStroke = Instance.new("UIStroke")

		UIStroke.Name = v35()
		UIStroke.Thickness = 1
		UIStroke.Color = t1.colorStroke
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke.Parent = Frame

		local TextLabel = Instance.new("TextLabel")

		TextLabel.Name = v35()
		TextLabel.Size = UDim2.new(1, -78, 1, 0)
		TextLabel.Position = UDim2.new(0, 14, 0, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = p46.name
		TextLabel.TextColor3 = t1.colorText
		TextLabel.TextSize = 12
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.Parent = Frame

		local Frame2 = Instance.new("Frame")

		Frame2.Name = v35()
		Frame2.Size = UDim2.new(0, 42, 0, 22)
		Frame2.Position = UDim2.new(1, -52, 0.5, -11)

		local default = p46.default

		if default then
			default = t1.colorOn
		end

		Frame2.BackgroundColor3 = default or t1.colorOff
		Frame2.BorderSizePixel = 0
		Frame2.Active = false
		Frame2.ZIndex = 3
		Frame2.Parent = Frame

		local UICorner5 = Instance.new("UICorner")

		UICorner5.CornerRadius = UDim.new(1, 0)
		UICorner5.Parent = Frame2

		local UIStroke2 = Instance.new("UIStroke")

		UIStroke2.Thickness = 1

		local default2 = p46.default

		if default2 then
			default2 = t1.colorOn
		end

		UIStroke2.Color = default2 or Color3.fromRGB(50, 56, 76)
		UIStroke2.Parent = Frame2

		local Frame3 = Instance.new("Frame")

		Frame3.Name = v35()
		Frame3.Size = UDim2.new(0, 16, 0, 16)

		local default3 = p46.default

		if default3 then
			default3 = UDim2.new(0, 23, 0.5, -8)
		end

		Frame3.Position = default3 or UDim2.new(0, 3, 0.5, -8)

		local default4 = p46.default

		if default4 then
			default4 = t1.colorKnob
		end

		Frame3.BackgroundColor3 = default4 or t1.colorOffKnob
		Frame3.BorderSizePixel = 0
		Frame3.Active = false
		Frame3.ZIndex = 4
		Frame3.Parent = Frame2

		local UICorner6 = Instance.new("UICorner")

		UICorner6.CornerRadius = UDim.new(1, 0)
		UICorner6.Parent = Frame3

		if p46.tag == "PLAYER_ESP" then
			TextLabel.Size = UDim2.new(1, -110, 1, 0)

			local TextButton = Instance.new("TextButton")

			TextButton.Name = v35()
			TextButton.Size = UDim2.new(0, 24, 0, 24)
			TextButton.Position = UDim2.new(1, -84, 0.5, -12)
			TextButton.BackgroundColor3 = t1.colorBtn
			TextButton.Text = "⚙"
			TextButton.TextColor3 = t1.colorTextDim
			TextButton.TextSize = 13
			TextButton.Font = Enum.Font.GothamBold
			TextButton.BorderSizePixel = 0
			TextButton.AutoButtonColor = false
			TextButton.ZIndex = 15
			TextButton.Parent = Frame

			local UICorner7 = Instance.new("UICorner")

			UICorner7.CornerRadius = UDim.new(0, 6)
			UICorner7.Parent = TextButton

			local UIStroke3 = Instance.new("UIStroke")

			UIStroke3.Thickness = 1
			UIStroke3.Color = t1.colorStroke
			UIStroke3.Parent = TextButton
			TextButton.MouseEnter:Connect(function()
				local v703 = TweenService
				local v704 = TextButton
				local v705 = tweenInfo
				local colorBtnHover = t1.colorBtnHover

				v703.Create(v703, v704, v705, {
					BackgroundColor3 = colorBtnHover,
					TextColor3 = t1.colorOn
				}):Play()

				local v707 = TweenService
				local v708 = UIStroke3
				local v709 = tweenInfo
				local t29 = {
					Color = t1.colorStrokeLight
				}

				v707.Create(v707, v708, v709, t29):Play()
			end)
			TextButton.MouseLeave:Connect(function()
				local v711 = TweenService
				local v712 = TextButton
				local v713 = tweenInfo
				local t30 = {
					BackgroundColor3 = t1.colorBtn,
					TextColor3 = t1.colorTextDim
				}

				v711.Create(v711, v712, v713, t30):Play()

				local v715 = TweenService
				local v716 = UIStroke3
				local v717 = tweenInfo
				local t31 = {
					Color = t1.colorStroke
				}

				v715.Create(v715, v716, v717, t31):Play()
			end)
			v32(TextButton, function()
				t25.value50.Visible = not t25.value50.Visible
			end)
		end

		if p46.tag == "INV_CHECKER" or p46.tag == "ZOOM" then
			TextLabel.Size = UDim2.new(1, -125, 1, 0)

			local function v719()
				if p46.tag == "INV_CHECKER" then
					return t25.value29
				elseif p46.tag == "ZOOM" then
					return t25.value32
				else
					return nil
				end
			end

			local TextButton = Instance.new("TextButton")

			TextButton.Name = v35()
			TextButton.Size = UDim2.new(0, 50, 0, 22)
			TextButton.Position = UDim2.new(1, -108, 0.5, -11)
			TextButton.BackgroundColor3 = Color3.fromRGB(20, 24, 36)

			local v721 = v209
			local value29

			if p46.tag == "INV_CHECKER" then
				value29 = t25.value29
			elseif p46.tag == "ZOOM" then
				value29 = t25.value32
			else
				value29 = nil
			end

			TextButton.Text = v721(value29)

			local s14 = "TextColor3"
			local color3 = v719()

			if color3 then
				color3 = Color3.fromRGB(245, 245, 250)
			end

			TextButton[s14] = color3 or t1.colorTextDim
			TextButton.TextSize = 11
			TextButton.Font = Enum.Font.GothamBold
			TextButton.TextStrokeTransparency = 1
			TextButton.BorderSizePixel = 0
			TextButton.AutoButtonColor = false
			TextButton.Active = true
			TextButton.ZIndex = 15
			TextButton.Parent = Frame

			local UICorner7 = Instance.new("UICorner")

			UICorner7.CornerRadius = UDim.new(0, 6)
			UICorner7.Parent = TextButton

			local UIStroke3 = Instance.new("UIStroke")

			UIStroke3.Thickness = 1
			UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

			local s15 = "Color"
			local value292

			if p46.tag == "INV_CHECKER" then
				value292 = t25.value29
			elseif p46.tag == "ZOOM" then
				value292 = t25.value32
			else
				value292 = nil
			end

			if value292 then
				value292 = Color3.fromRGB(55, 70, 100)
			end

			UIStroke3[s15] = value292 or t1.colorStroke
			UIStroke3.Parent = TextButton

			local u729 = false

			local function v730()
				local value293

				if p46.tag == "INV_CHECKER" then
					value293 = t25.value29
				elseif p46.tag == "ZOOM" then
					value293 = t25.value32
				else
					value293 = nil
				end

				if u729 then
					TextButton.Text = "..."
					TextButton.TextColor3 = t1.colorOn
					TextButton.TextSize = 11
					TextButton.BackgroundColor3 = Color3.fromRGB(18, 30, 48)
					UIStroke3.Color = t1.colorOn
				elseif value293 then
					TextButton.Text = v209(value293)
					TextButton.TextColor3 = Color3.fromRGB(245, 245, 250)
					TextButton.TextSize = 11
					TextButton.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
					UIStroke3.Color = Color3.fromRGB(55, 70, 100)

					return
				else
					TextButton.Text = "NONE"
					TextButton.TextColor3 = t1.colorTextDim
					TextButton.TextSize = 10
					TextButton.BackgroundColor3 = Color3.fromRGB(17, 20, 30)
					UIStroke3.Color = t1.colorStroke

					return
				end
			end

			TextButton.MouseEnter:Connect(function()
				if u729 then
					return
				end

				local v732 = TweenService
				local v733 = TextButton
				local v734 = tweenInfo
				local Color3_ = Color3

				v732.Create(v732, v733, v734, {
					BackgroundColor3 = Color3_.fromRGB(30, 36, 52)
				}):Play()

				local v736 = TweenService
				local v737 = UIStroke3
				local v738 = tweenInfo
				local s16 = "Color"
				local value293

				if p46.tag == "INV_CHECKER" then
					value293 = t25.value29
				elseif p46.tag == "ZOOM" then
					value293 = t25.value32
				else
					value293 = nil
				end

				if value293 then
					value293 = Color3.fromRGB(75, 100, 145)
				end

				v736:Create(v737, v738, {
					[s16] = value293 or t1.colorStrokeLight
				}):Play()
			end)
			TextButton.MouseLeave:Connect(function()
				if u729 then
					return
				end

				local value293

				if p46.tag == "INV_CHECKER" then
					value293 = t25.value29
				elseif p46.tag == "ZOOM" then
					value293 = t25.value32
				else
					value293 = nil
				end

				local v742 = TweenService
				local v743 = TextButton
				local v744 = tweenInfo
				local s17 = "BackgroundColor3"
				local color32

				if value293 then
					color32 = Color3.fromRGB(22, 26, 38)
				else
					color32 = value293
				end

				local color33 = color32 or Color3.fromRGB(17, 20, 30)

				v742.Create(v742, v743, v744, {
					[s17] = color33
				}):Play()

				local v748 = TweenService
				local v749 = UIStroke3
				local v750 = tweenInfo
				local s18 = "Color"

				if value293 then
					value293 = Color3.fromRGB(55, 70, 100)
				end

				v748:Create(v749, v750, {
					[s18] = value293 or t1.colorStroke
				}):Play()
			end)
			v32(TextButton, function()
				if u729 then
					u729 = false
					v730()

					return
				end

				v730()
				UserInputService.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.Keyboard then
						if input.KeyCode == Enum.KeyCode.Escape or (input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete) then
							if p46.tag == "INV_CHECKER" then
								if not t25.value28 then
									u729 = false
									v730()

									return
								end

								local visible = t25.value9.INV_CHECKER == true

								if not visible then
									visible = t25.value29

									if visible then
										visible = t25.value31()
									end
								end

								if t25.value28.Visible == visible then
									u729 = false
									v730()

									return
								end

								t25.value28.Visible = visible
							else
								if p46.tag ~= "ZOOM" then
									u729 = false
									v730()

									return
								end

								v443()
							end

							u729 = false
							v730()

							return
						elseif input.KeyCode == Enum.KeyCode.Unknown then
							return
						else
							local _ = input.KeyCode

							if p46.tag == "INV_CHECKER" then
								if not t25.value28 then
									u729 = false
									v730()

									return
								end

								local visible = t25.value9.INV_CHECKER == true

								if not visible then
									visible = t25.value29

									if visible then
										visible = t25.value31()
									end
								end

								if t25.value28.Visible == visible then
									u729 = false
									v730()

									return
								end

								t25.value28.Visible = visible
							else
								if p46.tag ~= "ZOOM" then
									u729 = false
									v730()

									return
								end

								v443()
							end

							u729 = false
							v730()

							return
						end
					end

					if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then
						local _ = input.UserInputType

						if p46.tag == "INV_CHECKER" then
							if not t25.value28 then
								u729 = false
								v730()

								return
							end

							local visible = t25.value9.INV_CHECKER == true

							if not visible then
								visible = t25.value29

								if visible then
									visible = t25.value31()
								end
							end

							if t25.value28.Visible == visible then
								u729 = false
								v730()

								return
							end

							t25.value28.Visible = visible
						else
							if p46.tag ~= "ZOOM" then
								u729 = false
								v730()

								return
							end

							v443()
						end

						u729 = false
						v730()

						return
					end

					if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
						return
					end

					u729 = false
					v730()
				end)
			end)
		end

		local TextButton = Instance.new("TextButton")

		TextButton.Name = v35()

		local s19 = "Size"
		local v759 = p46.tag == "INV_CHECKER" or p46.tag == "ZOOM"

		if v759 then
			v759 = UDim2.new(1, -112, 1, 0)
		end

		if not v759 then
			local v760 = p46.tag == "PLAYER_ESP"

			if v760 then
				v760 = UDim2.new(1, -95, 1, 0)
			end

			v759 = v760 or UDim2.new(1, 0, 1, 0)
		end

		TextButton[s19] = v759
		TextButton.BackgroundTransparency = 1
		TextButton.Text = ""
		TextButton.Active = true
		TextButton.ZIndex = 10
		TextButton.AutoButtonColor = false
		TextButton.Parent = Frame

		local TextButton2 = Instance.new("TextButton")

		TextButton2.Name = v35()
		TextButton2.Size = UDim2.new(1, 0, 1, 0)
		TextButton2.BackgroundTransparency = 1
		TextButton2.Text = ""
		TextButton2.Active = true
		TextButton2.ZIndex = 12
		TextButton2.AutoButtonColor = false
		TextButton2.Parent = Frame2
		TextButton.MouseEnter:Connect(function()
			local v762 = TweenService
			local v763 = Frame
			local v764 = tweenInfo

			v762.Create(v762, v763, v764, {
				BackgroundColor3 = t1.colorRowHover
			}):Play()

			local v765 = TweenService
			local v766 = UIStroke
			local v767 = tweenInfo
			local v768 = t1

			v765.Create(v765, v766, v767, {
				Color = v768.colorStrokeLight
			}):Play()
		end)
		TextButton.MouseLeave:Connect(function()
			local v769 = TweenService
			local v770 = Frame
			local v771 = tweenInfo
			local v772 = t1

			v769.Create(v769, v770, v771, {
				BackgroundColor3 = v772.colorRow
			}):Play()

			local v773 = TweenService
			local v774 = UIStroke
			local v775 = tweenInfo
			local v776 = t1

			v773.Create(v773, v774, v775, {
				Color = v776.colorStroke
			}):Play()
		end)
		TextButton2.MouseEnter:Connect(function()
			local v777 = TweenService
			local v778 = Frame
			local v779 = tweenInfo
			local t32 = {
				BackgroundColor3 = t1.colorRowHover
			}

			v777.Create(v777, v778, v779, t32):Play()

			local v781 = TweenService
			local v782 = UIStroke
			local v783 = tweenInfo
			local v784 = t1

			v781.Create(v781, v782, v783, {
				Color = v784.colorStrokeLight
			}):Play()
		end)
		TextButton2.MouseLeave:Connect(function()
			local v785 = TweenService
			local v786 = Frame
			local v787 = tweenInfo
			local v788 = t1

			v785.Create(v785, v786, v787, {
				BackgroundColor3 = v788.colorRow
			}):Play()
			TweenService:Create(UIStroke, tweenInfo, {
				Color = t1.colorStroke
			}):Play()
		end)

		local function v789(p47)
			t25.value9[p46.tag] = p47

			local v790 = TweenService
			local v791 = Frame2
			local v792 = tweenInfo
			local colorOn

			if p47 then
				colorOn = t1.colorOn
			else
				colorOn = p47
			end

			v790:Create(v791, v792, {
				BackgroundColor3 = colorOn or t1.colorOff
			}):Play()

			local v794 = TweenService
			local v795 = UIStroke2
			local v796 = tweenInfo
			local colorOn2

			if p47 then
				colorOn2 = t1.colorOn
			else
				colorOn2 = p47
			end

			v794:Create(v795, v796, {
				Color = colorOn2 or Color3.fromRGB(50, 56, 76)
			}):Play()

			local v798 = TweenService
			local v799 = Frame3
			local v800 = tweenInfo3
			local uDim2

			if p47 then
				uDim2 = UDim2.new(0, 23, 0.5, -8)
			else
				uDim2 = p47
			end

			local uDim22 = uDim2 or UDim2.new(0, 3, 0.5, -8)
			local s20 = "BackgroundColor3"
			local colorKnob

			if p47 then
				colorKnob = t1.colorKnob
			else
				colorKnob = p47
			end

			v798:Create(v799, v800, {
				Position = uDim22,
				[s20] = colorKnob or t1.colorOffKnob
			}):Play()

			if string.find(p46.tag, "ESP") then
				task.spawn(t25.value58)
			elseif p46.tag == "AIMBOT" then
				if p47 then
					t25.value68()
				else
					if t25.value24 then
						t25.value24:Disconnect()
					end

					if not t25.value56 then
						v455()

						return
					end

					t25.value56.Visible = false
					t25.value56.Color = t14.FOV_COLOR
				end
			elseif p46.tag == "NO_RECOIL" then
				if p47 then
					t25.value69()
				else
					t25.value70()
				end
			elseif p46.tag == "ALWAYS_DAY" then
				if p47 then
					Lighting.ClockTime = 14

					if t25.value17 then
						v455()

						return
					end

					local t33 = { newcclosure_(function()
							Lighting.ClockTime = 14
						end) }

					t25.value17 = RunService.RenderStepped:Connect(unpack_(t33))
				else
					if not t25.value17 then
						v455()

						return
					end

					t25.value17:Disconnect()
				end
			elseif p46.tag == "NO_FOG" then
				local Atmosphere = Lighting:FindFirstChild("Atmosphere")
				local WaterBlur = Lighting:FindFirstChild("WaterBlur")

				if p47 then
					if Atmosphere then
						if not t25.value21 then
							t25.value21 = Atmosphere.Density
						end

						Atmosphere.Density = 0
					end

					if not WaterBlur then
						v455()

						return
					end

					if not t25.value22 then
						t25.value22 = WaterBlur.Size
					end

					WaterBlur.Size = 0
				else
					local value21

					if Atmosphere then
						value21 = t25.value21
					else
						value21 = Atmosphere
					end

					if value21 then
						Atmosphere.Density = t25.value21
					end

					local value22

					if WaterBlur then
						value22 = t25.value22
					else
						value22 = WaterBlur
					end

					if not value22 then
						v455()

						return
					end

					WaterBlur.Size = t25.value22
				end
			elseif p46.tag == "FULLBRIGHT" then
				if p47 then
					if not t25.value18 then
						t25.value18 = Lighting.Ambient
					end

					if not t25.value19 then
						t25.value19 = Lighting.OutdoorAmbient
					end

					if t25.value20 == nil then
						t25.value20 = Lighting.GlobalShadows
					end

					Lighting.Ambient = Color3.fromRGB(255, 255, 255)
					Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
					Lighting.GlobalShadows = false
				else
					if t25.value18 then
						Lighting.Ambient = t25.value18
					end

					if t25.value19 then
						Lighting.OutdoorAmbient = t25.value19
					end

					if t25.value20 == nil then
						v455()

						return
					end

					Lighting.GlobalShadows = t25.value20
				end
			elseif p46.tag == "FAST_RUN" then
				if p47 then
					v455()

					return
				end

				local Character = t24.value1.Character

				if Character then
					Character = t24.value1.Character:FindFirstChild("Humanoid")
				end

				if not Character then
					v455()

					return
				end

				t24.value1.Character.Humanoid.WalkSpeed = 16
			elseif p46.tag == "STATS_GUI" then
				if not t25.value26 then
					v455()

					return
				end

				t25.value26.Visible = p47
			elseif p46.tag == "BOSS_TRACKER" then
				if not t25.value27 then
					v455()

					return
				end

				t25.value27.Visible = p47
			elseif p46.tag == "INV_CHECKER" then
				if not t25.value28 then
					v455()

					return
				end

				local visible = t25.value9.INV_CHECKER == true

				if not visible then
					visible = t25.value29

					if visible then
						visible = t25.value31()
					end
				end

				if t25.value28.Visible == visible then
					v455()

					return
				end

				t25.value28.Visible = visible
			else
				if p46.tag ~= "ZOOM" then
					v455()

					return
				end

				v443()
			end

			v455()
		end

		t25.value1[p46.tag] = v789
		v32(TextButton, function()
			v789(not t25.value9[p46.tag])
		end)
		v32(TextButton2, function()
			v789(not t25.value9[p46.tag])
		end)
	end

	local function v812(player, p48)
		local Frame = Instance.new("Frame")

		Frame.Name = v35()
		Frame.Size = UDim2.new(1, -16, 0, t1.rowHeight)
		Frame.BackgroundColor3 = t1.colorRow
		Frame.BorderSizePixel = 0
		Frame.Parent = player

		local UICorner4 = Instance.new("UICorner")

		UICorner4.CornerRadius = UDim.new(0, 8)
		UICorner4.Parent = Frame

		local UIStroke = Instance.new("UIStroke")

		UIStroke.Name = v35()
		UIStroke.Thickness = 1
		UIStroke.Color = t1.colorStroke
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke.Parent = Frame

		local TextLabel = Instance.new("TextLabel")

		TextLabel.Name = v35()
		TextLabel.Size = UDim2.new(1, -78, 1, 0)
		TextLabel.Position = UDim2.new(0, 14, 0, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = p48.name
		TextLabel.TextColor3 = t1.colorText
		TextLabel.TextSize = 12
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.Parent = Frame

		local Frame2 = Instance.new("Frame")

		Frame2.Name = v35()
		Frame2.Size = UDim2.new(0, 42, 0, 22)
		Frame2.Position = UDim2.new(1, -52, 0.5, -11)

		local colorOn = t25.value5[p48.tag]

		if colorOn then
			colorOn = t1.colorOn
		end

		Frame2.BackgroundColor3 = colorOn or t1.colorOff
		Frame2.BorderSizePixel = 0
		Frame2.Active = false
		Frame2.ZIndex = 3
		Frame2.Parent = Frame

		local UICorner5 = Instance.new("UICorner")

		UICorner5.CornerRadius = UDim.new(1, 0)
		UICorner5.Parent = Frame2

		local UIStroke2 = Instance.new("UIStroke")

		UIStroke2.Thickness = 1

		local colorOn2 = t25.value5[p48.tag]

		if colorOn2 then
			colorOn2 = t1.colorOn
		end

		UIStroke2.Color = colorOn2 or Color3.fromRGB(50, 56, 76)
		UIStroke2.Parent = Frame2

		local Frame3 = Instance.new("Frame")

		Frame3.Name = v35()
		Frame3.Size = UDim2.new(0, 16, 0, 16)

		local uDim2 = t25.value5[p48.tag]

		if uDim2 then
			uDim2 = UDim2.new(0, 23, 0.5, -8)
		end

		Frame3.Position = uDim2 or UDim2.new(0, 3, 0.5, -8)

		local colorKnob = t25.value5[p48.tag]

		if colorKnob then
			colorKnob = t1.colorKnob
		end

		Frame3.BackgroundColor3 = colorKnob or t1.colorOffKnob
		Frame3.BorderSizePixel = 0
		Frame3.Active = false
		Frame3.ZIndex = 4
		Frame3.Parent = Frame2

		local UICorner6 = Instance.new("UICorner")

		UICorner6.CornerRadius = UDim.new(1, 0)
		UICorner6.Parent = Frame3

		local TextButton = Instance.new("TextButton")

		TextButton.Name = v35()
		TextButton.Size = UDim2.new(1, 0, 1, 0)
		TextButton.BackgroundTransparency = 1
		TextButton.Text = ""
		TextButton.Active = true
		TextButton.ZIndex = 10
		TextButton.AutoButtonColor = false
		TextButton.Parent = Frame

		local function v827()
			local v828 = TweenService
			local v829 = Frame
			local v830 = tweenInfo
			local t34 = {
				BackgroundColor3 = t1.colorRowHover
			}

			v828.Create(v828, v829, v830, t34):Play()

			local v832 = TweenService
			local v833 = UIStroke
			local v834 = tweenInfo
			local t35 = {
				Color = t1.colorStrokeLight
			}

			v832.Create(v832, v833, v834, t35):Play()
		end

		TextButton.MouseEnter:Connect(v827)

		local function v836()
			local v837 = TweenService
			local v838 = Frame
			local v839 = tweenInfo
			local v840 = t1

			v837.Create(v837, v838, v839, {
				BackgroundColor3 = v840.colorRow
			}):Play()

			local v841 = TweenService
			local v842 = UIStroke
			local v843 = tweenInfo

			v841.Create(v841, v842, v843, {
				Color = t1.colorStroke
			}):Play()
		end

		TextButton.MouseLeave:Connect(v836)
		v32(TextButton, function()
			t25.value5[p48.tag] = not t25.value5[p48.tag]

			local colorKnob2 = t25.value5[p48.tag]
			local v845 = TweenService
			local v846 = Frame2
			local v847 = tweenInfo
			local colorOn3

			if colorKnob2 then
				colorOn3 = t1.colorOn
			else
				colorOn3 = colorKnob2
			end

			v845:Create(v846, v847, {
				BackgroundColor3 = colorOn3 or t1.colorOff
			}):Play()

			local v849 = TweenService
			local v850 = UIStroke2
			local v851 = tweenInfo
			local colorOn4

			if colorKnob2 then
				colorOn4 = t1.colorOn
			else
				colorOn4 = colorKnob2
			end

			local color3 = colorOn4 or Color3.fromRGB(50, 56, 76)

			v849.Create(v849, v850, v851, {
				Color = color3
			}):Play()

			local v854 = TweenService
			local v855 = Frame3
			local v856 = tweenInfo3
			local uDim22

			if colorKnob2 then
				uDim22 = UDim2.new(0, 23, 0.5, -8)
			else
				uDim22 = colorKnob2
			end

			local uDim23 = uDim22 or UDim2.new(0, 3, 0.5, -8)

			if not colorKnob2 then
				v854:Create(v855, v856, {
					Position = uDim23,
					BackgroundColor3 = colorKnob2 or t1.colorOffKnob
				}):Play()
				task.spawn(t25.value58)

				return
			end

			colorKnob2 = t1.colorKnob
			v854:Create(v855, v856, {
				Position = uDim23,
				BackgroundColor3 = colorKnob2 or t1.colorOffKnob
			}):Play()
			task.spawn(t25.value58)
		end)
	end

	UICorner = function(p49, p50)
		local Frame = Instance.new("Frame")

		Frame.Name = v35()
		Frame.Size = UDim2.new(1, -16, 0, t1.rowHeight)
		Frame.BackgroundColor3 = t1.colorRow
		Frame.BorderSizePixel = 0
		Frame.Parent = p49

		local UICorner4 = Instance.new("UICorner")

		UICorner4.CornerRadius = UDim.new(0, 8)
		UICorner4.Parent = Frame

		local UIStroke = Instance.new("UIStroke")

		UIStroke.Name = v35()
		UIStroke.Thickness = 1
		UIStroke.Color = t1.colorStroke
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke.Parent = Frame

		local TextLabel = Instance.new("TextLabel")

		TextLabel.Name = v35()
		TextLabel.Size = UDim2.new(1, -78, 1, 0)
		TextLabel.Position = UDim2.new(0, 14, 0, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = p50.name
		TextLabel.TextColor3 = t1.colorText
		TextLabel.TextSize = 12
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.Parent = Frame

		local Frame2 = Instance.new("Frame")

		Frame2.Name = v35()
		Frame2.Size = UDim2.new(0, 42, 0, 22)
		Frame2.Position = UDim2.new(1, -52, 0.5, -11)

		local colorOn = t25.value9[p50.tag]

		if colorOn then
			colorOn = t1.colorOn
		end

		Frame2.BackgroundColor3 = colorOn or t1.colorOff
		Frame2.BorderSizePixel = 0
		Frame2.Active = false
		Frame2.ZIndex = 3
		Frame2.Parent = Frame

		local UICorner5 = Instance.new("UICorner")

		UICorner5.CornerRadius = UDim.new(1, 0)
		UICorner5.Parent = Frame2

		local UIStroke2 = Instance.new("UIStroke")

		UIStroke2.Thickness = 1

		local colorOn2 = t25.value9[p50.tag]

		if colorOn2 then
			colorOn2 = t1.colorOn
		end

		UIStroke2.Color = colorOn2 or Color3.fromRGB(50, 56, 76)
		UIStroke2.Parent = Frame2

		local Frame3 = Instance.new("Frame")

		Frame3.Name = v35()
		Frame3.Size = UDim2.new(0, 16, 0, 16)

		local uDim2 = t25.value9[p50.tag]

		if uDim2 then
			uDim2 = UDim2.new(0, 23, 0.5, -8)
		end

		Frame3.Position = uDim2 or UDim2.new(0, 3, 0.5, -8)

		local colorKnob = t25.value9[p50.tag]

		if colorKnob then
			colorKnob = t1.colorKnob
		end

		Frame3.BackgroundColor3 = colorKnob or t1.colorOffKnob
		Frame3.BorderSizePixel = 0
		Frame3.Active = false
		Frame3.ZIndex = 4
		Frame3.Parent = Frame2

		local UICorner6 = Instance.new("UICorner")

		UICorner6.CornerRadius = UDim.new(1, 0)
		UICorner6.Parent = Frame3

		local TextButton = Instance.new("TextButton")

		TextButton.Name = v35()
		TextButton.Size = UDim2.new(1, 0, 1, 0)
		TextButton.BackgroundTransparency = 1
		TextButton.Text = ""
		TextButton.Active = true
		TextButton.ZIndex = 10
		TextButton.AutoButtonColor = false
		TextButton.Parent = Frame
		TextButton.MouseEnter:Connect(function()
			local v873 = TweenService
			local v874 = Frame
			local v875 = tweenInfo
			local v876 = t1

			v873.Create(v873, v874, v875, {
				BackgroundColor3 = v876.colorRowHover
			}):Play()

			local v877 = TweenService
			local v878 = UIStroke
			local v879 = tweenInfo
			local v880 = t1

			v877.Create(v877, v878, v879, {
				Color = v880.colorStrokeLight
			}):Play()
		end)

		local function v881()
			local v882 = TweenService
			local v883 = Frame

			v882.Create(v882, v883, tweenInfo, {
				BackgroundColor3 = t1.colorRow
			}):Play()

			local v884 = TweenService
			local v885 = UIStroke
			local v886 = tweenInfo
			local t36 = {
				Color = t1.colorStroke
			}

			v884.Create(v884, v885, v886, t36):Play()
		end

		TextButton.MouseLeave:Connect(v881)
		v32(TextButton, function()
			t25.value9[p50.tag] = not t25.value9[p50.tag]

			local colorKnob2 = t25.value9[p50.tag]
			local v889 = TweenService
			local v890 = Frame2
			local v891 = tweenInfo
			local colorOn3

			if colorKnob2 then
				colorOn3 = t1.colorOn
			else
				colorOn3 = colorKnob2
			end

			v889:Create(v890, v891, {
				BackgroundColor3 = colorOn3 or t1.colorOff
			}):Play()

			local v893 = TweenService
			local v894 = UIStroke2
			local v895 = tweenInfo
			local colorOn4

			if colorKnob2 then
				colorOn4 = t1.colorOn
			else
				colorOn4 = colorKnob2
			end

			local color3 = colorOn4 or Color3.fromRGB(50, 56, 76)

			v893.Create(v893, v894, v895, {
				Color = color3
			}):Play()

			local v898 = TweenService
			local v899 = Frame3
			local v900 = tweenInfo3
			local uDim22

			if colorKnob2 then
				uDim22 = UDim2.new(0, 23, 0.5, -8)
			else
				uDim22 = colorKnob2
			end

			local uDim23 = uDim22 or UDim2.new(0, 3, 0.5, -8)

			if not colorKnob2 then
				v898:Create(v899, v900, {
					Position = uDim23,
					BackgroundColor3 = colorKnob2 or t1.colorOffKnob
				}):Play()

				return
			end

			colorKnob2 = t1.colorKnob
			v898:Create(v899, v900, {
				Position = uDim23,
				BackgroundColor3 = colorKnob2 or t1.colorOffKnob
			}):Play()
		end)
	end
	UIGradient = function(p51, p52, p53, p54, p55, p56, p57, p58)
		local v903 = p55 or 20
		local v904 = p56 or 600
		local v905 = p57 or 15

		if t25.value9[p53] == nil then
			t25.value9[p53] = p54
		end

		local Frame = Instance.new("Frame")

		Frame.Name = v35()
		Frame.Size = UDim2.new(1, -16, 0, t1.rowHeight)
		Frame.BackgroundColor3 = t1.colorRow
		Frame.BorderSizePixel = 0
		Frame.Parent = p51

		local UICorner4 = Instance.new("UICorner")

		UICorner4.CornerRadius = UDim.new(0, 8)
		UICorner4.Parent = Frame

		local UIStroke = Instance.new("UIStroke")

		UIStroke.Name = v35()
		UIStroke.Thickness = 1
		UIStroke.Color = t1.colorStroke
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke.Parent = Frame

		local TextLabel = Instance.new("TextLabel")

		TextLabel.Name = v35()
		TextLabel.Size = UDim2.new(1, -125, 1, 0)
		TextLabel.Position = UDim2.new(0, 14, 0, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = p52
		TextLabel.TextColor3 = t1.colorText
		TextLabel.TextSize = 12
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.Parent = Frame

		local Frame2 = Instance.new("Frame")

		Frame2.Name = v35()
		Frame2.Size = UDim2.new(0, 108, 0, 26)
		Frame2.Position = UDim2.new(1, -118, 0.5, -13)
		Frame2.BackgroundTransparency = 1
		Frame2.Parent = Frame

		local TextButton = Instance.new("TextButton")

		TextButton.Name = v35()
		TextButton.Size = UDim2.new(0, 24, 0, 24)
		TextButton.Position = UDim2.new(0, 0, 0.5, -12)
		TextButton.BackgroundColor3 = t1.colorBtn
		TextButton.Text = "–"
		TextButton.TextColor3 = t1.colorText
		TextButton.TextSize = 13
		TextButton.Font = Enum.Font.GothamBold
		TextButton.BorderSizePixel = 0
		TextButton.AutoButtonColor = false
		TextButton.Parent = Frame2

		local UICorner5 = Instance.new("UICorner")

		UICorner5.CornerRadius = UDim.new(0, 5)
		UICorner5.Parent = TextButton

		local UIStroke2 = Instance.new("UIStroke")

		UIStroke2.Thickness = 1
		UIStroke2.Color = t1.colorStroke
		UIStroke2.Parent = TextButton

		local Frame3 = Instance.new("Frame")

		Frame3.Name = v35()
		Frame3.Size = UDim2.new(0, 52, 0, 24)
		Frame3.Position = UDim2.new(0, 28, 0.5, -12)
		Frame3.BackgroundColor3 = t1.colorBg
		Frame3.BorderSizePixel = 0
		Frame3.Parent = Frame2

		local UICorner6 = Instance.new("UICorner")

		UICorner6.CornerRadius = UDim.new(0, 5)
		UICorner6.Parent = Frame3

		local UIStroke3 = Instance.new("UIStroke")

		UIStroke3.Thickness = 1
		UIStroke3.Color = t1.colorStroke
		UIStroke3.Parent = Frame3

		local v917

		if p58 then
			local format = string.format
			local v919 = t25.value9[p53]

			v917 = format("%.3f", tonumber(v919) or p54)
		else
			v917 = p58
		end

		local text = v917 or tostring(t25.value9[p53] or p54)
		local TextBox = Instance.new("TextBox")

		TextBox.Name = v35()
		TextBox.Size = UDim2.new(1, 0, 1, 0)
		TextBox.BackgroundTransparency = 1
		TextBox.Text = text
		TextBox.TextColor3 = t1.colorOn
		TextBox.TextSize = p58 and 10 or 11.5
		TextBox.Font = Enum.Font.GothamBold
		TextBox.ClearTextOnFocus = false
		TextBox.Parent = Frame3

		local TextButton2 = Instance.new("TextButton")

		TextButton2.Name = v35()
		TextButton2.Size = UDim2.new(0, 24, 0, 24)
		TextButton2.Position = UDim2.new(1, -24, 0.5, -12)
		TextButton2.BackgroundColor3 = t1.colorBtn
		TextButton2.Text = "+"
		TextButton2.TextColor3 = t1.colorText
		TextButton2.TextSize = 13
		TextButton2.Font = Enum.Font.GothamBold
		TextButton2.BorderSizePixel = 0
		TextButton2.AutoButtonColor = false
		TextButton2.Parent = Frame2

		local UICorner7 = Instance.new("UICorner")

		UICorner7.CornerRadius = UDim.new(0, 5)
		UICorner7.Parent = TextButton2

		local UIStroke4 = Instance.new("UIStroke")

		UIStroke4.Thickness = 1
		UIStroke4.Color = t1.colorStroke
		UIStroke4.Parent = TextButton2

		local function v925(p59)
			local v926 = v903
			local v927 = v904
			local v928 = math.clamp(p59, v926, v927)

			t25.value9[p53] = v928

			if p58 then
				t25.value9.AIMBOT_DRAG_MANUAL = true
				TextBox.Text = string.format("%.3f", v928)
			else
				local v929 = v928 + 0.5
				local v930 = math.floor(v929)

				t25.value9[p53] = v930
				TextBox.Text = tostring(v930)
			end
		end

		v32(TextButton, function()
			local v931 = t25.value9[p53]

			v925(tonumber(v931) or p54 - v905)
		end)
		v32(TextButton2, function()
			local v932 = t25.value9[p53]

			v925(tonumber(v932) or p54 + v905)
		end)
		TextButton.MouseEnter:Connect(function()
			local v933 = TweenService
			local v934 = TextButton
			local v935 = tweenInfo

			v933.Create(v933, v934, v935, {
				BackgroundColor3 = t1.colorBtnHover
			}):Play()
		end)
		TextButton.MouseLeave:Connect(function()
			local v936 = TweenService
			local v937 = TextButton
			local v938 = tweenInfo
			local t37 = {
				BackgroundColor3 = t1.colorBtn
			}

			v936.Create(v936, v937, v938, t37):Play()
		end)
		TextButton2.MouseEnter:Connect(function()
			TweenService:Create(TextButton2, tweenInfo, {
				BackgroundColor3 = t1.colorBtnHover
			}):Play()
		end)
		TextButton2.MouseLeave:Connect(function()
			TweenService:Create(TextButton2, tweenInfo, {
				BackgroundColor3 = t1.colorBtn
			}):Play()
		end)
		TextBox.FocusLost:Connect(function()
			local Text = TextBox.Text
			local v941 = tonumber(Text)
			local v942

			if v941 then
				if v903 <= v941 then
					v942 = v941 <= v904
				else
					v942 = false
				end
			else
				v942 = v941
			end

			if v942 then
				v925(v941)
			elseif p58 then
				local v943 = TextBox
				local format = string.format
				local v945 = t25.value9[p53]

				v943.Text = format("%.3f", tonumber(v945) or p54)

				return
			else
				local v946 = TextBox
				local v947 = t25.value9[p53]

				v946.Text = tostring(v947)

				return
			end
		end)
	end
	v392 = function(p60, p61, p62)
		local Frame = Instance.new("Frame")

		Frame.Name = v35()
		Frame.Size = UDim2.new(1, -16, 0, t1.rowHeight)
		Frame.BackgroundColor3 = t1.colorRow
		Frame.BorderSizePixel = 0
		Frame.Parent = p60

		local UICorner4 = Instance.new("UICorner")

		UICorner4.CornerRadius = UDim.new(0, 8)
		UICorner4.Parent = Frame

		local UIStroke = Instance.new("UIStroke")

		UIStroke.Name = v35()
		UIStroke.Thickness = 1
		UIStroke.Color = t1.colorStroke
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke.Parent = Frame

		local TextLabel = Instance.new("TextLabel")

		TextLabel.Name = v35()
		TextLabel.Size = UDim2.new(1, -78, 1, 0)
		TextLabel.Position = UDim2.new(0, 14, 0, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = p61
		TextLabel.TextColor3 = t1.colorText
		TextLabel.TextSize = 12
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.Parent = Frame

		local Frame2 = Instance.new("Frame")

		Frame2.Name = v35()
		Frame2.Size = UDim2.new(0, 42, 0, 22)
		Frame2.Position = UDim2.new(1, -52, 0.5, -11)
		Frame2.BackgroundColor3 = t1.colorOff
		Frame2.BorderSizePixel = 0
		Frame2.Active = false
		Frame2.ZIndex = 3
		Frame2.Parent = Frame

		local UICorner5 = Instance.new("UICorner")

		UICorner5.CornerRadius = UDim.new(1, 0)
		UICorner5.Parent = Frame2

		local UIStroke2 = Instance.new("UIStroke")

		UIStroke2.Thickness = 1
		UIStroke2.Color = Color3.fromRGB(50, 56, 76)
		UIStroke2.Parent = Frame2

		local Frame3 = Instance.new("Frame")

		Frame3.Name = v35()
		Frame3.Size = UDim2.new(0, 16, 0, 16)
		Frame3.Position = UDim2.new(0, 3, 0.5, -8)
		Frame3.BackgroundColor3 = t1.colorOffKnob
		Frame3.BorderSizePixel = 0
		Frame3.Active = false
		Frame3.ZIndex = 4
		Frame3.Parent = Frame2

		local UICorner6 = Instance.new("UICorner")

		UICorner6.CornerRadius = UDim.new(1, 0)
		UICorner6.Parent = Frame3

		local TextButton = Instance.new("TextButton")

		TextButton.Name = v35()
		TextButton.Size = UDim2.new(1, 0, 1, 0)
		TextButton.BackgroundTransparency = 1
		TextButton.Text = ""
		TextButton.Active = true
		TextButton.ZIndex = 10
		TextButton.AutoButtonColor = false
		TextButton.Parent = Frame
		TextButton.MouseEnter:Connect(function()
			local v958 = TweenService
			local v959 = Frame
			local v960 = tweenInfo
			local t38 = {
				BackgroundColor3 = t1.colorRowHover
			}

			v958.Create(v958, v959, v960, t38):Play()

			local v962 = TweenService
			local v963 = UIStroke
			local v964 = tweenInfo
			local t39 = {
				Color = t1.colorStrokeLight
			}

			v962.Create(v962, v963, v964, t39):Play()
		end)
		TextButton.MouseLeave:Connect(function()
			local v966 = TweenService
			local v967 = Frame
			local v968 = tweenInfo

			v966.Create(v966, v967, v968, {
				BackgroundColor3 = t1.colorRow
			}):Play()

			local v969 = TweenService
			local v970 = UIStroke
			local v971 = tweenInfo
			local v972 = t1

			v969.Create(v969, v970, v971, {
				Color = v972.colorStroke
			}):Play()
		end)
		v32(TextButton, function()
			local v973 = t25.value9[p62]

			t25.value9[p62] = not v973

			local v974 = t25.value9[p62]
			local v975 = TweenService
			local v976 = Frame2
			local v977 = tweenInfo
			local colorOn

			if v974 then
				colorOn = t1.colorOn
			else
				colorOn = v974
			end

			v975:Create(v976, v977, {
				BackgroundColor3 = colorOn or t1.colorOff
			}):Play()

			local v979 = TweenService
			local v980 = UIStroke2
			local v981 = tweenInfo
			local colorOn2

			if v974 then
				colorOn2 = t1.colorOn
			else
				colorOn2 = v974
			end

			v979:Create(v980, v981, {
				Color = colorOn2 or Color3.fromRGB(50, 56, 76)
			}):Play()

			local v983 = TweenService
			local v984 = Frame3
			local v985 = tweenInfo3
			local s21 = "Position"
			local uDim2

			if v974 then
				uDim2 = UDim2.new(0, 23, 0.5, -8)
			else
				uDim2 = v974
			end

			local uDim22 = uDim2 or UDim2.new(0, 3, 0.5, -8)
			local colorKnob

			if v974 then
				colorKnob = t1.colorKnob
			else
				colorKnob = v974
			end

			v983:Create(v984, v985, {
				[s21] = uDim22,
				BackgroundColor3 = colorKnob or t1.colorOffKnob
			}):Play()

			if v974 then
				v455()

				return
			end

			local v990 = not t25.value9.PLAYER_ESP_BOX

			if v990 then
				v990 = not t25.value9.PLAYER_ESP_NAME

				if v990 then
					v990 = not t25.value9.PLAYER_ESP_DISTANCE

					if v990 then
						v990 = not t25.value9.PLAYER_ESP_HEALTH
					end
				end
			end

			if not v990 then
				v455()

				return
			end

			v404()
			v455()
		end)
	end
	UICorner2(t25.value44[1], "HIGHLIGHTS")

	for _, v in ipairs(t2) do
		Connect(t25.value44[1], v)
	end

	UICorner3(t25.value44[1])
	v371(t25.value44[1])
	UICorner2(t25.value44[2], "LOOT DETECTION")

	for _, v in ipairs(t3) do
		Connect(t25.value44[2], v)
	end

	UICorner3(t25.value44[2])
	UICorner2(t25.value44[2], "LOOT FILTERS")
	v377, LocalPlayer, value1 = ipairs(t10)

	while true do
		value1, t23 = v377(LocalPlayer, value1)

		if not value1 then
			break
		end

		v812(t25.value44[2], t23)
	end

	UICorner2(t25.value44[3], "COMBAT")

	for _, v in ipairs(t4) do
		Connect(t25.value44[3], v)
	end

	UICorner3(t25.value44[3])
	UICorner2(t25.value44[3], "AIMBOT CONFIG")
	UIGradient(t25.value44[3], "CIRCLE SIZE", "AIMBOT_CIRCLE_SIZE", 150, 20, 600, 15, false)

	for _, v in ipairs(t11) do
		UICorner(t25.value44[3], v)
	end

	UICorner2(t25.value44[4], "MOVEMENT")
	v812, UICorner, UIGradient = ipairs(t5)

	while true do
		UIGradient, v377 = v812(UICorner, UIGradient)

		if not UIGradient then
			break
		end

		Connect(t25.value44[4], v377)
	end

	UICorner3(t25.value44[4])
	UICorner2(t25.value44[4], "VISUAL")

	for _, v in ipairs(t6) do
		Connect(t25.value44[4], v)
	end

	v392(t25.value51, "BOX (2D Box)", "PLAYER_ESP_BOX")
	v392(t25.value51, "NAME (Player)", "PLAYER_ESP_NAME")
	v392(t25.value51, "DISTANCE (Studs)", "PLAYER_ESP_DISTANCE")
	v392(t25.value51, "HEALTH (HP)", "PLAYER_ESP_HEALTH")
	UICorner2(t25.value44[5], "ENVIRONMENT")

	for _, v in ipairs(t7) do
		Connect(t25.value44[5], v)
	end

	UICorner2 = function()
		t25.value10 = not t25.value10

		local value10 = t25.value10

		if value10 then
			value10 = UDim2.new(0, t1.width, 0, t1.titleH)
		end

		local uDim2 = value10 or UDim2.new(0, t1.width, 0, t25.value8)
		local value102 = t25.value10

		TweenService:Create(t25.value36, tweenInfo2, {
			Size = uDim2
		}):Play()
		t25.value39.Text = value102 and "▼" or value102 or "▲"

		if t25.value10 then
			t25.value37.Visible = false
		else
			task.delay(0.18, function()
				if t25.value10 then
					return
				end

				t25.value37.Visible = true
			end)
		end

		t25.value38.Visible = not t25.value10
		t25.value41.Visible = not t25.value10
		t25.value46.Visible = not t25.value10
		t25.value47.Visible = not t25.value10

		for _, v in ipairs(t25.value44) do
			if t25.value10 then
				v.Visible = false
			else
				v.Visible = t25.value44[t25.value52] == v
			end
		end

		if not t25.value10 then
			return
		end

		t25.value50.Visible = false
	end
	v455()
	v32(t25.value39, UICorner2)
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.KeyCode ~= Enum.KeyCode.RightShift then
			return
		end

		t25.value36.Visible = not t25.value36.Visible

		if t25.value36.Visible then
			return
		end

		t25.value50.Visible = false
	end)
	UICorner2, UICorner3, Connect = ipairs(Players:GetPlayers())
	v812 = function(p63)
		if p63 == t24.value1 then
			return
		end

		if t25.value11[p63] then
			for _, v in ipairs(t25.value11[p63]) do
				v:Disconnect()
			end
		end

		t25.value11[p63] = {}
		t25.value7(p63)
		table.insert(t25.value11[p63], p63.CharacterAdded:Connect(function(character)
			if not character:WaitForChild("HumanoidRootPart", 5) then
				return
			end

			t25.value57(p63)
		end))
		table.insert(t25.value11[p63], p63.CharacterRemoving:Connect(function(character)
			t25.value55(character)
		end))

		if not p63.Character then
			return
		end

		task.spawn(function()
			t25.value57(p63)
		end)
	end

	while true do
		Connect, UICorner = UICorner2(UICorner3, Connect)

		if not Connect then
			break
		end

		v812(UICorner)
	end

	Players.PlayerAdded:Connect(v812)
	Players.PlayerRemoving:Connect(function(player)
		if not t25.value11[player] then
			v395(player)
			t25.value14[player.UserId] = nil

			return
		end

		for _, v in ipairs(t25.value11[player]) do
			v:Disconnect()
		end

		t25.value11[player] = nil
		v395(player)
		t25.value14[player.UserId] = nil
	end)

	for _, descendant in ipairs(Workspace:GetDescendants()) do
		t25.value54(descendant)
	end

	Workspace.DescendantAdded:Connect(function(descendant)
		local function v1014()
			t25.value54(descendant)

			local isHumanoid = descendant:IsA("Humanoid")

			if isHumanoid then
				isHumanoid = descendant.Parent
			end

			if not isHumanoid then
				return
			end

			t25.value54(descendant.Parent)
		end

		task.delay(0.12, v1014)
	end)
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		local v1016 = input.KeyCode == Enum.KeyCode.Space

		if v1016 then
			v1016 = t25.value9.INFINITY_JUMP
		end

		local HumanoidRootPart = v1016 and (t24.value1.Character and t24.value1.Character:FindFirstChild("HumanoidRootPart"))

		if not HumanoidRootPart then
			return
		end

		HumanoidRootPart.Velocity = HumanoidRootPart.Velocity + Vector3.new(0, t25.value9.INF_JUMP_POWER or 25, 0)
	end)
	RunService.Heartbeat:Connect(unpack_({ newcclosure_(function()
			if not t25.value9.FAST_RUN then
				return
			end

			local Character = t24.value1.Character
			local Humanoid = Character and Character:FindFirstChild("Humanoid")

			if not Humanoid then
				return
			end

			local value3

			if t25.value4 then
				value3 = t25.value3
			else
				local v1021 = Humanoid.MoveDirection.Magnitude > 0.05

				if v1021 then
					v1021 = t25.value2
				end

				value3 = v1021 or t25.value3
			end

			if Humanoid.WalkSpeed == value3 then
				return
			end

			Humanoid.WalkSpeed = value3
		end) }))
	RunService.RenderStepped:Connect(newcclosure_(function()
		if not t25.value9.NO_VISOR then
			return
		end

		local function v1022()
			local PlayerGui = t24.value1:FindFirstChild("PlayerGui")
			local NoInsetGui = PlayerGui and PlayerGui:FindFirstChild("NoInsetGui")

			if not NoInsetGui then
				return
			end

			local MainFrame = NoInsetGui:FindFirstChild("MainFrame")

			if MainFrame then
				MainFrame = NoInsetGui.MainFrame:FindFirstChild("ScreenEffects")
			end

			if not MainFrame then
				return
			end

			if MainFrame:FindFirstChild("Visor") then
				MainFrame.Visor.Visible = false
			end

			if MainFrame:FindFirstChild("HelmetMask") then
				MainFrame.HelmetMask.Visible = false
			end

			if MainFrame:FindFirstChild("Mask") then
				MainFrame.Mask.Visible = false
			end

			if MainFrame:FindFirstChild("Flashbang") then
				MainFrame.Flashbang.Visible = false
			end

			local Mask = MainFrame:FindFirstChild("Mask")

			if Mask then
				Mask = MainFrame.Mask:FindFirstChild("GP5")
			end

			local GasMask

			if Mask then
				GasMask = Mask:FindFirstChild("GasMask")
			else
				GasMask = Mask
			end

			if not (GasMask and Mask.GasMask.Playing) then
				return
			end

			Mask.GasMask.Playing = false
		end

		pcall(v1022)
	end))
	task.spawn(function()
		while true do
			repeat
				task.wait(math.random(60, 120))
			until t25.value9.FAST_RUN

			task.wait(math.random(2, 4) / 10)
			t25.value4 = false
		end
	end)
	RunService.RenderStepped:Connect(unpack_({ newcclosure_(function()
			local PLAYER_ESP_BOX = t25.value9.PLAYER_ESP_BOX
			local PLAYER_ESP_DISTANCE = t25.value9.PLAYER_ESP_DISTANCE
			local PLAYER_ESP_HEALTH = t25.value9.PLAYER_ESP_HEALTH
			local PLAYER_ESP_NAME = t25.value9.PLAYER_ESP_NAME
			local v1032 = not PLAYER_ESP_BOX

			if v1032 then
				v1032 = not PLAYER_ESP_DISTANCE

				if v1032 then
					v1032 = not PLAYER_ESP_HEALTH

					if v1032 then
						v1032 = not PLAYER_ESP_NAME
					end
				end
			end

			if v1032 then
				v404()

				return
			end

			local CurrentCamera = Workspace.CurrentCamera

			if not CurrentCamera then
				return
			end

			local Character = t24.value1.Character

			if Character then
				Character = Character:FindFirstChild("HumanoidRootPart")
			end

			local v1035 = Players

			for _, player in ipairs(v1035.GetPlayers(v1035)) do
				if player ~= t24.value1 then
					if not t25.value6[player] then
						t25.value7(player)
					end

					local v1038 = t25.value6[player]

					if v1038 then
						local function v1039()
							local Character2 = player.Character
							local HumanoidRootPart

							if Character2 then
								HumanoidRootPart = Character2:FindFirstChild("HumanoidRootPart")
							else
								HumanoidRootPart = Character2
							end

							local Humanoid

							if Character2 then
								Humanoid = Character2:FindFirstChildOfClass("Humanoid")
							else
								Humanoid = Character2
							end

							if Character2 then
								if HumanoidRootPart then
									if Humanoid then
										Character2 = Humanoid.Health > 0
									else
										Character2 = Humanoid
									end
								else
									Character2 = HumanoidRootPart
								end
							end

							if not Character2 then
								if v1038.Box then
									v1038.Box.Visible = false
								end

								if v1038.Name then
									v1038.Name.Visible = false
								end

								if v1038.HealthBg then
									v1038.HealthBg.Visible = false
								end

								if v1038.HealthBar then
									v1038.HealthBar.Visible = false
								end

								if not v1038.HealthText then
									return
								end

								v1038.HealthText.Visible = false

								return
							end

							local v1043, v1044 = CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position)

							if not v1044 then
								if v1038.Box then
									v1038.Box.Visible = false
								end

								if v1038.Name then
									v1038.Name.Visible = false
								end

								if v1038.HealthBg then
									v1038.HealthBg.Visible = false
								end

								if v1038.HealthBar then
								elseif v1038.HealthText then
									v1038.HealthText.Visible = false

									return
								else
									return
								end

								v1038.HealthBar.Visible = false

								if v1038.HealthText then
									v1038.HealthText.Visible = false

									return
								else
									return
								end
							end

							local FRIEND_ESP = t25.value53(player)
							local FRIEND_ESP2

							if FRIEND_ESP then
								FRIEND_ESP2 = t25.value9.FRIEND_ESP
							else
								FRIEND_ESP2 = FRIEND_ESP
							end

							if FRIEND_ESP2 then
								FRIEND_ESP2 = t1.TEAM_COLOR
							end

							local color3 = FRIEND_ESP2 or Color3.fromRGB(0, 255, 0)

							if FRIEND_ESP then
								FRIEND_ESP = t25.value9.FRIEND_ESP
							end

							if FRIEND_ESP then
								FRIEND_ESP = t1.TEAM_COLOR
							end

							local color32 = FRIEND_ESP or Color3.fromRGB(240, 245, 255)
							local v1049 = CurrentCamera
							local Position = HumanoidRootPart.Position
							local Vector3_ = Vector3
							local v1052 = v1049.WorldToViewportPoint(v1049, Position + Vector3_.new(0, 3, 0))
							local v1053 = CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position - Vector3.new(0, 3, 0))
							local v1054 = v1052.Y - v1053.Y
							local v1055 = math.abs(v1054)
							local v1056 = v1055 / 1.5
							local v1057 = v1043.X - v1056 / 2
							local v1058 = v1043.Y - v1055 / 2
							local Box = PLAYER_ESP_BOX

							if Box then
								Box = v1038.Box
							end

							local Box2

							if Box then
								v1038.Box.Size = Vector2.new(v1056, v1055)
								v1038.Box.Position = Vector2.new(v1057, v1058)
								v1038.Box.Color = color3
								Box2 = v1038.Box
								Box2.Visible = true
							elseif v1038.Box then
								Box2 = v1038.Box
								Box2.Visible = false
							else
								Box2 = v1058
							end

							local HealthBg = PLAYER_ESP_HEALTH

							if HealthBg then
								HealthBg = v1038.HealthBg

								if HealthBg then
									HealthBg = v1038.HealthBar
								end
							end

							if HealthBg then
								local v1063 = Humanoid.MaxHealth > 0

								if v1063 then
									local v1064 = Humanoid.Health / Humanoid.MaxHealth

									v1063 = math.clamp(v1064, 0, 1)
								end

								local v1065 = v1063 or 0
								local v1066 = v1055 * v1065

								v1038.HealthBg.Size = Vector2.new(4, v1055 + 2)
								v1038.HealthBg.Position = Vector2.new(v1057 - 6, v1058 - 1)
								v1038.HealthBg.Visible = true
								v1038.HealthBar.Size = Vector2.new(2, v1066)
								v1038.HealthBar.Position = Vector2.new(v1057 - 5, v1058 + v1055 - v1066)

								local HealthBar = v1038.HealthBar
								local color33 = Color3.fromRGB
								local v1068 = 255 - 255 * v1065
								local v1069 = math.floor(v1068)
								local v1070 = 255 * v1065

								HealthBar.Color = color33(v1069, math.floor(v1070), 0)
								v1038.HealthBar.Visible = true

								if v1038.HealthText then
									local HealthText = v1038.HealthText
									local format = string.format
									local v1073 = v1065 * 100

									HealthText.Text = format("[%d]", (math.floor(v1073)))
									v1038.HealthText.Position = Vector2.new(v1038.HealthBg.Position.X - 18, v1038.HealthBg.Position.Y - 2)
									v1038.HealthText.Visible = true
								end
							else
								if v1038.HealthBg then
									v1038.HealthBg.Visible = false
								end

								if v1038.HealthBar then
									v1038.HealthBar.Visible = false
								end

								if v1038.HealthText then
									v1038.HealthText.Visible = false
								end
							end

							local Name = PLAYER_ESP_NAME or PLAYER_ESP_DISTANCE

							if Name then
								Name = v1038.Name
							end

							if Name then
							elseif v1038.Name then
								v1038.Name.Visible = false

								return
							else
								return
							end

							local v1075 = Character

							if v1075 then
								local v1076 = (Character.Position - HumanoidRootPart.Position).Magnitude + 0.5

								v1075 = math.floor(v1076)
							end

							if not v1075 then
								local Z = v1043.Z

								v1075 = math.floor(Z)
							end

							v1038.Name.Position = Vector2.new(v1043.X, v1058 - 19)
							v1038.Name.Color = color32

							local v1078 = PLAYER_ESP_NAME

							if not v1078 then
								if v1078 then
									v1038.Name.Text = string.format("%s [%dm]", player.Name, v1075)
								elseif PLAYER_ESP_NAME then
									v1038.Name.Text = player.Name
								else
									v1038.Name.Text = string.format("[%dm]", v1075)
								end

								v1038.Name.Visible = true

								return
							end

							v1078 = PLAYER_ESP_DISTANCE

							if v1078 then
								v1038.Name.Text = string.format("%s [%dm]", player.Name, v1075)
							elseif PLAYER_ESP_NAME then
								v1038.Name.Text = player.Name
							else
								v1038.Name.Text = string.format("[%dm]", v1075)
							end

							v1038.Name.Visible = true
						end

						pcall(v1039)
					end
				end
			end
		end) }))
	task.spawn(function()
		while true do
			task.wait(5 + math.random() * 5)

			local function v1079()
				if not Players then
					return
				end

				local v1080 = Players

				for _, player in ipairs(v1080.GetPlayers(v1080)) do
					t25.value57(player)
				end
			end

			pcall(v1079)
		end
	end)
end

v371 = function(p64)
	local Frame = Instance.new("Frame")

	Frame.Name = v35()
	Frame.Size = UDim2.new(1, -16, 0, 56)
	Frame.BackgroundColor3 = Color3.fromRGB(20, 23, 35)
	Frame.BorderSizePixel = 0
	Frame.Parent = p64

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = Frame

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Thickness = 1
	UIStroke.Color = Color3.fromRGB(55, 65, 110)
	UIStroke.Parent = Frame

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = v35()
	TextLabel.Size = UDim2.new(0, 32, 0, 32)
	TextLabel.Position = UDim2.new(0, 12, 0.5, -16)
	TextLabel.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
	TextLabel.Text = "💬"
	TextLabel.TextSize = 16
	TextLabel.BorderSizePixel = 0
	TextLabel.Parent = Frame

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(0, 8)
	UICorner2.Parent = TextLabel

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Name = v35()
	TextLabel2.Size = UDim2.new(1, -170, 0, 18)
	TextLabel2.Position = UDim2.new(0, 52, 0, 10)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = "Delta Community"
	TextLabel2.TextColor3 = t1.colorText
	TextLabel2.TextSize = 12
	TextLabel2.Font = Enum.Font.GothamBold
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.Parent = Frame

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Name = v35()
	TextLabel3.Size = UDim2.new(1, -170, 0, 16)
	TextLabel3.Position = UDim2.new(0, 52, 0, 28)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = "Daily updates & support"
	TextLabel3.TextColor3 = t1.colorTextDim
	TextLabel3.TextSize = 9.5
	TextLabel3.Font = Enum.Font.Gotham
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel3.Parent = Frame

	local TextButton = Instance.new("TextButton")

	TextButton.Name = v35()
	TextButton.Size = UDim2.new(0, 96, 0, 28)
	TextButton.Position = UDim2.new(1, -106, 0.5, -14)
	TextButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
	TextButton.Text = "Join Server"
	TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton.TextSize = 11
	TextButton.Font = Enum.Font.GothamBold
	TextButton.BorderSizePixel = 0
	TextButton.AutoButtonColor = false
	TextButton.Parent = Frame

	local UICorner3 = Instance.new("UICorner")

	UICorner3.CornerRadius = UDim.new(0, 6)
	UICorner3.Parent = TextButton
	TextButton.MouseEnter:Connect(function()
		local v1092 = TweenService
		local v1093 = TextButton
		local v1094 = tweenInfo
		local t40 = {
			BackgroundColor3 = Color3.fromRGB(110, 125, 255)
		}

		v1092.Create(v1092, v1093, v1094, t40):Play()
	end)

	local MouseLeave = TextButton.MouseLeave

	local function v1097()
		local v1098 = TweenService
		local v1099 = TextButton
		local v1100 = tweenInfo
		local Color3_ = Color3

		v1098.Create(v1098, v1099, v1100, {
			BackgroundColor3 = Color3_.fromRGB(88, 101, 242)
		}):Play()
	end

	MouseLeave.Connect(MouseLeave, v1097)
	v32(TextButton, function()
		local function v1102()
			if not setclipboard then
				return
			end

			setclipboard("https://discord.gg/aHhdKyMnq4")
			TextButton.Text = "Copied!"
			TextButton.BackgroundColor3 = Color3.fromRGB(50, 180, 100)
			task.delay(1.5, function()
				if not TextButton then
					return
				end

				TextButton.Text = "Join Server"
				TextButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
			end)
		end

		pcall(v1102)
	end)
end
task.spawn(function()
	pcall(v372)
end)
