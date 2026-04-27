-- [[ SHADOW-PREMIUM: INDEPENDENT ANTI-BAN MODULE ]]
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local replicated = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

-- [1] TỐI ƯU METATABLE
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
local oldIndex = mt.__index
setreadonly(mt, false)

-- Chặn các lệnh Kick/Close
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
       if method == "Kick" or method == "kick" or method == "Close" then
        -- 1. Ghi log Console cho mình xem
        warn("🛡️ [SHADOW-SHIELD]: KICK BLOCKED!")

        -- [ GIAI ĐOẠN 1: HIỆN LÝ DO BAN/KICK TRƯỚC ]
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "🚫 BẠN VỪA BỊ BAN/KICK?",
                Text = "📍 Lý do: " .. tostring(args[1] or "Nghi vấn Cheat") .. "\n🔥 KHÔNG BAN/KICK ĐƯỢC ĐÂU!",
                Icon = "rbxassetid://10734951185",
                Duration = 5
            })
        end)

        -- [ GIAI ĐOẠN 2: HIỆN CẢNH BÁO BẢO MỆT SAU 5 GIÂY ]
        task.spawn(function()
            task.wait(5.5) -- Đợi bảng lý do biến mất
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "⚠️ CẢNH BÁO BẢO MẬT 🚫",
                    Text = "🛡️ Sao mà ban/kick được!\n✨ Anti-ban vừa kích hoạt\n🔥 Trạng thái: Đang bảo vệ",
                    Icon = "rbxassetid://10734951185",
                    Duration = 7
                })
            end)
        end)
        
        return nil -- Quan trọng nhất: Chặn đứng lệnh Kick
    end

        
-- Fake thông số WalkSpeed/JumpPower (Chống Auto-Detection)
mt.__index = newcclosure(function(t, k)
    if not checkcaller() then 
        if k == "WalkSpeed" and t:IsA("Humanoid") then return 16 end
        if k == "JumpPower" and t:IsA("Humanoid") then return 50 end
    end
    return oldIndex(t, k)
end)

setreadonly(mt, true)

-- [2] REMOTE HOOKING (CHỈ KIỂM TRA KHI GỬI TIN - SIÊU NHẸ)
local BadRemotes = {"Report", "Log", "Stats", "Checking", "AdDetector", "AdminLog", "Cheat", "Ban"}

local oldFireServer
oldFireServer = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
    local name = tostring(self.Name):lower()
    for _, bad in pairs(BadRemotes) do
        if name:find(bad:lower()) then
            return nil 
        end
    end
    return oldFireServer(self, ...)
end))

-- [3] CÀI ĐẶT SIMULATION RADIUS (CHỈ SET 1 LẦN)
pcall(function()
    sethiddenproperty(plr, "SimulationRadius", 65)
    sethiddenproperty(plr, "MaxSimulationRadius", 65)
end)

-- Thông báo khi nạp thành công
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "🛡️ Shadow Protection",
        Text = "The anti-ban system has been activated!",
        Duration = 3
    })
end)

print("Shield Active! Shadow-Premium Protection Loaded.")
