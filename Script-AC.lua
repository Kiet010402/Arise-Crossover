-- Orion UI Version - Tối ưu hóa hiệu suất
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local enemiesFolder = workspace:WaitForChild("__Main"):WaitForChild("__Enemies"):WaitForChild("Client")
local remote = ReplicatedStorage:WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent")

local teleportEnabled = false
local damageEnabled = false
local killedNPCs = {}
local dungeonkill = {}
local selectedMobName = ""
local movementMethod = "Tween" -- Phương thức di chuyển mặc định
local farmingStyle = "Default" -- Phong cách farm mặc định

-- Hệ thống lưu trữ
local ConfigSystem = {}
ConfigSystem.FileName = "AriseOrionConfig_" .. player.Name .. ".json"
ConfigSystem.DefaultConfig = {
    SelectedMobName = "",
    SelectedWorld = "SoloWorld",
    FarmSelectedMob = false,
    AutoFarmNearestNPCs = false,
    MainAutoDestroy = false,
    MainAutoArise = false,
    FarmingMethod = "Tween",
    DamageMobs = false
}
ConfigSystem.CurrentConfig = {}

-- Hàm để lưu cấu hình
ConfigSystem.SaveConfig = function()
    local success, err = pcall(function()
        writefile(ConfigSystem.FileName, game:GetService("HttpService"):JSONEncode(ConfigSystem.CurrentConfig))
    end)
    if success then
        print("Đã lưu cấu hình thành công!")
    else
        warn("Lưu cấu hình thất bại:", err)
    end
end

-- Hàm để tải cấu hình
ConfigSystem.LoadConfig = function()
    local success, content = pcall(function()
        if isfile(ConfigSystem.FileName) then
            return readfile(ConfigSystem.FileName)
        end
        return nil
    end)
    
    if success and content then
        local data = game:GetService("HttpService"):JSONDecode(content)
        ConfigSystem.CurrentConfig = data
        return true
    else
        ConfigSystem.CurrentConfig = table.clone(ConfigSystem.DefaultConfig)
        ConfigSystem.SaveConfig()
        return false
    end
end

-- Tải cấu hình khi khởi động
ConfigSystem.LoadConfig()

-- Tạo mapping giữa các map và danh sách mob tương ứng
local mobsByWorld = {
    ["SoloWorld"] = {"Soondoo", "Gonshee", "Daek", "Longin", "Anders", "Largalgan"},
    ["NarutoWorld"] = {"Snake Man", "Blossom", "Black Crow"},
    ["OPWorld"] = {"Shark Man", "Eminel", "Light Admiral"},
    ["BleachWorld"] = {"Luryu", "Fyakuya", "Genji"},
    ["BCWorld"] = {"Sortudo", "Michille", "Wind"},
    ["ChainsawWorld"] = {"Heaven", "Zere", "Ika"},
    ["JojoWorld"] = {"Diablo", "Gosuke", "Golyne"}
}

local selectedWorld = ConfigSystem.CurrentConfig.SelectedWorld or "SoloWorld"

-- Tự động phát hiện HumanoidRootPart mới khi người chơi hồi sinh
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    hrp = newCharacter:WaitForChild("HumanoidRootPart")
end)

-- Utility Functions
local function anticheat()
    local player = game.Players.LocalPlayer
    if player and player.Character then
        local characterScripts = player.Character:FindFirstChild("CharacterScripts")
        
        if characterScripts then
            local flyingFixer = characterScripts:FindFirstChild("FlyingFixer")
            if flyingFixer then
                flyingFixer:Destroy()
            end

            local characterUpdater = characterScripts:FindFirstChild("CharacterUpdater")
            if characterUpdater then
                characterUpdater:Destroy()
            end
        end
    end
end

local function isEnemyDead(enemy)
    local healthBar = enemy:FindFirstChild("HealthBar")
    if healthBar and healthBar:FindFirstChild("Main") and healthBar.Main:FindFirstChild("Bar") then
        local amount = healthBar.Main.Bar:FindFirstChild("Amount")
        if amount and amount:IsA("TextLabel") and amount.ContentText == "0 HP" then
            return true
        end
    end
    return false
end

