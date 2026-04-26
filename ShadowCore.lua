
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")

-- Cổng truyền dữ liệu sát thương
local RegisterAttack = Net:WaitForChild("RE/RegisterAttack")
local RegisterHit = Net:WaitForChild("RE/RegisterHit")

local AttackConfig = {
    Enabled = true,
    Multiplier = 5, -- Dồn sát thương X5
    Distance = 65,
    AutoObservation = true -- Tự bật Ken Haki né đòn khi farm
}

-- Hàm quét mục tiêu (Mobs + Players)
local function GetAttackTargets()
    local t = {}
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return t end
    
    local myPos = char.HumanoidRootPart.Position
    for _, folder in ipairs({workspace.Enemies, workspace.Characters}) do
        for _, v in ipairs(folder:GetChildren()) do
            if v ~= char and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                local root = v:FindFirstChild("HumanoidRootPart")
                if root and (root.Position - myPos).Magnitude <= AttackConfig.Distance then
                    table.insert(t, v)
                end
            end
        end
    end
    return t
end

-- Logic đánh đứng yên (No Animation)
local function SilentAttackLoop()
    if not AttackConfig.Enabled then return end
    
    local char = Player.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    -- Chỉ chạy khi cầm Melee hoặc Sword
    if not tool or (tool.ToolTip ~= "Melee" and tool.ToolTip ~= "Sword") then return end

    local targets = GetAttackTargets()
    if #targets > 0 then
        -- Gửi tín hiệu đánh ngầm (Bypass Cooldown)
        RegisterAttack:FireServer(-math.huge)

        pcall(function()
            local targetPart = targets[1]:FindFirstChild("Head") or targets[1]:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local hitData = {targetPart, {}}
                for i, v in ipairs(targets) do
                    hitData[2][i] = {v, v.HumanoidRootPart}
                end
                
                -- X5 Damage Batching
                for i = 1, AttackConfig.Multiplier do
                    RegisterHit:FireServer(unpack(hitData))
                end
            end
        end)
    end
end

-- Tự động bật Ken Haki (Tích hợp trong file Attack để bảo vệ nhịp đánh)
local function AutoKenSupport()
    if AttackConfig.AutoObservation and Player.Character then
        local hum = Player.Character:FindFirstChild("Humanoid")
        if hum and hum.Health < (hum.MaxHealth * 0.85) then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Kenshoku", true)
            end)
        end
    end
end

-- Vòng lặp siêu tốc
task.spawn(function()
    RunService.Heartbeat:Connect(function()
        SilentAttackLoop()
        AutoKenSupport()
    end)
end)

print("Shadow Core: Silent Attack V2 (Standalone) - Loaded!")
