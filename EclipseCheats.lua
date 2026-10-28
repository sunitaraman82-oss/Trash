local t1 = {}
local Players = game:GetService("Players")
t1[1] = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
t1[2] = Players.LocalPlayer
t1[3] = {}
t1[4] = nil
t1[5] = false
t1[6] = false
t1[7] = false
t1[8] = 50
t1[9] = 16
t1[10] = 42
t1[11] = false
t1[12] = "Main"
t1[13] = nil
t1[14] = nil
t1[15] = function()
    local Character = t1[2].Character
    if not Character then
        Character = t1[2].CharacterAdded:Wait()
    end
    return Character
end
t1[16] = function()
    return t1[15]():WaitForChild("HumanoidRootPart")
end
t1[17] = function()
    return t1[15]():WaitForChild("Humanoid")
end
t1[18] = function(p1, p2)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, p2)
    UICorner.Parent = p1
    return UICorner
end
t1[19] = function(p3, p4, p5, p6)
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = p4
    UIStroke.Transparency = p5
    UIStroke.Thickness = p6 or 1
    UIStroke.Parent = p3
    return UIStroke
end
t1[20] = function(p7, p8, p9, p10, p11)
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingLeft = UDim.new(0, p8 or 0)
    UIPadding.PaddingRight = UDim.new(0, p9 or 0)
    UIPadding.PaddingTop = UDim.new(0, p10 or 0)
    UIPadding.PaddingBottom = UDim.new(0, p11 or 0)
    UIPadding.Parent = p7
    return UIPadding
end
t1[21] = Instance.new("ScreenGui")
t1[21].Name = "EclipseCheats"
t1[21].ResetOnSpawn = false
t1[21].Parent = t1[2]:WaitForChild("PlayerGui")
t1[22] = Instance.new("Frame")
t1[22].Size = UDim2.fromOffset(520, 430)
t1[22].Position = UDim2.new(0.5, -260, 0.5, -215)
t1[22].BackgroundColor3 = Color3.fromRGB(24, 24, 24)
t1[22].BorderSizePixel = 0
t1[22].Parent = t1[21]
t1[18](t1[22], 7)
t1[19](t1[22], Color3.fromRGB(40, 40, 40), 0.1, 1)
t1[23] = Instance.new("UIScale")
t1[23].Parent = t1[22]
local function v4()
    local CurrentCamera = workspace.CurrentCamera
    if not CurrentCamera then
        return
    end
    local ViewportSize = CurrentCamera.ViewportSize
    local v48 = math.clamp((ViewportSize.X - 24) / 520, 0.72, 1)
    local v49 = math.clamp((ViewportSize.Y - 24) / 430, 0.72, 1)
    t1[23].Scale = math.min(v48, v49)
    t1[22].Position = UDim2.new(0.5, -260 * t1[23].Scale, 0.5, -215 * t1[23].Scale)
