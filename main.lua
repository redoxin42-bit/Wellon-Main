-- Wellon Premier | DZ-Vellure Hybrid
-- /unlock | Isolated Environment S-01

local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

if CoreGui:FindFirstChild("Wellon_Final") then CoreGui.Wellon_Final:Destroy() end

local Flags = {
    CurrentTab = "Home",
    AutoRaid = false, AutoRetry = false, AutoJoin = false, SelectedRaid = "Jotaro",
    AutoQuest = false, AutoPrestige = false, AutoFarm = false,
    Skills = {R=false, Z=false, X=false, C=false, V=false, E=false},
    RaidOpen = false, SkillOpen = false
}

local UI = Instance.new("ScreenGui", CoreGui); UI.Name = "Wellon_Final"

-- [ ISLAND - TOP ]
local Island = Instance.new("TextButton", UI)
Island.Size = UDim2.new(0, 130, 0, 30); Island.Position = UDim2.new(0.5, -65, 0, 5)
Island.BackgroundColor3 = Color3.fromRGB(25, 22, 35); Island.Text = "Wellon OPEN"
Island.TextColor3 = Color3.new(1,1,1); Island.Font = Enum.Font.GothamBold
Instance.new("UICorner", Island)

-- [ MAIN MENU ]
local Main = Instance.new("Frame", UI)
Main.Size = UDim2.new(0, 600, 0, 420); Main.Position = UDim2.new(0.5, -300, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 13, 22); Main.Visible = false
Main.Active = true; Main.Draggable = true -- Двигается!
Instance.new("UICorner", Main)

-- Sidebar
local Side = Instance.new("Frame", Main)
Side.Size = UDim2.new(0, 60, 1, 0); Side.BackgroundColor3 = Color3.fromRGB(10, 8, 15)
Instance.new("UICorner", Side)

-- Content
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Position = UDim2.new(0, 70, 0, 15); Scroll.Size = UDim2.new(1, -85, 1, -30)
Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 0
local Layout = Instance.new("UIListLayout", Scroll); Layout.Padding = UDim.new(0, 10)

-- [ UI BUILDERS ]
local function NewToggle(name, parent, flag, sub)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 35); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.6, 0, 1, 0); l.Text = name; l.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    l.BackgroundTransparency = 1; l.TextXAlignment = "Left"; l.Font = Enum.Font.Gotham
    
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0, 40, 0, 20); b.Position = UDim2.new(0.85, 0, 0.2, 0)
    b.BackgroundColor3 = Color3.fromRGB(40, 35, 50); b.Text = ""
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    
    b.MouseButton1Click:Connect(function()
        if sub then Flags.Skills[flag] = not Flags.Skills[flag]
        else Flags[flag] = not Flags[flag] end
        local active = sub and Flags.Skills[flag] or Flags[flag]
        b.BackgroundColor3 = active and Color3.fromRGB(140, 100, 255) or Color3.fromRGB(40, 35, 50)
    end)
end

-- [ HOME TAB CONTENT ]
local HomeGroup = Instance.new("Frame", Scroll)
HomeGroup.Size = UDim2.new(1, 0, 0, 500); HomeGroup.BackgroundTransparency = 1
local HLayout = Instance.new("UIListLayout", HomeGroup); HLayout.Padding = UDim.new(0, 8)

NewToggle("Auto Quest", HomeGroup, "AutoQuest")
NewToggle("Auto Prestige", HomeGroup, "AutoPrestige")

-- Raid Accordion
local RaidHeader = Instance.new("TextButton", HomeGroup)
RaidHeader.Size = UDim2.new(1, 0, 0, 40); RaidHeader.Text = "  ▼ Raid Automation"; RaidHeader.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
RaidHeader.TextColor3 = Color3.new(1,1,1); RaidHeader.TextXAlignment = "Left"
Instance.new("UICorner", RaidHeader)

local RaidBody = Instance.new("Frame", HomeGroup)
RaidBody.Size = UDim2.new(1, 0, 0, 0); RaidBody.ClipsDescendants = true; RaidBody.BackgroundTransparency = 1
local RLayout = Instance.new("UIListLayout", RaidBody); RLayout.Padding = UDim.new(0, 5)

NewToggle("Auto Raid (Underground)", RaidBody, "AutoRaid")
NewToggle("Auto Retry Raid", RaidBody, "AutoRetry")

for _, r in pairs({"Jotaro", "Dio", "Death 13", "Avidol", "Dio TWOH"}) do
    local rb = Instance.new("TextButton", RaidBody)
    rb.Size = UDim2.new(1, 0, 0, 30); rb.Text = "  - Select: " .. r .. " Raid"
    rb.BackgroundTransparency = 1; rb.TextColor3 = Color3.new(0.6, 0.6, 0.6); rb.TextXAlignment = "Left"
    rb.MouseButton1Click:Connect(function() Flags.SelectedRaid = r end)
end

RaidHeader.MouseButton1Click:Connect(function()
    Flags.RaidOpen = not Flags.RaidOpen
    TS:Create(RaidBody, TweenInfo.new(0.3), {Size = Flags.RaidOpen and UDim2.new(1, 0, 0, 250) or UDim2.new(1, 0, 0, 0)}):Play()
end)

-- [ EYE TAB CONTENT ]
local EyeGroup = Instance.new("Frame", Scroll)
EyeGroup.Size = UDim2.new(1, 0, 0, 500); EyeGroup.BackgroundTransparency = 1; EyeGroup.Visible = false
local ELayout = Instance.new("UIListLayout", EyeGroup); ELayout.Padding = UDim.new(0, 8)

NewToggle("Auto Farm Mobs", EyeGroup, "AutoFarm")

-- Skills Accordion
local SkillHeader = Instance.new("TextButton", EyeGroup)
SkillHeader.Size = UDim2.new(1, 0, 0, 40); SkillHeader.Text = "  ▼ Auto Skills"; SkillHeader.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
SkillHeader.TextColor3 = Color3.new(1,1,1); SkillHeader.TextXAlignment = "Left"
Instance.new("UICorner", SkillHeader)

local SkillBody = Instance.new("Frame", EyeGroup)
SkillBody.Size = UDim2.new(1, 0, 0, 0); SkillBody.ClipsDescendants = true; SkillBody.BackgroundTransparency = 1
Instance.new("UIListLayout", SkillBody).Padding = UDim.new(0, 5)

for _, k in pairs({"R","Z","X","C","V","E"}) do NewToggle("Use Skill ["..k.."]", SkillBody, k, true) end

SkillHeader.MouseButton1Click:Connect(function()
    Flags.SkillOpen = not Flags.SkillOpen
    TS:Create(SkillBody, TweenInfo.new(0.3), {Size = Flags.SkillOpen and UDim2.new(1, 0, 0, 250) or UDim2.new(1, 0, 0, 0)}):Play()
end)

-- [ LOGIC: ISLAND & TABS ]
Island.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    Island.Text = Main.Visible and "Wellon CLOSE" or "Wellon OPEN"
end)

-- [ CORE LOOP ]
RS.Stepped:Connect(function()
    if Flags.AutoRaid and Player.Character:FindFirstChild("HumanoidRootPart") then
        local Target = workspace.Entities:FindFirstChildWhichIsA("Model")
        if Target then Player.Character.HumanoidRootPart.CFrame = Target.HumanoidRootPart.CFrame * CFrame.new(0, -14, 0) end
    end
    for k, v in pairs(Flags.Skills) do
        if v then VIM:SendKeyEvent(true, Enum.KeyCode[k], false, game) end
    end
end)
