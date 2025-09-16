--// PlaceId Check
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer

if game.PlaceId ~= 10449761463 then
    LocalPlayer:Kick("This script only works in The Strongest Battlegrounds.")
    return
end

--// Loading Tip (fade in/out)
local ScreenGuiTips = Instance.new("ScreenGui", game.CoreGui)
ScreenGuiTips.Name = "TipsUI"

local TipLabel = Instance.new("TextLabel", ScreenGuiTips)
TipLabel.AnchorPoint = Vector2.new(0.5,0.5)
TipLabel.Position = UDim2.new(0.5, 0, 0.25, 0) -- agak atas tengah
TipLabel.Size = UDim2.new(0,600,0,50)
TipLabel.BackgroundTransparency = 1
TipLabel.TextColor3 = Color3.new(1,1,1)
TipLabel.Font = Enum.Font.SourceSansBold
TipLabel.TextSize = 24
TipLabel.Text = "Tip: Reset your character after executing to avoid M1 bug!"
TipLabel.TextStrokeTransparency = 0.3
TipLabel.TextTransparency = 1

-- Label credit
local CreditLabel = TipLabel:Clone()
CreditLabel.Parent = ScreenGuiTips
CreditLabel.Position = UDim2.new(0.5, 0, 0.30, 0) -- agak bawah tip
CreditLabel.TextSize = 20
CreditLabel.Text = 'Made By Vinzee | "ZeSpreeze"'
CreditLabel.TextTransparency = 1

-- fade in
TweenService:Create(TipLabel, TweenInfo.new(1), {TextTransparency = 0}):Play()
TweenService:Create(CreditLabel, TweenInfo.new(1), {TextTransparency = 0}):Play()
task.wait(5)
-- fade out
TweenService:Create(TipLabel, TweenInfo.new(1), {TextTransparency = 1}):Play()
TweenService:Create(CreditLabel, TweenInfo.new(1), {TextTransparency = 1}):Play()
Debris:AddItem(ScreenGuiTips, 6)

--// Simple Anti-Freeze + Speed Hack GUI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer

-- Vars
local AntiFreeze = false
local SpeedHack = false
local speed = 150

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "MiniToolsUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 180, 0, 90)
Frame.Position = UDim2.new(0.7, 0, 0.7, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Active = true
Frame.Draggable = true

local UIList = Instance.new("UIListLayout", Frame)
UIList.FillDirection = Enum.FillDirection.Vertical
UIList.Padding = UDim.new(0,5)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.VerticalAlignment = Enum.VerticalAlignment.Center

-- Buttons
local AntiFreezeBtn = Instance.new("TextButton", Frame)
AntiFreezeBtn.Size = UDim2.new(0.9,0,0,35)
AntiFreezeBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
AntiFreezeBtn.TextColor3 = Color3.new(1,1,1)
AntiFreezeBtn.Font = Enum.Font.SourceSansBold
AntiFreezeBtn.TextSize = 16
AntiFreezeBtn.Text = "Anti Freeze: OFF"

local SpeedBtn = Instance.new("TextButton", Frame)
SpeedBtn.Size = UDim2.new(0.9,0,0,35)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(0,0,200)
SpeedBtn.TextColor3 = Color3.new(1,1,1)
SpeedBtn.Font = Enum.Font.SourceSansBold
SpeedBtn.TextSize = 16
SpeedBtn.Text = "Speed Hack: OFF"

-- Toggle AntiFreeze
AntiFreezeBtn.MouseButton1Click:Connect(function()
    AntiFreeze = not AntiFreeze
    if AntiFreeze then
        AntiFreezeBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
        AntiFreezeBtn.Text = "Anti Freeze: ON"
    else
        AntiFreezeBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
        AntiFreezeBtn.Text = "Anti Freeze: OFF"
    end
end)

-- Toggle Speed Hack
SpeedBtn.MouseButton1Click:Connect(function()
    SpeedHack = not SpeedHack
    if SpeedHack then
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(0,200,200)
        SpeedBtn.Text = "Speed Hack: ON"
    else
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(0,0,200)
        SpeedBtn.Text = "Speed Hack: OFF"
    end
end)

-- Clean Freeze/Slow
local function CleanLiveFolder()
    local liveFolder = workspace:FindFirstChild("Live")
    if liveFolder then
        for _, obj in ipairs(liveFolder:GetDescendants()) do
            local n = string.lower(obj.Name)
            if n:find("freeze") or n:find("slowed") then
                obj:Destroy()
            end
        end
    end
end

-- Anti-Freeze Loop
RunService.Stepped:Connect(function()
    if not AntiFreeze then return end
    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if hum then
        hum.PlatformStand = false
        hum.Sit = false
        if hum.WalkSpeed < 14 then hum.WalkSpeed = 16 end
        if hum.JumpPower < 40 then hum.JumpPower = 50 end
    end

    if hrp then
        hrp.Anchored = false
        if hrp.Velocity.Magnitude < 1 then
            hrp.Velocity = hrp.CFrame.LookVector * 6
        end
    end

    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BodyPosition") then
            obj:Destroy()
        elseif obj:IsA("BodyVelocity") then
            if obj.Velocity.Magnitude < 1 then
                obj:Destroy()
            end
        elseif obj:IsA("VectorForce") or obj:IsA("AlignPosition") then
            local force = Vector3.new(0,0,0)
            pcall(function() force = obj.MaxForce end)
            if force.Magnitude > 10000 then
                obj:Destroy()
            end
        end
    end

    CleanLiveFolder()
end)

-- Speed Hack Loop
RunService.Heartbeat:Connect(function()
    if not SpeedHack then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = speed
    end
end)
