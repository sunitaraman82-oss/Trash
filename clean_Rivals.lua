local function _w0(v1, v2)
    return function(v3, v4, v5, v10, ...)
        local v6 = v2[4][1]()
        local v7 = v6
        if v6 then
            v7 = v2[3][1][v6]
        end
        local v8 = v7
        local v9 = v2[2][1]
        if not v7 then
            v8 = v4
        end
        v9 = table.pack(v9(v3, v8, v5, v10, ...))
        return table.unpack(v9, 1, v9.n)
    end
end
local function _w1(v1)
    return function(espGlowChams)
        EspSettings.EspGlowChams = espGlowChams
    end
end
local function _w2(v1)
    return function()
        getgenv()._Dark_V12_EnemyWeapons.destroyContainer()
    end
end
local function _w3(v1)
    return function()
        restoreAllHitboxes()
    end
end
local function _w4(v1, v2)
    return function(lockIndicator)
        v2[1][1].LockIndicator = lockIndicator
    end
end
local function _w5(v1)
    return function(espLines)
        EspSettings.EspLines = espLines
    end
end
local function _w6(v1, v2)
    return function()
        local v3, v4, v5, descendantAdded
        if not v2[4][1]._renderConn then
            v2[6][1]()
            descendantAdded = workspace.DescendantAdded
            v2[4][1]._addedConn = descendantAdded:Connect(v1:uf({v2[5], v2[2], v2[4]}))
            v3 = v2[1][1]
            v4 = v2[4][1]
            v5 = v1:vf({v2[3]})
            v4._updateConn = v3.Heartbeat:Connect(v5)
            v4._renderConn = v2[1][1].RenderStepped:Connect(v1:wf({v2[4]}))
        end
    end
end
local function _w7(v1)
    return function()
        local v2, v3, v4
        v4, v2, v3 = pairs(OriginalHeadSizes)
        v4, v2, v3 = v1.g(v4, v2, v3)
        local v5, v6
        v6, v5 = v4(v2, v3)
        if v6 ~= nil then
            while true do
                v6 = {[2] = 1, [1] = v6}
                v6[3] = v6
                v5 = {[2] = 1, [1] = v5}
                v5[3] = v5
                if v6[1] and v6[1].Parent then
                    pcall(v1:Ef({v5, v6}))
                end
                v6, v5 = v4(v2, v3)
                v3 = v6
                if v3 == nil then
                    break
                end
            end
        end
        OriginalHeadSizes = {}
    end
end
local function _w8(v1, v2)
    return function(v3, v4)
        v2[2][1].BulletTracer.OldShootEffect(v3, v4)
        local getMuzzlePosition = v3.ViewModel:GetMuzzlePosition()
        local v5, v6, v7
        v7, v6, v5 = pairs(v4)
        v7, v6, v5 = v1.g(v7, v6, v5)
        local v8, v9
        v9, v8 = v7(v6, v5)
        local v10, v11, v12, v13, v14, v15, v16, v17, tracerColor2
        if v9 ~= nil then
            while true do
                v17 = v8[utf8.char(0)]
                if v17 then
                    v13 = {[2] = 1, [1] = Instance.new("Attachment")}
                    v13[3] = v13
                    v13[1].WorldPosition = getMuzzlePosition
                    v15 = workspace.Terrain
                    v13[1].Parent = v15
                    v15 = {[2] = 1, [1] = Instance.new("Attachment")}
                    v15[3] = v15
                    v15[1].WorldPosition = v17
                    v16 = workspace.Terrain
                    v15[1].Parent = v16
                    v16 = {[2] = 1, [1] = Instance.new("Beam")}
                    v16[3] = v16
                    v16[1].Attachment0 = v13[1]
                    v16[1].Attachment1 = v15[1]
                    v10 = v2[1][1]
                    v14 = v10.TracerWidth
                    v16[1].Width0 = v14
                    v11, v10 = 0.5, v10.TracerWidth
                    v16[1].Width1 = v10 * 0.5
                    v16[1].FaceCamera = true
                    v14 = workspace.Terrain
                    v16[1].Parent = v14
                    if v2[1][1].TracerRainbow then
                        v14 = {[2] = 1, [1] = 0}
                        v14[3] = v14
                        task.spawn(v1:bf({v14, v16}))
                    else
                        v14 = ColorSequence.new
                        v10 = {}
                        v11 = ColorSequenceKeypoint.new(0, v2[1][1].TracerColor1)
                        v12 = ColorSequenceKeypoint.new
                        tracerColor2 = v2[1][1].TracerColor2
                        v12 = table.pack(v12(1, tracerColor2))
                        v10[1] = v11
                        v1.j(v10, 2, table.unpack(v12, 1, v12.n))
                        v14 = v14(v10)
                        v16[1].Color = v14
                    end
                    v14 = NumberSequence.new(0)
                    v16[1].Transparency = v14
                    v16[1].LightEmission = 1
                    v10 = v1:af({v15, v13, v16, v2[1]})
                    task.spawn(v10)
                end
                v9, v8 = v7(v6, v5)
                v5 = v9
                if v5 == nil then
                    break
                end
            end
        end
    end
end
local function _w9(v1, v2)
    return function()
        v2[2][1]:EquipItem(v2[1][1]())
    end
end
local function _w10(v1)
    return function(boxThickness)
        EspSettings.BoxThickness = boxThickness
    end
end
local function _w11(v1, v2)
    return function()
        local dark_ESPSphere = Instance.new("Part")
        dark_ESPSphere.Name = "Dark_ESPSphere"
        dark_ESPSphere.Shape = Enum.PartType.Ball
        local v3 = v2[2][1]
        local size = v3.Size
        local v4 = v3
        v3, v4 = v4.Size, v4.Size
        dark_ESPSphere.Size = Vector3.new(size, v3, v4)
        dark_ESPSphere.Material = Enum.Material.ForceField
        size = v2[2][1]
        dark_ESPSphere.Color = size.Color
        dark_ESPSphere.Transparency = size.Transparency
        dark_ESPSphere.CanCollide = false
        dark_ESPSphere.Anchored = false
        dark_ESPSphere.Massless = true
        dark_ESPSphere.CastShadow = false
        dark_ESPSphere.Parent = v2[3][1]
        local weldConstraint = Instance.new("WeldConstraint")
        weldConstraint.Part0 = v2[1][1]
        weldConstraint.Part1 = dark_ESPSphere
        weldConstraint.Parent = dark_ESPSphere
        v3 = v2[3][1]
        v2[2][1]._spheres[v3] = dark_ESPSphere
    end
end
local function _w12(v1, v2)
    return function(bloomIntensity)
        v2[1][1].BloomIntensity = bloomIntensity
        applyBloomSettings()
    end
end
local function _w13(v1, v2)
    return function(v3)
        local n, _, J, s
        local color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
        local espColorMode = EspSettings.EspColorMode
        local v4 = espColorMode == "Rainbow" and color
        local v5
        if not v4 then
            v5 = EspSettings.EspColorMode
            v4 = Dark_Crosshair.presets[v5]
        end
        if not v4 then
            v4 = Color3.fromRGB(0, 180, 255)
        end
        v5 = EspSettings.EspFilledColorMode
        espColorMode = v5 == "Rainbow" and color
        local v6
        if not espColorMode then
            v6 = EspSettings.EspFilledColorMode
            espColorMode = Dark_Crosshair.presets[v6]
        end
        if not espColorMode then
            espColorMode = Color3.fromRGB(0, 180, 255)
        end
        v6 = EspSettings.EspChamsColorMode
        v5 = v6 == "Rainbow" and color
        local v7
        if not v5 then
            v7 = EspSettings.EspChamsColorMode
            v5 = Dark_Crosshair.presets[v7]
        end
        if not v5 then
            v5 = Color3.fromRGB(0, 255, 255)
        end
        local v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22
        if EspSettings.ArrowESP and v2[4][1] then
            v6 = v2[3][1].ViewportSize
            v17 = v6.X
            v17, v12 = v6.Y, v17 / 2
            v7 = Vector2.new(v12, v17 / 2)
            v12 = 0
            v11 = v2[1][1]
            v11, s = v11.GetPlayers, v11
            v11 = v1.h(v11(s))
            v17, v11, s = ipairs(v1.i(v11))
            v17, v11, s = v1.g(v17, v11, s)
            for s, J in v17, v11, s do
                if J ~= v2[2][1] and J.Character and not isTeammate(J) then
                    v8 = J.Character:FindFirstChildOfClass("Humanoid")
                    v13 = J.Character:FindFirstChild("HumanoidRootPart")
                    if v8 and v13 and v8.Health > 0 then
                        v14 = v2[3][1]
                        v14, v19 = v14.WorldToViewportPoint, v14
                        v14, v19 = v14(v19, v13.Position)
                        v21, v22, n = v14.Y, Vector2.new, v14.X
                        v22 = v22(n, v21)
                        v21, n = not v19, (v22 - v7).Magnitude
                        if not v21 then
                            v21 = n > 150
                        end
                        if v21 then
                            _, v12 = EspSettings, v12 + 1
                            v21 = v2[4][1].new("Triangle")
                            v21.Thickness = 1
                            v21.Filled = true
                            v21.Color = v4
                            v21.Visible = false
                            EspSettings._arrows[v12] = v21
                            v21 = EspSettings._arrows[v12]
                            v9 = v22 - v7
                            if v9.Magnitude > 0 then
                                v9 = v9.Unit
                            else
                                v15, v18, _ = Vector2.new, -1, 0
                                v9 = v15(0, -1)
                            end
                            v20 = v6.Y
                            v18, _ = 20, math.min(v6.X, v20) / 2
                            _ = v7 + v9 * (_ - 20)
                            v20 = v9.Y
                            v20, v16 = v9.X, -v20
                            v18 = Vector2.new(v16, v20)
                            v21.PointA = _ + v9 * 8
                            v21.PointB = _ - v9 * 8 + v18 * 8
                            v21.PointC = _ - v9 * 8 - v18 * 8
                            v21.Color = v4
                            v21.Visible = true
                        end
                    end
                end
            end
            v17 = v12 + 1
            v11 = #EspSettings._arrows
            if v17 <= v11 then
                while true do
                    if EspSettings._arrows[v17] then
                        J, v10 = false, EspSettings._arrows[v17]
                        v10.Visible = false
                    end
                    v17 = v17 + 1
                    if v17 > v11 then
                        break
                    end
                end
            end
        else
            v6 = 1
            v7 = #EspSettings._arrows
            if 1 <= v7 then
                while true do
                    if EspSettings._arrows[v6] then
                        EspSettings._arrows[v6].Visible = false
                    end
                    v6 = v6 + 1
                    if v6 > v7 then
                        break
                    end
                end
            end
        end
        v6, v7, v12 = pairs(EspRegistry)
        v6, v7, v12 = v1.g(v6, v7, v12)
        v17, v11 = v6(v7, v12)
        local v23, v24, v25, v26, v27, v28, v29, v30, v31, v32, v33, v34, v35, v36, leftLowerArm, v37, v38, v39, v40, v41, v42, v43, v44
        if v17 ~= nil then
            while true do
                s = v17.Character
                v10 = s and s:FindFirstChild("HumanoidRootPart")
                J = s and s:FindFirstChildOfClass("Humanoid")
                if v10 and J and J.Health > 0 then
                    v8 = isTeammate(v17)
                    if v8 and EspSettings.TeamCheckESP then
                        v11.Box.Visible = false
                        v11.FilledBox.Visible = false
                        v11.Tracer.Visible = false
                        v11.HealthBar.Visible = false
                        v11.Tag.Visible = false
                        v11.DistTag.Visible = false
                        v11.WeaponTag.Visible = false
                        v11.CurrentCham.Enabled = false
                        v11.CurrentGlowCham.Enabled = false
                        v13, v14, v19 = ipairs(SkeletonCache[v17])
                        v13, v14, v19 = v1.g(v13, v14, v19)
                        for _, n in v13, v14, v19 do
                            n.Visible = false
                        end
                    else
                        v13 = v4
                        v14 = v8 and Color3.fromRGB(0, 200, 200) or espColorMode
                        v19 = v8
                        if v19 then
                            v22, v19, n = 0, Color3.fromRGB, 255
                            v19 = v19(0, 255, 255)
                        end
                        if not v19 then
                            v19 = v5
                        end
                        v22 = v8
                        if v22 then
                            v21, v22, n = 255, Color3.fromRGB, 0
                            v22 = v22(0, 255, 255)
                        end
                        if not v22 then
                            n, v21 = EspSettings.EspGlowColorMode, "Rainbow"
                            n, v22, v21 = 0, Color3.fromRGB, 255
                            v22 = v22(0, 255, 255)
                        end
                        n = v2[3][1]
                        v21, n = n, n.WorldToViewportPoint
                        n, v21 = n(v21, v10.Position)
                        _, v18 = v2[3][1].CFrame.Position, v10.Position
                        v15 = v21
                        v9 = (_ - v18).Magnitude
                        if v15 then
                            v15 = v9 <= EspSettings.MaxEspDistance
                        end
                        if v15 then
                            v15 = v9 >= 1
                        end
                        if v15 then
                            v15 = EspSettings.BoxSizeMultiplier / v9
                            _ = v15 * 1.45
                            v18 = n.X - v15 / 2
                            v16 = n.Y - _ / 2
                            if EspSettings.EspBoxes then
                                v34 = UDim2.new
                                v11.Box.Position = v34(0, v18, 0, v16)
                                v34 = UDim2.new
                                v11.Box.Size = v34(0, v15, 0, _)
                                v34 = EspSettings.BoxThickness
                                v11.BoxStroke.Thickness = v34
                                v11.BoxStroke.Color = v13
                                v11.Box.Visible = true
                            else
                                v11.Box.Visible = false
                            end
                            if EspSettings.EspFilledBoxes then
                                v34 = UDim2.new
                                v11.FilledBox.Position = v34(0, v18, 0, v16)
                                v34 = UDim2.new
                                v11.FilledBox.Size = v34(0, v15, 0, _)
                                v11.FilledBox.BackgroundColor3 = v14
                                v34 = EspSettings.FilledBoxTransparency
                                v11.FilledBox.BackgroundTransparency = v34
                                v11.FilledBox.Visible = true
                            else
                                v11.FilledBox.Visible = false
                            end
                            if EspSettings.EspLines then
                                v20 = v2[3][1].ViewportSize
                                v34 = v20.X / 2
                                v23 = v20.Y
                                v40 = n.X
                                v40, v27 = n.Y, v40 - v34
                                v35 = v40 - v23
                                v40 = math.sqrt(v27 ^ 2 + v35 ^ 2)
                                v41 = math.atan2(v35, v27)
                                v42 = UDim2.new
                                v11.Tracer.Position = v42(0, v34 + v27 / 2, 0, v23 + v35 / 2)
                                v42 = UDim2.new
                                v11.Tracer.Size = v42(0, v40, 0, EspSettings.LineThickness)
                                v11.Tracer.BackgroundColor3 = v13
                                v42 = math.deg
                                v11.Tracer.Rotation = v42(v41)
                                v11.Tracer.Visible = true
                            else
                                v11.Tracer.Visible = false
                            end
                            if EspSettings.EspHealth then
                                v20 = math.clamp(J.Health / J.MaxHealth, 0, 1)
                                v23 = UDim2.new
                                v11.HealthBar.Position = v23(0, v18 - HEALTH_BAR_OFFSET - HEALTH_BAR_WIDTH, 0, v16)
                                v23 = UDim2.new
                                v11.HealthBar.Size = v23(0, HEALTH_BAR_WIDTH, 0, _)
                                v23 = UDim2.new
                                v11.HealthFill.Size = v23(1, 0, v20, 0)
                                v11.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50):Lerp(Color3.fromRGB(0, 255, 140), v20)
                                v11.HealthBar.Visible = true
                            else
                                v11.HealthBar.Visible = false
                            end
                            if EspSettings.EspNames then
                                v34 = UDim2.new
                                v27 = n.X
                                v11.Tag.Position = v34(0, v27, 0, v16 - 4)
                                v11.Tag.Text = v17.DisplayName
                                v11.Tag.TextSize = math.clamp(14 - v9 / 100, 10, 14)
                                v11.Tag.Visible = true
                            else
                                v11.Tag.Visible = false
                            end
                            if EspSettings.EspDistance then
                                v34 = UDim2.new
                                v27 = n.X
                                v11.DistTag.Position = v34(0, v27, 0, v16 + _ + 2)
                                v20 = v11.DistTag
                                v34 = string.format
                                v27 = math.floor
                                v27 = table.pack(v27(v9))
                                v20.Text = v34("%d Studs", table.unpack(v27, 1, v27.n))
                                v11.DistTag.TextSize = math.clamp(12 - v9 / 100, 9, 12)
                                v11.DistTag.Visible = true
                            else
                                v11.DistTag.Visible = false
                            end
                            if EspSettings.EspChams then
                                v11.CurrentCham:Destroy()
                                v20 = Instance.new("Highlight")
                                v20.Name = "NeonEngineStorage"
                                v20.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                v20.Parent = s
                                v11.CurrentCham = v20
                                v20 = EspSettings.ChamsBrightness
                                v35 = v19.G * v20
                                v40 = v19.B
                                v11.CurrentCham.FillColor = Color3.new(v19.R * v20, v35, v40 * v20)
                                v27 = v19.R * v20
                                v35 = v19.G * v20
                                v40 = v19.B
                                v11.CurrentCham.OutlineColor = Color3.new(v27, v35, v40 * v20)
                                if EspSettings.HighlightPulse then
                                    v29 = v17.UserId % 10
                                    v24 = EspSettings
                                    v42 = math
                                    v23 = math.sin((tick() + v29 * 0.4) * v24.HighlightPulseSpeed * v42.pi * 2) * 0.5 + 0.5
                                    v27 = v42.clamp(v24.HighlightPulseRange, 0, 0.95)
                                    v11.CurrentCham.FillTransparency = 0.2 + v23 * (v27 - 0.2)
                                    v11.CurrentCham.OutlineTransparency = 0 + v23 * v27 * 0.5
                                else
                                    v11.CurrentCham.FillTransparency = 0.2
                                    v11.CurrentCham.OutlineTransparency = 0
                                end
                                v11.CurrentCham.Enabled = true
                            end
                            if EspSettings.EspGlowChams then
                                v11.CurrentGlowCham:Destroy()
                                v20 = Instance.new("Highlight")
                                v20.Name = "GlowEngineStorage"
                                v20.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                v20.Parent = s
                                v11.CurrentGlowCham = v20
                                v20 = EspSettings.GlowBrightness
                                v34 = v11.CurrentGlowCham
                                v23 = Color3.new
                                v27 = math.clamp(v22.R * v20, 0, 1)
                                v35 = math.clamp(v22.G * v20, 0, 1)
                                v40 = math.clamp
                                v41 = v22.B * v20
                                v40 = table.pack(v40(v41, 0, 1))
                                v34.FillColor = v23(v27, v35, table.unpack(v40, 1, v40.n))
                                v11.CurrentGlowCham.OutlineColor = v22
                                if EspSettings.HighlightPulse then
                                    v29 = v17.UserId % 10
                                    v24 = EspSettings
                                    v42 = math
                                    v23 = math.sin((tick() + v29 * 0.4) * v24.HighlightPulseSpeed * v42.pi * 2) * 0.5 + 0.5
                                    v27 = v42.clamp(v24.HighlightPulseRange, 0, 0.95)
                                    v11.CurrentGlowCham.FillTransparency = 0.5 + v23 * (v27 - 0.5)
                                    v11.CurrentGlowCham.OutlineTransparency = v23 * v27 * 0.5
                                else
                                    v11.CurrentGlowCham.FillTransparency = 0.5
                                    v11.CurrentGlowCham.OutlineTransparency = 0
                                end
                                v11.CurrentGlowCham.Enabled = true
                            end
                            if EspSettings.EspEnemyWeapons then
                                v20 = getEnemyWeaponName(v17)
                                v35 = n.X
                                v23 = UDim2.new
                                v11.WeaponTag.Position = v23(0, v35, 0, v16 + _ + 14)
                                v11.WeaponTag.Text = "[" .. v20 .. "]"
                                v11.WeaponTag.TextSize = math.clamp(10 - v9 / 120, 8, 10)
                                v11.WeaponTag.Visible = true
                            else
                                v11.WeaponTag.Visible = false
                            end
                            if EspSettings.EspSkeleton then
                                v20 = {}
                                v34 = s:FindFirstChild("Head")
                                v23 = s:FindFirstChild("HumanoidRootPart") or s:FindFirstChild("Torso")
                                v27 = s:FindFirstChild("Left Arm") or s:FindFirstChild("LeftUpperArm")
                                v35 = s:FindFirstChild("Right Arm") or s:FindFirstChild("RightUpperArm")
                                v40 = s:FindFirstChild("Left Leg") or s:FindFirstChild("LeftUpperLeg")
                                v41 = s:FindFirstChild("Right Leg") or s:FindFirstChild("RightUpperLeg")
                                leftLowerArm = s:FindFirstChild("LeftLowerArm")
                                v42 = s:FindFirstChild("RightLowerArm")
                                v24 = s:FindFirstChild("LeftLowerLeg")
                                v29 = s:FindFirstChild("RightLowerLeg")
                                if v34 and v23 then
                                    v39 = table.insert
                                    v25 = {}
                                    v25[1], v25[2] = v34, v23
                                    v39(v20, v25)
                                    if v27 then
                                        v25 = {}
                                        v39 = table.insert
                                        v25[1], v25[2] = v23, v27
                                        v39(v20, v25)
                                    end
                                    if v35 then
                                        v25 = {}
                                        v39 = table.insert
                                        v25[1], v25[2] = v23, v35
                                        v39(v20, v25)
                                    end
                                    if v40 then
                                        v25 = {}
                                        v39 = table.insert
                                        v25[1], v25[2] = v23, v40
                                        v39(v20, v25)
                                    end
                                    if v41 then
                                        v39 = table.insert
                                        v25 = {}
                                        v25[1], v25[2] = v23, v41
                                        v39(v20, v25)
                                    end
                                    v25 = {}
                                    v39 = table.insert
                                    v25[1], v25[2] = v27, leftLowerArm
                                    v39(v20, v25)
                                    v25 = {}
                                    v39 = table.insert
                                    v25[1], v25[2] = v35, v42
                                    v39(v20, v25)
                                    v25 = {}
                                    v39 = table.insert
                                    v25[1], v25[2] = v40, v24
                                    v39(v20, v25)
                                    v39 = table.insert
                                    v25 = {}
                                    v25[1], v25[2] = v41, v29
                                    v39(v20, v25)
                                end
                                if not SkeletonCache[v17] then
                                    SkeletonCache[v17] = {}
                                end
                                v39 = SkeletonCache[v17]
                                while true do
                                    if #v39 < #v20 then
                                        v36, v25 = pcall(v1:Lf())
                                        if v36 and v25 then
                                            v25.Visible = false
                                            v25.Color = v13
                                            v25.Thickness = 1.5
                                            v25.Transparency = 1
                                            table.insert(v39, v25)
                                            continue
                                        end
                                        break
                                    end
                                    break
                                end
                                v36, v25, v38 = ipairs(v20)
                                v36, v25, v38 = v1.g(v36, v25, v38)
                                v37, v32 = v36(v25, v38)
                                v38 = v37
                                if v38 ~= nil then
                                    while true do
                                        v30 = v39[v37]
                                        if v30 then
                                            v31 = v2[3][1]
                                            v43 = v32[1]
                                            v31, v43, v26 = v31.WorldToViewportPoint, v43.Position, v31
                                            v31, v26 = v31(v26, v43)
                                            v43 = v2[3][1]
                                            v44 = v32[2]
                                            v43, v44, v28 = v43.WorldToViewportPoint, v44.Position, v43
                                            v43, v28 = v43(v28, v44)
                                            if v26 and v28 then
                                                v33 = v31.Y
                                                v30.From = Vector2.new(v31.X, v33)
                                                v33 = v43.Y
                                                v30.To = Vector2.new(v43.X, v33)
                                                v30.Color = v13
                                                v30.Visible = true
                                            else
                                                v30.Visible = false
                                            end
                                        end
                                        v37, v32 = v36(v25, v38)
                                        v38 = v37
                                        if v38 == nil then
                                            break
                                        end
                                    end
                                end
                                v36 = #v20 + 1
                                v25 = #v39
                                if v36 <= v25 then
                                    while true do
                                        if v39[v36] then
                                            v39[v36].Visible = false
                                        end
                                        v36 = v36 + 1
                                        if v36 > v25 then
                                            break
                                        end
                                    end
                                end
                            end
                            if EspSettings.HeadScale > 1 then
                                v20 = {[2] = 1, [1] = s:FindFirstChild("Head")}
                                v20[3] = v20
                                v34 = v20[1]
                                if v34 then
                                    v23 = v20[1]
                                    v34 = v20[1].IsA(v23, "BasePart")
                                end
                                if v34 then
                                    v23 = v20[1].Size
                                    OriginalHeadSizes[v20[1]] = v23
                                    pcall(v1:Kf({v20}))
                                end
                            end
                        else
                            v11.Box.Visible = false
                            v11.FilledBox.Visible = false
                            v11.Tracer.Visible = false
                            v11.HealthBar.Visible = false
                            v11.Tag.Visible = false
                            v11.DistTag.Visible = false
                            v11.WeaponTag.Visible = false
                        end
                    end
                else
                    v11.Box.Visible = false
                    v11.FilledBox.Visible = false
                    v11.Tracer.Visible = false
                    v11.HealthBar.Visible = false
                    v11.Tag.Visible = false
                    v11.DistTag.Visible = false
                    v11.WeaponTag.Visible = false
                end
                v17, v11 = v6(v7, v12)
                v12 = v17
                if v12 == nil then
                    break
                end
            end
        end
    end
end
local function _w14(v1, v2)
    return function(v3)
        local character
        if v2[1][1][v3] then
            return v2[1][1][v3]
        else
            character = v3.Character
            if character then
                character:FindFirstChildOfClass("Tool")
                v2[1][1][v3] = nil
            end
            return "—"
        end
    end
end
local function _w15(v1, v2)
    return function()
        local v3, v4, v5, v6, v7
        while true do
            task.wait(0.5)
            pcall(v1:Bf({
                v2[4],
                v2[6],
                v2[5],
                v2[2],
                v2[1],
                v2[3],
                v2[7],
            }))
            v5, v6, v7 = pairs(v2[4][1]._spheres)
            v5, v6, v7 = v1.g(v5, v6, v7)
            v4, v3 = v5(v6, v7)
            v7 = v4
            if v7 == nil then
                continue
            end
            while true do
                if v4.Parent then
                    v4, v3 = v5(v6, v7)
                    v7 = v4
                    if v7 == nil then
                        break
                    else
                        continue
                    end
                end
                v2[4][1]._spheres[v4] = nil
                v4, v3 = v5(v6, v7)
                v7 = v4
                if v7 == nil then
                    break
                end
            end
        end
    end
end
local function _w16(v1, v2)
    return function()
        local v3 = {equipped = {}, favorites = v2[4][1]}
        local v4, v5, v6
        v3, v6, v5, v4 = v2[3][1], v3, nil, nil
        v3, v5, v4 = v1.g(v3, nil, nil)
        local v7, v8
        v8, v7 = v3(v5, v4)
        local v9, v10, v11, v12, v13, v14
        if v8 ~= nil then
            while true do
                v13 = {}
                v6.equipped[v8] = v13
                v10, v14, v9 = v1.g(v7, nil, nil)
                v12, v11 = v10(v14, v9)
                v9 = v12
                if v9 ~= nil then
                    while true do
                        if v11 and v11.Name and not v2[1][1](v11.Name) then
                            v13[v12] = {name = v11.Name, seed = v11.Seed, inverted = v11.Inverted}
                        end
                        v12, v11 = v10(v14, v9)
                        v9 = v12
                        if v9 == nil then
                            break
                        end
                    end
                end
                v8, v7 = v3(v5, v4)
                v4 = v8
                if v4 == nil then
                    break
                end
            end
        end
        makefolder("SkinChanger")
        v4 = v2[2][1]
        v4, v8 = v4.JSONEncode, v4
        v4 = table.pack(v4(v8, v6))
        writefile("SkinChanger/config.json", table.unpack(v4, 1, v4.n))
    end
end
local function _w17(v1, v2)
    return function()
        v2[2][1]:EquipItem(v2[1][1]())
    end
end
local function _w18(v1, v2)
    return function()
        local v3 = v2[2][1]
        local v4
        v4, v3 = v3, v3.GetPlayers
        v3 = v1.h(v3(v4))
        local v5
        v5, v3, v4 = ipairs(v1.i(v3))
        v5, v3, v4 = v1.g(v5, v3, v4)
        local v6, v7
        v6, v7 = v5(v3, v4)
        if v6 ~= nil then
            while true do
                if not (v7 ~= v2[3][1] and v2[1][1](v7)) then
                    v6, v7 = v5(v3, v4)
                    v4 = v6
                    if v4 ~= nil then
                        continue
                    end
                    return false
                end
                break
            end
            return true
        end
        return false
    end
end
local function _w19(v1)
    return function(espBoxes)
        EspSettings.EspBoxes = espBoxes
    end
end
local function _w20(v1, v2)
    return function(name, v3, inverted, onlyUseFavorites)
        local v4, v5, clone
        if v2[2][1](name) then
            return nil
        else
            v4 = v2[3][1][name]
            if not v4 then
                return nil
            else
                clone = table.clone(v4)
                clone.Name = name
                clone.Type = clone.Type or v3
                clone.Seed = clone.Seed or math.random(1, 1000000)
                v5 = v2[1][1](name)
                if v5 then
                    clone.Enum = v5
                    clone.ObjectID = clone.ObjectID or v5
                end
                if inverted ~= nil then
                    clone.Inverted = inverted
                end
                if onlyUseFavorites ~= nil then
                    clone.OnlyUseFavorites = onlyUseFavorites
                end
                return clone
            end
        end
    end
end
local function _w21(v1, v2)
    return function()
        local r, _
        local character2 = v2[2][1].Character
        local head, humanoid, humanoidRootPart, v3, v4, magnitude, humanoidRootPart2, v5, character3, v6, position
        if not character2 then
            return nil
        else
            humanoidRootPart = character2:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then
                return nil
            else
                v4 = v2[1][1]
                v6 = 200
                v5 = nil
                v4, v3 = v4.GetPlayers, v4
                v4, v3 = v4(v3)
                _, v4, v3 = v1.g(next, v4, v3)
                for _, r in _, v4, v3 do
                    if r ~= v2[2][1] then
                        if r:GetAttribute("TeamID") ~= v2[2][1]:GetAttribute("TeamID") then
                            character3 = r.Character
                            if character3 then
                                humanoidRootPart2 = character3:FindFirstChild("HumanoidRootPart")
                                head = character3:FindFirstChild("Head")
                                humanoid = character3:FindFirstChildWhichIsA("Humanoid")
                                if humanoidRootPart2 and head and humanoid and humanoid.Health > 0 then
                                    position = humanoidRootPart2.Position
                                    magnitude = (humanoidRootPart.Position - position).Magnitude
                                    if magnitude < v6 then
                                        v5 = r
                                        v6 = magnitude
                                    end
                                end
                            end
                        end
                    end
                end
                return v5
            end
        end
    end
