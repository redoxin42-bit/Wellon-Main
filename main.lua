-- Wellon UnlockCode-01 | /unlock | S-01
-- Style: Liquid Glass v2.1 (Bizarre Lineage)
-- Авторская сборка (Handcrafted Logic)

local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

-- Удаление старых сессий
if CoreGui:FindFirstChild("Wellon_Liquid") then CoreGui.Wellon_Liquid:Destroy() end

local Flags = {
    AutoRaid = false, AutoAgain = false, AutoJoin = false,
    SelectedRaid = "Death 13 Raid",
    RaidOpen = false, SkillsOpen = false,
    Skills = {R=false, Z=false, X=false, C=false, V=false, E=false}
}

-- [ ГЕНЕРАЦИЯ ИНТЕРФЕЙСА ]
local UI = Instance.new("ScreenGui", CoreGui)
UI.Name = "Wellon_Liquid"

-- Island (Switcher)
local Island = Instance.new("TextButton", UI)
Island.Name = "WellonTrigger"
Island.Size = UDim2.new(0, 140, 0, 32)
Island.Position = UDim2.new(0.5, -70, 0, 8)
Island.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Island.BackgroundTransparency = 0.4
Island.Text = "Wellon Close"
Island.TextColor3 = Color3.fromRGB(200, 180, 255)
Island.Font = Enum.Font.Code
Island.TextSize = 13
local ICorn = Instance.new("UICorner", Island); ICorn.CornerRadius = UDim.new(0, 8)
local IStroke = Instance.new("UIStroke", Island); IStroke.Color = Color3.fromRGB(100, 80, 200); IStroke.Transparency = 0.5

-- Main Glass Frame
local Main = Instance.new("Frame", UI)
Main.Name = "Main"
Main.Size = UDim2.new(0, 580, 0, 420)
Main.Position = UDim2.new(0.5, -290, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BackgroundTransparency = 0.25 -- Liquid Glass Effect
Main.Visible = false
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MStroke = Instance.new("UIStroke", Main); MStroke.Color = Color3.fromRGB(255, 255, 255); MStroke.Transparency = 0.85

-- Контейнер с прокруткой
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -20)
Scroll.Position = UDim2.new(0, 10, 0, 10)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
Scroll.ScrollBarThickness = 2
local Layout = Instance.new("UIListLayout", Scroll); Layout.Padding = UDim.new(0, 12)

-- [ КОМПОНЕНТЫ: СТИЛЬ КОДЕРА ]
local function NewSection(name, flagKey)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.95
    btn.Text = "  [+] " .. name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextXAlignment = "Left"
    btn.Font = Enum.Font.Code
    Instance.new("UICorner", btn)
    
    local panel = Instance.new("Frame", Scroll)
    panel.Size = UDim2.new(1, 0, 0, 0)
    panel.ClipsDescendants = true
    panel.BackgroundTransparency = 1
    local pLayout = Instance.new("UIListLayout", panel); pLayout.Padding = UDim.new(0, 5)
    
    btn.MouseButton1Click:Connect(function()
        Flags[flagKey] = not Flags[flagKey]
        local targetSize = Flags[flagKey] and UDim2.new(1, 0, 0, 280) or UDim2.new(1, 0, 0, 0)
        if flagKey == "RaidOpen" then targetSize = Flags[flagKey] and UDim2.new(1, 0, 0, 320) or UDim2.new(1, 0, 0, 0) end
        TweenService:Create(panel, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = targetSize}):Play()
        btn.Text = Flags[flagKey] and "  [-] " .. name or "  [+] " .. name
    end)
    return panel
end

local function CreateToggle(name, parent, cb)
    local t = Instance.new("TextButton", parent)
    t.Size = UDim2.new(1, -10, 0, 35)
    t.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    t.BackgroundTransparency = 0.98
    t.Text = "  " .. name .. " : OFF"
    t.TextColor3 = Color3.fromRGB(180, 180, 180)
    t.TextXAlignment = "Left"
    t.Font = Enum.Font.Code
    Instance.new("UICorner", t)
    
    local active = false
    t.MouseButton1Click:Connect(function()
        active = not active
        t.Text = "  " .. name .. (active and " : ON" or " : OFF")
        t.TextColor3 = active and Color3.fromRGB(150, 100, 255) or Color3.fromRGB(180, 180, 180)
        cb(active)
    end)
end

-- [ РАЗДЕЛ РЕЙДОВ ]
local RaidPanel = NewSection("RAID AUTOMATION", "RaidOpen")
CreateToggle("Auto Raid", RaidPanel, function(v) Flags.AutoRaid = v end)
CreateToggle("Auto Again", RaidPanel, function(v) Flags.AutoAgain = v end)
CreateToggle("Auto Join", RaidPanel, function(v) Flags.AutoJoin = v end)

local Raids = {"Muhammad Avidol Raid", "Person Raid", "Death 13 Raid", "Jotaro Raid", "Dio raid", "Dio Tvoh Raid"}
for _, rName in pairs(Raids) do
    local rb = Instance.new("TextButton", RaidPanel)
    rb.Size = UDim2.new(1, -20, 0, 30)
    rb.BackgroundTransparency = 1
    rb.Text = "  > Select: " .. rName
    rb.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    rb.Font = Enum.Font.Code
    rb.TextXAlignment = "Left"
    rb.MouseButton1Click:Connect(function()
        Flags.SelectedRaid = rName
        print("Target set to: "..rName)
    end)
end

-- [ РАЗДЕЛ SKILLS ]
local SkillPanel = NewSection("AUTO SKILLS", "SkillsOpen")
for _, k in pairs({"R","Z","X","C","V","E"}) do
    CreateToggle("Use Skill ["..k.."]", SkillPanel, function(v) Flags.Skills[k] = v end)
end

-- [ ЛОГИКА ОСТРОВА ]
Island.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    Island.Text = Main.Visible and "Wellon Open" or "Wellon Close"
end)

-- [ ИСПОЛНИТЕЛЬНЫЙ ЯДРО ]
RunService.Stepped:Connect(function()
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    local HRP = Player.Character.HumanoidRootPart

    if Flags.AutoRaid then
        -- Проверка: Мы в лобби или на рейде?
        local Boss = workspace.Entities:FindFirstChild(Flags.SelectedRaid) or workspace.Entities:FindFirstChildWhichIsA("Model")
        
        if Boss then
            -- МЫ НА РЕЙДЕ: Уходим под карту
            HRP.CFrame = Boss.HumanoidRootPart.CFrame * CFrame.new(0, -14, 0)
        else
            -- МЫ В ЛОББИ: ТП к NPC рейда
            local NPC = workspace.NPCs:FindFirstChild("Raid Master") -- Название NPC уточнить
            if NPC then HRP.CFrame = NPC.HumanoidRootPart.CFrame end
        end
    end

    for k, v in pairs(Flags.Skills) do
        if v then VIM:SendKeyEvent(true, Enum.KeyCode[k], false, game) end
    end
end)
