-- [[ SHADOW-PREMIUM: CLEAN ANTI-BAN ]]
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "Kick" or method == "kick" or method == "Close" then
        -- Giai đoạn 1: Hiện lý do
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "🚫 BẠN VỪA BỊ BAN/KICK?",
                Text = "📍 Lý do: " .. tostring(args[1] or "Nghi vấn") .. "\n🔥 KHÔNG BAN/KICK ĐƯỢC ĐÂU!",
                Duration = 5
            })
        end)
        
        -- Giai đoạn 2: Sau 5s gáy (Chạy ngầm để không treo Metatable)
        task.delay(5.5, function()
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "⚠️ CẢNH BÁO BẢO MẬT 🚫",
                    Text = "🛡️ Sao mà kick được anh!\n✨ Anti-ban: Active\n🔥 Trạng thái: Bảo vệ",
                    Duration = 5
                })
            end)
        end)
        
        return nil 
    end
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)
print("Anti-Ban Clean Loaded!")
