-- Chỉ chạy script nếu đúng GameID
do
    local ok, gameId = pcall(function()
        return game.GameId
    end)
    if not ok or tonumber(gameId) ~= 4509896324 then
        return
    end
end

-- Load UI Library với error handling
local success, err = pcall(function()
    Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
    InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
end)

if not success then
    warn("Lỗi khi tải UI Library: " .. tostring(err))
    return
end

if not Fluent then
    warn("Không thể tải thư viện Fluent!")
    return
end

-- Hệ thống lưu trữ cấu hình
local ConfigSystem = {}
ConfigSystem.FileName = "HTHubAllStar_" .. game:GetService("Players").LocalPlayer.Name .. ".json"
ConfigSystem.DefaultConfig = {
    DelayTime = 3,
    HalloweenEventEnabled = false,
    AutoHideUI = false,
}
ConfigSystem.CurrentConfig = {}

ConfigSystem.SaveConfig = function()
    local success, err = pcall(function()
        writefile(ConfigSystem.FileName, game:GetService("HttpService"):JSONEncode(ConfigSystem.CurrentConfig))
    end)
    if not success then warn("Lưu cấu hình thất bại:", err) end
end

ConfigSystem.LoadConfig = function()
    local success, content = pcall(function()
        if isfile(ConfigSystem.FileName) then
            return readfile(ConfigSystem.FileName)
        end
    end)

    if success and content then
        ConfigSystem.CurrentConfig = game:GetService("HttpService"):JSONDecode(content)
    else
        ConfigSystem.CurrentConfig = table.clone(ConfigSystem.DefaultConfig)
        ConfigSystem.SaveConfig()
    end
end

ConfigSystem.LoadConfig()

local playerName = game:GetService("Players").LocalPlayer.Name

local Window = Fluent:CreateWindow({
    Title = "HT HUB | All Star Tower Defense",
    TabWidth = 80,
    Size = UDim2.fromOffset(300, 220),
    Acrylic = true,
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local JoinerTab = Window:AddTab({ Title = "Joiner", Icon = "rbxassetid://90319448802378" })
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "rbxassetid://13311798537" })
local EventSection = JoinerTab:AddSection("Event")
local SettingsSection = SettingsTab:AddSection("Script Settings")
local UISection = SettingsTab:AddSection("UI Settings")

local halloweenEventEnabled = ConfigSystem.CurrentConfig.HalloweenEventEnabled or false
local delayTime = ConfigSystem.CurrentConfig.DelayTime or 3

-- Halloween Event logic
local function executeHalloweenEvent()
    if not halloweenEventEnabled then return end
    task.spawn(function()
        print("Bước 1: Entering Halloween Event...")
        game:GetService("ReplicatedStorage").Events.Hallowen2025.Enter:FireServer()
        task.wait(delayTime)
        if halloweenEventEnabled then
            print("Bước 2: Starting Halloween Event...")
            game:GetService("ReplicatedStorage").Events.Hallowen2025.Start:FireServer()
        end
    end)
end

EventSection:AddInput("DelayTimeInput", {
    Title = "Delay Time",
    Default = tostring(delayTime),
    Callback = function(val)
        local num = tonumber(val)
        if num and num >= 1 and num <= 60 then
            delayTime = num
            ConfigSystem.CurrentConfig.DelayTime = num
            ConfigSystem.SaveConfig()
        end
    end
})

EventSection:AddToggle("HalloweenEventToggle", {
    Title = "Join Halloween Event",
    Default = halloweenEventEnabled,
    Callback = function(enabled)
        halloweenEventEnabled = enabled
        ConfigSystem.CurrentConfig.HalloweenEventEnabled = enabled
        ConfigSystem.SaveConfig()
        if enabled then executeHalloweenEvent() end
    end
})

-- 🧩 Auto Hide UI Toggle
local autoHideEnabled = ConfigSystem.CurrentConfig.AutoHideUI or false
UISection:AddToggle("AutoHideUIToggle", {
    Title = "Auto Hide UI",
    Description = "Tự động ẩn/hiện toàn bộ UI (trừ nút logo nhỏ)",
    Default = autoHideEnabled,
    Callback = function(enabled)
        autoHideEnabled = enabled
        ConfigSystem.CurrentConfig.AutoHideUI = enabled
        ConfigSystem.SaveConfig()
        local gui = game:GetService("CoreGui"):FindFirstChild("Fluent")
        if gui then gui.Enabled = not enabled end
        print(enabled and "Auto Hide UI: ON" or "Auto Hide UI: OFF")
    end
})

task.delay(1, function()
    local gui = game:GetService("CoreGui"):FindFirstChild("Fluent")
    if gui then gui.Enabled = not autoHideEnabled end
end)

-- Logo mở UI
spawn(function()
    if not getgenv().LoadedMobileUI then
        getgenv().LoadedMobileUI = true
        local OpenUI = Instance.new("ScreenGui")
        local Button = Instance.new("ImageButton")
        local Corner = Instance.new("UICorner")

        if syn and syn.protect_gui then syn.protect_gui(OpenUI) end
        OpenUI.Parent = game:GetService("CoreGui")
        OpenUI.Name = "OpenUI"

        Button.Parent = OpenUI
        Button.BackgroundColor3 = Color3.fromRGB(105,105,105)
        Button.BackgroundTransparency = 0.8
        Button.Position = UDim2.new(0.9, 0, 0.1, 0)
        Button.Size = UDim2.new(0, 50, 0, 50)
        Button.Image = "rbxassetid://13099788281"
        Button.Draggable = true
        Corner.CornerRadius = UDim.new(0,200)
        Corner.Parent = Button

        Button.MouseButton1Click:Connect(function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
        end)
    end
end)

print("HT Hub All Star Tower Defense Script đã tải thành công!")