end
v4()
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(v4)
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(v4)
end
t1[24] = Instance.new("Frame")
t1[24].Size = UDim2.new(1, 0, 0, 44)
t1[24].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
t1[24].BorderSizePixel = 0
t1[24].Parent = t1[22]
t1[18](t1[24], 7)
local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, -140, 1, 0)
TextLabel.Position = UDim2.fromOffset(13, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Eclipse Cheats v2.3.0"
TextLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 15
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = t1[24]
local function v6(p12, p13)
    local TextButton = Instance.new("TextButton")
    TextButton.Size = UDim2.fromOffset(28, 28)
    TextButton.Position = UDim2.new(1, p13, 0, 8)
    TextButton.BackgroundTransparency = 1
    TextButton.Text = p12
    TextButton.TextColor3 = Color3.fromRGB(90, 90, 90)
    TextButton.Font = Enum.Font.GothamBold
    TextButton.TextSize = 20
    TextButton.Parent = t1[24]
    return TextButton
end
v6("Q", -128)
v6("/", -96)
local v7 = v6("-", -64)
local v8 = v6("x", -32)
local function v9(p14)
    local TextLabel2 = Instance.new("TextLabel")
    TextLabel2.Size = UDim2.fromOffset(240, 34)
    TextLabel2.Position = UDim2.new(1, -258, 1, -52)
    TextLabel2.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    TextLabel2.BackgroundTransparency = 0.28
    TextLabel2.BorderSizePixel = 0
    TextLabel2.Text = "  " .. p14
    TextLabel2.TextColor3 = Color3.fromRGB(230, 230, 230)
    TextLabel2.Font = Enum.Font.GothamMedium
    TextLabel2.TextSize = 13
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.Parent = t1[21]
    t1[18](TextLabel2, 6)
    task.delay(4, function()
        local v169 = TextLabel2
        if v169 then
            v169 = TextLabel2.Parent
        end
        if v169 then
            TextLabel2:Destroy()
        end
    end)
end
v9("Eclipse Cheats loaded")
v8.MouseButton1Click:Connect(function()
    t1[21]:Destroy()
end)
t1[25] = false
v7.MouseButton1Click:Connect(function()
    t1[25] = not t1[25]
    local v55 = t1[22]
    local v56 = t1[25]
    if v56 then
        v56 = UDim2.fromOffset(520, 44)
    end
    if not v56 then
        v56 = UDim2.fromOffset(520, 430)
    end
    v55.Size = v56
end)
t1[26] = Instance.new("Frame")
t1[26].Size = UDim2.new(1, -20, 0, 42)
t1[26].Position = UDim2.fromOffset(10, 53)
t1[26].BackgroundColor3 = Color3.fromRGB(22, 22, 22)
t1[26].BorderSizePixel = 0
t1[26].Parent = t1[22]
t1[18](t1[26], 7)
t1[20](t1[26], 6, 6, 6, 6)
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = t1[26]
t1[27] = Instance.new("Frame")
t1[27].Size = UDim2.new(1, -20, 1, -106)
t1[27].Position = UDim2.fromOffset(10, 100)
t1[27].BackgroundTransparency = 1
t1[27].Parent = t1[22]
t1[28] = nil
t1[29] = nil
t1[29] = {}
t1[28] = {}
local function v11(p15)
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = p15
    ScrollingFrame.Size = UDim2.fromScale(1, 1)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 3
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 70)
    ScrollingFrame.Visible = false
    ScrollingFrame.CanvasSize = UDim2.fromOffset(0, 0)
    ScrollingFrame.Parent = t1[27]
    local UIListLayout2 = Instance.new("UIListLayout")
    UIListLayout2.Padding = UDim.new(0, 7)
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout2.Parent = ScrollingFrame
    t1[20](ScrollingFrame, 0, 4, 0, 0)
    UIListLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollingFrame.CanvasSize = UDim2.fromOffset(0, UIListLayout2.AbsoluteContentSize.Y + 8)
    end)
    t1[28][p15] = ScrollingFrame
    return ScrollingFrame
end
t1[30] = function(p16)
    t1[12] = p16
    for v60, v61 in pairs(t1[28]) do
        v61.Visible = v60 == p16
    end
    for k, v in pairs(t1[29]) do
        local v64 = k == p16
        local v65 = v64
        if v64 then
            v65 = Color3.fromRGB(38, 92, 125)
        end
        if not v65 then
            v65 = Color3.fromRGB(31, 31, 31)
        end
        v.BackgroundColor3 = v65
        if v64 then
            v64 = Color3.fromRGB(235, 248, 255)
        end
        if not v64 then
            v64 = Color3.fromRGB(165, 165, 165)
        end
        v.TextColor3 = v64
    end
end
local function v12(p17, p18)
    local TextButton = Instance.new("TextButton")
    TextButton.Size = UDim2.new(0.25, -5, 1, 0)
    TextButton.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
    TextButton.BorderSizePixel = 0
    TextButton.Text = p17
    TextButton.TextColor3 = Color3.fromRGB(165, 165, 165)
    TextButton.Font = Enum.Font.GothamBold
    TextButton.TextSize = 13
    TextButton.LayoutOrder = p18
    TextButton.Parent = t1[26]
    t1[18](TextButton, 6)
    t1[19](TextButton, Color3.fromRGB(56, 56, 56), 0.3, 1)
    TextButton.MouseButton1Click:Connect(function()
        t1[30](p17)
    end)
    t1[29][p17] = TextButton
    return TextButton