end
local function _w22(v1, v2)
    return function()
        while true do
            pcall(v2[2][1])
            pcall(v2[1][1])
            task.wait(0.5)
        end
    end
end
local function _w23(v1, v2)
    return function()
        local getFighter = v2[4][1]:GetFighter(v2[3][1])
        local v3 = getFighter
        if getFighter then
            v3 = getFighter.Items
        end
        local v4, name, v5, v6, v7, v8
        if v3 then
            v6 = v2[1][1]
            v6, v3, v4, v7 = getFighter.Items, v6[1], nil, nil
            v6, v7, v4 = v1.g(v6, nil, nil)
            v8, v5 = v6(v7, v4)
            v4 = v8
            if v4 ~= nil then
                while true do
                    if v5:Get("ObjectID") == v3 then
                        break
                    else
                        v8, v5 = v6(v7, v4)
                        v4 = v8
                        if v4 ~= nil then
                            continue
                        end
                    end
                    return
                end
                name = v5.Name
                v2[2][1] = name
            end
        end
    end
end
local function _w24(v1)
    return function()
        game()
    end
end
local function _w25(v1, v2)
    return function()
        local v3
        if v2[2][1].InfiniteJump.Enabled then
            v3 = v2[1][1]
            table.clear(v3._double_jumps_used)
        end
    end
end
local function _w26(v1)
    return function(v2)
        local split = string.split(v2, " - ")
        if #split >= 3 then
            return split[3]
        else
            return v2
        end
    end
end
local function _w27(v1, v2)
    return function(weatherType)
        v2[1][1].WeatherType = weatherType
        applyWeather()
    end
end
local function _w28(v1, v2)
    return function(v3)
        v2[2][1](v3)
        v2[1][1]._originalSizes[v3] = nil
    end
end
local function _w29(v1)
    return function(arrowESP)
        EspSettings.ArrowESP = arrowESP
    end
end
local function _w30(v1, v2)
    return function(walkSpeed)
        v2[1][1].WalkSpeed = walkSpeed
    end
end
local function _w31(v1, v2)
    return function(enabled)
        v2[1][1].Automation.AutoLoadout.Enabled = enabled
    end
end
local function _w32(v1, v2)
    return function()
        while true do
            if not task.wait(0.5) then
                break
            end
        end
    end
end
local function _w33(v1)
    return function()
        getgenv()._Dark_V12_EnemyWeapons.disable()
    end
end
local function _w34(v1, v2)
    return function(v3, v4, v9, ...)
        local v5 = {}
        local oldFunc = v2[4][1].Wallbang.OldFunc
        local v6 = v1.h(v4, v9, ...)
        oldFunc = v1.h(oldFunc(v3, v1.i(v6)))
        v1.j(v5, 1, v1.i(oldFunc))
        local v7 = v5
        local delay, v8
        if not v3.ClientFighter or not v3.ClientFighter.IsLocalPlayer then
            v5 = table.pack(unpack(v7))
            return table.unpack(v5, 1, v5.n)
        else
            v5 = v7[3]
            if not v5 or typeof(v5) ~= "table" then
                oldFunc = table.pack(unpack(v7))
                return table.unpack(oldFunc, 1, oldFunc.n)
            else
                v7[4] = true
                oldFunc = v2[3][1]()
                if not oldFunc or not oldFunc.Character then
                    return unpack(v7)
                else
                    oldFunc.Character:FindFirstChild("Head")
                    delay = task.delay
                    v8 = v2[1][1]
                    v2[4][1].Wallbang.Task = delay(0.15, v8)
                    v6 = table.pack(unpack(v7))
                    return table.unpack(v6, 1, v6.n)
                end
            end
        end
    end
end
local function _w35(v1, v2)
    return function()
        v2[1][1]:Destroy()
    end
end
local function _w36(v1, v2)
    return function()
        local viewModels = workspace:FindFirstChild("ViewModels")
        local v3, v4, character4, v5, v6, v7
        if viewModels then
            v7 = viewModels.GetChildren
            v7 = v1.h(v7(viewModels))
            character4, v7, v6 = ipairs(v1.i(v7))
            character4, v7, v6 = v1.g(character4, v7, v6)
            v3, v4 = character4(v7, v6)
            v6 = v3
            if v6 ~= nil then
                while true do
                    if not v4:IsA("Model") then
                        v3, v4 = character4(v7, v6)
                        v6 = v3
                        if v6 ~= nil then
                            continue
                        end
                        character4 = v2[1][1].Character
                        if character4 then
                            v6 = character4.GetChildren
                            v6 = v1.h(v6(character4))
                            v7, v6, v3 = ipairs(v1.i(v6))
                            v7, v6, v3 = v1.g(v7, v6, v3)
                            v4, v5 = v7(v6, v3)
                            v3 = v4
                            if v3 ~= nil then
                                while true do
                                    if not (v5:IsA("Model") and v5.Name:lower():find("view")) then
                                        v4, v5 = v7(v6, v3)
                                        v3 = v4
                                        if v3 ~= nil then
                                            continue
                                        end
                                        return nil
                                    end
                                    break
                                end
                                return v5
                            end
                        end
                        return nil
                    end
                    break
                end
                return v4
            end
        end
    end
end
local function _w37(v1, v2)
    return function()
        v2[1][1]:Destroy()
    end
end
local function _w38(v1, v2)
    return function()
        local c
        local v3, v4, character5, v5
        if not v2[2][1].ArmLatexEnabled then
            return
        else
            character5 = v2[1][1].Character
            if character5 then
                v3 = character5.GetDescendants
                v3 = v1.h(v3(character5))
                v4, v3, v5 = ipairs(v1.i(v3))
                v4, v3, v5 = v1.g(v4, v3, v5)
                for v6, c in v4, v3, v5 do
                    if c:IsA("BasePart") and c.Name:lower():find("arm") then
                        c.Material = Enum.Material.ForceField
                        c.Color = Color3.fromRGB(170, 170, 255)
                        c.Reflectance = 0.12
                    end
                end
                return
            end
        end
    end
end
local function _w39(v1, v2)
    return function()
        local v3 = v2[1][1]
        v3.Size = OriginalHeadSizes[v3] * EspSettings.HeadScale
        v3.Massless = true
        v3.CanCollide = false
    end
end
local function _w40(v1, v2)
    return function(teamTrigger)
        v2[1][1].Automation.SubspaceTripmines.TeamTrigger = teamTrigger
    end
end
local function _w41(v1, v2)
    return function(v3)
        v2[1][1][v3] = nil
    end
end
local function _w42(v1, v2)
    return function()
        v2[4][1]()
        if v2[3][1]._container then
            v2[3][1]._container.Visible = true
        end
        local v3, v4, v5
        if not v2[3][1]._conn then
            v5 = v2[3][1]
            v3 = v2[1][1]
            v4 = v1:Vd({v2[2]})
            v5._conn = v3.Heartbeat:Connect(v4)
        end
    end
end
local function _w43(v1, v2)
    return function(enabled)
        v2[1][1].Automation.AutoVote.Enabled = enabled
    end
end
local function _w44(v1, v2)
    return function()
        v2[1][1].Wallbang.Active = false
        v2[1][1].Wallbang.Target = nil
        local v3
        if v2[1][1].Wallbang.Conn then
            v3 = v2[1][1]
            v3.Wallbang.Conn:Disconnect()
            v3.Wallbang.Conn = nil
        end
        local v4
        if v2[1][1].Wallbang.Task then
            v3 = v2[1][1]
            v4 = v3.Wallbang.Task
            task.cancel(v4)
            v3.Wallbang.Task = nil
        end
    end
end
local function _w45(v1)
    return function()
        while true do
            pcall(applyBloomSettings)
            task.wait(2)
        end
    end
end
local function _w46(v1, v2)
    return function()
        v2[1][1].Parent = game:GetService("CoreGui")
    end
end
local function _w47(v1, v2)
    return function()
        v2[1][1]._screenGui:Destroy()
    end
end
local function _w48(v1, v2)
    return function(enabled)
        v2[2][1]:SetHandicapsEnabled(enabled)
        v2[3][1].AutoShoot.Enabled = enabled
        local v3 = v2[1][1]
        local v4 = {Title = "Auto Shoot (PC)"}
        local v5 = enabled
        if enabled then
            v5 = "Enabled!"
        end
        if not v5 then
            v5 = "Disabled!"
        end
        v4.Description = v5
        v4.Time = 2
        v3:Notify(v4)
    end
end
local function _w49(v1, v2)
    return function()
        local v3, v4, v5, cFrame, v6, v7, v8, v9, v10, v11, v12, vector3, v13, v14
        if not v2[4][1].Enabled then
            return
        else
            v2[9][1]()
            v6, v9, v12 = v2[8][1]()
            v8 = v9
            v11 = nil
            if v8 then
                v8 = v12
            end
            if v8 then
                if v2[2][1](v6) then
                    v10 = CFrame.new
                    v8 = (v9.CFrame * v10(0, 6, 0)).Position
                else
                    v10 = CFrame.new
                    v8 = (v9.CFrame * v10(0, 1, 2)).Position
                end
                v11 = CFrame.lookAt(v8, v12.Position)
            end
            if v11 and v2[1][1].Character then
                v8 = v2[1][1].Character
                v8, v7 = v8.FindFirstChild, v8
                v8 = {[2] = 1, [1] = v8(v7, "HumanoidRootPart")}
                v8[3] = v8
                if v8[1] then
                    v7 = {[2] = 1, [1] = v8[1].CFrame}
                    v7[3] = v7
                    v3 = {[2] = 1, [1] = v8[1].Velocity}
                    v3[3] = v3
                    v10 = {[2] = 1, [1] = v8[1].RotVelocity}
                    v10[3] = v10
                    v8[1].CFrame = v11
                    v14 = v1:de({v2[3], v10, v7, v8, v3})
                    v2[3][1]:BindToRenderStep("__ragebot_restore", 101, v14)
                end
            end
            if not (not v6 or not v12 or not v9) then
                v2[1][1].Character:FindFirstChild("HumanoidRootPart")
                v8 = v2[5][1].LocalFighter.EquippedItem
                if v8 then
                    if not (tick() - v2[6][1] < v2[4][1].FireRate) then
                        v7 = tick()
                        v7, v2[6][1] = v11, v7
                        v3 = v12.Position
                        v10 = CFrame.lookAt(v9.Position, v3)
                        cFrame = v12.CFrame
                        vector3 = Vector3.new((math.random() - 0.5) * 0.1, (math.random() - 0.5) * 0.1, (math.random() - 0.5) * 0.1)
                        v4 = v12.CFrame
                        v5 = CFrame.new
                        v5 = v1.h(v5(v3 + vector3))
                        v4 = v4:ToObjectSpace(v1.i(v5))
                        v14 = {}
                        v5 = utf8.char(1)
                        v13 = {}
                        v13[utf8.char(0)] = v2[7][1]:EncodeCFrame(v10)
                        v13[utf8.char(1)] = v2[7][1]:EncodeCFrame(cFrame)
                        v13[utf8.char(2)] = v12
                        v13[utf8.char(3)] = v2[7][1]:EncodeCFrame(v4)
                        v14[v5] = v13
                        v2[11][1].Remotes.Replication.Fighter.UseItem:FireServer(v8:Get("ObjectID"), require(v2[11][1].Modules.EnumLibrary):ToEnum("StartShooting"), v14, nil)
                    end
                    return
                end
            end
        end
    end
end
local function _w50(v1, v2)
    return function()
        local v3 = v1:Xe({v2[4], v2[3], v2[1], v2[2]})
        task.spawn(v3)
    end
end
local function _w51(v1, v2)
    return function()
        v2[4][1]:WaitForChild("Remotes"):WaitForChild("Replication"):WaitForChild("Fighter"):WaitForChild("SetControls"):FireServer(v2[3][1])
        local v3 = {
            Title = "Spoofer",
            Description = "Spoofed device controls to: " .. v2[2][1],
            Time = 2,
        }
        v2[1][1]:Notify(v3)
    end
end
local function _w52(v1, v2)
    return function()
        local weaponSlot = v2[1][1].WeaponSlot
        return v2[2][1][weaponSlot] or 3
    end
end
local function _w53(v1, v2)
    return function(tracerColor2)
        v2[1][1].TracerColor2 = tracerColor2
    end
end
local function _w54(v1, v2)
    return function()
        local v3
        while true do
            task.wait(1)
            if not v2[2][1].Enabled then
                continue
            end
            v3 = {[2] = 1, [1] = v2[3][1].LocalFighter}
            v3[3] = v3
            if not v3[1] then
                continue
            end
            pcall(v1:we({v2[1], v3}))
        end
    end
end
local function _w55(v1, v2)
    return function(v3, v4)
        local name2 = v3.Name
        local v5 = v3.ClientFighter and v3.ClientFighter.Player
        local v6 = v5 == v2[3][1] and name2 or nil
        local v7
        v7, v2[4][1] = v2[3][1], v6
        local v8, v9
        if v5 == v7 and v2[1][1][name2] and v2[1][1][name2].Skin and v4 then
            v7 = v2[1][1][name2]
            v8, v7, v9, v6 = "Data", v3.ToEnum, v3, v7.Skin
            v7 = v7(v9, "Data")
            if v4[v7] then
                v4[v7][v3:ToEnum("Skin")] = v6
                v4[v7][v3:ToEnum("Name")] = v6.Name
            end
        end
        v6 = v2[2][1](v3, v4)
        v2[4][1] = nil
        return v6
    end
end
local function _w56(v1)
    return function(position)
        local dark_TripmineGhost = Instance.new("Part")
        dark_TripmineGhost.Name = "Dark_TripmineGhost"
        dark_TripmineGhost.Anchored = true
        dark_TripmineGhost.CanCollide = false
        dark_TripmineGhost.CanQuery = false
        dark_TripmineGhost.CanTouch = false
        dark_TripmineGhost.CastShadow = false
        dark_TripmineGhost.Transparency = 1
        dark_TripmineGhost.Size = Vector3.new(1, 1, 1)
        dark_TripmineGhost.Position = position
        dark_TripmineGhost.Parent = workspace
        return dark_TripmineGhost
    end
end
local function _w57(v1, v2)
    return function()
        v2[1][1]._screenGui:Destroy()
    end
end
local function _w58(v1)
    return function(v2)
    end
end
local function _w59(v1, v2)
    return function()
        local v3 = workspace
        local v4
        v3, v4 = v3.GetDescendants, v3
        v3 = {[2] = 1, [1] = v3(v4)}
        v3[3] = v3
        local v5 = v1:sf({v2[2], v2[3], v2[1], v3})
        task.spawn(v5)
    end
end
local function _w60(v1, v2)
    return function()
        v2[1][1]:Destroy()
    end
end
local function _w61(v1, v2)
    return function(v3)
        local v4
        if v3:IsA("Frame") then
            task.wait(0.1)
            v4 = v2[1][1]
            pcall(v2[2][1], v4)
        end
    end
end
local function _w62(v1, v2)
    return function(v3)
        v2[1][1](v3)
    end
end
local function _w63(v1)
    return function(v2)
        local c
        local v3, v4, v5
        if EspRegistry[v2] then
            EspRegistry[v2].CurrentCham:Destroy()
            EspRegistry[v2].CurrentGlowCham:Destroy()
            v4, v3, v5 = pairs(EspRegistry[v2])
            v4, v3, v5 = v1.g(v4, v3, v5)
            for _, c in v4, v3, v5 do
                if typeof(c) == "Instance" then
                    c:Destroy()
                end
            end
            EspRegistry[v2] = nil
        end
        if SkeletonCache[v2] then
            v4, v3, v5 = ipairs(SkeletonCache[v2])
            v4, v3, v5 = v1.g(v4, v3, v5)
            for _, c in v4, v3, v5 do
                c = {[2] = 1, [1] = c}
                c[3] = c
                pcall(v1:Ye({c}))
            end
            SkeletonCache[v2] = nil
        end
    end
end
local function _w64(v1, v2)
    return function(firstWeapons)
        v2[1][1].Automation.AutoBan.FirstWeapons = firstWeapons
    end
end
local function _w65(v1, v2)
    return function(enabled)
        v2[1][1].Automation.HackerDetector.Enabled = enabled
    end
end
(function()
    local function v1(v2, v3, v4)
        if v3 > v4 then
            return
        end
        return v2[v3], v1(v2, v3 + 1, v4)
    end
    return function(v2)
        return v1(v2[1], 1, v2[2])
    end
end)()
local function _w67(v1, v2)
    return function()
        if not v2[1][1].viewModels then
            v2[1][1].viewModels = workspace:FindFirstChild("ViewModels")
        end
        return v2[1][1].viewModels
    end
end
local function _w68(v1, v2)
    return function(v3)
        local v4 = {}
        local autoPickupDrops = v2[1][1].Automation.AutoPickupDrops
        v4.Ammo = false
        v4.Health = false
        autoPickupDrops.Types = v4
        local v5
        autoPickupDrops, v5, v4 = ipairs(v3)
        autoPickupDrops, v5, v4 = v1.g(autoPickupDrops, v5, v4)
        local v6, v7
        v6, v7 = autoPickupDrops(v5, v4)
        if v6 ~= nil then
            while true do
                v2[1][1].Automation.AutoPickupDrops.Types[v7] = true
                v6, v7 = autoPickupDrops(v5, v4)
                v4 = v6
                if v4 == nil then
                    break
                end
            end
        end
    end
end
local function _w69(v1, v2)
    return function(v3)
        local team, myTeamID, team2, teamID, team3, v4
        if not TeamCheckState.Enabled then
            return false
        else
            myTeamID = teamCache.myTeamID
            teamID = v3:GetAttribute("TeamID")
            if myTeamID ~= nil and teamID ~= nil and myTeamID ~= 0 and teamID ~= 0 and myTeamID == teamID then
                return true
            else
                v4 = v2[1][1]
                v4, team2 = v3.Team, v4.Team
                if team2 and v4 and team2 == v4 then
                    return true
                else
                    team3 = v2[1][1]:GetAttribute("Team")
                    team = v3:GetAttribute("Team")
                    if team3 and team and team3 == team then
                        return true
                    else
                        return false
                    end
                end
            end
        end
    end
end
local function _w70(v1, v2)
    return function(v3)
        local v4 = {[2] = 1, [1] = v2[1][1]._spheres[v3]}
        v4[3] = v4
        if v4[1] then
            pcall(v1:fe({v4}))
            v2[1][1]._spheres[v3] = nil
        end
    end
end
local function _w71(v1, v2)
    return function()
        local v3 = v2[1][1]
        local v4
        v3, v4 = v3.WaitForChild, v3
        v3 = table.pack(v3(v4, "FighterController", 10))
        local v5 = require(table.unpack(v3, 1, v3.n))
        v2[2][1] = v5
    end
end
local function _w72(v1, v2)
    return function(jumpPower)
        v2[1][1].JumpPower = jumpPower
    end
end
local function _w73(v1, v2)
    return function(weaponSlot)
        v2[1][1].WeaponSlot = weaponSlot
    end
end
local function _w74(v1, v2)
    return function()
        while true do
            if not task.wait(2) then
                break
            end
        end
    end
end
local function _w75(v1, v2)
    return function()
        local v3 = v2[4][1]
        local v4
        v3, v4 = v3.GetPlayers, v3
        v3 = v1.h(v3(v4))
        local v5
        v5, v3, v4 = ipairs(v1.i(v3))
        v5, v3, v4 = v1.g(v5, v3, v4)
        local v6, v7
        v7, v6 = v5(v3, v4)
        local v8, v9, size2, character6, humanoidRootPart3
        if v7 ~= nil then
            while true do
                if v6 ~= v2[6][1] and v6.Character then
                    character6 = v6.Character
                    v8 = isTeammate(v6)
                    if v2[5][1].Enabled and not v8 then
                        humanoidRootPart3 = character6:FindFirstChild("HumanoidRootPart")
                        v9 = humanoidRootPart3
                        if v9 then
                            size2 = v2[5][1].Size
                            v9 = humanoidRootPart3.Size.X < size2 - 0.1
                        end
                        if v9 then
                            v2[2][1](character6)
                        end
                    end
                    if v2[1][1].Enabled and not v8 then
                        v2[3][1](character6)
                    end
                end
                v7, v6 = v5(v3, v4)
                v4 = v7
                if v4 == nil then
                    break
                end
            end
        end
    end
end
(function()
    local v1, v2, v3 = type, getmetatable, pairs
    return function(v4, v5, v6)
        if v1(v4) ~= "function" then
            local v7 = v2(v4)
            if v7 ~= nil and v7.__iter ~= nil then
                return v7.__iter(v4)
            elseif (v7 and v7.__call) == nil and v1(v4) == "table" then
                return v3(v4)
            end
        end
        return v4, v5, v6
    end
end)()
local function _w77(v1, v2)
    return function()
        if not (not readfile or not isfile or not isfile("SkinChanger/config.json")) then
            pcall(v1:Re({v2[4], v2[3], v2[5], v2[2], v2[1]}))
            return
        end
    end
end
local function _w78(v1)
    return function()
        return game.HttpService
    end
end
local function _w79(v1, v2)
    return function()
        local v3 = require(v2[1][1].Modules.ClientReplicatedClasses.ClientEntity)
        v2[2][1] = v3
    end
end
local function _w80(v1, v2, v3, ...)
    return v1:k()(v2, v3, ...)
end
local function _w81(v1, v2)
    return function(thirdpersonDistance)
        local v3 = v2[1][1]
        v3.ThirdpersonDistance = thirdpersonDistance
        v3 = v3.ThirdpersonEnabled
        if v3 then
            applyThirdperson()
        end
    end
end
local function _w82(v1, v2)
    return function(thirdpersonActivation)
        v2[1][1].ThirdpersonActivation = thirdpersonActivation
    end
end
local function _w83(v1, v2)
    return function(v3)
        v3 = {[2] = 1, [1] = v3}
        v3[3] = v3
        local v4 = {[2] = 1, [1] = v2[2][1][v3[1]]}
        v4[3] = v4
        if v4[1] then
            pcall(v1:ff({v2[3], v3, v4, v2[1]}))
        end
    end
end
local function _w84(v1, v2)
    return function(v3, v4)
        local v5, v6
        v5, v6, v4 = pairs, v3, v4 or 1
        local v7
        v5, v6, v7 = v5(v6)
        v5, v6, v7 = v1.g(v5, v6, v7)
        local v8, v9
        v8, v9 = v5(v6, v7)
        if v8 ~= nil then
            while true do
                v2[2][1]:Create(v2[1][1], TweenInfo.new(v4, Enum.EasingStyle.Linear), {[v8] = v9}):Play()
                v8, v9 = v5(v6, v7)
                v7 = v8
                if v7 == nil then
                    break
                end
            end
        end
    end
end
local function _w85(v1, v2)
    return function()
        local v3, v4, getFighter2, v5, v6, items
        if v2[2][1] then
            getFighter2 = v2[2][1]:GetFighter(v2[1][1])
            if not (not getFighter2 or not getFighter2.Items) then
                items = getFighter2.Items
                items, v4, v5 = v1.g(items, nil, nil)
                v3, v6 = items(v4, v5)
                v5 = v3
                if v5 ~= nil then
                    while true do
                        if not v6.IsEquipped then
                            v3, v6 = items(v4, v5)
                            v5 = v3
                            if v5 ~= nil then
                                continue
                            end
                            return nil
                        end
                        break
                    end
                    return v6.Name
                end
            end
        end
        return nil
    end
end
local function _w86(v1)
    return function(maxEspDistance)
        EspSettings.MaxEspDistance = maxEspDistance
    end
end
local function _w87(v1, v2)
    return function(v3)
        local v4 = {[2] = 1, [1] = v2[1][1]._labels[v3]}
        v4[3] = v4
        local v5
        if v4[1] then
            v2[1][1]._labels[v3] = nil
            v5 = v2[1][1]
            v5._labelCount = v5._labelCount - 1
        end
    end
end
local function _w88(v1)
    return function(espChamsColorMode)
        EspSettings.EspChamsColorMode = espChamsColorMode
    end
end
local function _w89(v1)
    return function(espFilledBoxes)
        EspSettings.EspFilledBoxes = espFilledBoxes
    end
end
local function _w90(v1, v2)
    return function()
        local v3, v4, v5, v6, new, v7, colorSequenceKeypoint
        while true do
            if v2[2][1] and v2[2][1].Parent then
                v5 = v2[1][1] + 0.01
                v5, v2[1][1] = Color3, v5 % 1
                v5, v6, v3 = v2[1][1], 1, v5.fromHSV
                v3 = v3(v5, 1, 1)
                v5 = v2[2][1]
                new = ColorSequence.new
                v6 = {}
                colorSequenceKeypoint = ColorSequenceKeypoint.new(0, v3)
                v7 = ColorSequenceKeypoint.new
                v4 = Color3.fromRGB
                v4 = table.pack(v4(255, 255, 255))
                v7 = table.pack(v7(1, table.unpack(v4, 1, v4.n)))
                v6[1] = colorSequenceKeypoint
                v1.j(v6, 2, table.unpack(v7, 1, v7.n))
                v5.Color = new(v6)
                task.wait(0.05)
                continue
            end
            break
        end
    end
end
local function _w91(v1, v2)
    return function(hideFlashbang)
        v2[1][1].HideFlashbang = hideFlashbang
    end
end
local function _w92(v1)
    return function()
        pcall(v1:ye())
        pcall(v1:xe())
        pcall(v1:ze())
        pcall(v1:Ae())
    end
end
local function _w93(v1, v2)
    return function()
        local v3 = v2[4][1]
        local v4 = v1.h(readfile("SkinChanger/config.json"))
        v3 = v3:JSONDecode(v1.i(v4))
        local v5, v6, v7, name3, v8, v9, v10, v11, v12, v13, v14
        if v3.equipped then
            v8 = v3.equipped
            v8, v4, v9 = v1.g(v8, nil, nil)
            v6, v7 = v8(v4, v9)
            v9 = v6
            if v9 ~= nil then
                while true do
                    v2[3][1][v6] = {}
                    v10, v14, v11 = v1.g(v7, nil, nil)
                    v5, v12 = v10(v14, v11)
                    v11 = v5
                    if v11 ~= nil then
                        while true do
                            name3 = v12.name
                            if not v2[5][1](name3) then
                                v13 = v2[2][1](v12.name, v5, v12.inverted)
                                v13.Seed = v12.seed
                                v2[3][1][v6][v5] = v13
                            end
                            v5, v12 = v10(v14, v11)
                            v11 = v5
                            if v11 == nil then
                                break
                            end
                        end
                    end
                    v6, v7 = v8(v4, v9)
                    v9 = v6
                    if v9 == nil then
                        break
                    end
                end
            end
        end
        v8 = v3.favorites or {}
        v2[1][1] = v8
    end
end
local function _w94(v1, v2)
    return function()
        local v3
        if isfile("darkrivals_executions.txt") then
            v3 = tonumber(readfile("darkrivals_executions.txt")) or 0
            v2[1][1] = v3
        end
        local v4 = v2[1][1] + 1
        local v5
        v5, v3, v4, v2[1][1] = tostring, "darkrivals_executions.txt", writefile, v4
        local v6 = v2[1][1]
        v5 = table.pack(v5(v6))
        v4("darkrivals_executions.txt", table.unpack(v5, 1, v5.n))
    end
end
local function _w95(v1, v2)
    return function()
        local v3 = v2[3][1]
        v2[2][1]:FireServer(v3)
        v2[1][1]:FireServer(v3)
    end
end
local function _w96(v1, v2)
    return function()
        local v3 = v2[4][1]
        v3.CFrame = v2[3][1]
        v3.Velocity = v2[5][1]
        v3.RotVelocity = v2[2][1]
        v2[1][1]:UnbindFromRenderStep("__restore")
    end
end
local function _w97(v1, v2)
    return function()
        v2[1][1]:FireServer()
    end
end
local function _w98(v1, v2)
    return function()
        local fOVOverrideValue
        if v2[2][1].FOVOverrideEnabled then
            fOVOverrideValue = v2[2][1].FOVOverrideValue
            v2[3][1].FieldOfView = fOVOverrideValue
        else
            v2[3][1].FieldOfView = v2[1][1]
        end
    end
end
local function _w99(v1, v2)
    return function()
        local character7 = v2[2][1].Character
        local v3 = character7
        if character7 then
            v3 = character7:FindFirstChildWhichIsA("Humanoid")
        end
        local v4 = v3
        if v3 then
            v4 = v3.Jump
        end
        if v4 then
            v4 = character7:FindFirstChild("HumanoidRootPart")
        end
        local v5, jumpPower, v6
        if v4 then
            v5 = character7.HumanoidRootPart.Velocity.X
            jumpPower = v2[1][1].JumpPower
            v6 = character7.HumanoidRootPart.Velocity.Z
            character7.HumanoidRootPart.Velocity = Vector3.new(v5, jumpPower, v6)
        end
    end
end
local function _w100(v1, v2)
    return function(enabled)
        v2[1][1].Enabled = enabled
        if not enabled then
            restoreAllHitboxes()
        end
    end
end
local function _w101(v1, v2)
    return function()
        v2[2][1]:Destroy()
        v2[3][1]:Destroy()
        v2[1][1]:Destroy()
    end
end
local function _w102(v1, v2)
    return function(tracerColor1)
        v2[1][1].TracerColor1 = tracerColor1
    end
end
local function _w103(v1, v2)
    return function()
        v2[4][1](false)
        v2[9][1](false)
        v2[8][1](false)
        v2[14][1](false)
        v2[1][1](false)
        v2[3][1](false)
        v2[12][1](false)
        v2[5][1](false)
        v2[6][1](false)
        v2[7][1](false)
        v2[11][1](false)
        pcall(v1:ke())
        pcall(v1:oe())
        pcall(v1:pe())
        pcall(v1:qe())
        pcall(v1:le())
        pcall(v1:me())
        v2[10][1]()
        local v3, v4, v5
        v3, v5, v4 = ipairs(v2[13][1])
        v3, v5, v4 = v1.g(v3, v5, v4)
        local v6, v7
        v7, v6 = v3(v5, v4)
        if v7 ~= nil then
            while true do
                v6 = {[2] = 1, [1] = v6}
                v6[3] = v6
                pcall(v1:ne({v6}))
                v7, v6 = v3(v5, v4)
                v4 = v7
                if v4 == nil then
                    break
                end
            end
        end
        v2[2][1]:Unload()
    end
end
local function _w104(v1, v2)
    return function()
        v2[1][1]:Destroy()
    end
end
local function _w105(v1)
    return function(lineThickness)
        EspSettings.LineThickness = lineThickness
    end
