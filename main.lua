-- Wellon Hub | Version: Liquid Glass Elite
-- Target: Bizarre Lineage | Author: UnlockCode-01
-- /unlock | S-01 Isolated Env

local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

if CoreGui:FindFirstChild("Wellon_Liquid_Pro") then CoreGui.Wellon_Liquid_Pro:Destroy() end

local Flags = {
    Tab = "Home",
    RaidOpen = false, SkillOpen = false,
    AutoRaid = false, AutoJoin = false, SelectedRaid = "Jotaro",
    AutoQuest = false, AutoPrestige = false, AutoFarm = false, AutoMeditation = false,
    Skills = {R=false, Z=false, X=false, C=false, V=false, E=false}
}

local UI = Instance.new("ScreenGui", CoreGui); UI.Name = "Wellon_Liquid_Pro"

-- [ ISLAND - СКРИН 4 ]
local Island = Instance.new("TextButton", UI)
Island.Size = UDim2.new(0, 120, 0, 28); Island.Position = UDim2.new(0.5, -60, 0, 0)
Island.BackgroundColor3 = Color3.fromRGB(15, 12, 25); Island.Text = "Wellon CLOSE"
Island.TextColor3 = Color3.fromRGB(180, 150, 255); Island.Font = Enum.Font.Code; Island.TextSize = 11
Instance.new("UICorner", Island).CornerRadius = UDim.new(0, 5)
Instance.new("UIStroke", Island).Color = Color3.fromRGB(100, 80, 200)

-- [ MAIN MENU - DZ HUB STYLE ]
local Main = Instance.new("Frame", UI)
Main.Size = UDim2.new(0, 520, 0, 360); Main.Position = UDim2.new(0.5, -260, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(12, 10, 18); Main.BackgroundTransparency = 0.2
Main.Visible = false; Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main)
local MStroke = Instance.new("UIStroke", Main); MStroke.Color = Color3.fromRGB(255,255,255); MStroke.Transparency = 0.9

-- Sidebar
local Side = Instance.new("Frame", Main)
Side.Size = UDim2.new(0, 55, 1, 0); Side.BackgroundColor3 = Color3.fromRGB(8, 6, 12); Side.BackgroundTransparency = 0.3
Instance.new("UICorner", Side)

-- Content
local Content = Instance.new("ScrollingFrame", Main)
Content.Position = UDim2.new(0, 65, 0, 15); Content.Size = UDim2.new(1, -75, 1, -30)
Content.BackgroundTransparency = 1; Content.ScrollBarThickness = 0
local Layout = Instance.new("UIListLayout", Content); Layout.Padding = UDim.new(0, 8)

-- [ ELEMENTS BUILDER ]
local function CreateToggle(name, parent, flag, isSkill)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 34); btn.BackgroundColor3 = Color3.fromRGB(255,255,255); btn.BackgroundTransparency = 0.97
    btn.Text = "  " .. name .. " [OFF]"; btn.TextColor3 = Color3.new(0.7, 0.7, 0.7); btn.Font = Enum.Font.Code; btn.TextXAlignment = "Left"
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        if isSkill then Flags.Skills[flag] = not Flags.Skills[flag] else Flags[flag] = not Flags[flag] end
        local active = isSkill and Flags.Skills[flag] or Flags[flag]
        btn.Text = "  " .. name .. (active and " [ON]" or " [OFF]")
        btn.TextColor3 = active and Color3.fromRGB(160, 120, 255) or Color3.new(0.7, 0.7, 0.7)
    end)
end

local function CreateAccordion(name, parent, flag)
    local h = Instance.new("TextButton", parent)
    h.Size = UDim2.new(1, 0, 0, 38); h.BackgroundColor3 = Color3.fromRGB(25, 20, 40); h.Text = "  [+] " .. name
    h.TextColor3 = Color3.new(1,1,1); h.Font = Enum.Font.Code; h.TextXAlignment = "Left"
    Instance.new("UICorner", h)
    
    local b = Instance.new("Frame", parent)
    b.Size = UDim2.new(1, 0, 0, 0); b.ClipsDescendants = true; b.BackgroundTransparency = 1
    Instance.new("UIListLayout", b).Padding = UDim.new(0, 5)
    
    h.MouseButton1Click:Connect(function()
        Flags[flag] = not Flags[flag]
        TS:Create(b, TweenInfo.new(0.3), {Size = Flags[flag] and UDim2.new(1, 0, 0, 240) or UDim2.new(1, 0, 0, 0)}):Play()
        h.Text = Flags[flag] and "  [-] " .. name or "  [+] " .. name
    end)
    return b
