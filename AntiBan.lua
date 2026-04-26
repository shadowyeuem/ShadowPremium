-- [[ SHADOW ANTI-BAN - FINAL STABLE EDITION ]]
-- Tối ưu hóa cực mạnh cho Mobile, chống đứng UI 100%

if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(5) -- Đợi 5 giây cho game ổn định hoàn toàn rồi mới chạy

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Success, Error = pcall(function()
    -- [1] Hook Metatable (Chỉ Hook khi thực sự cần)
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    local oldIndex = mt.__index
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() and (method == "Kick" or method == "kick" or method == "Close") then 
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

    -- [2] Remote Filtering (Quét lười - Lazy Scan)
    local BadRemotes = {"Report", "Log", "Stats", "Checking", "AdDetector", "Validator", "BugReport", "AdminLog", "Cheat", "Ban"}
    
    local function ProtectRemote(obj)
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            for _, name in pairs(BadRemotes) do
                if obj.Name:lower():find(name:lower()) then
                    local oldFire = obj.FireServer
                    obj.FireServer = newcclosure(function(self, ...) return nil end)
                end
            end
        end
    end

    -- Chia nhỏ quá trình quét để không gây đứng máy
    task.spawn(function()
        local folders = {game:GetService("ReplicatedStorage"), game:GetService("JointsService")}
        for _, folder in pairs(folders) do
            local children = folder:GetDescendants()
            for i, v in ipairs(children) do
                ProtectRemote(v)
                if i % 50 == 0 then task.wait() end -- Cứ 50 món thì nghỉ 1 nhịp
            end
        end
        
        game.DescendantAdded:Connect(ProtectRemote)
        
        -- Thông báo khi mọi thứ đã xong
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "🛡️ Shadow Protection",
                Text = "Hệ thống bảo vệ đã sẵn sàng!",
                Duration = 5
            })
        end)
    end)

    -- [3] Giữ SimulationRadius (Tăng delay cho nhẹ)
    task.spawn(function()
        while task.wait(5) do
            pcall(function()
                sethiddenproperty(LocalPlayer, "SimulationRadius", 65)
            end)
        end
    end)
end)