end
local function _w106(v1, v2)
    return function()
        v2[1][1]:Destroy()
    end
end
local function _w107(v1, v2)
    return function()
        local f, _
        local equippedItem, v3, v4, player, objects
        if not (not v2[2][1] or not v2[2][1].Objects) then
            objects = v2[2][1].Objects
            objects, v4, f = v1.g(objects, nil, nil)
            for f, _ in objects, v4, f do
                player = _.Player
                if player then
                    _.Entity:IsAlive()
                    _:Get("IsSpectating")
                    equippedItem = _.EquippedItem
                    v3 = false
                    if equippedItem and equippedItem.ViewModel and equippedItem.ViewModel.Name == "Katana" then
                        v3 = equippedItem._attack_cooldown and equippedItem._attack_cooldown > tick() or false
                    end
                    v2[1][1][player] = v3
                end
            end
            return
        end
    end
end
local function _w108(v1, v2)
    return function()
        if writefile then
            pcall(v1:Jf({v2[4], v2[3], v2[1], v2[2]}))
            return
        end
    end
end
local function _w109(v1)
    return function(v2)
        EspSettings.HighlightPulseSpeed = v2 / 10
    end
end
local function _w110(v1, v2)
    return function()
        local darkWeatherPart = workspace:FindFirstChild("DarkWeatherPart")
        if darkWeatherPart then
            darkWeatherPart:Destroy()
        end
        local darkWeatherPart2
        if v2[1][1].WeatherType ~= "None" then
            darkWeatherPart2 = Instance.new("Part")
            darkWeatherPart2.Name = "DarkWeatherPart"
            darkWeatherPart2.Anchored = true
            darkWeatherPart2.CanCollide = false
            darkWeatherPart2.Size = Vector3.new(1000, 1, 1000)
            darkWeatherPart2.Position = Vector3.new(0, 100, 0)
            darkWeatherPart2.Transparency = 0.5
            if v2[1][1].WeatherType == "Rain" then
                darkWeatherPart2.Material = Enum.Material.Glass
                darkWeatherPart2.Color = Color3.fromRGB(170, 170, 255)
            end
            darkWeatherPart2.Parent = workspace
            return
        end
    end
end
local function _w111(v1, v2)
    return function(v3)
        local v4, v5
        if v3 then
            v4 = {[2] = 1, [1] = v3:FindFirstChild("HumanoidRootPart")}
            v4[3] = v4
            if v4[1] then
                v5 = {[2] = 1, [1] = v2[1][1]._originalSizes[v3]}
                v5[3] = v5
                if v5[1] then
                    pcall(v1:ge({v5, v4}))
                    v2[1][1]._originalSizes[v3] = nil
                end
            end
            return
        end
    end
end
local function _w112(v1, v2)
    return function()
        v2[2][1]("WeaponInventory")
        task.wait(0.2)
        v2[1][1]()
    end
end
local function _w113(v1)
    return function(spoofed_enemy_names)
        getgenv().NameSpooferConfig.spoofed_enemy_names = spoofed_enemy_names
    end
end
local function _w114(v1, v2)
    return function()
        if v2[2][1].LeaveQueue then
            v2[2][1]:LeaveQueue()
        end
        task.wait(0.2)
        local queue
        if v2[2][1].QueueInto then
            queue = v2[1][1].Automation.AutoQueue.Queue
            v2[2][1]:QueueInto(queue)
        end
    end
end
local function _w115(v1)
    return function()
        local new2 = Drawing.new
        local pack = table.pack(new2("Line"))
        return table.unpack(pack, 1, pack.n)
    end
end
local function _w116(v1, v2)
    return function(perMap)
        v2[1][1].Automation.AutoLoadout.PerMap = perMap
    end
end
local function Of(v1, v2, v3, v4, v9, ...)
    local v5 = 0
    local v6 = v1
    local v7 = #v2
    local v8 = v7 - 1
    if 0 <= v8 then
        while true do
            v6[v2[(100169 * v5 + 18361) % v7 + 1]] = v6[v5 + 1]
            v5 = v5 + 1
            if v5 > v8 then
                break
            end
        end
    end
    v5 = v1[v3]
    v5 = table.pack(v5(v1, v4, v9, ...))
    return table.unpack(v5, 1, v5.n)
end
local function _w118(v1)
    return function(chamsBrightness)
        EspSettings.ChamsBrightness = chamsBrightness
    end
end
local function _w119(v1, v2)
    return function()
        while true do
            if not task.wait(0.1) then
                break
            end
        end
    end
end
local function _w120(v1, v2)
    return function()
        local v3 = v2[3][1]
        v2[2][1]:FireServer(v3)
        v2[1][1]:FireServer(v3)
    end
end
local function _w121(v1)
    return function(highlightPulse)
        EspSettings.HighlightPulse = highlightPulse
    end
end
local function _w122(v1, v2)
    return function()
        local v3 = v2[1][1]
        local v4
        v3, v4 = v3.GetDescendants, v3
        v3 = v1.h(v3(v4))
        local v5
        v5, v3, v4 = ipairs(v1.i(v3))
        v5, v3, v4 = v1.g(v5, v3, v4)
        local v6, v7
        v6, v7 = v5(v3, v4)
        if v6 ~= nil then
            while true do
                if not v7:IsA("BloomEffect") then
                    v6, v7 = v5(v3, v4)
                    v4 = v6
                    if v4 ~= nil then
                        continue
                    end
                    return nil
                end
                break
            end
            return v7
        end
        return nil
    end
end
local function _w123(v1, v2)
    return function()
        v2[2][1]:FireServer(v2[1][1])
    end
end
local function _w124(v1, v2)
    return function()
        v2[1][1]:Remove()
    end
end
local function _w125(v1, v2)
    return function(visible)
        v2[1][1].KeybindFrame.Visible = visible
    end
end
local function _w126(v1, v2)
    return function(enabled)
        v2[2][1].tripmine.Enabled = enabled
        local v3, v4
        if enabled then
            getgenv()._Dark_V12_Tripmine.enable()
            v4 = {}
            v3 = v2[1][1]
            v4.Title = "Tripmine ESP"
            v4.Description = "Enabled - scanning for traps!"
            v4.Time = 3
            v3:Notify(v4)
        else
            getgenv()._Dark_V12_Tripmine.disable()
            v2[1][1]:Notify({Title = "Tripmine ESP", Description = "Disabled", Time = 3})
        end
    end
end
local function _w127(v1, v2)
    return function(hideSmoke)
        v2[1][1].HideSmoke = hideSmoke
    end
end
local function _w128(v1, v2)
    return function(v3, v4, v13, ...)
        local v5, onlyUseFavorites, v6, isInverted, v7, v8, v9, v10, v11, v12
        if getnamecallmethod() ~= "FireServer" then
            v6 = v2[4][1]
            v6 = table.pack(v6(v3, v4, v13, ...))
            return table.unpack(v6, 1, v6.n)
        else
            v10 = v1.h(v4, v13, ...)
            v8 = {}
            v1.j(v8, 1, v1.i(v10))
            v6 = {[2] = 1, [1] = v8}
            v6[3] = v6
            if v2[9][1] and v3 == v2[9][1] and v2[8][1] then
                pcall(v1:Ie({v6, v2[14], v2[1], v2[8]}))
            end
            if v3 == v2[3][1] then
                v11 = v6[1][3]
                v10 = v6[1][2]
                v8 = v6[1][1]
                v9 = v6[1][4] or {}
                if not v11 or v11 == "None" or v11 == "" then
                    v7 = v2[15][1]
                    v7[v8] = v7[v8] or {}
                    v2[15][1][v8][v10] = nil
                    v2[15][1][v8] = nil
                    v2[5][1]()
                    task.defer(v1:He({v2[6], v2[7]}))
                    v7 = v2[4][1]
                    v7 = table.pack(v7(v3, v4, v13, ...))
                    return table.unpack(v7, 1, v7.n)
                else
                    v2[16][1](v11)
                    v12 = v2[13][1]
                    v7 = v2[10][1](v12, "CosmeticInventory")
                    if v7 and type(v7[v11]) ~= "boolean" and v7[v11] ~= nil then
                        v12 = v2[4][1]
                        v12 = table.pack(v12(v3, v4, v13, ...))
                        return table.unpack(v12, 1, v12.n)
                    else
                        v12 = v2[15][1]
                        v12[v8] = v12[v8] or {}
                        isInverted = v9.IsInverted
                        onlyUseFavorites = v9.OnlyUseFavorites
                        v2[2][1](v11, v10, isInverted, onlyUseFavorites)
                        if v10 == "Finisher" then
                            v2[12][1][v8] = v11
                        end
                        v2[5][1]()
                        v5 = v1:Je({v2[6], v2[7]})
                        task.defer(v5)
                        return
                    end
                end
            else
                v8 = v2[4][1]
                v11 = table.pack(v4, v13, ...)
                v8 = table.pack(v8(v3, table.unpack(v11, 1, v11.n)))
                return table.unpack(v8, 1, v8.n)
            end
        end
    end
end
local function _w129(v1, v2)
    return function(v3)
        v2[1][1].Transparency = v3 / 100
    end
end
local function _w130(v1, v2)
    return function()
        return v2[1][1].Automation.AntiKatana.Enabled
    end
end
local function _w131(v1)
    return function()
        getgenv()._Dark_V12_EnemyWeapons.destroyContainer()
    end
end
local function _w132(v1, v2)
    return function(worldColorName)
        local v3 = v2[1][1]
        v3.WorldColorName = worldColorName
        v3 = v3.WorldColorEnabled
        if v3 then
            applyWorldColor()
        end
    end
end
local function _w133(v1, v2)
    return function(enabled)
        v2[1][1].Automation.AntiKatana.Enabled = enabled
    end
end
local function _w134(v1, v2)
    return function()
        v2[1][1]:Disconnect()
    end
end
local function _w135(v1, v2)
    return function()
        local v3 = v2[2][1]
        local v4 = {[2] = 1, [1] = v3.enemyWeapons}
        v4[3] = v4
        v3 = {[2] = 1, [1] = v3}
        v3[3] = v3
        v3[1] = v1:Rd()
        local v5 = {[2] = 1, [1] = nil}
        v5[3] = v5
        v5[1] = v1:Qd()
        local v6 = {[2] = 1, [1] = nil}
        v6[3] = v6
        local v7
        v7, v6[1] = v1:Ud({v4}), v1:Td({v2[3], v4})
        local v8 = {[2] = 1, [1] = nil}
        v8[3] = v8
        v8[1] = v1:Sd({v2[3], v3, v5, v4})
        local v9 = v1:Pd({v4})
        local v10 = {}
        v10.enable = v1:Od({v2[1], v8, v4, v6})
        v10.disable = v9
        v10.destroyContainer = v7
        return v10
    end
end
local function _w136(v1)
    return function(winstreak_spoof)
        getgenv().NameSpooferConfig.winstreak_spoof = winstreak_spoof
    end
end
local function _w137(v1, v2)
    return function()
        while true do
            if not task.wait(0.4) then
                break
            end
        end
    end
end
local function _w138(v1, v2)
    return function(v3)
        local v4, v5, v6
        v4, v6, v5 = v3:gmatch("[^,]+")
        v4, v6, v5 = v1.g(v4, v6, v5)
        local v7 = v4(v6, v5)
        local v8 = {}
        local v9, v10, v11, v12, insert
        if v7 ~= nil then
            while true do
                insert = table.insert
                v11 = v7:gsub("^%s+", "")
                v9, v11, v10, v12 = "%s+$", v11.gsub, v11, ""
                insert(v8, v11(v10, "%s+$", ""))
                v7 = v4(v6, v5)
                v5 = v7
                if v5 == nil then
                    break
                end
            end
        end
        v2[1][1].Automation.ModDetector.ModFriends = v8
    end
end
local function _w139(v1, v2)
    return function()
        local v3 = v2[2][1]
        local v4 = {[2] = 1, [1] = v3.tripmine}
        v4[3] = v4
        v3 = {[2] = 1, [1] = v3}
        v3[3] = v3
        v3[1] = v1:of()
        local v5 = {[2] = 1, [1] = nil}
        v5[3] = v5
        v5[1] = v1:nf()
        local v6 = {[2] = 1, [1] = nil}
        v6[3] = v6
        v6[1] = v1:kf()
        local v7 = {[2] = 1, [1] = nil}
        v7[3] = v7
        v7[1] = v1:if_({v4})
        local v8 = {[2] = 1, [1] = nil}
        v8[3] = v8
        v8[1] = v1:jf({v5, v6, v2[3], v4})
        local v9 = {[2] = 1, [1] = nil}
        v9[3] = v9
        v9[1] = v1:hf({v7, v4})
        local v10 = {[2] = 1, [1] = nil}
        v10[3] = v10
        v10[1] = v1:lf({v4, v3, v8})
        local v11 = v1:mf({v7, v4})
        local v12 = {}
        v12.enable = v1:pf({v2[1], v3, v9, v4, v8, v10})
        v12.disable = v11
        return v12
    end
end
local function _w140(v1, v2)
    return function()
        local v3 = v2[3][1]
        local v4 = v2[1][1]
        local v5 = v2[2][1]
        v5(v3, v4, 0)
        v5(v3, v4, 1)
    end
end
local function _w141(v1, v2)
    return function()
        local v3 = v2[2][1]
        local v4 = v2[1][1]
        local size3 = v4.Size
        local v5 = v4
        v4, v5 = v5.Size, v5.Size
        v3.Size = Vector3.new(size3, v4, v5)
        v3.Transparency = v2[1][1].Transparency
        v3.CanCollide = false
    end
end
local function _w142(v1, v2)
    return function(v3)
        v2[1][1].Transparency = v3 / 100
    end
end
local function _w143(v1, v2)
    return function()
        while true do
            if not task.wait(1) then
                break
            end
        end
    end
end
local function _w144(v1, v2)
    return function()
        if v2[1][1]._screenGui then
            pcall(v1:_e({v2[1]}))
        end
        local v3 = v2[1][1]
        v3._screenGui = nil
        v3._container = nil
        v3._labels = {}
    end
end
local function _w145(v1, v2)
    return function()
        local character8 = v2[2][1].Character
        local v3 = character8
        if character8 then
            v3 = character8:FindFirstChild("HumanoidRootPart")
        end
        local v4 = character8
        if character8 then
            v4 = character8:FindFirstChildWhichIsA("Humanoid")
        end
        local v5 = v3
        if v3 then
            v5 = v4
        end
        local speed
        if v5 then
            v3.Velocity = Vector3.new(0, 0, 0)
            v5 = Vector3.new(0, 0, 0)
            if v4.MoveDirection.Magnitude > 0 then
                v5 = v4.MoveDirection
            end
            if v2[3][1]:IsKeyDown(Enum.KeyCode.Space) then
                v5 = v5 + Vector3.new(0, 1, 0)
            else
                v2[3][1]:IsKeyDown(Enum.KeyCode.LeftShift)
            end
            speed = v2[1][1].Fly.Speed
            v3.CFrame = v3.CFrame + v5 * (speed / 100)
        end
    end
end
local function _w146(v1, v2)
    return function(showCustomCursor)
        v2[1][1].ShowCustomCursor = showCustomCursor
    end
end
local function _w147(v1, v2)
    return function(v3)
        if v3:IsA("BasePart") and v2[2][1](v3) and not v2[3][1]._labels[v3] then
            v2[1][1](v3)
        end
    end
end
local function _w148(v1)
    return function()
        if EspGui then
            EspGui:Destroy()
        end
    end
end
local function _w149(v1)
    return function(espSkeleton)
        EspSettings.EspSkeleton = espSkeleton
    end
end
local function _w150(v1)
    return function(espColorMode)
        EspSettings.EspColorMode = espColorMode
    end
end
local function _w151(v1, v2)
    return function(v3)
        v3 = {[2] = 1, [1] = v3}
        v3[3] = v3
        if v2[2][1].Wallbang.Conn then
            v2[2][1].Wallbang.Conn:Disconnect()
        end
        v2[2][1].Wallbang.Active = true
        local v4 = v2[2][1]
        v4.Wallbang.Target = v3[1]
        v4.Wallbang.Conn = v2[3][1].Heartbeat:Connect(v1:Ce({v3, v2[3], v2[1], v2[2]}))
    end
end
local function _w152(v1, v2)
    return function()
        v2[1][1]:SetAttribute("Level", getgenv().NameSpooferConfig.spoofed_level)
    end
end
local function _w153(v1, v2)
    return function(worldColorEnabled)
        v2[1][1].WorldColorEnabled = worldColorEnabled
        applyWorldColor()
    end
end
local function _w154(v1, v2)
    return function()
        pcall(v2[1][1])
    end
end
local function _w155(v1, v2)
    return function()
        local v3
        if not v2[2][1] then
            v3 = v2[3][1]()
            v2[2][1] = v3
        end
        local v4, v5
        if v2[2][1] then
            v3 = v2[2][1]
            v4 = v2[1][1]
            v3.Enabled = v4.BloomEnabled
            v4, v5 = v4.BloomIntensity, 10
            v3.Intensity = v4 / 10
        end
    end
end
local function _w156(v1)
    return function()
        getgenv()._Dark_V12_Tripmine.disable()
    end
end
local function h(...)
    return {[1] = {...}, [2] = select("#", ...)}
end
local function _w158(v1, v2)
    return function(bloomEnabled)
        v2[1][1].BloomEnabled = bloomEnabled
        applyBloomSettings()
    end
end
local function _w159(v1, v2)
    return function(fOVOverrideEnabled)
        v2[1][1].FOVOverrideEnabled = fOVOverrideEnabled
        applyFOVOverride()
    end
end
local function _w160(v1, v2)
    return function()
        local v3 = tick()
        local v4, v5, v6
        v4, v5, v6 = pairs(v2[2][1]._labels)
        v4, v5, v6 = v1.g(v4, v5, v6)
        local v7, v8
        v7, v8 = v4(v5, v6)
        local new3, position2
        if v7 ~= nil then
            while true do
                if v7.Parent and v7:IsA("BasePart") then
                    v8.lastPosition = v7.Position
                    v8.lastSeen = v3
                    new3 = CFrame.new
                    position2 = v7.Position
                    v8.ghost.CFrame = new3(position2)
                elseif v3 - v8.lastSeen > 3 then
                    v2[1][1](v7)
                end
                v7, v8 = v4(v5, v6)
                v6 = v7
                if v6 == nil then
                    break
                end
            end
        end
    end
end
local function _w161(v1, v2)
    return function(v3)
        local v4, v5, v6
        v4, v6, v5 = ipairs(v2[1][1].Automation.ModDetector.Moderators)
        v4, v6, v5 = v1.g(v4, v6, v5)
        local v7, v8
        v8, v7 = v4(v6, v5)
        if v8 ~= nil then
            while true do
                if v3.Name ~= v7 then
                    v8, v7 = v4(v6, v5)
                    v5 = v8
                    if v5 ~= nil then
                        continue
                    end
                    v4, v6, v5 = ipairs(v2[1][1].Automation.ModDetector.ModFriends)
                    v4, v6, v5 = v1.g(v4, v6, v5)
                    v8, v7 = v4(v6, v5)
                    v5 = v8
                    if v5 ~= nil then
                        while true do
                            if v3.Name ~= v7 then
                                v8, v7 = v4(v6, v5)
                                v5 = v8
                                if v5 ~= nil then
                                    continue
                                end
                                return false
                            end
                            break
                        end
                        return true
                    end
                    return false
                end
                break
            end
            return true
        end
    end
end
local function _w162(v1)
    return function()
        local e, _
        local v2 = workspace
        local v3
        v3, v2 = v2, v2.GetDescendants
        v2 = v1.h(v2(v3))
        local v4
        v4, v2, v3 = ipairs(v1.i(v2))
        v4, v2, v3 = v1.g(v4, v2, v3)
        local v5
        v5, _ = v4(v2, v3)
        local v6, v7, v8
        if v5 ~= nil then
            while true do
                if _.Name == "Smoke Grenade" then
                    v8 = _.GetDescendants
                    v8 = v1.h(v8(_))
                    v7, v8, v6 = ipairs(v1.i(v8))
                    v7, v8, v6 = v1.g(v7, v8, v6)
                    for _, e in v7, v8, v6 do
                        if e:IsA("ParticleEmitter") then
                            e.Enabled = false
                        else
                            e:IsA("BasePart")
                            e:IsA("Decal")
                            e:IsA("Texture")
                        end
                    end
                end
                v5, _ = v4(v2, v3)
                v3 = v5
                if v3 == nil then
                    break
                end
            end
        end
    end
end
local function _w163(v1, v2)
    return function(speed)
        v2[1][1].Fly.Speed = speed
    end
end
local function _w164(v1, v2)
    return function(v3, v4)
        local v5 = v4.ClientFighter and v4.ClientFighter.Player
        local v6 = v2[4][1] or v4.Name
        local v7, toEnum, v8, v9
        if v5 == v2[3][1] and v2[5][1][v6] then
            v7 = require(v2[2][1].Modules.ReplicatedClass)
            toEnum = v7:ToEnum("Data")
            v3[toEnum] = v3[toEnum] or {}
            v9 = v2[5][1][v6]
            v8 = v3[toEnum]
            if v9.Skin then
                v8[v7:ToEnum("Skin")] = v9.Skin
            end
            if v9.Wrap then
                v8[v7:ToEnum("Wrap")] = v9.Wrap
            end
            if v9.Charm then
                v8[v7:ToEnum("Charm")] = v9.Charm
            end
        end
        v7 = {[2] = 1, [1] = v2[1][1](v3, v4)}
        v7[3] = v7
        if v5 == v2[3][1] and v2[5][1][v6] and v2[5][1][v6].Wrap and v7[1]._UpdateWrap then
            v7[1]._UpdateWrap(v7[1])
            v8 = v1:ae({v7})
            task.delay(0.1, v8)
        end
        return v7[1]
    end
end
local function _w165(v1)
    return function(v2)
        getgenv().NameSpooferConfig.spoofed_level = tonumber(v2) or 996
    end
end
local function _w166(v1, v2)
    return function(fOVOverrideValue)
        local v3 = v2[1][1]
        v3.FOVOverrideValue = fOVOverrideValue
        v3 = v3.FOVOverrideEnabled
        if v3 then
            applyFOVOverride()
        end
    end
end
local function _w167(v1, v2)
    return function(fastFireShootTime)
        v2[2][1].FastFireShootTime = fastFireShootTime
        if v2[3][1].FastFire.Enabled then
            v2[1][1]()
        end
    end
end
local function _w168(v1, v2)
    return function(v3)
        local v4
        if v3 == v2[1][1] then
            v4 = pcall
            pcall(v1:Id())
            v4(v1:Kd())
            v4(v1:Jd())
            v4(v1:Ld())
        end
    end
end
local function _w169(v1)
    return function(espHealth)
        EspSettings.EspHealth = espHealth
    end
end
local function _w170(v1, v2)
    return function()
        local v3 = require(v2[1][1].Modules.ClientReplicatedClasses.ClientFighter.ClientItem)
        v2[2][1] = v3
    end
end
local function _w171(v1, v2)
    return function()
        local v3, uIStroke, v4, v5, uICorner
        if not v2[2][1]._label then
            v5 = {[2] = 1, [1] = Instance.new("ScreenGui")}
            v5[3] = v5
            v5[1].Name = "Dark_KatanaWarning"
            v5[1].ResetOnSpawn = false
            v5[1].DisplayOrder = 10000
            v5[1].IgnoreGuiInset = true
            pcall(v1:Pe({v5}))
            if not v5[1].Parent then
                v4 = v2[1][1]:FindFirstChild("PlayerGui")
                v5[1].Parent = v4
            end
            v4 = Instance.new("TextLabel")
            v4.Size = UDim2.new(0, 400, 0, 40)
            v4.Position = UDim2.new(0.5, -200, 0, 80)
            v4.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
            v4.BackgroundTransparency = 0.1
            v4.Font = Enum.Font.GothamBold
            v4.TextSize = 18
            v4.TextColor3 = Color3.fromRGB(255, 255, 255)
            v4.Text = "ENEMY IS HOLDING KATANA!"
            v4.Visible = false
            v4.Parent = v5[1]
            uICorner = Instance.new("UICorner")
            uICorner.CornerRadius = UDim.new(0, 6)
            uICorner.Parent = v4
            uIStroke = Instance.new("UIStroke")
            uIStroke.Thickness = 2
            uIStroke.Color = Color3.fromRGB(255, 200, 100)
            uIStroke.Parent = v4
            v3 = v2[2][1]
            v3._label = v4
            v3._screenGui = v5[1]
        end
        v2[2][1]._label.Visible = true
        v2[2][1]._expiry = tick() + 1
    end
end
local function _w172(v1, v2)
    return function()
        local v3 = v2[1][1]
        local v4
        v4, v3 = v3, v3.GetChildren
        v3 = v1.h(v3(v4))
        local terrain
        terrain, v3, v4 = ipairs(v1.i(v3))
        terrain, v3, v4 = v1.g(terrain, v3, v4)
        local v5, v6
        v6, v5 = terrain(v3, v4)
        if v6 ~= nil then
            while true do
                if v5:IsA("Atmosphere") or v5:IsA("Sky") or v5:IsA("Clouds") or v5:IsA("ColorCorrectionEffect") then
                    v5:Destroy()
                end
                v6, v5 = terrain(v3, v4)
                v4 = v6
                if v4 == nil then
                    break
                end
            end
        end
        terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            v3 = terrain:FindFirstChild("ThemeSnowParticles")
            if v3 then
                v3:Destroy()
            end
        end
    end
end
local function _w173(v1, v2)
    return function()
        local v3
        if v2[4][1] then
            v3 = v2[4][1]
            v3.CFrame = v2[3][1]
            v3.Velocity = v2[5][1]
            v3.RotVelocity = v2[2][1]
        end
        v2[1][1]:UnbindFromRenderStep("__ragebot_restore")
    end
end
local function _w174(v1, v2)
    return function()
        while true do
            if task.wait(2) then
                v2[1][1] = {}
                continue
            end
            break
        end
    end
end
local function _w175(v1, v2)
    return function()
        while true do
            if not task.wait(0.2) then
                break
            end
        end
    end
end
local function _w176(v1, v2)
    return function(v3)
        v2[1][1](v3)
    end
end
local function _w177(v1)
    return function(v2)
        if type(v2) ~= "string" then
            return true
        else
            return v2:find("MISSING_") or v2:find("Bubblegum") or v2:find("Ragdoll") or v2:find("Fall Apart") or v2:find("Every Finisher Ever")
        end
    end
end
local function _w178(v1, v2)
    return function(enabled)
        local _, n
        local v3, v4, v5, v6, v7, v8, v9, v10, v11, v12
        if enabled then
            v6 = {Sniper = true, Crossbow = true, Bow = true, RPG = true}
            v3, v5, _ = pairs(v2[4][1])
            v3, v5, _ = v1.g(v3, v5, _)
            v11, v12 = v3(v5, _)
            _ = v11
            if _ ~= nil then
                while true do
                    if typeof(v12) == "table" and not v6[v11] then
                        v4 = {}
                        v10, v8, v9 = ipairs(v2[5][1])
                        v10, v8, v9 = v1.g(v10, v8, v9)
                        for _, n in v10, v8, v9 do
                            if v12[n] ~= nil then
                                v4[n] = v12[n]
                            end
                        end
                        v2[6][1].FastFire.Original[v11] = v4
                    end
                    v11, v12 = v3(v5, _)
                    _ = v11
                    if _ == nil then
                        break
                    end
                end
            end
            v2[2][1]()
            _ = {}
            v3 = v2[1][1]
            _.Title = "Fast Fire"
            _.Description = "Enabled at " .. tostring(v2[3][1].FastFireShootTime) .. "s"
            _.Time = 2
            v3:Notify(_)
        else
            v6, v3, v5 = pairs(v2[6][1].FastFire.Original)
            v6, v3, v5 = v1.g(v6, v3, v5)
            _, v11 = v6(v3, v5)
            v5 = _
            if v5 ~= nil then
                while true do
                    v12 = v2[4][1][_]
                    if v12 then
                        v4, v10, v8 = pairs(v11)
                        v4, v10, v8 = v1.g(v4, v10, v8)
                        v9, v7 = v4(v10, v8)
                        v8 = v9
                        if v8 ~= nil then
                            while true do
                                v12[v9] = v7
                                v9, v7 = v4(v10, v8)
                                v8 = v9
                                if v8 == nil then
                                    break
                                end
                            end
                        end
                    end
                    _, v11 = v6(v3, v5)
                    v5 = _
                    if v5 == nil then
                        break
                    end
                end
            end
            v2[1][1]:Notify({Title = "Fast Fire", Description = "Disabled!", Time = 2})
        end
        v2[6][1].FastFire.Enabled = enabled
    end
end
local function _w179(v1, v2)
    return function(enabled)
        local autoLoadout, v3, conn
        if enabled then
            if not v2[4][1].AutoLoadout.Conn then
                autoLoadout = v2[4][1].AutoLoadout
                v3 = v1:Md({v2[3], v2[5], v2[2], v2[4], v2[1]})
                autoLoadout.Conn = task.spawn(v3)
                v2[4][1].AutoLoadout.Enabled = enabled
            end
            return
        elseif v2[4][1].AutoLoadout.Conn then
            v3 = v2[4][1]
            conn = v3.AutoLoadout.Conn
            task.cancel(conn)
            v3.AutoLoadout.Conn = nil
        end
        v2[4][1].AutoLoadout.Enabled = enabled
    end
end
local function _w180(v1, v2)
    return function(tracerFadeTime)
        v2[1][1].TracerFadeTime = tracerFadeTime
    end
end
local function _w181(v1, v2)
    return function(enabled)
        v2[2][1].SkinChanger.Enabled = enabled
        local v3, v4
        if enabled then
            v4 = {}
            v3 = v2[1][1]
            v4.Title = "Skin Changer"
            v4.Description = "Skins, Charms, Wraps & Emotes unlocked!"
        else
            v4 = {}
            v3 = v2[1][1]
            v4.Title = "Skin Changer"
            v4.Description = "Disabled! (you may need to re-equip items)"
        end
        v4.Time = 3
        v3:Notify(v4)
    end
end
local function _w182(v1)
    return function(level_spoof)
        getgenv().NameSpooferConfig.level_spoof = level_spoof
    end
end
local function _w183(v1, v2)
    return function(enabled)
        v2[1][1].Enabled = enabled
    end
end
local function _w184(v1, v2)
    return function(tracerRainbow)
        v2[1][1].TracerRainbow = tracerRainbow
    end
