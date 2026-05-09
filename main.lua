-- UnlockCode-01 | /unlock | S-01 Isolated Env
-- Target: Bizarre Lineage (Vellure Style UI)

local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

-- Чистка
if CoreGui:FindFirstChild("Vellure_Unlock") then CoreGui.Vellure_Unlock:Destroy() end

local Flags = {
    AutoRaid = false, AutoFarm = false, SelectedRaid = "Death 13",
    Skills = {R=false, Z=false, X=false, C=false, V=false, E=false},
    Offset = Vector3.new(0, -13, 0)
}

-- UI
local UI = Instance.new("ScreenGui", CoreGui)
UI.Name = "Vellure_Unlock"

-- [ ISLAND - СКРИН 4 ]
local Island = Instance.new("TextButton", UI)
Island.Size = UDim2.new(0, 100, 0, 25)
Island.Position = UDim2.new(0.5, -50, 0, 0) -- Самый верх экрана
Island.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
Island.Text = "Vellure CLOSE"
Island.TextColor3 = Color3.new(1,1,1)
Island.Font = Enum.Font.GothamBold
Island.TextSize = 10
Instance.new("UICorner", Island).CornerRadius = UDim.new(0, 4)

-- [ MAIN MENU - СКРИН 3 STYLE ]
local Main = Instance.new("Frame", UI)
Main.Size = UDim2.new(0, 500, 0, 320)
Main.Position = UDim2.new(0.5, -250, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(18, 15, 25)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

-- Sidebar
local Side = Instance.new("Frame", Main)
Side.Size = UDim2.new(0, 50, 1, 0)
Side.BackgroundColor3 = Color3.fromRGB(14, 12, 20)

-- Content Area
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -60, 1, -20)
Container.Position = UDim2.new(0, 60, 0, 10)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
local Layout = Instance.new("UIListLayout", Container); Layout.Padding = UDim.new(0, 8)

-- [ FUNCTIONS ]
local function AddToggle(name, flag)
    local f = Instance.new("Frame", Container)
    f.Size = UDim2.new(1, 0, 0, 30); f.BackgroundTransparency = 1
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(0.7, 0, 1, 0); t.Text = name; t.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    t.BackgroundTransparency = 1; t.TextXAlignment = "Left"
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0, 40, 0, 20); b.Position = UDim2.new(0.8, 0, 0.2, 0)
    b.BackgroundColor3 = Color3.fromRGB(45, 40, 60); b.Text = ""
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        Flags[flag] = not Flags[flag]
        b.BackgroundColor3 = Flags[flag] and Color3.fromRGB(140, 100, 255) or Color3.fromRGB(45, 40, 60)
    end)
end

-- Наполнение (Automation / Skills)
AddToggle("Auto Raid (Underground)", "AutoRaid")
AddToggle("Auto Farm Mobs", "AutoFarm")
for _, k in pairs({"R","Z","X","C","V","E"}) do
    AddToggle("Auto Skill ["..k.."]", "Skill"..k)
end

-- Logic Opening
Island.MouseButton1Click:Connect(function() Main.Visible = true Island.Visible = false end)
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 60, 0, 20); Close.Position = UDim2.new(0.44, 0, 0, -25)
Close.Text = "CLOSE"; Close.MouseButton1Click:Connect(function() Main.Visible = false Island.Visible = true end)

-- [ WORKER LOOP ]
RunService.Stepped:Connect(function()
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    local HRP = Player.Character.HumanoidRootPart

    if Flags.AutoRaid then
        for _, e in pairs(workspace:GetDescendants()) do
            if e:IsA("Model") and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 and e ~= Player.Character then
                HRP.CFrame = e.HumanoidRootPart.CFrame * CFrame.new(Flags.Offset)
                break
            end
        end
    end

    -- Skill Spam
    for k, _ in pairs(Flags.Skills) do
        if Flags["Skill"..k] then VIM:SendKeyEvent(true, Enum.KeyCode[k], false, game) end
    end
end)