end
local v13 = v11("Main")
local v14 = v11("Waypoints")
local v15 = v11("Movement")
local v16 = v11("Tutorial")
v12("Main", 1)
v12("Waypoints", 2)
v12("Movement", 3)
v12("Tutorial", 4)
t1[31] = nil
t1[32] = {}
t1[33] = function(p19)
    if t1[31] then
        table.insert(t1[32][t1[31]], p19)
    end
end
t1[34] = nil
local function v17(p20, p21, p22)
    local v81 = t1[34](p20, p21)
    local TextButton = Instance.new("TextButton")
    TextButton.Size = UDim2.fromOffset(42, 22)
    TextButton.Position = UDim2.new(1, -56, 0.5, -11)
    TextButton.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
    TextButton.BorderSizePixel = 0
    TextButton.Text = ""
    TextButton.Parent = v81
    t1[18](TextButton, 20)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.fromOffset(18, 18)
    Frame.Position = UDim2.fromOffset(2, 2)
    Frame.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
    Frame.BorderSizePixel = 0
    Frame.Parent = TextButton
    t1[18](Frame, 20)
    local u84 = false
    local function v85()
        local v170 = TextButton
        local v171 = u84
        if v171 then
            v171 = Color3.fromRGB(21, 112, 158)
        end
        if not v171 then
            v171 = Color3.fromRGB(44, 44, 44)
        end
        v170.BackgroundColor3 = v171
        local v172 = Frame
        local v173 = u84
        if v173 then
            v173 = Color3.fromRGB(0, 170, 255)
        end
        if not v173 then
            v173 = Color3.fromRGB(95, 95, 95)
        end
        v172.BackgroundColor3 = v173
        local v174 = Frame
        local v175 = u84
        if v175 then
            v175 = UDim2.new(1, -20, 0, 2)
        end
        if not v175 then
            v175 = UDim2.fromOffset(2, 2)
        end
        v174.Position = v175
    end
    TextButton.MouseButton1Click:Connect(function()
        u84 = not u84
        v85()
        p22(u84)
    end)
    return function(p23)
        u84 = p23
        v85()
        p22(u84)
    end
end
t1[34] = function(p24, p25, p26)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, p26 or 40)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Frame.BorderSizePixel = 0
    Frame.Parent = p24
    t1[33](Frame)
    t1[18](Frame, 5)
    t1[19](Frame, Color3.fromRGB(46, 46, 46), 0.25, 1)
    local TextLabel3 = Instance.new("TextLabel")
    TextLabel3.Size = UDim2.new(0.47, -12, 1, 0)
    TextLabel3.Position = UDim2.fromOffset(15, 0)
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = p25
    TextLabel3.TextColor3 = Color3.fromRGB(220, 220, 220)
    TextLabel3.Font = Enum.Font.GothamBold
    TextLabel3.TextSize = 13
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel3.TextWrapped = true
    TextLabel3.Parent = Frame
    return Frame, TextLabel3