end

-- [ TABS SETUP ]
local function ClearContent() for _, v in pairs(Content:GetChildren()) do if v:IsA("Frame") or v:IsA("TextButton") then v.Visible = false end end end

local HomeBtn = Instance.new("TextButton", Side); HomeBtn.Size = UDim2.new(0, 35, 0, 35); HomeBtn.Position = UDim2.new(0, 10, 0, 20); HomeBtn.Text = "H"; HomeBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 80)
local EyeBtn = Instance.new("TextButton", Side); EyeBtn.Size = UDim2.new(0, 35, 0, 35); EyeBtn.Position = UDim2.new(0, 10, 0, 65); EyeBtn.Text = "E"; EyeBtn.BackgroundTransparency = 0.8

-- [ HOME CONTENT ]
local HomeGroup = Instance.new("Frame", Content); HomeGroup.Size = UDim2.new(1, 0, 1, 0); HomeGroup.BackgroundTransparency = 1
Instance.new("UIListLayout", HomeGroup).Padding = UDim.new(0, 8)

CreateToggle("Auto Quest", HomeGroup, "AutoQuest")
CreateToggle("Auto Prestige", HomeGroup, "AutoPrestige")
CreateToggle("Auto Meditation", HomeGroup, "AutoMeditation")

local RaidAcc = CreateAccordion("Raid Automation", HomeGroup, "RaidOpen")
CreateToggle("Auto Raid", RaidAcc, "AutoRaid")
local raids = {"Muhammad Avidol", "Person", "Death 13", "Jotaro", "Dio", "Dio Tvoh"}
for _, r in pairs(raids) do
    local rb = Instance.new("TextButton", RaidAcc)
    rb.Size = UDim2.new(1, 0, 0, 28); rb.Text = "  > " .. r; rb.BackgroundTransparency = 1
    rb.TextColor3 = Color3.new(0.6, 0.6, 0.6); rb.TextXAlignment = "Left"
    rb.MouseButton1Click:Connect(function() Flags.SelectedRaid = r; print("Wellon: "..r.." Selected") end)
end

-- [ EYE CONTENT ]
local EyeGroup = Instance.new("Frame", Content); EyeGroup.Size = UDim2.new(1, 0, 1, 0); EyeGroup.BackgroundTransparency = 1; EyeGroup.Visible = false
Instance.new("UIListLayout", EyeGroup).Padding = UDim.new(0, 8)

CreateToggle("Auto Farm (Mobs)", EyeGroup, "AutoFarm")
local SkillAcc = CreateAccordion("Auto Skills", EyeGroup, "SkillOpen")
for _, k in pairs({"R", "Z", "X", "C", "V", "E"}) do CreateToggle("Skill ["..k.."]", SkillAcc, k, true) end

-- [ NAVIGATION ]
HomeBtn.MouseButton1Click:Connect(function() HomeGroup.Visible = true; EyeGroup.Visible = false end)
EyeBtn.MouseButton1Click:Connect(function() HomeGroup.Visible = false; EyeGroup.Visible = true end)

Island.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    Island.Text = Main.Visible and "Wellon OPEN" or "Wellon CLOSE"
end)

-- [ WORKER ]
RS.Stepped:Connect(function()
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    local HRP = Player.Character.HumanoidRootPart

    if Flags.AutoRaid then
        local target = workspace.Entities:FindFirstChildWhichIsA("Model") or workspace.Entities:FindFirstChild(Flags.SelectedRaid)
        if target and target:FindFirstChild("HumanoidRootPart") then
            HRP.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, -14, 0)
        else
            -- Поиск NPC рейда (имена по классике Bizarre Lineage)
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name:find("Raid") and v:FindFirstChild("HumanoidRootPart") then
                    HRP.CFrame = v.HumanoidRootPart.CFrame
                    break
                end
            end
        end
    end
    
    if Flags.AutoFarm then
        for _, m in pairs(workspace.Mobs:GetChildren()) do
            if m:FindFirstChild("Humanoid") and m.Humanoid.Health > 0 then
                HRP.CFrame = m.HumanoidRootPart.CFrame * CFrame.new(0, -13, 0); break
            end
        end
    end

    for k, v in pairs(Flags.Skills) do if v then VIM:SendKeyEvent(true, Enum.KeyCode[k], false, game) end end
end)