local function getNearestSelectedEnemy()
    local nearestEnemy = nil
    local shortestDistance = math.huge
    local playerPosition = hrp.Position

    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
            local healthBar = enemy:FindFirstChild("HealthBar")
            if healthBar and healthBar:FindFirstChild("Main") and healthBar.Main:FindFirstChild("Title") then
                local title = healthBar.Main.Title
                if title and title:IsA("TextLabel") and title.ContentText == selectedMobName and not killedNPCs[enemy.Name] then
                    local enemyPosition = enemy.HumanoidRootPart.Position
                    local distance = (playerPosition - enemyPosition).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        nearestEnemy = enemy
                    end
                end
            end
        end
    end
    return nearestEnemy
end

local function getAnyEnemy()
    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") and not dungeonkill[enemy.Name] then
            return enemy
        end
    end
    return nil
end

local function fireShowPetsRemote()
    local args = {
        [1] = {
            [1] = {
                ["Event"] = "ShowPets"
            },
            [2] = "\t"
        }
    }
    remote:FireServer(unpack(args))
end

local function getNearestEnemy()
    local nearestEnemy, shortestDistance = nil, math.huge
    local playerPosition = hrp.Position

    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") and not killedNPCs[enemy.Name] then
            local distance = (playerPosition - enemy:GetPivot().Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestEnemy = enemy
            end
        end
    end
    return nearestEnemy
end

local function moveToTarget(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    local enemyHrp = target.HumanoidRootPart

    if movementMethod == "Teleport" then
        hrp.CFrame = enemyHrp.CFrame * CFrame.new(0, 0, 6)
    elseif movementMethod == "Tween" then
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = enemyHrp.CFrame * CFrame.new(0, 0, 6)})
        tween:Play()
    elseif movementMethod == "Walk" then
        hrp.Parent:MoveTo(enemyHrp.Position)
    end
end

-- Farming Functions
local function teleportAndTrackDeath()
    while teleportEnabled do
        local target = getNearestEnemy()
        if target and target.Parent then
            anticheat()
            moveToTarget(target)
            task.wait(0.5)
            fireShowPetsRemote()
            remote:FireServer({
                {
                    ["PetPos"] = {},
                    ["AttackType"] = "All",
                    ["Event"] = "Attack",
                    ["Enemy"] = target.Name
                },
                "\7"
            })

            while teleportEnabled and target.Parent and not isEnemyDead(target) do
                task.wait(0.1)
            end

            killedNPCs[target.Name] = true
        end
        task.wait(0.2)
    end
end

local function teleportDungeon()
    while teleportEnabled do
        local target = getAnyEnemy()

        if target and target.Parent then
            anticheat()
            moveToTarget(target)
            task.wait(0.50)
            fireShowPetsRemote()
            remote:FireServer({
                {
                    ["PetPos"] = {},
                    ["AttackType"] = "All",
                    ["Event"] = "Attack",
                    ["Enemy"] = target.Name
                },
                "\7"
            })

            repeat task.wait() until not target.Parent or isEnemyDead(target)

            dungeonkill[target.Name] = true
        end
        task.wait()
    end
end

local function teleportToSelectedEnemy()
    while teleportEnabled do
        local target = getNearestSelectedEnemy()
        if target and target.Parent then
            anticheat()
            moveToTarget(target)
            task.wait(0.5)
            fireShowPetsRemote()

            remote:FireServer({
                {
                    ["PetPos"] = {},
                    ["AttackType"] = "All",
                    ["Event"] = "Attack",
                    ["Enemy"] = target.Name
                },
                "\7"
            })

            while teleportEnabled and target.Parent and not isEnemyDead(target) do
                task.wait(0.1)
            end

            killedNPCs[target.Name] = true
        end
        task.wait(0.20)
    end
end

local function attackEnemy()
    while damageEnabled do
        local targetEnemy = getNearestEnemy()
        if targetEnemy then
            local args = {
                [1] = {
                    [1] = {
                        ["Event"] = "PunchAttack",
                        ["Enemy"] = targetEnemy.Name
                    },
                    [2] = "\4"
                }
            }
            remote:FireServer(unpack(args))
        end
        task.wait(1)
    end
end

