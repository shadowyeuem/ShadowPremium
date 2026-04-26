-- [[ SHADOW ANTI-BAN & BYPASS SYSTEM - PERFECT EDITION ]]
-- File này lưu trên GitHub, đã tối ưu chống Crash cho máy yếu

-- Chờ game load hoàn toàn để tránh xung đột dữ liệu lúc loading screen
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- [1] Hàm thông báo
local function ShadowNotify(text)
    pcall(function()
         StarterGui:SetCore("SendNotification", {
            Title = "🛡️ Shadow Protection",
            Text = text,
            Duration = 5
        })
    end)
end

-- [2] Thực thi các lớp bảo vệ
local Success, Error = pcall(function()
    -- Cấu trúc Metatable
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    local oldIndex = mt.__index
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" or method == "Close" then
            ShadowNotify("Đã chặn một nỗ lực Kick/Ban!")
            return nil
        end
        return oldNamecall(self, ...)
    end)

    mt.__index = newcclosure(function(t, k)
        if not checkcaller() and t == LocalPlayer.Character and t:FindFirstChild("Humanoid") then
            if k == "WalkSpeed" then return 16 end
            if k == "JumpPower" then return 50 end
        end
        return oldIndex(t, k)
    end)
    setreadonly(mt, true)

    -- [3] REMOTE FILTERING (Tối ưu chống Crash)
    local BadRemotes = {"Report", "Log", "Stats", "Checking", "AdDetector", "Validator", "BugReport", "AdminLog", "Cheat", "Ban"}
    
    local function ProtectRemote(obj)
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            for _, name in pairs(BadRemotes) do
                if obj.Name:lower():find(name:lower()) then
                    local oldFire = obj.FireServer
                    obj.FireServer = newcclosure(function(self, ...)
                        return nil 
                    end)
                end
            end
        end
    end

    -- CHỈ QUÉT CÁC KHU VỰC TRỌNG YẾU (Giúp không bị đứng game/crash)
    local ProtectedPaths = {
        game:GetService("ReplicatedStorage"),
        game:GetService("JointsService"),
        game:GetService("HttpService") -- Thêm cái này cho chắc
    }

    for _, path in pairs(ProtectedPaths) do
        for _, v in pairs(path:GetDescendants()) do
            ProtectRemote(v)
        end
    end
    
    -- Lắng nghe các Remote mới được sinh ra sau khi game đã load
    game.DescendantAdded:Connect(ProtectRemote)

    -- [4] Vòng lặp bảo vệ tầm đánh
    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                sethiddenproperty(LocalPlayer, "SimulationRadius", 65)
                sethiddenproperty(LocalPlayer, "MaxSimulationRadius", 65)
            end)
        end
    end)

    ShadowNotify("Hệ thống bảo vệ 100% đã sẵn sàng!")
end)

if not Success then
    warn("❌ [Shadow Anti-Ban Error]: " .. tostring(Error))
end
