return function(module, _, _, _, _, _)
  return function(_, module, config)
    local state = _[1]
    return function()
      local tweenService = game:GetService("TweenService")
      local userInputService = game:GetService("UserInputService")
      local contextActionService = game:GetService("ContextActionService")
      local textService = game:GetService("TextService")
      local players = game:GetService("Players")
      local coreGui = game:GetService("CoreGui")
      local httpService = game:GetService("HttpService")
      local lighting = game:GetService("Lighting")
      local runService = game:GetService("RunService")
      local guiService = game:GetService("GuiService")
      local localPlayer, library = players.LocalPlayer, {}
      library.__index = library
      library.Toggles = {}
      library.Options = {}
      library.Tabs = {}
      library.Labels = {}
      library.Buttons = {}
      library.Dialogues = {}
      library.Signals = {}
      library.UnloadSignals = {}
      library.Registry = {}
      library.RegistryMap = {}
      library.Unloaded = false
      library.Toggled = true
      library.VideoLink = ""
      library.NotifyOnError = false
      library.ShowCustomCursor = false
      library.Font = Enum.Font.Gotham
      library.GlowStrength = 0.2
      local setMetatable, weakCache = setmetatable, { __mode = "k" }
      local glowCache = setMetatable({}, weakCache)
      library.Theme = {
        Window = Color3.fromRGB(16, 9, 20),
        Window2 = Color3.fromRGB(22, 13, 27),
        Sidebar = Color3.fromRGB(18, 11, 21),
        Topbar = Color3.fromRGB(29, 18, 32),
        Card = Color3.fromRGB(56, 36, 52),
        Card2 = Color3.fromRGB(34, 22, 37),
        Row = Color3.fromRGB(21, 13, 25),
        Stroke = Color3.fromRGB(109, 73, 98),
        StrokeSoft = Color3.fromRGB(64, 36, 63),
        Accent = Color3.fromRGB(247, 133, 190),
        Accent2 = Color3.fromRGB(169, 84, 126),
        AccentSoft = Color3.fromRGB(255, 179, 216),
        Text = Color3.fromRGB(244, 228, 241),
        TextDim = Color3.fromRGB(183, 153, 180),
        TextMute = Color3.fromRGB(134, 106, 132),
        Track = Color3.fromRGB(41, 26, 45),
        White = Color3.fromRGB(255, 245, 252),
        Green = Color3.fromRGB(115, 236, 164),
      }
      local function newInstance(className, properties)
        local instance = Instance.new(className)
        for key, value in next, properties or {}, nil do
          instance[key] = value
        end
        return instance
      end
      local function applyCorner(parent, radius)
        return newInstance("UICorner", { CornerRadius = UDim.new(0, radius or 10), Parent = parent })
      end
      local function applyStroke(parent, color, thickness, transparency)
        return newInstance("UIStroke", {
          Color = color or library.Theme.Stroke,
          Thickness = thickness or 1,
          Transparency = transparency or 0,
          ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
          Parent = parent,
        })
      end
      local function attachGlow(parent, color, thickness, spread)
        local folder = newInstance("Folder", { Name = "LunarGlowSettings", Parent = parent })
        local stroke = newInstance("UIStroke", {
          Name = "LunarSoftGlow",
          Color = color or library.Theme.Accent,
          Thickness = math.clamp((thickness or 4) * 0.5, 1.5, 4),
          Transparency = math.clamp(spread or 0.72, 0, 1),
          ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
          LineJoinMode = Enum.LineJoinMode.Round,
          Parent = folder,
        })
        local yResult = applyStroke(parent, stroke.Color, stroke.Thickness, 1)
        yResult.Name = "LunarGlowCore"
        yResult.LineJoinMode = Enum.LineJoinMode.Round
        local isA = parent.Name == "Window" and parent.Parent:IsA("ScreenGui")
        local corner, list, list2 =
          parent:FindFirstChildOfClass("UICorner"), {}, { 0.48, 0.3, 0.18, 0.1, 0.05, 0.02 }
        for index = 1, #list2, 1 do
          spread = newInstance("Frame", {
            Name = "LunarGlowRing" .. index,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Active = false,
            ClipsDescendants = false,
            ZIndex = isA and math.max(0, parent.ZIndex - 1) or parent.ZIndex,
            Parent = isA and parent.Parent or parent,
          })
          list[index] = {
            Frame = spread,
            Corner = applyCorner(spread, 0),
            Stroke = applyStroke(spread, stroke.Color, 2, 1),
          }
        end
        local function refreshGlow()
          if not parent.Parent then
            return
          end
          local width, height, element =
            parent.AbsoluteSize.X, parent.AbsoluteSize.Y, corner and corner.CornerRadius or UDim.new(0, 0)
          local element2, element3 =
            math.clamp(
              element.Scale * math.min(width, height) + element.Offset,
              0,
              math.min(width, height) * 0.5
            ),
            library.GlowStrength
          element = math.clamp(stroke.Thickness * 5, 8, 18) * (0.4 + element3 * 0.6)
          local bound, clamped =
            math.max(2, element * 0.42), math.clamp((1 - stroke.Transparency) * 1.8, 0, 1) * element3
          yResult.Color = stroke.Color
          yResult.Thickness = stroke.Thickness * (0.65 + element3 * 0.35)
          yResult.Transparency = 1 - (1 - stroke.Transparency) * element3
          yResult.Enabled = stroke.Enabled and element3 > 0
          local element4 = parent.ClipsDescendants and not isA
          for index = 1, 1 / 0, 1 do
            local item = rawget(list, index)
            if item == nil then
              break
            end
            local element, stroke, value1 = item.Frame, item.Stroke, element * (index - 1) / (#list - 1)
            local value2 = element4 and value1 + bound * 0.5 or -value1
            if isA then
              element.AnchorPoint = parent.AnchorPoint
              element.Position = UDim2.new(
                parent.Position.X.Scale,
                parent.Position.X.Offset + (2 * parent.AnchorPoint.X - 1) * value1,
                parent.Position.Y.Scale,
                parent.Position.Y.Offset + (2 * parent.AnchorPoint.Y - 1) * value1
              )
              element.Size = UDim2.new(
                parent.Size.X.Scale,
                parent.Size.X.Offset + value1 * 2,
                parent.Size.Y.Scale,
                parent.Size.Y.Offset + value1 * 2
              )
            else
              element.Position = UDim2.fromOffset(value2, value2)
              element.Size = UDim2.new(1, -value2 * 2, 1, -value2 * 2)
            end
            item.Corner.CornerRadius = UDim.new(0, math.max(0, element2 - value2))
            element.ZIndex = isA and math.max(0, parent.ZIndex - 1) or parent.ZIndex
            element.Visible = stroke.Enabled
              and element3 > 0
              and parent.Visible
              and width > 0
              and height > 0
              and (if element4 then width > value2 * 2 and height > value2 * 2 else not element4)
            stroke.Color = stroke.Color
            stroke.Thickness = bound
            stroke.Transparency = 1 - clamped * list2[index]
          end
        end
        color = { "Color", "Transparency", "Thickness", "Enabled" }
        for step = 1, 1 / 0, 1 do
          spread = rawget(color, step)
          if spread == nil then
            break
          end
          stroke:GetPropertyChangedSignal(spread):Connect(refreshGlow)
        end
        color = { "AbsoluteSize", "Visible", "ClipsDescendants", "ZIndex" }
        for limit = 1, 1 / 0, 1 do
          folder = rawget(color, limit)
          if folder == nil then
            break
          end
          parent:GetPropertyChangedSignal(folder):Connect(refreshGlow)
        end
        if corner then
          corner:GetPropertyChangedSignal("CornerRadius"):Connect(refreshGlow)
        end
        if isA then
          thickness = { "Position", "Size", "AnchorPoint" }
          for index = 1, 1 / 0, 1 do
            folder = rawget(thickness, index)
            if folder == nil then
              break
            end
            parent:GetPropertyChangedSignal(folder):Connect(refreshGlow)
          end
        end
        glowCache[stroke] = refreshGlow
        local function clearGlow()
          glowCache[stroke] = nil
          if isA then
            for index = 1, 1 / 0, 1 do
              local item = rawget(list, index)
              if item == nil then
                break
              end
              item.Frame:Destroy()
            end
          end
        end
        parent.Destroying:Connect(clearGlow)
        refreshGlow()
        return stroke
      end
      library.SetGlowStrength = function(argument1, argument2)
        local number = tonumber(argument2)
        if number then
          if number ~= number then
            return
          end
        else
          return
        end
        argument1.GlowStrength = math.clamp(number, 0, 1)
        for key, value in next, glowCache, nil do
          value()
        end
      end
      local function applyAccentDecor(parent, theme, radius, transparency)
        applyCorner(parent, radius or 10)
        return applyStroke(parent, theme and theme.AccentSoft or library.Theme.AccentSoft, 1, 0.4),
          (attachGlow(parent, theme and theme.Accent or library.Theme.Accent, 4, transparency or 0.6))
      end
      local function applyPadding(parent, left, top, right, bottom)
        return newInstance("UIPadding", {
          PaddingLeft = UDim.new(0, left or 0),
          PaddingRight = UDim.new(0, top or 0),
          PaddingTop = UDim.new(0, right or 0),
          PaddingBottom = UDim.new(0, bottom or 0),
          Parent = parent,
        })
      end
      local function applyScaleAdapter(argument3, argument4, stroke, argument5, argument6)
        if argument3:IsA("UIScale") then
          if stroke.Scale then
            stroke.Scale = 1
          end
        end
        if argument3.Name == "LunarSoftGlow" then
          if stroke.Thickness then
            stroke.Thickness = math.clamp(stroke.Thickness * 0.5, 1.5, 4)
          end
          if stroke.Transparency then
            stroke.Transparency = math.clamp(stroke.Transparency, 0, 1)
          end
        end
        argument5 = tweenService:Create(
          argument3,
          TweenInfo.new(math.min(argument4 or 0.12, 0.12), Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
          stroke
        )
        argument5:Play()
        return argument5
      end
      local function applyGradient(parent, from, to, rotation)
        return newInstance("UIGradient", {
          Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, from), ColorSequenceKeypoint.new(1, to) }),
          Rotation = rotation or 0,
          Parent = parent,
        })
      end
      local function parentToCoreGui(guiObject)
        local ok = pcall(function()
          guiObject.Parent = coreGui
        end)
        if if ok then not guiObject.Parent else not ok then
          guiObject.Parent = localPlayer:WaitForChild("PlayerGui")
        end
      end
      local function measureText(text, size, font, width)
        local text2, value3, value4, value5 =
          tostring(text), size or 14, font or Enum.Font.Gotham, module[23](Vector2.new(width or 10000, 10000))
        return (textService:GetTextSize(text2, value3, value4, module:bD(value5)))
      end
      local function normalizeHex(hex)
        hex = tostring(hex or ""):gsub("#", "")
        if #hex ~= 6 then
          return library.Theme.Accent
        end
        local value6, value7, value8 =
          tonumber(hex:sub(1, 2), 16) or 255,
          tonumber(hex:sub(3, 4), 16) or 103,
          tonumber(hex:sub(5, 6), 16) or 177
        return Color3.fromRGB(value6, value7, value8)
      end
      local function colorToHex(color)
        if typeof(color) ~= "Color3" then
          return "#FFFFFF"
        end
        return string.format(
          "#%02X%02X%02X",
          math.floor(color.R * 255 + 0.5),
          math.floor(color.G * 255 + 0.5),
          math.floor(color.B * 255 + 0.5)
        )
      end
      local function deepCopy(value)
        local list = {}
        for key, value2 in next, value or {}, nil do
          list[key] = type(value2) == "table" and deepCopy(value2) or value2
        end
        return list
      end
      local function ensureFolder(path)
        if type(isfolder) ~= "function" then
          return false
        elseif type(makefolder) ~= "function" then
          return false
        end
        local text = ""
        for key in tostring(path):gmatch("[^/]+") do
          text = text == "" and key or text .. "/" .. key
          if not (isfolder(text)) then
            pcall(makefolder, text)
          end
        end
        return isfolder(path)
      end
      local value9 =
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbTwV0KD313MCCxxz7GkvmtySHoShbjCCwjrhVz8E4NKSzvhwTJuRiRp4&s=10"
      local function getGuiInset()
        local value10, value11, value12, value13 = 0, 0, pcall(guiService.GetGuiInset, guiService)
        if value12 then
          if typeof(value13) == "Vector2" then
            local value14, value15 = value13.X, value13.Y
            value10, value11 = value14, value15
          else
          end
        else
        end
        value12 = userInputService:GetMouseLocation()
        return Vector2.new(value12.X - value10, value12.Y - value11)
      end
      local function isKeyInput(value, expected)
        if typeof(expected) ~= "EnumItem" then
          return false
        end
        if expected.EnumType == Enum.KeyCode then
          return value.UserInputType == Enum.UserInputType.Keyboard and value.KeyCode == expected
        end
        if expected.EnumType == Enum.UserInputType then
          return value.UserInputType == expected
        end
        return false
      end
      local function inputToText(input)
        if typeof(input) ~= "EnumItem" then
          return tostring(input)
        end
        if input == Enum.KeyCode.Unknown then
          return "None"
        end
        if input.EnumType == Enum.UserInputType then
          return ({
            [Enum.UserInputType.MouseButton1] = "MB1",
            [Enum.UserInputType.MouseButton2] = "MB2",
            [Enum.UserInputType.MouseButton3] = "MB3",
          })[input] or input.Name
        end
        return input.Name
      end
      local function normalizeKeycode(value)
        if typeof(value) == "EnumItem" then
          return value
        end
        local input, input2 =
          tostring(value or ""), {
            MB1 = Enum.UserInputType.MouseButton1,
            MB2 = Enum.UserInputType.MouseButton2,
            MB3 = Enum.UserInputType.MouseButton3,
            MouseButton1 = Enum.UserInputType.MouseButton1,
            MouseButton2 = Enum.UserInputType.MouseButton2,
            MouseButton3 = Enum.UserInputType.MouseButton3,
            None = Enum.KeyCode.Unknown,
          }
        if input2[input] then
          return input2[input]
        end
        if Enum.KeyCode[input] then
          return Enum.KeyCode[input]
        end
        if Enum.UserInputType[input] then
          return Enum.UserInputType[input]
        end
        return Enum.KeyCode.Unknown
      end
      local function serializeValue(value)
        if typeof(value) == "Color3" then
          return { __type = "Color3", R = value.R, G = value.G, newInstance = value.B }
        elseif typeof(value) == "EnumItem" then
          return { __type = "EnumItem", EnumType = tostring(value.EnumType), Name = value.Name }
        elseif type(value) == "table" then
          local list = {}
          for key, value in next, value, nil do
            list[key] = serializeValue(value)
          end
          return list
        end
        return value
      end
      local function deserializeValue(value)
        if type(value) ~= "table" then
          return value
        end
        if value.__type == "Color3" then
          return Color3.new(tonumber(value.R) or 1, tonumber(value.G) or 1, tonumber(value.B) or 1)
        elseif value.__type == "EnumItem" then
          local text = tostring(value.EnumType or ""):match("Enum%.(.+)")
          local value16 = text and Enum[text]
          return value16 and value16[value.Name] or nil
        end
        local list = {}
        for key, value2 in next, value, nil do
          list[key] = deserializeValue(value2)
        end
        return list
      end
      local function createFlowerDecor(parent, theme)
        local frame = newInstance("Frame", {
          Name = "FlowerDecor",
          BackgroundTransparency = 1,
          Size = UDim2.fromScale(1, 1),
          ClipsDescendants = true,
          ZIndex = 40,
          Active = false,
          Parent = parent,
        })
        local list, enabled = { Overlay = frame }, false
        local function getTheme()
          return theme and theme() or library.Theme
        end
        local function drawLineSegment(parent, from, to, thickness, color, transparency, overlap)
          local value17, value18 = to.X - from.X, to.Y - from.Y
          to = math.sqrt(value17 * value17 + value18 * value18)
          local frame = newInstance("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromOffset(from.X, from.Y),
            Size = UDim2.fromOffset(to, thickness or 2),
            Rotation = math.deg(math.atan2(value18, value17)),
            BackgroundColor3 = color,
            BackgroundTransparency = transparency or 0,
            BorderSizePixel = 0,
            ZIndex = overlap or 3,
            Parent = parent,
          })
          applyCorner(frame, 99)
          return frame
        end
        local function drawGlowLine(parent, from, to, thickness, color, transparency)
          local wResult = getTheme()
          local value19 = wResult.Accent2:Lerp(Color3.fromRGB(90, 35, 75), 0.56)
          local frame = newInstance("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(from, to),
            Size = UDim2.fromOffset(16 * thickness, 7 * thickness),
            Rotation = color + (transparency or 0),
            BackgroundColor3 = value19,
            BackgroundTransparency = 0.18,
            BorderSizePixel = 0,
            ZIndex = 3,
            Parent = parent,
          })
          applyCorner(frame, 99)
          applyGradient(
            frame,
            value19:Lerp(wResult.AccentSoft, 0.18),
            value19:Lerp(Color3.new(0, 0, 0), 0.35),
            0
          )
          drawLineSegment(
            frame,
            Vector2.new(2 * thickness, 3.5 * thickness),
            Vector2.new(14 * thickness, 3.5 * thickness),
            0.65,
            wResult.AccentSoft,
            0.35,
            4
          )
          for index = 1, 3, 1 do
            color = (3 + index * 3) * thickness
            drawLineSegment(
              frame,
              Vector2.new(color, 3.5 * thickness),
              Vector2.new(color - 2 * thickness, 1 * thickness),
              0.5,
              wResult.AccentSoft,
              0.48,
              4
            )
          end
          return frame
        end
        local function drawCornerArc(parent, from, to, thickness, color, transparency, overlap)
          local wResult = getTheme()
          local value20 = transparency or wResult.Accent
          applyCorner(
            newInstance("Frame", {
              AnchorPoint = Vector2.new(0.5, 0.5),
              Position = UDim2.fromOffset(from, to),
              Size = UDim2.fromOffset(38 * thickness, 38 * thickness),
              BackgroundColor3 = value20,
              BackgroundTransparency = 0.88,
              BorderSizePixel = 0,
              ZIndex = (overlap or 5) - 1,
              Parent = parent,
            }),
            99
          )
          for index = 0, 4, 1 do
            local value21, value22 = math.rad(color + index * 72 - 90), 8.2 * thickness
            local value23, value24, value25 =
              from + math.cos(value21) * value22,
              to + math.sin(value21) * value22,
              value20:Lerp(wResult.AccentSoft, index % 2 == 0 and 0.34 or 0.18)
            value22 = newInstance("Frame", {
              AnchorPoint = Vector2.new(0.5, 0.72),
              Position = UDim2.fromOffset(value23, value24),
              Size = UDim2.fromOffset(12 * thickness, 22 * thickness),
              Rotation = color + index * 72,
              BackgroundColor3 = value25,
              BackgroundTransparency = 0.03,
              BorderSizePixel = 0,
              ZIndex = overlap or 5,
              Parent = parent,
            })
            applyCorner(value22, 99)
            applyGradient(
              value22,
              value25:Lerp(Color3.new(1, 1, 1), 0.2),
              value20:Lerp(Color3.new(0, 0, 0), 0.2),
              90
            )
            applyCorner(
              newInstance("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.84),
                Position = UDim2.fromScale(0.5, 0.7),
                Size = UDim2.fromScale(0.34, 0.4),
                BackgroundColor3 = wResult.AccentSoft,
                BackgroundTransparency = 0.38,
                BorderSizePixel = 0,
                ZIndex = (overlap or 5) + 1,
                Parent = value22,
              }),
              99
            )
          end
          for step = 0, 4, 1 do
            transparency = math.rad(color + step * 72 - 90)
            value20 = Vector2.new(math.cos(transparency), math.sin(transparency))
            local vector, vector2 = Vector2.new(-value20.Y, value20.X), Vector2.new(from, to)
            for index = -1, 1, 1 do
              step = vector2 + value20 * (16 * thickness) + vector * (index * 2.1 * thickness)
              drawLineSegment(
                parent,
                vector2 + value20 * (4 * thickness),
                step,
                0.55 * thickness,
                wResult.AccentSoft,
                0.46,
                (overlap or 5) + 1
              )
            end
          end
          for limit = 0, 9, 1 do
            value20, transparency = math.rad(color + limit * 36), Vector2.new(from, to)
            local value26 = transparency
              + Vector2.new(math.cos(value20), math.sin(value20)) * ((6.5 + limit % 3) * thickness)
            drawLineSegment(
              parent,
              transparency,
              value26,
              0.65 * thickness,
              Color3.fromRGB(255, 218, 230),
              0.22,
              (overlap or 5) + 2
            )
            applyCorner(
              newInstance("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromOffset(value26.X, value26.Y),
                Size = UDim2.fromOffset(1.8 * thickness, 1.8 * thickness),
                BackgroundColor3 = Color3.fromRGB(255, 232, 207),
                BorderSizePixel = 0,
                ZIndex = (overlap or 5) + 3,
                Parent = parent,
              }),
              99
            )
          end
          color = newInstance("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(from, to),
            Size = UDim2.fromOffset(7.5 * thickness, 7.5 * thickness),
            BackgroundColor3 = Color3.fromRGB(255, 212, 230),
            BorderSizePixel = 0,
            ZIndex = (overlap or 5) + 2,
            Parent = parent,
          })
          applyCorner(color, 99)
          applyStroke(color, wResult.AccentSoft, 1, 0.3)
        end
        local function drawPath(parent, from, to, thickness, color, transparency)
          local wResult = getTheme()
          local frame = newInstance("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(from, to),
            Size = UDim2.fromOffset(10 * thickness, 15 * thickness),
            Rotation = color,
            BackgroundColor3 = transparency or wResult.Accent2,
            BackgroundTransparency = 0.05,
            BorderSizePixel = 0,
            ZIndex = 5,
            Parent = parent,
          })
          applyCorner(frame, 99)
          applyGradient(
            frame,
            (transparency or wResult.Accent2):Lerp(wResult.AccentSoft, 0.3),
            (transparency or wResult.Accent2):Lerp(Color3.new(0, 0, 0), 0.2),
            90
          )
        end
        local function drawPolyline(parent, points, color)
          local wResult = getTheme()
          for index = 1, #points - 1, 1 do
            drawLineSegment(
              parent,
              points[index],
              points[index + 1],
              color or 2.3,
              wResult.Accent2:Lerp(Color3.fromRGB(88, 41, 75), 0.48),
              0.14,
              3
            )
          end
        end
        list.Rebuild = function(element)
          if frame.Parent then
            if not frame.Visible then
              return
            end
          else
            return
          end
          if not frame.Parent then
            return
          end
          element = frame:GetChildren()
          for index = 1, 1 / 0, 1 do
            local item = rawget(element, index)
            if item == nil then
              break
            end
            item:Destroy()
          end
          local width, height = parent.AbsoluteSize.X, parent.AbsoluteSize.Y
          if width < 50 then
            return
          elseif height < 50 then
            return
          end
          local element2, element3, frame =
            getTheme(), newInstance("Frame", {
              BackgroundTransparency = 1,
              Position = UDim2.new(1, -112, 0, 0),
              Size = UDim2.fromOffset(112, math.min(270, height * 0.48)),
              ClipsDescendants = true,
              Active = false,
              ZIndex = 40,
              Parent = frame,
            }), newInstance("Frame", {
              BackgroundTransparency = 1,
              Position = UDim2.fromOffset(0, 0),
              Size = UDim2.fromOffset(82, 130),
              ClipsDescendants = true,
              Active = false,
              ZIndex = 40,
              Parent = frame,
            })
          drawPolyline(element3, {
            Vector2.new(99, -10),
            Vector2.new(83, 34),
            Vector2.new(97, 81),
            Vector2.new(77, 130),
            Vector2.new(95, 180),
            Vector2.new(87, 247),
          }, 2)
          drawPolyline(element3, { Vector2.new(88, 30), Vector2.new(54, 49), Vector2.new(35, 82) }, 1.2)
          drawPolyline(element3, { Vector2.new(94, 88), Vector2.new(65, 105), Vector2.new(53, 143) }, 1.2)
          drawPolyline(frame, {
            Vector2.new(3, -8),
            Vector2.new(24, 23),
            Vector2.new(11, 54),
            Vector2.new(28, 93),
            Vector2.new(14, 122),
          }, 1.6)
          element = {
            { 85, 18, 1.05, 18 },
            { 59, 40, 0.85, -12 },
            { 102, 55, 0.9, 36 },
            { 77, 81, 0.75, 8 },
            { 46, 88, 0.55, -20 },
            { 94, 117, 0.82, 25 },
            { 67, 144, 0.62, -8 },
            { 96, 170, 0.66, 38 },
            { 86, 207, 0.48, 14 },
            { 37, 12, 0.64, -24 },
            { 65, 9, 0.72, 42 },
            { 104, 31, 0.65, -8 },
            { 37, 58, 0.53, 30 },
            { 79, 53, 0.66, -32 },
            { 105, 87, 0.72, 16 },
            { 61, 111, 0.58, 48 },
            { 81, 132, 0.56, -18 },
            { 103, 145, 0.62, 27 },
            { 78, 167, 0.52, -36 },
            { 104, 193, 0.56, 9 },
            { 74, 225, 0.4, 32 },
            { 98, 239, 0.42, -16 },
          }
          for step = 1, 1 / 0, 1 do
            height = rawget(element, step)
            if height == nil then
              break
            end
            drawCornerArc(element3, height[1], height[2], height[3], height[4], element2.Accent, 5)
          end
          height = {
            { 20, 12, 0.92, 24 },
            { 45, 32, 0.63, -10 },
            { 13, 54, 0.7, 12 },
            { 30, 91, 0.48, 32 },
            { 51, 8, 0.6, -22 },
            { 7, 29, 0.65, 42 },
            { 31, 48, 0.56, -30 },
            { 52, 62, 0.48, 18 },
            { 12, 79, 0.55, -14 },
            { 42, 105, 0.45, 40 },
            { 15, 119, 0.4, -8 },
          }
          for limit = 1, 1 / 0, 1 do
            element = rawget(height, limit)
            if element == nil then
              break
            end
            drawCornerArc(frame, element[1], element[2], element[3], element[4], element2.Accent2, 5)
          end
          for limit2 = 1, 20, 1 do
            width, height = 8 + limit2 * 12, 88 + math.sin(limit2 * 1.8) * 10
            drawGlowLine(element3, height, width, 0.75 + limit2 % 3 * 0.15, limit2 * 29, 0)
            if limit2 % 2 == 0 then
              drawPath(element3, height - 14, width + 5, 0.45, limit2 * 17, element2.AccentSoft)
            end
          end
          for limit3 = 1, 9, 1 do
            drawGlowLine(frame, 12 + limit3 % 2 * 20, limit3 * 13, 0.65, limit3 * 37, 0)
          end
          height = { frame, element3 }
          for limit4 = 1, 1 / 0, 1 do
            element = rawget(height, limit4)
            if element == nil then
              break
            end
            element3 = element:GetDescendants()
            for index = 1, 1 / 0, 1 do
              frame = rawget(element3, index)
              if frame == nil then
                break
              end
              if frame:IsA("GuiObject") then
                if frame.BackgroundTransparency < 1 then
                  frame.BackgroundTransparency = 0.66 + frame.BackgroundTransparency * 0.34
                end
              end
              limit4 = frame:FindFirstChildOfClass("UIStroke")
              if limit4 then
                limit4.Transparency = 0.7 + limit4.Transparency * 0.3
              end
            end
          end
        end
        local function initDecor()
          if enabled then
            return
          end
          enabled = true
          task.defer(function()
            enabled = false
            if frame.Parent then
              list:Rebuild()
            end
          end)
        end
        list.SetVisible = function(argument7, argument8)
          argument7 = argument8 == true
          if frame.Visible == argument7 then
            return
          end
          frame.Visible = argument7
          if argument7 then
            initDecor()
          end
        end
        local propertySignal = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(initDecor)
        task.defer(function()
          if frame.Parent then
            list:Rebuild()
          end
        end)
        list.Destroy = function(argument9)
          if propertySignal then
            propertySignal:Disconnect()
          end
          if frame then
            frame:Destroy()
          end
        end
        return list
      end
      local list = {}
      list.__index = list
      list.SetVisible = function(argument10, argument11)
        if argument10.Container then
          argument10.Container.Visible = argument11
        end
      end
      list.Matches = function(argument12, argument13)
        if argument13 == "" then
          return true
        end
        return string.find(string.lower(argument12.SearchText or ""), argument13, 1, true) ~= nil
      end
      local function drawConnector(parent, x1, y1, x2, y2, argument14, argument15)
        local value27, value28 = x2 - x1, y2 - y1
        local value29 = math.sqrt(value27 * value27 + value28 * value28)
        local frame = newInstance("Frame", {
          AnchorPoint = Vector2.new(0.5, 0.5),
          Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2),
          Size = UDim2.fromOffset(value29, argument14 or 2),
          Rotation = math.deg(math.atan2(value28, value27)),
          BackgroundColor3 = argument15,
          BorderSizePixel = 0,
          Parent = parent,
        })
        applyCorner(frame, 99)
        return frame
      end
      local function createVectorIcon(parent, size, color)
        local frame = newInstance("Frame", {
          Name = "VectorIcon",
          BackgroundTransparency = 1,
          AnchorPoint = Vector2.new(0.5, 0.5),
          Position = UDim2.fromScale(0.5, 0.5),
          Size = UDim2.fromOffset(24, 24),
          Parent = parent,
        })
        local scale = newInstance("UIScale", { Scale = 1, Parent = frame })
        local function updateIconScale()
          scale.Scale = math.min(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) / 24
        end
        parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateIconScale)
        updateIconScale()
        local list, list2 = {}, {}
        local element = color.TextDim
        local function addPolylinePoint(points, color, thickness, transparency, overlap)
          local rResult =
            drawConnector(frame, points, color, thickness, transparency, overlap or 1.6, element)
          list[#list + 1] = rResult
          return rResult
        end
        local function buildPolyline(points, closed, color)
          for index = 2, #points, 1 do
            addPolylinePoint(
              points[index - 1][1],
              points[index - 1][2],
              points[index][1],
              points[index][2],
              color
            )
          end
          if closed then
            addPolylinePoint(points[#points][1], points[#points][2], points[1][1], points[1][2], color)
          end
        end
        local function createArrowHead(x, y, angle, size, color)
          local frame = newInstance("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(x, y),
            Size = UDim2.fromOffset(angle, size),
            BackgroundColor3 = element,
            BackgroundTransparency = color and 0 or 1,
            BorderSizePixel = 0,
            Parent = frame,
          })
          applyCorner(frame, 99)
          if color then
            list[#list + 1] = frame
          else
            list2[#list2 + 1] = applyStroke(frame, element, 1.6, 0)
          end
          return frame
        end
        local function createNodeMarker(x, y, radius, color, parent)
          local frame = newInstance("Frame", {
            Position = UDim2.fromOffset(x, y),
            Size = UDim2.fromOffset(radius, color),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Parent = frame,
          })
          applyCorner(frame, parent or 2)
          list2[#list2 + 1] = applyStroke(frame, element, 1.6, 0)
          return frame
        end
        color = string.lower(tostring(size or ""))
        if color == "combat" or color == "swords" then
          buildPolyline({ { 4, 3 }, { 16, 15 }, { 18, 14 }, { 5, 2 } }, true)
          buildPolyline({ { 20, 3 }, { 8, 15 }, { 6, 14 }, { 19, 2 } }, true)
          addPolylinePoint(13, 16, 18, 11)
          addPolylinePoint(6, 11, 11, 16)
          addPolylinePoint(16, 15, 20, 19, 2)
          addPolylinePoint(8, 15, 4, 19, 2)
          addPolylinePoint(18, 21, 22, 17, 2)
          addPolylinePoint(2, 17, 6, 21, 2)
        elseif color == "silent" or color == "silent aim" then
          buildPolyline(
            { { 2, 12 }, { 6, 7 }, { 12, 5 }, { 18, 7 }, { 22, 12 }, { 18, 17 }, { 12, 19 }, { 6, 17 } },
            true
          )
          createArrowHead(12, 12, 6, 6, false)
          addPolylinePoint(3, 21, 21, 3, 2)
        elseif color == "rage" or color == "ragebot" then
          buildPolyline({ { 13, 2 }, { 4, 13 }, { 11, 13 }, { 9, 22 }, { 20, 10 }, { 13, 10 } }, true, 1.8)
        elseif color == "trigger" or color == "triggerbot" then
          buildPolyline({
            { 8, 11 },
            { 8, 5 },
            { 10, 3 },
            { 12, 5 },
            { 12, 10 },
            { 16, 9 },
            { 20, 12 },
            { 19, 20 },
            { 9, 21 },
            { 4, 15 },
            { 5, 13 },
            { 8, 15 },
          }, false)
          addPolylinePoint(15, 3, 16, 5)
          addPolylinePoint(19, 6, 21, 6)
        elseif color == "gun mods" or color == "sliders" then
          addPolylinePoint(4, 2, 4, 22)
          addPolylinePoint(12, 2, 12, 22)
          addPolylinePoint(20, 2, 20, 22)
          createNodeMarker(1.5, 6, 5, 4, 1)
          createNodeMarker(9.5, 14, 5, 4, 1)
          createNodeMarker(17.5, 4, 5, 4, 1)
        elseif color:find("aim") or color:find("target") or color:find("crosshair") or color == "plus" then
          createArrowHead(12, 12, 15, 15, false)
          createArrowHead(12, 12, 3, 3, true)
          addPolylinePoint(12, 1, 12, 7)
          addPolylinePoint(12, 17, 12, 23)
          addPolylinePoint(1, 12, 7, 12)
          addPolylinePoint(17, 12, 23, 12)
        elseif color:find("esp") or color:find("eye") then
          buildPolyline(
            { { 2, 12 }, { 6, 7 }, { 12, 5 }, { 18, 7 }, { 22, 12 }, { 18, 17 }, { 12, 19 }, { 6, 17 } },
            true
          )
          createArrowHead(12, 12, 7, 7, false)
          createArrowHead(12, 12, 2, 2, true)
        elseif color == "visuals" or color == "sparkles" then
          buildPolyline(
            { { 14, 2 }, { 16, 8 }, { 22, 10 }, { 16, 12 }, { 14, 18 }, { 12, 12 }, { 6, 10 }, { 12, 8 } },
            true
          )
          addPolylinePoint(5, 15, 5, 23)
          addPolylinePoint(1, 19, 9, 19)
          addPolylinePoint(4, 2, 4, 6)
          addPolylinePoint(2, 4, 6, 4)
        elseif color:find("camera") then
          createNodeMarker(2, 7, 20, 14, 3)
          createArrowHead(12, 14, 7, 7, false)
          buildPolyline({ { 7, 7 }, { 9, 3 }, { 15, 3 }, { 17, 7 } }, false)
          addPolylinePoint(18, 10, 19, 10, 2)
        elseif color:find("globe") or color:find("world") then
          createArrowHead(12, 12, 20, 20, false)
          createArrowHead(12, 12, 9, 20, false)
          addPolylinePoint(2, 12, 22, 12)
          addPolylinePoint(4, 7, 20, 7, 1.3)
          addPolylinePoint(4, 17, 20, 17, 1.3)
        elseif color:find("player") or color:find("user") or color == "character" then
          createArrowHead(12, 7, 8, 8, false)
          buildPolyline(
            { { 3, 22 }, { 3, 20 }, { 5, 16 }, { 9, 14 }, { 15, 14 }, { 19, 16 }, { 21, 20 }, { 21, 22 } },
            false
          )
          addPolylinePoint(3, 22, 21, 22)
        elseif color:find("setting") or color:find("gear") then
          createArrowHead(12, 12, 13, 13, false)
          createArrowHead(12, 12, 5, 5, false)
          for index = 0, 7, 1 do
            updateIconScale = math.rad(index * 45)
            addPolylinePoint(
              12 + math.cos(updateIconScale) * 7,
              12 + math.sin(updateIconScale) * 7,
              12 + math.cos(updateIconScale) * 10,
              12 + math.sin(updateIconScale) * 10,
              2.5
            )
          end
        elseif color:find("misc") or color == "grid" then
          createNodeMarker(2, 2, 8, 8, 2)
          createNodeMarker(14, 2, 8, 8, 2)
          createNodeMarker(2, 14, 8, 8, 2)
          createNodeMarker(14, 14, 8, 8, 2)
        elseif color:find("package") then
          buildPolyline({ { 2, 7 }, { 12, 2 }, { 22, 7 }, { 22, 17 }, { 12, 22 }, { 2, 17 } }, true)
          buildPolyline({ { 2, 7 }, { 12, 12 }, { 22, 7 } }, false)
          addPolylinePoint(12, 12, 12, 22)
          addPolylinePoint(7, 4.5, 17, 9.5)
        elseif color:find("bug") or color:find("debug") then
          createArrowHead(12, 13, 10, 14, false)
          addPolylinePoint(12, 6, 12, 20)
          size = { 9, 13, 17 }
          for index = 1, 1 / 0, 1 do
            local item = rawget(size, index)
            if item == nil then
              break
            end
            addPolylinePoint(3, item, 7, item)
            addPolylinePoint(17, item, 21, item)
          end
          addPolylinePoint(9, 6, 7, 2)
          addPolylinePoint(15, 6, 17, 2)
        elseif color:find("move") or color:find("speed") then
          addPolylinePoint(12, 2, 12, 22)
          addPolylinePoint(2, 12, 22, 12)
          buildPolyline({ { 8, 6 }, { 12, 2 }, { 16, 6 } }, false)
          buildPolyline({ { 8, 18 }, { 12, 22 }, { 16, 18 } }, false)
          buildPolyline({ { 6, 8 }, { 2, 12 }, { 6, 16 } }, false)
          buildPolyline({ { 18, 8 }, { 22, 12 }, { 18, 16 } }, false)
        else
          createNodeMarker(2, 2, 8, 8, 2)
          createNodeMarker(14, 2, 8, 8, 2)
          createNodeMarker(2, 14, 8, 8, 2)
          createNodeMarker(14, 14, 8, 8, 2)
        end
        return {
          SetColor = function(frame, argument16)
            for index = 1, 1 / 0, 1 do
              frame = rawget(list, index)
              if frame == nil then
                break
              end
              if frame.Parent then
                frame.BackgroundColor3 = argument16
              end
            end
            for step = 1, 1 / 0, 1 do
              local item = rawget(list2, step)
              if item == nil then
                break
              end
              if item.Parent then
                item.Color = argument16
              end
            end
          end,
        }
      end
      local list2 = {}
      list2.__index = list2
      library.CreateWindow = function(library, config)
        config = config or {}
        local object = setmetatable({}, list2)
        object.Theme = deepCopy(library.Theme)
        object.Tabs = {}
        object.Elements = {}
        object.Options = library.Options
        object.Toggles = library.Toggles
        object.Keybinds = {}
        table.clear(object.Options)
        table.clear(object.Toggles)
        library.ActiveWindow = object
        object.ActiveTab = nil
        object.SearchQuery = ""
        object._connections = {}
        object.MenuKeybind = config.ToggleKeybind or Enum.KeyCode.RightShift
        object.NotificationsEnabled = config.Notifications ~= false
        object.MinSize = config.MinSize or Vector2.new(620, 380)
        object.MaxSize = config.MaxSize
        object.ThemeName = "Sakura"
        object.BlurSize = tonumber(config.BlurSize) or 20
        object.BlurTweenTime = tonumber(config.BlurTweenTime) or 0.18
        object.BlurEnabled = config.BlurEnabled ~= false
        object.UnlockMouseWhileOpen = config.UnlockMouseWhileOpen ~= false
        object.ShowCustomCursor = config.ShowCustomCursor ~= false
        object.CustomCursorUrl = config.CustomCursorUrl or value9
        object.DecorationsEnabled = config.Decorations ~= false
        object.GlowStrength = config.GlowStrength or library.GlowStrength
        library:SetGlowStrength(object.GlowStrength)
        local screenGui = newInstance("ScreenGui", {
          Name = config.GuiName or "LunarUI",
          ResetOnSpawn = false,
          ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
          IgnoreGuiInset = false,
        })
        parentToCoreGui(screenGui)
        object.Gui = screenGui
        local screenGui2 = newInstance("ScreenGui", {
          Name = (config.GuiName or "LunarUI") .. "_Notifications",
          ResetOnSpawn = false,
          ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
          IgnoreGuiInset = false,
          DisplayOrder = screenGui.DisplayOrder + 1,
          Enabled = true,
        })
        parentToCoreGui(screenGui2)
        object.NotificationGui = screenGui2
        object.MobileToggleEnabled = config.MobileToggle ~= false
        local screenGui3 = newInstance("ScreenGui", {
          Name = (config.GuiName or "LunarUI") .. "_MobileToggle",
          ResetOnSpawn = false,
          ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
          IgnoreGuiInset = false,
          Enabled = object.MobileToggleEnabled
            and (userInputService.TouchEnabled or config.ShowMobileToggleOnDesktop == true),
        })
        parentToCoreGui(screenGui3)
        object.MobileToggleGui = screenGui3
        local button = newInstance("TextButton", {
          Name = "MobileUIToggle",
          AnchorPoint = Vector2.new(1, 0),
          Position = UDim2.new(1, -12, 0, 12),
          Size = UDim2.fromOffset(100, 38),
          BackgroundColor3 = object.Theme.Card2,
          BackgroundTransparency = 0.08,
          BorderSizePixel = 0,
          Text = "LOCK UI",
          TextColor3 = object.Theme.Text,
          TextSize = 12,
          Font = Enum.Font.GothamSemibold,
          AutoButtonColor = false,
          ZIndex = 1000,
          Parent = screenGui3,
        })
        applyCorner(button, 11)
        applyStroke(button, object.Theme.AccentSoft, 1, 0.3)
        attachGlow(button, object.Theme.Accent, 4, 0.84)
        object.MobileToggleButton = button
        local function refreshBlurButton(unused)
          if button then
            if not button.Parent then
              return
            end
          else
            return
          end
          button.Text = unused and "LOCK UI" or "OPEN UI"
          applyScaleAdapter(button, 0.12, {
            BackgroundColor3 = unused and object.Theme.Card2 or object.Theme.Accent2,
            TextColor3 = unused and object.Theme.Text or object.Theme.White,
          })
        end
        object._updateMobileToggleButton = refreshBlurButton
        refreshBlurButton(screenGui.Enabled)
        local function onMenuHoverEnter()
          applyScaleAdapter(button, 0.1, { BackgroundTransparency = 0 })
        end
        button.MouseEnter:Connect(onMenuHoverEnter)
        local function onMenuHoverLeave()
          applyScaleAdapter(button, 0.1, { BackgroundTransparency = 0.08 })
        end
        button.MouseLeave:Connect(onMenuHoverLeave)
        local function onMenuClick()
          object:SetVisible(not screenGui.Enabled)
        end
        button.Activated:Connect(onMenuClick)
        refreshBlurButton = (config.GuiName or "LunarUI") .. "_MenuBlur"
        local findFirstChildResult = lighting:FindFirstChild(refreshBlurButton)
        if findFirstChildResult then
          if findFirstChildResult:IsA("BlurEffect") then
          else
            findFirstChildResult:Destroy()
            local value30
            findFirstChildResult = value30
          end
        else
        end
        local enabled, enabled2 = false
        if findFirstChildResult then
          enabled2 = findFirstChildResult
        else
          findFirstChildResult = Instance.new("BlurEffect")
          findFirstChildResult.Name = refreshBlurButton
          findFirstChildResult.Size = 0
          findFirstChildResult.Parent = lighting
          enabled2, enabled = findFirstChildResult, true
        end
        object.BlurEffect = enabled2
        object._ownsBlur = enabled
        local value31
        local function updateMenuBlur(blur, enabled)
          if enabled2 then
            if not enabled2.Parent then
              return
            end
          else
            return
          end
          if value31 then
            pcall(function()
              value31:Cancel()
            end)
            value31 = nil
          end
          local value32 = blur and object.BlurEnabled and math.max(0, object.BlurSize) or 0
          if enabled then
            enabled2.Size = value32
            return
          elseif object.BlurTweenTime <= 0 then
            enabled2.Size = value32
            return
          end
          value31 = tweenService:Create(
            enabled2,
            TweenInfo.new(object.BlurTweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Size = value32 }
          )
          value31:Play()
        end
        object._setMenuBlur = updateMenuBlur
        local frame = newInstance("Frame", {
          Name = "Window",
          AnchorPoint = Vector2.new(0.5, 0.5),
          Position = config.Center == true and UDim2.fromScale(0.5, 0.5)
            or config.Position
            or UDim2.fromScale(0.5, 0.5),
          Size = config.Size or UDim2.fromOffset(1008, 616),
          BackgroundColor3 = object.Theme.Window,
          BackgroundTransparency = 0.03,
          BorderSizePixel = 0,
          ClipsDescendants = true,
          Active = true,
          Parent = screenGui,
        })
        pcall(function()
          frame.InputSink = Enum.InputSink.All
        end)
        object.Root = frame
        object.Holder = frame
        updateMenuBlur(true, false)
        applyCorner(frame, 6)
        refreshBlurButton, library, onMenuClick =
          applyStroke(frame, object.Theme.Stroke, 1, 0.35),
          attachGlow(frame, object.Theme.Accent, 5, 0.66),
          attachGlow(frame, object.Theme.AccentSoft, 2, 0.82)
        object.RootStroke = refreshBlurButton
        object.RootGlow = library
        object.RootInnerGlow = onMenuClick
        local frame2 = newInstance("Frame", {
          Name = "Sidebar",
          Size = UDim2.new(0, 216, 1, 0),
          BackgroundColor3 = object.Theme.Sidebar,
          BackgroundTransparency = 0.05,
          BorderSizePixel = 0,
          ZIndex = 10,
          Parent = frame,
        })
        object.Sidebar = frame2
        frame2.ClipsDescendants = true
        applyCorner(frame2, 4)
        newInstance("Frame", {
          Position = UDim2.new(1, -1, 0, 0),
          Size = UDim2.new(0, 1, 1, 0),
          BackgroundColor3 = object.Theme.StrokeSoft,
          BackgroundTransparency = 0.45,
          BorderSizePixel = 0,
          Parent = frame2,
        })
        library = newInstance("TextLabel", {
          Name = "Brand",
          BackgroundTransparency = 1,
          Position = UDim2.fromOffset(46, 12),
          Size = UDim2.new(1, -58, 0, 34),
          Text = config.Title or "Lunar",
          TextColor3 = object.Theme.Text,
          TextSize = tonumber(config.TitleSize) or 18,
          Font = Enum.Font.GothamMedium,
          TextXAlignment = Enum.TextXAlignment.Left,
          Parent = frame2,
        })
        newInstance("TextLabel", {
          BackgroundTransparency = 1,
          Position = UDim2.fromOffset(13, 11),
          Size = UDim2.fromOffset(22, 22),
          Text = "\226\151\134",
          TextColor3 = object.Theme.AccentSoft,
          TextSize = 16,
          Font = Enum.Font.GothamBold,
          Parent = frame2,
        })
        local scrollFrame = newInstance("ScrollingFrame", {
          Name = "Nav",
          Position = UDim2.fromOffset(0, 50),
          Size = UDim2.new(1, 0, 1, -170),
          BackgroundTransparency = 1,
          BorderSizePixel = 0,
          ScrollBarThickness = 0,
          CanvasSize = UDim2.fromOffset(0, 0),
          AutomaticCanvasSize = Enum.AutomaticSize.Y,
          ClipsDescendants = true,
          Parent = frame2,
        })
        object.Nav = scrollFrame
        local value33 = newInstance(
          "UIListLayout",
          { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = scrollFrame }
        )
        applyPadding(scrollFrame, 3, 3, 3, 3)
        onMenuClick = newInstance("Frame", {
          Name = "PlayerProfile",
          AnchorPoint = Vector2.new(0, 1),
          Position = UDim2.new(0, 8, 1, -8),
          Size = UDim2.new(1, -16, 0, 58),
          BackgroundColor3 = object.Theme.Card,
          BackgroundTransparency = 0.15,
          BorderSizePixel = 0,
          ZIndex = 20,
          Parent = frame2,
        })
        applyCorner(onMenuClick, 12)
        applyStroke(onMenuClick, object.Theme.StrokeSoft, 1, 0.45)
        local imageLabel = newInstance("ImageLabel", {
          Name = "PlayerAvatar",
          Position = UDim2.fromOffset(8, 9),
          Size = UDim2.fromOffset(40, 40),
          BackgroundColor3 = object.Theme.Card2,
          BackgroundTransparency = 0.1,
          BorderSizePixel = 0,
          Image = "",
          ScaleType = Enum.ScaleType.Crop,
          ZIndex = 21,
          Parent = onMenuClick,
        })
        applyCorner(imageLabel, 20)
        local label = newInstance("TextLabel", {
          Name = "AvatarFallback",
          Size = UDim2.fromScale(1, 1),
          BackgroundTransparency = 1,
          Text = localPlayer and localPlayer.Name:sub(1, 1):upper() or "?",
          TextColor3 = object.Theme.AccentSoft,
          TextSize = 20,
          Font = Enum.Font.GothamBold,
          ZIndex = 22,
          Parent = imageLabel,
        })
        newInstance("TextLabel", {
          Name = "PlayerName",
          Position = UDim2.fromOffset(57, 10),
          Size = UDim2.new(1, -65, 0, 20),
          BackgroundTransparency = 1,
          Text = localPlayer and localPlayer.Name or "Player",
          TextColor3 = object.Theme.Text,
          TextSize = 13,
          Font = Enum.Font.GothamSemibold,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextTruncate = Enum.TextTruncate.AtEnd,
          ZIndex = 21,
          Parent = onMenuClick,
        })
        newInstance("TextLabel", {
          Name = "PlayerRole",
          Position = UDim2.fromOffset(57, 31),
          Size = UDim2.new(1, -65, 0, 17),
          BackgroundTransparency = 1,
          Text = "Rivals Buyer",
          TextColor3 = object.Theme.TextDim,
          TextSize = 11,
          Font = Enum.Font.Gotham,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextTruncate = Enum.TextTruncate.AtEnd,
          ZIndex = 21,
          Parent = onMenuClick,
        })
        object.ProfileCard = onMenuClick
        object.ProfileAvatar = imageLabel
        task.spawn(function()
          if not localPlayer then
            return
          end
          for index = 1, 3, 1 do
            local ok, ok2, ok3 = pcall(function()
              local value34, enumValue, enumValue2 =
                localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100
              return players:GetUserThumbnailAsync(value34, enumValue, enumValue2)
            end)
            if imageLabel.Parent then
              if not screenGui.Parent then
                return
              end
            else
              return
            end
            if ok then
              if ok3 then
                if type(ok2) == "string" then
                  if ok2 ~= "" then
                    imageLabel.Image = ok2
                    label.Visible = false
                    return
                  end
                end
              end
            end
            if index < 3 then
              task.wait(1)
            end
          end
        end)
        local frame3 = newInstance("Frame", {
          AnchorPoint = Vector2.new(0, 1),
          Position = UDim2.new(0, 10, 1, -112),
          Size = UDim2.new(1, -20, 0, 1),
          BackgroundColor3 = object.Theme.StrokeSoft,
          BackgroundTransparency = 0.45,
          BorderSizePixel = 0,
          Parent = frame2,
        })
        local button2 = newInstance("TextButton", {
          Name = "Settings",
          AnchorPoint = Vector2.new(0, 1),
          Position = UDim2.new(0, 8, 1, -73),
          Size = UDim2.new(1, -16, 0, 36),
          BackgroundColor3 = Color3.fromRGB(42, 20, 44),
          BackgroundTransparency = 0.7,
          Text = "",
          AutoButtonColor = false,
          ZIndex = 20,
          Parent = frame2,
        })
        applyCorner(button2, 12)
        local scale = newInstance("UIScale", { Scale = 1, Parent = button2 })
        onMenuHoverLeave = newInstance("Frame", {
          AnchorPoint = Vector2.new(0, 0.5),
          Position = UDim2.new(0, 0, 0.5, 0),
          Size = UDim2.fromOffset(3, 0),
          BackgroundColor3 = object.Theme.AccentSoft,
          BackgroundTransparency = 1,
          BorderSizePixel = 0,
          Parent = button2,
        })
        applyCorner(onMenuHoverLeave, 99)
        onMenuClick = newInstance("Frame", {
          Name = "IconSlot",
          BackgroundTransparency = 1,
          Position = UDim2.fromOffset(8, 9),
          Size = UDim2.fromOffset(30, 26),
          ClipsDescendants = true,
          Parent = button2,
        })
        object.SettingsIcon = createVectorIcon(
          newInstance("Frame", {
            Name = "IconCanvas",
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(3, 1),
            Size = UDim2.fromOffset(24, 24),
            ClipsDescendants = true,
            Parent = onMenuClick,
          }),
          "settings",
          object.Theme
        )
        local label2 = newInstance("TextLabel", {
          BackgroundTransparency = 1,
          Position = UDim2.fromOffset(52, 0),
          Size = UDim2.new(1, -64, 1, 0),
          Text = "Settings",
          TextColor3 = object.Theme.Text,
          TextSize = 14,
          Font = Enum.Font.GothamMedium,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextYAlignment = Enum.TextYAlignment.Center,
          Parent = button2,
        })
        local function resizeSettingsPanel()
          local bound = math.max(40, frame2.AbsoluteSize.Y - 122)
          local bound2 = math.min(bound, value33.AbsoluteContentSize.Y + 8)
          scrollFrame.Size = UDim2.new(1, 0, 0, bound2)
          frame3.AnchorPoint = Vector2.new(0, 0)
          frame3.Position = UDim2.fromOffset(12, 50 + bound2 + 8)
          button2.AnchorPoint = Vector2.new(0, 0)
          button2.Position = UDim2.fromOffset(4, 50 + bound2 + 17)
          button2.Size = UDim2.new(1, -8, 0, 40)
        end
        value33:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resizeSettingsPanel)
        frame2:GetPropertyChangedSignal("AbsoluteSize"):Connect(resizeSettingsPanel)
        task.defer(resizeSettingsPanel)
        object.SettingsButton = button2
        object.SettingsLabel = label2
        object.SettingsScale = scale
        object.SettingsAccent = onMenuHoverLeave
        object.SettingsStroke = applyStroke(button2, object.Theme.Accent, 1, 1)
        object.SettingsGlow = attachGlow(button2, object.Theme.Accent, 4, 0.95)
        local function highlightSettingsButton()
          button2.ZIndex = 35
          if not object._settingsSelected then
            applyScaleAdapter(button2, 0.12, { BackgroundTransparency = 0.52 })
            applyScaleAdapter(label2, 0.12, { TextColor3 = object.Theme.AccentSoft })
            applyScaleAdapter(scale, 0.12, { Scale = 1.012 })
          end
        end
        button2.MouseEnter:Connect(highlightSettingsButton)
        local function unhighlightSettingsButton()
          if object._settingsSelected then
            button2.ZIndex = 35
          else
            applyScaleAdapter(button2, 0.12, { BackgroundTransparency = 0.7 })
            applyScaleAdapter(label2, 0.12, { TextColor3 = object.Theme.Text })
            applyScaleAdapter(scale, 0.12, { Scale = 1 })
            button2.ZIndex = 20
          end
        end
        button2.MouseLeave:Connect(unhighlightSettingsButton)
        local frame4 = newInstance("Frame", {
          Name = "Topbar",
          Position = UDim2.fromOffset(216, 0),
          Size = UDim2.new(1, -216, 0, 48),
          BackgroundColor3 = object.Theme.Topbar,
          BackgroundTransparency = 0.1,
          BorderSizePixel = 0,
          ZIndex = 10,
          Parent = frame,
        })
        object.Topbar = frame4
        frame4.ClipsDescendants = true
        applyCorner(frame4, 0)
        newInstance("Frame", {
          AnchorPoint = Vector2.new(0, 1),
          Position = UDim2.new(0, 0, 1, 0),
          Size = UDim2.new(1, 0, 0, 1),
          BackgroundColor3 = object.Theme.StrokeSoft,
          BackgroundTransparency = 0.45,
          BorderSizePixel = 0,
          Parent = frame4,
        })
        local label3 = newInstance("TextLabel", {
          Name = "CurrentTab",
          BackgroundTransparency = 1,
          Position = UDim2.fromOffset(18, 0),
          Size = UDim2.fromOffset(82, 48),
          Text = "",
          TextColor3 = object.Theme.Text,
          TextSize = 14,
          Font = Enum.Font.GothamMedium,
          TextXAlignment = Enum.TextXAlignment.Left,
          Parent = frame4,
        })
        object.CurrentLabel = label3
        local frame5 = newInstance("Frame", {
          Position = UDim2.fromOffset(90, 8),
          Size = UDim2.new(1, -102, 0, 32),
          BackgroundColor3 = Color3.fromRGB(26, 12, 31),
          BackgroundTransparency = 0.1,
          BorderSizePixel = 0,
          Parent = frame4,
        })
        local function updateSidebarWidth()
          local width = frame4.AbsoluteSize.X
          if width <= 0 then
            return
          end
          local clamped = math.clamp(
            measureText(label3.Text, 14, Enum.Font.GothamMedium).X + 34,
            76,
            math.max(76, width * 0.38)
          )
          label3.Size = UDim2.new(0, clamped - 26, 1, 0)
          label3.TextTruncate = Enum.TextTruncate.AtEnd
          frame5.Position = UDim2.fromOffset(clamped, 8)
          frame5.Size = UDim2.new(1, -clamped - 12, 0, 32)
        end
        label3:GetPropertyChangedSignal("Text"):Connect(updateSidebarWidth)
        frame4:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSidebarWidth)
        task.defer(updateSidebarWidth)
        applyCorner(frame5, 10)
        applyStroke(frame5, object.Theme.StrokeSoft, 1, 0.4)
        newInstance("TextLabel", {
          BackgroundTransparency = 1,
          Position = UDim2.fromOffset(10, 0),
          Size = UDim2.fromOffset(20, 30),
          Text = "\226\140\149",
          TextColor3 = object.Theme.TextDim,
          TextSize = 17,
          Font = Enum.Font.Gotham,
          Parent = frame5,
        })
        local textBox = newInstance("TextBox", {
          BackgroundTransparency = 1,
          Position = UDim2.fromOffset(31, 0),
          Size = UDim2.new(1, -80, 1, 0),
          PlaceholderText = "Search settings...",
          PlaceholderColor3 = object.Theme.TextMute,
          Text = "",
          TextColor3 = object.Theme.Text,
          TextSize = 12,
          Font = Enum.Font.Gotham,
          ClearTextOnFocus = false,
          TextXAlignment = Enum.TextXAlignment.Left,
          Parent = frame5,
        })
        object.SearchBox = textBox
        applyCorner(textBox, 8)
        onMenuHoverEnter = newInstance("TextLabel", {
          AnchorPoint = Vector2.new(1, 0),
          Position = UDim2.new(1, -5, 0, 3),
          Size = UDim2.fromOffset(42, 26),
          BackgroundColor3 = Color3.fromRGB(56, 28, 58),
          BackgroundTransparency = 0.1,
          Text = "\226\140\152K",
          TextColor3 = object.Theme.TextDim,
          TextSize = 11,
          Font = Enum.Font.GothamMedium,
          Parent = frame5,
        })
        applyCorner(onMenuHoverEnter, 9)
        applyStroke(onMenuHoverEnter, object.Theme.StrokeSoft, 1, 0.45)
        local frame6 = newInstance("Frame", {
          Name = "Content",
          Position = UDim2.fromOffset(216, 48),
          Size = UDim2.new(1, -216, 1, -68),
          BackgroundTransparency = 1,
          ClipsDescendants = true,
          ZIndex = 10,
          Parent = frame,
        })
        local function applyResponsiveLayout()
          local element = frame.AbsoluteSize.X < 760 and 160 or 216
          frame2.Size = UDim2.new(0, element, 1, 0)
          frame4.Position = UDim2.fromOffset(element, 0)
          frame4.Size = UDim2.new(1, -element, 0, 48)
          frame6.Position = UDim2.fromOffset(element, 48)
          frame6.Size = UDim2.new(1, -element, 1, -68)
        end
        frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(applyResponsiveLayout)
        task.defer(applyResponsiveLayout)
        object.Content = frame6
        applyCorner(frame6, 14)
        object.PopupLayer = newInstance("Frame", {
          Name = "PopupLayer",
          Size = UDim2.fromScale(1, 1),
          BackgroundTransparency = 1,
          BorderSizePixel = 0,
          Active = false,
          ZIndex = 500,
          Parent = screenGui,
        })
        object._OpenDropdown = nil
        object._OpenColorPicker = nil
        table.insert(
          object._connections,
          userInputService.InputBegan:Connect(function(input)
            local input2, input3 = object._OpenDropdown, object._OpenColorPicker
            if input.KeyCode == Enum.KeyCode.Escape then
              if input2 then
                input2:Close()
              end
              if input3 then
                input3:Close()
              end
              return
            end
            if
              input.UserInputType == Enum.UserInputType.MouseButton1
              or input.UserInputType == Enum.UserInputType.Touch
            then
              local vector = Vector2.new(input.Position.X, input.Position.Y)
              if input2 then
                if not (input2:ContainsPoint(vector)) then
                  input2:Close()
                end
              end
              if input3 then
                if not (input3:ContainsPoint(vector)) then
                  input3:Close()
                end
              end
            end
          end)
        )
        local screenGui4 = newInstance("ScreenGui", {
          Name = (config.GuiName or "LunarUI") .. "_Cursor",
          ResetOnSpawn = false,
          ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
          IgnoreGuiInset = false,
          DisplayOrder = math.max(10001, screenGui.DisplayOrder + 100),
          Enabled = true,
        })
        parentToCoreGui(screenGui4)
        object.CursorGui = screenGui4
        local frame7 = newInstance("Frame", {
          Name = "CursorLayer",
          Size = UDim2.fromScale(1, 1),
          BackgroundTransparency = 1,
          BorderSizePixel = 0,
          Visible = false,
          ZIndex = 980,
          Active = false,
          Parent = screenGui4,
        })
        local imageLabel2 = newInstance("ImageLabel", {
          Name = "MenuCursor",
          BackgroundTransparency = 1,
          AnchorPoint = Vector2.zero,
          Position = UDim2.fromOffset(0, 0),
          Size = UDim2.fromOffset(1, 1),
          Image = "",
          Visible = false,
          ZIndex = 981,
          Parent = frame7,
        })
        local frame8 = newInstance("Frame", {
          Name = "PixelFlowerCursor",
          BackgroundTransparency = 1,
          AnchorPoint = Vector2.zero,
          Position = UDim2.fromOffset(0, 0),
          Size = UDim2.fromOffset(16, 16),
          Visible = true,
          ZIndex = 981,
          Parent = frame7,
        })
        local function createKeybindChip(parent, x, y, width, height, zIndex)
          return newInstance("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = height,
            Position = UDim2.fromOffset(parent, x),
            Size = UDim2.fromOffset(y, width),
            ZIndex = zIndex or 981,
            Parent = frame8,
          })
        end
        createKeybindChip(5, 1, 3, 3, Color3.fromRGB(255, 170, 214), 982)
        createKeybindChip(1, 5, 3, 3, Color3.fromRGB(255, 145, 204), 982)
        createKeybindChip(9, 5, 3, 3, Color3.fromRGB(255, 145, 204), 982)
        createKeybindChip(5, 9, 3, 3, Color3.fromRGB(255, 170, 214), 982)
        createKeybindChip(5, 5, 3, 3, Color3.fromRGB(255, 235, 150), 983)
        createKeybindChip(6, 12, 2, 2, Color3.fromRGB(118, 228, 160), 982)
        createKeybindChip(7, 14, 1, 2, Color3.fromRGB(96, 205, 141), 982)
        object.CursorLayer = frame7
        object.CursorImage = imageLabel2
        object.CursorFallback = frame8
        local function positionKeybindChip()
          local jResult = getGuiInset()
          imageLabel2.Position = UDim2.fromOffset(jResult.X, jResult.Y)
          frame8.Position = UDim2.fromOffset(jResult.X - 1, jResult.Y - 1)
        end
        local function releaseMouseLock(unlock)
          if unlock then
            if object.UnlockMouseWhileOpen then
              pcall(function()
                userInputService.MouseBehavior = Enum.MouseBehavior.Default
              end)
            end
            if object.ShowCustomCursor and not userInputService.TouchEnabled then
              frame7.Visible = true
              pcall(function()
                userInputService.MouseIconEnabled = false
              end)
              positionKeybindChip()
            else
              frame7.Visible = false
              pcall(function()
                userInputService.MouseIconEnabled = true
              end)
            end
          else
            frame7.Visible = false
            pcall(function()
              userInputService.MouseIconEnabled = true
            end)
          end
        end
        object._applyMenuInputState = releaseMouseLock
        releaseMouseLock(true)
        local list = {}
        list[frame] = true
        local list2 = {}
        local generateGUIDResult = httpService:GenerateGUID(false) .. "_MenuPointer"
        local function isSurfaceEnabled(surface, enabled)
          if not surface.Parent then
            return false
          end
          local position = surface
          while position do
            if position:IsA("GuiObject") then
              if not position.Visible then
                return false
              end
            end
            if position:IsA("ScreenGui") then
              if not position.Enabled then
                return false
              end
              break
            end
            position = position.Parent
          end
          if not position then
            return false
          end
          local position2, position3 = surface.AbsolutePosition, surface.AbsoluteSize
          return enabled.X >= position2.X
            and enabled.Y >= position2.Y
            and enabled.X < position2.X + position3.X
            and enabled.Y < position2.Y + position3.Y
        end
        object.RegisterInputSurface = function(argument17, argument18)
          list[argument18] = true
          argument18.Active = true
          pcall(function()
            argument18.InputSink = Enum.InputSink.All
          end)
          return function()
            list[argument18] = nil
          end
        end
        object.IsPointerOverMenu = function(surface, position)
          if not screenGui.Enabled then
            return false
          end
          position = position or (getGuiInset())
          for key in next, list, nil do
            if isSurfaceEnabled(key, position) then
              return true
            end
          end
          local value35, value36 = surface._OpenDropdown, surface._OpenColorPicker
          return value35 ~= nil and value35:ContainsPoint(position)
            or value36 ~= nil and value36:ContainsPoint(position)
            or false
        end
        local function normalizePointer(input, state, inputObject)
          input = inputObject.UserInputType
          local value37, value38 = input == Enum.UserInputType.Touch and inputObject or input
          if input == Enum.UserInputType.Touch then
            local getGuiInsetResult = guiService:GetGuiInset()
            value38 = Vector2.new(
              inputObject.Position.X - getGuiInsetResult.X,
              inputObject.Position.Y - getGuiInsetResult.Y
            )
          else
          end
          inputObject = list2[value37]
          if state == Enum.UserInputState.Begin then
            inputObject = object:IsPointerOverMenu(value38)
            list2[value37] = inputObject
          else
            inputObject = if input == Enum.UserInputType.MouseWheel
              then object:IsPointerOverMenu(value38)
              else if inputObject == nil
                then if state ~= Enum.UserInputState.End
                  then if state ~= Enum.UserInputState.Cancel
                    then object:IsPointerOverMenu(value38)
                    else inputObject
                  else inputObject
                else inputObject
          end
          if state == Enum.UserInputState.End then
            list2[value37] = nil
          elseif state == Enum.UserInputState.Cancel then
            list2[value37] = nil
          end
          return inputObject and Enum.ContextActionResult.Sink or Enum.ContextActionResult.Pass
        end
        contextActionService:BindActionAtPriority(
          generateGUIDResult,
          normalizePointer,
          false,
          5000,
          Enum.UserInputType.MouseButton1,
          Enum.UserInputType.MouseButton2,
          Enum.UserInputType.MouseButton3,
          Enum.UserInputType.MouseWheel,
          Enum.UserInputType.Touch
        )
        object.Floral = nil
        object.SetFlowersVisible = function(window, argument19)
          window.DecorationsEnabled = argument19 == true
          if window.Floral then
            window.Floral:SetVisible(window.DecorationsEnabled)
          elseif window.DecorationsEnabled then
            if frame.Parent then
              if not window._flowerBuildQueued then
                window._flowerBuildQueued = true
                task.defer(function()
                  window._flowerBuildQueued = false
                  if frame.Parent then
                    if window.DecorationsEnabled then
                      if not window.Floral then
                        window.Floral = createFlowerDecor(frame, function()
                          return window.Theme
                        end)
                      end
                    end
                  end
                end)
              end
            end
          end
        end
        object.SetGlowStrength = function(argument20, argument21)
          library:SetGlowStrength(argument21)
          argument20.GlowStrength = library.GlowStrength
        end
        task.defer(function()
          if frame.Parent then
            object:SetFlowersVisible(object.DecorationsEnabled)
          end
        end)
        unhighlightSettingsButton = newInstance("Frame", {
          Name = "KeybindList",
          AnchorPoint = Vector2.new(1, 0),
          Position = UDim2.new(1, -16, 0, 70),
          Size = UDim2.fromOffset(220, 34),
          AutomaticSize = Enum.AutomaticSize.Y,
          BackgroundColor3 = object.Theme.Card2,
          BackgroundTransparency = 0.12,
          BorderSizePixel = 0,
          ClipsDescendants = true,
          Visible = false,
          ZIndex = 200,
          Parent = screenGui,
        })
        applyCorner(unhighlightSettingsButton, 12)
        applyStroke(unhighlightSettingsButton, object.Theme.Stroke, 1, 0.2)
        newInstance("TextLabel", {
          BackgroundTransparency = 1,
          Size = UDim2.new(1, 0, 0, 30),
          Text = "Keybinds",
          TextColor3 = object.Theme.Text,
          TextSize = 14,
          Font = Enum.Font.GothamSemibold,
          Parent = unhighlightSettingsButton,
        })
        normalizePointer = newInstance("Frame", {
          Position = UDim2.fromOffset(8, 30),
          Size = UDim2.new(1, -16, 0, 0),
          AutomaticSize = Enum.AutomaticSize.Y,
          BackgroundTransparency = 1,
          Parent = unhighlightSettingsButton,
        })
        newInstance(
          "UIListLayout",
          { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = normalizePointer }
        )
        applyPadding(unhighlightSettingsButton, 0, 0, 0, 8)
        object.KeybindList = unhighlightSettingsButton
        object.KeybindListBody = normalizePointer
        object.KeybindListEntries = {}
        onMenuHoverEnter = newInstance("TextLabel", {
          Name = "Watermark",
          AnchorPoint = Vector2.new(1, 0),
          Position = UDim2.new(1, -16, 0, 16),
          Size = UDim2.fromOffset(250, 30),
          BackgroundColor3 = object.Theme.Card2,
          BackgroundTransparency = 0.1,
          Text = (config.Title or "Lunar") .. "  \226\128\162  UI Library",
          TextColor3 = object.Theme.Text,
          TextSize = 13,
          Font = Enum.Font.GothamMedium,
          BorderSizePixel = 0,
          ClipsDescendants = true,
          ZIndex = 200,
          Visible = false,
          Parent = screenGui2,
        })
        applyCorner(onMenuHoverEnter, 10)
        applyStroke(onMenuHoverEnter, object.Theme.Stroke, 1, 0.25)
        object.Watermark = onMenuHoverEnter
        applyResponsiveLayout = newInstance("Frame", {
          Name = "Notifications",
          AnchorPoint = Vector2.new(1, 1),
          Position = UDim2.new(1, -16, 1, -16),
          Size = UDim2.fromOffset(330, 0),
          AutomaticSize = Enum.AutomaticSize.Y,
          BackgroundTransparency = 1,
          ZIndex = 250,
          Parent = screenGui2,
        })
        newInstance("UIListLayout", {
          Padding = UDim.new(0, 7),
          FillDirection = Enum.FillDirection.Vertical,
          VerticalAlignment = Enum.VerticalAlignment.Bottom,
          HorizontalAlignment = Enum.HorizontalAlignment.Right,
          SortOrder = Enum.SortOrder.LayoutOrder,
          Parent = applyResponsiveLayout,
        })
        object.NotificationArea = applyResponsiveLayout
        local enabled, enabled2, enabled3 = false
        local function onInputBegan(input)
          if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
            if input.UserInputType ~= Enum.UserInputType.Touch then
              return
            end
          end
          enabled = true
          enabled2 = input.Position
          enabled3 = frame.Position
          local input2
          input2 = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
              enabled = false
              if input2 then
                input2:Disconnect()
              end
            end
          end)
        end
        frame4.InputBegan:Connect(onInputBegan)
        library.InputBegan:Connect(onInputBegan)
        table.insert(
          object._connections,
          userInputService.InputChanged:Connect(function(input)
            if not enabled then
              return
            end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement then
              if input.UserInputType ~= Enum.UserInputType.Touch then
                return
              end
            end
            local input2 = input.Position - enabled2
            frame.Position = UDim2.new(
              enabled3.X.Scale,
              enabled3.X.Offset + input2.X,
              enabled3.Y.Scale,
              enabled3.Y.Offset + input2.Y
            )
          end)
        )
        refreshBlurButton, createKeybindChip =
          newInstance("TextButton", {
            Name = "ResizeGrip",
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -8, 1, -4),
            Size = UDim2.fromOffset(18, 16),
            BackgroundTransparency = 1,
            Text = "",
            TextColor3 = object.Theme.TextMute,
            TextSize = 17,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
            ZIndex = 210,
            Parent = frame,
          }), { 10, 7, 4 }
        for index = 1, 1 / 0, 1 do
          applyResponsiveLayout = rawget(createKeybindChip, index)
          if applyResponsiveLayout == nil then
            break
          end
          applyCorner(
            newInstance("Frame", {
              Name = "GripLine",
              AnchorPoint = Vector2.new(0.5, 0.5),
              Position = UDim2.fromOffset(6 + index * 2, 6 + index * 2),
              Size = UDim2.fromOffset(applyResponsiveLayout, 1),
              Rotation = -45,
              BackgroundColor3 = object.Theme.TextMute,
              BackgroundTransparency = 0.3,
              BorderSizePixel = 0,
              Active = false,
              ZIndex = 211,
              Parent = refreshBlurButton,
            }),
            1
          )
        end
        object.ResizeGrip = refreshBlurButton
        local enabled4, enabled5, enabled6, enabled7 = false
        refreshBlurButton.InputBegan:Connect(function(input)
          if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
            if input.UserInputType ~= Enum.UserInputType.Touch then
              return
            end
          end
          enabled4 = true
          enabled5 = input.Position
          enabled6 = frame.AbsoluteSize
          enabled7 = frame.Position
        end)
        table.insert(
          object._connections,
          userInputService.InputChanged:Connect(function(input)
            if not enabled4 then
              return
            end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement then
              if input.UserInputType ~= Enum.UserInputType.Touch then
                return
              end
            end
            local input2, input3 =
              input.Position - enabled5,
              workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
            input = object.MaxSize
              or Vector2.new(
                math.max(object.MinSize.X, input3.X - 30),
                math.max(object.MinSize.Y, input3.Y - 30)
              )
            local clamped, clamped2 =
              math.clamp(enabled6.X + input2.X, object.MinSize.X, input.X),
              math.clamp(enabled6.Y + input2.Y, object.MinSize.Y, input.Y)
            frame.Size = UDim2.fromOffset(clamped, clamped2)
            input3, input2 = (clamped - enabled6.X) * 0.5, (clamped2 - enabled6.Y) * 0.5
            frame.Position = UDim2.new(
              enabled7.X.Scale,
              enabled7.X.Offset + input3,
              enabled7.Y.Scale,
              enabled7.Y.Offset + input2
            )
          end)
        )
        table.insert(
          object._connections,
          userInputService.InputEnded:Connect(function(_)
            if _.UserInputType == Enum.UserInputType.MouseButton1 then
              enabled4 = false
            elseif _.UserInputType == Enum.UserInputType.Touch then
              enabled4 = false
            end
          end)
        )
        table.insert(
          object._connections,
          userInputService.InputBegan:Connect(function(_, argument22)
            if argument22 then
              return
            elseif textBox:IsFocused() then
              return
            end
            argument22 = object.MenuKeybind
            if
              isKeyInput(
                _,
                if library.ToggleKeybind
                  then (normalizeKeycode(
                    library.ToggleKeybind.Value or library.ToggleKeybind.Get and library.ToggleKeybind:Get()
                  ))
                  else argument22
              )
            then
              object:Toggle()
            end
          end)
        )
        table.insert(
          object._connections,
          screenGui:GetPropertyChangedSignal("Enabled"):Connect(function()
            updateMenuBlur(screenGui.Enabled, false)
            releaseMouseLock(screenGui.Enabled)
          end)
        )
        table.insert(
          object._connections,
          runService.RenderStepped:Connect(function()
            if not screenGui.Enabled then
              return
            end
            if object.UnlockMouseWhileOpen then
              pcall(function()
                userInputService.MouseBehavior = Enum.MouseBehavior.Default
              end)
            end
            if object.ShowCustomCursor then
              if not userInputService.TouchEnabled then
                if userInputService.MouseIconEnabled then
                  pcall(function()
                    userInputService.MouseIconEnabled = false
                  end)
                end
                positionKeybindChip()
              end
            end
          end)
        )
        local function onSearchChanged()
          object.SearchQuery = string.lower(textBox.Text or "")
          object:_ApplySearch()
        end
        textBox:GetPropertyChangedSignal("Text"):Connect(onSearchChanged)
        table.insert(
          object._connections,
          userInputService.InputBegan:Connect(function(_, argument23)
            if argument23 then
              return
            elseif screenGui.Enabled then
              if not textBox.Parent then
                return
              end
            else
              return
            end
            if _.KeyCode == Enum.KeyCode.K then
              argument23 = Enum.KeyCode.LeftControl
              if userInputService:IsKeyDown(argument23) then
                textBox:CaptureFocus()
              else
                local enumValue = Enum.KeyCode.RightControl
                if userInputService:IsKeyDown(enumValue) then
                  textBox:CaptureFocus()
                else
                  local enumValue = Enum.KeyCode.LeftMeta
                  if userInputService:IsKeyDown(enumValue) then
                    textBox:CaptureFocus()
                  else
                    local enumValue = Enum.KeyCode.RightMeta
                    if userInputService:IsKeyDown(enumValue) then
                      textBox:CaptureFocus()
                    end
                  end
                end
              end
            end
          end)
        )
        object.Destroy = function(_)
          if _._OpenDropdown then
            if _._OpenDropdown.Close then
              pcall(function()
                _._OpenDropdown:Close()
              end)
            end
          end
          if _._OpenColorPicker then
            if _._OpenColorPicker.Close then
              pcall(function()
                _._OpenColorPicker:Close()
              end)
            end
          end
          updateMenuBlur(false, true)
          if _._applyMenuInputState then
            pcall(function()
              _._applyMenuInputState(false)
            end)
          end
          local value39 = _._connections or {}
          for index = 1, 1 / 0, 1 do
            local item = rawget(value39, index)
            if item == nil then
              break
            end
            pcall(function()
              item:Disconnect()
            end)
          end
          if _.Floral then
            pcall(function()
              _.Floral:Destroy()
            end)
          end
          if screenGui3 then
            pcall(function()
              screenGui3:Destroy()
            end)
          end
          if screenGui2 then
            pcall(function()
              screenGui2:Destroy()
            end)
          end
          contextActionService:UnbindAction(generateGUIDResult)
          table.clear(list)
          table.clear(list2)
          if screenGui4 then
            pcall(function()
              screenGui4:Destroy()
            end)
          end
          _.CursorGui = nil
          _.NotificationGui = nil
          _.NotificationArea = nil
          if screenGui then
            screenGui:Destroy()
          end
          if _._ownsBlur then
            if enabled2 then
              pcall(function()
                enabled2:Destroy()
              end)
            end
          end
        end
        object.SetBlurEnabled = function(_, argument24)
          _.BlurEnabled = not not argument24
          updateMenuBlur(screenGui.Enabled, false)
        end
        object.SetVisible = function(_, argument25)
          local value40 = not not argument25
          if not argument25 then
            if _._OpenDropdown then
              if _._OpenDropdown.Close then
                pcall(function()
                  _._OpenDropdown:Close()
                end)
              end
            end
          end
          if not argument25 then
            if _._OpenColorPicker then
              if _._OpenColorPicker.Close then
                pcall(function()
                  _._OpenColorPicker:Close()
                end)
              end
            end
          end
          screenGui.Enabled = value40
          library.Toggled = value40
          updateMenuBlur(value40, false)
          if _._applyMenuInputState then
            _._applyMenuInputState(value40)
          end
          if _._updateMobileToggleButton then
            _._updateMobileToggleButton(value40)
          end
        end
        object.Toggle = function(_)
          _:SetVisible(not screenGui.Enabled)
        end
        return object
      end
      list2.SetBackgroundImage = function(_, argument26)
        argument26 = tostring(argument26 or "")
        local value41 = _.BackgroundImage
        if if value41 then not _.BackgroundImage.Parent else not value41 then
          _.BackgroundImage = newInstance("ImageLabel", {
            Name = "LunarBackgroundImage",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            ImageTransparency = 0.72,
            ScaleType = Enum.ScaleType.Crop,
            ZIndex = 2,
            Parent = _.Root,
          })
          applyCorner(_.BackgroundImage, 20)
        end
        value41 = argument26:match("%d+")
        if value41 then
          _.BackgroundImage.Image = "rbxassetid://" .. value41
          _.BackgroundImage.Visible = true
        else
          _.BackgroundImage.Image = ""
          _.BackgroundImage.Visible = false
        end
      end
      list2.SetNotifySide = function(_, argument27)
        argument27 = tostring(argument27 or "Right")
        if not _.NotificationArea then
          return
        end
        if argument27 == "Left" then
          _.NotificationArea.AnchorPoint = Vector2.new(0, 1)
          _.NotificationArea.Position = UDim2.new(0, 16, 1, -16)
          local listLayout = _.NotificationArea:FindFirstChildOfClass("UIListLayout")
          if listLayout then
            listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
          end
        else
          _.NotificationArea.AnchorPoint = Vector2.new(1, 1)
          _.NotificationArea.Position = UDim2.new(1, -16, 1, -16)
          local listLayout = _.NotificationArea:FindFirstChildOfClass("UIListLayout")
          if listLayout then
            listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
          end
        end
      end
      list2._ApplySearch = function(_)
        local value42, value43 = _.SearchQuery or "", _.Elements
        for index = 1, 1 / 0, 1 do
          local item = rawget(value43, index)
          if item == nil then
            break
          end
          item:SetVisible((item:Matches(value42)))
        end
        value43 = _.Tabs
        for step = 1, 1 / 0, 1 do
          _ = rawget(value43, step)
          if _ == nil then
            break
          end
          _:_RefreshCanvas()
        end
      end
      list2._SelectTab = function(_, argument28)
        if argument28.ParentTab then
          _:_SelectTab(argument28.ParentTab)
          argument28.ParentTab:_SelectSubTab(argument28)
          return
        end
        if _.ActiveTab == argument28 then
          return
        end
        if _._OpenDropdown then
          _._OpenDropdown:Close()
        end
        if _._OpenColorPicker then
          _._OpenColorPicker:Close()
        end
        if _.ActiveTab then
          _.ActiveTab.Page.Visible = false
          _.ActiveTab:_SetSelected(false)
        end
        _.ActiveTab = argument28
        argument28.Page.Visible = true
        argument28:_SetSelected(true)
        _.CurrentLabel.Text = argument28.Name
        _.SearchBox.Text = ""
        local value44 = string.lower(tostring(argument28.Name or "")):find("settings", 1, true) ~= nil
        _._settingsSelected = value44
        if _.SettingsButton then
          if _.SettingsStroke then
            if _.SettingsGlow then
              local value45, list = _.SettingsButton, {}
              list.BackgroundTransparency = value44 and 0.28 or 0.7
              applyScaleAdapter(value45, 0.14, list)
              if _.SettingsLabel then
                argument28, list = _.SettingsLabel, {}
                list.TextColor3 = value44 and _.Theme.AccentSoft or _.Theme.Text
                applyScaleAdapter(argument28, 0.14, list)
              end
              if _.SettingsScale then
                value45, list = _.SettingsScale, {}
                list.Scale = value44 and 1.012 or 1
                applyScaleAdapter(value45, 0.14, list)
              end
              if _.SettingsAccent then
                list, value45 = _.SettingsAccent, { BackgroundTransparency = value44 and 0 or 1 }
                value45.Size = UDim2.fromOffset(3, value44 and 24 or 0)
                applyScaleAdapter(list, 0.16, value45)
              end
              _.SettingsButton.ZIndex = value44 and 35 or 20
              _.SettingsStroke.Transparency = value44 and 0.05 or 1
              _.SettingsGlow.Transparency = value44 and 0.4 or 0.95
              if _.SettingsIcon then
                _.SettingsIcon:SetColor(value44 and _.Theme.AccentSoft or _.Theme.TextDim)
              end
            end
          end
        end
      end
      local list = {}
      list.__index = list
      list.ColumnPadding = { Left = 8, Right = 10, Top = 6, Bottom = 10 }
      list2.AddTab = function(window, name, icon)
        local object = setmetatable({}, list)
        object.Window = window
        object.Name = name
        object.Icon = icon or name
        object.Cards = {}
        object.Groupboxes = {}
        object.Tabboxes = {}
        object.DependencyGroupboxes = {}
        local button = newInstance("TextButton", {
          Name = name,
          Size = UDim2.new(1, 0, 0, 40),
          BackgroundColor3 = Color3.fromRGB(45, 20, 44),
          BackgroundTransparency = 1,
          BorderSizePixel = 0,
          Text = "",
          AutoButtonColor = false,
          ZIndex = 20,
          Parent = window.Nav,
        })
        applyCorner(button, 15)
        local scale = newInstance("UIScale", { Scale = 1, Parent = button })
        local element, element2, element3 =
          applyStroke(button, window.Theme.Accent, 1, 1),
          attachGlow(button, window.Theme.Accent, 4, 0.96),
          newInstance("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.fromOffset(3, 0),
            BackgroundColor3 = window.Theme.AccentSoft,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Parent = button,
          })
        applyCorner(element3, 99)
        icon = newInstance("Frame", {
          Name = "IconSlot",
          BackgroundTransparency = 1,
          Position = UDim2.fromOffset(6, 7),
          Size = UDim2.fromOffset(30, 26),
          ClipsDescendants = true,
          Parent = button,
        })
        local element4, element5 =
          createVectorIcon(
            newInstance("Frame", {
              Name = "IconCanvas",
              BackgroundTransparency = 1,
              Position = UDim2.fromOffset(3, 1),
              Size = UDim2.fromOffset(24, 24),
              ClipsDescendants = true,
              Parent = icon,
            }),
            object.Icon or name,
            window.Theme
          ), newInstance("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(42, 0),
            Size = UDim2.new(1, -64, 1, 0),
            Text = name,
            TextColor3 = window.Theme.Text,
            TextSize = 14,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = button,
          })
        object.NavButton = button
        object.NavStroke = element
        object.NavGlow = element2
        object.NavIcon = element4
        object.NavLabel = element5
        object.NavScale = scale
        object.NavAccent = element3
        local frame = newInstance("Frame", {
          Name = name .. "Page",
          Size = UDim2.fromScale(1, 1),
          BackgroundTransparency = 1,
          BorderSizePixel = 0,
          Visible = false,
          ClipsDescendants = true,
          Parent = window.Content,
        })
        applyCorner(frame, 14)
        object.Page = frame
        object.Inner = frame
        icon =
          newInstance("Frame", { Size = UDim2.new(1, 0, 0, 44), BackgroundTransparency = 1, Parent = frame })
        newInstance("TextLabel", {
          BackgroundTransparency = 1,
          Position = UDim2.fromOffset(12, 6),
          Size = UDim2.fromOffset(230, 32),
          Text = name,
          TextColor3 = window.Theme.Text,
          TextSize = 18,
          Font = Enum.Font.GothamMedium,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextYAlignment = Enum.TextYAlignment.Center,
          Parent = icon,
        })
        object.CountLabel = newInstance("TextLabel", {
          BackgroundTransparency = 1,
          Position = UDim2.fromOffset(20 + measureText(name, 18, Enum.Font.GothamMedium).X, 11),
          Size = UDim2.fromOffset(110, 22),
          Text = "0 modules",
          TextColor3 = window.Theme.TextDim,
          TextSize = 11,
          Font = Enum.Font.GothamSemibold,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextYAlignment = Enum.TextYAlignment.Center,
          Parent = icon,
        })
        object.Header = icon
        local function createScrollingPanel(name, parent, layout)
          local scrollFrame = newInstance("ScrollingFrame", {
            Name = name,
            Position = parent,
            Size = layout,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = window.Theme.Accent2,
            ScrollBarImageTransparency = 0.28,
            CanvasSize = UDim2.fromOffset(0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.None,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
            ScrollingEnabled = true,
            ClipsDescendants = true,
            Parent = frame,
          })
          applyCorner(scrollFrame, 12)
          name = object.ColumnPadding
          applyPadding(scrollFrame, name.Left, name.Right, name.Top, name.Bottom)
          return scrollFrame
        end
        local sResult = createScrollingPanel("Left", UDim2.new(0, 0, 0, 44), UDim2.new(0.5, 0, 1, -44))
        local sResult2 = createScrollingPanel("Right", UDim2.new(0.5, 0, 0, 44), UDim2.new(0.5, 0, 1, -44))
        object._LayoutColumns = function(unused)
          local element, element2 = frame.AbsoluteSize.X < 580, unused.ParentTab and 0 or 44
          sResult.Position = UDim2.new(0, 0, 0, element2)
          sResult.Size = element and UDim2.new(1, 0, 1, -element2) or UDim2.new(0.5, 0, 1, -element2)
          sResult2.Position = UDim2.new(0.5, 0, 0, element2)
          sResult2.Size = UDim2.new(0.5, 0, 1, -element2)
          sResult2.Visible = not element
          element2 = unused.Cards
          for index = 1, 1 / 0, 1 do
            unused = rawget(element2, index)
            if unused == nil then
              break
            end
            local value46, value47 =
              unused.Frame, element and sResult or (unused.ColumnSide == "right" and sResult2 or sResult)
            value46.Parent = value47
            unused:Resize()
          end
        end
        local function refreshCanvasLayout()
          local value48 = object.Cards
          for index = 1, 1 / 0, 1 do
            local item = rawget(value48, index)
            if item == nil then
              break
            end
            item:Resize()
          end
        end
        sResult:GetPropertyChangedSignal("AbsoluteSize"):Connect(refreshCanvasLayout)
        sResult2:GetPropertyChangedSignal("AbsoluteSize"):Connect(refreshCanvasLayout)
        local function onCanvasResized()
          object:_LayoutColumns()
        end
        frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(onCanvasResized)
        task.defer(function()
          object:_LayoutColumns()
        end)
        object.Left = sResult
        object.Right = sResult2
        object.Sides = { sResult, sResult2 }
        object.Columns = frame
        createScrollingPanel, element2 =
          newInstance(
            "UIListLayout",
            { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = sResult }
          ),
          newInstance(
            "UIListLayout",
            { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = sResult2 }
          )
        object.LeftList = createScrollingPanel
        object.RightList = element2
        local function refreshCanvas()
          object:_RefreshCanvas()
        end
        createScrollingPanel:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshCanvas)
        element2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshCanvas)
        local function onTabButtonClick()
          window:_SelectTab(object)
        end
        button.MouseButton1Click:Connect(onTabButtonClick)
        local function updateTabButtonInactive()
          button.ZIndex = 35
          if window.ActiveTab ~= object then
            applyScaleAdapter(button, 0.12, { BackgroundTransparency = 0.72 })
            applyScaleAdapter(element5, 0.12, { TextColor3 = window.Theme.AccentSoft })
            applyScaleAdapter(scale, 0.12, { Scale = 1.012 })
          end
        end
        button.MouseEnter:Connect(updateTabButtonInactive)
        local function updateTabButtonActive()
          if window.ActiveTab ~= object then
            applyScaleAdapter(button, 0.12, { BackgroundTransparency = 1 })
            applyScaleAdapter(element5, 0.12, { TextColor3 = window.Theme.Text })
            applyScaleAdapter(scale, 0.12, { Scale = 1 })
            button.ZIndex = 20
          else
            button.ZIndex = 35
          end
        end
        button.MouseLeave:Connect(updateTabButtonActive)
        table.insert(window.Tabs, object)
        library.Tabs[name] = object
        if name == "Settings" or name == "UI Settings" then
          if window.SettingsButton then
            button.Visible = false
            onTabButtonClick, refreshCanvasLayout =
              window.SettingsButton, function()
                window:_SelectTab(object)
              end
            onTabButtonClick.MouseButton1Click:Connect(refreshCanvasLayout)
          end
        end
        if not window.ActiveTab then
          window:_SelectTab(object)
        end
        return object
      end
      list._SetSelected = function(argument29, argument30)
        argument29.NavButton.ZIndex = argument30 and 35 or 20
        if argument30 then
          applyScaleAdapter(argument29.NavButton, 0.16, { BackgroundTransparency = 0.26 })
          local value49, list = argument29.NavLabel, {}
          list.TextColor3 = argument29.Window.Theme.AccentSoft
          applyScaleAdapter(value49, 0.16, list)
          applyScaleAdapter(argument29.NavScale, 0.16, { Scale = 1.012 })
          value49, list = argument29.NavAccent, { BackgroundTransparency = 0 }
          list.Size = UDim2.fromOffset(3, 24)
          applyScaleAdapter(value49, 0.18, list)
          argument29.NavStroke.Transparency = 0.04
          argument29.NavStroke.Thickness = 1.2
          if argument29.NavGlow then
            argument29.NavGlow.Transparency = 0.4
          end
          argument29.NavIcon:SetColor(argument29.Window.Theme.AccentSoft)
        else
          applyScaleAdapter(argument29.NavButton, 0.16, { BackgroundTransparency = 1 })
          local value50, list = argument29.NavLabel, {}
          list.TextColor3 = argument29.Window.Theme.Text
          applyScaleAdapter(value50, 0.16, list)
          applyScaleAdapter(argument29.NavScale, 0.16, { Scale = 1 })
          list, value50 = argument29.NavAccent, { BackgroundTransparency = 1 }
          value50.Size = UDim2.fromOffset(3, 0)
          applyScaleAdapter(list, 0.16, value50)
          argument29.NavStroke.Transparency = 1
          if argument29.NavGlow then
            argument29.NavGlow.Transparency = 0.96
          end
          argument29.NavIcon:SetColor(argument29.Window.Theme.TextDim)
        end
      end
      list._RefreshCanvas = function(argument31)
        if argument31._canvasRefreshQueued then
          return
        end
        argument31._canvasRefreshQueued = true
        task.defer(function()
          argument31._canvasRefreshQueued = false
          if argument31.Page then
            if not argument31.Page.Parent then
              return
            end
          else
            return
          end
          local value51 = argument31.ColumnPadding
          local value52 = value51.Top + value51.Bottom
          local value53, value54 =
            math.max(0, argument31.LeftList.AbsoluteContentSize.Y + value52),
            math.max(0, argument31.RightList.AbsoluteContentSize.Y + value52)
          argument31.Left.CanvasSize = UDim2.fromOffset(0, value53)
          argument31.Right.CanvasSize = UDim2.fromOffset(0, value54)
        end)
      end
      list.AddGroupbox = function(tab, options)
        options = (if type(options) == "string" then { Name = options, Side = 1 } else options) or {}
        local value55, value56 =
          options.Name or options.Text or "Groupbox " .. tostring(#tab.Cards + 1),
          (options.Side == 2 or string.lower(tostring(options.Side)) == "right") and "Right" or "Left"
        local addCardResult = tab:AddCard(value55, options.Subtitle or "", value56)
        addCardResult.Name = value55
        addCardResult.Side = value56 == "Right" and 2 or 1
        tab.Groupboxes[value55] = addCardResult
        return addCardResult
      end
      list.AddLeftGroupbox = function(tab, name)
        return tab:AddGroupbox({ Name = name, Side = 1 })
      end
      list.AddRightGroupbox = function(tab, name)
        return tab:AddGroupbox({ Name = name, Side = 2 })
      end
      list.AddLeftTabbox = function(tab, argument32)
        local addCardResult = tab:AddCard(argument32 or "Tabs", "", "Left"):AddTabbox(argument32 or "Tabs")
        tab.Tabboxes[argument32 or ""] = addCardResult
        return addCardResult
      end
      list.AddRightTabbox = function(tab, argument33)
        local addCardResult = tab:AddCard(argument33 or "Tabs", "", "Right"):AddTabbox(argument33 or "Tabs")
        tab.Tabboxes[argument33 or ""] = addCardResult
        return addCardResult
      end
      list._SelectSubTab = function(tab, subtab)
        subtab = if type(subtab) == "string" then tab.SubtabByName and tab.SubtabByName[subtab] else subtab
        if subtab then
          if subtab.ParentTab ~= tab then
            return
          elseif tab.ActiveSubtab == subtab then
            return
          end
        else
          return
        end
        local value57 = tab.Window
        if value57._OpenDropdown then
          value57._OpenDropdown:Close()
        end
        if value57._OpenColorPicker then
          value57._OpenColorPicker:Close()
        end
        if tab.ActiveSubtab then
          tab.ActiveSubtab.Page.Visible = false
          tab.ActiveSubtab:_SetSelected(false)
        end
        tab.ActiveSubtab = subtab
        subtab.Page.Visible = true
        subtab:_SetSelected(true)
        if value57.SearchQuery ~= "" or value57.SearchBox.Text ~= "" then
          value57.SearchQuery = ""
          value57.SearchBox.Text = ""
          value57:_ApplySearch()
        end
        subtab:_LayoutColumns()
        subtab:_RefreshCanvas()
      end
      list.SelectSubTab = function(tab, subtab)
        tab.Window:_SelectTab(tab)
        tab:_SelectSubTab(subtab)
      end
      list.AddSubTab = function(tab, name, icon)
        if tab.SubtabByName then
          if tab.SubtabByName[name] then
            return tab.SubtabByName[name]
          end
        end
        if not tab.Subtabs then
          tab.Subtabs = {}
          tab.SubtabByName = {}
          tab.Header.Visible = false
          tab._LayoutColumns = function(argument34)
            argument34.Left.Visible = false
            argument34.Right.Visible = false
          end
          tab:_LayoutColumns()
          tab.SubtabBar = newInstance("ScrollingFrame", {
            Name = "CombatSubtabs",
            Position = UDim2.fromOffset(8, 4),
            Size = UDim2.new(1, -18, 0, 36),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            CanvasSize = UDim2.fromOffset(0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.X,
            ScrollingDirection = Enum.ScrollingDirection.X,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = tab.Window.Theme.Accent,
            ClipsDescendants = true,
            ZIndex = 20,
            Parent = tab.Page,
          })
          newInstance("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
            Parent = tab.SubtabBar,
          })
        end
        local clicked = list2.AddTab(tab.Window, name, icon)
        clicked.ParentTab = tab
        clicked.NavButton.Visible = false
        clicked.Header.Visible = false
        clicked.Page.Parent = tab.Page
        clicked.Page.Position = UDim2.fromOffset(0, 44)
        clicked.Page.Size = UDim2.new(1, 0, 1, -44)
        clicked.Page.Visible = false
        local clicked2, bound =
          tab.Window.Theme, math.max(96, measureText(name, 12, Enum.Font.GothamSemibold).X + 48)
        local button = newInstance("TextButton", {
          Name = name,
          Size = UDim2.fromOffset(bound, 32),
          LayoutOrder = #tab.Subtabs + 1,
          BackgroundColor3 = clicked2.Card,
          BackgroundTransparency = 0.35,
          BorderSizePixel = 0,
          Text = "",
          TextColor3 = clicked2.TextDim,
          TextSize = 12,
          Font = Enum.Font.GothamSemibold,
          AutoButtonColor = false,
          TextTruncate = Enum.TextTruncate.AtEnd,
          ZIndex = 21,
          Parent = tab.SubtabBar,
        })
        applyCorner(button, 8)
        local yResult = applyStroke(button, clicked2.StrokeSoft, 1, 0.35)
        local sResult = attachGlow(button, clicked2.Accent, 4, 0.64)
        local frame = createVectorIcon(
          newInstance("Frame", {
            Name = "SubtabIcon",
            Position = UDim2.fromOffset(8, 7),
            Size = UDim2.fromOffset(18, 18),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 22,
            Parent = button,
          }),
          icon or name,
          clicked2
        )
        local label = newInstance("TextLabel", {
          Name = "SubtabLabel",
          Position = UDim2.fromOffset(33, 0),
          Size = UDim2.new(1, -41, 1, 0),
          BackgroundTransparency = 1,
          Text = name,
          TextColor3 = clicked2.TextDim,
          TextSize = 12,
          Font = Enum.Font.GothamSemibold,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextTruncate = Enum.TextTruncate.AtEnd,
          ZIndex = 22,
          Parent = button,
        })
        clicked.SubtabButton = button
        clicked.SubtabIcon = frame
        clicked.SubtabLabel = label
        clicked._SetSelected = function(argument35, argument36)
          local value58 = argument35.Window.Theme
          button.BackgroundColor3 = argument36 and value58.Accent or value58.Card
          button.BackgroundTransparency = argument36 and 0.2 or 0.35
          button.TextColor3 = argument36 and value58.White or value58.TextDim
          label.TextColor3 = argument36 and value58.White or value58.TextDim
          frame:SetColor(argument36 and value58.White or value58.TextDim)
          yResult.Color = argument36 and value58.AccentSoft or value58.StrokeSoft
          yResult.Transparency = argument36 and 0.1 or 0.35
          sResult.Color = value58.Accent
          sResult.Transparency = argument36 and 0.34 or 0.64
        end
        clicked.Show = function(argument37)
          argument37.ParentTab:SelectSubTab(argument37)
        end
        local function onSubtabClick()
          clicked:Show()
        end
        button.MouseButton1Click:Connect(onSubtabClick)
        local function onSubtabHover()
          applyScaleAdapter(sResult, 0.12, { Transparency = 0.28 })
        end
        button.MouseEnter:Connect(onSubtabHover)
        local function refreshSubtabSelected()
          clicked:_SetSelected(tab.ActiveSubtab == clicked)
        end
        button.MouseLeave:Connect(refreshSubtabSelected)
        tab.Subtabs[#tab.Subtabs + 1] = clicked
        tab.SubtabByName[name] = clicked
        clicked:_LayoutColumns()
        if not tab.ActiveSubtab then
          tab:_SelectSubTab(clicked)
        end
        return clicked
      end
      local list = {}
      list.__index = list
      list.AddCard = function(tab, title, subtitle, side)
        local object = setmetatable({}, list)
        object.Tab = tab
        object.Window = tab.Window
        object.Title = title
        object.Subtitle = subtitle or ""
        local value59 = object.Subtitle ~= "" and 46 or 36
        object.Elements = {}
        object.ColumnSide = string.lower(side or "Left")
        side = tab.Page.AbsoluteSize.X < 580
        local element = (if side then not side else object.ColumnSide == "right") and tab.Right or tab.Left
        side = newInstance("Frame", {
          Name = title,
          Size = UDim2.fromOffset(
            math.max(1, element.AbsoluteSize.X - tab.ColumnPadding.Left - tab.ColumnPadding.Right),
            76
          ),
          AutomaticSize = Enum.AutomaticSize.None,
          BackgroundColor3 = Color3.new(1, 1, 1),
          BackgroundTransparency = 0,
          BorderSizePixel = 0,
          ClipsDescendants = true,
          Parent = element,
        })
        object.Frame = side
        applyCorner(side, 12)
        applyStroke(side, tab.Window.Theme.AccentSoft, 1, 0.55)
        attachGlow(side, tab.Window.Theme.Accent, 4, 0.74)
        newInstance("UIGradient", {
          Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, tab.Window.Theme.Card2),
            ColorSequenceKeypoint.new(0.24, tab.Window.Theme.Window2),
            ColorSequenceKeypoint.new(0.9, tab.Window.Theme.Window),
            ColorSequenceKeypoint.new(1, tab.Window.Theme.Card),
          }),
          Rotation = 90,
          Parent = side,
        })
        element = newInstance("Frame", {
          Size = UDim2.new(1, 0, 0, value59),
          BackgroundColor3 = Color3.new(1, 1, 1),
          BackgroundTransparency = 0.12,
          BorderSizePixel = 0,
          Parent = side,
        })
        local cResult = applyCorner(element, 12)
        pcall(function()
          cResult.BottomLeftRadius = UDim.new(0, 0)
          cResult.BottomRightRadius = UDim.new(0, 0)
        end)
        applyGradient(element, tab.Window.Theme.Card, tab.Window.Theme.Card2, 90)
        object.Header = element
        createVectorIcon(
          newInstance("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(8, 8),
            Size = UDim2.fromOffset(20, 20),
            ClipsDescendants = true,
            Parent = element,
          }),
          title,
          tab.Window.Theme
        ):SetColor(tab.Window.Theme.Accent)
        newInstance("TextLabel", {
          BackgroundTransparency = 1,
          Position = UDim2.fromOffset(34, object.Subtitle ~= "" and 5 or 8),
          Size = UDim2.new(1, -76, 0, 20),
          Text = title,
          TextTruncate = Enum.TextTruncate.AtEnd,
          TextColor3 = tab.Window.Theme.Text,
          TextSize = 15,
          Font = Enum.Font.GothamMedium,
          TextXAlignment = Enum.TextXAlignment.Left,
          Parent = element,
        })
        newInstance("TextLabel", {
          BackgroundTransparency = 1,
          Position = UDim2.fromOffset(34, 23),
          Size = UDim2.new(1, -76, 0, 18),
          Text = tostring(subtitle or ""),
          RichText = false,
          TextColor3 = tab.Window.Theme.TextDim,
          TextSize = 11,
          Font = Enum.Font.GothamMedium,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextWrapped = true,
          Parent = element,
        })
        local button = newInstance("TextButton", {
          AnchorPoint = Vector2.new(1, 0),
          Position = UDim2.new(1, -12, 0, 8),
          Size = UDim2.fromOffset(22, 22),
          BackgroundTransparency = 1,
          Text = "\226\136\146",
          AutoButtonColor = false,
          TextColor3 = tab.Window.Theme.TextDim,
          TextSize = 14,
          Font = Enum.Font.GothamBold,
          Parent = element,
        })
        newInstance("Frame", {
          AnchorPoint = Vector2.new(0, 1),
          Position = UDim2.new(0, 0, 1, 0),
          Size = UDim2.new(1, 0, 0, 1),
          BackgroundColor3 = tab.Window.Theme.StrokeSoft,
          BackgroundTransparency = 0.55,
          BorderSizePixel = 0,
          Parent = element,
        })
        title = newInstance("Frame", {
          Position = UDim2.fromOffset(0, value59),
          Size = UDim2.new(1, 0, 0, 0),
          AutomaticSize = Enum.AutomaticSize.Y,
          BackgroundTransparency = 1,
          Parent = side,
        })
        object.Body = title
        object.Container = title
        object.Outer = side
        subtitle = newInstance(
          "UIListLayout",
          { Padding = UDim.new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder, Parent = title }
        )
        object.BodyList = subtitle
        object.Collapsed = false
        object.Resize = function(element)
          local element2 = element.Frame.Parent
          if not element2 then
            return
          end
          local element3 = element.Tab.ColumnPadding
          local element4, element5 =
            math.max(1, math.floor(element2.AbsoluteSize.X - element3.Left - element3.Right)),
            if element.Collapsed then value59 else value59 + element.BodyList.AbsoluteContentSize.Y + 8
          element.Frame.Size = UDim2.fromOffset(element4, element5)
          element.Tab:_RefreshCanvas()
        end
        object.SetCollapsed = function(unused, argument38)
          unused.Collapsed = argument38 == true
          button.Text = unused.Collapsed and "+" or "\226\136\146"
          if unused.Window._OpenDropdown then
            unused.Window._OpenDropdown:Close()
          end
          if unused.Window._OpenColorPicker then
            unused.Window._OpenColorPicker:Close()
          end
          unused.Body.Visible = not unused.Collapsed
          unused:Resize()
          return unused
        end
        local function onCardContentResized()
          object:Resize()
        end
        subtitle:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(onCardContentResized)
        local function onCollapseToggle()
          object:SetCollapsed(not object.Collapsed)
        end
        button.Activated:Connect(onCollapseToggle)
        table.insert(tab.Cards, object)
        object:Resize()
        tab.CountLabel.Text = tostring(#tab.Cards) .. " modules"
        tab:_RefreshCanvas()
        return object
      end
      local function createRowContainer(argument39, argument40, argument41)
        local value60 = argument39.Window.Theme
        local frame = newInstance("Frame", {
          Name = argument40,
          Size = UDim2.new(1, 0, 0, math.max(argument41 or 32, 32)),
          BackgroundColor3 = value60.Row,
          BackgroundTransparency = 1,
          BorderSizePixel = 0,
          Parent = argument39.Body,
        })
        newInstance("Frame", {
          AnchorPoint = Vector2.new(0, 1),
          Position = UDim2.new(0, 0, 1, 0),
          Size = UDim2.new(1, 0, 0, 1),
          BackgroundColor3 = value60.StrokeSoft,
          BackgroundTransparency = 0.52,
          BorderSizePixel = 0,
          Parent = frame,
        })
        local value61, value62 =
          newInstance("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(10, 0),
            Size = UDim2.new(0.46, -8, 1, 0),
            Text = argument40,
            TextColor3 = value60.Text,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = frame,
          }), setmetatable({ Container = frame, SearchText = argument40, Card = argument39 }, list)
        table.insert(argument39.Elements, value62)
        table.insert(argument39.Window.Elements, value62)
        return frame, value61, value62
      end
      list.AddToggle = function(card, text, default, callback)
        local pResult, pResult2, pResult3 = createRowContainer(card, text, 34)
        pResult2.Size = UDim2.new(1, -62, 1, 0)
        local clicked = card.Window.Theme
        local clicked2 = default == true
        local button = newInstance("TextButton", {
          AnchorPoint = Vector2.new(1, 0.5),
          Position = UDim2.new(1, -12, 0.5, 0),
          Size = UDim2.fromOffset(32, 18),
          BackgroundColor3 = clicked2 and clicked.Accent or Color3.fromRGB(40, 24, 46),
          BorderSizePixel = 0,
          Text = "",
          AutoButtonColor = false,
          Parent = pResult,
        })
        applyCorner(button, 99)
        local yResult = applyStroke(
          button,
          clicked2 and clicked.AccentSoft or clicked.StrokeSoft,
          1,
          clicked2 and 0.08 or 0.52
        )
        local sResult = attachGlow(button, clicked.Accent, clicked2 and 5 or 3, clicked2 and 0.36 or 0.82)
        local frame = newInstance("Frame", {
          AnchorPoint = Vector2.new(0.5, 0.5),
          Position = clicked2 and UDim2.new(1, -9, 0.5, 0) or UDim2.new(0, 9, 0.5, 0),
          Size = UDim2.fromOffset(14, 14),
          BackgroundColor3 = clicked.White,
          BorderSizePixel = 0,
          Parent = button,
        })
        applyCorner(frame, 99)
        local list = {
          Set = function(argument42, argument43, argument44)
            clicked2 = not not argument43
            applyScaleAdapter(
              button,
              0.13,
              { BackgroundColor3 = clicked2 and clicked.Accent or Color3.fromRGB(40, 24, 46) }
            )
            applyScaleAdapter(
              frame,
              0.13,
              { Position = clicked2 and UDim2.new(1, -9, 0.5, 0) or UDim2.new(0, 9, 0.5, 0) }
            )
            applyScaleAdapter(yResult, 0.13, {
              Color = clicked2 and clicked.AccentSoft or clicked.StrokeSoft,
              Transparency = clicked2 and 0.08 or 0.52,
              Thickness = clicked2 and 1.25 or 1,
            })
            applyScaleAdapter(
              sResult,
              0.16,
              {
                Color = clicked.Accent,
                Transparency = clicked2 and 0.36 or 0.82,
                Thickness = clicked2 and 5 or 3,
              }
            )
            if callback then
              if not argument44 then
                task.spawn(callback, clicked2)
              end
            end
          end,
          Get = function(argument45)
            argument45 = clicked2
            return argument45
          end,
        }
        button.MouseButton1Click:Connect(function()
          list:Set(not clicked2)
        end)
        pResult3.ValueObject = list
        return list
      end
      list.AddButton = function(card, text, callback, options)
        local pResult, pResult2 = createRowContainer(card, text, 36)
        text = card.Window.Theme
        local button = newInstance("TextButton", {
          AnchorPoint = Vector2.new(1, 0.5),
          Position = UDim2.new(1, -12, 0.5, 0),
          Size = UDim2.fromOffset(94, 23),
          BackgroundColor3 = Color3.fromRGB(69, 35, 67),
          BackgroundTransparency = 0.08,
          Text = callback or "Run",
          TextColor3 = text.Text,
          TextSize = 11,
          Font = Enum.Font.GothamMedium,
          AutoButtonColor = false,
          Parent = pResult,
        })
        button.TextWrapped = true
        button.TextTruncate = Enum.TextTruncate.None
        applyPadding(button, 10, 10, 4, 4)
        local function updateButtonText()
          if pResult.Parent then
            if pResult.AbsoluteSize.X <= 24 then
              return
            end
          else
            return
          end
          local bound, rounded =
            math.max(1, pResult.AbsoluteSize.X - 24),
            math.ceil(measureText(button.Text, button.TextSize, button.Font).X) + 24
          local bound2 = math.min(bound, math.max(94, rounded))
          rounded = measureText(button.Text, button.TextSize, button.Font, math.max(1, bound2 - 24))
          local bound3, element =
            math.max(26, math.ceil(rounded.Y) + 10), pResult2.Text ~= "" and pResult2.Text ~= button.Text
          pResult2.Visible = element
          pResult2.TextWrapped = true
          pResult2.TextTruncate = Enum.TextTruncate.None
          if
            element and measureText(pResult2.Text, pResult2.TextSize, pResult2.Font).X + bound2 + 16 > bound
          then
            rounded = math.ceil(measureText(pResult2.Text, pResult2.TextSize, pResult2.Font, bound).Y)
            pResult2.Position = UDim2.fromOffset(12, 6)
            pResult2.Size = UDim2.fromOffset(bound, rounded)
            button.AnchorPoint = Vector2.new(1, 0)
            button.Position = UDim2.new(1, -12, 0, rounded + 12)
            pResult.Size = UDim2.new(1, 0, 0, rounded + bound3 + 20)
          else
            pResult2.Position = UDim2.fromOffset(12, 0)
            pResult2.Size = UDim2.new(0, math.max(0, bound - bound2 - 16), 1, 0)
            button.AnchorPoint = Vector2.new(1, 0.5)
            button.Position = UDim2.new(1, -12, 0.5, 0)
            pResult.Size = UDim2.new(1, 0, 0, math.max(34, bound3 + 8))
          end
          button.Size = UDim2.fromOffset(bound2, bound3)
        end
        pResult:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateButtonText)
        callback = { "Text", "TextSize", "Font" }
        for index = 1, 1 / 0, 1 do
          card = rawget(callback, index)
          if card == nil then
            break
          end
          button:GetPropertyChangedSignal(card):Connect(updateButtonText)
          pResult2:GetPropertyChangedSignal(card):Connect(updateButtonText)
        end
        task.defer(updateButtonText)
        applyCorner(button, 11)
        local yResult = applyStroke(button, text.AccentSoft, 1, 0.32)
        local sResult = attachGlow(button, text.Accent, 5, 0.58)
        local function onButtonHover()
          applyScaleAdapter(button, 0.12, { BackgroundColor3 = Color3.fromRGB(88, 41, 79) })
          applyScaleAdapter(yResult, 0.12, { Transparency = 0.16 })
          applyScaleAdapter(sResult, 0.12, { Transparency = 0.3, Thickness = 6 })
        end
        button.MouseEnter:Connect(onButtonHover)
        local function onButtonLeave()
          applyScaleAdapter(button, 0.12, { BackgroundColor3 = Color3.fromRGB(69, 35, 67) })
          applyScaleAdapter(yResult, 0.12, { Transparency = 0.32 })
          applyScaleAdapter(sResult, 0.12, { Transparency = 0.58, Thickness = 5 })
        end
        button.MouseLeave:Connect(onButtonLeave)
        local function onButtonPress()
          applyScaleAdapter(sResult, 0.08, { Transparency = 0.18, Thickness = 7 })
          task.delay(0.14, function()
            if button then
              if button.Parent then
                applyScaleAdapter(sResult, 0.18, { Transparency = 0.58, Thickness = 5 })
              end
            end
          end)
          if options then
            task.spawn(options)
          end
        end
        button.MouseButton1Click:Connect(onButtonPress)
        return button
      end
      list.AddTextbox = function(card, text, default, callback, multiline, options)
        local value63 = (options or {}).MultiLine == true
        local pResult, pResult2, pResult3 = createRowContainer(card, text, value63 and 144 or 34)
        local value64, value65 =
          card.Window.Theme, newInstance("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -12, 0.5, 0),
            Size = UDim2.fromOffset(126, 21),
            BackgroundColor3 = Color3.fromRGB(35, 18, 39),
            BorderSizePixel = 0,
            Parent = pResult,
          })
        applyCorner(value65, 9)
        applyStroke(value65, value64.StrokeSoft, 1, 0.35)
        attachGlow(value65, value64.Accent, 4, 0.72)
        if value63 then
          pResult2.Position = UDim2.fromOffset(10, 0)
          pResult2.Size = UDim2.new(1, -20, 0, 26)
          value65.AnchorPoint = Vector2.new(0, 0)
          value65.Position = UDim2.fromOffset(10, 28)
          value65.Size = UDim2.new(1, -20, 1, -36)
          value65.ClipsDescendants = true
        end
        local textBox = newInstance("TextBox", {
          BackgroundTransparency = 1,
          Position = UDim2.fromOffset(9, value63 and 6 or 0),
          Size = UDim2.new(1, -18, 1, value63 and -12 or 0),
          Text = tostring(default or ""),
          PlaceholderText = callback or "Type...",
          PlaceholderColor3 = value64.TextMute,
          TextColor3 = value64.Text,
          TextSize = 11,
          Font = Enum.Font.Gotham,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextYAlignment = value63 and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
          MultiLine = value63,
          TextWrapped = value63,
          TextEditable = true,
          ClearTextOnFocus = false,
          Parent = value65,
        })
        local list = {
          Set = function(argument46, argument47, argument48)
            textBox.Text = tostring(argument47 or "")
            if multiline then
              if not argument48 then
                task.spawn(multiline, textBox.Text)
              end
            end
          end,
          Get = function(argument49)
            return textBox.Text
          end,
        }
        local function onTextboxChanged()
          list.Value = textBox.Text
          if multiline then
            task.spawn(multiline, textBox.Text)
          end
          if list._listeners then
            local value66 = list._listeners
            for index = 1, 1 / 0, 1 do
              local item = rawget(value66, index)
              if item == nil then
                break
              end
              task.spawn(item, textBox.Text)
            end
          end
        end
        textBox.FocusLost:Connect(onTextboxChanged)
        pResult3.ValueObject = list
        return list
      end
      list.AddSlider = function(card, text, min, max, default, step, callback)
        local pResult, pResult2, pResult3 = createRowContainer(card, text, 34)
        local input, number = card.Window.Theme, tonumber(min) or 0
        local number2 = tonumber(max) or 100
        local number3 = tonumber(step) or 1
        local clamped = math.clamp(tonumber(default) or number, number, number2)
        local label = newInstance("TextLabel", {
          AnchorPoint = Vector2.new(1, 0.5),
          Position = UDim2.new(1, -10, 0.5, 0),
          Size = UDim2.fromOffset(48, 22),
          BackgroundColor3 = Color3.fromRGB(49, 25, 53),
          Text = tostring(clamped),
          TextColor3 = input.Text,
          TextSize = 12,
          Font = Enum.Font.GothamMedium,
          Parent = pResult,
        })
        applyCorner(label, 10)
        applyStroke(label, input.StrokeSoft, 1, 0.5)
        local button = newInstance("TextButton", {
          Position = UDim2.new(0, 100, 0.5, -9),
          Size = UDim2.new(1, -170, 0, 18),
          BackgroundColor3 = input.Track,
          BorderSizePixel = 0,
          Text = "",
          AutoButtonColor = false,
          Parent = pResult,
        })
        applyCorner(button, 99)
        applyStroke(button, input.Stroke, 1, 0.36)
        local frame = newInstance("Frame", {
          Size = UDim2.new((clamped - number) / (number2 - number), 0, 1, 0),
          BackgroundColor3 = Color3.new(1, 1, 1),
          BorderSizePixel = 0,
          Parent = button,
        })
        applyCorner(frame, 99)
        applyGradient(frame, input.Accent2, input.Accent, 0)
        attachGlow(frame, input.Accent, 4, 0.62)
        local frame2 = newInstance("Frame", {
          AnchorPoint = Vector2.new(0.5, 0.5),
          Position = UDim2.new((clamped - number) / (number2 - number), 0, 0.5, 0),
          Size = UDim2.fromOffset(14, 14),
          BackgroundColor3 = input.White,
          BorderSizePixel = 0,
          Parent = button,
        })
        applyCorner(frame2, 99)
        attachGlow(frame2, input.AccentSoft, 5, 0.48)
        pResult2.TextWrapped = true
        pResult2.TextTruncate = Enum.TextTruncate.None
        local function updateSliderFill()
          local width = pResult.AbsoluteSize.X
          if width <= 0 then
            return
          end
          local clamped = math.clamp(measureText(label.Text, label.TextSize, label.Font).X + 18, 48, 110)
          label.Size = UDim2.fromOffset(clamped, 22)
          local cResult = measureText(pResult2.Text, pResult2.TextSize, pResult2.Font)
          local rounded = math.ceil(cResult.X)
          local bound = math.max(94, rounded + 32)
          if width - bound - clamped - 22 < 96 then
            rounded = math.max(
              20,
              math.ceil(
                measureText(pResult2.Text, pResult2.TextSize, pResult2.Font, math.max(1, width - 20)).Y
              ) + 2
            )
            pResult.Size = UDim2.new(1, 0, 0, rounded + 44)
            pResult2.Position = UDim2.fromOffset(10, 4)
            pResult2.Size = UDim2.new(1, -20, 0, rounded)
            button.Position = UDim2.fromOffset(16, rounded + 14)
            button.Size = UDim2.new(1, -clamped - 42, 0, 18)
            label.Position = UDim2.new(1, -10, 0, rounded + 23)
          else
            pResult.Size = UDim2.new(1, 0, 0, math.max(38, math.ceil(cResult.Y) + 16))
            pResult2.Position = UDim2.fromOffset(10, 0)
            pResult2.Size = UDim2.new(0, bound - 30, 1, 0)
            button.Position = UDim2.new(0, bound, 0.5, -9)
            button.Size = UDim2.new(1, -bound - clamped - 22, 0, 18)
            label.Position = UDim2.new(1, -10, 0.5, 0)
          end
        end
        pResult:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSliderFill)
        label:GetPropertyChangedSignal("Text"):Connect(updateSliderFill)
        pResult2:GetPropertyChangedSignal("Text"):Connect(updateSliderFill)
        pResult2:GetPropertyChangedSignal("TextSize"):Connect(updateSliderFill)
        pResult2:GetPropertyChangedSignal("Font"):Connect(updateSliderFill)
        task.defer(updateSliderFill)
        local list = {}
        local function snapToStep(argument50)
          return math.floor(argument50 / number3 + 0.5) * number3
        end
        list.Set = function(argument51, argument52, argument53)
          argument52 = math.clamp(snapToStep(tonumber(argument52) or number), number, number2)
          clamped = argument52
          argument51 = (argument52 - number) / (number2 - number)
          frame.Size = UDim2.new(argument51, 0, 1, 0)
          frame2.Position = UDim2.new(argument51, 0, 0.5, 0)
          label.Text = number3 < 1 and string.format("%.3f", argument52):gsub("0+$", ""):gsub("%.$", "")
            or tostring(argument52)
          if callback then
            if not argument53 then
              task.spawn(callback, argument52)
            end
          end
        end
        list.Get = function(argument54)
          argument54 = clamped
          return argument54
        end
        local enabled = false
        local function onSliderDrag(position)
          local clamped =
            math.clamp((position - button.AbsolutePosition.X) / math.max(button.AbsoluteSize.X, 1), 0, 1)
          list:Set(number + (number2 - number) * clamped)
        end
        button.InputBegan:Connect(function(input)
          if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
          then
            enabled = true
            onSliderDrag(input.Position.X)
          end
        end)
        userInputService.InputChanged:Connect(function(input)
          local input2 = enabled
            and (
              input.UserInputType == Enum.UserInputType.MouseMovement
              or input.UserInputType == Enum.UserInputType.Touch
            )
          if input2 then
            onSliderDrag(input.Position.X)
          end
        end)
        userInputService.InputEnded:Connect(function(input)
          if input.UserInputType == Enum.UserInputType.MouseButton1 then
            enabled = false
          elseif input.UserInputType == Enum.UserInputType.Touch then
            enabled = false
          end
        end)
        pResult3.ValueObject = list
        return list
      end
      local function markOptionSelected(element, argument55)
        element.Text = ""
        local list = { -1, 1 }
        for index = 1, 1 / 0, 1 do
          local item = rawget(list, index)
          if item == nil then
            break
          end
          applyCorner(
            newInstance("Frame", {
              AnchorPoint = Vector2.new(0.5, 0.5),
              Position = UDim2.new(0.5, item * 3, 0.5, 0),
              Size = UDim2.fromOffset(8, 2),
              Rotation = item == -1 and 45 or -45,
              BackgroundColor3 = argument55,
              BorderSizePixel = 0,
              Active = false,
              ZIndex = element.ZIndex,
              Parent = element,
            }),
            99
          )
        end
      end
      local function createDropdownPopup(argument56, element, visible, argument57, argument58)
        local value67
        local function pointInBounds(element, position)
          local position2, position3 = element.AbsolutePosition, element.AbsoluteSize
          return position.X >= position2.X
            and position.X <= position2.X + position3.X
            and position.Y >= position2.Y
            and position.Y <= position2.Y + position3.Y
        end
        argument57.ContainsPoint = function(argument59, argument60)
          return pointInBounds(element, argument60) or visible.Visible and pointInBounds(visible, argument60)
        end
        argument57.Close = function(argument61)
          visible.Visible = false
          argument58.Rotation = 0
          if value67 then
            value67:Disconnect()
            value67 = nil
          end
          if argument56._OpenDropdown == argument57 then
            argument56._OpenDropdown = nil
          end
        end
        local function refreshDropdownPopup()
          if element.Parent then
            if not argument56.Gui.Enabled then
              argument57:Close()
              return
            end
          else
            argument57:Close()
            return
          end
          local element, position = element.AbsolutePosition + element.AbsoluteSize * 0.5, element
          while position and position ~= argument56.Gui do
            if position:IsA("GuiObject") then
              if position.Visible then
                if position.ClipsDescendants then
                  if not (pointInBounds(position, element)) then
                    argument57:Close()
                    return
                  end
                end
              else
                argument57:Close()
                return
              end
            end
            position = position.Parent
          end
          element = argument56.PopupLayer
          local position2, position3 = element.AbsolutePosition, element.AbsoluteSize
          local position4, position5 = element.AbsolutePosition - position2, element.AbsoluteSize
          element, position2 =
            math.min(math.max(position5.X, 152), math.max(1, position3.X - 16)),
            math.min(visible.CanvasSize.Y.Offset, 240, math.max(1, position3.Y - 16))
          local clamped, position6 =
            math.clamp(position4.X + position5.X - element, 8, math.max(8, position3.X - element - 8)),
            position4.Y + position5.Y + 4
          position6 = if position6 + position2 > position3.Y - 8
            then position4.Y - position2 - 4
            else position6
          position6 = math.clamp(position6, 8, math.max(8, position3.Y - position2 - 8))
          visible.Size = UDim2.fromOffset(element, position2)
          visible.Position = UDim2.fromOffset(clamped, position6)
        end
        element.Activated:Connect(function()
          if visible.Visible then
            argument57:Close()
            return
          end
          if visible.CanvasSize.Y.Offset <= 0 then
            return
          end
          if argument56._OpenDropdown then
            argument56._OpenDropdown:Close()
          end
          if argument56._OpenColorPicker then
            argument56._OpenColorPicker:Close()
          end
          visible.CanvasPosition = Vector2.new(0, 0)
          argument56._OpenDropdown = argument57
          visible.Visible = true
          argument58.Rotation = 180
          refreshDropdownPopup()
          if visible.Visible then
            value67 = runService.RenderStepped:Connect(refreshDropdownPopup)
          end
        end)
      end
      list.AddDropdown = function(card, text, default, callback, options)
        local pResult, pResult2, pResult3 = createRowContainer(card, text, 36)
        pResult2.Size = UDim2.new(1, -156, 1, 0)
        local clicked = card.Window.Theme
        local clicked2 = default or {}
        local clicked3 = callback or clicked2[1] or "None"
        pResult2 = newInstance("TextButton", {
          AnchorPoint = Vector2.new(1, 0.5),
          Position = UDim2.new(1, -12, 0.5, 0),
          Size = UDim2.fromOffset(124, 26),
          BackgroundColor3 = Color3.fromRGB(39, 20, 43),
          Text = "",
          AutoButtonColor = false,
          Parent = pResult,
        })
        applyCorner(pResult2, 13)
        applyStroke(pResult2, clicked.AccentSoft, 1, 0.42)
        attachGlow(pResult2, clicked.Accent, 4, 0.64)
        local label = newInstance("TextLabel", {
          BackgroundTransparency = 1,
          Position = UDim2.fromOffset(10, 0),
          Size = UDim2.new(1, -38, 1, 0),
          Text = tostring(clicked3),
          TextColor3 = clicked.Text,
          TextSize = 12,
          Font = Enum.Font.Gotham,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextTruncate = Enum.TextTruncate.AtEnd,
          Parent = pResult2,
        })
        text = newInstance("TextLabel", {
          AnchorPoint = Vector2.new(1, 0.5),
          Position = UDim2.new(1, -9, 0.5, 0),
          Size = UDim2.fromOffset(20, 20),
          BackgroundTransparency = 1,
          Text = "\226\140\132",
          TextColor3 = clicked.TextDim,
          TextSize = 15,
          Font = Enum.Font.GothamBold,
          Parent = pResult2,
        })
        markOptionSelected(text, clicked.TextDim)
        callback = card.Window.PopupLayer or card.Window.Gui
        local scrollFrame = newInstance("ScrollingFrame", {
          Position = UDim2.fromOffset(0, 0),
          Size = UDim2.fromOffset(136, 0),
          BackgroundColor3 = Color3.fromRGB(29, 13, 33),
          BorderSizePixel = 0,
          Visible = false,
          ZIndex = 510,
          ScrollBarThickness = 2,
          ScrollBarImageColor3 = clicked.AccentSoft,
          ScrollBarImageTransparency = 0.25,
          CanvasSize = UDim2.fromOffset(0, 0),
          ScrollingDirection = Enum.ScrollingDirection.Y,
          ClipsDescendants = true,
          Parent = callback,
        })
        applyCorner(scrollFrame, 10)
        applyStroke(scrollFrame, clicked.Stroke, 1, 0.15)
        newInstance("UIListLayout", {
          SortOrder = Enum.SortOrder.LayoutOrder,
          FillDirection = Enum.FillDirection.Vertical,
          VerticalAlignment = Enum.VerticalAlignment.Top,
          Parent = scrollFrame,
        })
        local list = {
          Set = function(argument62, argument63, argument64)
            clicked3 = argument63
            label.Text = tostring(argument63)
            if options then
              if not argument64 then
                task.spawn(options, argument63)
              end
            end
          end,
          Get = function(argument65)
            argument65 = clicked3
            return argument65
          end,
        }
        list.SetValues = function(clicked, clicked2)
          clicked2 = clicked2 or {}
          clicked = scrollFrame:GetChildren()
          for index = 1, 1 / 0, 1 do
            clicked2 = rawget(clicked, index)
            if clicked2 == nil then
              break
            end
            if clicked2:IsA("TextButton") then
              clicked2:Destroy()
            end
          end
          clicked = clicked2
          for step = 1, 1 / 0, 1 do
            local item = rawget(clicked, step)
            if item == nil then
              break
            end
            local button = newInstance("TextButton", {
              LayoutOrder = step,
              Size = UDim2.new(1, -2, 0, 23),
              BackgroundTransparency = 1,
              Text = "  " .. tostring(item),
              TextColor3 = clicked.Text,
              TextSize = 12,
              Font = Enum.Font.Gotham,
              TextXAlignment = Enum.TextXAlignment.Left,
              TextTruncate = Enum.TextTruncate.AtEnd,
              AutoButtonColor = false,
              ZIndex = 511,
              Parent = scrollFrame,
            })
            local function onOptionHover()
              button.BackgroundTransparency = 0.65
              button.BackgroundColor3 = Color3.fromRGB(72, 35, 69)
            end
            button.MouseEnter:Connect(onOptionHover)
            local function onOptionLeave()
              button.BackgroundTransparency = 1
            end
            button.MouseLeave:Connect(onOptionLeave)
            local function onOptionClick()
              list:Set(item)
              list:Close()
            end
            button.MouseButton1Click:Connect(onOptionClick)
          end
          clicked = #clicked2 * 23
          clicked2 = math.min(clicked, 184)
          scrollFrame.Size = UDim2.fromOffset(136, clicked2)
          scrollFrame.CanvasSize = UDim2.fromOffset(0, clicked)
          scrollFrame.CanvasPosition = Vector2.new(0, 0)
        end
        list:SetValues(clicked2)
        createDropdownPopup(card.Window, pResult2, scrollFrame, list, text)
        pResult3.ValueObject = list
        return list
      end
      list.AddKeybind = function(card, text, default, callback)
        local pResult, pResult2, pResult3 = createRowContainer(card, text, 36)
        local input, input2, enabled = card.Window.Theme, default or Enum.KeyCode.RightShift, false
        local button = newInstance("TextButton", {
          AnchorPoint = Vector2.new(1, 0.5),
          Position = UDim2.new(1, -12, 0.5, 0),
          Size = UDim2.fromOffset(142, 24),
          BackgroundColor3 = Color3.fromRGB(39, 20, 43),
          Text = tostring(input2.Name or input2),
          TextColor3 = input.Text,
          TextSize = 11,
          Font = Enum.Font.Gotham,
          AutoButtonColor = false,
          Parent = pResult,
        })
        applyCorner(button, 11)
        applyStroke(button, input.AccentSoft, 1, 0.42)
        attachGlow(button, input.Accent, 4, 0.62)
        local list = {
          Set = function(argument66, argument67, argument68)
            input2 = argument67
            button.Text = tostring(argument67.Name or argument67)
            if callback then
              if not argument68 then
                task.spawn(callback, argument67)
              end
            end
          end,
          Get = function(argument69)
            argument69 = input2
            return argument69
          end,
        }
        button.MouseButton1Click:Connect(function()
          enabled = true
          button.Text = "Press a key..."
        end)
        userInputService.InputBegan:Connect(function(input, input2)
          if not enabled then
            return
          end
          enabled = false
          input2 = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
          list:Set(input2)
        end)
        pResult3.ValueObject = list
        return list
      end
      library.ThemePresets = library.ThemePresets
        or {
          Sakura = deepCopy(library.Theme),
          Amethyst = {
            Window = Color3.fromRGB(16, 10, 25),
            Window2 = Color3.fromRGB(23, 13, 35),
            Sidebar = Color3.fromRGB(18, 10, 28),
            Topbar = Color3.fromRGB(28, 16, 41),
            Card = Color3.fromRGB(45, 31, 61),
            Card2 = Color3.fromRGB(33, 23, 48),
            Row = Color3.fromRGB(38, 26, 52),
            Stroke = Color3.fromRGB(89, 67, 118),
            StrokeSoft = Color3.fromRGB(62, 47, 84),
            Accent = Color3.fromRGB(180, 104, 255),
            Accent2 = Color3.fromRGB(145, 78, 225),
            AccentSoft = Color3.fromRGB(214, 169, 255),
            Text = Color3.fromRGB(242, 235, 249),
            TextDim = Color3.fromRGB(184, 170, 199),
            TextMute = Color3.fromRGB(132, 119, 150),
            Track = Color3.fromRGB(49, 34, 67),
            White = Color3.fromRGB(255, 250, 255),
            Green = Color3.fromRGB(111, 229, 158),
          },
          Moonlight = {
            Window = Color3.fromRGB(8, 13, 24),
            Window2 = Color3.fromRGB(11, 19, 33),
            Sidebar = Color3.fromRGB(8, 15, 26),
            Topbar = Color3.fromRGB(12, 23, 39),
            Card = Color3.fromRGB(24, 38, 59),
            Card2 = Color3.fromRGB(17, 29, 46),
            Row = Color3.fromRGB(21, 34, 52),
            Stroke = Color3.fromRGB(45, 74, 108),
            StrokeSoft = Color3.fromRGB(35, 57, 82),
            Accent = Color3.fromRGB(89, 177, 255),
            Accent2 = Color3.fromRGB(62, 139, 227),
            AccentSoft = Color3.fromRGB(154, 214, 255),
            Text = Color3.fromRGB(231, 242, 252),
            TextDim = Color3.fromRGB(159, 184, 205),
            TextMute = Color3.fromRGB(103, 129, 151),
            Track = Color3.fromRGB(27, 44, 65),
            White = Color3.fromRGB(250, 253, 255),
            Green = Color3.fromRGB(100, 227, 168),
          },
          Crimson = {
            Window = Color3.fromRGB(21, 7, 12),
            Window2 = Color3.fromRGB(32, 10, 16),
            Sidebar = Color3.fromRGB(24, 7, 12),
            Topbar = Color3.fromRGB(39, 12, 19),
            Card = Color3.fromRGB(61, 26, 34),
            Card2 = Color3.fromRGB(45, 18, 25),
            Row = Color3.fromRGB(52, 21, 29),
            Stroke = Color3.fromRGB(112, 51, 63),
            StrokeSoft = Color3.fromRGB(78, 37, 47),
            Accent = Color3.fromRGB(255, 84, 113),
            Accent2 = Color3.fromRGB(218, 53, 84),
            AccentSoft = Color3.fromRGB(255, 150, 170),
            Text = Color3.fromRGB(250, 232, 235),
            TextDim = Color3.fromRGB(200, 162, 169),
            TextMute = Color3.fromRGB(151, 111, 120),
            Track = Color3.fromRGB(63, 26, 34),
            White = Color3.fromRGB(255, 248, 249),
            Green = Color3.fromRGB(114, 232, 157),
          },
        }
      local function sanitizeId(id)
        return tostring(id or "Option"):gsub("[^%w_%-%.]", "_")
      end
      local function registerOption(card, text, default, options, callback, flag, mode)
        if not options then
          return nil
        end
        local value68, value69 =
          sanitizeId(
            flag
              or (text.Tab and text.Tab.Name or "Tab")
                .. "."
                .. (text.Title or "Card")
                .. "."
                .. tostring(default)
          ),
          callback == "Toggle" and card.Toggles or card.Options
        default, flag = value68, 2
        while value69[default] and value69[default] ~= options do
          default, flag = value68 .. "_" .. tostring(flag), flag + 1
        end
        options.Id = default
        options.Type = callback
        options.NoSave = mode == true
        options._listeners = options._listeners or {}
        options.Value = options.Get and options:Get() or options.Value
        local value70 = options.Set
        if value70 and not options.__DecoratedSet then
          options.Set = function(value, argument70, argument71)
            value70(value, argument70, argument71)
            value.Value = value.Get and value:Get() or argument70
            if not argument71 then
              argument70 = value._listeners
              for index = 1, 1 / 0, 1 do
                local item = rawget(argument70, index)
                if item == nil then
                  break
                end
                task.spawn(item, value.Value)
              end
            end
            return value
          end
          options.SetValue = options.Set
          options.__DecoratedSet = true
        elseif options.SetValue then
        elseif value70 then
          options.SetValue = value70
        end
        options.OnChanged = function(argument72, argument73)
          if type(argument73) == "function" then
            table.insert(argument72._listeners, argument73)
          end
          return argument72
        end
        options.RunChanged = function(value)
          value.Value = value.Get and value:Get() or value.Value
          local value71 = value._listeners or {}
          for index = 1, 1 / 0, 1 do
            local item = rawget(value71, index)
            if item == nil then
              break
            end
            task.spawn(item, value.Value)
          end
          return value
        end
        options.SetId = function(option, id)
          id = sanitizeId(id)
          if id == "" then
            return option
          end
          local value72 = option.Type == "Toggle" and card.Toggles or card.Options
          if value72[option.Id] == option then
            value72[option.Id] = nil
          end
          option.Id = id
          value72[id] = option
          return option
        end
        options.Serialize = function(option)
          if option.Type == "Keybind" or option.Type == "KeyPicker" then
            return {
              Key = serializeValue(option:Get()),
              Mode = option.GetMode and option:GetMode() or option.Mode,
              Active = option.IsActive and option:IsActive() or option.Toggled,
            }
          end
          return serializeValue(option.Get and option:Get() or option.Value)
        end
        options.Deserialize = function(option, data)
          if option.Type == "Keybind" or option.Type == "KeyPicker" then
            if type(data) == "table" then
              local uResult = deserializeValue(data.Key)
              if uResult then
                if option.Set then
                  option:Set(uResult, false)
                end
              end
              if data.Mode then
                if option.SetMode then
                  option:SetMode(data.Mode, false)
                end
              end
              return
            end
          end
          if option.Set then
            option:Set(deserializeValue(data), false)
          end
        end
        value69[default] = options
        return options
      end
      list2._RegisterOption = function(card, text, default, options, callback, flag, mode)
        return registerOption(card, text, default, options, callback, flag, mode)
      end
      list2.GetOption = function(window, id)
        return window.Options and window.Options[id]
      end
      list2.SetToggleKeybind = function(window, keybind)
        if typeof(keybind) == "EnumItem" then
          window.MenuKeybind = keybind
        end
      end
      list2.SetKeybindListVisible = function(window, visible)
        if window.KeybindList then
          window.KeybindList.Visible = not not visible
        end
      end
      list2.SetWatermarkVisible = function(window, visible)
        if window.Watermark then
          window.Watermark.Visible = not not visible
        end
      end
      list2.SetWatermark = function(window, text)
        if not window.Watermark then
          return
        end
        local textLabel = window.Watermark
        textLabel.Text = tostring(text or "")
        textLabel.TextTruncate = Enum.TextTruncate.AtEnd
        text = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
        window = math.min(
          math.max(1, text.X - 32),
          math.max(250, math.ceil(measureText(textLabel.Text, textLabel.TextSize, textLabel.Font).X) + 24)
        )
        textLabel.Size = UDim2.fromOffset(window, 30)
      end
      list2.SetSize = function(window, size)
        size = if typeof(size) == "Vector2" then UDim2.fromOffset(size.X, size.Y) else size
        if typeof(size) == "UDim2" then
          if window.Root then
            window.Root.Size = size
          end
        end
      end
      list2.Notify = function(window, title, message, duration)
        if window.NotificationsEnabled then
          if window.NotificationArea then
            if not window.NotificationArea.Parent then
              return
            end
          else
            return
          end
        else
          return
        end
        message = tonumber(message) or 3.2
        local value73 = window.Theme
        local value74, frame =
          duration == "Error" and Color3.fromRGB(255, 92, 112)
            or (duration == "Success" and value73.Green or value73.Accent),
          newInstance("Frame", {
            Size = UDim2.fromOffset(310, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = value73.Card2,
            BackgroundTransparency = 0.05,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 260,
            Parent = window.NotificationArea,
          })
        applyCorner(frame, 12)
        applyStroke(frame, value74, 1, 0.2)
        applyPadding(frame, 12, 12, 10, 10)
        local frame2 = newInstance(
          "Frame",
          {
            Size = UDim2.fromOffset(3, 28),
            BackgroundColor3 = value74,
            BorderSizePixel = 0,
            ZIndex = 261,
            Parent = frame,
          }
        )
        applyCorner(frame2, 99)
        local label = newInstance("TextLabel", {
          Position = UDim2.fromOffset(12, 0),
          Size = UDim2.new(1, -12, 0, 20),
          AutomaticSize = Enum.AutomaticSize.Y,
          BackgroundTransparency = 1,
          Text = tostring(title),
          TextWrapped = true,
          TextColor3 = value73.Text,
          TextSize = 12,
          Font = Enum.Font.Gotham,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextYAlignment = Enum.TextYAlignment.Top,
          ZIndex = 261,
          Parent = frame,
        })
        frame.BackgroundTransparency = 1
        label.TextTransparency = 1
        frame2.BackgroundTransparency = 1
        applyScaleAdapter(frame, 0.18, { BackgroundTransparency = 0.05 })
        applyScaleAdapter(label, 0.18, { TextTransparency = 0 })
        applyScaleAdapter(frame2, 0.18, { BackgroundTransparency = 0 })
        task.delay(message, function()
          if not frame.Parent then
            return
          end
          applyScaleAdapter(frame, 0.18, { BackgroundTransparency = 1 })
          applyScaleAdapter(label, 0.18, { TextTransparency = 1 })
          applyScaleAdapter(frame2, 0.18, { BackgroundTransparency = 1 })
          task.delay(0.2, function()
            if frame.Parent then
              frame:Destroy()
            end
          end)
        end)
      end
      list2._UpdateKeybindList = function(window)
        if window._keybindRefreshQueued then
          return
        end
        window._keybindRefreshQueued = true
        task.defer(function()
          window._keybindRefreshQueued = false
          if window.Gui then
            if not window.Gui.Parent then
              return
            end
          else
            return
          end
          window:_RefreshKeybindList()
        end)
      end
      list2._RefreshKeybindList = function(window)
        if not window.KeybindListBody then
          return
        end
        local list, value75 = {}, window.Keybinds or {}
        for index = 1, 1 / 0, 1 do
          local item = rawget(value75, index)
          if item == nil then
            break
          end
          if item.ShowInList ~= false and (item:IsActive() or item:GetMode() == "Always") then
            index = window.KeybindListEntries[item]
            if if index then not index.Parent else not index then
              index = newInstance(
                "Frame",
                { Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Parent = window.KeybindListBody }
              )
              newInstance("TextLabel", {
                Name = "Name",
                Size = UDim2.new(0.62, 0, 1, 0),
                BackgroundTransparency = 1,
                TextColor3 = window.Theme.Text,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = index,
              })
              newInstance("TextLabel", {
                Name = "Key",
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, 0, 0, 0),
                Size = UDim2.new(0.38, 0, 1, 0),
                BackgroundTransparency = 1,
                TextColor3 = window.Theme.AccentSoft,
                TextSize = 11,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = index,
              })
              window.KeybindListEntries[item] = index
            else
            end
            local name, key = index:FindFirstChild("Name"), index:FindFirstChild("Key")
            if name then
              name.Text = item.DisplayName or item.Id or "Keybind"
            end
            if key then
              key.Text = inputToText(item:Get()) .. "  [" .. item:GetMode() .. "]"
            end
            index.Visible = true
            list[item] = true
          end
        end
        for key, value in next, window.KeybindListEntries, nil do
          if not list[key] then
            value.Visible = false
          end
        end
      end
      list2.SetTheme = function(window, theme, save)
        if type(theme) ~= "table" then
          return false
        end
        local enabled = false
        for key, value in next, theme, nil do
          if typeof(value) == "Color3" and value ~= window.Theme[key] then
            enabled = true
            break
          end
        end
        if not enabled then
          window.ThemeName = save or window.ThemeName
          return true
        end
        local hResult, hResult2 = deepCopy(window.Theme), deepCopy(window.Theme)
        for extra, extra2 in next, theme, nil do
          if typeof(extra2) == "Color3" then
            hResult2[extra] = extra2
          end
        end
        local list = {}
        for extra3, extra4 in next, hResult, nil do
          if typeof(extra4) == "Color3" then
            if typeof(hResult2[extra3]) == "Color3" then
              list[colorToHex(extra4)] = hResult2[extra3]
            end
          end
        end
        local function resolveThemeColor(unused)
          return list[colorToHex(unused)] or unused
        end
        hResult = window.Gui:GetDescendants()
        if window.NotificationGui then
          theme = window.NotificationGui:GetDescendants()
          for index = 1, 1 / 0, 1 do
            local item = rawget(theme, index)
            if item == nil then
              break
            end
            hResult[#hResult + 1] = item
          end
        end
        for limit = 1, 1 / 0, 1 do
          local item = rawget(hResult, limit)
          if item == nil then
            break
          end
          if item:IsA("UIStroke") then
            item.Color = resolveThemeColor(item.Color)
          elseif item:IsA("UIGradient") then
            local list = {}
            theme = item.Color.Keypoints
            for index = 1, 1 / 0, 1 do
              limit = rawget(theme, index)
              if limit == nil then
                break
              end
              table.insert(list, ColorSequenceKeypoint.new(limit.Time, (resolveThemeColor(limit.Value))))
            end
            pcall(function()
              item.Color = ColorSequence.new(list)
            end)
          elseif item:IsA("GuiObject") then
            item.BackgroundColor3 = resolveThemeColor(item.BackgroundColor3)
            item.BorderColor3 = resolveThemeColor(item.BorderColor3)
            if item:IsA("TextLabel") then
              item.TextColor3 = resolveThemeColor(item.TextColor3)
            elseif item:IsA("TextButton") then
              item.TextColor3 = resolveThemeColor(item.TextColor3)
            elseif item:IsA("TextBox") then
              item.TextColor3 = resolveThemeColor(item.TextColor3)
            elseif item:IsA("ImageLabel") then
              item.ImageColor3 = resolveThemeColor(item.ImageColor3)
            elseif item:IsA("ImageButton") then
              item.ImageColor3 = resolveThemeColor(item.ImageColor3)
            elseif item:IsA("ViewportFrame") then
              item.ImageColor3 = resolveThemeColor(item.ImageColor3)
            elseif item:IsA("ScrollingFrame") then
              item.ScrollBarImageColor3 = resolveThemeColor(item.ScrollBarImageColor3)
            end
          end
        end
        for extra5, extra6 in next, hResult2, nil do
          window.Theme[extra5] = extra6
        end
        window.ThemeName = save or window.ThemeName
        if window.Floral then
          window.Floral:Rebuild()
        end
        resolveThemeColor = window.Tabs
        for limit2 = 1, 1 / 0, 1 do
          window = rawget(resolveThemeColor, limit2)
          if window == nil then
            break
          end
          if window.ParentTab then
            window:_SetSelected(window.ParentTab.ActiveSubtab == window)
          end
        end
        return true
      end
      list2.ApplyThemePreset = function(window, preset)
        local value76 = library.ThemePresets[preset]
        if not value76 then
          return false
        end
        return window:SetTheme(value76, preset)
      end
      local value77 = list.AddToggle
      local value78 = list.AddTextbox
      local value79 = list.AddSlider
      local value80 = list.AddDropdown
      local value81 = list.AddButton
      list.AddToggle = function(card, text, default, callback)
        local value82, value83, value84
        if type(default) == "table" then
          local value85 = default.Text or text
          default, callback, value83 = default.Default, default.Callback, default.NoSave
          value82, value84 = text, value85
        else
          value84 = text
        end
        local xResult =
          value77(card, value84, if card.Window.FeatureDefaultsOff then false else default, callback)
        card.Window:_RegisterOption(card, value84, xResult, "Toggle", value82, value83)
        xResult.DisplayName = value84
        xResult.Callback = callback
        xResult.Value = xResult:Get()
        xResult.AddKeyPicker = function(card, text, options)
          local value86, value87 = options or {}, card
          local value88 = value86.Callback
          local function onPickerChanged(argument74, ...)
            if value86.SyncToggleState then
              value87:Set(argument74)
            end
            if value88 then
              value88(argument74, ...)
            end
          end
          local value89, value90 =
            card._card, {
              Text = value86.Text or value84 .. " Key",
              Default = value86.Default or "None",
              Mode = value86.Mode or "Toggle",
              Modes = value86.Modes,
              Callback = onPickerChanged,
              ChangedCallback = value86.ChangedCallback,
              NoSave = value86.NoSave,
              NoUI = value86.NoUI,
              SyncToggleState = value86.SyncToggleState,
            }
          return value89:AddKeyPicker(text, value90)
        end
        xResult.AddColorPicker = function(card, text, options)
          options = options or {}
          local value91, value92 =
            card._card, {
              Text = options.Text or value84 .. " Color",
              Default = options.Default or card._card.Window.Theme.Accent,
              Callback = options.Callback,
              NoSave = options.NoSave,
            }
          return value91:AddColorPicker(text, value92)
        end
        xResult._card = card
        return xResult
      end
      list.AddTextbox = function(card, text, default, callback, multiline)
        local value93, value94, value95, value96
        if type(default) == "table" then
          value96 = default.Text or text
          default, callback, multiline, value93, value94, value95 =
            default.Default or "",
            default.Placeholder or default.PlaceholderText or "Type...",
            default.Callback,
            text,
            default.NoSave,
            default
        else
          value96 = text
        end
        text = value78(card, value96, default, callback, multiline, value95)
        card.Window:_RegisterOption(card, value96, text, "Input", value93, value94)
        text.DisplayName = value96
        text.Callback = multiline
        text.Value = text:Get()
        return text
      end
      list.AddInput = list.AddTextbox
      list.AddSlider = function(card, text, min, max, default, step, callback)
        local value97, value98, value99
        if type(min) == "table" then
          value99 = min.Text or text
          local value100 = min
          min, max = value100.Min or 0, value100.Max or 100
          default, step, callback, value97, value98 =
            value100.Default or min,
            if value100.Step
              then value100.Step
              else if value100.Rounding ~= nil then 10 ^ -(tonumber(value100.Rounding) or 0) else 1,
            value100.Callback,
            text,
            value100.NoSave
        else
          value99 = text
        end
        text = value79(card, value99, min, max, default, step, callback)
        card.Window:_RegisterOption(card, value99, text, "Slider", value97, value98)
        text.DisplayName = value99
        text.Callback = callback
        text.Min = min
        text.Max = max
        text.Rounding = step
        text.Value = text:Get()
        return text
      end
      local function createDropdownCore(card, text, options)
        local clicked = options or {}
        local clicked2, clicked3, list = clicked.Text or text, clicked.Values or {}, {}
        local clicked4 = clicked.Default
        if type(clicked4) == "table" then
          for key, value in next, clicked4, nil do
            if type(key) == "number" then
              list[tostring(value)] = true
            elseif value then
              list[tostring(key)] = true
            end
          end
        end
        local pResult, pResult2, pResult3 = createRowContainer(card, clicked2, 42)
        pResult2.Size = UDim2.new(1, -184, 1, 0)
        local clicked5 = card.Window.Theme
        pResult2 = newInstance("TextButton", {
          AnchorPoint = Vector2.new(1, 0.5),
          Position = UDim2.new(1, -12, 0.5, 0),
          Size = UDim2.fromOffset(152, 26),
          BackgroundColor3 = Color3.fromRGB(39, 20, 43),
          Text = "",
          AutoButtonColor = false,
          Parent = pResult,
        })
        applyCorner(pResult2, 11)
        applyStroke(pResult2, clicked5.AccentSoft, 1, 0.42)
        attachGlow(pResult2, clicked5.Accent, 4, 0.62)
        local label = newInstance("TextLabel", {
          BackgroundTransparency = 1,
          Position = UDim2.fromOffset(9, 0),
          Size = UDim2.new(1, -34, 1, 0),
          Text = "None",
          TextColor3 = clicked5.Text,
          TextSize = 12,
          Font = Enum.Font.Gotham,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextTruncate = Enum.TextTruncate.AtEnd,
          Parent = pResult2,
        })
        clicked4 = newInstance("TextLabel", {
          AnchorPoint = Vector2.new(1, 0.5),
          Position = UDim2.new(1, -7, 0.5, 0),
          Size = UDim2.fromOffset(18, 18),
          BackgroundTransparency = 1,
          Text = "\226\140\132",
          TextColor3 = clicked5.TextDim,
          TextSize = 14,
          Font = Enum.Font.GothamBold,
          Parent = pResult2,
        })
        markOptionSelected(clicked4, clicked5.TextDim)
        local scrollFrame = newInstance("ScrollingFrame", {
          Position = UDim2.fromOffset(0, 0),
          Size = UDim2.fromOffset(152, 0),
          BackgroundColor3 = Color3.fromRGB(29, 13, 33),
          BorderSizePixel = 0,
          Visible = false,
          ZIndex = 510,
          ScrollBarThickness = 3,
          ScrollBarImageColor3 = clicked5.AccentSoft,
          CanvasSize = UDim2.fromOffset(0, 0),
          ScrollingDirection = Enum.ScrollingDirection.Y,
          ClipsDescendants = true,
          Parent = card.Window.PopupLayer,
        })
        applyCorner(scrollFrame, 10)
        applyStroke(scrollFrame, clicked5.Stroke, 1, 0.15)
        newInstance("UIListLayout", {
          SortOrder = Enum.SortOrder.LayoutOrder,
          FillDirection = Enum.FillDirection.Vertical,
          VerticalAlignment = Enum.VerticalAlignment.Top,
          Parent = scrollFrame,
        })
        local list2 = {}
        local function renderDropdownValues()
          local list, value101, value102 = {}, clicked3, 1 / 0
          for index = 1, value102, 1 do
            local item = rawget(value101, index)
            if item == nil then
              break
            end
            index = list
            if index[tostring(item)] then
              table.insert(list, tostring(item))
            end
          end
          label.Text = #list > 0 and table.concat(list, ", ") or "None"
          if list2 then
            list2.Value = deepCopy(list)
          end
        end
        local function clearDropdownValues()
          local children = scrollFrame:GetChildren()
          for index = 1, 1 / 0, 1 do
            local item = rawget(children, index)
            if item == nil then
              break
            end
            if item:IsA("TextButton") then
              item:Destroy()
            end
          end
          local clicked, clicked2 = clicked3, 1 / 0
          for step = 1, clicked2, 1 do
            children = rawget(clicked, step)
            if children == nil then
              break
            end
            local text = tostring(children)
            local button = newInstance("TextButton", {
              LayoutOrder = step,
              Size = UDim2.new(1, 0, 0, 30),
              BackgroundTransparency = 1,
              Text = "",
              AutoButtonColor = false,
              ZIndex = 511,
              Parent = scrollFrame,
            })
            local label = newInstance("TextLabel", {
              Position = UDim2.fromOffset(8, 0),
              Size = UDim2.fromOffset(22, 30),
              BackgroundTransparency = 1,
              Text = list[text] and "\226\156\147" or "",
              TextColor3 = clicked5.AccentSoft,
              TextSize = 14,
              Font = Enum.Font.GothamBold,
              ZIndex = 512,
              Parent = button,
            })
            newInstance("TextLabel", {
              Position = UDim2.fromOffset(30, 0),
              Size = UDim2.new(1, -36, 1, 0),
              BackgroundTransparency = 1,
              Text = text,
              TextTruncate = Enum.TextTruncate.AtEnd,
              TextColor3 = clicked5.Text,
              TextSize = 12,
              Font = Enum.Font.Gotham,
              TextXAlignment = Enum.TextXAlignment.Left,
              ZIndex = 512,
              Parent = button,
            })
            button.MouseButton1Click:Connect(function()
              local value103 = list
              value103[text] = not value103[text]
              label.Text = list[text] and "\226\156\147" or ""
              renderDropdownValues()
              if clicked.Callback then
                task.spawn(clicked.Callback, deepCopy(list))
              end
              if list2._listeners then
                local value104, value105 = list2._listeners, 1 / 0
                for index = 1, value105, 1 do
                  value103 = rawget(value104, index)
                  if value103 == nil then
                    break
                  end
                  task.spawn(value103, deepCopy(list))
                end
              end
            end)
          end
          scrollFrame.Size = UDim2.fromOffset(152, math.min(#clicked3, 8) * 30)
          scrollFrame.CanvasSize = UDim2.fromOffset(0, #clicked3 * 30)
          scrollFrame.CanvasPosition = Vector2.new(0, 0)
        end
        list2.Set = function(self, values, silent)
          list = {}
          if type(values) == "table" then
            for key, value in next, values, nil do
              if type(key) == "number" then
                self = list
                self[tostring(value)] = true
              elseif value then
                local value106 = list
                value106[tostring(key)] = true
              end
            end
          end
          clearDropdownValues()
          renderDropdownValues()
          if clicked.Callback then
            if not silent then
              task.spawn(clicked.Callback, deepCopy(list))
            end
          end
        end
        list2.Get = function(self)
          self = list
          return deepCopy(self)
        end
        list2.SetValues = function(argument75, argument76)
          clicked3 = argument76 or {}
          argument75.Values = clicked3
          clearDropdownValues()
          renderDropdownValues()
        end
        createDropdownPopup(card.Window, pResult2, scrollFrame, list2, clicked4)
        clearDropdownValues()
        renderDropdownValues()
        pResult3.ValueObject = list2
        card.Window:_RegisterOption(card, clicked2, list2, "Dropdown", text, clicked.NoSave)
        list2.DisplayName = clicked2
        list2.Callback = clicked.Callback
        list2.Values = clicked3
        list2.Multi = true
        list2.Value = list2:Get()
        return list2
      end
      list.AddDropdown = function(card, text, default, callback, options)
        if
          type(default) == "table" and (default.Values ~= nil or default.Text ~= nil or default.Multi ~= nil)
        then
          if default.Multi then
            return createDropdownCore(card, text, default)
          end
          local value107, value108, value109 = default.Text or text, default.Values or {}, default.Default
          value109 = if type(value109) == "number" then value108[value109] else value109
          local fResult = value80(
            card,
            value107,
            value108,
            if value109 == nil then if default.AllowNull then value109 else value108[1] else value109,
            default.Callback
          )
          card.Window:_RegisterOption(card, value107, fResult, "Dropdown", text, default.NoSave)
          fResult.DisplayName = value107
          fResult.Callback = default.Callback
          fResult.Values = value108
          fResult.Multi = false
          fResult.AllowNull = default.AllowNull == true
          fResult.Value = fResult:Get()
          local value110 = fResult.SetValues
          fResult.SetValues = function(self, values)
            self.Values = values or {}
            value110(self, self.Values)
            if self.Value ~= nil then
              if not (table.find(self.Values, self.Value)) then
                self:Set(self.AllowNull and nil or self.Values[1], true)
              end
            end
            return self
          end
          fResult.SetDisabledValues = function(self, values)
            self.DisabledValues = values or {}
            return self
          end
          return fResult
        end
        local fResult = value80(
          card,
          text,
          default,
          if type(callback) == "number"
            then if type(default) == "table" then default[callback] else callback
            else callback,
          options
        )
        card.Window:_RegisterOption(card, text, fResult, "Dropdown", nil, false)
        fResult.DisplayName = text
        fResult.Callback = options
        fResult.Values = default or {}
        fResult.Multi = false
        fResult.Value = fResult:Get()
        return fResult
      end
      list.AddMultiDropdown = function(argument77, argument78, argument79)
        return createDropdownCore(argument77, argument78, argument79)
      end
      list.AddButton = function(clicked, clicked2, clicked3, clicked4)
        local clicked5, clicked6
        if type(clicked2) == "table" then
          clicked5, clicked6 = clicked2.Text or "Button", clicked2.Func or clicked2.Callback
        else
          if type(clicked3) == "function" and clicked4 == nil then
            clicked5, clicked6 = tostring(clicked2 or "Button"), clicked3
          else
            clicked5, clicked6 = tostring(clicked3 or clicked2 or "Button"), clicked4
          end
        end
        local jResult = value81(clicked, clicked5, clicked5, clicked6)
        return {
          Container = jResult,
          Button = jResult,
          _card = clicked,
          OnClick = function(self, callback)
            if type(callback) == "function" then
              jResult.MouseButton1Click:Connect(callback)
            end
            return self
          end,
          AddButton = function(self, text, callback)
            return self._card:AddButton(text, callback)
          end,
          SetDisabled = function(self, disabled)
            local value111 = not disabled
            jResult.Active = value111
            jResult.AutoButtonColor = value111
            jResult.TextTransparency = disabled and 0.45 or 0
            return self
          end,
        }
      end
      list.AddKeybind = function(card, text, default, callback, options)
        local value112
        if type(default) == "table" then
          value112 = default
        else
          local list = { Text = text, Default = default, Callback = callback, Mode = options }
          value112 = list
        end
        options = value112.Text or text
        local pResult, pResult2, pResult3 = createRowContainer(card, options, 36)
        pResult2.Size = UDim2.new(1, -186, 1, 0)
        local value113, wResult =
          card.Window.Theme, normalizeKeycode(value112.Default or Enum.KeyCode.RightShift)
        local value114 = value112.Modes or { "Toggle", "Hold", "Always" }
        local value115 = value112.Mode or value114[1] or "Toggle"
        local value116, enabled = value115 == "Always", false
        local button = newInstance("TextButton", {
          AnchorPoint = Vector2.new(1, 0.5),
          Position = UDim2.new(1, -72, 0.5, 0),
          Size = UDim2.fromOffset(92, 26),
          BackgroundColor3 = Color3.fromRGB(39, 20, 43),
          Text = inputToText(wResult),
          TextColor3 = value113.Text,
          TextSize = 12,
          Font = Enum.Font.Gotham,
          AutoButtonColor = false,
          Parent = pResult,
        })
        applyCorner(button, 11)
        applyStroke(button, value113.AccentSoft, 1, 0.42)
        attachGlow(button, value113.Accent, 4, 0.62)
        local button2 = newInstance("TextButton", {
          AnchorPoint = Vector2.new(1, 0.5),
          Position = UDim2.new(1, -10, 0.5, 0),
          Size = UDim2.fromOffset(52, 26),
          BackgroundColor3 = Color3.fromRGB(49, 25, 53),
          Text = value115,
          TextColor3 = value113.TextDim,
          TextSize = 10,
          Font = Enum.Font.GothamSemibold,
          AutoButtonColor = false,
          Parent = pResult,
        })
        applyAccentDecor(button2, value113, 9, 0.6)
        local list = { DisplayName = options }
        list.ShowInList = value112.NoUI ~= true
        list.Set = function(self, value, silent)
          if typeof(value) == "EnumItem" then
            if value ~= wResult then
              wResult = value
              button.Text = inputToText(value)
              if value115 ~= "Always" then
                self:SetActive(false, true)
              end
            end
          end
          self._window:_UpdateKeybindList()
        end
        list.Get = function(self)
          self = wResult
          return self
        end
        list.SetMode = function(self, mode, argument80)
          if not (table.find(value114, mode)) then
            return
          end
          value115 = mode
          button2.Text = mode
          self:SetActive(value115 == "Always", true)
          if not argument80 then
            if value112.ChangedCallback then
              task.spawn(value112.ChangedCallback, wResult, value115)
            end
          end
          self._window:_UpdateKeybindList()
        end
        list.GetMode = function(self)
          self = value115
          return self
        end
        list.IsActive = function(self)
          self = value116
          return self
        end
        list.SetActive = function(self, value, silent)
          local value117, value118 = value115 == "Always"
          if value117 then
            value118 = value117
          else
            local value119 = wResult
            value118 = value119 ~= Enum.KeyCode.Unknown and value == true
          end
          value116 = value118
          if not silent then
            if value112.Callback then
              task.spawn(value112.Callback, value116, wResult, value115)
            end
          end
          self._window:_UpdateKeybindList()
        end
        list._window = card.Window
        button.MouseButton1Click:Connect(function()
          enabled = true
          card.Window._keybindCapture = list
          button.Text = "..."
        end)
        button2.MouseButton1Click:Connect(function()
          local result = table.find(value114, value115) or 1
          list:SetMode(value114[result % #value114 + 1], false)
        end)
        table.insert(
          card.Window._connections,
          userInputService.InputBegan:Connect(function(input, input2)
            local input3 = card.Window._keybindCapture
            if enabled then
              if input3 == list then
                enabled = false
                task.defer(function()
                  if card.Window._keybindCapture == list then
                    card.Window._keybindCapture = nil
                  end
                end)
                if input.KeyCode == Enum.KeyCode.Escape then
                  button.Text = inputToText(wResult)
                  return
                end
                local input = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode
                  or input.UserInputType
                input = if input.KeyCode == Enum.KeyCode.Backspace then Enum.KeyCode.Unknown else input
                list:Set(input, false)
                button.Text = inputToText(wResult)
                return
              end
            end
            if input3 ~= nil then
              return
            elseif input2 then
              return
            elseif userInputService:GetFocusedTextBox() ~= nil then
              return
            else
              local value120 = wResult
              if value120 == Enum.KeyCode.Unknown then
                return
              elseif not (isKeyInput(input, wResult)) then
                return
              end
            end
            if value115 == "Toggle" then
              list:SetActive(not value116, false)
            elseif value115 == "Hold" then
              list:SetActive(true, false)
            elseif value115 == "Always" then
              if value112.Callback then
                task.spawn(value112.Callback, true, wResult, value115)
              end
            end
          end)
        )
        table.insert(
          card.Window._connections,
          userInputService.InputEnded:Connect(function(argument81)
            if value115 == "Hold" then
              if isKeyInput(argument81, wResult) then
                list:SetActive(false, false)
              end
            end
          end)
        )
        table.insert(
          card.Window._connections,
          userInputService.WindowFocusReleased:Connect(function()
            if value115 == "Hold" then
              list:SetActive(false, false)
            end
            if card.Window._keybindCapture == list then
              card.Window._keybindCapture = nil
            end
            enabled = false
            button.Text = inputToText(wResult)
          end)
        )
        pResult3.ValueObject = list
        card.Window:_RegisterOption(card, options, list, "Keybind", text, value112.NoSave)
        list.Callback = value112.Callback
        list.Mode = value115
        list.Modifiers = value112.Modifiers or {}
        list.Toggled = value116
        list.Value = inputToText(wResult)
        local input4 = list.Set
        list.Set = function(self, value, silent)
          if type(value) == "table" then
            local value121, value122, value123 =
              value[1] or value.Key, value[2] or value.Mode, value[3] or value.Modifiers
            if value121 ~= nil then
              input4(self, normalizeKeycode(value121), silent)
            end
            if value122 then
              if self.SetMode then
                self:SetMode(value122, silent)
              end
            end
            if type(value123) == "table" then
              self.Modifiers = value123
            end
          else
            input4(self, normalizeKeycode(value), silent)
          end
          self.Value = inputToText(self:Get())
          self.Mode = self:GetMode()
          self.Toggled = self:IsActive()
          return self
        end
        list.SetValue = list.Set
        local input5 = list.SetMode
        list.SetMode = function(self, mode, silent)
          input5(self, mode, silent)
          self.Mode = self:GetMode()
          self.Toggled = self:IsActive()
          return self
        end
        list.Update = function(self)
          if value115 == "Always" then
            value116 = true
          elseif self.Toggled ~= nil then
            local value124 = wResult
            value116 = value124 ~= Enum.KeyCode.Unknown and self.Toggled == true
          end
          self.Value = inputToText(self:Get())
          self.Mode = self:GetMode()
          self.Toggled = self:IsActive()
          self._window:_UpdateKeybindList()
          return self
        end
        local input6 = list.SetActive
        list.SetActive = function(self, value, silent)
          input6(self, value, silent)
          self.Toggled = self:IsActive()
          return self
        end
        list.GetState = function(self)
          return self:IsActive()
        end
        table.insert(card.Window.Keybinds, list)
        card.Window:_UpdateKeybindList()
        return list
      end
      list.AddKeyPicker = function(card, text, options)
        local addKeybindResult = card:AddKeybind(text, options or {})
        addKeybindResult.Type = "KeyPicker"
        addKeybindResult.Value = inputToText(addKeybindResult:Get())
        return addKeybindResult
      end
      list.AddColorPicker = function(card, text, options)
        local stroke = options or {}
        local value125 = stroke.Text or text
        local pResult, pResult2, pResult3 = createRowContainer(card, value125, 36)
        local value126 = card.Window.Theme
        local typeName = typeof(stroke.Default) == "Color3" and stroke.Default or value126.Accent
        local toHSVResult, toHSVResult2, toHSVResult3 = typeName:ToHSV()
        local button = newInstance("TextButton", {
          AnchorPoint = Vector2.new(1, 0.5),
          Position = UDim2.new(1, -12, 0.5, 0),
          Size = UDim2.fromOffset(66, 26),
          BackgroundColor3 = typeName,
          Text = colorToHex(typeName),
          TextColor3 = value126.White,
          TextStrokeTransparency = 0.4,
          TextSize = 10,
          Font = Enum.Font.GothamSemibold,
          AutoButtonColor = false,
          Parent = pResult,
        })
        applyCorner(button, 9)
        applyStroke(button, value126.StrokeSoft, 1, 0.3)
        attachGlow(button, value126.Accent, 4, 0.62)
        local frame = newInstance("Frame", {
          Position = UDim2.fromOffset(0, 0),
          Size = UDim2.fromOffset(200, 168),
          BackgroundColor3 = Color3.fromRGB(26, 13, 31),
          BorderSizePixel = 0,
          Visible = false,
          Active = true,
          ClipsDescendants = true,
          ZIndex = 520,
          Parent = card.Window.PopupLayer,
        })
        pcall(function()
          frame.InputSink = Enum.InputSink.All
        end)
        applyCorner(frame, 12)
        applyStroke(frame, value126.Stroke, 1, 0.15)
        applyPadding(frame, 10, 10, 10, 10)
        local button2 = newInstance("TextButton", {
          Size = UDim2.fromOffset(165, 128),
          BackgroundColor3 = Color3.fromHSV(toHSVResult, 1, 1),
          BorderSizePixel = 0,
          Text = "",
          AutoButtonColor = false,
          ZIndex = 521,
          Parent = frame,
        })
        applyCorner(button2, 7)
        pResult = newInstance("Frame", {
          Size = UDim2.fromScale(1, 1),
          BackgroundColor3 = Color3.new(1, 1, 1),
          BorderSizePixel = 0,
          ZIndex = 522,
          Parent = button2,
        })
        newInstance("UIGradient", {
          Color = ColorSequence.new(Color3.new(1, 1, 1)),
          Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1),
          }),
          Rotation = 0,
          Parent = pResult,
        })
        pResult = newInstance("Frame", {
          Size = UDim2.fromScale(1, 1),
          BackgroundColor3 = Color3.new(0, 0, 0),
          BorderSizePixel = 0,
          ZIndex = 523,
          Parent = button2,
        })
        newInstance("UIGradient", {
          Color = ColorSequence.new(Color3.new(0, 0, 0)),
          Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0),
          }),
          Rotation = 90,
          Parent = pResult,
        })
        local frame2 = newInstance("Frame", {
          AnchorPoint = Vector2.new(0.5, 0.5),
          Size = UDim2.fromOffset(10, 10),
          Position = UDim2.fromScale(toHSVResult2, 1 - toHSVResult3),
          BackgroundColor3 = Color3.new(1, 1, 1),
          BorderSizePixel = 0,
          ZIndex = 524,
          Parent = button2,
        })
        applyCorner(frame2, 99)
        applyStroke(frame2, Color3.new(0, 0, 0), 1, 0.15)
        local button3 = newInstance("TextButton", {
          AnchorPoint = Vector2.new(1, 0),
          Position = UDim2.new(1, 0, 0, 0),
          Size = UDim2.fromOffset(24, 128),
          BackgroundColor3 = Color3.new(1, 1, 1),
          BorderSizePixel = 0,
          Text = "",
          AutoButtonColor = false,
          ZIndex = 521,
          Parent = frame,
        })
        applyCorner(button3, 7)
        newInstance("UIGradient", {
          Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
            ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
            ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
            ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
            ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
          }),
          Rotation = 90,
          Parent = button3,
        })
        local frame3 = newInstance("Frame", {
          AnchorPoint = Vector2.new(0.5, 0.5),
          Position = UDim2.new(0.5, 0, toHSVResult, 0),
          Size = UDim2.new(1, 4, 0, 3),
          BackgroundColor3 = Color3.new(1, 1, 1),
          BorderSizePixel = 0,
          ZIndex = 524,
          Parent = button3,
        })
        local textBox = newInstance("TextBox", {
          Position = UDim2.new(0, 0, 1, -31),
          Size = UDim2.new(1, 0, 0, 28),
          BackgroundColor3 = Color3.fromRGB(39, 20, 43),
          Text = colorToHex(typeName),
          TextColor3 = value126.Text,
          TextSize = 12,
          Font = Enum.Font.Gotham,
          ClearTextOnFocus = false,
          ZIndex = 521,
          Parent = frame,
        })
        applyCorner(textBox, 8)
        applyStroke(textBox, value126.StrokeSoft, 1, 0.4)
        local list = {}
        local function applyPickerColor(accent)
          typeName = Color3.fromHSV(toHSVResult, toHSVResult2, toHSVResult3)
          button.BackgroundColor3 = typeName
          button.Text = colorToHex(typeName)
          textBox.Text = colorToHex(typeName)
          button2.BackgroundColor3 = Color3.fromHSV(toHSVResult, 1, 1)
          frame2.Position = UDim2.fromScale(toHSVResult2, 1 - toHSVResult3)
          frame3.Position = UDim2.new(0.5, 0, toHSVResult, 0)
          if list then
            list.Value = typeName
          end
          if stroke.Callback then
            if not accent then
              task.spawn(stroke.Callback, typeName)
            end
          end
          if (if accent then not accent else list) and list._listeners then
            local value127, value128 = list._listeners, 1 / 0
            for index = 1, value128, 1 do
              local item = rawget(value127, index)
              if item == nil then
                break
              end
              task.spawn(item, typeName)
            end
          end
        end
        list.Set = function(self, color, silent)
          if typeof(color) == "Color3" then
            toHSVResult, toHSVResult2, toHSVResult3 = color:ToHSV()
            applyPickerColor(silent)
          end
        end
        list.Get = function(self)
          self = typeName
          return self
        end
        local value129
        local value130 = card.Window
        local function pointInArea(element, position)
          local position2, position3 = element.AbsolutePosition, element.AbsoluteSize
          return position.X >= position2.X
            and position.X <= position2.X + position3.X
            and position.Y >= position2.Y
            and position.Y <= position2.Y + position3.Y
        end
        list.ContainsPoint = function(self, position)
          return pointInArea(button, position) or frame.Visible and pointInArea(frame, position)
        end
        list.Close = function(self)
          frame.Visible = false
          if value129 then
            value129:Disconnect()
            value129 = nil
          end
          if value130._OpenColorPicker == list then
            value130._OpenColorPicker = nil
          end
        end
        local function refreshPickerPopup()
          if button.Parent then
            if not value130.Gui.Enabled then
              list:Close()
              return
            end
          else
            list:Close()
            return
          end
          local element, input = button.AbsolutePosition + button.AbsoluteSize * 0.5, button
          while input and input ~= value130.Gui do
            if input:IsA("GuiObject") then
              if input.Visible then
                if input.ClipsDescendants then
                  if not (pointInArea(input, element)) then
                    list:Close()
                    return
                  end
                end
              else
                list:Close()
                return
              end
            end
            input = input.Parent
          end
          element = value130.PopupLayer
          local input2, input3 = element.AbsolutePosition, element.AbsoluteSize
          local input4, input5, input6, input7 =
            button.AbsolutePosition - input2,
            button.AbsoluteSize,
            math.min(200, math.max(1, input3.X - 16)),
            math.min(168, math.max(1, input3.Y - 16))
          input2, element =
            math.clamp(input4.X + input5.X - input6, 8, math.max(8, input3.X - input6 - 8)),
            input4.Y + input5.Y + 4
          element = if element + input7 > input3.Y - 8 then input4.Y - input7 - 4 else element
          element = math.clamp(element, 8, math.max(8, input3.Y - input7 - 8))
          frame.Size = UDim2.fromOffset(input6, input7)
          frame.Position = UDim2.fromOffset(input2, element)
        end
        button.Activated:Connect(function()
          if frame.Visible then
            list:Close()
            return
          end
          if value130._OpenDropdown then
            value130._OpenDropdown:Close()
          end
          if value130._OpenColorPicker then
            value130._OpenColorPicker:Close()
          end
          value130._OpenColorPicker = list
          frame.Visible = true
          refreshPickerPopup()
          if frame.Visible then
            value129 = runService.RenderStepped:Connect(refreshPickerPopup)
          end
        end)
        local enabled, enabled2 = false, false
        local function onColorAreaDrag(position)
          toHSVResult2 =
            math.clamp((position.X - button2.AbsolutePosition.X) / math.max(button2.AbsoluteSize.X, 1), 0, 1)
          toHSVResult3 = 1
            - math.clamp(
              (position.Y - button2.AbsolutePosition.Y) / math.max(button2.AbsoluteSize.Y, 1),
              0,
              1
            )
          applyPickerColor(false)
        end
        local function onHueBarDrag(position)
          toHSVResult =
            math.clamp((position.Y - button3.AbsolutePosition.Y) / math.max(button3.AbsoluteSize.Y, 1), 0, 1)
          applyPickerColor(false)
        end
        button2.InputBegan:Connect(function(input)
          if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
          then
            enabled = true
            onColorAreaDrag(input.Position)
          end
        end)
        button3.InputBegan:Connect(function(input)
          if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
          then
            enabled2 = true
            onHueBarDrag(input.Position)
          end
        end)
        table.insert(
          card.Window._connections,
          userInputService.InputChanged:Connect(function(input)
            local input2 = enabled
              and (
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
              )
            if input2 then
              onColorAreaDrag(input.Position)
            elseif enabled2 then
              if input.UserInputType == Enum.UserInputType.MouseMovement then
                onHueBarDrag(input.Position)
              elseif input.UserInputType == Enum.UserInputType.Touch then
                onHueBarDrag(input.Position)
              end
            end
          end)
        )
        table.insert(
          card.Window._connections,
          userInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
              enabled, enabled2 = false, false
            elseif input.UserInputType == Enum.UserInputType.Touch then
              enabled, enabled2 = false, false
            end
          end)
        )
        textBox.FocusLost:Connect(function()
          local xResult = normalizeHex(textBox.Text)
          toHSVResult, toHSVResult2, toHSVResult3 = xResult:ToHSV()
          applyPickerColor(false)
        end)
        pResult3.ValueObject = list
        card.Window:_RegisterOption(card, value125, list, "ColorPicker", text, stroke.NoSave)
        list.DisplayName = value125
        list.Callback = stroke.Callback
        list.Transparency = tonumber(stroke.Transparency) or 0
        applyPickerColor(true)
        list.Value = list:Get()
        list.SetValueRGB = function(prompt, color, transparency)
          if transparency ~= nil then
            prompt.Transparency = tonumber(transparency) or prompt.Transparency
          end
          return prompt:Set(color, false)
        end
        return list
      end
      list.AddLabel = function(card, text, color)
        local frame = newInstance("Frame", {
          Size = UDim2.new(1, 0, 0, 28),
          AutomaticSize = color and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
          BackgroundTransparency = 1,
          Parent = card.Body,
        })
        local label = newInstance("TextLabel", {
          Position = UDim2.fromOffset(10, 0),
          Size = color and UDim2.new(1, -20, 0, 24) or UDim2.new(1, -20, 1, 0),
          AutomaticSize = color and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
          BackgroundTransparency = 1,
          Text = tostring(text),
          TextWrapped = color == true,
          TextColor3 = card.Window.Theme.TextDim,
          TextSize = 12,
          Font = Enum.Font.Gotham,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextYAlignment = Enum.TextYAlignment.Center,
          Parent = frame,
        })
        return {
          Container = frame,
          Label = label,
          _card = card,
          _text = tostring(text),
          SetText = function(self, text)
            self._text = tostring(text)
            label.Text = self._text
            return self
          end,
          SetVisible = function(self, visible)
            frame.Visible = not not visible
            return self
          end,
          AddColorPicker = function(self, text, options)
            frame.Visible = false
            options = options or {}
            if options.Text == nil then
              options.Text = self._text
            end
            return self._card:AddColorPicker(text, options)
          end,
          AddKeyPicker = function(self, text, options)
            frame.Visible = false
            options = options or {}
            if options.Text == nil then
              options.Text = self._text
            end
            return self._card:AddKeyPicker(text, options)
          end,
        }
      end
      list.AddBlank = function(card, height, color)
        local frame = newInstance("Frame", {
          Size = UDim2.new(1, 0, 0, tonumber(height) or 6),
          BackgroundTransparency = 1,
          Visible = color ~= false,
          Parent = card.Body,
        })
        return {
          Container = frame,
          Visible = color ~= false,
          SetVisible = function(self, visible)
            self.Visible = not not visible
            frame.Visible = self.Visible
            return self
          end,
        }
      end
      list.AddDivider = function(card, color)
        local frame = newInstance(
          "Frame",
          { Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Parent = card.Body }
        )
        newInstance("Frame", {
          AnchorPoint = Vector2.new(0, 0.5),
          Position = UDim2.new(0, 12, 0.5, 0),
          Size = UDim2.new(1, -24, 0, 1),
          BackgroundColor3 = card.Window.Theme.StrokeSoft,
          BackgroundTransparency = 0.45,
          BorderSizePixel = 0,
          Parent = frame,
        })
        if color then
          applyCorner(
            newInstance("TextLabel", {
              Position = UDim2.fromOffset(18, 0),
              Size = UDim2.fromOffset(math.max(80, measureText(color, 11, Enum.Font.Gotham).X + 16), 28),
              BackgroundColor3 = card.Window.Theme.Card2,
              BackgroundTransparency = 0.02,
              Text = tostring(color),
              TextColor3 = card.Window.Theme.TextMute,
              TextSize = 11,
              Font = Enum.Font.GothamSemibold,
              Parent = frame,
            }),
            8
          )
        end
        return frame
      end
      local list = {}
      list.__index = list
      list._RefreshSize = function(self)
        if self._sizeRefreshQueued then
          return
        end
        self._sizeRefreshQueued = true
        task.defer(function()
          self._sizeRefreshQueued = false
          local value131 = self.Active
          if self.Host.Parent then
            if not value131 then
              return
            end
          else
            return
          end
          local value132 = value131.Layout.AbsoluteContentSize.Y
          value131.Body.Size = UDim2.new(1, 0, 0, value132)
          self.Pages.Size = UDim2.new(1, 0, 0, value132)
          self.Host.Size = UDim2.new(1, 0, 0, 38 + value132)
        end)
      end
      list.AddTabbox = function(card, title)
        local frame = newInstance("Frame", {
          Name = title or "Tabbox",
          Size = UDim2.new(1, 0, 0, 120),
          BackgroundColor3 = card.Window.Theme.Card2,
          BackgroundTransparency = 0.25,
          BorderSizePixel = 0,
          ClipsDescendants = true,
          Parent = card.Body,
        })
        applyCorner(frame, 12)
        applyStroke(frame, card.Window.Theme.StrokeSoft, 1, 0.4)
        title =
          newInstance("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Parent = frame })
        local frame2 = newInstance("Frame", {
          Position = UDim2.fromOffset(7, 3),
          Size = UDim2.new(1, -14, 0, 24),
          BackgroundTransparency = 1,
          Parent = title,
        })
        newInstance("UIListLayout", {
          FillDirection = Enum.FillDirection.Horizontal,
          Padding = UDim.new(0, 5),
          SortOrder = Enum.SortOrder.LayoutOrder,
          Parent = frame2,
        })
        title = newInstance(
          "Frame",
          {
            Position = UDim2.fromOffset(0, 30),
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            Parent = frame,
          }
        )
        return (
          setmetatable(
            {
              Card = card,
              Window = card.Window,
              Host = frame,
              Buttons = frame2,
              Pages = title,
              Tabs = {},
              Active = nil,
            },
            list
          )
        )
      end
      list.AddTab = function(tabbox, name)
        local button = newInstance("TextButton", {
          Size = UDim2.fromOffset(math.max(68, measureText(name, 11, Enum.Font.Gotham).X + 20), 24),
          BackgroundColor3 = tabbox.Window.Theme.Row,
          BackgroundTransparency = 0.5,
          Text = name,
          TextColor3 = tabbox.Window.Theme.TextDim,
          TextSize = 11,
          Font = Enum.Font.GothamSemibold,
          AutoButtonColor = false,
          Parent = tabbox.Buttons,
        })
        applyCorner(button, 8)
        local sResult = attachGlow(button, tabbox.Window.Theme.Accent, 4, 0.66)
        local frame = newInstance(
          "Frame",
          {
            Name = name,
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = tabbox.Pages,
          }
        )
        local clicked, clicked2 =
          newInstance("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = frame }),
          setmetatable(
            {
              Tab = tabbox.Card.Tab,
              Window = tabbox.Window,
              Title = (tabbox.Card.Title or "Card") .. "/" .. name,
              Body = frame,
              Elements = {},
            },
            list
          )
        local list = { Button = button, Body = frame, Layout = clicked, Proxy = clicked2, Glow = sResult }
        table.insert(tabbox.Tabs, list)
        local function updateActiveTab()
          if tabbox.Active then
            tabbox.Active.Body.Visible = false
            tabbox.Active.Button.BackgroundTransparency = 0.5
            tabbox.Active.Button.TextColor3 = tabbox.Window.Theme.TextDim
            tabbox.Active.Glow.Transparency = 0.66
          end
          tabbox.Active = list
          frame.Visible = true
          button.BackgroundTransparency = 0.05
          button.TextColor3 = tabbox.Window.Theme.Text
          sResult.Transparency = 0.34
          tabbox:_RefreshSize()
        end
        button.MouseButton1Click:Connect(updateActiveTab)
        local function onTabResize()
          if tabbox.Active == list then
            tabbox:_RefreshSize()
          end
        end
        clicked:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(onTabResize)
        if not tabbox.Active then
          updateActiveTab()
        end
        return clicked2
      end
      list.AddDependencyBox = function(card, name)
        local frame = newInstance("Frame", {
          Name = name or "DependencyBox",
          Size = UDim2.new(1, 0, 0, 0),
          AutomaticSize = Enum.AutomaticSize.Y,
          BackgroundTransparency = 1,
          Parent = card.Body,
        })
        local frame2 = newInstance("Frame", {
          Size = UDim2.new(1, 0, 0, 0),
          AutomaticSize = Enum.AutomaticSize.Y,
          BackgroundTransparency = 1,
          Parent = frame,
        })
        newInstance("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = frame2 })
        local object = setmetatable({
          Tab = card.Tab,
          Window = card.Window,
          Title = (card.Title or "Card") .. "/" .. (name or "Dependency"),
          Body = frame2,
          Elements = {},
          Dependencies = {},
        }, list)
        object.AddDependency = function(self, option, expected)
          table.insert(self.Dependencies, { option, expected })
          local function refreshDependencies()
            local value133, enabled = self.Dependencies, true
            for index = 1, 1 / 0, 1 do
              local item = rawget(value133, index)
              if item == nil then
                break
              end
              index = if item[1] then item[1].Get and item[1]:Get() or item[1].Value else nil
              enabled = if type(item[2]) == "function"
                then enabled and item[2](index)
                else enabled and index == item[2]
            end
            frame.Visible = enabled
          end
          if option then
            if option.OnChanged then
              option:OnChanged(refreshDependencies)
            end
          end
          refreshDependencies()
          return self
        end
        object.SetupDependencies = function(self, dependencies)
          self.Dependencies = {}
          local value134 = dependencies or {}
          for index = 1, 1 / 0, 1 do
            dependencies = rawget(value134, index)
            if dependencies == nil then
              break
            end
            local value135, value136 = dependencies[1], dependencies[2]
            table.insert(self.Dependencies, { value135, value136 })
            if value135 then
              if value135.OnChanged then
                value135:OnChanged(function()
                  self:RefreshDependencies()
                end)
              end
            end
          end
          self:RefreshDependencies()
          return self
        end
        object.RefreshDependencies = function(self)
          local value137, enabled = self.Dependencies or {}, true
          for index = 1, 1 / 0, 1 do
            self = rawget(value137, index)
            if self == nil then
              break
            end
            index = self[1] and (self[1].Get and self[1]:Get() or self[1].Value)
            enabled = if type(self[2]) == "function"
              then enabled and self[2](index)
              else enabled and index == self[2]
          end
          frame.Visible = enabled
        end
        return object
      end
      list.AddViewport = function(card, name, options)
        options = options or {}
        local number = tonumber(options.Height) or 220
        local frame = newInstance("Frame", {
          Name = tostring(name or "Viewport"),
          Size = UDim2.new(1, 0, 0, number + 10),
          BackgroundTransparency = 1,
          Parent = card.Body,
        })
        local viewport = newInstance("ViewportFrame", {
          Position = UDim2.fromOffset(10, 5),
          Size = UDim2.new(1, -20, 0, number),
          BackgroundColor3 = Color3.fromRGB(10, 8, 15),
          BackgroundTransparency = 0.08,
          BorderSizePixel = 0,
          Ambient = Color3.fromRGB(180, 160, 190),
          LightColor = Color3.new(1, 1, 1),
          LightDirection = Vector3.new(-1, -1, -1),
          Parent = frame,
        })
        applyCorner(viewport, 14)
        applyStroke(viewport, card.Window.Theme.StrokeSoft, 1, 0.38)
        local camera = options.Camera or Instance.new("Camera")
        camera.Parent = viewport
        viewport.CurrentCamera = camera
        local value138 = options.Object
        if value138 and options.Clone then
          local clone, clone2 = pcall(function()
            return value138:Clone()
          end)
          if clone then
            value138 = clone2
          else
          end
        else
        end
        if value138 then
          value138.Parent = viewport
        end
        local list = {
          Type = "Viewport",
          Object = value138,
          Camera = camera,
          Holder = frame,
          Container = viewport,
          Height = number,
          Visible = options.Visible ~= false,
        }
        frame.Visible = list.Visible
        list.SetObject = function(self, object, size)
          if self.Object then
            if self.Object.Parent == viewport then
              pcall(function()
                self.Object:Destroy()
              end)
            end
          end
          if object and size then
            local clone, clone2 = pcall(function()
              return object:Clone()
            end)
            if clone then
              object = clone2
            else
            end
          else
          end
          self.Object = object
          if object then
            object.Parent = viewport
          end
          return self
        end
        list.SetHeight = function(self, height)
          self.Height = math.max(40, tonumber(height) or self.Height)
          frame.Size = UDim2.new(1, 0, 0, self.Height + 10)
          viewport.Size = UDim2.new(1, -20, 0, self.Height)
          if self._card then
            if self._card.Resize then
              self._card:Resize()
            end
          end
          return self
        end
        list.SetVisible = function(self, visible)
          self.Visible = not not visible
          frame.Visible = self.Visible
          return self
        end
        list._card = card
        card.Window.Options[name] = list
        return list
      end
      list2.AddDialog = function(window, title, options)
        local clicked = options or {}
        local button = newInstance("TextButton", {
          Name = "DialogOverlay_" .. tostring(title),
          Size = UDim2.fromScale(1, 1),
          BackgroundTransparency = 1,
          Text = "",
          AutoButtonColor = false,
          ZIndex = 400,
          Parent = window.Gui,
        })
        local frame = newInstance("Frame", {
          AnchorPoint = Vector2.new(0.5, 0.5),
          Position = UDim2.fromScale(0.5, 0.5),
          Size = UDim2.fromOffset(480, 0),
          AutomaticSize = Enum.AutomaticSize.Y,
          BackgroundColor3 = window.Theme.Card2,
          BackgroundTransparency = 0.03,
          BorderSizePixel = 0,
          ClipsDescendants = true,
          ZIndex = 401,
          Parent = button,
        })
        applyCorner(frame, 14)
        applyStroke(frame, window.Theme.AccentSoft, 1, 0.24)
        attachGlow(frame, window.Theme.Accent, 6, 0.88)
        newInstance("TextLabel", {
          Position = UDim2.fromOffset(16, 12),
          Size = UDim2.new(1, -32, 0, 28),
          BackgroundTransparency = 1,
          Text = tostring(clicked.Title or "Dialog"),
          TextColor3 = window.Theme.Text,
          TextSize = 18,
          Font = Enum.Font.GothamMedium,
          TextXAlignment = Enum.TextXAlignment.Left,
          ZIndex = 402,
          Parent = frame,
        })
        local label = newInstance("TextLabel", {
          Position = UDim2.fromOffset(16, 40),
          Size = UDim2.new(1, -32, 0, 0),
          AutomaticSize = Enum.AutomaticSize.Y,
          BackgroundTransparency = 1,
          Text = tostring(clicked.Description or ""),
          TextWrapped = true,
          TextColor3 = window.Theme.TextDim,
          TextSize = 12,
          Font = Enum.Font.Gotham,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextYAlignment = Enum.TextYAlignment.Top,
          ZIndex = 402,
          Parent = frame,
        })
        local frame2 = newInstance("Frame", {
          Position = UDim2.fromOffset(12, 70),
          Size = UDim2.new(1, -24, 0, 0),
          AutomaticSize = Enum.AutomaticSize.Y,
          BackgroundTransparency = 1,
          ZIndex = 402,
          Parent = frame,
        })
        local listLayout =
          newInstance("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = frame2 })
        local frame3 = newInstance("Frame", {
          Size = UDim2.new(1, -24, 0, 40),
          Position = UDim2.new(0, 12, 1, 0),
          AutomaticSize = Enum.AutomaticSize.Y,
          BackgroundTransparency = 1,
          ZIndex = 402,
          Parent = frame,
        })
        newInstance("UIListLayout", {
          FillDirection = Enum.FillDirection.Horizontal,
          HorizontalAlignment = Enum.HorizontalAlignment.Right,
          Padding = UDim.new(0, 6),
          SortOrder = Enum.SortOrder.LayoutOrder,
          Parent = frame3,
        })
        local object = setmetatable({
          Window = window,
          Tab = nil,
          Title = tostring(clicked.Title or "Dialog"),
          Body = frame2,
          BodyList = listLayout,
          Elements = {},
          Overlay = button,
          Frame = frame,
          Footer = frame3,
          FooterButtons = {},
        }, list)
        object.Resize = function(unused)
          unused = listLayout.AbsoluteContentSize.Y
          frame2.Size = UDim2.new(1, -24, 0, unused)
          local bound = math.max(20, label.AbsoluteTextSize.Y)
          frame2.Position = UDim2.fromOffset(12, 48 + bound + 10)
          frame3.Position = UDim2.fromOffset(12, 48 + bound + 10 + unused + 8)
          frame.Size = UDim2.fromOffset(480, 48 + bound + 10 + unused + 8 + 40 + 12)
        end
        object.Dismiss = function(unused)
          if button then
            if button.Parent then
              button:Destroy()
            end
          end
          if library.Dialogues then
            library.Dialogues[title] = nil
          end
        end
        object.RemoveFooterButton = function(self, name)
          local value139 = self.FooterButtons[name]
          if value139 then
            if value139.Container then
              value139.Container:Destroy()
            end
          end
          self.FooterButtons[name] = nil
        end
        object.AddFooterButton = function(self, name, options)
          local clicked = options or {}
          self:RemoveFooterButton(name)
          local button = newInstance("TextButton", {
            Size = UDim2.fromOffset(
              math.max(84, measureText(clicked.Title or name, 12, Enum.Font.Gotham).X + 24),
              28
            ),
            BackgroundColor3 = clicked.Variant == "Destructive" and Color3.fromRGB(102, 35, 48)
              or Color3.fromRGB(69, 35, 67),
            Text = tostring(clicked.Title or name),
            TextColor3 = self.Window.Theme.Text,
            TextSize = 12,
            Font = Enum.Font.GothamMedium,
            AutoButtonColor = false,
            ZIndex = 403,
            LayoutOrder = tonumber(clicked.Order) or 0,
            Parent = frame3,
          })
          applyCorner(button, 9)
          applyStroke(
            button,
            clicked.Variant == "Destructive" and Color3.fromRGB(255, 105, 120) or self.Window.Theme.AccentSoft,
            1,
            0.34
          )
          local function onFooterButtonClick()
            if clicked.Callback then
              task.spawn(clicked.Callback, self)
            end
            if clicked.AutoDismiss ~= false then
              if clicked.AutoDismiss ~= false then
                self:Dismiss()
              end
            end
          end
          button.MouseButton1Click:Connect(onFooterButtonClick)
          onFooterButtonClick = { Container = button }
          self.FooterButtons[name] = onFooterButtonClick
          return onFooterButtonClick
        end
        local function onDialogContentResized()
          task.defer(function()
            if button.Parent then
              object:Resize()
            end
          end)
        end
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(onDialogContentResized)
        if clicked.OutsideClickDismiss ~= false then
          local function onDialogDismissClick()
            object:Dismiss()
          end
          button.MouseButton1Click:Connect(onDialogDismissClick)
        end
        for key, value in next, clicked.FooterButtons or {}, nil do
          object:AddFooterButton(key, value)
        end
        task.defer(function()
          if button.Parent then
            object:Resize()
          end
        end)
        library.Dialogues = library.Dialogues or {}
        library.Dialogues[title] = object
        return object
      end
      local list = {}
      list.__index = list
      list.new = function(window)
        return setmetatable(
          { Window = window, Folder = "LunarUI/configs", AutoloadFile = "LunarUI/configs/autoload.txt" },
          list
        )
      end
      list.SetFolder = function(self, folder)
        self.Folder = folder or self.Folder
        self.AutoloadFile = self.Folder .. "/autoload.txt"
        return self
      end
      list._ready = function(self)
        return ensureFolder(self.Folder) and type(writefile) == "function" and type(readfile) == "function"
      end
      list.Save = function(self, name)
        name = tostring(name or "default"):gsub("[^%w_%- ]", "_")
        if name == "" then
          return false, "File APIs unavailable"
        elseif not (self:_ready()) then
          return false, "File APIs unavailable"
        end
        local list = { version = 2, options = {} }
        for key, value in next, self.Window.Toggles or {}, nil do
          if not value.NoSave then
            if value.Serialize then
              list.options[key] = value:Serialize()
            end
          end
        end
        for extra, extra2 in next, self.Window.Options or {}, nil do
          if not extra2.NoSave then
            if extra2.Serialize then
              list.options[extra] = extra2:Serialize()
            end
          end
        end
        local ok, ok2 = pcall(writefile, self.Folder .. "/" .. name .. ".json", httpService:JSONEncode(list))
        return ok, ok2
      end
      list.Load = function(self, name)
        if not (self:_ready()) then
          return false, "File APIs unavailable"
        end
        local value140 = self.Folder .. "/" .. tostring(name) .. ".json"
        if type(isfile) == "function" then
          if not (isfile(value140)) then
            return false, "Config not found"
          end
        end
        local ok, ok2 = pcall(function()
          local value141 = module[23](readfile(value140))
          return httpService:JSONDecode(module:bD(value141))
        end)
        if ok then
          if type(ok2) ~= "table" then
            return false, ok2
          end
        else
          return false, ok2
        end
        if state.migrate_you_spoofer_config then
          state.migrate_you_spoofer_config(ok2)
        end
        for key, value in next, ok2.options or {}, nil do
          local value142 = self.Window.Toggles[key] or self.Window.Options[key]
          if value142 and value142.Deserialize then
            pcall(function()
              value142:Deserialize(value)
            end)
          end
        end
        return true
      end
      list.Delete = function(self, name)
        if type(delfile) ~= "function" then
          return false, "Delete API unavailable"
        end
        local value143 = self.Folder .. "/" .. tostring(name) .. ".json"
        self, name = pcall(delfile, value143)
        return self, name
      end
      list.List = function(self)
        local list = {}
        if type(listfiles) ~= "function" then
          return list
        elseif not (ensureFolder(self.Folder)) then
          return list
        end
        local ok, ok2 = pcall(listfiles, self.Folder)
        if not ok then
          return list
        end
        for index = 1, 1 / 0, 1 do
          self = rawget(ok2, index)
          if self == nil then
            break
          end
          index = tostring(self):match("([^/\\]+)%.json$")
          if index then
            table.insert(list, index)
          end
        end
        table.sort(list)
        return list
      end
      list.SetAutoload = function(self, name)
        if not (self:_ready()) then
          return false
        end
        return pcall(writefile, self.AutoloadFile, tostring(name or ""))
      end
      list.ClearAutoload = function(self)
        if not (self:_ready()) then
          return false
        end
        return pcall(writefile, self.AutoloadFile, "")
      end
      list.GetAutoload = function(self)
        if type(readfile) ~= "function" then
          return nil
        elseif type(isfile) ~= "function" then
          return nil
        elseif not (isfile(self.AutoloadFile)) then
          return nil
        end
        local ok, ok2 = pcall(readfile, self.AutoloadFile)
        return ok and ok2 or nil
      end
      list.LoadAutoload = function(self)
        local getAutoloadResult = self:GetAutoload()
        if getAutoloadResult then
          if getAutoloadResult == "" then
            return false
          end
        else
          return false
        end
        return self:Load(getAutoloadResult)
      end
      local list2 = {}
      list2.__index = list2
      list2.new = function(window)
        return setmetatable({ Window = window, Folder = "LunarUI/themes" }, list2)
      end
      list2.SetFolder = function(self, folder)
        self.Folder = folder or self.Folder
        return self
      end
      list2.Apply = function(self, preset)
        return self.Window:ApplyThemePreset(preset)
      end
      list2.Save = function(self, name)
        if type(writefile) ~= "function" then
          return false, "File APIs unavailable"
        elseif not (ensureFolder(self.Folder)) then
          return false, "File APIs unavailable"
        end
        name = tostring(name or "theme"):gsub("[^%w_%- ]", "_")
        local list = {}
        for key, value in next, self.Window.Theme, nil do
          if typeof(value) == "Color3" then
            list[key] = colorToHex(value)
          end
        end
        local ok, ok2 = pcall(writefile, self.Folder .. "/" .. name .. ".json", httpService:JSONEncode(list))
        return ok, ok2
      end
      list2.Load = function(self, name)
        if type(readfile) ~= "function" then
          return false, "File APIs unavailable"
        end
        local value144 = self.Folder .. "/" .. tostring(name) .. ".json"
        if type(isfile) == "function" then
          if not (isfile(value144)) then
            return false, "Theme not found"
          end
        end
        local ok, ok2 = pcall(function()
          local value145 = module[23](readfile(value144))
          return httpService:JSONDecode(module:bD(value145))
        end)
        if ok then
          if type(ok2) ~= "table" then
            return false, ok2
          end
        else
          return false, ok2
        end
        ok = {}
        for key, value in next, ok2, nil do
          if type(value) == "string" then
            ok[key] = normalizeHex(value)
          end
        end
        self.Window:SetTheme(ok, name)
        return true
      end
      list2.Delete = function(self, name)
        if type(delfile) ~= "function" then
          return false, "Delete API unavailable"
        end
        return pcall(delfile, self.Folder .. "/" .. tostring(name) .. ".json")
      end
      list2.List = function(self)
        local list = {}
        if type(listfiles) ~= "function" then
          return list
        elseif not (ensureFolder(self.Folder)) then
          return list
        end
        local ok, ok2 = pcall(listfiles, self.Folder)
        if not ok then
          return list
        end
        for index = 1, 1 / 0, 1 do
          ok = rawget(ok2, index)
          if ok == nil then
            break
          end
          index = tostring(ok):match("([^/\\]+)%.json$")
          if index then
            table.insert(list, index)
          end
        end
        table.sort(list)
        return list
      end
      library.SaveManager = list
      library.ThemeManager = list2
      list2.AddSettingsTab = function(window)
        if window.SettingsTab then
          return window.SettingsTab
        end
        window.SaveManager = window.SaveManager or list.new(window)
        window.ThemeManager = window.ThemeManager or list2.new(window)
        local addTabResult = window:AddTab("Settings", "settings")
        window.SettingsTab = addTabResult
        if addTabResult.NavButton then
          addTabResult.NavButton.Visible = false
        end
        if window.SettingsButton then
          local clicked, handler =
            window.SettingsButton, function()
              window:_SelectTab(addTabResult)
            end
          clicked.MouseButton1Click:Connect(handler)
        end
        local addCardResult =
          addTabResult:AddCard("Menu \194\183 Controls", "Window behavior and keybinds", "Left")
        local addKeybindResult = addCardResult:AddKeybind(
          "MenuKeybind",
          {
            Text = "Menu Keybind",
            Default = window.MenuKeybind,
            Mode = "Toggle",
            NoUI = true,
            NoSave = false,
          }
        )
        addKeybindResult.ShowInList = false
        addKeybindResult:OnChanged(function(argument82)
          window:SetToggleKeybind(argument82)
        end)
        addCardResult:AddToggle("ShowKeybindList", {
          Text = "Keybind List",
          Default = false,
          Callback = function(argument83)
            window:SetKeybindListVisible(argument83)
          end,
        })
        addCardResult:AddToggle("ShowWatermark", {
          Text = "Watermark",
          Default = false,
          Callback = function(argument84)
            window:SetWatermarkVisible(argument84)
          end,
        })
        addCardResult:AddToggle("Notifications", {
          Text = "Notifications",
          Default = true,
          Callback = function(argument85)
            window.NotificationsEnabled = argument85
          end,
        })
        addCardResult:AddToggle("BlurOnOpen", {
          Text = "Blur when menu opens",
          Default = window.BlurEnabled,
          Callback = function(argument86)
            window:SetBlurEnabled(argument86)
          end,
        })
        addCardResult:AddButton("Test Notification", "Show", function()
          window:Notify("Lunar notification preview", 3, "Success")
        end)
        addCardResult:AddLabel("Drag from the top bar. Resize from the bottom-right corner.", true)
        addKeybindResult, addCardResult =
          addTabResult:AddCard("Theme Manager", "Presets, colors and saved themes", "Right"), {}
        for key in next, library.ThemePresets, nil do
          table.insert(addCardResult, key)
        end
        table.sort(addCardResult)
        addKeybindResult:AddDropdown("ThemePreset", {
          Text = "Preset",
          Values = addCardResult,
          Default = window.ThemeName,
          Callback = function(argument87)
            window.ThemeManager:Apply(argument87)
          end,
        })
        addKeybindResult:AddColorPicker("ThemeAccent", {
          Text = "Accent",
          Default = window.Theme.Accent,
          NoSave = true,
          Callback = function(argument88)
            window:SetTheme({
              Accent = argument88,
              Accent2 = argument88:Lerp(Color3.new(0, 0, 0), 0.2),
              AccentSoft = argument88:Lerp(Color3.new(1, 1, 1), 0.35),
            })
          end,
        })
        addKeybindResult:AddColorPicker("ThemeWindow", {
          Text = "Window",
          Default = window.Theme.Window,
          NoSave = true,
          Callback = function(argument89)
            window:SetTheme({
              Window = argument89,
              Window2 = argument89:Lerp(Color3.new(1, 1, 1), 0.05),
              Sidebar = argument89:Lerp(Color3.new(0, 0, 0), 0.1),
              Topbar = argument89:Lerp(Color3.new(1, 1, 1), 0.08),
            })
          end,
        })
        addKeybindResult:AddColorPicker("ThemeText", {
          Text = "Text",
          Default = window.Theme.Text,
          NoSave = true,
          Callback = function(argument90)
            window:SetTheme({ Text = argument90 })
          end,
        })
        local addTextboxResult = addKeybindResult:AddTextbox(
          "ThemeName",
          { Text = "Theme Name", Default = "My Theme", Placeholder = "Theme name", NoSave = true }
        )
        addKeybindResult:AddButton("Save Theme", "Save", function()
          local currentValue, currentValue2 = window.ThemeManager:Save(addTextboxResult:Get())
          window:Notify(
            currentValue and "Theme saved" or tostring(currentValue2),
            3,
            currentValue and "Success" or "Error"
          )
        end)
        local addDropdownResult = addKeybindResult:AddDropdown(
          "SavedTheme",
          { Text = "Saved Themes", Values = window.ThemeManager:List(), Default = "", NoSave = true }
        )
        addKeybindResult:AddButton("Refresh Themes", "Refresh", function()
          addDropdownResult:SetValues(window.ThemeManager:List())
        end)
        addKeybindResult:AddButton("Load Theme", "Load", function()
          local currentValue, currentValue2 = window.ThemeManager:Load(addDropdownResult:Get())
          window:Notify(
            currentValue and "Theme loaded" or tostring(currentValue2),
            3,
            currentValue and "Success" or "Error"
          )
        end)
        addKeybindResult:AddButton("Delete Theme", "Delete", function()
          local currentValue, currentValue2 = window.ThemeManager:Delete(addDropdownResult:Get())
          addDropdownResult:SetValues(window.ThemeManager:List())
          window:Notify(
            currentValue and "Theme deleted" or tostring(currentValue2),
            3,
            currentValue and "Success" or "Error"
          )
        end)
        addKeybindResult = addTabResult:AddCard("Save Manager", "Profiles and autoload", "Left")
        local addTextboxResult2 = addKeybindResult:AddTextbox(
          "ConfigName",
          { Text = "Config Name", Default = "default", Placeholder = "config name", NoSave = true }
        )
        local addDropdownResult2 = addKeybindResult:AddDropdown(
          "ConfigList",
          { Text = "Saved Configs", Values = window.SaveManager:List(), Default = "", NoSave = true }
        )
        addKeybindResult:AddButton("Create Config", "Create", function()
          local currentValue = addTextboxResult2:Get()
          local value146, value147 = window.SaveManager:Save(currentValue)
          addDropdownResult2:SetValues(window.SaveManager:List())
          if value146 then
            addDropdownResult2:Set(currentValue, true)
          end
          window:Notify(
            value146 and "Config created" or tostring(value147),
            3,
            value146 and "Success" or "Error"
          )
        end)
        addKeybindResult:AddButton("Save Config", "Save", function()
          local currentValue = addDropdownResult2:Get()
          currentValue = if currentValue
            then if currentValue == "" then (addTextboxResult2:Get()) else currentValue
            else (addTextboxResult2:Get())
          local value148, value149 = window.SaveManager:Save(currentValue)
          addDropdownResult2:SetValues(window.SaveManager:List())
          window:Notify(
            value148 and "Config saved" or tostring(value149),
            3,
            value148 and "Success" or "Error"
          )
        end)
        addKeybindResult:AddButton("Load Config", "Load", function()
          local currentValue, currentValue2 = window.SaveManager:Load(addDropdownResult2:Get())
          window:Notify(
            currentValue and "Config loaded" or tostring(currentValue2),
            3,
            currentValue and "Success" or "Error"
          )
        end)
        addKeybindResult:AddButton("Delete Config", "Delete", function()
          local currentValue, currentValue2 = window.SaveManager:Delete(addDropdownResult2:Get())
          addDropdownResult2:SetValues(window.SaveManager:List())
          window:Notify(
            currentValue and "Config deleted" or tostring(currentValue2),
            3,
            currentValue and "Success" or "Error"
          )
        end)
        addKeybindResult:AddButton("Refresh Configs", "Refresh", function()
          addDropdownResult2:SetValues(window.SaveManager:List())
        end)
        addCardResult = window.SaveManager:GetAutoload()
        local input
        input = addKeybindResult:AddToggle("AutoloadSelected", {
          Text = "Autoload selected config",
          Default = addCardResult ~= nil and addCardResult ~= "",
          NoSave = true,
          Callback = function(input)
            local input2
            if input then
              local currentValue = addDropdownResult2:Get()
              if if currentValue then currentValue == "" else not currentValue then
                window:Notify("Select a config first", 3, "Error")
                task.defer(function()
                  input:Set(false, true)
                end)
                return
              end
              input2 = window.SaveManager:SetAutoload(currentValue)
            else
              input2 = window.SaveManager:ClearAutoload()
            end
            window:Notify(
              input2 and (input and "Autoload enabled" or "Autoload disabled") or "Could not change autoload",
              3,
              input2 and "Success" or "Error"
            )
          end,
        })
        addKeybindResult:AddLabel("Autoload: " .. tostring(addCardResult or "none"), true)
        addCardResult =
          addTabResult:AddCard("Library \194\183 Extras", "Linoria-style convenience features", "Right")
        addCardResult:AddToggle(
          "ExampleToggle",
          { Text = "Dependency Example", Default = false, NoSave = true }
        )
        addKeybindResult = addCardResult:AddDependencyBox("Dependency")
        addKeybindResult:AddLabel("This content only appears while the dependency toggle is enabled.", true)
        addKeybindResult:AddDependency(window.Options.ExampleToggle, true)
        addKeybindResult = addCardResult:AddTabbox("Mini Tabs")
        addCardResult = addKeybindResult:AddTab("General")
        addCardResult:AddLabel("Nested tabboxes are supported.", true)
        addCardResult:AddSlider(
          "MiniSlider",
          { Text = "Example Slider", Min = 0, Max = 100, Default = 50, Rounding = 0, NoSave = true }
        )
        addKeybindResult
          :AddTab("Colors")
          :AddColorPicker(
            "MiniColor",
            { Text = "Example Color", Default = window.Theme.Accent, NoSave = true }
          )
        return addTabResult
      end
      list.AddESPPreview = function(window, _, subtitle, side)
        local addCardResult, element =
          window:AddCard(_ or "ESP Preview", subtitle or "Live preview", side or "Left"), window.Window.Theme
        side = newInstance("Frame", {
          Name = "ESPPreviewCanvas",
          Size = UDim2.new(1, 0, 0, 340),
          BackgroundColor3 = Color3.fromRGB(13, 8, 18),
          BackgroundTransparency = 0.04,
          BorderSizePixel = 0,
          Parent = addCardResult.Body,
        })
        subtitle = setmetatable(
          {
            Container = side,
            SearchText = "esp preview box skeleton tracer name health distance",
            Card = addCardResult,
          },
          list
        )
        table.insert(addCardResult.Elements, subtitle)
        table.insert(addCardResult.Window.Elements, subtitle)
        local frame = newInstance("Frame", {
          Position = UDim2.fromOffset(14, 14),
          Size = UDim2.new(1, -28, 1, -28),
          BackgroundColor3 = Color3.fromRGB(18, 12, 23),
          BorderSizePixel = 0,
          ClipsDescendants = true,
          Parent = side,
        })
        applyCorner(frame, 18)
        applyStroke(frame, element.AccentSoft, 1, 0.42)
        attachGlow(frame, element.Accent, 5, 0.91)
        applyGradient(frame, Color3.fromRGB(26, 14, 30), Color3.fromRGB(10, 8, 15), 90)
        for index = 1, 7, 1 do
          newInstance("Frame", {
            Position = UDim2.new(index / 8, 0, 0, 0),
            Size = UDim2.new(0, 1, 1, 0),
            BackgroundColor3 = Color3.fromRGB(82, 45, 78),
            BackgroundTransparency = 0.9,
            BorderSizePixel = 0,
            Parent = frame,
          })
        end
        for step = 1, 5, 1 do
          newInstance("Frame", {
            Position = UDim2.new(0, 0, step / 6, 0),
            Size = UDim2.new(1, 0, 0, 1),
            BackgroundColor3 = Color3.fromRGB(82, 45, 78),
            BackgroundTransparency = 0.92,
            BorderSizePixel = 0,
            Parent = frame,
          })
        end
        _ = newInstance("Frame", {
          AnchorPoint = Vector2.new(0.5, 0.5),
          Position = UDim2.fromScale(0.5, 0.5),
          Size = UDim2.fromOffset(190, 270),
          BackgroundTransparency = 1,
          Parent = frame,
        })
        local scale = newInstance("UIScale", { Scale = 1, Parent = _ })
        side, subtitle =
          newInstance("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(95, 132),
            Size = UDim2.fromOffset(96, 186),
            BackgroundTransparency = 1,
            Parent = _,
          }), Color3.fromRGB(55, 40, 62)
        applyCorner(
          newInstance("Frame", {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromOffset(48, 0),
            Size = UDim2.fromOffset(36, 36),
            BackgroundColor3 = subtitle,
            BorderSizePixel = 0,
            Parent = side,
          }),
          99
        )
        applyCorner(
          newInstance("Frame", {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromOffset(48, 43),
            Size = UDim2.fromOffset(44, 72),
            BackgroundColor3 = subtitle,
            BorderSizePixel = 0,
            Parent = side,
          }),
          8
        )
        applyCorner(
          newInstance("Frame", {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromOffset(19, 50),
            Size = UDim2.fromOffset(17, 65),
            Rotation = 7,
            BackgroundColor3 = subtitle,
            BorderSizePixel = 0,
            Parent = side,
          }),
          8
        )
        applyCorner(
          newInstance("Frame", {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromOffset(77, 50),
            Size = UDim2.fromOffset(17, 65),
            Rotation = -7,
            BackgroundColor3 = subtitle,
            BorderSizePixel = 0,
            Parent = side,
          }),
          8
        )
        applyCorner(
          newInstance("Frame", {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromOffset(35, 119),
            Size = UDim2.fromOffset(19, 64),
            BackgroundColor3 = subtitle,
            BorderSizePixel = 0,
            Parent = side,
          }),
          8
        )
        applyCorner(
          newInstance("Frame", {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromOffset(61, 119),
            Size = UDim2.fromOffset(19, 64),
            BackgroundColor3 = subtitle,
            BorderSizePixel = 0,
            Parent = side,
          }),
          8
        )
        local frame2 = newInstance("Frame", {
          AnchorPoint = Vector2.new(0.5, 0.5),
          Position = UDim2.fromOffset(95, 132),
          Size = UDim2.fromOffset(132, 218),
          BackgroundTransparency = 1,
          Parent = _,
        })
        local yResult = applyStroke(frame2, element.AccentSoft, 2, 0.03)
        local sResult = attachGlow(frame2, element.Accent, 4, 0.82)
        local label = newInstance("TextLabel", {
          AnchorPoint = Vector2.new(0.5, 1),
          Position = UDim2.new(0.5, 0, 0, -7),
          Size = UDim2.fromOffset(168, 20),
          BackgroundTransparency = 1,
          Text = "Player_Example",
          TextColor3 = element.White,
          TextStrokeTransparency = 0.32,
          TextStrokeColor3 = Color3.new(0, 0, 0),
          TextSize = 13,
          Font = Enum.Font.GothamMedium,
          Parent = frame2,
        })
        local label2 = newInstance("TextLabel", {
          AnchorPoint = Vector2.new(0.5, 0),
          Position = UDim2.new(0.5, 0, 1, 6),
          Size = UDim2.fromOffset(110, 18),
          BackgroundTransparency = 1,
          Text = "[ 42m ]",
          TextColor3 = element.TextDim,
          TextStrokeTransparency = 0.36,
          TextStrokeColor3 = Color3.new(0, 0, 0),
          TextSize = 12,
          Font = Enum.Font.Gotham,
          Parent = frame2,
        })
        local frame3 = newInstance("Frame", {
          AnchorPoint = Vector2.new(1, 0),
          Position = UDim2.fromOffset(-7, 0),
          Size = UDim2.fromOffset(5, 218),
          BackgroundColor3 = Color3.fromRGB(26, 18, 29),
          BorderSizePixel = 0,
          Parent = frame2,
        })
        local frame4 = newInstance("Frame", {
          AnchorPoint = Vector2.new(0, 1),
          Position = UDim2.new(0, 0, 1, 0),
          Size = UDim2.new(1, 0, 0.78, 0),
          BackgroundColor3 = element.Green,
          BorderSizePixel = 0,
          Parent = frame3,
        })
        applyCorner(frame3, 99)
        applyCorner(frame4, 99)
        attachGlow(frame4, element.Green, 3, 0.88)
        local frame5, list =
          newInstance("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = side }),
          {}
        local function drawEspLine(parent, x1, y1, x2, y2, thickness, color, transparency)
          local value150, value151 = x2 - x1, y2 - y1
          local value152 = math.sqrt(value150 * value150 + value151 * value151)
          local frame = newInstance("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2),
            Size = UDim2.fromOffset(value152, thickness or 2),
            Rotation = math.deg(math.atan2(value151, value150)),
            BackgroundColor3 = color or element.AccentSoft,
            BorderSizePixel = 0,
            ZIndex = transparency or 4,
            Parent = parent,
          })
          applyCorner(frame, 99)
          return frame
        end
        local function addEspElement(parent, x1, y1, x2)
          local oResult = drawEspLine(frame5, parent, x1, y1, x2, 2, element.AccentSoft, 6)
          table.insert(list, oResult)
          return oResult
        end
        addEspElement(48, 20, 48, 61)
        addEspElement(48, 61, 48, 112)
        addEspElement(48, 59, 21, 96)
        addEspElement(48, 59, 75, 96)
        addEspElement(48, 112, 35, 174)
        addEspElement(48, 112, 61, 174)
        local frame6, element2 =
          drawEspLine(_, 95, 266, 95, 241, 2, element.AccentSoft, 2),
          { Box = true, Skeleton = true, Name = true, Distance = true, Health = true, Tracer = true }
        local function applyEspToggles()
          frame2.Visible = element2.Box
          frame5.Visible = element2.Skeleton
          label.Visible = element2.Name
          label2.Visible = element2.Distance
          frame3.Visible = element2.Health
          frame6.Visible = element2.Tracer
        end
        local function refreshEspPreview()
          if not frame.Parent then
            return
          end
          local element = frame.AbsoluteSize
          if element.X <= 1 then
            return
          elseif element.Y <= 1 then
            return
          end
          local element2, element3 = (element.X - 26) / 190, (element.Y - 22) / 270
          scale.Scale = math.clamp(math.min(element2, element3), 0.58, 1.15)
        end
        frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(refreshEspPreview)
        task.defer(refreshEspPreview)
        applyEspToggles()
        addCardResult:AddToggle("Box", true, function(argument91)
          element2.Box = argument91
          applyEspToggles()
        end)
        addCardResult:AddToggle("Skeleton", true, function(argument92)
          element2.Skeleton = argument92
          applyEspToggles()
        end)
        addCardResult:AddToggle("Name", true, function(argument93)
          element2.Name = argument93
          applyEspToggles()
        end)
        addCardResult:AddToggle("Distance", true, function(argument94)
          element2.Distance = argument94
          applyEspToggles()
        end)
        addCardResult:AddToggle("Health Bar", true, function(argument95)
          element2.Health = argument95
          applyEspToggles()
        end)
        addCardResult:AddToggle("Tracer", true, function(argument96)
          element2.Tracer = argument96
          applyEspToggles()
        end)
        window:_RefreshCanvas()
        return {
          Card = addCardResult,
          Scene = frame,
          SetName = function(argument97, argument98)
            label.Text = tostring(argument98)
          end,
          SetDistance = function(argument99, argument100)
            label2.Text = tostring(argument100)
          end,
          SetHealth = function(argument101, argument102)
            frame4.Size = UDim2.new(1, 0, math.clamp(tonumber(argument102) or 0, 0, 1), 0)
          end,
          SetAccent = function(frame, _)
            _ = typeof(_) == "Color3" and _ or normalizeHex(_)
            yResult.Color = _
            sResult.Color = _
            frame6.BackgroundColor3 = _
            for index = 1, 1 / 0, 1 do
              frame = rawget(list, index)
              if frame == nil then
                break
              end
              frame.BackgroundColor3 = _
            end
          end,
        }
      end
      library.FontColor = library.Theme.Text
      library.MainColor = library.Theme.Card
      library.AccentColor = library.Theme.Accent
      library.BackgroundColor = library.Theme.Window
      library.OutlineColor = library.Theme.Stroke
      library.RiskColor = Color3.fromRGB(255, 90, 120)
      library.AccentColorDark = library.AccentColor:Lerp(Color3.new(0, 0, 0), 0.28)
      library.Black = Color3.new(0, 0, 0)
      library.NotifySide = "Right"
      library.KeybindMenuMode = "Toggled"
      setMetatable, weakCache =
        setmetatable, {
          __index = function(self, key)
            if key == "MainColor" then
              return library.MainColor
            end
            if key == "BackgroundColor" then
              return library.BackgroundColor
            end
            if key == "AccentColor" then
              return library.AccentColor
            end
            if key == "OutlineColor" then
              return library.OutlineColor
            end
            if key == "FontColor" then
              return library.FontColor
            end
            return nil
          end,
          __newindex = function(self, _, value)
            if _ == "MainColor" then
              library.MainColor = value
            elseif _ == "BackgroundColor" then
              library.BackgroundColor = value
            elseif _ == "AccentColor" then
              library.AccentColor = value
            elseif _ == "OutlineColor" then
              library.OutlineColor = value
            elseif _ == "FontColor" then
              library.FontColor = value
            else
              rawset(self, _, value)
              return
            end
            library:UpdateColorsUsingRegistry()
          end,
        }
      library.Scheme = setMetatable({}, weakCache)
      library.GetDarkerColor = function(color, argument103)
        local color2, color3, color4 = Color3.toHSV(argument103)
        return Color3.fromHSV(color2, color3, color4 / 1.45)
      end
      library.UpdateColorsUsingRegistry = function(window)
        local _ = window.ActiveWindow
        if not _ then
          return
        end
        window.AccentColorDark = window:GetDarkerColor(window.AccentColor)
        _:SetTheme({
          Text = window.FontColor,
          TextDim = window.FontColor:Lerp(window.BackgroundColor, 0.4),
          TextMute = window.FontColor:Lerp(window.BackgroundColor, 0.58),
          Window = window.BackgroundColor,
          Window2 = window.BackgroundColor:Lerp(window.MainColor, 0.18),
          Sidebar = window.BackgroundColor:Lerp(Color3.new(0, 0, 0), 0.08),
          Topbar = window.BackgroundColor:Lerp(window.MainColor, 0.22),
          Card = window.MainColor,
          Card2 = window.MainColor:Lerp(window.BackgroundColor, 0.32),
          Row = window.BackgroundColor:Lerp(window.MainColor, 0.15),
          Stroke = window.OutlineColor,
          StrokeSoft = window.OutlineColor:Lerp(window.BackgroundColor, 0.35),
          Accent = window.AccentColor,
          Accent2 = window.AccentColor:Lerp(Color3.new(0, 0, 0), 0.18),
          AccentSoft = window.AccentColor:Lerp(Color3.new(1, 1, 1), 0.34),
          Track = window.MainColor:Lerp(window.BackgroundColor, 0.24),
        })
      end
      library.SetNotifySide = function(library, _)
        library.NotifySide = tostring(_ or "Right")
        if library.ActiveWindow then
          library.ActiveWindow:SetNotifySide(library.NotifySide)
        end
      end
      library.Notify = function(library, _, message, duration)
        local value153 = library.ActiveWindow
        if not value153 then
          return
        end
        local value154, value155 = message, duration
        if type(_) == "table" then
          local text, text2 = tostring(_.Title or ""), tostring(_.Description or _.Text or "")
          return value153:Notify(
            text ~= "" and (text2 ~= "" and text .. "  \194\183  " .. text2 or text) or text2,
            _.Time or value154,
            _.Type or value155
          )
        end
        return value153:Notify(_, value154, value155)
      end
      library.GiveSignal = function(library, _)
        if _ then
          table.insert(library.Signals, _)
        end
        return _
      end
      library.OnUnload = function(library, _)
        if type(_) == "function" then
          table.insert(library.UnloadSignals, _)
        end
      end
      library.Toggle = function(library)
        if library.ActiveWindow then
          library.ActiveWindow:Toggle()
        end
      end
      library.Unload = function(library)
        if library.Unloaded then
          return
        end
        local _ = library.UnloadSignals
        for index = 1, 1 / 0, 1 do
          local item = rawget(_, index)
          if item == nil then
            break
          end
          pcall(item)
        end
        _ = library.Signals
        for step = 1, 1 / 0, 1 do
          local item = rawget(_, step)
          if item == nil then
            break
          end
          pcall(function()
            item:Disconnect()
          end)
        end
        table.clear(library.Signals)
        if library.ActiveWindow then
          library.ActiveWindow:Destroy()
        end
        library.Unloaded = true
        library.Toggled = false
      end
      library.SetDPIScale = function(library, argument104) end
      library.UpdateDependencyBoxes = function(argument105) end
      library.UpdateDependencyGroupboxes = function(argument106) end
      library.AttemptSave = function(argument107) end
      local createWindow = library.CreateWindow
      library.CreateWindow = function(_, config)
        config = config or {}
        local camera = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
          or Vector2.new(1280, 720)
        local bound, bound2 =
          math.min(1008, math.max(1, camera.X - 24)), math.min(616, math.max(1, camera.Y - 48))
        if config.Size == nil then
          config.Size = UDim2.fromOffset(bound, bound2)
        end
        if config.MinSize == nil then
          config.MinSize = Vector2.new(math.min(760, bound), math.min(460, bound2))
        end
        bound = createWindow(_, config)
        _.ActiveWindow = bound
        _.Window = bound
        _.ScreenGui = bound.Gui
        _.KeybindFrame = bound.KeybindList
        _.KeybindContainer = bound.KeybindListBody
        _.Unloaded = false
        _.Toggled = bound.Gui.Enabled
        bound:SetNotifySide(_.NotifySide)
        if config.AutoShow == false then
          bound:SetVisible(false)
        end
        return bound
      end
      library.Demo = function(library)
        local createWindowResult =
          library:CreateWindow({ Title = "Lunar", Size = UDim2.fromOffset(860, 520) })
        local tab, tab2, tab3, tab4, tab5 =
          createWindowResult:AddTab("Combat", "combat"),
          createWindowResult:AddTab("Triggerbot", "triggerbot"),
          createWindowResult:AddTab("Visuals", "visuals"),
          createWindowResult:AddTab("Movement", "movement"),
          createWindowResult:AddTab("Player", "player")
        library = tab:AddCard("Aimbot \194\183 Main", "Core aim behavior", "Left")
        library:AddDropdown("Quick Setup", { "Custom", "Legit", "Aggressive" }, "Custom")
        library:AddToggle("Enabled", true)
        library:AddKeybind("Hotkey", Enum.UserInputType.MouseButton2)
        library:AddDropdown("Aim Type", { "Mouse", "Camera" }, "Mouse")
        library:AddDropdown("Target Priority", { "FOV Center", "Distance", "Health" }, "FOV Center")
        library:AddDropdown("Hit Part", { "Head", "Torso", "Random" }, "Head")
        library:AddToggle("Instant Snap", false)
        library = tab:AddCard("Aimbot \194\183 Motion", "Smoothing and tuning", "Right")
        library:AddToggle("Sticky Aim", true)
        library:AddToggle("Humanize", false)
        library:AddSlider("X Smoothing", 0, 100, 35, 1)
        library:AddSlider("Y Smoothing", 0, 100, 35, 1)
        library:AddSlider("Reaction Time", 0, 300, 120, 1)
        library:AddSlider("Hit Chance", 0, 100, 75, 1)
        library:AddSlider("Sticky FOV", 0, 50, 15, 1)
        library:AddSlider("Aim Strength", 0, 50, 16, 1)
        library = tab:AddCard(
          "Projectile Lead",
          "Only for arrows, knives and other projectiles - leave off for guns",
          "Left"
        )
        library:AddToggle("Lead Projectiles", true)
        library:AddSlider("Lead Strength", 0, 2, 1, 0.01)
        library = tab:AddCard("Combat \194\183 Checks", "Filtering rules for targets", "Right")
        library:AddToggle("Team Check", true)
        library:AddToggle("Wall Check", true)
        library:AddToggle("Alive Check", true)
        tab3:AddESPPreview("ESP Preview", "Preview your ESP style before applying it", "Left")
        tab = tab3:AddCard("Visuals \194\183 Style", "ESP appearance", "Right")
        tab:AddToggle("Glow", true)
        tab:AddSlider("Outline", 0, 5, 2, 0.1)
        tab:AddDropdown("Box Type", { "Full", "Corners", "3D" }, "Full")
        tab:AddTextbox("ESP Text", "Player", "Enter text...")
        tab = tab2:AddCard("Triggerbot", "Automatic fire settings", "Left")
        tab:AddToggle("Enabled", false)
        tab:AddSlider("Delay", 0, 250, 35, 1)
        tab = tab4:AddCard("Movement", "Movement helpers", "Left")
        tab:AddToggle("Bunny Hop", false)
        tab:AddSlider("Speed", 0, 100, 16, 1)
        tab3 = tab5:AddCard("Player", "Local player settings", "Left")
        tab3:AddSlider("Field of View", 60, 120, 90, 1)
        tab3:AddToggle("Third Person", false)
        createWindowResult:AddSettingsTab()
        createWindowResult:SetWatermark("Lunar  \226\128\162  Sakura UI v6")
        return createWindowResult
      end
      return library
    end
  end
end
