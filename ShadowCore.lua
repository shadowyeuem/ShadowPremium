print("ShadowCore is Loading...")

local Framework = require(game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild("CombatFramework"))
local CombatLib = debug.getupvalues(Framework.attack)[1]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = game:GetService("Players").LocalPlayer

_G.ShadowFastAttack = function(target)
    if not target or not _G.FastAttack then return end
    
    pcall(function()
        -- 1. Gửi gói tin sát thương trực tiếp (Bypass Animation)
        ReplicatedStorage.Remotes.Validator:FireServer(math.huge)
        ReplicatedStorage.Remotes.CommF_:InvokeServer("attack", target, 1)
        
        -- 2. Cắt động tác thừa (Premium Logic)
        local AC = Framework.activeController
        if AC and AC.equipped then
            AC.hitboxMagnitude = 60
            AC.attackInterval = 0 
            AC.readyToAttack = true
            
            -- Giả lập click nhẹ để đảm bảo Server nhận dame
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
        end
    end)
end

print("ShadowCore Loaded Successfully!")