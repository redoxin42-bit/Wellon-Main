-- UnlockCode-01 | /unlock | S-01 Isolated Environment
-- Target: Bizarre Lineage | Full Script

local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Очистка старых сессий
if CoreGui:FindFirstChild("BizarreLineage_Unlock_S01") then
    CoreGui:FindFirstChild("BizarreLineage_Unlock_S01"):Destroy()
end

-- Переменные состояний
local Flags = {
    AutoRaid = false,
    AutoFarm = false,
    AutoSkills = false,
    AutoQuest = false,
    ActiveSkills = {},
    SelectedRaid = "Death 13",
    UOffset = Vector3.new(0, -14, 0) -- Смещение под карту
}

-- [ GUI INITIALIZATION ]
local MainUI = Instance.new("ScreenGui")
MainUI.Name = "BizarreLineage_Unlock_S01"
MainUI.Parent = CoreGui

-- [ ISLAND TRIGGER ]
local Island = Instance.new("TextButton")
Island.Name = "Island"
Island.Size = UDim2.new(0, 150, 0, 35)
Island.Position = UDim2.new(0.5, -75, 0, 15)
Island.BackgroundColor3 = Color3.fromRGB(15, 0, 30)
Island.Text = "UnlockCode-01 ~"
Island.TextColor3 = Color3.fromRGB(180, 100, 255)
Island.Font = Enum.Font.GothamBold
Island.TextSize = 14
Island.Parent = MainUI
Instance.new("UICorner", Island).CornerRadius = UDim.new(0, 10)

-- [ MAIN FRAME ]
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 35)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = MainUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

-- Close Button (Top Header)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(1, 0, 0, 30)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 0, 55)
CloseBtn.Text = "▲ CLICK TO HIDE MENU ▲"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.Parent = MainFrame

-- Sidebar & Pages
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -30)
Sidebar.Position = UDim2.new(0, 0, 0, 30)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
Sidebar.Parent = MainFrame

local PageCont = Instance.new("Frame")
PageCont.Size = UDim2.new(1, -160, 1, -30)
PageCont.Position = UDim2.new(0, 160, 0, 30)
PageCont.BackgroundTransparency = 1
PageCont.Parent = MainFrame

local function NewPage()
    local f = Instance.new("ScrollingFrame")
    f.Size = UDim2.new(1, -20, 1, -20)
    f.Position = UDim2.new(0, 10, 0, 10)
    f.BackgroundTransparency = 1
    f.ScrollBarThickness = 0
    f.Visible = false
    f.Parent = PageCont
    local list = Instance.new("UIListLayout", f)
    list.Padding = UDim.new(0, 8)
    return f
end

local Home = NewPage() Home.Visible = true
local Farm = NewPage()

-- [ HELPERS ]
local function CreateButton(text, parent, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(40, 0, 75)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Gotham
    b.Parent = parent
    b.MouseButton1Click:Connect(callback)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
end

local function CreateToggle(text, parent, flagKey)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    b.Text = text .. ": OFF"
    b.Parent = parent
    b.MouseButton1Click:Connect(function()
        Flags[flagKey] = not Flags[flagKey]
        b.Text = text .. (Flags[flagKey] and ": ON" or ": OFF")
        b.BackgroundColor3 = Flags[flagKey] and Color3.fromRGB(80, 0, 150) or Color3.fromRGB(50, 50, 50)
    end)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
end

-- [ CONTENT: HOME ]
CreateToggle("Auto Raid", Home, "AutoRaid")
CreateToggle("Auto Join Raid", Home, "AutoJoin")

local RaidList = {"Death 13", "Dio", "TVOH", "Kira Yoshikage", "Jotaro"}
for _, r in pairs(RaidList) do
    CreateButton("Select: " .. r, Home, function() 
        Flags.SelectedRaid = r
        print("S-01: Target set to " .. r)
    end)
end

-- [ CONTENT: FARM ]
CreateToggle("Auto Farm Mobs", Farm, "AutoFarm")
CreateToggle("Auto Quest NPC", Farm, "AutoQuest")
CreateButton("Prestige Check", Farm, function() print("Checking Prestige Requirements...") end)

local Keys = {"R", "Z", "X", "C", "V", "E"}
for _, k in pairs(Keys) do
    CreateToggle("Auto Skill ["..k.."]", Farm, k)
end

-- [ NAVIGATION ]
CreateButton("HOME (Raids)", Sidebar, function() Home.Visible = true Farm.Visible = false end)
CreateButton("FARM (Skills)", Sidebar, function() Home.Visible = false Farm.Visible = true end)

-- [ LOGIC: TELEPORT & COMBAT ]
Island.MouseButton1Click:Connect(function() MainFrame.Visible = true Island.Visible = false end)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false Island.Visible = true end)

task.spawn(function()
    while task.wait() do
        local char = Player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if hrp then
            -- Logic for AutoRaid (Underground)
            if Flags.AutoRaid then
                for _, ent in pairs(workspace.Entities:GetChildren()) do
                    if ent:FindFirstChild("Humanoid") and ent.Humanoid.Health > 0 and ent.Name:find(Flags.SelectedRaid) then
                        hrp.CFrame = ent.HumanoidRootPart.CFrame * CFrame.new(Flags.UOffset)
                        -- Trigger Attack Remote (Example)
                        -- game:GetService("ReplicatedStorage").Remotes.Punch:FireServer()
                    end
                end
            end
            
            -- Logic for AutoFarm (NPC TP)
            if Flags.AutoFarm then
                -- Поиск ближайшего моба и ТП под него
                for _, mob in pairs(workspace.Mobs:GetChildren()) do
                    if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        hrp.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(Flags.UOffset)
                        break
                    end
                end
            end
            
            -- Auto Skills
            for _, k in pairs(Keys) do
                if Flags[k] then
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode[k], false, game)
                    task.wait(0.1)
                end
            end
        end
    end
end)