end
local function v18(p27, p28, p29, p30, p31, p32, p33)
    local v93 = t1[34](p27, p28, 48)
    local TextLabel4 = Instance.new("TextLabel")
    TextLabel4.Size = UDim2.new(0, 92, 0, 22)
    TextLabel4.Position = UDim2.new(1, -102, 0, 5)
    TextLabel4.BackgroundTransparency = 1
    TextLabel4.TextColor3 = Color3.fromRGB(210, 230, 245)
    TextLabel4.Font = Enum.Font.GothamBold
    TextLabel4.TextSize = 12
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Right
    TextLabel4.Parent = v93
    local TextButton = Instance.new("TextButton")
    TextButton.Size = UDim2.new(0.48, -10, 0, 12)
    TextButton.Position = UDim2.new(0.52, 0, 1, -20)
    TextButton.BackgroundColor3 = Color3.fromRGB(24, 53, 74)
    TextButton.BorderSizePixel = 0
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.Parent = v93
    t1[18](TextButton, 8)
    t1[19](TextButton, Color3.fromRGB(54, 142, 196), 0.35, 1)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.fromScale(0, 1)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 146, 219)
    Frame.BorderSizePixel = 0
    Frame.Parent = TextButton
    t1[18](Frame, 8)
    local Frame2 = Instance.new("Frame")
    Frame2.Size = UDim2.fromOffset(18, 18)
    Frame2.Position = UDim2.new(0, -9, 0.5, -9)
    Frame2.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Frame2.BorderSizePixel = 0
    Frame2.Parent = TextButton
    t1[18](Frame2, 20)
    local u98 = p31
    local u99 = false
    local function v100(p34)
        u98 = math.clamp(math.floor(p34 + 0.5), p29, p30)
        local v178 = (u98 - p29) / (p30 - p29)
        Frame.Size = UDim2.fromScale(v178, 1)
        Frame2.Position = UDim2.new(v178, -9, 0.5, -9)
        TextLabel4.Text = u98 .. p32
        p33(u98)
    end
    TextButton.InputBegan:Connect(function(input)
        local v182 = input.UserInputType == Enum.UserInputType.MouseButton1
        if not v182 then
            v182 = input.UserInputType == Enum.UserInputType.Touch
        end
        if v182 then
            u99 = true
            local v183 = math.clamp((input.Position.X - TextButton.AbsolutePosition.X) / TextButton.AbsoluteSize.X, 0, 1)
            v100(p29 + (p30 - p29) * v183)
        end
    end)
    t1[1].InputEnded:Connect(function(input)
        local v185 = input.UserInputType == Enum.UserInputType.MouseButton1
        if not v185 then
            v185 = input.UserInputType == Enum.UserInputType.Touch
        end
        if v185 then
            u99 = false
        end
    end)
    t1[1].InputChanged:Connect(function(input)
        local v187 = u99
        if v187 then
            v187 = input.UserInputType == Enum.UserInputType.MouseMovement
            if not v187 then
                v187 = input.UserInputType == Enum.UserInputType.Touch
            end
        end
        if v187 then
            local v188 = math.clamp((input.Position.X - TextButton.AbsolutePosition.X) / TextButton.AbsoluteSize.X, 0, 1)
            v100(p29 + (p30 - p29) * v188)
        end
    end)
    v100(p31)
    return v100
end
local function v19(p35, p36)
    local TextButton = Instance.new("TextButton")
    TextButton.Size = UDim2.new(1, 0, 0, 36)
    TextButton.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    TextButton.BorderSizePixel = 0
    TextButton.Text = "  " .. p36 .. "  v"
    TextButton.TextColor3 = Color3.fromRGB(165, 165, 165)
    TextButton.Font = Enum.Font.GothamBold
    TextButton.TextSize = 13
    TextButton.TextXAlignment = Enum.TextXAlignment.Left
    TextButton.AutoButtonColor = false
    TextButton.Parent = p35
    t1[18](TextButton, 7)
    t1[32][TextButton] = {}
    local u104 = true
    TextButton.MouseButton1Click:Connect(function()
        u104 = not u104
        TextButton.Text = "  " .. p36 .. (not u104 and "  >" or "  v")
        for _, v in ipairs(t1[32][TextButton]) do
            v.Visible = u104
        end
    end)
    return TextButton
end
local function v20(p37, p38)
    local TextLabel5 = Instance.new("TextLabel")
    TextLabel5.Size = UDim2.new(1, 0, 0, 31)
    TextLabel5.BackgroundTransparency = 1
    TextLabel5.Text = p38
    TextLabel5.TextColor3 = Color3.fromRGB(150, 150, 150)
    TextLabel5.Font = Enum.Font.GothamBold
    TextLabel5.TextSize = 12
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel5.TextWrapped = true
    TextLabel5.Parent = p37
    t1[33](TextLabel5)
    return TextLabel5
