-- UnlockCode-01 | /unlock | S-01
-- Full Bizarre Lineage Script: Raids (Boss + NPC), Auto Farm, Island UI

local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")
local VirtualInput = game:GetService("VirtualInputManager")

-- Cleanup
if CoreGui:FindFirstChild("BizarreLineage_Unlock_S01") then
    CoreGui:FindFirstChild("BizarreLineage_Unlock_S01"):Destroy()
end

local Flags = {
    AutoRaid = false,
    AutoFarm = false,
    SelectedRaid = "Death 13",
    UOffset = Vector3.new(0, -14, 0),
    Keys = {R = false, Z = false, X = false, C = false, V = false, E = false}
}

-- [ UI BUILDER ]
local MainUI = Instance.new("ScreenGui", CoreGui)
MainUI.Name = "BizarreLineage_Unlock_S01"

-- Island (Top)
local Island = Instance.new("TextButton", MainUI)
Island.Size = UDim2.new(0, 140, 0, 35)
Island.Position = UDim2.new(0.5, -70, 0, 10)
Island.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
Island.Text = "UnlockCode-01"
Island.TextColor3 = Color3.fromRGB(180, 100, 255)
Instance.new("UICorner", Island)

-- Main Frame
local MainFrame = Instance.new("Frame", MainUI)
MainFrame.Size = UDim2.new(0, 550, 0, 380)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 0, 45)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

-- Close Trigger (Top of Menu)
local CloseBar = Instance.new("TextButton", MainFrame)
CloseBar.Size = UDim2.new(1, 0, 0, 30)
CloseBar.BackgroundColor3 = Color3.fromRGB(35, 0, 65)
CloseBar.Text = "▲ CLICK TO HIDE ▲"
CloseBar.TextColor3 = Color3.new(0.8, 0.8, 0.8)

-- Tabs
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 140, 1, -30)
Sidebar.Position = UDim2.new(0, 0, 0, 30)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 0, 30)

local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -140, 1, -30)
Content.Position = UDim2.new(0, 140, 0, 30)
Content.BackgroundTransparency = 1

local function CreateList(parent)
    local sc = Instance.new("ScrollingFrame", parent)
    sc.Size = UDim2.new(1, -10, 1, -10)
    sc.Position = UDim2.new(0, 5, 0, 5)
    sc.BackgroundTransparency = 1
    sc.ScrollBarThickness = 2
    local l = Instance.new("UIListLayout", sc)
    l.Padding = UDim.new(0, 5)
    return sc
end

local HomeList = CreateList(Content)
local FarmList = CreateList(Content)
FarmList.Visible = false

-- UI Logic
Island.MouseButton1Click:Connect(function() MainFrame.Visible = true Island.Visible = false end)
CloseBar.MouseButton1Click:Connect(function() MainFrame.Visible = false Island.Visible = true end)

-- [ FUNCTIONS ]
local function Toggle(txt, parent, cb)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(45, 0, 85)
    b.Text = txt .. ": OFF"
    b.TextColor3 = Color3.new(1, 1, 1)
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = txt .. (state and ": ON" or ": OFF")
        b.BackgroundColor3 = state and Color3.fromRGB(100, 0, 200) or Color3.fromRGB(45, 0, 85)
        cb(state)
    end)
end

-- Home Content
Toggle("Auto Raid (Boss + Mobs)", HomeList, function(v) Flags.AutoRaid = v end)
for _, r in pairs({"Death 13", "Dio", "TWOH", "Kira", "Jotaro"}) do
    local b = Instance.new("TextButton", HomeList)
    b.Size = UDim2.new(1, 0, 0, 30)
    b.Text = "Target: " .. r
    b.MouseButton1Click:Connect(function() Flags.SelectedRaid = r end)
end

-- Farm Content
Toggle("Auto Farm (TP NPC/Mobs)", FarmList, function(v) Flags.AutoFarm = v end)
for k, _ in pairs(Flags.Keys) do
    Toggle("Auto Skill ["..k.."]", FarmList, function(v) Flags.Keys[k] = v end)
end

-- Sidebar Nav
local b1 = Instance.new("TextButton", Sidebar)
b1.Size = UDim2.new(1, 0, 0, 40)
b1.Text = "HOME (RAIDS)"
b1.MouseButton1Click:Connect(function() HomeList.Visible = true FarmList.Visible = false end)

local b2 = Instance.new("TextButton", Sidebar)
b2.Size = UDim2.new(1, 0, 0, 40)
b2.Position = UDim2.new(0, 0, 0, 45)
b2.Text = "FARM (EYE)"
b2.MouseButton1Click:Connect(function() HomeList.Visible = false FarmList.Visible = true end)

-- [ MASTER LOOP ]
task.spawn(function()
    while task.wait() do
        local char = Player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if hrp then
            -- Универсальный Raid Killer (убивает всё, что движется в рейде)
            if Flags.AutoRaid then
                for _, ent in pairs(workspace.Entities:GetChildren()) do
                    if ent:FindFirstChild("Humanoid") and ent.Humanoid.Health > 0 then
                        -- Приоритет боссу, но бьет всех NPC рядом
                        hrp.CFrame = ent.HumanoidRootPart.CFrame * CFrame.new(Flags.UOffset)
                        -- Trigger Attack (Remote)
                    end
                end
            end
            
            -- Auto Farm NPC/Mobs
            if Flags.AutoFarm then
                for _, mob in pairs(workspace.Mobs:GetChildren()) do
                    if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        hrp.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(Flags.UOffset)
                        break
                    end
                end
            end

            -- Skills
            for k, active in pairs(Flags.Keys) do
                if active then
                    VirtualInput:SendKeyEvent(true, Enum.KeyCode[k], false, game)
                    task.wait(0.05)
                end
            end
        end
    end
end)