end
local function _w185(v1, v2)
    return function()
        local v3, v4, v5, v6, v7, fastFireShootTime, v8
        if v2[2][1].FastFire.Enabled then
            v4 = {}
            fastFireShootTime = v2[3][1].FastFireShootTime
            v4.Sniper = true
            v4.Crossbow = true
            v4.Bow = true
            v4.RPG = true
            v6, v4, v7 = v2[1][1], pairs, v4
            v4, v6, v3 = v4(v6)
            v4, v6, v3 = v1.g(v4, v6, v3)
            v5, v8 = v4(v6, v3)
            v3 = v5
            if v3 ~= nil then
                while true do
                    if typeof(v8) == "table" and not v7[v5] then
                        v8.ShootSpread = 0
                        v8.ShootAccuracy = 0
                        v8.ShootRecoil = 0
                        v8.ShootCooldown = fastFireShootTime
                        v8.ShootBurstCooldown = fastFireShootTime
                        v8.AttackCooldown = fastFireShootTime
                        v8.SwingCooldown = fastFireShootTime
                        v8.Cooldown = fastFireShootTime
                        v8.RecoveryTime = fastFireShootTime
                        v8.ResetTime = fastFireShootTime
                        v8.FireRate = fastFireShootTime
                        v8.FireDelay = fastFireShootTime
                        v8.ShootDelay = fastFireShootTime
                    end
                    v5, v8 = v4(v6, v3)
                    v3 = v5
                    if v3 == nil then
                        break
                    end
                end
            end
        end
    end
end
local function _w186(v1, v2)
    return function()
        local e, _
        local v3 = v2[4][1]
        table.clear(v3)
        local v4 = v2[3][1]
        local v5
        v4, v3, v5 = v1.g(v4, nil, nil)
        local v6 = v4(v3, v5)
        if v6 ~= nil then
            while true do
                if not v2[1][1](v6) then
                    v2[4][1][v6] = true
                end
                v6 = v4(v3, v5)
                v5 = v6
                if v5 == nil then
                    break
                end
            end
        end
        v4 = v2[2][1]
        v4, v3, v5 = v1.g(v4, nil, nil)
        v6, _ = v4(v3, v5)
        if v6 ~= nil then
            while true do
                for _, e in v1.g(_, nil, nil) do
                    if e and e.Name and not v2[1][1](e.Name) then
                        v2[4][1][e.Name] = true
                    end
                end
                v6, _ = v4(v3, v5)
                v5 = v6
                if v5 == nil then
                    break
                end
            end
        end
    end
end
local function _w187(v1, v2)
    return function(v3)
        local v4 = v2[1][1]
        v2[2][1].WeaponChoices[v4] = v3
    end
end
local function _w188(v1, v2)
    return function(v3)
        task.wait(0.5)
        if v2[4][1].Enabled and not isTeammate(v2[3][1]) then
            v2[5][1](v3)
        end
        if v2[2][1].Enabled and not isTeammate(v2[3][1]) then
            v2[1][1](v3)
        end
    end
end
local function _w189(v1, v2)
    return function(secondWeapons)
        v2[1][1].Automation.AutoBan.SecondWeapons = secondWeapons
    end
end
local function _w190(v1, v2)
    return function(v3, name)
        local v4 = v2[2][1](v3, name)
        local v5, clone2, v6, v7, v8, v9, v10
        if not v4 then
            return nil
        else
            clone2 = table.clone(v4)
            clone2.Name = name
            v5 = v2[1][1][name]
            if v5 then
                v6, v7, v8 = v1.g(v5, nil, nil)
                v9, v10 = v6(v7, v8)
                v8 = v9
                if v8 ~= nil then
                    while true do
                        clone2[v9] = v10
                        v9, v10 = v6(v7, v8)
                        v8 = v9
                        if v8 == nil then
                            break
                        end
                    end
                end
            end
            return clone2
        end
    end
end
local function _w191(v1)
    return function(name_spoof)
        getgenv().NameSpooferConfig.name_spoof = name_spoof
    end
end
local function _w192(v1, v2)
    return function()
        local v3 = v2[1][1]
        v3.Name = getgenv().NameSpooferConfig.your_spoofed_name
        v3.DisplayName = getgenv().NameSpooferConfig.your_spoofed_name
    end
end
local function _w193(v1, v2)
    return function(enabled)
        v2[1][1].Automation.AutoPickupDrops.Enabled = enabled
    end
end
local function _w194(v1, v2)
    return function(v3)
        local uIStroke2, uIStroke3, frame, frame2, v4, frame3, uIStroke4, textLabel, frame4, frame5, uIStroke5, frame6, textLabel2, textLabel3
        if not (v3 == v2[1][1] or EspRegistry[v3]) then
            v4 = {}
            frame2 = Instance.new("Frame", EspGui)
            frame2.BackgroundTransparency = 1
            frame2.Visible = false
            frame5 = Instance.new("Frame", frame2)
            frame5.Size = UDim2.new(1, 0, 1, 0)
            frame5.BackgroundTransparency = 1
            uIStroke5 = Instance.new("UIStroke", frame5)
            uIStroke5.Thickness = EspSettings.BoxThickness
            v4.Box = frame2
            v4.BoxStroke = uIStroke5
            frame3 = Instance.new("Frame", EspGui)
            frame3.BorderSizePixel = 0
            frame3.Visible = false
            v4.FilledBox = frame3
            frame6 = Instance.new("Frame", EspGui)
            frame6.AnchorPoint = Vector2.new(0.5, 0.5)
            frame6.BorderSizePixel = 0
            frame6.Visible = false
            v4.Tracer = frame6
            frame4 = Instance.new("Frame", EspGui)
            frame4.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            frame4.BackgroundTransparency = 0.3
            frame4.BorderSizePixel = 0
            frame4.Visible = false
            frame = Instance.new("Frame", frame4)
            frame.BorderSizePixel = 0
            frame.AnchorPoint = Vector2.new(0, 1)
            frame.Position = UDim2.new(0, 0, 1, 0)
            v4.HealthBar = frame4
            v4.HealthFill = frame
            textLabel = Instance.new("TextLabel", EspGui)
            textLabel.BackgroundTransparency = 1
            textLabel.AnchorPoint = Vector2.new(0.5, 1)
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Font = Enum.Font.FredokaOne
            textLabel.TextSize = 13
            textLabel.Visible = false
            uIStroke4 = Instance.new("UIStroke", textLabel)
            uIStroke4.Color = Color3.fromRGB(0, 0, 0)
            uIStroke4.Thickness = 1.5
            v4.Tag = textLabel
            textLabel2 = Instance.new("TextLabel", EspGui)
            textLabel2.BackgroundTransparency = 1
            textLabel2.AnchorPoint = Vector2.new(0.5, 0)
            textLabel2.TextColor3 = Color3.fromRGB(235, 235, 235)
            textLabel2.Font = Enum.Font.FredokaOne
            textLabel2.TextSize = 11
            textLabel2.Visible = false
            uIStroke2 = Instance.new("UIStroke", textLabel2)
            uIStroke2.Color = Color3.fromRGB(0, 0, 0)
            uIStroke2.Thickness = 1.5
            v4.DistTag = textLabel2
            textLabel3 = Instance.new("TextLabel", EspGui)
            textLabel3.BackgroundTransparency = 1
            textLabel3.AnchorPoint = Vector2.new(0.5, 0)
            textLabel3.TextColor3 = Color3.fromRGB(255, 200, 80)
            textLabel3.Font = Enum.Font.FredokaOne
            textLabel3.TextSize = 10
            textLabel3.Visible = false
            uIStroke3 = Instance.new("UIStroke", textLabel3)
            uIStroke3.Color = Color3.fromRGB(0, 0, 0)
            uIStroke3.Thickness = 1.5
            v4.WeaponTag = textLabel3
            v4.CurrentCham = nil
            v4.CurrentGlowCham = nil
            EspRegistry[v3] = v4
            return
        end
    end
end
local function _w195(v1, v2)
    return function()
        local list, uIListLayout, v3, uICorner2, uICorner3, uIStroke6, v4, uIPadding, title, v5
        if not v2[2][1]._container then
            v5 = {[2] = 1, [1] = Instance.new("ScreenGui")}
            v5[3] = v5
            v5[1].Name = "Dark_EnemyWeaponsPanel"
            v5[1].ResetOnSpawn = false
            v5[1].DisplayOrder = 9999
            v3 = Enum.ZIndexBehavior.Sibling
            v5[1].ZIndexBehavior = v3
            pcall(v1:Yd({v5}))
            if not v5[1].Parent then
                v3 = v2[1][1]:FindFirstChild("PlayerGui")
                v5[1].Parent = v3
            end
            v3 = Instance.new("Frame")
            v3.Name = "Panel"
            v3.Size = UDim2.new(0, 220, 0, 200)
            v3.Position = UDim2.new(1, -240, 0, 80)
            v3.BackgroundColor3 = Color3.fromRGB(20, 18, 30)
            v3.BackgroundTransparency = 0.05
            v3.BorderSizePixel = 0
            v3.Visible = false
            v3.Parent = v5[1]
            uICorner2 = Instance.new("UICorner")
            uICorner2.CornerRadius = UDim.new(0, 8)
            uICorner2.Parent = v3
            uIStroke6 = Instance.new("UIStroke")
            uIStroke6.Color = Color3.fromRGB(80, 60, 120)
            uIStroke6.Thickness = 1
            uIStroke6.Transparency = 0.4
            uIStroke6.Parent = v3
            title = Instance.new("TextLabel")
            title.Name = "Title"
            title.Size = UDim2.new(1, 0, 0, 28)
            title.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
            title.Text = "ENEMY WEAPONS"
            title.Font = Enum.Font.GothamBold
            title.TextSize = 13
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.Parent = v3
            uICorner3 = Instance.new("UICorner")
            uICorner3.CornerRadius = UDim.new(0, 8)
            uICorner3.Parent = title
            list = Instance.new("Frame")
            list.Name = "List"
            list.Size = UDim2.new(1, 0, 1, -32)
            list.Position = UDim2.new(0, 0, 0, 30)
            list.BackgroundTransparency = 1
            list.Parent = v3
            uIListLayout = Instance.new("UIListLayout")
            uIListLayout.SortOrder = Enum.SortOrder.Name
            uIListLayout.Padding = UDim.new(0, 4)
            uIListLayout.Parent = list
            uIPadding = Instance.new("UIPadding")
            uIPadding.PaddingLeft = UDim.new(0, 6)
            uIPadding.PaddingRight = UDim.new(0, 6)
            uIPadding.PaddingTop = UDim.new(0, 4)
            uIPadding.Parent = list
            v4 = v2[2][1]
            v4._container = v3
            v4._screenGui = v5[1]
        end
    end
end
local function _w196(v1, v2)
    return function()
        v2[1][1]:Destroy()
    end
end
local function _w197(v1, v2)
    return function(v3)
        local v4, v5, v6
        v4, v6, v5 = v3:gmatch("[^,]+")
        v4, v6, v5 = v1.g(v4, v6, v5)
        local v7 = v4(v6, v5)
        local v8 = {}
        local v9, v10, insert2, v11, v12
        if v7 ~= nil then
            while true do
                insert2 = table.insert
                v9 = v7:gsub("^%s+", "")
                v10, v12, v11, v9 = "%s+$", v9, "", v9.gsub
                insert2(v8, v9(v12, "%s+$", ""))
                v7 = v4(v6, v5)
                v5 = v7
                if v5 == nil then
                    break
                end
            end
        end
        v2[1][1].Automation.ModDetector.Moderators = v8
    end
end
local function _w198(v1)
    return function(v2)
        EspSettings.HeadScale = v2 / 100
    end
end
local function _w199(v1, v2)
    return function()
        local v3 = {[2] = 1, [1] = nil}
        v3[3] = v3
        v3[1] = v1:ue()
        local v4 = {[2] = 1, [1] = nil}
        v4[3] = v4
        v4[1] = v1:se()
        local v5 = {[2] = 1, [1] = nil}
        v5[3] = v5
        v5[1] = v1:ve({v2[1]})
        local v6 = v1:te({v4, v5, v3})
        return {extractPlayerName = v3[1], extractWeaponName = v4[1], getEnemyHeldWeapon = v6}
    end
end
local function _w200(v1, v2)
    return function(v3, v4, v5, v9, ...)
        local v6, v7, v8, pack
        if not (v4 == "BlindEffect" and v2[1][1].AntiFlash.Enabled) then
            v6 = v2[1][1].AntiFlash
            v7, v6, pack, v8 = v4, v3, table.pack(v5, v9, ...), v6.OriginalHook
            v8 = table.pack(v8(v6, v7, table.unpack(pack, 1, pack.n)))
            return table.unpack(v8, 1, v8.n)
        end
    end
end
local function _w201(v1, v2)
    return function()
        local v3 = v2[2][1]
        v3.Size = v2[1][1]
        v3.Massless = false
    end
end
local function _w202(v1, v2)
    return function()
        local v3 = v2[2][1]
        local v4
        v4, v3 = v3, v3.GetPlayers
        v3 = v1.h(v3(v4))
        local v5
        v5, v3, v4 = ipairs(v1.i(v3))
        v5, v3, v4 = v1.g(v5, v3, v4)
        local v6, v7
        v6, v7 = v5(v3, v4)
        local character9
        if v6 ~= nil then
            while true do
                if v7.Character then
                    character9 = v7.Character
                    v2[3][1](character9)
                end
                v6, v7 = v5(v3, v4)
                v4 = v6
                if v4 == nil then
                    break
                end
            end
        end
        v5, v3, v4 = pairs(v2[1][1]._originalSizes)
        v5, v3, v4 = v1.g(v5, v3, v4)
        v6, v7 = v5(v3, v4)
        if v6 ~= nil then
            while true do
                v2[3][1](v6)
                v6, v7 = v5(v3, v4)
                v4 = v6
                if v4 == nil then
                    break
                end
            end
        end
        v2[1][1]._originalSizes = {}
    end
end
local function _w203(v1, v2)
    return function()
        local v3 = {[2] = 1, [1] = v2[2][1].LocalFighter}
        v3[3] = v3
        while true do
            if not v3[1] and v2[3][1].Enabled then
                task.wait(0.1)
                v3[1] = v2[2][1].LocalFighter
                continue
            end
            break
        end
        if v3[1] then
            pcall(v1:Hd({v2[1], v3}))
        end
    end
end
local function _w204(v1, v2)
    return function()
        v2[1][1]:SetAttribute("StatisticDuelsWinStreak", getgenv().NameSpooferConfig.spoofed_winstreak)
    end
end
local function _w205(v1)
    return function(v2)
        local split2 = string.split(v2, " - ")
        if #split2 >= 1 then
            return split2[1]
        else
            return "Unknown"
        end
    end
end
local function _w206(v1, v2)
    return function(v3)
        local name4, v4, v5, v6, v7, v8, name5, v9
        if v3 then
            v9 = v2[2][1]()
            if v9 then
                v7 = v9.GetChildren
                v7 = v1.h(v7(v9))
                v4, v7, v5 = ipairs(v1.i(v7))
                v4, v7, v5 = v1.g(v4, v7, v5)
                v6, v8 = v4(v7, v5)
                v5 = v6
                if v5 ~= nil then
                    while true do
                        if not v8:IsA("Model") then
                            v6, v8 = v4(v7, v5)
                            v5 = v6
                            if v5 ~= nil then
                                continue
                            end
                            return nil
                        end
                        name4 = v8.Name
                        if v2[3][1](name4) ~= v3.Name then
                            v6, v8 = v4(v7, v5)
                            v5 = v6
                            if v5 ~= nil then
                                continue
                            end
                            return nil
                        end
                        break
                    end
                    name5 = v8.Name
                    return v2[1][1](name5), v8
                end
            end
        end
        return nil
    end
end
local function _w207(v1)
    return function()
        getgenv()._Dark_V12_EnemyWeapons.disable()
    end
end
local function _w208(v1, v2)
    return function()
        local controllers = v2[1][1].PlayerScripts.Controllers
        local v3
        controllers, v3 = controllers.WaitForChild, controllers
        controllers = table.pack(controllers(v3, "MatchmakingController", 5))
        local v4 = require(table.unpack(controllers, 1, controllers.n))
        v2[2][1] = v4
    end
end
local function _w209(v1)
    return function()
        local HttpService = game:GetService("HttpService")
        local v2, v3
        v2, v3, HttpService = "[68, \"getgold.cc\", true, 123, false, [321, null, \"goldtm\"], null, [\"a\"]]", HttpService, HttpService.JSONDecode
        HttpService = table.pack(HttpService(v3, "[68, \"getgold.cc\", true, 123, false, [321, null, \"goldtm\"], null, [\"a\"]]"))
        return table.unpack(HttpService, 1, HttpService.n)
    end
end
local function _w210(v1, v2)
    return function(v3)
        local clientItem = v3.ClientItem
        local v4 = clientItem
        if clientItem then
            v4 = clientItem.Name
        end
        local v5 = clientItem
        if clientItem then
            v5 = clientItem.ClientFighter
        end
        if v5 then
            v5 = clientItem.ClientFighter.Player
        end
        local v6 = v4
        if v4 then
            v6 = v5 == v2[2][1]
        end
        if v6 then
            v6 = v2[3][1][v4]
        end
        local v7 = v6
        if v6 then
            v7 = v6.Wrap
        end
        if not v7 then
            v7 = v2[1][1](v3)
        end
        return v7
    end
end
local function _w211(v1, v2)
    return function(notify)
        v2[1][1].Automation.HackerDetector.Notify = notify
    end
end
local function _w212(v1)
    return function(teamCheckESP)
        EspSettings.TeamCheckESP = teamCheckESP
    end
end
local function _w213(v1, v2)
    return function(enabled)
        v2[4][1].Enabled = enabled
        local v3, heartbeat
        if enabled then
            if not v2[6][1].Ragebot.Conn then
                heartbeat = v2[5][1].Heartbeat
                v2[6][1].Ragebot.Conn = heartbeat:Connect(v2[2][1])
            end
            task.spawn(v1:Gd({v2[1], v2[3], v2[4]}))
            v3 = {
                Title = "Ragebot",
                Description = "Enabled! Slot: " .. v2[4][1].WeaponSlot,
                Time = 2,
            }
            v2[7][1]:Notify(v3)
        else
            if v2[6][1].Ragebot.Conn then
                v3 = v2[6][1]
                v3.Ragebot.Conn:Disconnect()
                v3.Ragebot.Conn = nil
            end
            v2[7][1]:Notify({Title = "Ragebot", Description = "Disabled!", Time = 2})
        end
    end
end
local function _w214(v1, v2)
    return function(v3)
        local v4
        if v3 then
            v4 = {[2] = 1, [1] = v3:FindFirstChild("HumanoidRootPart")}
            v4[3] = v4
            if v4[1] then
                pcall(v1:yf({v2[1], v4}))
            end
            return
        end
    end
end
local function _w215(v1, v2)
    return function(nightModeEnabled)
        v2[1][1].NightModeEnabled = nightModeEnabled
        applyNightMode()
    end
end
local function _w216(v1, v2)
    return function()
        v2[1][1]()
    end
end
local function _w217(v1, v2)
    return function()
        pcall(v1:Ee({v2[2]}))
        pcall(v1:Fe({v2[2]}))
        pcall(v1:Ge({v2[2]}))
        v2[1][1]:Notify({Title = "Cosmetics", Description = "Refreshed!", Time = 2})
    end
end
local function _w218(v1, v2)
    return function()
        local c
        local v3, v4, v5, v6
        if not v2[2][1].WeaponLatexEnabled then
            return
        else
            v5 = v2[1][1]()
            if v5 then
                v4 = v5.GetDescendants
                v4 = v1.h(v4(v5))
                v6, v4, v3 = ipairs(v1.i(v4))
                v6, v4, v3 = v1.g(v6, v4, v3)
                for v7, c in v6, v4, v3 do
                    if c:IsA("BasePart") and c.Name:lower():find("arm") then
                        c.Material = Enum.Material.ForceField
                        c.Color = Color3.fromRGB(170, 170, 255)
                        c.Reflectance = 0.12
                    end
                end
                return
            end
        end
    end
end
local function _w219(v1, v2)
    return function(enabled)
        v2[1][1].Enabled = enabled
        if not enabled then
            removeAllSpheres()
        end
    end
end
local function _w220(v1, v2)
    return function()
        v2[1][1]:Replicate("CosmeticInventory")
    end
end
local function _w221(v1, v2)
    return function(enabled)
        v2[1][1].Automation.AutoRespawn.Enabled = enabled
    end
end
local function _w222(v1)
    return function(v2)
        local v3, v4, v5, v6, v7, viewModels2
        if v2 then
            viewModels2 = workspace:FindFirstChild("ViewModels")
            if viewModels2 then
                v3, v4, v5 = viewModels2:GetChildren()
                v3, v4, v5 = v1.g(v3, v4, v5)
                v6, v7 = v3(v4, v5)
                v5 = v6
                if v5 ~= nil then
                    while true do
                        if not (v7:IsA("Model") and string.find(v7.Name, v2.Name, 1, true) and string.find(v7.Name, "Knife", 1, true)) then
                            v6, v7 = v3(v4, v5)
                            v5 = v6
                            if v5 ~= nil then
                                continue
                            end
                            return false
                        end
                        break
                    end
                    return true
                end
            end
        end
        return false
    end
end
local function _w223(v1)
    return function()
        local v2 = {[2] = 1, [1] = 0}
        v2[3] = v2
        if writefile then
            pcall(v1:Mf({v2}))
        end
        return v2[1]
    end
end
local function _w224(v1, v2)
    return function(v3)
        v3 = {[2] = 1, [1] = v3}
        v3[3] = v3
        local v4
        if getgenv().NameSpooferConfig.name_spoof then
            v4 = v2[1][1]
            if v3[1] == v4 then
                pcall(v1:ef({v3}))
            else
                pcall(v1:df({v3}))
            end
        end
    end
end
local function _w225(v1, v2)
    return function(v3)
        local v4
        if v3:IsA("BloomEffect") then
            v4, v2[1][1] = applyBloomSettings, v3
            v4()
        end
    end
end
local function _w226(v1)
    return function()
        RestoreHeadScales()
    end
end
local function _w227(v1, v2)
    return function()
        local v3
        if v2[2][1].NightModeEnabled then
            v3 = v2[1][1]
            v3.TimeOfDay = "00:00:00"
            v3.Brightness = 1
            v3.Ambient = Color3.fromRGB(20, 20, 30)
            v3.OutdoorAmbient = Color3.fromRGB(10, 10, 20)
        else
            v3 = v2[1][1]
            v3.TimeOfDay = "14:00:00"
            v3.Brightness = 2
            v3.Ambient = Color3.fromRGB(128, 128, 128)
            v3.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end
    end
end
local function _w228(v1)
    return function()
        if espPipelineConn then
            espPipelineConn:Disconnect()
        end
    end
end
local function _w229(v1)
    return function()
        getgenv()._Dark_V12_KatanaWarning.destroy()
    end
end
local function _w230(v1, v2)
    return function(v3)
        v3 = {[2] = 1, [1] = v3}
        v3[3] = v3
        local v4 = v2[1][1]
        local v5
        if v3[1] ~= v4 then
            return
        else
            v5 = v3[1]
            v5 = not v3[1].FindFirstChild(v5, "CustomLeaderstats")
            if not v5 then
                v5 = getgenv().NameSpooferConfig.winstreak_spoof
                return
            end
        end
    end
end
local function _w231(v1, v2)
    return function()
        local v3, v4
        if v2[2][1].FogEnabled then
            v4 = v2[3][1]
            v4.FogStart = 0
            v3 = v2[2][1]
            v4.FogEnd = v3.FogDistance
            v3 = v3.FogColorName
            v2[3][1].FogColor = v2[1][1][v3]
        else
            v2[3][1].FogEnd = 100000
        end
    end
end
local function _w232(v1, v2)
    return function(fireRate)
        v2[1][1].FireRate = fireRate
    end
end
local function _w233(v1, v2)
    return function(weaponLatexEnabled)
        v2[1][1].WeaponLatexEnabled = weaponLatexEnabled
    end
end
local function _w234(v1, v2)
    return function(enabled)
        v2[4][1].JumpHack.Enabled = enabled
        local v3, heartbeat2
        if enabled then
            if v2[4][1].JumpHack.Conn then
                v2[4][1].JumpHack.Conn:Disconnect()
            end
            heartbeat2 = v2[3][1].Heartbeat
            v2[4][1].JumpHack.Conn = heartbeat2:Connect(v1:Be({v2[1], v2[2]}))
        elseif v2[4][1].JumpHack.Conn then
            v3 = v2[4][1]
            v3.JumpHack.Conn:Disconnect()
            v3.JumpHack.Conn = nil
        end
    end
end
local function _w235(v1, v2)
    return function()
        local w, s
        local v3 = v2[2][1].Character
        local v4, humanoidRootPart4, v5, humanoidRootPart5, magnitude2, v6, v7, head2, humanoid2, position3, v8, v9, v10
        if not v3 then
            return nil, nil, nil
        else
            humanoidRootPart4 = v3:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart4 then
                return nil, nil, nil
            else
                v7 = nil
                v8 = nil
                v10 = v2[3][1]
                v4 = 500
                v9 = nil
                v10, v6 = v10.GetPlayers, v10
                v10, v6, w = v10(v6)
                v10, v6, w = v1.g(v10, v6, w)
                for w, s in v10, v6, w do
                    if v2[1][1](s) then
                        v5 = s.Character
                        if v5 then
                            humanoidRootPart5 = v5:FindFirstChild("HumanoidRootPart")
                            head2 = v5:FindFirstChild("Head")
                            humanoid2 = v5:FindFirstChildWhichIsA("Humanoid")
                            if humanoidRootPart5 and head2 and humanoid2 and humanoid2.Health > 0 then
                                position3 = humanoidRootPart5.Position
                                magnitude2 = (humanoidRootPart4.Position - position3).Magnitude
                                if magnitude2 < v4 then
                                    v8 = humanoidRootPart5
                                    v4 = magnitude2
                                    v9 = s
                                    v7 = head2
                                end
                            end
                        end
                    end
                end
                return v9, v8, v7
            end
        end
    end
end
local function _w236(v1, v2)
    return function(enabled)
        local v3, v4, v5, v6
        if enabled then
            if not v2[4][1].BulletTracer.OldShootEffect then
                v3 = v2[3][1]
                v4 = v3._ShootEffect
                v2[4][1].BulletTracer.OldShootEffect = v4
                v3._ShootEffect = v1:_f({v2[1], v2[4]})
            end
            v3 = {}
            v6 = v2[2][1]
            v3.Title = "Bullet Tracer"
            v3.Description = "Enabled!"
            v3.Time = 2
            v6:Notify(v3)
        else
            if v2[4][1].BulletTracer.OldShootEffect then
                v5 = v2[4][1]
                v4 = v5.BulletTracer.OldShootEffect
                v2[3][1]._ShootEffect = v4
                v5.BulletTracer.OldShootEffect = nil
            end
            v2[2][1]:Notify({Title = "Bullet Tracer", Description = "Disabled!", Time = 2})
        end
        v2[4][1].BulletTracer.Enabled = enabled
    end
end
local function _w237(v1, v2)
    return function()
        if v2[2][1]._renderConn then
            v2[2][1]._renderConn:Disconnect()
            v2[2][1]._renderConn = nil
        end
        if v2[2][1]._addedConn then
            v2[2][1]._addedConn:Disconnect()
            v2[2][1]._addedConn = nil
        end
        if v2[2][1]._removedConn then
            v2[2][1]._removedConn:Disconnect()
            v2[2][1]._removedConn = nil
        end
        if v2[2][1]._updateConn then
            v2[2][1]._updateConn:Disconnect()
            v2[2][1]._updateConn = nil
        end
        local v3, v4, v5
        v3, v4, v5 = pairs(v2[2][1]._labels)
        v3, v4, v5 = v1.g(v3, v4, v5)
        local v6, v7
        v6, v7 = v3(v4, v5)
        if v6 ~= nil then
            while true do
                v2[1][1](v6)
                v6, v7 = v3(v4, v5)
                v5 = v6
                if v5 == nil then
                    break
                end
            end
        end
        v3 = v2[2][1]
        v3._labels = {}
        v3._labelCount = 0
        v4 = workspace
        v5, v4 = v4, v4.GetChildren
        v4 = v1.h(v4(v5))
        v3, v4, v5 = ipairs(v1.i(v4))
        v3, v4, v5 = v1.g(v3, v4, v5)
        v6, v7 = v3(v4, v5)
        if v6 ~= nil then
            while true do
                v7 = {[2] = 1, [1] = v7}
                v7[3] = v7
                if v7[1].Name == "Dark_TripmineGhost" then
                    pcall(v1:tf({v7}))
                end
                v6, v7 = v3(v4, v5)
                v5 = v6
                if v5 == nil then
                    break
                end
            end
        end
    end
end
local function _w238(v1)
    return function()
        if getgenv().Dark_V12Cleanup then
            getgenv().Dark_V12Cleanup()
        end
    end
end
local function _w239(v1, v2)
    return function()
        local p, _, c
        local camera = workspace.CurrentCamera
        local v3, v4, v5, position4, v6, v7, v8, v9, clamp, v10, v11
        if not camera then
            position4, v11, v5 = pairs(v2[1][1]._labels)
            position4, v11, v5 = v1.g(position4, v11, v5)
            for _, c in position4, v11, v5 do
                if c.draw then
                    c.draw.Visible = false
                end
            end
        else
            v11, position4, c = pairs, camera.CFrame.Position, v2[1][1]
            v11, v5, _ = v11(c._labels)
            v11, v5, _ = v1.g(v11, v5, _)
            for _, p in v11, v5, _ do
                if p.draw and p.ghost and p.ghost.Parent then
                    v3, v9 = camera:WorldToViewportPoint(p.ghost.Position)
                    v7 = not v9 or v3.Z <= 0
                    if not v7 then
                        v10 = v2[1][1].MaxDistance
                        v7 = (p.ghost.Position - position4).Magnitude > v10
                    end
                    if v7 then
                        p.draw.Visible = false
                    else
                        clamp = math.clamp(50 / math.max((p.ghost.Position - position4).Magnitude, 1), 0.125, 1)
                        v10 = p.draw
                        v8 = math.floor
                        v6 = math.clamp
                        v4 = math.floor(32 * clamp)
                        v6 = v1.h(v6(v4, 12, 32))
                        v10.Size = v8(v1.i(v6))
                        v8 = Vector2.new
                        v6 = v3.X
                        v4 = v3.Y
                        p.draw.Position = v8(v6, v4)
                        p.draw.Visible = true
                    end
                end
            end
        end
    end
end
local function _w240(v1)
    return function(espNames)
        EspSettings.EspNames = espNames
    end