-- Teleport Functions
local function SetSpawnAndReset(spawnName)
    local args = {
        [1] = {
            [1] = {
                ["Event"] = "ChangeSpawn",
                ["Spawn"] = spawnName
            },
            [2] = "\n"
        }
    }

    local remote = game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent")
    remote:FireServer(unpack(args))

    task.wait(0.5)

    local player = game.Players.LocalPlayer
    if player.Character and player.Character.Parent then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end
end

-- Auto Destroy/Arise Functions
local autoDestroy = false
local autoArise = false

local function fireDestroy()
    while autoDestroy do
        task.wait(0.3)
        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
            if enemy:IsA("Model") then
                local rootPart = enemy:FindFirstChild("HumanoidRootPart")
                local DestroyPrompt = rootPart and rootPart:FindFirstChild("DestroyPrompt")

                if DestroyPrompt then
                    DestroyPrompt:SetAttribute("MaxActivationDistance", 100000)
                    fireproximityprompt(DestroyPrompt)
                end
            end
        end
    end
end

local function fireArise()
    while autoArise do
        task.wait(0.3)
        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
            if enemy:IsA("Model") then
                local rootPart = enemy:FindFirstChild("HumanoidRootPart")
                local arisePrompt = rootPart and rootPart:FindFirstChild("ArisePrompt")

                if arisePrompt then
                    arisePrompt:SetAttribute("MaxActivationDistance", 100000)
                    fireproximityprompt(arisePrompt)
                end
            end
        end
    end
end

-- Tạo Window với Orion UI
local Window = OrionLib:MakeWindow({
    Name = "Kaihon Hub | Arise Crossover",
    HidePremium = true,
    SaveConfig = true,
    ConfigFolder = "KaihonHub_AriseCrossover",
    IntroEnabled = false
})