end
local function v21(p39, p40, p41)
    local TextButton = Instance.new("TextButton")
    TextButton.Size = UDim2.new(1, 0, 0, 38)
    if not p41 then
        p41 = Color3.fromRGB(35, 35, 35)
    end
    TextButton.BackgroundColor3 = p41
    TextButton.BorderSizePixel = 0
    TextButton.Text = "  " .. p40
    TextButton.TextColor3 = Color3.fromRGB(230, 230, 230)
    TextButton.Font = Enum.Font.GothamBold
    TextButton.TextSize = 13
    TextButton.TextXAlignment = Enum.TextXAlignment.Left
    TextButton.Parent = p39
    t1[33](TextButton)
    t1[18](TextButton, 5)
    t1[19](TextButton, Color3.fromRGB(48, 48, 48), 0.25, 1)
    return TextButton
end
v19(v13, "Main")
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(1, 0, 0, 260)
Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Frame.BorderSizePixel = 0
Frame.Parent = v13
t1[33](Frame)
t1[18](Frame, 7)
t1[19](Frame, Color3.fromRGB(38, 38, 38), 0.1, 1)
local TextLabel6 = Instance.new("TextLabel")
TextLabel6.Size = UDim2.new(1, -30, 1, 0)
TextLabel6.Position = UDim2.fromOffset(15, 0)
TextLabel6.BackgroundTransparency = 1
local v24 = t1[2].DisplayName ~= ""
if v24 then
    v24 = t1[2].DisplayName
end
if not v24 then
    v24 = t1[2].Name
end
TextLabel6.Text = "Hello, " .. v24
TextLabel6.TextColor3 = Color3.fromRGB(245, 245, 245)
TextLabel6.Font = Enum.Font.GothamBlack
TextLabel6.TextSize = 26
TextLabel6.TextWrapped = true
TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
TextLabel6.Parent = Frame
local Frame3 = Instance.new("Frame")
Frame3.Size = UDim2.new(1, -30, 0, 2)
Frame3.Position = UDim2.new(0, 15, 1, -44)
Frame3.BackgroundColor3 = Color3.fromRGB(0, 145, 215)
Frame3.BorderSizePixel = 0
Frame3.Parent = Frame
t1[18](Frame3, 2)
v19(v14, "Waypoint Teleport")
v20(v14, "1. Create a waypoint.  2. Save your current position.  3. Select it and teleport back anytime.")
t1[35] = v20(v14, "Selected: none")
t1[36] = (function(p42, p43, p44, p45)
    local v116 = t1[34](p42, p43)
    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0.48, -10, 0, 30)
    TextBox.Position = UDim2.new(0.52, 0, 0.5, -15)
    TextBox.BackgroundColor3 = Color3.fromRGB(24, 53, 74)
    TextBox.BorderSizePixel = 0
    TextBox.Text = p44
    TextBox.PlaceholderText = p44
    TextBox.TextColor3 = Color3.fromRGB(220, 238, 248)
    TextBox.PlaceholderColor3 = Color3.fromRGB(120, 140, 150)
    TextBox.Font = Enum.Font.GothamBold
    TextBox.TextSize = 12
    TextBox.ClearTextOnFocus = false
    TextBox.Parent = v116
    t1[18](TextBox, 6)
    t1[19](TextBox, Color3.fromRGB(54, 142, 196), 0.3, 1)
    TextBox.FocusLost:Connect(function()
        p45(TextBox.Text, TextBox)
    end)
    return TextBox