end
local function _w241(v1, v2)
    return function()
        local v3 = false
        local __cont1 = false
        local name6, v4, v5, v6, v7, v8
        while true do
            task.wait(0.1)
            if not v2[4][1].Automation.AntiKatana.Enabled then
                continue
            end
            v6 = v2[3][1]
            v7, v6 = v6, v6.GetPlayers
            v6 = v1.h(v6(v7))
            v4, v6, v7 = ipairs(v1.i(v6))
            v4, v6, v7 = v1.g(v4, v6, v7)
            v8, v5 = v4(v6, v7)
            v7 = v8
            if v7 == nil then
                continue
            end
            while true do
                if v2[1][1](v5) then
                    break
                end
                v8, v5 = v4(v6, v7)
                v7 = v8
                if v7 == nil then
                    __cont1 = true
                    break
                end
            end
            if __cont1 then
                __cont1 = false
                continue
            end
            name6 = v5.Name
            if not v3 then
                v4 = v2[2][1]
                v7 = {}
                v3 = true
                v7.Title = "Anti Katana"
                v7.Description = name6 .. " is deflecting! Shots blocked."
                v7.Time = 3
                v4:Notify(v7)
                continue
            end
            continue
        end
    end
end
local function _w242(v1, v2)
    return function(enabled)
        v2[2][1].AntiFlash.Enabled = enabled
        local v3 = require(v2[1][1].PlayerScripts.Modules.Items.Flashbang)
        local v4, antiFlash
        if enabled then
            if not v2[2][1].AntiFlash.OriginalHook then
                v4 = v2[2][1]
                v4, antiFlash = v3.ReplicateFromServer, v4.AntiFlash
                antiFlash.OriginalHook = v4
                v3.ReplicateFromServer = v1:ee({v2[2]})
            end
        end
    end
end
local function _w243(v1, v2)
    return function()
        local v3
        v2[4][1], v3 = {}, {}
        local v4
        v4, v2[3][1], v3 = pcall, v3, v1:Nf()
        v4(v3)
        v2[1][1]()
        v2[2][1]:Notify({Title = "Skin Changer", Description = "Config cleared!", Time = 2})
    end
end
local function _w244(v1, v2)
    return function()
        local v3 = v2[1][1]
        v3.Name = getgenv().NameSpooferConfig.spoofed_enemy_names
        v3.DisplayName = getgenv().NameSpooferConfig.spoofed_enemy_names
    end
end
local function _w245(v1, v2)
    return function()
        local v3 = v2[2][1].Character
        local v4 = v3
        if v3 then
            v4 = v3:FindFirstChildWhichIsA("Humanoid")
        end
        local v5 = v4
        if v4 then
            v5 = v4.MoveDirection.Magnitude > 0
        end
        if v5 then
            v5 = v3:FindFirstChild("HumanoidRootPart")
        end
        local v6, v7, walkSpeed
        if v5 then
            walkSpeed = v2[1][1].WalkSpeed
            v6 = v4.MoveDirection * (walkSpeed / 100)
            v7 = v3.HumanoidRootPart.CFrame + v6
            v3.HumanoidRootPart.CFrame = v7
        end
    end
end
local function _w246(v1)
    return function()
        getgenv()._Dark_V12_Tripmine.disable()
    end
end
local function _w247(v1, v2)
    return function()
        local v3, cFrame2, v4, v5, cFrame3, v6, v7, v8
        if not v2[4][1].Wallbang.Active then
            return
        else
            v8 = {[2] = 1, [1] = v2[3][1].Character}
            v8[3] = v8
            v6 = v2[1][1].Character and v2[1][1].Character:FindFirstChild("HumanoidRootPart")
            if not (not v8[1] or not v6) then
                v3 = v8[1].RotVelocity
                v7 = v8[1].Velocity
                v5 = {[2] = 1, [1] = v8[1].CFrame}
                v5[3] = v5
                v7 = {[2] = 1, [1] = v7}
                v7[3] = v7
                v3 = {[2] = 1, [1] = v3}
                v3[3] = v3
                cFrame2 = v6.CFrame
                cFrame3 = CFrame.new(0, -5, 0)
                v8[1].CFrame = cFrame2 * cFrame3
                v4 = v1:De({v2[2], v3, v5, v8, v7})
                v2[2][1]:BindToRenderStep("__restore", 101, v4)
                return
            end
        end
    end
end
local function _w248(v1, v2)
    return function(enabled)
        local v3, heartbeat3
        if enabled then
            if not v2[2][1].InfiniteJump.Conn then
                heartbeat3 = v2[3][1].Heartbeat
                v2[2][1].InfiniteJump.Conn = heartbeat3:Connect(v1:Te({v2[1], v2[2]}))
                v2[2][1].InfiniteJump.Enabled = enabled
            end
            return
        elseif v2[2][1].InfiniteJump.Conn then
            v3 = v2[2][1]
            v3.InfiniteJump.Conn:Disconnect()
            v3.InfiniteJump.Conn = nil
        end
        v2[2][1].InfiniteJump.Enabled = enabled
    end
end
local function _w249(v1, v2)
    return function(fogDistance)
        local v3 = v2[1][1]
        v3.FogDistance = fogDistance
        v3 = v3.FogEnabled
        if v3 then
            applyFog()
        end
    end
end
local function _w250(v1)
    return function(espDistance)
        EspSettings.EspDistance = espDistance
    end
end
local function _w251(v1, v2)
    return function()
        v2[1][1]:Replicate("FavoritedCosmetics")
    end
end
local function _w252(v1, v2)
    return function()
        while true do
            if task.wait(0.5) then
                pcall(v1:Fd())
                pcall(v1:Ed({v2[1]}))
                continue
            end
            break
        end
    end
end
local function _w253(v1, v2)
    return function(anchorPoint)
        local frame7 = Instance.new("Frame", v2[1][1])
        frame7.BorderSizePixel = 0
        frame7.AnchorPoint = anchorPoint
        local uIStroke7 = Instance.new("UIStroke", frame7)
        uIStroke7.Color = Color3.fromRGB(0, 0, 0)
        uIStroke7.Thickness = 1.5
        return frame7
    end
end
local function _w254(v1)
    return function(espEnemyWeapons)
        EspSettings.EspEnemyWeapons = espEnemyWeapons
    end
end
local function _w255(v1, v2)
    return function()
        local v3, v4, v5
        v5, v3, v4 = pairs(v2[2][1]._spheres)
        v5, v3, v4 = v1.g(v5, v3, v4)
        local v6, v7
        v6, v7 = v5(v3, v4)
        if v6 ~= nil then
            while true do
                v7 = {[2] = 1, [1] = v7}
                v7[3] = v7
                pcall(v1:ie({v7}))
                v6, v7 = v5(v3, v4)
                v4 = v6
                if v4 == nil then
                    break
                end
            end
        end
        v2[2][1]._spheres = {}
        v3 = v2[1][1]
        v4, v3 = v3, v3.GetPlayers
        v3 = v1.h(v3(v4))
        v5, v3, v4 = ipairs(v1.i(v3))
        v5, v3, v4 = v1.g(v5, v3, v4)
        v6, v7 = v5(v3, v4)
        local v8, v9
        if v6 ~= nil then
            while true do
                if v7.Character then
                    v8 = v7.Character
                    v9, v8 = v8, v8.FindFirstChild
                    v8 = {[2] = 1, [1] = v8(v9, "Dark_ESPSphere")}
                    v8[3] = v8
                    if v8[1] then
                        pcall(v1:je({v8}))
                    end
                end
                v6, v7 = v5(v3, v4)
                v4 = v6
                if v4 == nil then
                    break
                end
            end
        end
    end
end
local function _w256(v1, v2)
    return function(v3)
        v3 = {[2] = 1, [1] = v3}
        v3[3] = v3
        local v4 = v2[2][1]
        local v5, v6, v7
        if not (v3[1] ~= v4) then
            v4 = {[2] = 1, [1] = nil}
            v4[3] = v4
            v5 = v3[1].ChildAdded
            v7 = v1:Se({v4, v2[3], v3})
            v6, v5 = v5, v5.Connect
            v4[1], v6 = v5(v6, v7), table
            v7, v6, v5 = v4[1], v2[1][1], v6.insert
            v5(v6, v7)
            v2[3][1](v3[1])
        end
    end
end
local function _w257(v1, v2)
    return function(v3, v4, v5)
        local v6, name7, v7, v8
        if not v4 then
            v6 = v2[4][1]
            v6 = table.pack(v6(v3, v4, v5))
            return table.unpack(v6, 1, v6.n)
        else
            v7 = v2[3][1][v4.Name]
            if v7 and v7.Skin and v4.Skin == v7.Skin then
                name7 = v7.Skin.Name
                v8 = v3.ViewModels[name7]
                return v8[v5 and "ImageHighResolution" or "Image"] or v8.Image
            end
            v8 = v2[4][1]
            v8 = table.pack(v8(v3, v4, v5))
            return table.unpack(v8, 1, v8.n)
        end
    end
end
local function _w258(v1, v2)
    return function()
        if v2[1][1]._label then
            v2[1][1]._label.Visible = false
        end
    end