-- INFO Tab
local InfoTab = Window:MakeTab({
    Name = "INFO",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

InfoTab:AddParagraph("🎉 Chào mừng đến với Kaihon Hub!", 
    "Mở khóa trải nghiệm tốt nhất với các tính năng cao cấp!\n\n" ..
    "✅ Vượt qua Anti-Cheat nâng cao\n" ..
    "⚡ Thực thi nhanh hơn & Tối ưu hóa\n" ..
    "🔄 Cập nhật độc quyền\n" ..
    "🎁 Hỗ trợ & Cộng đồng"
)

InfoTab:AddButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/W77Vj2HNBA")
        OrionLib:MakeNotification({
            Name = "Đã sao chép!",
            Content = "Đường dẫn Discord đã được sao chép vào clipboard.",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end    
})

-- MAIN Tab
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Dropdown để chọn World/Map
local WorldDropdown = MainTab:AddDropdown({
    Name = "Select World",
    Default = ConfigSystem.CurrentConfig.SelectedWorld or "SoloWorld",
    Options = {"SoloWorld", "NarutoWorld", "OPWorld", "BleachWorld", "BCWorld", "ChainsawWorld", "JojoWorld"},
    Callback = function(value)
        selectedWorld = value
        ConfigSystem.CurrentConfig.SelectedWorld = value
        
        -- Cập nhật danh sách mob dựa trên world được chọn
        local mobs = mobsByWorld[value] or {}
        MobDropdown:Refresh(mobs, mobs[1] or "")
        if #mobs > 0 then
            selectedMobName = mobs[1]
            ConfigSystem.CurrentConfig.SelectedMobName = selectedMobName
        else
            selectedMobName = ""
        end
        
        ConfigSystem.SaveConfig()
        killedNPCs = {} -- Đặt lại danh sách NPC đã tiêu diệt khi thay đổi world
    end    
})

-- Dropdown để chọn Mob trong world đã chọn
local MobDropdown = MainTab:AddDropdown({
    Name = "Select Enemy",
    Default = "",
    Options = mobsByWorld[selectedWorld] or {},
    Callback = function(value)
        selectedMobName = value
        ConfigSystem.CurrentConfig.SelectedMobName = value
        ConfigSystem.SaveConfig()
        killedNPCs = {} -- Đặt lại danh sách NPC đã tiêu diệt khi thay đổi mob
        print("Selected Mob:", selectedMobName) -- Gỡ lỗi
    end    
})

MainTab:AddToggle({
    Name = "Farm Selected Mob",
    Default = ConfigSystem.CurrentConfig.FarmSelectedMob or false,
    Callback = function(value)
        teleportEnabled = value
        damageEnabled = value -- Đảm bảo tính năng tấn công mobs được kích hoạt
        ConfigSystem.CurrentConfig.FarmSelectedMob = value
        ConfigSystem.SaveConfig()
        killedNPCs = {} -- Đặt lại danh sách NPC đã tiêu diệt khi bắt đầu farm
        if value then
            task.spawn(teleportToSelectedEnemy)
        end
    end    
})

MainTab:AddToggle({
    Name = "Auto farm (nearest NPCs)",
    Default = ConfigSystem.CurrentConfig.AutoFarmNearestNPCs or false,
    Callback = function(value)
        teleportEnabled = value
        ConfigSystem.CurrentConfig.AutoFarmNearestNPCs = value
        ConfigSystem.SaveConfig()
        if value then
            task.spawn(teleportAndTrackDeath)
        end
    end    
})

MainTab:AddDropdown({
    Name = "Farming Method",
    Default = ConfigSystem.CurrentConfig.FarmingMethod or "Tween",
    Options = {"Tween", "Teleport"},
    Callback = function(value)
        movementMethod = value
        ConfigSystem.CurrentConfig.FarmingMethod = value
        ConfigSystem.SaveConfig()
    end    
})

MainTab:AddToggle({
    Name = "Damage Mobs ENABLE THIS",
    Default = ConfigSystem.CurrentConfig.DamageMobs or false,
    Callback = function(value)
        damageEnabled = value
        ConfigSystem.CurrentConfig.DamageMobs = value
        ConfigSystem.SaveConfig()
        if value then
            task.spawn(attackEnemy)
        end
    end    
})

MainTab:AddToggle({
    Name = "Gamepass Shadow farm",
    Default = false,
    Callback = function(value)
        local attackatri = game:GetService("Players").LocalPlayer.Settings
        local atri = attackatri:GetAttribute("AutoAttack")
        
        if value then
            -- Bật tính năng
            if atri == false then
                attackatri:SetAttribute("AutoAttack", true)
            end
            print("Shadow farm đã bật")
        else
            -- Tắt tính năng
            attackatri:SetAttribute("AutoAttack", false)
            print("Shadow farm đã tắt")
        end
    end    
})

-- Auto Destroy/Arise Toggles
MainTab:AddToggle({
    Name = "Auto Destroy",
    Default = ConfigSystem.CurrentConfig.MainAutoDestroy or false,
    Callback = function(value)
        autoDestroy = value
        ConfigSystem.CurrentConfig.MainAutoDestroy = value
        ConfigSystem.SaveConfig()
        if value then
            task.spawn(fireDestroy)
        end
    end    
})

MainTab:AddToggle({
    Name = "Auto Arise",
    Default = ConfigSystem.CurrentConfig.MainAutoArise or false,
    Callback = function(value)
        autoArise = value
        ConfigSystem.CurrentConfig.MainAutoArise = value
        ConfigSystem.SaveConfig()
        if value then
            task.spawn(fireArise)
        end
    end    
})

-- TELEPORTS Tab
local TeleportsTab = Window:MakeTab({
    Name = "Teleports",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

TeleportsTab:AddButton({
    Name = "Leveling City",
    Callback = function()
        SetSpawnAndReset("SoloWorld")
    end    
})

TeleportsTab:AddButton({
    Name = "Grass Village",
    Callback = function()
        SetSpawnAndReset("NarutoWorld")
    end    
})

TeleportsTab:AddButton({
    Name = "Brum Island",
    Callback = function()
        SetSpawnAndReset("OPWorld")
    end    
})

TeleportsTab:AddButton({
    Name = "Faceheal Town",
    Callback = function()
        SetSpawnAndReset("BleachWorld")
    end    
})

TeleportsTab:AddButton({
    Name = "Lucky Kingdom",
    Callback = function()
        SetSpawnAndReset("BCWorld")
    end    
})

TeleportsTab:AddButton({
    Name = "Nipon City",
    Callback = function()
        SetSpawnAndReset("ChainsawWorld")
    end    
})

TeleportsTab:AddButton({
    Name = "Mori Town",
    Callback = function()
        SetSpawnAndReset("JojoWorld")
    end    
})

-- DUNGEON Tab
local DungeonTab = Window:MakeTab({
    Name = "Dungeon",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

DungeonTab:AddToggle({
    Name = "Auto farm Dungeon",
    Default = false,
    Callback = function(value)
        teleportEnabled = value
        if value then
            task.spawn(teleportDungeon)
        end
    end    
})

DungeonTab:AddToggle({
    Name = "Auto Destroy",
    Default = false,
    Callback = function(value)
        autoDestroy = value
        if value then
            task.spawn(fireDestroy)
        end
    end    
})

DungeonTab:AddToggle({
    Name = "Auto Arise",
    Default = false,
    Callback = function(value)
        autoArise = value
        if value then
            task.spawn(fireArise)
        end
    end    
})

DungeonTab:AddToggle({
    Name = "Teleport to Dungeon",
    Default = false,
    Callback = function(value)
        -- Teleport to Dungeon Logic
        -- Implement your teleport dungeon function here
    end    
})

DungeonTab:AddToggle({
    Name = "Auto Detect Dungeon (KEEP THIS ON)",
    Default = true,
    Callback = function(value)
        -- Auto Detect Dungeon Logic
        if value then
            player.PlayerGui.Warn.ChildAdded:Connect(function(dungeon)
                if dungeon:IsA("Frame") and value then
                    print("Đã phát hiện Dungeon!")
                    for _, child in ipairs(dungeon:GetChildren()) do
                        if child:IsA("TextLabel") then
                            for village, spawnName in pairs({
                                ["Grass Village"] = "NarutoWorld",
                                ["BRUM ISLAND"] = "OPWorld",
                                ["Leveling City"] = "SoloWorld",
                                ["FACEHEAL TOWN"] = "BleachWorld",
                                ["Lucky"] = "BCWorld",
                                ["Nipon City"] = "ChainsawWorld",
                                ["Mori Town"] = "JojoWorld",
                            }) do
                                if string.find(string.lower(child.Text), string.lower(village)) then
                                    teleportEnabled = false
                                    print("Đã phát hiện làng:", village)
                                    SetSpawnAndReset(spawnName)
                                    return
                                end
                            end
                        end
                    end
                end
            end)
        end
    end    
})

DungeonTab:AddToggle({
    Name = "Auto Enter Guild Dungeon",
    Default = false,
    Callback = function(value)
        if value then
            task.spawn(function()
                while value do
                    local args = {
                        [1] = {
                            [1] = {
                                ["Event"] = "DungeonAction",
                                ["Action"] = "TestEnter"
                            },
                            [2] = "\n"
                        }
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                    task.wait(0.5)
                end
            end)
        end
    end    
})

DungeonTab:AddToggle({
    Name = "Auto Buy Dungeon Ticket",
    Default = false,
    Callback = function(value)
        if value then
            task.spawn(function()
                while value do
                    local args = {
                        [1] = {
                            [1] = {
                                ["Type"] = "Gems",
                                ["Event"] = "DungeonAction",
                                ["Action"] = "BuyTicket"
                            },
                            [2] = "\n"
                        }
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end    
})

-- PLAYER Tab
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local speedValue = 16
local jumpValue = 50
local speedEnabled = false
local jumpEnabled = false

PlayerTab:AddSlider({
    Name = "Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "",
    Callback = function(value)
        speedValue = value
        if speedEnabled and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end    
})

PlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "",
    Callback = function(value)
        jumpValue = value
        if jumpEnabled and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end    
})

PlayerTab:AddToggle({
    Name = "Enable Speed",
    Default = false,
    Callback = function(value)
        speedEnabled = value
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value and speedValue or 16
        end
    end    
})

PlayerTab:AddToggle({
    Name = "Enable Jump Power",
    Default = false,
    Callback = function(value)
        jumpEnabled = value
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value and jumpValue or 50
        end
    end    
})

PlayerTab:AddToggle({
    Name = "Anti AFK",
    Default = false,
    Callback = function(value)
        if value then
            local VirtualUser = game:GetService("VirtualUser")
            local antiAfkConnection
            
            antiAfkConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        end
    end    
})

PlayerTab:AddToggle({
    Name = "Enable NoClip",
    Default = false,
    Callback = function(value)
        if value then
            task.spawn(function()
                while value do
                    for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    task.wait()
                end
            end)
        else
            for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end    
})

PlayerTab:AddButton({
    Name = "Boost FPS",
    Callback = function()
        local Optimizer = {Enabled = true}

        -- Disable Effects
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
            end
            if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
                v.Enabled = false
            end
        end

        -- Maximize Performance
        local lighting = game:GetService("Lighting")
        lighting.GlobalShadows = false
        lighting.FogEnd = 9e9
        lighting.Brightness = 2
        settings().Rendering.QualityLevel = 1
        settings().Physics.PhysicsEnvironmentalThrottle = 1
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
        settings().Physics.AllowSleep = true
        settings().Physics.ForceCSGv2 = false
        settings().Physics.DisableCSGv2 = true
        settings().Rendering.EagerBulkExecution = true

        game:GetService("StarterGui"):SetCore("TopbarEnabled", false)

        -- Optimize Instances
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CastShadow = false
                v.Reflectance = 0
                v.Material = Enum.Material.SmoothPlastic
            end
            if v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end
            if v:IsA("MeshPart") then
                v.RenderFidelity = Enum.RenderFidelity.Performance
            end
        end

        -- Clean Memory
        game:GetService("Debris"):SetAutoCleanupEnabled(true)
        settings().Physics.ThrottleAdjustTime = 2
        game:GetService("RunService"):Set3dRenderingEnabled(false)
        task.wait(0.1)
        game:GetService("RunService"):Set3dRenderingEnabled(true)
        
        OrionLib:MakeNotification({
            Name = "FPS Boost",
            Content = "FPS Boosting has been applied!",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end    
})

PlayerTab:AddButton({
    Name = "Server Hop",
    Callback = function()
        local PlaceID = game.PlaceId
        local AllIDs = {}
        local foundAnything = ""
        local actualHour = os.date("!*t").hour
        
        local Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        for _, v in pairs(Site.data) do
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                local ID = tostring(v.id)
                game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                break
            end
        end
    end    
})

-- Tự động reset farm
task.spawn(function()
    while true do
        task.wait(120) -- Đợi 120 giây
        killedNPCs = {} -- Đặt lại số lượng NPC đã tiêu diệt
        print("AutoFarm đã được đặt lại!")
    end
end)

-- Notification khi khởi động
OrionLib:MakeNotification({
    Name = "Kaihon Hub",
    Content = "Script đã tải xong! Phiên bản tối ưu hiệu suất.",
    Image = "rbxassetid://4483345998",
    Time = 5
})

-- Mobile UI Support
task.spawn(function()
    if not getgenv().LoadedMobileUI then
        getgenv().LoadedMobileUI = true
        local OpenUI = Instance.new("ScreenGui")
        local ImageButton = Instance.new("ImageButton")
        local UICorner = Instance.new("UICorner")
        
        -- Check device
        if syn and syn.protect_gui then
            syn.protect_gui(OpenUI)
            OpenUI.Parent = game:GetService("CoreGui")
        elseif gethui then
            OpenUI.Parent = gethui()
        else
            OpenUI.Parent = game:GetService("CoreGui")
        end
        
        OpenUI.Name = "OpenUI"
        OpenUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        ImageButton.Parent = OpenUI
        ImageButton.BackgroundColor3 = Color3.fromRGB(105,105,105)
        ImageButton.BackgroundTransparency = 0.8
        ImageButton.Position = UDim2.new(0.9,0,0.1,0)
        ImageButton.Size = UDim2.new(0,50,0,50)
        ImageButton.Image = "rbxassetid://13099788281"
        ImageButton.Draggable = true
        ImageButton.Transparency = 0.2
        
        UICorner.CornerRadius = UDim.new(0,200)
        UICorner.Parent = ImageButton
        
        ImageButton.MouseButton1Click:Connect(function()
            OrionLib:ToggleUI()
        end)
    end
end)

OrionLib:Init() 
