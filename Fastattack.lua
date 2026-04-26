--[[
    Blox Fruits Fast Attack Script - Optimized Edition
    Dựa trên cấu trúc của FastMax.lua
]]

local FastAttack = {}
local MT = getrawmetatable(game)
local OldNamecall = MT.__namecall
setreadonly(MT, false)

-- Cấu hình thông số (Tùy chỉnh để tránh bị kick/reset)
local AttackConfig = {
    Cooldown = 0.05, -- Giảm xuống 0.01 nếu muốn cực nhanh (Dễ văng)
    Distance = 60,   -- Khoảng cách tấn công hiệu quả
    FastMode = true
}

-- Tối ưu hóa hàm gửi tín hiệu tấn công
local function GetAttackSignal()
    for _, v in pairs(getgc(true)) do
        if type(v) == "table" and v.Attack ~= nil then
            return v
        end
    end
end

local AttackModule = GetAttackSignal()

-- Script Đánh Nhanh
task.spawn(function()
    while task.wait(AttackConfig.Cooldown) do
        pcall(function()
            if AttackConfig.FastMode then
                local Character = game.Players.LocalPlayer.Character
                local Tool = Character:FindFirstChildOfClass("Tool")
                
                if Tool and Tool:FindFirstChild("Click") then
                    -- Gửi tín hiệu trực tiếp thông qua Module
                    if AttackModule then
                        AttackModule.Attack()
                    end
                    
                    -- Kết hợp với giả lập click để tăng tốc độ phản hồi
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end
        end)
    end
end)

-- Chống lag và ổn định Frame hình
game:GetService("RunService").Stepped:Connect(function()
    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
end)

print("Fast Attack đã được kích hoạt!")
