--[[
  Nama Script : ALZHUB Anti Protect
  Pembuat     : @anakscrpt_
  Game        : Steal an Egg
  Fitur       : Anti Trap, Anti Hit, Anti Monster
  Key         : KEYLESS
--]]

repeat wait() until game:IsLoaded()
local plr = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local ws = game:GetService("Workspace")

-- ==========================================
-- STATE
-- ==========================================
local antiTrap = false
local antiHit = false
local antiMonster = false
local loop1, loop2, loop3 = nil, nil, nil

-- ==========================================
-- GUI
-- ==========================================
local gui = Instance.new("ScreenGui")
gui.Name = "ALZHUB_AntiProtect"
gui.Parent = plr:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local function makeDrag(frame)
    local drag, dragIn, start, startPos = false, nil, nil, nil
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; start = i.Position; startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            dragIn = i
        end
    end)
    uis.InputChanged:Connect(function(i)
        if i == dragIn and drag then
            local d = i.Position - start
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    uis.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
end

-- Logo (pojok kanan bawah)
local logo = Instance.new("TextButton")
logo.Size = UDim2.new(0, 55, 0, 55)
logo.Position = UDim2.new(0.9, 0, 0.8, 0)
logo.BackgroundColor3 = Color3.fromRGB(25, 12, 10)
logo.Text = "ALZ"
logo.TextColor3 = Color3.fromRGB(255, 130, 40)
logo.Font = Enum.Font.GothamBold
logo.TextSize = 16
logo.BorderSizePixel = 0
logo.Parent = gui
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 10)
local ls = Instance.new("UIStroke", logo)
ls.Color = Color3.fromRGB(255, 100, 0)
ls.Thickness = 1.5
makeDrag(logo)

-- Main Frame (KECIL)
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 240, 0, 150)
main.Position = UDim2.new(0.65, 0, 0.6, 0)
main.BackgroundColor3 = Color3.fromRGB(25, 12, 10)
main.BorderSizePixel = 0
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local ms = Instance.new("UIStroke", main)
ms.Color = Color3.fromRGB(255, 100, 0)
ms.Thickness = 1.5

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -35, 0, 22)
title.Position = UDim2.new(0, 8, 0, 4)
title.BackgroundTransparency = 1
title.Text = "ALZHUB | @anakscrpt_"
title.TextColor3 = Color3.fromRGB(255, 130, 40)
title.Font = Enum.Font.GothamBold
title.TextSize = 11
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 22, 0, 22)
close.Position = UDim2.new(1, -26, 0, 4)
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.TextSize = 11
close.BorderSizePixel = 0
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
close.MouseButton1Click:Connect(function() main.Visible = false end)

local trapBtn = Instance.new("TextButton", main)
trapBtn.Size = UDim2.new(0, 224, 0, 32)
trapBtn.Position = UDim2.new(0, 8, 0, 32)
trapBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
trapBtn.Text = "ANTI TRAP: OFF"
trapBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
trapBtn.Font = Enum.Font.GothamBold
trapBtn.TextSize = 11
trapBtn.BorderSizePixel = 0
Instance.new("UICorner", trapBtn).CornerRadius = UDim.new(0, 6)

local hitBtn = Instance.new("TextButton", main)
hitBtn.Size = UDim2.new(0, 224, 0, 32)
hitBtn.Position = UDim2.new(0, 8, 0, 70)
hitBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
hitBtn.Text = "ANTI HIT: OFF"
hitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hitBtn.Font = Enum.Font.GothamBold
hitBtn.TextSize = 11
hitBtn.BorderSizePixel = 0
Instance.new("UICorner", hitBtn).CornerRadius = UDim.new(0, 6)

local monsterBtn = Instance.new("TextButton", main)
monsterBtn.Size = UDim2.new(0, 224, 0, 32)
monsterBtn.Position = UDim2.new(0, 8, 0, 108)
monsterBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
monsterBtn.Text = "ANTI MONSTER: OFF"
monsterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
monsterBtn.Font = Enum.Font.GothamBold
monsterBtn.TextSize = 11
monsterBtn.BorderSizePixel = 0
Instance.new("UICorner", monsterBtn).CornerRadius = UDim.new(0, 6)

-- ==========================================
-- ANTI TRAP (NOCLIP + LEPAS TRAP)
-- ==========================================
local function startAntiTrap()
    if loop1 then loop1:Disconnect() end
    loop1 = rs.Heartbeat:Connect(function()
        if not antiTrap then return end
        local char = plr.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        if hum.PlatformStand or hum.WalkSpeed == 0 then
            hum.PlatformStand = false
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end)
end

-- ==========================================
-- ANTI HIT (ANTI RAGDOLL)
-- ==========================================
local function startAntiHit()
    if loop2 then loop2:Disconnect() end
    loop2 = rs.Heartbeat:Connect(function()
        if not antiHit then return end
        local char = plr.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
        if hum.PlatformStand then
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
        for _, track in pairs(hum:GetPlayingAnimationTracks()) do
            local aname = track.Animation.Name:lower()
            if aname:find("ragdoll") or aname:find("fall") or aname:find("hit") 
            or aname:find("stun") or aname:find("knock") then
                track:Stop()
            end
        end
        if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
    end)
end

-- ==========================================
-- ANTI MONSTER (MATIIN AI)
-- ==========================================
local function startAntiMonster()
    if loop3 then loop3:Disconnect() end
    loop3 = rs.Heartbeat:Connect(function()
        if not antiMonster then return end
        local char = plr.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for _, obj in pairs(ws:GetChildren()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= char then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local mhrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                if hum and mhrp then
                    local dist = (mhrp.Position - hrp.Position).Magnitude
                    if dist < 100 then
                        pcall(function()
                            hum.WalkSpeed = 0
                            hum.JumpPower = 0
                            hum:ChangeState(Enum.HumanoidStateType.Physics)
                        end)
                    end
                end
            end
        end
    end)
end

-- ==========================================
-- EVENT
-- ==========================================
trapBtn.MouseButton1Click:Connect(function()
    antiTrap = not antiTrap
    if antiTrap then
        trapBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        trapBtn.Text = "ANTI TRAP: ON"
        startAntiTrap()
    else
        trapBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        trapBtn.Text = "ANTI TRAP: OFF"
        if loop1 then loop1:Disconnect() loop1 = nil end
    end
end)

hitBtn.MouseButton1Click:Connect(function()
    antiHit = not antiHit
    if antiHit then
        hitBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        hitBtn.Text = "ANTI HIT: ON"
        startAntiHit()
    else
        hitBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        hitBtn.Text = "ANTI HIT: OFF"
        if loop2 then loop2:Disconnect() loop2 = nil end
    end
end)

monsterBtn.MouseButton1Click:Connect(function()
    antiMonster = not antiMonster
    if antiMonster then
        monsterBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        monsterBtn.Text = "ANTI MONSTER: ON"
        startAntiMonster()
    else
        monsterBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        monsterBtn.Text = "ANTI MONSTER: OFF"
        if loop3 then loop3:Disconnect() loop3 = nil end
    end
end)

logo.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

makeDrag(main)

plr.CharacterAdded:Connect(function()
    wait(0.5)
    if antiTrap then startAntiTrap() end
    if antiHit then startAntiHit() end
    if antiMonster then startAntiMonster() end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ALZHUB Anti Protect | @anakscrpt_",
    Text = "✅ Script loaded! Klik logo ALZ",
    Duration = 3
})