end
local function _w259(v1)
    return function(v2)
        local v3, v4, v5, v6, viewModels3, v7, v8
        if v2 then
            viewModels3 = workspace:FindFirstChild("ViewModels")
            if viewModels3 then
                v5 = viewModels3.GetChildren
                v5 = v1.h(v5(viewModels3))
                v6, v5, v3 = ipairs(v1.i(v5))
                v6, v5, v3 = v1.g(v6, v5, v3)
                v7, v4 = v6(v5, v3)
                v3 = v7
                if v3 ~= nil then
                    while true do
                        v8 = v4:IsA("Model")
                        if not v8 then
                            v7, v4 = v6(v5, v3)
                            v3 = v7
                            if v3 ~= nil then
                                continue
                            end
                            return nil
                        end
                        v8 = string.split(v4.Name, " - ")
                        if not (#v8 >= 1 and v8[1] == v2.Name) then
                            v7, v4 = v6(v5, v3)
                            v3 = v7
                            if v3 ~= nil then
                                continue
                            end
                            return nil
                        end
                        break
                    end
                    if #v8 >= 3 then
                        return v8[3]
                    else
                        return v4.Name
                    end
                end
            end
        end
        return nil
    end
end
local function _w260(v1)
    return function(espChams)
        EspSettings.EspChams = espChams
    end
end
local function _w261(v1, v2)
    return function(size)
        v2[1][1].Size = size
    end
end
local function _w262(v1)
    return function(espGlowColorMode)
        EspSettings.EspGlowColorMode = espGlowColorMode
    end
end
local function _w263(v1, v2)
    return function(v3)
        if v3.Name == "CustomLeaderstats" then
            task.wait(0.1)
            v2[2][1](v2[3][1])
            if v2[1][1] then
                v2[1][1]:Disconnect()
            end
        end
    end
end
local function _w264(v1, v2)
    return function(v3)
        local v4, color2, v5, v6, v7, v8, v9, v10
        if not v2[4][1].Enabled then
            v2[6][1].Visible = false
        else
            v2[6][1].Visible = true
            color2 = Color3.fromRGB(160, 32, 240)
            v2[5][1].BackgroundColor3 = color2
            v2[2][1].BackgroundColor3 = color2
            v2[1][1].BackgroundColor3 = color2
            v2[3][1].BackgroundColor3 = color2
            v4 = v2[6][1]
            v7 = v2[4][1]
            v10 = v7.SPIN_SPEED * v3
            v4.Rotation = (v4.Rotation + v10) % 360
            v4 = tick() * v7.PULSE_SPEED
            v5 = math.sin(v4) + 1
            v8 = v7.MIN_GAP
            v10 = v5 / 2 * (v7.MAX_GAP - v8)
            v5 = v7.MIN_GAP + v10
            v9 = v2[5][1]
            v6, v7, v8 = v7.BASE_LENGTH, v7.THICKNESS, 0
            v9.Size = UDim2.new(0, v7, 0, v6)
            v9.Position = UDim2.new(0, 0, 0, -v5)
            v9 = v2[2][1]
            v8 = v2[4][1]
            v6, v7, v8 = v2[4][1], v8.THICKNESS, 0
            v9.Size = UDim2.new(0, v7, 0, v6.BASE_LENGTH)
            v9.Position = UDim2.new(0, 0, 0, v5)
            v9 = v2[1][1]
            v8 = v2[4][1]
            v6, v7, v8 = v2[4][1], v8.BASE_LENGTH, 0
            v9.Size = UDim2.new(0, v7, 0, v6.THICKNESS)
            v9.Position = UDim2.new(0, -v5, 0, 0)
            v9 = v2[3][1]
            v7 = v2[4][1].BASE_LENGTH
            v6 = v2[4][1]
            v9.Size = UDim2.new(0, v7, 0, v6.THICKNESS)
            v9.Position = UDim2.new(0, v5, 0, 0)
        end
    end
end
local function _w265(v1, v2)
    return function()
        while true do
            task.wait()
            if v2[2][1].CurrentData then
                break
            end
        end
        local currentData = v2[2][1].CurrentData
        v2[1][1] = currentData
    end
end
local function _w266(v1, v2)
    return function()
        while true do
            if not task.wait(0.25) then
                break
            end
        end
    end
end
local function _w267(v1, v2)
    return function()
        v2[1][1].Parent = game:GetService("CoreGui")
    end
end
local function _w268(v1, v2)
    return function()
        while true do
            if not task.wait(1) then
                break
            end
        end
    end
end
local function _w269(v1, v2)
    return function(autoTrigger)
        v2[1][1].Automation.SubspaceTripmines.AutoTrigger = autoTrigger
    end
end
local function _w270(v1, v2)
    return function()
        v2[1][1]:Replicate("WeaponInventory")
    end
end
local function _w271(v1, v2)
    return function(enabled)
        local v3, v4, v5, v6
        if enabled then
            if not v2[4][1].Wallbang.OldFunc then
                v4 = v2[3][1]
                v3 = v4.StartShooting
                v2[4][1].Wallbang.OldFunc = v3
                v4.StartShooting = v2[5][1]
            end
            v4 = {}
            v6 = v2[2][1]
            v4.Title = "Wallbang"
            v4.Description = "Enabled!"
        else
            if v2[4][1].Wallbang.OldFunc then
                v5 = v2[4][1]
                v3 = v5.Wallbang.OldFunc
                v2[3][1].StartShooting = v3
                v5.Wallbang.OldFunc = nil
            end
            v2[1][1]()
            v4 = {}
            v6 = v2[2][1]
            v4.Title = "Wallbang"
            v4.Description = "Disabled!"
        end
        v4.Time = 2
        v6:Notify(v4)
        v2[4][1].Wallbang.Enabled = enabled
    end
end
local function _w272(v1, v2)
    return function(fogEnabled)
        v2[1][1].FogEnabled = fogEnabled
        applyFog()
    end
end
local function _w273(v1)
    return function()
        removeAllSpheres()
    end
end
local function _w274(v1)
    return function(v2)
        EspSettings.FilledBoxTransparency = v2 / 100
    end
end
local function _w275(v1, v2)
    return function()
        local v3 = {[2] = 1, [1] = v2[2][1].katanaWarning}
        v3[3] = v3
        local v4 = getgenv()
        local v5 = {[2] = 1, [1] = v4._Dark_V12_Helpers}
        v5[3] = v5
        v4 = {[2] = 1, [1] = v4}
        v4[3] = v4
        v4[1] = v1:Le({v2[3], v3})
        local v6 = {[2] = 1, [1] = nil}
        v6[3] = v6
        local v7, v8
        v6[1], v7, v8 = v1:Me({v3}), task, v1:Oe({v3})
        local spawn
        v7, spawn = v1:Ne({v3, v4, v6, v2[3], v5, v2[1]}), v7.spawn
        spawn(v7)
        return {show = v4[1], hide = v6[1], destroy = v8}
    end
end
local function _w276(v1, v2)
    return function(v3)
        local v4, v5, v6
        if not v2[1][1] then
            return nil
        else
            v6 = v2[1][1]
            v4, v5 = pcall(v6.ToEnum, v6, v3)
            return v4 and v5 or nil
        end
    end
end
local function _w277(v1, v2)
    return function()
        while true do
            if not task.wait(2) then
                break
            end
        end
    end
end
local function _w278(v1, v2)
    return function()
        local t, _
        local v3, v4, textLabel4, v5, v6, v7, v8, uIPadding2, uICorner4, viewModels4, v9, v10
        if not v2[4][1].Enabled then
            return
        else
            v4 = tick()
            if v4 - v2[4][1]._lastUpdate >= 0.2 then
                v2[4][1]._lastUpdate = v4
                viewModels4 = workspace:FindFirstChild("ViewModels")
                if viewModels4 then
                    v3 = {}
                    v9, _, v7 = pairs(v2[4][1]._labels)
                    v9, _, v7 = v1.g(v9, _, v7)
                    v5, t = v9(_, v7)
                    v7 = v5
                    if v7 ~= nil then
                        while true do
                            v3[v5] = false
                            v5, t = v9(_, v7)
                            v7 = v5
                            if v7 == nil then
                                break
                            end
                        end
                    end
                    _ = viewModels4.GetChildren
                    _ = v1.h(_(viewModels4))
                    v9, _, v7 = ipairs(v1.i(_))
                    v9, _, v7 = v1.g(v9, _, v7)
                    for _, t in v9, _, v7 do
                        if t:IsA("Model") then
                            v6 = t.Name
                            v8 = v2[3][1](v6)
                            if v8 ~= v2[1][1].Name then
                                v10 = t.Name
                                v6 = v2[2][1](v10)
                                v3[v8] = true
                                if not v2[4][1]._labels[v8] then
                                    v10 = v2[4][1]._container:FindFirstChild("List")
                                    textLabel4 = Instance.new("TextLabel")
                                    textLabel4.Name = "W_" .. v8
                                    textLabel4.Size = UDim2.new(1, 0, 0, 24)
                                    textLabel4.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
                                    textLabel4.BackgroundTransparency = 0.2
                                    textLabel4.Font = Enum.Font.GothamSemibold
                                    textLabel4.TextSize = 12
                                    textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
                                    textLabel4.TextXAlignment = Enum.TextXAlignment.Left
                                    textLabel4.Parent = v10
                                    uICorner4 = Instance.new("UICorner")
                                    uICorner4.CornerRadius = UDim.new(0, 4)
                                    uICorner4.Parent = textLabel4
                                    uIPadding2 = Instance.new("UIPadding")
                                    uIPadding2.PaddingLeft = UDim.new(0, 8)
                                    uIPadding2.Parent = textLabel4
                                    v2[4][1]._labels[v8] = textLabel4
                                end
                                if v2[4][1]._labels[v8] then
                                    v2[4][1]._labels[v8].Text = v8 .. ": " .. v6
                                end
                            end
                        end
                    end
                    v9, _, v7 = pairs(v2[4][1]._labels)
                    v9, _, v7 = v1.g(v9, _, v7)
                    v5, t = v9(_, v7)
                    v7 = v5
                    if v7 ~= nil then
                        while true do
                            t = {[2] = 1, [1] = t}
                            t[3] = t
                            if not v3[v5] then
                                pcall(v1:Xd({t}))
                                v2[4][1]._labels[v5] = nil
                            end
                            v5, t = v9(_, v7)
                            v7 = v5
                            if v7 == nil then
                                break
                            end
                        end
                    end
                    return
                end
            end
        end
    end
end
local function _w279(v1, v2)
    return function()
        if v2[1][1]._screenGui then
            pcall(v1:Qe({v2[1]}))
        end
        local v3 = v2[1][1]
        v3._screenGui = nil
        v3._label = nil
    end
end
local function _w280(v1, v2)
    return function(enabled)
        v2[1][1].Automation.AutoBan.Enabled = enabled
    end
end
local function _w281(v1, v2)
    return function()
        local v3 = v2[2][1]
        local v4 = v2[3][1]
        local v5 = v2[1][1]
        v3(v4, v5, 0)
        v3(v4, v5, 1)
    end
end
local function _w282(v1, v2)
    return function()
        task.wait(v2[4][1].TracerFadeTime)
        local v3 = 1
        local new4
        while true do
            if not (not v2[3][1] or not v2[3][1].Parent) then
                new4 = NumberSequence.new
                v2[3][1].Transparency = new4(v3 / 20)
                task.wait(0.05)
                v3 = v3 + 1
                if v3 <= 20 then
                    continue
                end
                break
            end
            break
        end
        pcall(v1:cf({v2[1], v2[3], v2[2]}))
    end
end
local function _w283(v1)
    return function(espFilledColorMode)
        EspSettings.EspFilledColorMode = espFilledColorMode
    end
end
local function _w284(v1, v2)
    return function(v3)
        v2[4][1]()
        local v4, sky, v5, v6, v7, v8, v9, v10, v11, v12, v13
        if v3 == "Default" then
            v9 = v2[5][1]
            v5 = {
                Ambient = v9.Ambient,
                OutdoorAmbient = v9.OutdoorAmbient,
                Brightness = v9.Brightness,
                ClockTime = v9.ClockTime,
                FogColor = v9.FogColor,
                FogEnd = v9.FogEnd,
                FogStart = v9.FogStart,
            }
            v2[3][1](v5, 1.5)
            v2[2][1]:Notify({Title = "World Theme", Description = "Restored to server defaults.", Time = 3})
        else
            v10 = v2[1][1]
            sky = Instance.new("Sky", v10)
            v5 = Instance.new("Atmosphere", v2[1][1])
            v10 = Instance.new("ColorCorrectionEffect", v2[1][1])
            sky.CelestialBodiesShown = true
            if v3 == "Snowy Blizzard" then
                v4 = {}
                v11 = v2[3][1]
                v4.Ambient = Color3.fromRGB(190, 200, 215)
                v4.OutdoorAmbient = Color3.fromRGB(160, 175, 190)
                v4.Brightness = 1.2
                v4.ClockTime = 14
                v4.FogColor = Color3.fromRGB(225, 235, 245)
                v4.FogStart = 0
                v4.FogEnd = 250
                v9, v4 = v4, 1.5
                v11(v9, 1.5)
                v5.Density = 0.45
                v5.Color = Color3.fromRGB(220, 230, 245)
                v5.Glare = 0.3
                v5.Haze = 2
                v10.Saturation = -0.2
                v10.Contrast = 0.1
                v10.TintColor = Color3.fromRGB(240, 245, 255)
                v11 = workspace:FindFirstChildOfClass("Terrain")
                if v11 then
                    v9 = Instance.new("Attachment", v11)
                    v9.Name = "ThemeSnowParticles"
                    v9.Position = Vector3.new(0, 120, 0)
                    v4 = Instance.new("ParticleEmitter", v9)
                    v4.Texture = "rbxassetid://242299839"
                    v13 = NumberSequence.new
                    v12 = {}
                    v6 = NumberSequenceKeypoint.new(0, 0.4)
                    v7 = NumberSequenceKeypoint.new
                    v7 = v1.h(v7(1, 1.2))
                    v12[1] = v6
                    v1.j(v12, 2, v1.i(v7))
                    v4.Size = v13(v12)
                    v4.Speed = NumberRange.new(30, 60)
                    v4.VelocityInverse = true
                    v4.Acceleration = Vector3.new(4, -15, 0)
                    v4.Lifetime = NumberRange.new(6, 12)
                    v4.Rate = 250
                    v12 = {}
                    v13 = NumberSequence.new
                    v6 = NumberSequenceKeypoint.new(0, 0)
                    v7 = NumberSequenceKeypoint.new(0.8, 0)
                    v8 = NumberSequenceKeypoint.new
                    v8 = table.pack(v8(1, 1))
                    v12[1], v12[2] = v6, v7
                    v1.j(v12, 3, table.unpack(v8, 1, v8.n))
                    v4.Transparency = v13(v12)
                end
            end
            v2[2][1]:Notify({Title = "World Theme", Description = "Loaded environment: " .. v3, Time = 3})
        end
    end
end
local function _w285(v1, v2)
    return function()
        local v3 = 1
        local v4 = #v2[4][1]
        local v5, v6
        if 1 <= v4 then
            while true do
                v6 = v2[3][1]
                v5 = v6._labelCount
                v6 = v6.MaxLabels
                if v5 < v6 then
                    v5 = v2[4][1][v3]
                    if v5 and v5:IsA("BasePart") and v2[1][1](v5) then
                        v2[2][1](v5)
                    end
                    if v3 % 50 == 0 then
                        task.wait()
                    end
                    v3 = v3 + 1
                    if v3 <= v4 then
                        continue
                    end
                    break
                end
                break
            end
        end
    end
end
local function _w286(v1, v2)
    return function()
        local v3, v4, v5, v6, v7, v8, v9, v10, v11, position5, v12, v13, v14, v15, v16, v17, v18
        while true do
            local shouldExit = false
            v5 = v13
            v9 = "blade"
            v18 = string.find(v5, "blade")
            while true do
                while true do
                    if v18 then
                        goto __L235
                    end
                    ::__L49::
                    v8, v7 = v11(v10, v6)
                    v6 = v8
                    if v6 == nil then
                        v11 = v2[2][1]
                        v11()
                        v15 = v2[1][1]
                        v16 = v15._label
                        if v16 then
                            v14 = v2[1][1]
                            v15 = v14._label
                            v16 = v15.Visible
                        end
                        goto __L235
                    end
                    v13 = v2[4][1]
                    v3 = v7 ~= v13 and v7.Character
                    if v3 then
                        v3 = v2[5][1].getEnemyHeldWeapon(v7)
                        v13 = string.lower(v3)
                        v9 = "katana"
                        v5 = v13
                        v18 = string.find(v5, "katana")
                        if not v18 then
                            v9 = "sword"
                            v5 = v13
                            v18 = string.find(v5, "sword")
                        end
                        if v18 then
                            goto __L235
                        else
                            shouldExit = true
                            break
                        end
                    else
                        goto __L49
                    end
                    ::__L86::
                    v12 = v5.Position
                    v9 = v15.Position - v12
                    v17 = v9.Magnitude
                    v12 = 0
                    if v17 > 0 then
                        v15, v16 = 0.1, v15.wait
                        v16(0.1)
                        if getgenv().Dark_AntiKatanaEnabled then
                            v15 = getgenv()
                            v16 = v15.Dark_AntiKatanaEnabled()
                            v4 = 0.3
                            goto __L49
                        end
                    else
                        goto __L49
                    end
                    v15 = v2[1][1]
                    v16 = v15._label
                    if v16 then
                        v14 = v2[1][1]
                        v15 = v14._label
                        v16 = v15.Visible
                    end
                    ::__L235::
                    v17 = "HumanoidRootPart"
                    v18 = v7.Character
                    v5 = v18:FindFirstChild("HumanoidRootPart")
                    v9 = v5
                    if v9 then
                        position5 = v5.Position
                        v17 = (v15.Position - position5).Magnitude
                        v12 = 150
                        v9 = v17 <= 150
                    end
                    goto __L86
                end
            end
            if not shouldExit then
                break
            end
        end
    end
end
local function _w287(v1, v2)
    return function()
        local fromRGB, worldColorName
        if v2[2][1].WorldColorEnabled then
            worldColorName = v2[2][1].WorldColorName
            v2[1][1].Ambient = v2[3][1][worldColorName]
        else
            fromRGB = Color3.fromRGB
            v2[1][1].Ambient = fromRGB(128, 128, 128)
        end
    end
end
local function _w288(v1, v2)
    return function(v3)
        local v4 = {}
        v4.Red = Color3.fromRGB(255, 50, 50)
        v4.Blue = Color3.fromRGB(0, 180, 255)
        v4.Purple = Color3.fromRGB(160, 32, 240)
        v4.Yellow = Color3.fromRGB(255, 230, 50)
        v4.Pink = Color3.fromRGB(255, 105, 180)
        v4.Orange = Color3.fromRGB(255, 140, 0)
        v4.Cyan = Color3.fromRGB(0, 255, 255)
        v4.Green = Color3.fromRGB(0, 255, 0)
        local v5
        v5, v4 = v4, v2[1][1]
        v4.Color = v5[v3] or Color3.fromRGB(0, 255, 0)
    end
end
local function _w289(v1)
    return function(v2)
        local split3 = string.split(v2, " - ")
        if #split3 >= 1 then
            return split3[1]
        else
            return "Unknown"
        end
    end
end
local function _w290(v1, v2)
    return function(colorMode)
        v2[1][1].ColorMode = colorMode
    end
end
local function _w291(v1, v2)
    return function()
        v2[1][1].draw:Remove()
    end
end
local function _w292(v1, v2)
    return function()
        local v3 = v2[4][1].Character
        local v4
        if not v3 then
            return
        elseif not v3:FindFirstChildOfClass("Humanoid") then
            return
        else
            task.wait(0.05)
            v4 = v2[4][1]
            v4.CameraMode = Enum.CameraMode.LockFirstPerson
            v4.CameraMaxZoomDistance = v2[1][1]
            v4.CameraMinZoomDistance = v2[2][1]
            return
        end
    end
end
local function _w293(v1)
    return function()
        local drawing = Drawing.new("Text")
        drawing.Text = "TRIPMINE"
        drawing.Size = 18
        drawing.Color = Color3.fromRGB(255, 80, 80)
        drawing.Center = true
        drawing.Outline = true
        drawing.Visible = false
        return drawing
    end
end
local function _w294(v1, v2)
    return function()
        local currentData2
        if not v2[2][1] and v2[3][1].CurrentData then
            currentData2 = v2[3][1].CurrentData
            v2[2][1] = currentData2
        end
        if v2[2][1] then
            v2[2][1]:Replicate(v2[1][1])
        end
    end
end
local function _w295(v1)
    return function(v2)
        EspSettings.HighlightPulseRange = v2 / 100
    end
end
local function _w296(v1)
    return function(v2, v3, v10, ...)
        local v4 = v2
        local v5 = v1.h(v3, v10, ...)
        local v6 = {}
        v1.j(v6, 1, v1.i(v5))
        local v7, v8, v9
        v8, v9, v7 = ipairs(v6)
        v8, v9, v7 = v1.g(v8, v9, v7)
        v6, v5 = v8(v9, v7)
        if v6 ~= nil then
            while true do
                if v4 then
                    v4 = v4:FindFirstChild(v5)
                    v6, v5 = v8(v9, v7)
                    v7 = v6
                    if v7 ~= nil then
                        continue
                    end
                    return v4
                end
                break
            end
            return nil
        end
        return v4
    end
end
local function _w297(v1)
    return function(v2)
        getgenv().NameSpooferConfig.spoofed_winstreak = tonumber(v2) or 56
    end
end
local function _w298(v1, v2)
    return function()
        while true do
            if not task.wait(0.5) then
                break
            end
        end
    end
end
local function _w299(v1)
    return function(boxSizeMultiplier)
        EspSettings.BoxSizeMultiplier = boxSizeMultiplier
    end
end
local function _w300(v1, v2)
    return function(enabled)
        v2[4][1].Fly.Enabled = enabled
        local v3, fly, v4
        if enabled then
            if v2[4][1].Fly.Conn then
                v2[4][1].Fly.Conn:Disconnect()
            end
            fly = v2[4][1].Fly
            v3 = v2[3][1]
            v4 = v1:If({v2[4], v2[1], v2[2]})
            fly.Conn = v3.Heartbeat:Connect(v4)
        elseif v2[4][1].Fly.Conn then
            v3 = v2[4][1]
            v3.Fly.Conn:Disconnect()
            v3.Fly.Conn = nil
        end
    end
end
local function _w301(v1, v2)
    return function()
        v2[1][1].Parent = game:GetService("CoreGui")
    end
end
local function _w302(v1)
    return function()
        Instance.new("Part"):InvalidMethod("a")
    end
end
local function _w303(v1, v2)
    return function()
        local m, c
        local playerGui = v2[1][1]:FindFirstChildOfClass("PlayerGui")
        local v3, v4, v5, v6, v7, lower, v8
        if playerGui then
            v5 = playerGui.GetChildren
            v5 = v1.h(v5(playerGui))
            v7, v5, v8 = ipairs(v1.i(v5))
            v7, v5, v8 = v1.g(v7, v5, v8)
            for _, c in v7, v5, v8 do
                v3 = c.GetDescendants
                v3 = v1.h(v3(c))
                v6, v3, v4 = ipairs(v1.i(v3))
                v6, v3, v4 = v1.g(v6, v3, v4)
                for _, m in v6, v3, v4 do
                    if m:IsA("Frame") or m:IsA("ImageLabel") then
                        lower = m.Name:lower()
                        if lower:find("flash") or lower:find("blind") or lower:find("stun") or lower:find("whiteout") then
                            m.Visible = false
                        end
                    end
                end
            end
        end
    end
end
local function _w304(v1, v2)
    return function(maps)
        v2[1][1].Automation.AutoVote.Maps = maps
    end
end
local function _w305(v1)
    return function(your_spoofed_name)
        getgenv().NameSpooferConfig.your_spoofed_name = your_spoofed_name
    end
end
local function _w306(v1, v2)
    return function(tracerWidth)
        v2[1][1].TracerWidth = tracerWidth
    end
end
local function _w307(v1, v2)
    return function(v3)
        v3 = {[2] = 1, [1] = v3}
        v3[3] = v3
        local connect, v4
        if v3[1] then
            v4 = v1:Ue({v3, v2[2]})
            connect = v3[1].ChildAdded:Connect(v4)
            v4 = v2[1][1]
            table.insert(v4, connect)
        end
    end
end
local function _w308(v1)
    return function()
        getgenv()._Dark_V12_KatanaWarning.destroy()
    end
end
local function _w309(v1, v2)
    return function()
        local level_spoof
        while true do
            if task.wait(3) then
                level_spoof = getgenv().NameSpooferConfig.level_spoof
                v2[2][1](v2[1][1])
                continue
            end
            break
        end
    end
end
local function _w310(v1, v2)
    return function(v3)
        v3 = {[2] = 1, [1] = v3}
        v3[3] = v3
        v3[1].CharacterAdded:Connect(v1:Af({v2[4], v2[3], v3, v2[5], v2[2]}))
        local v4 = v1:zf({v2[5], v2[1]})
        v3[1].CharacterRemoving:Connect(v4)
    end
end
local function _w311(v1)
    return function(v2)
        local viewModels5, camera2, lower2
        if not v2 or not v2:IsA("BasePart") then
            return false
        else
            viewModels5 = workspace:FindFirstChild("ViewModels")
            if viewModels5 and v2:IsDescendantOf(viewModels5) then
                return false
            else
                camera2 = workspace.CurrentCamera
                if camera2 and v2:IsDescendantOf(camera2) then
                    return false
                else
                    lower2 = string.lower(v2.Name or "")
                    if string.find(lower2, "tripmine") then
                        return true
                    else
                        string.find(lower2, "subspace")
                        v2:FindFirstAncestorOfClass("Model")
                        return false
                    end
                end
            end
        end
    end
end
local function _w312(v1, v2)
    return function(v3)
        v3 = {[2] = 1, [1] = v3}
        v3[3] = v3
        local v4
        if v3[1] then
            v4 = {
                [2] = 1,
                [1] = v3[1].FindFirstChild(v3[1], "HumanoidRootPart"),
            }
            v4[3] = v4
            if v4[1] then
                pcall(v1:re({v4, v2[1], v3}))
            end
        end
    end
end
local function _w313(v1, v2)
    return function(enabled)
        v2[4][1].SpeedHack.Enabled = enabled
        local v3, v4, speedHack
        if enabled then
            if v2[4][1].SpeedHack.Conn then
                v2[4][1].SpeedHack.Conn:Disconnect()
            end
            v3 = v2[3][1]
            speedHack = v2[4][1].SpeedHack
            v4 = v1:he({v2[1], v2[2]})
            speedHack.Conn = v3.Heartbeat:Connect(v4)
        elseif v2[4][1].SpeedHack.Conn then
            v3 = v2[4][1]
            v3.SpeedHack.Conn:Disconnect()
            v3.SpeedHack.Conn = nil
        end
    end
end
local function _w314(v1, v2)
    return function()
        v2[2][1]:FireServer(v2[1][1])
    end
end
local function _w315(v1, v2)
    return function()
        local v3 = require(v2[2][1].Modules.Pages.ViewProfile)
        local v4 = v3
        if v3 then
            v4 = v3.Fetch
        end
        if v4 then
            v4 = {[2] = 1, [1] = v3.Fetch}
            v4[3] = v4
            v3.Fetch = v1:Hf({v4, v2[1]})
        end
    end
end
local function _w316(v1, v2)
    return function(size)
        v2[1][1].Size = size
    end
end
local function _w317(v1, v2)
    return function(v3, v4)
        local v5, v6, v7
        v5, v2[2][1], v6, v7 = v3, v4, v4, v2[1][1]
        v7 = table.pack(v7(v5, v6))
        return table.unpack(v7, 1, v7.n)
    end
end
local function _w318(v1, v2)
    return function(enabled)
        v2[1][1].Automation.ModDetector.Enabled = enabled
    end
end
local function _w319(v1)
    return function(v2)
        local split4 = string.split(v2, " - ")
        if #split4 >= 3 then
            return split4[3]
        else
            return v2
        end
    end
end
local function _w320(v1, v2)
    return function(v3, v4)
        local _, n
        local v5
        v4, v5 = v4 or {}, not v3
        local v6
        if not v5 then
            v6 = v3.GetChildren
            v6 = v1.h(v6(v3))
            v5, v6, _ = ipairs(v1.i(v6))
            v5, v6, _ = v1.g(v5, v6, _)
            for _, n in v5, v6, _ do
                if n:IsA("TextLabel") and n.Name == "Title" then
                    table.insert(v4, n)
                end
                v2[1][1](n, v4)
            end
        end
        return v4
    end
end
local function _w321(v1, v2)
    return function(armLatexEnabled)
        v2[1][1].ArmLatexEnabled = armLatexEnabled
    end
end
local function _w322(v1, v2)
    return function(v3)
        local v4, v5, v6, v7, v8
        if not (not v3 or not v3.Parent) then
            v5 = v2[4][1]
            v4 = v5._labelCount
            v5 = v5.MaxLabels
            if v4 < v5 then
                v4 = workspace.CurrentCamera
                v5 = v4
                if v5 then
                    v6 = v4.CFrame.Position
                    v8 = v2[4][1].MaxDistance
                    v5 = (v3.Position - v6).Magnitude > v8
                end
                if not v5 then
                    v7 = v3.Position
                    v5 = v2[1][1](v7)
                    v7 = v2[2][1]()
                    v8 = v2[4][1]._labels
                    v6 = {draw = v7, ghost = v5}
                    v6.lastSeen = tick()
                    v6.lastPosition = v3.Position
                    v8[v3] = v6
                    v8 = v2[4][1]
                    v8._labelCount = v8._labelCount + 1
                    return
                end
            end
        end
    end
end
local function _w323(v1, v2)
    return function()
        if v2[1][1]._conn then
            v2[1][1]._conn:Disconnect()
            v2[1][1]._conn = nil
        end
        if v2[1][1]._container then
            v2[1][1]._container.Visible = false
        end
        local v3, v4, v5
        v5, v3, v4 = pairs(v2[1][1]._labels)
        v5, v3, v4 = v1.g(v5, v3, v4)
        local v6, v7
        v7, v6 = v5(v3, v4)
        if v7 ~= nil then
            while true do
                v6 = {[2] = 1, [1] = v6}
                v6[3] = v6
                pcall(v1:Wd({v6}))
                v7, v6 = v5(v3, v4)
                v4 = v7
                if v4 == nil then
                    break
                end
            end
        end
        v2[1][1]._labels = {}
    end
end
local function _w324(v1, v2)
    return function(v3, v4)
        local t
        local v5 = v2[4][1](v3, v4)
        local v6, v7, v8, v9, v10
        if v4 == "CosmeticInventory" then
            v6 = {}
            if v5 then
                v8, v7, v9 = v1.g(v5, nil, nil)
                t, v10 = v8(v7, v9)
                v9 = t
                if v9 ~= nil then
                    while true do
                        if not v2[3][1](t) then
                            v6[t] = v10
                        end
                        t, v10 = v8(v7, v9)
                        v9 = t
                        if v9 == nil then
                            break
                        end
                    end
                end
            end
            v8 = v2[1][1]
            v8, v7, v9 = v1.g(v8, nil, nil)
            for t in v8, v7, v9 do
                v6[t] = true
            end
            return v6
        else
            return v5
        end
    end
end
local function _w325(v1)
    return function()
    end
end
local function _w326(v1, v2)
    return function()
        if not v2[1][1]._destroyed then
            v2[1][1]:_UpdateWrap()
        end
    end
end
local function _w327(v1, v2)
    return function(maxDistance)
        v2[1][1].tripmine.MaxDistance = maxDistance
    end
end
local function _w328(v1, v2)
    return function()
        local v3 = teamCache
        v3.myTeamID = v2[1][1]:GetAttribute("TeamID")
        v3.lastUpdate = tick()
    end
end
local function _w329(v1)
    return function()
        if isfile("SkinChanger/config.json") then
            delfile("SkinChanger/config.json")
        end
    end
end
local function _w330(v1)
    return function(...)
        local hc, _, na
        local v2 = pcall(v1:Oc())
        while v2 do
            task.spawn()
        end
        game:GetChildren(v1:Ka())
        local v3, v4, v5
        while true do
            v4 = game
            v5, v4 = v4, v4.GetChildren
            v4, v3 = 4, #v4(v5)
            if v3 <= 4 then
                v4 = buffer.fromstring
                buffer.writei8(v4("a"), 1, 2)
                continue
            end
            break
        end
        v3, v4 = pcall(v1:qb())
        while true do
            if not v3 then
                task()
                continue
            end
            break
        end
        while true do
            if v4[6][2] == nil then
                break
            end
        end
        v5 = pcall(v1:gb())
        while not v5 do
        end
        _G.getgoldcc = "goldtm"
        while true do
            if getfenv().getgoldcc ~= nil then
                game()
                continue
            end
            break
        end
        _G.getgoldcc = nil
        local v6, v7
        v6, v7 = pcall(v1:qc())
        while true do
            if not v7:find("attempt to call a Instance value") then
                table.create(9000000000)
                continue
            end
            break
        end
        if not game:IsLoaded() then
            game.Loaded:Wait()
        end
        local v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30, v31, v32, v33, v34, v35, v36, v37, v38, v39, v40, v41, v42, v43, v44, v45, v46, v47, modules, v48, v49, v50, v51, v52, v53, v54, v55, v56, v57, v58, v59, bb2, v60, v61, v62, v63, v64, v65, v66, v67, v68, v69, v70, v71, v72, v73, v74, v75, v76, v77, v78, v79, v80, v81, v82, v83, v84, v85, v86, v87, v88, v89, v90, v91, v92, v93, v94, v95, v96, v97, v98, v99, v100, v101, v102, v103, v104, addRightGroupbox, v105, v106, v107, v108, v109, addRightGroupbox2, addRightGroupbox3, v110, v111, v112, v113, v114, v115, v116, v117, v118, v119, v120, v121, v122, v123, v124, v125, v126, v127, v128, v129, v130, v131, v132, v133, v134, v135, v136, v137, v138, v139, v140, v141, addRightGroupbox4, v142, v143, v144, v145, v146, v147
        if game.GameId ~= 6035872082 then
            warn("This script is only for Rivals!")
        else
            v137 = game
            v63, v137 = v137, v137.GetService
            v137 = {[2] = 1, [1] = v137(v63, "Players")}
            v137[3] = v137
            v63 = game
            v127, v63 = v63, v63.GetService
            v63 = {[2] = 1, [1] = v63(v127, "ReplicatedStorage")}
            v63[3] = v63
            v127 = game
            v107, v127 = v127, v127.GetService
            v127 = {[2] = 1, [1] = v127(v107, "RunService")}
            v127[3] = v127
            game:GetService("HttpService")
            v61 = game
            v79, v61 = v61, v61.GetService
            v61 = {[2] = 1, [1] = v61(v79, "Lighting")}
            v61[3] = v61
            v79 = game
            v140, v79 = v79, v79.GetService
            v79 = {[2] = 1, [1] = v79(v140, "TweenService")}
            v79[3] = v79
            v140 = game
            v140, v27 = v140.GetService, v140
            v140 = {[2] = 1, [1] = v140(v27, "UserInputService")}
            v140[3] = v140
            v27 = {[2] = 1, [1] = v137[1].LocalPlayer}
            v27[3] = v27
            v101 = {[2] = 1, [1] = workspace.CurrentCamera}
            v101[3] = v101
            v65 = game
            v147, v65 = v65, v65.HttpGet
            v65 = v1.h(v65(v147, "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))
            v10 = {[2] = 1, [1] = loadstring(v1.i(v65))()}
            v10[3] = v10
            v147 = game
            v145, v147 = v147, v147.HttpGet
            v147 = v1.h(v147(v145, "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))
            v65 = loadstring(v1.i(v147))()
            v145 = game
            v62, v145 = v145, v145.HttpGet
            v145 = v1.h(v145(v62, "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))
            v147 = loadstring(v1.i(v145))()
            v145 = v10[1].Options
            v10[1].ShowToggleFrameInKeybinds = true
            v19 = v1:yd()()
            _ = getgenv()
            _.NameSpooferConfig = {
                name_spoof = false,
                your_spoofed_name = "Andy",
                spoofed_enemy_names = "Johnny",
                level_spoof = false,
                spoofed_level = 996,
                winstreak_spoof = false,
                spoofed_winstreak = 56,
            }
            v43 = {
                WeaponChoices = {[1] = "Bow", [2] = "Handgun", [3] = "Fists", [4] = "Grenade"},
                WalkSpeed = 16,
                JumpPower = 50,
            }
            v43.TracerColor1 = Color3.fromRGB(255, 105, 180)
            v43.TracerColor2 = Color3.fromRGB(255, 255, 255)
            v43.TracerWidth = 0.06
            v43.TracerFadeTime = 3
            v43.TracerRainbow = false
            v43.FastFireShootTime = 0.001
            _ = {[2] = 1, [1] = v43}
            _[3] = _
            v43 = {
                [2] = 1,
                [1] = {
                    FastFire = {Enabled = false, Original = {}},
                    Wallbang = {Enabled = false, Active = false, Target = nil, Conn = nil, Task = nil, OldFunc = nil},
                    AutoLoadout = {Enabled = true, Conn = nil},
                    AutoShoot = {Enabled = false},
                    InfiniteJump = {Enabled = false, Conn = nil},
                    SkinChanger = {Enabled = false},
                    AntiFlash = {Enabled = false, OriginalHook = nil},
                    Fly = {Enabled = false, Conn = nil, Speed = 50},
                    SpeedHack = {Enabled = false, Conn = nil},
                    JumpHack = {Enabled = false, Conn = nil},
                    BulletTracer = {Enabled = false, OldShootEffect = nil},
                    Ragebot = {Enabled = false, Conn = nil, FireRate = 0.0005, WeaponSlot = "Melee", LastFire = 0},
                },
            }
            v43[3] = v43
            v130 = {[2] = 1, [1] = require(v63[1].Modules.Utility)}
            v130[3] = v130
            v14 = {
                [2] = 1,
                [1] = require(v27[1].PlayerScripts.Modules.ItemTypes.Gun),
            }
            v14[3] = v14
            v54 = {[2] = 1, [1] = require(v63[1].Modules.ItemLibrary).Items}
            v54[3] = v54
            v53 = {
                [2] = 1,
                [1] = require(v27[1].PlayerScripts.Controllers.MechanicsController),
            }
            v53[3] = v53
            v29 = v27[1].PlayerScripts.Controllers
            v29, v123 = v29.WaitForChild, v29
            v29 = v1.h(v29(v123, "DebugController"))
            v36 = {[2] = 1, [1] = require(v1.i(v29))}
            v36[3] = v36
            v29 = {
                [2] = 1,
                [1] = require(v27[1].PlayerScripts.Controllers.FighterController),
            }
            v29[3] = v29
            v37 = v27[1].PlayerScripts.Controllers
            v37, v133 = v37.WaitForChild, v37
            v37 = v1.h(v37(v133, "SpectateController"))
            v123 = {[2] = 1, [1] = require(v1.i(v37))}
            v123[3] = v123
            v37 = game:GetService("Players")
            v133 = game
            v133, v103 = v133.GetService, v133
            v133 = {[2] = 1, [1] = v133(v103, "ReplicatedStorage")}
            v133[3] = v133
            v103 = game
            v103, v64 = v103.GetService, v103
            v103 = {[2] = 1, [1] = v103(v64, "HttpService")}
            v103[3] = v103
            v64 = {[2] = 1, [1] = v37.LocalPlayer}
            v64[3] = v64
            v132 = {[2] = 1, [1] = v64[1].PlayerScripts}
            v132[3] = v132
            v47 = {[2] = 1, [1] = v132[1].Controllers}
            v47[3] = v47
            modules = v133[1].Modules
            v89 = modules.WaitForChild
            v89 = v1.h(v89(modules, "EnumLibrary", 10))
            v142 = {[2] = 1, [1] = require(v1.i(v89))}
            v142[3] = v142
            if v142[1] then
                v142[1].WaitForEnumBuilder(v142[1])
            end
            v102 = modules.WaitForChild
            v102 = v1.h(v102(modules, "CosmeticLibrary", 10))
            v89 = require(v1.i(v102))
            v99 = modules.WaitForChild
            v99 = v1.h(v99(modules, "ItemLibrary", 10))
            v102 = require(v1.i(v99))
            v85 = v47[1]
            v12 = v47[1].WaitForChild
            v12 = v1.h(v12(v85, "PlayerDataController", 10))
            v99 = {[2] = 1, [1] = require(v1.i(v12))}
            v99[3] = v99
            v12 = {[2] = 1, [1] = v89.Cosmetics}
            v12[3] = v12
            v85 = {[2] = 1, [1] = v99[1].CurrentData}
            v85[3] = v85
            if not v85[1] then
                task.spawn(v1:_b({v85, v99}))
            end
            v75 = {[2] = 1, [1] = {}}
            v75[3] = v75
            v86 = {[2] = 1, [1] = {}}
            v86[3] = v86
            v91 = {[2] = 1, [1] = nil}
            v91[3] = v91
            v74 = {[2] = 1, [1] = nil}
            v74[3] = v74
            v16 = {[2] = 1, [1] = nil}
            v16[3] = v16
            v35 = {}
            v51 = {[2] = 1, [1] = v35}
            v51[3] = v51
            v35 = {[2] = 1, [1] = v35}
            v35[3] = v35
            v35[1] = v1:wa()
            v134 = {[2] = 1, [1] = nil}
            v134[3] = v134
            v134[1] = v1:O({v142})
            v135 = {[2] = 1, [1] = nil}
            v135[3] = v135
            v135[1] = v1:wd({v134, v35, v12})
            v87 = {[2] = 1, [1] = nil}
            v87[3] = v87
            v97, bb2, v87[1] = {}, v1:Bb({v35, v103, v135, v86, v75}), v1:od({v75, v86, v103, v35})
            v98 = {[2] = 1, [1] = v97}
            v98[3] = v98
            v97 = {[2] = 1, [1] = v97}
            v97[3] = v97
            v97[1] = v1:R({v35, v75, v12, v98})
            v97[1]()
            v121 = {[2] = 1, [1] = v99[1].Get}
            v121[3] = v121
            v44 = v1:P({v98, v86, v35, v121})
            v99[1].Get = v44
            v44 = {[2] = 1, [1] = v99[1].GetWeaponData}
            v44[3] = v44
            v122 = v1:rc({v75, v44})
            v99[1].GetWeaponData = v122
            v122 = {[2] = 1, [1] = v122}
            v122[3] = v122
            v122[1], v34 = v1:Yc({v99, v85}), nil
            v34 = {[2] = 1, [1] = nil}
            v34[3] = v34
            pcall(v1:md({v47, v34}))
            v126 = {[2] = 1, [1] = pcall}
            v126[3] = v126
            v55, v126[1] = hookmetamethod, v1:ob({v64, v34})
            if v55 then
                v55 = v133[1].FindFirstChild(v133[1], "Remotes")
                v45 = v55 and v55:FindFirstChild("Data")
                v129 = {[2] = 1, [1] = v45 and v45:FindFirstChild("EquipCosmetic")}
                v129[3] = v129
                v111 = {[2] = 1, [1] = v45 and v45:FindFirstChild("FavoriteCosmetic")}
                v111[3] = v111
                v67 = v55 and v55:FindFirstChild("Replication")
                v90 = v67 and v67:FindFirstChild("Fighter")
                v42 = {[2] = 1, [1] = v90 and v90:FindFirstChild("UseItem")}
                v42[3] = v42
                if v129[1] then
                    v92 = {[2] = 1, [1] = nil}
                    v92[3] = v92
                    v11 = v1:hb({v64, v135, v129, v92, v97, v87, v122, v34, v42, v121, v86, v51, v99, v16, v75, v35, v111})
                    v92[1] = hookmetamethod(game, "__namecall", v11)
                end
            end
            v55 = {[2] = 1, [1] = nil}
            v55[3] = v55
            pcall(v1:pc({v132, v55}))
            if v55[1] and v55[1]._CreateViewModel then
                v45 = {[2] = 1, [1] = v55[1]._CreateViewModel}
                v45[3] = v45
                v129 = v1:fb({v75, v45, v64, v91})
                v55[1]._CreateViewModel = v129
            end
            v45 = v132[1].Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
            if v45 then
                v129 = require(v45)
                if v129.GetWrap then
                    v111 = {[2] = 1, [1] = v129.GetWrap}
                    v111[3] = v111
                    v129.GetWrap = v1:Qc({v111, v64, v75})
                end
                v111 = {[2] = 1, [1] = v129.new}
                v111[3] = v111
                v129.new = v1:E({v111, v133, v64, v91, v75})
            end
            v129 = {[2] = 1, [1] = v102.GetViewModelImageFromWeaponData}
            v129[3] = v129
            v102.GetViewModelImageFromWeaponData = v1:vb({v74, v64, v75, v129})
            pcall(v1:kd({v74, v132}))
            v111 = {[2] = 1, [1] = nil}
            v111[3] = v111
            pcall(v1:Ba({v132, v111}))
            if v111[1] and v111[1]._PlayFinisher then
                v67 = {[2] = 1, [1] = v111[1]._PlayFinisher}
                v67[3] = v67
                v90 = v1:ba({v75, v67, v51, v126})
                v111[1]._PlayFinisher = v90
            end
            bb2()
            v97[1]()
            v67 = v75[1]
            v67, v90, v42 = v1.g(v67, nil, nil)
            v92, v141 = v67(v90, v42)
            v42 = v92
            if v42 ~= nil then
                while true do
                    if v141.Finisher and v141.Finisher.Name then
                        v138 = v141.Finisher.Name
                        v51[1][v92] = v138
                    end
                    v92, v141 = v67(v90, v42)
                    v42 = v92
                    if v42 == nil then
                        break
                    end
                end
            end
            v67 = {
                [2] = 1,
                [1] = {Enabled = false, FireRate = 0.0005, WeaponSlot = "Melee"},
            }
            v67[3] = v67
            v42 = {Primary = 1, Secondary = 2, Melee = 3}
            v90 = {[2] = 1, [1] = v42}
            v90[3] = v90
            v42 = {[2] = 1, [1] = v42}
            v42[3] = v42
            v141, v42[1] = {}, v1:m({v67, v90})
            v92 = {[2] = 1, [1] = v141}
            v92[3] = v92
            v141 = v137[1].PlayerRemoving
            v104 = v1:yb({v92})
            v138 = v141
            v141:Connect(v104)
            v141 = {[2] = 1, [1] = v141}
            v141[3] = v141
            v141[1] = v1:mc({v92, v29})
            v138 = {[2] = 1, [1] = v138}
            v138[3] = v138
            v138[1] = v1:s({v123, v27})
            v104 = {[2] = 1, [1] = v104}
            v104[3] = v104
            v104[1] = v1:Rc({v138, v27, v137})
            v11 = {[2] = 1, [1] = v11}
            v11[3] = v11
            v88, v11[1] = 0, v1:wb()
            v88 = {[2] = 1, [1] = 0}
            v88[3] = v88
            v46 = {[2] = 1, [1] = nil}
            v46[3] = v46
            v46[1] = v1:K({v27, v11, v127, v67, v29, v88, v130, v104, v141, v92, v63})
            v32 = {[2] = 1, [1] = nil}
            v32[3] = v32
            v32[1], v8 = v1:x({v42, v46, v29, v67, v127, v43, v10}), task
            v8, v124 = v1:La({v42, v67, v29}), v8.spawn
            v124(v8)
            v124 = {[2] = 1, [1] = v124}
            v124[3] = v124
            v71, v96, v73, v33, v115, v22, v72, v94, v136, v116, v26, v114, v41, v124[1], v119 = "ResetTime", "SwingCooldown", "Cooldown", "ShootCooldown", "ShootSpread", "RecoveryTime", "FireDelay", "ShootBurstCooldown", "AttackCooldown", "FireRate", {}, "ShootRecoil", "ShootDelay", v1:nc({_, v10, v14, v43}), "ShootAccuracy"
            v26[1], v26[2], v26[3], v26[4], v26[5], v26[6], v26[7], v26[8], v26[9], v26[10], v26[11], v26[12], v26[13] = "ShootSpread", "ShootAccuracy", "ShootRecoil", "ShootCooldown", "ShootBurstCooldown", "AttackCooldown", "SwingCooldown", "Cooldown", "RecoveryTime", "ResetTime", "FireRate", "FireDelay", "ShootDelay"
            v8 = {[2] = 1, [1] = v26}
            v8[3] = v8
            v26 = {[2] = 1, [1] = v26}
            v26[3] = v26
            v26[1] = v1:Pa({v54, v43, _})
            v115 = {[2] = 1, [1] = "ShootSpread"}
            v115[3] = v115
            v115[1] = v1:ga({v10, v26, _, v54, v8, v43})
            v119 = {[2] = 1, [1] = "ShootAccuracy"}
            v119[3] = v119
            v119[1] = v1:u({v137, v27})
            v114 = {[2] = 1, [1] = "ShootRecoil"}
            v114[3] = v114
            v114[1] = v1:ab({v27, v43, v127})
            v33 = {[2] = 1, [1] = "ShootCooldown"}
            v33[3] = v33
            v33[1] = v1:tc({v43})
            v94 = {[2] = 1, [1] = "ShootBurstCooldown"}
            v94[3] = v94
            v94[1] = v1:ic({v33, v130, v119, v43, v114})
            v136 = {[2] = 1, [1] = "AttackCooldown"}
            v136[3] = v136
            v71, v136[1] = v63[1].Remotes, v1:ua({v33, v10, v14, v43, v94})
            v96 = {[2] = 1, [1] = v71.Replication.Fighter.PickWeapons}
            v96[3] = v96
            v73 = {[2] = 1, [1] = v63[1].Remotes.Duels.PickWeaponsAheadOfTime}
            v73[3] = v73
            v71 = {}
            v71[1], v71[2], v71[3], v71[4], v71[5], v71[6], v71[7], v71[8], v71[9], v71[10], v71[11], v71[12], v71[13], v71[14], v71[15], v71[16] = "Bow", "Handgun", "Fists", "Grenade", "Rifle", "Shotgun", "SMG", "Sniper", "Rocket Launcher", "Flamethrower", "Minigun", "Crossbow", "Katana", "Sword", "Staff", "Dagger"
            v71[17], v71[18], v71[19], v71[20], v71[21], v71[22], v71[23], v71[24], v71[25], v71[26], v71[27], v71[28], v71[29], v71[30], v71[31] = "Axe", "Hammer", "Spear", "Whip", "Throwable", "Shield", "Dual Pistols", "Revolver", "Scythe", "Trident", "Blowgun", "Boomerang", "Grappling Hook", "Shuriken", "Nunchucks"
            v22 = v71
            v71 = {[2] = 1, [1] = v71}
            v71[3] = v71
            v71[1] = v1:A({_, v27, v96, v43, v73})
            v116 = {[2] = 1, [1] = "Axe"}
            v116[3] = v116
            v116[1] = v1:za({v10, v36, v43})
            v72 = {[2] = 1, [1] = "Hammer"}
            v72[3] = v72
            v72[1] = v1:L({v27, v43})
            v41 = {[2] = 1, [1] = "Spear"}
            v41[3] = v41
            v41[1] = v1:Hb({v53, v43, v127})
            v48 = {[2] = 1, [1] = "Whip"}
            v48[3] = v48
            v48[1] = v1:_a({_, v27, v127, v43})
            v15 = {[2] = 1, [1] = "Throwable"}
            v15[3] = v15
            v15[1] = v1:Va({_, v27, v127, v43})
            v100 = {[2] = 1, [1] = "Shield"}
            v100[3] = v100
            v100[1], v112, v113 = v1:nd({v27, v140, v127, v43}), "MouseKeyboard", {}
            v113.Computer = "MouseKeyboard"
            v113.Mobile = "Touch"
            v113.Console = "Gamepad"
            v113.VR = "VR"
            v93 = {[2] = 1, [1] = v113}
            v93[3] = v93
            v13 = {}
            v113 = v1:Cc({v63, v93, v10})
            v112 = {[2] = 1, [1] = v13}
            v112[3] = v112
            v13 = {[2] = 1, [1] = v13}
            v13[3] = v13
            v13[1] = v1:zc({v27})
            v120 = {[2] = 1, [1] = "Blowgun"}
            v120[3] = v120
            v120[1] = v1:H({v27})
            v20 = {[2] = 1, [1] = "Boomerang"}
            v20[3] = v20
            v118, v143, v56, v60, v25, v20[1], v105 = {}, "Elements", "MainGui", "Container", "PlayerGui", v1:Dd({v20}), "PlayerList"
            v118[1], v118[2], v118[3], v118[4], v118[5], v118[6], v118[7], v118[8], v118[9] = "PlayerGui", "MainGui", "PlayerList", "Container", "Elements", "Container", "Middle", "List", "Container"
            v18 = {[2] = 1, [1] = v118}
            v18[3] = v18
            v118 = {[2] = 1, [1] = v118}
            v118[3] = v118
            v118[1] = v1:Nb({v18, v27})
            v25 = {[2] = 1, [1] = "PlayerGui"}
            v25[3] = v25
            v25[1] = v1:oc({v20, v27})
            v56 = {[2] = 1, [1] = "MainGui"}
            v56[3] = v56
            v56[1] = v1:Jb({v112, v25})
            v105 = v1:Ub({v118, v27, v25, v56})
            v60 = v1:Eb({v112, v27, v120})
            v144 = v137[1]
            v49 = v137[1].GetPlayers
            v49 = v1.h(v49(v144))
            v143, v49, v144 = ipairs(v1.i(v49))
            v143, v49, v144 = v1.g(v143, v49, v144)
            for _, na in v143, v49, v144 do
                v13[1](na)
                if na == v27[1] then
                    v60(na)
                end
            end
            na, v49, v143, v144 = v1:cb({v13}), v112[1], table.insert, v137[1].PlayerAdded
            v144, v83 = v144.Connect, v144
            v144 = v1.h(v144(v83, na))
            v143(v49, v1.i(v144))
            v49 = v1:Gc({v27, v120})
            task.spawn(v49)
            v105()
            v49 = {
                Ambient = v61[1].Ambient,
                OutdoorAmbient = v61[1].OutdoorAmbient,
                Brightness = v61[1].Brightness,
                ClockTime = v61[1].ClockTime,
                FogColor = v61[1].FogColor,
                FogEnd = v61[1].FogEnd,
            }
            v144 = v61[1].FogStart
            v49.FogStart = v144
            v143 = {[2] = 1, [1] = v49}
            v143[3] = v143
            v49 = {[2] = 1, [1] = v49}
            v49[3] = v49
            v49[1] = v1:tb({v61})
            v144 = {[2] = 1, [1] = v144}
            v144[3] = v144
            v144[1] = v1:va({v61, v79})
            v83 = v1:pd({v61, v10, v144, v49, v143})
            na = {
                [2] = 1,
                [1] = {
                    ThirdpersonEnabled = false,
                    ThirdpersonDistance = 12,
                    ThirdpersonActivation = "Always on",
                    FOVOverrideEnabled = false,
                    FOVOverrideValue = 120,
                    WorldColorEnabled = false,
                    WorldColorName = "white",
                    FogEnabled = false,
                    FogColorName = "white",
                    FogDistance = 1000,
                    WeatherType = "None",
                    NightModeEnabled = false,
                    WeaponLatexEnabled = false,
                    ArmLatexEnabled = false,
                    BloomEnabled = false,
                    BloomIntensity = 20,
                },
            }
            na[3] = na
            getgenv().Dark_VisualSettings = na[1]
            v146 = {}
            v146.red = Color3.fromRGB(255, 0, 0)
            v146.orange = Color3.fromRGB(255, 165, 0)
            v146.yellow = Color3.fromRGB(255, 255, 0)
            v146.green = Color3.fromRGB(0, 255, 0)
            v146.skyblue = Color3.fromRGB(135, 206, 235)
            v146.blue = Color3.fromRGB(0, 0, 255)
            v146.violet = Color3.fromRGB(238, 130, 238)
            v146.pink = Color3.fromRGB(255, 192, 203)
            v146.white = Color3.fromRGB(255, 255, 255)
            v146.brown = Color3.fromRGB(139, 69, 19)
            v109 = {[2] = 1, [1] = v146}
            v109[3] = v109
            v146 = {[2] = 1, [1] = v27[1].CameraMaxZoomDistance}
            v146[3] = v146
            v66 = {[2] = 1, [1] = v27[1].CameraMinZoomDistance}
            v66[3] = v66
            v69 = {[2] = 1, [1] = v101[1].FieldOfView}
            v69[3] = v69
            v70 = v1:_c({v146, v66, na, v27})
            v70, applyThirdperson = v1:T({v69, na, v101}), v70
            applyFOVOverride, v70 = v70, v1:Ac({v61, na, v109})
            v70, applyWorldColor = v1:Ja({v109, na, v61}), v70
            v70, applyFog = v1:Q({na}), v70
            applyWeather, v70 = v70, v1:ud({v61, na})
            applyNightMode = v70
            v70 = {[2] = 1, [1] = v70}
            v70[3] = v70
            v70[1] = v1:sa({v27})
            v76 = {[2] = 1, [1] = 19}
            v76[3] = v76
            v76[1] = v1:vd({v70, na})
            v108 = {[2] = 1, [1] = nil}
            v108[3] = v108
            v30, v108[1] = task, v1:Nc({v27, na})
            v59, v30 = v30.spawn, v1:Ea({v108, v76})
            v59(v30)
            v59 = {[2] = 1, [1] = nil}
            v59[3] = v59
            v30 = {[2] = 1, [1] = v30}
            v30[3] = v30
            v30[1] = v1:qa({v61})
            applyBloomSettings, v31, v84 = v1:zb({na, v59, v30}), v61[1].DescendantAdded, v1:ld({v59})
            v31:Connect(v84)
            v28 = v1:uc()
            task.spawn(v28)
            v31 = getgenv()
            v84 = getgenv()
            v28 = v84.Dark_HitboxExpander
            if not v28 then
                v84 = {Enabled = false, Size = 10, Transparency = 1, _originalSizes = {}}
                v28 = v84
            end
            v31.Dark_HitboxExpander = v28
            v28 = getgenv()
            v31 = {[2] = 1, [1] = v28.Dark_HitboxExpander}
            v31[3] = v31
            v28 = {[2] = 1, [1] = v28}
            v28[3] = v28
            v28[1] = v1:Kc({v31})
            v84 = {[2] = 1, [1] = v84}
            v84[3] = v84
            v84[1] = v1:Y({v31})
            restoreAllHitboxes, v77 = v1:ya({v31, v137, v84}), getgenv
            v77 = v77()
            v117 = getgenv()
            v40 = v117.Dark_ESPSphere
            if not v40 then
                v117 = {Enabled = false, Size = 6}
                v117.Color = Color3.fromRGB(0, 255, 0)
                v117.Transparency = 0.7
                v117._spheres = {}
                v40 = v117
            end
            v77.Dark_ESPSphere = v40
            v40 = getgenv()
            v77 = {[2] = 1, [1] = v40.Dark_ESPSphere}
            v77[3] = v77
            v40 = {[2] = 1, [1] = v40}
            v40[3] = v40
            v40[1] = v1:ja({v77})
            v117 = {[2] = 1, [1] = v117}
            v117[3] = v117
            v57, v117[1] = v1:ca({v137, v77}), v1:U({v77})
            v17 = {}
            removeAllSpheres = v57
            v17.Enabled = true
            v17.DebugMode = false
            TeamCheckState = v17
            teamCache, v57 = {myTeamID = nil, lastUpdate = 0}, v1:Ab({v27})
            v57()
            v95 = v27[1]
            v27[1].GetAttributeChangedSignal(v95, "TeamID"):Connect(v57)
            isTeammate = v1:Xc({v27})
            EspSettings = {
                EspBoxes = false,
                EspFilledBoxes = false,
                EspLines = false,
                EspHealth = false,
                EspNames = false,
                EspDistance = false,
                EspChams = false,
                EspSkeleton = false,
                EspGlowChams = false,
                EspEnemyWeapons = false,
                EspColorMode = "Blue",
                EspFilledColorMode = "Blue",
                EspChamsColorMode = "Cyan",
                EspGlowColorMode = "Cyan",
                MaxEspDistance = 400,
                BoxThickness = 1.5,
                LineThickness = 1,
                BoxSizeMultiplier = 1300,
                ChamsBrightness = 5,
                GlowBrightness = 3,
                FilledBoxTransparency = 0.4,
                HeadScale = 1,
                TeamCheckESP = false,
                ArrowESP = false,
                _arrows = {},
                HighlightPulse = false,
                HighlightPulseSpeed = 1,
                HighlightPulseRange = 0.4,
            }
            v23 = {}
            v95 = {}
            v23.Red = Color3.fromRGB(255, 50, 50)
            hc, v82, v125, v128 = 255, 180, 0, Color3.fromRGB
            v23.Blue = v128(0, 180, 255)
            hc, v82, v125, v128 = 240, 32, 160, Color3.fromRGB
            v23.Purple = v128(160, 32, 240)
            v128, v125, hc, v82 = Color3.fromRGB, 255, 50, 230
            v23.Yellow = v128(255, 230, 50)
            v82, v128, v125, hc = 105, Color3.fromRGB, 255, 180
            v23.Pink = v128(255, 105, 180)
            hc, v128, v125, v82 = 0, Color3.fromRGB, 255, 140
            v23.Orange = v128(255, 140, 0)
            v23.Cyan = Color3.fromRGB(0, 255, 255)
            v95.presets = v23
            v17, Dark_Crosshair = getgenv, v95
            v17().Dark_Crosshair = Dark_Crosshair
            EspGui = Instance.new("ScreenGui")
            EspGui.Name = "Dark_CoreAssetCache"
            EspGui.ResetOnSpawn = false
            EspGui.IgnoreGuiInset = true
            v24 = v27[1]
            EspGui.Parent = v27[1].WaitForChild(v24, "PlayerGui")
            HEALTH_BAR_OFFSET = 5
            HEALTH_BAR_WIDTH = 3
            EspRegistry = {}
            SkeletonCache = {}
            OriginalHeadSizes = {}
            v17 = {[2] = 1, [1] = getgenv().Drawing or Drawing}
            v17[3] = v17
            v128 = v137[1].GetPlayers
            v24 = v1:Vb()
            v125 = v137[1]
            v95 = v1:id({v27})
            v128 = v1.h(v128(v125))
            v23, v128, v125 = ipairs(v1.i(v128))
            v23, v128, v125 = v1.g(v23, v128, v125)
            for _, hc in v23, v128, v125 do
                v95(hc)
            end
            v137[1].PlayerAdded:Connect(v95)
            v137[1].PlayerRemoving:Connect(v24)
            RestoreHeadScales = v1:dd()
            v23 = {[2] = 1, [1] = {}}
            v23[3] = v23
            getEnemyWeaponName = v1:N({v23})
            task.spawn(v1:qd({v23}))
            v82 = v1:xd({v137, v27, v101, v17})
            espPipelineConn = v127[1].RenderStepped:Connect(v82)
            v125 = v1:Tc({v31, v137, v27, v77, v40, v28, v117})
            task.spawn(v125)
            v137[1].PlayerAdded:Connect(v1:Mc({v117, v28, v77, v40, v31}))
            v128 = getgenv()
            v125 = getgenv().Dark_V12
            if not v125 then
                v82 = {viewModels = nil}
                v82.tripmine = {
                    Enabled = false,
                    MaxDistance = 300,
                    MaxLabels = 50,
                    _labels = {},
                    _ghosts = {},
                    _labelCount = 0,
                    _updateConn = nil,
                    _renderConn = nil,
                    _addedConn = nil,
                    _removedConn = nil,
                }
                v82.enemyWeapons = {
                    Enabled = false,
                    _container = nil,
                    _screenGui = nil,
                    _labels = {},
                    _conn = nil,
                    _lastUpdate = 0,
                }
                v82.katanaWarning = {_label = nil, _screenGui = nil, _expiry = 0}
                v125 = v82
            end
            v128.Dark_V12 = v125
            v128 = {[2] = 1, [1] = getgenv().Dark_V12}
            v128[3] = v128
            getgenv()._Dark_V12_Helpers = v1:ma({v128})()
            getgenv()._Dark_V12_Tripmine = v1:Ic({v127, v128, v27})()
            getgenv()._Dark_V12_EnemyWeapons = v1:C({v127, v128, v27})()
            getgenv()._Dark_V12_KatanaWarning = v1:ub({v137, v128, v27})()
            hc = v1:y({v27})
            v137[1].PlayerRemoving:Connect(hc)
            Dark_V12Cleanup, v125 = v1:Sa(), getgenv
            v125().Dark_V12Cleanup = Dark_V12Cleanup
            hc = {
                Title = "Dark Rivals V5",
                Footer = "by Cryovex | Executions: " .. v19,
                NotifySide = "Right",
                ShowCustomCursor = true,
            }
            v125 = v10[1].CreateWindow(v10[1], hc)
            hc = {}
            hc.Player = v125:AddTab("Player", "user")
            hc.Rage = v125:AddTab("Rage", "zap")
            hc.Visuals = v125:AddTab("Visuals", "eye")
            hc.Automation = v125:AddTab("Automation", "bot")
            hc.Misc = v125:AddTab("Misc", "sparkles")
            hc.Settings = v125:AddTab("UI Settings", "settings")
            v82 = hc
            hc = hc.Player
            hc = hc:AddLeftGroupbox("Loadout", "backpack")
            addRightGroupbox4 = v82.Player:AddRightGroupbox("Movement & Defense", "run")
            hc:AddToggle("AutoLoadout", {Text = "Auto Loadout", Default = true, Callback = v71[1]})
            v38 = 1
            v139 = 1
            while true do
                v139 = {[2] = 1, [1] = v139}
                v139[3] = v139
                v39 = "Weapon" .. v139[1]
                v68 = {
                    Values = v22,
                    Default = _[1].WeaponChoices[v139[1]] or "Fists",
                    Multi = false,
                    Text = "Weapon Slot " .. v139[1],
                }
                v68.Callback = v1:jd({v139, _})
                hc:AddDropdown(v39, v68)
                v38 = v38 + 1
                v139 = v38
                if v38 > 4 then
                    break
                end
            end
            addRightGroupbox4:AddToggle("BypassSpeed", {Text = "Enable WalkSpeed", Default = false, Callback = v48[1]})
            v139 = {
                Text = "WalkSpeed Value",
                Default = 16,
                Min = 16,
                Max = 150,
                Rounding = 0,
            }
            v139.Callback = v1:mb({_})
            addRightGroupbox4:AddSlider("SpeedVal", v139)
            addRightGroupbox4:AddToggle("BypassJump", {Text = "Enable JumpPower", Default = false, Callback = v15[1]})
            v139 = {
                Text = "JumpPower Value",
                Default = 50,
                Min = 50,
                Max = 250,
                Rounding = 0,
            }
            v139.Callback = v1:xb({_})
            addRightGroupbox4:AddSlider("JumpVal", v139)
            addRightGroupbox4:AddToggle("InfiniteJump", {Text = "Infinite Double Jump", Default = false, Callback = v41[1]})
            addRightGroupbox4:AddToggle("FlyHack", {Text = "Bypass Flight Mode", Default = false, Callback = v100[1]})
            v139 = {
                Text = "Flight Velocity",
                Default = 50,
                Min = 10,
                Max = 200,
                Rounding = 0,
            }
            v139.Callback = v1:sd({v43})
            addRightGroupbox4:AddSlider("FlySpeed", v139)
            addRightGroupbox4:AddToggle("AntiFlash", {Text = "Anti Flashbang Effect", Default = false, Callback = v72[1]})
            v38 = v82.Rage:AddLeftGroupbox("Combat", "crosshair")
            addRightGroupbox3 = v82.Rage:AddRightGroupbox("Weapon Mods", "target")
            addRightGroupbox2 = v82.Rage:AddRightGroupbox("Ragebot", "zap")
            v38:AddToggle("FastFire", {Text = "Fast Fire", Default = false, Risky = true, Callback = v115[1]})
            v39 = {
                Text = "Shoot Time (seconds)",
                Default = 0.001,
                Min = 0.0001,
                Max = 0.5,
                Rounding = 4,
                Suffix = "s",
                Tooltip = "Customize how fast your weapon shoots when Fast Fire is enabled.\nLower = faster. 0.0001 = near-instant, 0.01 = 10ms, 0.1 = 100ms.",
            }
            v39.Callback = v1:oa({v26, _, v43})
            v38:AddSlider("FastFireShootTime", v39)
            v38:AddToggle("Wallbang", {Text = "Wallbang", Default = false, Risky = true, Callback = v136[1]})
            addRightGroupbox3:AddToggle("AutoShoot", {Text = "Auto Shoot (PC)", Default = false, Callback = v116[1]})
            v39 = {Text = "Enable Ragebot", Default = false, Risky = true}
            v39.Callback = v1:Uc({v32})
            addRightGroupbox2:AddToggle("RagebotEnabled", v39)
            v39 = {}
            v50 = {}
            v50[1], v50[2], v50[3] = "Primary", "Secondary", "Melee"
            v39.Values = v50
            v39.Default = "Melee"
            v39.Multi = false
            v39.Text = "Weapon Slot"
            v39.Callback = v1:S({v67})
            addRightGroupbox2:AddDropdown("RagebotWeaponSlot", v39)
            v39 = {
                Text = "Fire Rate (seconds)",
                Default = 0.0005,
                Min = 0.0001,
                Max = 1,
                Rounding = 4,
            }
            v39.Callback = v1:td({v67})
            addRightGroupbox2:AddSlider("RagebotFireRate", v39)
            v139 = v82.Visuals:AddLeftGroupbox("Visual Effects", "sparkles")
            addRightGroupbox = v82.Visuals:AddRightGroupbox("World", "cloud")
            v139:AddToggle("BulletTracer", {Text = "Bullet Tracer", Default = false, Callback = v124[1]})
            v50 = {
                Text = "Tracer Fade Time (seconds)",
                Default = 3,
                Min = 1,
                Max = 10,
                Rounding = 0,
            }
            v50.Callback = v1:p({_})
            v139:AddSlider("TracerFadeTime", v50)
            v50 = {
                Text = "Tracer Width",
                Default = 0.06,
                Min = 0.01,
                Max = 0.2,
                Rounding = 2,
            }
            v50.Callback = v1:W({_})
            v139:AddSlider("TracerWidth", v50)
            v131 = v139:AddLabel("Tracer Color 1")
            v50 = {}
            v50.Default = Color3.fromRGB(255, 105, 180)
            v50.Callback = v1:na({_})
            v131:AddColorPicker("TracerColor1", v50)
            v131 = v139:AddLabel("Tracer Color 2")
            v50 = {}
            v50.Default = Color3.fromRGB(255, 255, 255)
            v50.Callback = v1:la({_})
            v131:AddColorPicker("TracerColor2", v50)
            v50 = {Text = "Rainbow Mode", Default = false}
            v50.Callback = v1:sc({_})
            v139:AddToggle("TracerRainbow", v50)
            v139:AddDivider()
            v139:AddLabel("Weapon & Arm Latex", true)
            v50 = {Text = "Weapon Latex (Viewmodel)", Default = false}
            v50.Callback = v1:t({na})
            v139:AddToggle("WeaponLatex", v50)
            v50 = {Text = "Arm Latex (Character)", Default = false}
            v50.Callback = v1:Ta({na})
            v139:AddToggle("ArmLatex", v50)
            v139:AddDivider()
            v139:AddLabel("Bloom Effect", true)
            v50 = {Text = "Enable Bloom", Default = false}
            v50.Callback = v1:ac({na})
            v139:AddToggle("BloomEnabled", v50)
            v50 = {
                Text = "Bloom Intensity",
                Default = 20,
                Min = 1,
                Max = 100,
                Rounding = 0,
            }
            v50.Callback = v1:jc({na})
            v139:AddSlider("BloomIntensity", v50)
            v139:AddDivider()
            v139:AddLabel("Thirdperson & FOV", true)
            v50 = {Text = "Thirdperson Mode", Default = false}
            v50.Callback = v1:ad({na})
            v139:AddToggle("Thirdperson", v50)
            v50 = {
                Text = "Thirdperson Distance",
                Default = 12,
                Min = 5,
                Max = 30,
                Rounding = 0,
            }
            v50.Callback = v1:_d({na})
            v139:AddSlider("ThirdpersonDistance", v50)
            v50 = {}
            v106 = {}
            v106[1], v106[2], v106[3], v106[4] = "Always on", "K", "O", "P"
            v50.Values = v106
            v50.Default = "Always on"
            v50.Multi = false
            v50.Text = "Activation Key"
            v50.Callback = v1:xc({na})
            v139:AddDropdown("ThirdpersonActivation", v50)
            v50 = {Text = "FOV Override", Default = false}
            v50.Callback = v1:wc({na})
            v139:AddToggle("FOVOverride", v50)
            v50 = {Text = "FOV Value", Default = 120, Min = 70, Max = 170, Rounding = 0}
            v50.Callback = v1:Vc({na})
            v139:AddSlider("FOVOverrideValue", v50)
            v139:AddDivider()
            v139:AddLabel("Player ESP", true)
            v50 = {Text = "Box Outlines", Default = false}
            v50.Callback = v1:Lc()
            v139:AddToggle("EspBoxes", v50)
            v50 = {}
            v106 = {}
            v106[1], v106[2], v106[3], v106[4], v106[5], v106[6], v106[7], v106[8] = "Red", "Blue", "Purple", "Yellow", "Pink", "Orange", "Cyan", "Rainbow"
            v50.Values = v106
            v50.Default = "Blue"
            v50.Multi = false
            v50.Text = "Box Color"
            v50.Callback = v1:yc()
            v139:AddDropdown("EspColorMode", v50)
            v50 = {Text = "Filled Boxes", Default = false}
            v50.Callback = v1:hc()
            v139:AddToggle("EspFilledBoxes", v50)
            v106 = {}
            v50 = {}
            v106[1], v106[2], v106[3], v106[4], v106[5], v106[6], v106[7], v106[8] = "Red", "Blue", "Purple", "Yellow", "Pink", "Orange", "Cyan", "Rainbow"
            v50.Values = v106
            v50.Default = "Blue"
            v50.Multi = false
            v50.Text = "Filled Box Color"
            v50.Callback = v1:Yb()
            v139:AddDropdown("EspFilledColorMode", v50)
            v50 = {
                Text = "Filled Transparency",
                Default = 40,
                Min = 0,
                Max = 100,
                Rounding = 0,
                Suffix = "%",
            }
            v50.Callback = v1:bc()
            v139:AddSlider("FilledBoxTransparency", v50)
            v50 = {Text = "Line Tracers", Default = false}
            v50.Callback = v1:Ha()
            v139:AddToggle("EspLines", v50)
            v50 = {Text = "Health Bars", Default = false}
            v50.Callback = v1:Wc()
            v139:AddToggle("EspHealth", v50)
            v50 = {Text = "Player Names", Default = false}
            v50.Callback = v1:n()
            v139:AddToggle("EspNames", v50)
            v50 = {Text = "Distance Tags", Default = false}
            v50.Callback = v1:Gb()
            v139:AddToggle("EspDistance", v50)
            v50 = {Text = "Enemy Weapon Names", Default = false}
            v50.Callback = v1:Aa()
            v139:AddToggle("EspEnemyWeapons", v50)
            v50 = {Text = "Skeleton ESP", Default = false}
            v50.Callback = v1:Db()
            v139:AddToggle("EspSkeleton", v50)
            v50 = {
                Text = "Max ESP Distance",
                Default = 400,
                Min = 50,
                Max = 2000,
                Rounding = 0,
                Suffix = " studs",
            }
            v50.Callback = v1:Hc()
            v139:AddSlider("MaxEspDistance", v50)
            v50 = {
                Text = "Box Thickness",
                Default = 2,
                Min = 1,
                Max = 5,
                Rounding = 1,
            }
            v50.Callback = v1:jb()
            v139:AddSlider("BoxThickness", v50)
            v50 = {
                Text = "Tracer Thickness",
                Default = 1,
                Min = 1,
                Max = 5,
                Rounding = 1,
            }
            v50.Callback = v1:pa()
            v139:AddSlider("LineThickness", v50)
            v50 = {Text = "Box Scale", Default = 1300, Min = 800, Max = 2000, Rounding = 0}
            v50.Callback = v1:Fc()
            v139:AddSlider("BoxSizeMultiplier", v50)
            v50 = {
                Text = "Head Scale",
                Default = 100,
                Min = 100,
                Max = 300,
                Rounding = 0,
                Suffix = "%",
            }
            v50.Callback = v1:Fb()
            v139:AddSlider("HeadScale", v50)
            v50 = {Text = "ESP Team Check", Default = false, Tooltip = "Skip teammates when drawing ESP."}
            v50.Callback = v1:B()
            v139:AddToggle("TeamCheckESP", v50)
            v50 = {
                Text = "Arrow ESP (Off-screen)",
                Default = false,
                Tooltip = "Draw arrows pointing to off-screen enemies.",
            }
            v50.Callback = v1:lb()
            v139:AddToggle("ArrowESP", v50)
            v139:AddDivider()
            v139:AddLabel("Neon Chams", true)
            v50 = {Text = "Enable Neon Chams", Default = false}
            v50.Callback = v1:ec()
            v139:AddToggle("EspChams", v50)
            v106 = {}
            v50 = {}
            v106[1], v106[2], v106[3], v106[4], v106[5], v106[6], v106[7], v106[8] = "Red", "Blue", "Purple", "Yellow", "Pink", "Orange", "Cyan", "Rainbow"
            v50.Values = v106
            v50.Default = "Cyan"
            v50.Multi = false
            v50.Text = "Chams Color"
            v50.Callback = v1:ib()
            v139:AddDropdown("EspChamsColorMode", v50)
            v50 = {Text = "Glow Power", Default = 5, Min = 1, Max = 15, Rounding = 1}
            v50.Callback = v1:Ra()
            v139:AddSlider("ChamsBrightness", v50)
            v50 = {Text = "Enable Glow Chams", Default = false}
            v50.Callback = v1:Ad()
            v139:AddToggle("EspGlowChams", v50)
            v50 = {}
            v106 = {}
            v106[1], v106[2], v106[3], v106[4], v106[5], v106[6], v106[7], v106[8] = "Red", "Blue", "Purple", "Yellow", "Pink", "Orange", "Cyan", "Rainbow"
            v50.Values = v106
            v50.Default = "Cyan"
            v50.Multi = false
            v50.Text = "Glow Color"
            v50.Callback = v1:o()
            v139:AddDropdown("EspGlowColorMode", v50)
            v50 = {
                Text = "Glow Brightness",
                Default = 3,
                Min = 1,
                Max = 15,
                Rounding = 1,
            }
            v50.Callback = v1:J()
            v139:AddSlider("GlowBrightness", v50)
            v50 = {Text = "Highlight Pulse", Default = false, Tooltip = "Makes chams pulse / breathe."}
            v50.Callback = v1:ha()
            v139:AddToggle("HighlightPulse", v50)
            v50 = {
                Text = "Pulse Speed",
                Default = 10,
                Min = 1,
                Max = 50,
                Rounding = 0,
            }
            v50.Callback = v1:Ua()
            v139:AddSlider("HighlightPulseSpeed", v50)
            v50 = {
                Text = "Pulse Range",
                Default = 40,
                Min = 0,
                Max = 95,
                Rounding = 0,
                Suffix = "%",
            }
            v50.Callback = v1:Ga()
            v139:AddSlider("HighlightPulseRange", v50)
            v139:AddDivider()
            v139:AddLabel("Hitbox Expander", true)
            v50 = {Text = "Enable Hitbox Expander", Default = false}
            v50.Callback = v1:vc({v31})
            v139:AddToggle("HitboxExpander", v50)
            v50 = {
                Text = "Hitbox Size",
                Default = 10,
                Min = 1,
                Max = 30,
                Rounding = 1,
            }
            v50.Callback = v1:v({v31})
            v139:AddSlider("HitboxSize", v50)
            v50 = {
                Text = "Hitbox Transparency",
                Default = 100,
                Min = 0,
                Max = 100,
                Rounding = 0,
                Suffix = "%",
            }
            v50.Callback = v1:Wa({v31})
            v139:AddSlider("HitboxTransparency", v50)
            v50 = {Text = "3D ESP Sphere", Default = false}
            v50.Callback = v1:Qa({v77})
            v139:AddToggle("ESPSphere", v50)
            v50 = {
                Text = "Sphere Size",
                Default = 6,
                Min = 1,
                Max = 20,
                Rounding = 1,
            }
            v50.Callback = v1:Sc({v77})
            v139:AddSlider("ESPSphereSize", v50)
            v106 = {}
            v50 = {}
            v106[1], v106[2], v106[3], v106[4], v106[5], v106[6], v106[7], v106[8] = "Red", "Blue", "Purple", "Yellow", "Pink", "Orange", "Cyan", "Green"
            v50.Values = v106
            v50.Default = "Green"
            v50.Multi = false
            v50.Text = "Sphere Color"
            v50.Callback = v1:Kb({v77})
            v139:AddDropdown("ESPSphereColor", v50)
            v50 = {
                Text = "Sphere Transparency",
                Default = 70,
                Min = 0,
                Max = 100,
                Rounding = 0,
                Suffix = "%",
            }
            v50.Callback = v1:F({v77})
            v139:AddSlider("ESPSphereTransparency", v50)
            v139:AddDivider()
            v139:AddLabel("Tripmine Sixth Sense", true)
            v50 = {
                Text = "Tripmine ESP (Sixth Sense)",
                Default = false,
                Tooltip = "Detects all Subspace Tripmines in workspace and shows a red ESP label.\nSurvives the fade-out of the tripmine visual model (uses a ghost anchor).\nCritical for spotting hidden traps.",
            }
            v50.Callback = v1:Na({v10, v128})
            v139:AddToggle("TripmineESP", v50)
            v50 = {
                Text = "Max Detection Distance",
                Default = 300,
                Min = 50,
                Max = 1000,
                Rounding = 0,
                Suffix = " studs",
            }
            v50.Callback = v1:kc({v128})
            v139:AddSlider("TripmineDistance", v50)
            v139:AddDivider()
            v139:AddLabel("Enemy Weapons Panel", true)
            v50 = {
                Text = "Show Enemy Weapons Panel",
                Default = false,
                Tooltip = "Side panel listing each enemy's current weapon.\nUpdates every 0.2s from ViewModels.",
            }
            v50.Callback = v1:Ec({v10, v128})
            v139:AddToggle("EnemyWeaponsPanel", v50)
            v139:AddDivider()
            v139:AddLabel("Animated Crosshair", true)
            v131 = {[2] = 1, [1] = Instance.new("ScreenGui")}
            v131[3] = v131
            v131[1].Name = "Dark_AnimatedCrosshair"
            v131[1].IgnoreGuiInset = true
            v131[1].ResetOnSpawn = false
            v131[1].DisplayOrder = 500
            pcall(v1:Ya({v131}))
            if not v131[1].Parent then
                v68 = v27[1]
                v39 = v27[1].WaitForChild(v68, "PlayerGui")
                v131[1].Parent = v39
            end
            v39 = {[2] = 1, [1] = Instance.new("Frame", v131[1])}
            v39[3] = v39
            v68 = UDim2.new(0, 0, 0, 0)
            v39[1].Size = v68
            v68 = UDim2.new(0.5, 0, 0.5, 0)
            v39[1].Position = v68
            v39[1].BackgroundTransparency = 1
            v68 = Vector2.new(0.5, 0.5)
            v39[1].AnchorPoint = v68
            v39[1].Visible = false
            v68 = v1:Da({v39})
            v78 = Vector2.new
            v78 = v1.h(v78(0.5, 1))
            v50 = {[2] = 1, [1] = v68(v1.i(v78))}
            v50[3] = v50
            v106 = Vector2.new
            v106 = v1.h(v106(0.5, 0))
            v78 = {[2] = 1, [1] = v68(v1.i(v106))}
            v78[3] = v78
            v80 = Vector2.new
            v80 = v1.h(v80(1, 0.5))
            v106 = {[2] = 1, [1] = v68(v1.i(v80))}
            v106[3] = v106
            v81 = Vector2.new
            v81 = v1.h(v81(0, 0.5))
            v80 = {[2] = 1, [1] = v68(v1.i(v81))}
            v80[3] = v80
            v81 = {
                [2] = 1,
                [1] = {
                    Enabled = false,
                    ColorMode = "Purple",
                    SPIN_SPEED = 45,
                    THICKNESS = 3,
                    BASE_LENGTH = 14,
                    MIN_GAP = 4,
                    MAX_GAP = 12,
                    PULSE_SPEED = 3,
                },
            }
            v81[3] = v81
            getgenv().Dark_CrosshairSettings = v81[1]
            v21 = v1:bb({v106, v78, v80, v81, v50, v39})
            v127[1].RenderStepped:Connect(v21)
            v58 = {Text = "Animated Crosshair", Default = false}
            v58.Callback = v1:db({v81})
            v139:AddToggle("AnimatedCrosshair", v58)
            v110 = {}
            v58 = {}
            v110[1], v110[2], v110[3], v110[4], v110[5], v110[6], v110[7], v110[8] = "Red", "Blue", "Purple", "Yellow", "Pink", "Orange", "Cyan", "Rainbow"
            v58.Values = v110
            v58.Default = "Purple"
            v58.Multi = false
            v58.Text = "Crosshair Color"
            v58.Callback = v1:X({v81})
            v139:AddDropdown("CrosshairColor", v58)
            v139:AddDivider()
            v139:AddLabel("Grenade Effects", true)
            v131 = {
                [2] = 1,
                [1] = {HideSmoke = false, HideFlashbang = false, LockIndicator = false},
            }
            v131[3] = v131
            v78 = {Text = "Hide Smoke", Default = false, Tooltip = "Removes smoke grenade visual effects."}
            v78.Callback = v1:sb({v131})
            v139:AddToggle("HideSmoke", v78)
            v78 = {Text = "Hide Flashbang", Default = false, Tooltip = "Removes flashbang screen effects."}
            v78.Callback = v1:Ob({v131})
            v139:AddToggle("HideFlashbang", v78)
            v78 = {Text = "Lock Indicator", Default = false, Tooltip = "Shows LOCKED / SCANNING indicator."}
            v78.Callback = v1:nb({v131})
            v139:AddToggle("LockIndicator", v78)
            v68 = v1:q({v27, v131})
            task.spawn(v68)
            addRightGroupbox:AddDivider()
            addRightGroupbox:AddLabel("World Visual Effects", true)
            v78 = {Text = "World Color", Default = false}
            v78.Callback = v1:Pc({na})
            addRightGroupbox:AddToggle("WorldColor", v78)
            v80 = {}
            v78 = {}
            v80[1], v80[2], v80[3], v80[4], v80[5], v80[6], v80[7], v80[8], v80[9], v80[10] = "red", "orange", "yellow", "green", "skyblue", "blue", "violet", "pink", "white", "brown"
            v78.Values = v80
            v78.Default = "white"
            v78.Multi = false
            v78.Text = "World Color"
            v78.Callback = v1:Pb({na})
            addRightGroupbox:AddDropdown("WorldColorName", v78)
            v78 = {Text = "Fog", Default = false}
            v78.Callback = v1:fd({na})
            addRightGroupbox:AddToggle("FogEnabled", v78)
            v80 = {}
            v78 = {}
            v80[1], v80[2], v80[3], v80[4], v80[5], v80[6], v80[7], v80[8], v80[9], v80[10] = "red", "orange", "yellow", "green", "skyblue", "blue", "violet", "pink", "white", "brown"
            v78.Values = v80
            v78.Default = "white"
            v78.Multi = false
            v78.Text = "Fog Color"
            v78.Callback = v1:M({na})
            addRightGroupbox:AddDropdown("FogColorName", v78)
            v78 = {
                Text = "Fog Distance",
                Default = 1000,
                Min = 100,
                Max = 10000,
                Rounding = 0,
            }
            v78.Callback = v1:Ma({na})
            addRightGroupbox:AddSlider("FogDistance", v78)
            v78 = {}
            v80 = {}
            v80[1], v80[2], v80[3] = "None", "Rain", "Snow"
            v78.Values = v80
            v78.Default = "None"
            v78.Multi = false
            v78.Text = "Weather Effect"
            v78.Callback = v1:ka({na})
            addRightGroupbox:AddDropdown("WeatherType", v78)
            v78 = {Text = "Night Mode", Default = false}
            v78.Callback = v1:gc({na})
            addRightGroupbox:AddToggle("NightMode", v78)
            addRightGroupbox:AddDivider()
            v78 = {}
            v80 = {}
            v80[1], v80[2], v80[3], v80[4], v80[5], v80[6] = "Default", "Snowy Blizzard", "Blood Moon", "Cyberpunk Neon", "The Void", "Abyssal Ocean"
            v78.Values = v80
            v78.Default = "Default"
            v78.Multi = false
            v78.Text = "Select World Environment"
            v78.Callback = v83
            addRightGroupbox:AddDropdown("EnvTheme", v78)
            v68 = {
                AutoQueue = {Enabled = false, Queue = "1v1"},
                AutoVote = {Enabled = false, Maps = {}},
                AutoBan = {Enabled = false, FirstWeapons = {}, SecondWeapons = {}},
                AutoRespawn = {Enabled = false},
                AutoLoadout = {Enabled = false, PerMap = false, MultipleLoadouts = false, Loadouts = {}},
            }
            v78 = {Enabled = false}
            v78.Types = {Ammo = true, Health = true}
            v68.AutoPickupDrops = v78
            v68.AntiKatana = {Enabled = true}
            v68.SubspaceTripmines = {AutoTrigger = false, TeamTrigger = false}
            v68.HackerDetector = {Enabled = false, Notify = false}
            v68.ModDetector = {Enabled = false, Moderators = {}, ModFriends = {}}
            _[1].Automation = v68
            v39 = {}
            v50 = v63[1]
            v68 = v63[1].FindFirstChild(v50, "Remotes")
            if v68 then
                v50 = v1:Bc()
                v39.PickWeapons = v50(v68, "Replication", "Fighter", "PickWeapons")
                v39.RespawnNow = v50(v68, "Duels", "RespawnNow")
                v39.Vote = v50(v68, "Duels", "Vote")
                v39.UseItem = v50(v68, "Replication", "Fighter", "UseItem")
                v39.TrashRangeItems = v50(v68, "Misc", "ShootingRangeTrashItems")
            end
            v68 = _[1].Automation
            v50 = _[1].Automation.MapList
            if not v50 then
                v78 = {}
                v78[1], v78[2], v78[3], v78[4], v78[5], v78[6], v78[7], v78[8], v78[9], v78[10], v78[11], v78[12], v78[13] = "Arena", "Dojo", "Temple", "Volcano", "Ice Rink", "Rooftop", "Neon City", "Snowy Peaks", "Colosseum", "Docks", "Desert", "Cave", "Sky Islands"
                v50 = v78
            end
            v68.MapList = v50
            v68 = {[2] = 1, [1] = nil}
            v68[3] = v68
            pcall(v1:xa({v27, v68}))
            v78 = v1:Qb({v68, _})
            task.spawn(v78)
            v68 = {[2] = 1, [1] = v39.Vote}
            v68[3] = v68
            if v68[1] then
                v78 = v1:Mb({v68, _})
                task.spawn(v78)
            end
            v68 = {[2] = 1, [1] = v39.Vote}
            v68[3] = v68
            if v68[1] then
                v78 = v1:ed({v68, _})
                task.spawn(v78)
            end
            v68 = {[2] = 1, [1] = v39.RespawnNow}
            v68[3] = v68
            if v68[1] then
                v50 = task.spawn
                v78 = v1:hd({v68, _, v27})
                v50(v78)
            end
            if v96[1] and v73[1] then
                v50 = v1:cd({v73, v96, v27, _})
                task.spawn(v50)
            end
            v68 = {[2] = 1, [1] = getgenv().firetouchinterest or firetouchinterest}
            v68[3] = v68
            if v68[1] then
                v50 = task.spawn
                v78 = v1:pb({v68, _, v27})
                v50(v78)
            end
            v68 = getgenv()
            v50 = v1:Rb({_})
            v68.Dark_AntiKatanaEnabled = v50
            v68 = {[2] = 1, [1] = v68}
            v68[3] = v68
            v68[1] = v1:V()
            v50 = {[2] = 1, [1] = v50}
            v50[3] = v50
            v50[1] = v1:Cd()
            v78 = {[2] = 1, [1] = v78}
            v78[3] = v78
            v78[1], v106 = v1:Cb({v50, v27, v68}), getgenv
            v106().Dark_IsEnemyDeflecting = v1:cc({v78, v137, v27})
            v80 = v1:z({v78, v10, v137, _})
            task.spawn(v80)
            v68 = {[2] = 1, [1] = getgenv().firetouchinterest or firetouchinterest}
            v68[3] = v68
            if v68[1] then
                v78 = v1:Dc({v68, _, v27})
                task.spawn(v78)
            end
            v68 = {[2] = 1, [1] = {}}
            v68[3] = v68
            task.spawn(v1:Wb({v10, v68, v137, _, v27}))
            v50 = {}
            v68 = {[2] = 1, [1] = v50}
            v68[3] = v68
            v50 = {[2] = 1, [1] = v50}
            v50[3] = v50
            v50[1], v106 = v1:ia({_}), task
            v78, v106 = v106.spawn, v1:dc({v68, v50, v10, _, v27, v137})
            v78(v106)
            v68 = v82.Automation
            v50 = v68:AddLeftGroupbox("Match Flow", "bot")
            v81 = {Text = "Auto Queue", Default = false}
            v81.Callback = v1:da({_})
            v50:AddToggle("AutoQueueEnabled", v81)
            v52 = {}
            v81 = {}
            v52[1], v52[2], v52[3], v52[4], v52[5], v52[6], v52[7] = "1v1", "2v2", "3v3", "4v4", "Casual", "Ranked", "Arcade"
            v81.Values = v52
            v81.Default = "1v1"
            v81.Multi = false
            v81.Text = "Queue Type"
            v81.Callback = v1:ea({_})
            v50:AddDropdown("AutoQueueMode", v81)
            v50:AddDivider()
            v81 = {Text = "Auto Vote", Default = false}
            v81.Callback = v1:fc({_})
            v50:AddToggle("AutoVoteEnabled", v81)
            v81 = {
                Values = _[1].Automation.MapList,
                Default = {},
                Multi = true,
                Text = "Maps to Vote For",
            }
            v81.Callback = v1:Ia({_})
            v50:AddDropdown("AutoVoteMaps", v81)
            v50:AddDivider()
            v81 = {Text = "Auto Weapon Ban", Default = false}
            v81.Callback = v1:rd({_})
            v50:AddToggle("AutoBanEnabled", v81)
            v81 = {Values = v22, Default = {}, Multi = true, Text = "First Ban Choices"}
            v81.Callback = v1:Lb({_})
            v50:AddDropdown("AutoBanFirst", v81)
            v81 = {Values = v22, Default = {}, Multi = true, Text = "Second Ban Choices"}
            v81.Callback = v1:Oa({_})
            v50:AddDropdown("AutoBanSecond", v81)
            v50:AddDivider()
            v81 = {Text = "Auto Respawn", Default = false}
            v81.Callback = v1:Xb({_})
            v50:AddToggle("AutoRespawnEnabled", v81)
            v78 = v68:AddLeftGroupbox("Auto Loadout", "backpack")
            v9 = {Text = "Auto Loadout on Spawn", Default = false}
            v9.Callback = v1:w({_})
            v78:AddToggle("AutoLoadoutEnabled", v9)
            v9 = {Text = "Use Map-Specific Loadouts", Default = false}
            v9.Callback = v1:Ib({_})
            v78:AddToggle("AutoLoadoutPerMap", v9)
            v106 = v68:AddRightGroupbox("In-Match Automation", "tools")
            v52 = {Text = "Auto Pickup Drops", Default = false}
            v52.Callback = v1:lc({_})
            v106:AddToggle("AutoPickupEnabled", v52)
            v52 = {}
            v58 = {}
            v58[1], v58[2] = "Ammo", "Health"
            v52.Values = v58
            v58 = {}
            v58[1], v58[2] = "Ammo", "Health"
            v52.Default = v58
            v52.Multi = true
            v52.Text = "Pickup Types"
            v52.Callback = v1:Sb({_})
            v106:AddDropdown("AutoPickupTypes", v52)
            v106:AddDivider()
            v52 = {Text = "Anti Katana", Default = true}
            v52.Callback = v1:Ca({_})
            v106:AddToggle("AntiKatanaEnabled", v52)
            v106:AddDivider()
            v52 = {Text = "Subspace Tripmine Auto Trigger", Default = false}
            v52.Callback = v1:kb({_})
            v106:AddToggle("SubspaceAutoTrigger", v52)
            v52 = {Text = "Also Trigger Team Tripmines", Default = false}
            v52.Callback = v1:bd({_})
            v106:AddToggle("SubspaceTeamTrigger", v52)
            v80 = v68:AddRightGroupbox("Detection", "shield")
            v21 = {Text = "Hacker Detector", Default = false}
            v21.Callback = v1:I({_})
            v80:AddToggle("HackerDetectorEnabled", v21)
            v21 = {Text = "Notify on Hacker", Default = false}
            v21.Callback = v1:rb({_})
            v80:AddToggle("HackerDetectorNotify", v21)
            v80:AddDivider()
            v21 = {Text = "Moderator Detector", Default = false}
            v21.Callback = v1:Xa({_})
            v80:AddToggle("ModDetectorEnabled", v21)
            v21 = {Default = "", Numeric = false, Finished = true, Text = "Moderator Names (comma-separated)"}
            v21.Callback = v1:D({_})
            v80:AddInput("ModDetectorMods", v21)
            v21 = {Default = "", Numeric = false, Finished = true, Text = "Mod Friends (comma-separated)"}
            v21.Callback = v1:r({_})
            v80:AddInput("ModDetectorFriends", v21)
            v68 = v82.Misc:AddLeftGroupbox("Cosmetic Unlocks", "paintbrush")
            v50 = v82.Misc:AddRightGroupbox("Identity & Client Configs", "user")
            v81 = {Text = "Enable Skin Changer", Default = false}
            v81.Callback = v1:Tb({v10, v43})
            v68:AddToggle("SkinChangerEnabled", v81)
            v80 = {Text = "Refresh Cosmetics"}
            v80.Func = v1:eb({v10, v85})
            v68:AddButton(v80)
            v80 = {Text = "Clear Config"}
            v80.Func = v1:zd({v97, v10, v86, v75})
            v80.DoubleClick = true
            v68:AddButton(v80)
            v52 = {}
            v81 = {}
            v52[1], v52[2], v52[3], v52[4] = "Computer", "Mobile", "Console", "VR"
            v81.Values = v52
            v81.Default = "Computer"
            v81.Multi = false
            v81.Text = "Spoof Client Input Device"
            v81.Callback = v113
            v50:AddDropdown("DevSpoof", v81)
            v81 = {Text = "Enable Name Spoofer", Default = false}
            v81.Callback = v1:Fa()
            v50:AddToggle("NameSpoofToggle", v81)
            v81 = {Default = "Andy", Numeric = false, Finished = true, Text = "Your Spoofed Identity"}
            v81.Callback = v1:G()
            v50:AddInput("MySpoofName", v81)
            v81 = {Default = "Johnny", Numeric = false, Finished = true, Text = "Enemy Spoofed Identity"}
            v81.Callback = v1:aa()
            v50:AddInput("EnemySpoofName", v81)
            v81 = {Text = "Enable Level Spoofer", Default = false}
            v81.Callback = v1:ra()
            v50:AddToggle("LvlSpoofToggle", v81)
            v81 = {Default = "996", Numeric = true, Finished = true, Text = "Spoofed Level Value"}
            v81.Callback = v1:Jc()
            v50:AddInput("LvlSpoofVal", v81)
            v81 = {Text = "Enable WinStreak Spoofer", Default = false}
            v81.Callback = v1:gd()
            v50:AddToggle("StreakSpoofToggle", v81)
            v81 = {Default = "56", Numeric = true, Finished = true, Text = "Spoofed WinStreak Value"}
            v81.Callback = v1:Bd()
            v50:AddInput("StreakSpoofVal", v81)
            v78 = v82["UI Settings"]:AddLeftGroupbox("Menu", "settings")
            v106 = v82["UI Settings"]:AddRightGroupbox("Config", "save")
            v52 = {Text = "Open Keybind Menu", Default = v10[1].KeybindFrame.Visible}
            v52.Callback = v1:l({v10})
            v78:AddToggle("KeybindMenu", v52)
            v52 = {Text = "Custom Cursor", Default = true}
            v52.Callback = v1:ta({v10})
            v78:AddToggle("CustomCursor", v52)
            v78:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {Default = "RightShift", NoUI = true, Text = "Menu keybind"})
            v80 = v145.MenuKeybind
            v10[1].ToggleKeybind = v80
            v9 = {Text = "Destroy UI"}
            v9.Func = v1:fa({v41, v10, v72, v115, v15, v100, v124, v71, v136, v49, v32, v48, v112, v116})
            v9.DoubleClick = true
            v106:AddButton(v9)
            v65:SetLibrary(v10[1])
            v147:SetLibrary(v10[1])
            v147:IgnoreThemeSettings()
            v147:SetIgnoreIndexes({[1] = "MenuKeybind"})
            v65:SetFolder("DarkRivals")
            v147:SetFolder("DarkRivals/configs")
            v147:BuildConfigSection(v82["UI Settings"])
            v65:ApplyToTab(v82["UI Settings"])
            v10[1].Notify(v10[1], {Title = "Dark Rivals V5", Description = "Loaded | Execution #" .. v19, Time = 5})
        end
    end
end
local function _w331(v1, v2)
    return function(v3)
        local c, u, o
        local v4, v5, v6, v7, v8, container, v9, v10, v11, v12, v13
        if v3 then
            v6 = v3.GetChildren
            v6 = v1.h(v6(v3))
            v8, v6, v7 = ipairs(v1.i(v6))
            v8, v6, v7 = v1.g(v8, v6, v7)
            for _, c in v8, v6, v7 do
                if c:IsA("Frame") then
                    v4 = false
                    container = c:FindFirstChild("Container")
                    if container and container:IsA("Frame") then
                        v9 = container.GetChildren
                        v9 = v1.h(v9(container))
                        v5, v9, v13 = ipairs(v1.i(v9))
                        v5, v9, v13 = v1.g(v5, v9, v13)
                        for _, u in v5, v9, v13 do
                            if u:IsA("Frame") then
                                o = u:FindFirstChild("Title")
                                if o and o:IsA("TextLabel") then
                                    v12 = v2[2][1].Name
                                    o.Text = o.Text == v12 and getgenv().NameSpooferConfig.your_spoofed_name or getgenv().NameSpooferConfig.spoofed_enemy_names
                                    v4 = true
                                end
                            end
                        end
                    end
                    if not v4 then
                        v9, v13, v10 = ipairs(v2[1][1](c))
                        v9, v13, v10 = v1.g(v9, v13, v10)
                        for _, o in v9, v13, v10 do
                            v12 = v2[2][1].Name
                            v11 = o.Text == v12
                            if not v11 then
                                v12 = v2[2][1].DisplayName
                                v11 = o.Text == v12
                            end
                            o.Text = v11 and getgenv().NameSpooferConfig.your_spoofed_name or getgenv().NameSpooferConfig.spoofed_enemy_names
                        end
                    end
                end
            end
            return
        end
    end
end
local function _w332(v1, v2)
    return function(queue)
        v2[1][1].Automation.AutoQueue.Queue = queue
    end
end
local function _w333(v1, v2)
    return function(v3)
        local v4, v5, v6, v7, currentDuelSubject, teamID2, v8, v9
        if v3 == v2[2][1] then
            return false
        else
            currentDuelSubject = v2[1][1].CurrentDuelSubject
            v8 = currentDuelSubject and currentDuelSubject:GetDueler(v2[2][1])
            v7 = v8 and v8:Get("TeamID") or nil
            if v7 and currentDuelSubject and currentDuelSubject.Duelers then
                v4 = currentDuelSubject.Duelers
                v4, teamID2, v5 = v1.g(v4, nil, nil)
                v6, v9 = v4(teamID2, v5)
                v5 = v6
                if v5 ~= nil then
                    while true do
                        if v9.Player ~= v3 then
                            v6, v9 = v4(teamID2, v5)
                            v5 = v6
                            if v5 ~= nil then
                                continue
                            end
                            v4 = v3:GetAttribute("TeamID")
                            teamID2 = v2[2][1]:GetAttribute("TeamID")
                            if v4 and teamID2 then
                                return v4 ~= teamID2
                            else
                                return true
                            end
                        end
                        break
                    end
                    return v9:Get("TeamID") ~= v7
                end
            end
        end
    end
end
local function _w334(v1, v2)
    return function(v3)
        v3 = {[2] = 1, [1] = v3}
        v3[3] = v3
        pcall(v1:Cf({v3, v2[2], v2[1]}))
    end
end
local function _w335(v1, v2)
    return function(v3)
        local humanoidRootPart6, v4, v5, humanoidRootPart7, position6, v6, humanoid3, position7
        if not v3 or v3 == v2[2][1] then
            return false
        else
            humanoid3 = v3.Character:FindFirstChildOfClass("Humanoid")
            if not humanoid3 or humanoid3.Health <= 0 then
                return false
            else
                isTeammate(v3)
                v5 = v2[3][1](v3)
                if not v5 or not v2[1][1](v5) then
                    return false
                else
                    v6 = v2[2][1].Character
                    if not v6 then
                        return false
                    else
                        humanoidRootPart6 = v6:FindFirstChild("HumanoidRootPart")
                        humanoidRootPart7 = v3.Character:FindFirstChild("HumanoidRootPart")
                        if not humanoidRootPart6 or not humanoidRootPart7 then
                            return false
                        else
                            position6 = humanoidRootPart7.Position
                            if (humanoidRootPart6.Position - position6).Magnitude > 35 then
                                return false
                            else
                                position7 = humanoidRootPart7.Position
                                v4 = humanoidRootPart6.Position - position7
                                if v4.Magnitude > 0 then
                                    if humanoidRootPart7.CFrame.LookVector:Dot(v4.Unit) < 0.2 then
                                        return false
                                    end
                                end
                                return true
                            end
                        end
                    end
                end
            end
        end
    end
end
local function _w336(v1, v2)
    return function(thirdpersonEnabled)
        v2[1][1].ThirdpersonEnabled = thirdpersonEnabled
        applyThirdperson()
    end
end
local function _w337(v1, v2)
    return function(fogColorName)
        local v3 = v2[1][1]
        v3.FogColorName = fogColorName
        v3 = v3.FogEnabled
        if v3 then
            applyFog()
        end
    end
end
local function _w338(v1, v2, v3, ...)
    local v4 = {v3}
    for v5 = 1, 1 + select("#", ...) do
        v1[v2 + v5 - 1] = v4[v5]
    end
end
local function _w339(v1, v2)
    return function()
        v2[1][1].ghost:Destroy()
    end
end
local function _w340(v1, v2)
    return function(enabled)
        v2[2][1].enemyWeapons.Enabled = enabled
        local v3, v4
        if enabled then
            getgenv()._Dark_V12_EnemyWeapons.enable()
            v4 = {}
            v3 = v2[1][1]
            v4.Title = "Enemy Weapons"
            v4.Description = "Panel enabled!"
            v4.Time = 3
            v3:Notify(v4)
        else
            getgenv()._Dark_V12_EnemyWeapons.disable()
            v2[1][1]:Notify({Title = "Enemy Weapons", Description = "Panel disabled", Time = 3})
        end
    end
end
local function _w341(v1, v2)
    return function()
        local v3
        if v2[4][1]:WaitForChild("PlayerGui", 30) then
            while true do
                if task.wait(0.5) then
                    v3 = not getgenv().NameSpooferConfig.name_spoof
                    continue
                end
                break
            end
            return
        end
    end
end
local function _w342(v1)
    return function(v2)
        local lower3
        if not v2 then
            return false
        else
            lower3 = string.lower(v2)
            return string.find(lower3, "katana") or string.find(lower3, "sword") or string.find(lower3, "blade") or string.find(lower3, "sabre") or string.find(lower3, "saber")
        end
    end
end
local function _w343(v1, v2)
    return function()
        local v3 = v2[2][1]
        local v4, v5, v6
        v6, v5, v4 = ipairs(v2[1][1])
        v6, v5, v4 = v1.g(v6, v5, v4)
        local v7, v8
        v7, v8 = v6(v5, v4)
        if v7 ~= nil then
            while true do
                if v3 then
                    v3 = v3:FindFirstChild(v8)
                    v7, v8 = v6(v5, v4)
                    v4 = v7
                    if v4 ~= nil then
                        continue
                    end
                    return v3
                end
                break
            end
            return nil
        end
        return v3
    end
end
local function _w344(v1, v2)
    return function()
        v2[2][1]("WeaponInventory")
        task.wait(0.2)
        v2[1][1]()
    end
end
local function _w345(v1, v2)
    return function()
        local v3 = v2[2][1]
        local v4 = v2[1][1]
        v3.Size = v4.Size
        v3.Transparency = v4.Transparency
        v3.CanCollide = v4.CanCollide
    end
end
local function _w346(v1, v2)
    return function(enabled)
        v2[1][1].Automation.AutoQueue.Enabled = enabled
    end
end
local function _w347(v1)
    return function(glowBrightness)
        EspSettings.GlowBrightness = glowBrightness
    end
end
Of({
    "Kc",
    "zd",
    "fd",
    "Pe",
    "k",
    "re",
    "bd",
    "U",
    "Be",
    "Wa",
    "wc",
    "Af",
    "eb",
    "ye",
    "ub",
    "Ia",
    "s",
    "N",
    "fc",
    "S",
    "na",
    "Pb",
    "Fd",
    "Fa",
    "Ee",
    "Ma",
    "Sd",
    "Jb",
    "ad",
    "Hd",
    "Yd",
    "g",
    "pa",
    "C",
    "Jc",
    "id",
    "yd",
    "q",
    "gf",
    "Mc",
    "rf",
    "wd",
    "K",
    "Ba",
    "od",
    "r",
    "y",
    "D",
    "qe",
    "ca",
    "pd",
    "_a",
    "Cd",
    "Ie",
    "m",
    "xc",
    "Y",
    "yf",
    "Le",
    "ee",
    "Ld",
    "Me",
    "Ac",
    "v",
    "ge",
    "Rd",
    "fb",
    "ob",
    "We",
    "Ud",
    "qd",
    "Gd",
    "td",
    "Sc",
    "X",
    "se",
    "ba",
    "lb",
    "xf",
    "ib",
    "Ra",
    "uf",
    "wa",
    "te",
    "Rc",
    "bb",
    "kf",
    "jf",
    "oe",
    "Wb",
    "Ue",
    "Ob",
    "ha",
    "yc",
    "p",
    "qb",
    "ke",
    "Ya",
    "Bc",
    "Ka",
    "pf",
    "fe",
    "Lb",
    "Mf",
    "Ye",
    "Pc",
    "db",
    "B",
    "z",
    "Ge",
    "Fc",
    "Ab",
    "we",
    "Nc",
    "Sb",
    "Gf",
    "sb",
    "Id",
    "R",
    "gc",
    "df",
    "pe",
    "Oc",
    "oc",
    "jc",
    "yb",
    "md",
    "vc",
    "Rb",
    "hf",
    "Oa",
    "vd",
    "Ce",
    "O",
    "G",
    "Yc",
    "Tc",
    "tc",
    "dc",
    "fa",
    "Ca",
    "sd",
    "ef",
    "Xb",
    "Gb",
    "Oe",
    "Ae",
    "M",
    "cc",
    "Qe",
    "Bb",
    "tf",
    "gd",
    "Vc",
    "Td",
    "zc",
    "Da",
    "af",
    "of",
    "Ec",
    "u",
    "Ub",
    "ig",
    "Ua",
    "Ic",
    "Wc",
    "Fb",
    "ud",
    "Eb",
    "sf",
    "Ve",
    "Nb",
    "qc",
    "la",
    "Cc",
    "He",
    "F",
    "tb",
    "Ef",
    "H",
    "V",
    "Kb",
    "Hf",
    "da",
    "ka",
    "nf",
    "Hc",
    "Lf",
    "If",
    "Dc",
    "ce",
    "t",
    "o",
    "qf",
    "Dd",
    "Ad",
    "mb",
    "lf",
    "hc",
    "Md",
    "me",
    "ga",
    "Kd",
    "nc",
    "_b",
    "Cf",
    "Pd",
    "nb",
    "xe",
    "Uc",
    "Sa",
    "qa",
    "ab",
    "Tb",
    "Qc",
    "wf",
    "ed",
    "Bd",
    "ae",
    "dd",
    "sa",
    "I",
    "Df",
    "l",
    "vf",
    "sc",
    "x",
    "L",
    "ua",
    "nd",
    "Nf",
    "jb",
    "Kf",
    "Xc",
    "T",
    "hb",
    "ac",
    "jd",
    "Vd",
    "he",
    "bc",
    "Ed",
    "ea",
    "xd",
    "Od",
    "xb",
    "cf",
    "ze",
    "ia",
    "rc",
    "Qa",
    "Hb",
    "Qb",
    "W",
    "Cb",
    "Jf",
    "uc",
    "Bf",
    "ie",
    "ne",
    "E",
    "lc",
    "wb",
    "Fe",
    "rd",
    "Gc",
    "j",
    "Lc",
    "za",
    "gb",
    "mc",
    "pb",
    "oa",
    "Wd",
    "ld",
    "Aa",
    "Yb",
    "ja",
    "Xe",
    "Ea",
    "ff",
    "_d",
    "Q",
    "Ke",
    "pc",
    "ma",
    "le",
    "vb",
    "Ne",
    "kd",
    "Je",
    "Te",
    "La",
    "va",
    "aa",
    "hd",
    "de",
    "ya",
    "Ja",
    "ec",
    "ue",
    "Xa",
    "J",
    "zf",
    "_e",
    "if_",
    "Ib",
    "ta",
    "cb",
    "Qd",
    "Va",
    "Se",
    "_c",
    "Ta",
    "Jd",
    "w",
    "Xd",
    "bf",
    "Nd",
    "Db",
    "A",
    "xa",
    "mf",
    "cd",
    "Ga",
    "P",
    "Ha",
    "ic",
    "Vb",
    "Re",
    "Ff",
    "be",
    "ra",
    "rb",
    "n",
    "kb",
    "Mb",
    "kc",
    "_f",
    "je",
    "ve",
    "De",
    "Na",
    "zb",
    "Pa",
}, "ig", ...)