end)(v14, "Waypoint Name", "Base", function(p46)
    local v119 = t1[4]
    if v119 then
        v119 = t1[3][t1[4]] and p46 ~= ""
    end
    if v119 then
        t1[3][t1[4]].name = p46
    end
end)
t1[37] = v20(v14, "Status: ready")
local v26 = v21(v14, "+ Create Waypoint")
local v27 = v21(v14, "Save Current Position")
local v28 = v21(v14, "Teleport To Selected")
local v29 = v21(v14, "Delete Selected", Color3.fromRGB(54, 33, 36))
v19(v14, "Saved Waypoints")
t1[38] = Instance.new("Frame")
t1[38].Size = UDim2.new(1, 0, 0, 120)
t1[38].BackgroundTransparency = 1
t1[38].Parent = v14
t1[33](t1[38])
local UIListLayout3 = Instance.new("UIListLayout")
UIListLayout3.Padding = UDim.new(0, 6)
UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout3.Parent = t1[38]
t1[39] = function(p47)
    t1[37].Text = "Status: " .. p47
end
t1[40] = nil
t1[40] = function()
    for v123, v124 in ipairs(t1[38]:GetChildren()) do
        if v124:IsA("TextButton") then
            v124:Destroy()
        end
    end
    for i, v in ipairs(t1[3]) do
        local v127 = i
        local v128 = v
        local v129 = v127 == t1[4]
        local v130 = not v128.position and "empty" or "saved"
        local TextButton = Instance.new("TextButton")
        TextButton.Size = UDim2.new(1, 0, 0, 36)
        if v129 then
            v129 = Color3.fromRGB(28, 72, 100)
        end
        if not v129 then
            v129 = Color3.fromRGB(35, 35, 35)
        end
        TextButton.BackgroundColor3 = v129
        TextButton.BorderSizePixel = 0
        TextButton.Text = string.format("  %02d  %s    [%s]", v127, v128.name, v130)
        TextButton.TextColor3 = Color3.fromRGB(230, 230, 230)
        TextButton.Font = Enum.Font.GothamBold
        TextButton.TextSize = 13
        TextButton.TextXAlignment = Enum.TextXAlignment.Left
        TextButton.Parent = t1[38]
        t1[18](TextButton, 5)
        TextButton.MouseButton1Click:Connect(function()
            t1[4] = v127
            t1[36].Text = v128.name
            t1[35].Text = "Selected: " .. v128.name
            t1[11] = false
            t1[39](not v128.position and "save a position for this waypoint" or "position is saved")
            t1[40]()
        end)
    end
    t1[38].Size = UDim2.new(1, 0, 0, (math.max(80, #t1[3] * 42)))
end
v26.MouseButton1Click:Connect(function()
    local v132 = t1[36].Text ~= ""
    if v132 then
        v132 = t1[36].Text
    end
    local v133 = v132 or "Waypoint " .. #t1[3] + 1
    table.insert(t1[3], {
		name = v133,
		position = nil
	})
    t1[4] = #t1[3]
    t1[35].Text = "Selected: " .. v133
    t1[11] = false
    t1[39]("new waypoint created, now save your position")
    t1[40]()
end)
v27.MouseButton1Click:Connect(function()
    if not t1[4] or not t1[3][t1[4]] then
        t1[39]("create or select a waypoint first")
        return
    end
    local v134 = t1[3][t1[4]]
    if t1[36].Text ~= "" then
        v134.name = t1[36].Text
    end
    v134.position = t1[16]().CFrame
    t1[35].Text = "Selected: " .. v134.name
    t1[11] = false
    t1[39]("saved current position for " .. v134.name)
    t1[40]()
end)
v28.MouseButton1Click:Connect(function()
    if not t1[4] or not t1[3][t1[4]] then
        t1[39]("select a waypoint first")
        return
    end
    local v135 = t1[3][t1[4]]
    if not v135.position then
        t1[39]("this waypoint has no saved position")
        return
    end
    t1[16]().CFrame = v135.position + Vector3.new(0, 3, 0)
    t1[39]("teleported to " .. v135.name)
end)
v29.MouseButton1Click:Connect(function()
    if not t1[4] or not t1[3][t1[4]] then
        t1[39]("select a waypoint first")
        return
    end
    if not t1[11] then
        t1[39]("click delete again to confirm")
        return
    end
    table.remove(t1[3], t1[4])
    t1[35].Text = "Selected: none"
    t1[39]("waypoint deleted")
    t1[40]()
end)
v19(v15, "Movement")
t1[41] = v17(v15, "Fly Mode", function(p48)
    t1[5] = p48
    local v137 = t1[17]()
    v137.PlatformStand = p48
    if not p48 then
        t1[16]().AssemblyLinearVelocity = Vector3.zero
        v137.PlatformStand = false
        if t1[13] then
            t1[13]:Destroy()
            t1[13] = nil
        end
        if t1[14] then
            t1[14]:Destroy()
            t1[14] = nil
        end
    end
end)
t1[42] = v18(v15, "Fly Speed", 10, 250, t1[8], " studs/sec", function(p49)
    t1[8] = p49
end)
t1[43] = v18(v15, "Up / Down Speed", 10, 200, t1[10], " studs/sec", function(p50)
    t1[10] = p50
end)
t1[44] = v18(v15, "Walk Speed", 8, 120, t1[9], " studs/sec", function(p51)
    t1[9] = p51
    t1[17]().WalkSpeed = t1[9]
end)
t1[45] = v17(v15, "Noclip", function(p52)
    t1[6] = p52
    if not p52 then
        for _, descendant in ipairs(t1[15]():GetDescendants()) do
            local v144 = descendant:IsA("BasePart")
            if v144 then
                v144 = descendant.Name ~= "HumanoidRootPart"
            end
            if v144 then
                descendant.CanCollide = true
            end
        end
    end
end)
t1[46] = v17(v15, "Infinite Jump", function(p53)
    t1[7] = p53
end)
v19(v15, "Controls")
v20(v15, "Fly: W A S D moves with the camera. E goes up. Q goes down.")
v20(v15, "Noclip: keeps your character from colliding while enabled.")
v20(v15, "Infinite Jump: press jump again while you are in the air.")
v19(v16, "Tutorial")
v20(v16, "Main tab")
v20(v16, "Main shows your welcome screen.")
v19(v16, "Waypoints tab")
v20(v16, "Create Waypoint makes a new save slot.")
v20(v16, "Save Current Position saves where you are standing.")
v20(v16, "Click a waypoint in the list to select it.")
v20(v16, "Teleport To Selected sends you back to that saved spot.")
v19(v16, "Movement tab")
v20(v16, "Turn Fly Mode on to fly.")
v20(v16, "Use W A S D to move.")
v20(v16, "Use E to go up.")
v20(v16, "Use Q to go down.")
v20(v16, "Turn Noclip on to walk through parts.")
v20(v16, "Turn Infinite Jump on to jump again in the air.")
v19(v16, "Chat commands")
v20(v16, ";fly turns Fly on or off.")
v20(v16, ";noclip turns Noclip on or off.")
v20(v16, ";jump turns Infinite Jump on or off.")
v20(v16, ";speed 50 changes Walk Speed.")
v20(v16, ";flyspeed 100 changes Fly Speed.")
v20(v16, ";main, ;waypoints, ;movement, ;tutorial open tabs.")
t1[1].JumpRequest:Connect(function()
    if t1[7] then
        t1[17]():ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
t1[2].Chatted:Connect(function(message)
    local t2 = {}
    for match in string.gmatch(message, "%S+") do
        table.insert(t2, match)
    end
    local v149 = t2[1] and string.lower(t2[1]) or ""
    local num = tonumber(t2[2])
    if v149 == ";fly" then
        local v151 = t1[5]
        t1[41](not v151)
        v9(not ("Fly " .. t1[5]) and "disabled" or "enabled")
        return
    end
    if v149 == ";unfly" then
        t1[41](false)
        v9("Fly disabled")
        return
    end
    if v149 == ";noclip" then
        local v152 = t1[6]
        t1[45](not v152)
        v9(not ("Noclip " .. t1[6]) and "disabled" or "enabled")
        return
    end
    if v149 == ";clip" then
        t1[45](false)
        v9("Noclip disabled")
        return
    end
    if v149 == ";jump" then
        local v153 = t1[7]
        t1[46](not v153)
        v9(not ("Infinite Jump " .. t1[7]) and "disabled" or "enabled")
        return
    end
    if v149 == ";unjump" then
        t1[46](false)
        v9("Infinite Jump disabled")
        return
    end
    local v154 = v149 == ";speed"
    if not v154 then
        v154 = v149 == ";walkspeed" or v149 == ";ws"
    end
    if v154 then
        if num then
            t1[44](num)
            v9("Walk Speed set to " .. t1[9])
            return
        end
    elseif v149 == ";flyspeed" or v149 == ";fs" then
        if num then
            t1[42](num)
            v9("Fly Speed set to " .. t1[8])
            return
        end
    elseif v149 == ";upspeed" or v149 == ";vs" then
        if num then
            t1[43](num)
            v9("Up / Down Speed set to " .. t1[10])
            return
        end
    else
        if v149 == ";main" then
            t1[30]("Main")
            return
        end
        if v149 == ";waypoints" or v149 == ";wp" then
            t1[30]("Waypoints")
            return
        end
        if v149 == ";movement" or v149 == ";move" then
            t1[30]("Movement")
            return
        end
        if v149 == ";tutorial" or v149 == ";help" then
            t1[30]("Tutorial")
        end
    end
end)
RunService.RenderStepped:Connect(function()
    local v155 = t1[15]()
    if t1[6] then
        for _, descendant in ipairs(v155:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = false
            end
        end
    end
    if not t1[5] then
        return
    end
    local v158 = t1[16]()
    local CurrentCamera = workspace.CurrentCamera
    if not t1[13] then
        t1[13] = Instance.new("BodyVelocity")
        t1[13].MaxForce = Vector3.new(1, 1, 1) * 1000000
        t1[13].P = 50000
        t1[13].Parent = v158
    end
    if not t1[14] then
        t1[14] = Instance.new("BodyGyro")
        t1[14].MaxTorque = Vector3.new(1, 1, 1) * 1000000
        t1[14].P = 50000
        t1[14].Parent = v158
    end
    local zero = Vector3.zero
    if t1[1]:IsKeyDown(Enum.KeyCode.W) then
        zero += CurrentCamera.CFrame.LookVector
    end
    if t1[1]:IsKeyDown(Enum.KeyCode.S) then
        zero -= CurrentCamera.CFrame.LookVector
    end
    if t1[1]:IsKeyDown(Enum.KeyCode.A) then
        zero -= CurrentCamera.CFrame.RightVector
    end
    if t1[1]:IsKeyDown(Enum.KeyCode.D) then
        zero += CurrentCamera.CFrame.RightVector
    end
    local n1 = 0
    if t1[1]:IsKeyDown(Enum.KeyCode.E) then
        n1 += t1[10]
    end
    if t1[1]:IsKeyDown(Enum.KeyCode.Q) then
        n1 -= t1[10]
    end
    local v162 = zero.Magnitude > 0 and zero.Unit * t1[8]
    if not v162 then
        v162 = Vector3.zero
    end
    local vector3 = Vector3.new(v162.X, n1 + 10, v162.Z)
    t1[13].Velocity = vector3
    v158.AssemblyLinearVelocity = vector3
    t1[14].CFrame = CurrentCamera.CFrame
end)
t1[2].CharacterAdded:Connect(function()
    task.wait(0.5)
    t1[41](false)
    t1[45](false)
    t1[46](false)
    t1[17]().WalkSpeed = t1[9]
end)
t1[47] = false
t1[48] = nil
t1[49] = nil
t1[24].InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        t1[47] = true
        t1[48] = input.Position
        t1[49] = t1[22].Position
    end
end)
t1[1].InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        t1[47] = false
    end
end)
t1[1].InputChanged:Connect(function(input)
    local v167 = t1[47]
    if v167 then
        v167 = input.UserInputType == Enum.UserInputType.MouseMovement
    end
    if v167 then
        local v168 = input.Position - t1[48]
        t1[22].Position = UDim2.new(t1[49].X.Scale, t1[49].X.Offset + v168.X, t1[49].Y.Scale, t1[49].Y.Offset + v168.Y)
    end
end)
t1[40]()
t1[30](t1[12])