-- [[ SHADOW ANTI-BAN & BYPASS SYSTEM - PERFECT EDITION ]]
-- File này lưu trên GitHub, không cần task.spawn bao ngoài vì đã có Loader xử lý

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

-- [2] Thực thi các lớp bảo vệ ngay lập tức
local Success, Error = pcall(function()
    -- Cấu trúc Metatable (Giữ nguyên phần __namecall và __index của anh)
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    local oldIndex = mt.__index
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" or method == "Close" then
            ShadowNotify("Đã chặn một nỗ lực Kick!")
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

    -- Phần Remote Filtering (Giữ nguyên)
    -- ... [Code lọc Remote của anh] ...

    -- [3] Chỉ dùng task.spawn cho vòng lặp (Loop) cần chạy ngầm liên tục
    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                sethiddenproperty(LocalPlayer, "SimulationRadius", 65)
            end)
        end
    end)

    ShadowNotify("Hệ thống bảo vệ 100% đã sẵn sàng!")
end)

if not Success then
    warn("❌ [Shadow Anti-Ban Error]: " .. tostring(Error))
end
