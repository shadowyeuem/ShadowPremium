Repeat task.wait() until game:IsLoaded()
local TablePlace = {7449423635,2753915549,4442272183}

-- Thong bao khi vua chay script
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "Shadow Premium Hub", 
	Text = "Đang khởi tạo hệ thống...", 
	Icon = "rbxassetid://138810852860318", 
	Duration = 15
})

if table.find(TablePlace,game.PlaceId) or true then -- Em de true de luon chay Loader
    shared.LoaderTitle = "Shadow Premium Hub"; -- Ten hien thi chinh
    shared.LoaderKeyFrames = {
        [1] = {1, 35},
        [2] = {2, 70},
        [3] = {3, 100}
    };

    local v2 = {
        LoaderData = {
            Name = shared.LoaderTitle,
            Colors = {
                Main = Color3.fromRGB(0, 0, 0),
                Topic = Color3.fromRGB(200, 200, 200),
                Title = Color3.fromRGB(255, 255, 255),
                LoaderBackground = Color3.fromRGB(40, 40, 40),
                LoaderSplash = Color3.fromRGB(255, 105, 180) -- Em doi thanh thanh load mau HONG cho hop voi UI cua anh
            }
        },
        Keyframes = shared.LoaderKeyFrames
    };

    local v3 = {[1] = "Checking Data...", [2] = "Loading UI...", [3] = "Success!"};

    function TweenObject(v178, v179, v180)
        game.TweenService:Create(v178, TweenInfo.new(v179, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), v180):Play();
    end

    function CreateObject(v181, v182)
        local v183 = Instance.new(v181);
        for v416, v417 in pairs(v182) do
            if (v416 ~= "Parent") then v183[v416] = v417 else v183.Parent = v417 end
        end
        return v183;
    end

    local function v4(v186, v187)
        local v188 = Instance.new("UICorner");
        v188.CornerRadius = UDim.new(0, v186);
        v188.Parent = v187;
    end

    local v5 = CreateObject("ScreenGui", {Name = "Core", Parent = game.CoreGui});
    local v6 = CreateObject("Frame", {
        Name = "Main",
        Parent = v5,
        BackgroundColor3 = v2.LoaderData.Colors.Main,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 0, 0, 0)
    });
    v4(12, v6);

    local v7 = CreateObject("ImageLabel", {
        Name = "UserImage",
        Parent = v6,
        BackgroundTransparency = 1,
        Image = "rbxassetid://100472177647993",
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(0, 50, 0, 50)
    });
    v4(25, v7);

    local v8 = CreateObject("TextLabel", {
        Name = "UserName",
        Parent = v6,
        BackgroundTransparency = 1,
        Text = "Owner: Mai Tuấn Anh", -- Doi ten chu so huu o day
        Position = UDim2.new(0, 75, 0, 10),
        Size = UDim2.new(0, 200, 0, 50),
        Font = Enum.Font.GothamBold,
        TextColor3 = v2.LoaderData.Colors.Title,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    });

    local v9 = CreateObject("TextLabel", {
        Name = "Top",
        TextTransparency = 1,
        Parent = v6,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 30, 0, 70),
        Size = UDim2.new(0, 301, 0, 20),
        Font = Enum.Font.Gotham,
        Text = "System Loading",
        TextColor3 = v2.LoaderData.Colors.Topic,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    });

    local v10 = CreateObject("TextLabel", {
        Name = "Title",
        Parent = v6,
        TextTransparency = 1,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 30, 0, 85),
        Size = UDim2.new(0, 301, 0, 46),
        Font = Enum.Font.Gotham,
        RichText = true,
        Text = "<b>" .. v2.LoaderData.Name .. "</b>",
        TextColor3 = v2.LoaderData.Colors.Title,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    });

    local v11 = CreateObject("Frame", {
        Name = "BG",
        Parent = v6,
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = v2.LoaderData.Colors.LoaderBackground,
        Position = UDim2.new(0.5, 0, 0, 75),
        Size = UDim2.new(0.85, 0, 0, 10) -- Lam thanh load thanh manh hon cho dep
    });
    v4(8, v11);

    local v12 = CreateObject("Frame", {
        Name = "Progress",
        Parent = v11,
        BackgroundColor3 = v2.LoaderData.Colors.LoaderSplash,
        Size = UDim2.new(0, 0, 1, 0)
    });
    v4(8, v12);

    TweenObject(v6, 0.5, {Size = UDim2.new(0, 346, 0, 140)});
    wait(0.5);
    TweenObject(v9, 0.5, {TextTransparency = 0});
    TweenObject(v10, 0.5, {TextTransparency = 0});

    for i, v in pairs(v2.Keyframes) do
        wait(v[1]);
        TweenObject(v12, 0.5, {Size = UDim2.new(v[2] / 100, 0, 1, 0)});
    end

    wait(0.5);
    v5:Destroy();
end

-- Chay script chinh cua anh o duoi nay
loadstring(game:HttpGet("https://raw.githubusercontent.com/hdanhhub/hdanhhub/refs/heads/main/Fix-Lag.lua.txt"))()