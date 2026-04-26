-- [[ SHADOW ANTI-BAN - ULTRA SMOOTH EDITION ]]
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [1] Bảo vệ Metatable (Phần này nhẹ, giữ nguyên)
local Success, Error = pcall(function()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    local oldIndex = mt.__index
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" or method == "Close" then return nil end
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

    -- [2] REMOTE FILTERING - PHƯƠNG PHÁP QUÉT CHẬM (CHỐNG ĐỨNG UI)
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

    -- Thay vì dùng vòng lặp For quét 1 phát hết luôn, mình dùng task.spawn chia nhỏ ra
    task.spawn(function()
        local allDescendants = game:GetDescendants()
        for i, v in ipairs(allDescendants) do
            ProtectRemote(v)
            -- Cứ quét 100 cái thì nghỉ 1 chút cho UI nó chạy
            if i % 100 == 0 then task.wait() end 
        end
        
        -- Sau khi quét xong thì mới bật theo dõi cái mới
        game.DescendantAdded:Connect(ProtectRemote)
        
        -- Hiện thông báo sau khi đã quét xong an toàn
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🛡️ Shadow Protection",
            Text = "Hệ thống bảo vệ đã kích hoạt mượt mà!",
            Duration = 5
        })
    end)

    -- [3] Vòng lặp Simulation Radius
    task.spawn(function()
        while task.wait(2) do -- Tăng lên 2 giây cho nhẹ máy
            pcall(function()
                sethiddenproperty(LocalPlayer, "SimulationRadius", 65)
            end)
        end
    end)
end)
