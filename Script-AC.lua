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
    SaveManager = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
    InterfaceManager = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
end)

if not success then
    warn("Lỗi khi tải UI Library: " .. tostring(err))
    return
end

-- Đợi đến khi Fluent được tải hoàn tất
if not Fluent then
    warn("Không thể tải thư viện Fluent!")
    return
end

-- Hệ thống lưu trữ cấu hình
local ConfigSystem = {}
ConfigSystem.FileName = "HTHubAllStar_" .. game:GetService("Players").LocalPlayer.Name .. ".json"
ConfigSystem.DefaultConfig = {
    -- Event Settings
    DelayTime = 3,
    HalloweenEventEnabled = false,
    AutoHideUIEnabled = false,
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


-- Lấy tên người chơi
local playerName = game:GetService("Players").LocalPlayer.Name

-- Cấu hình UI
local Window = Fluent:CreateWindow({
    Title = "HT HUB | All Star Tower Defense",
    SubTitle = "",
    TabWidth = 80,
    Size = UDim2.fromOffset(300, 220),
    Acrylic = true,
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Hệ thống Tạo Tab
-- Tạo Tab Joiner
local JoinerTab = Window:AddTab({ Title = "Joiner", Icon = "rbxassetid://90319448802378" })

-- Tạo Tab Settings
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "rbxassetid://13311798537" })

-- Tab Joiner
-- Section Event trong tab Joiner
local EventSection = JoinerTab:AddSection("Event")
-- Tab Settings
-- Settings tab configuration
local SettingsSection = SettingsTab:AddSection("Script Settings")
-- Thêm section UI Settings vào tab Settings
local SettingsSection = SettingsTab:AddSection("UI Settings")

-- Chọn tab Joiner mặc định khi mở script
pcall(function()
    if JoinerTab and JoinerTab.Select then
        JoinerTab:Select()
    elseif Window and Window.SelectTab then
        Window:SelectTab(JoinerTab)
    end
end)

-- Biến lưu trạng thái Halloween Event
local halloweenEventEnabled = ConfigSystem.CurrentConfig.HalloweenEventEnabled or false
local delayTime = ConfigSystem.CurrentConfig.DelayTime or 3
-- Biến lưu trạng thái Auto Hide UI
local autoHideUIEnabled = ConfigSystem.CurrentConfig.AutoHideUIEnabled or false

-- Hàm tự động ẩn UI sau 3 giây khi bật
local function autoHideUI()
    if not Window then return end
    task.spawn(function()
        print("Auto Hide UI: Sẽ tự động ẩn sau 3 giây...")
        task.wait(3)
        if Window.Minimize then
            Window:Minimize()
            print("UI đã được ẩn!")
        elseif Window.Visible ~= nil then
            Window.Visible = false
            print("UI đã bị ẩn thông qua Visible!")
        end
    end)
end
-- Hàm thực thi Halloween Event
local function executeHalloweenEvent()
    if not halloweenEventEnabled then return end

    local success, err = pcall(function()
        -- Bước 1: Enter Halloween Event
        print("Bước 1: Entering Halloween Event...")
        game:GetService("ReplicatedStorage").Events.Hallowen2025.Enter:FireServer()

        -- Bước 2: Đợi delay time rồi Start
        task.wait(delayTime)

        if halloweenEventEnabled then -- Kiểm tra lại sau khi đợi
            print("Bước 2: Starting Halloween Event...")
            game:GetService("ReplicatedStorage").Events.Hallowen2025.Start:FireServer()
            print("Halloween Event executed successfully!")
        end
    end)

    if not success then
        warn("Lỗi Halloween Event:", err)
    end
end

-- Input Delay Time
EventSection:AddInput("DelayTimeInput", {
    Title = "Delay Time",
    Default = tostring(delayTime),
    Placeholder = "(1-60s)",
    Callback = function(val)
        local num = tonumber(val)
        if num and num >= 1 and num <= 60 then
            delayTime = num
            ConfigSystem.CurrentConfig.DelayTime = delayTime
            ConfigSystem.SaveConfig()
            print("Delay time set to:", delayTime, "seconds")
        else
            warn("Delay time must be between 1-60 seconds")
        end
    end
})

-- Toggle Join Halloween Event
EventSection:AddToggle("HalloweenEventToggle", {
    Title = "Join Halloween Event",
    Description = "Auto Join Halloween",
    Default = halloweenEventEnabled,
    Callback = function(enabled)
        halloweenEventEnabled = enabled
        ConfigSystem.CurrentConfig.HalloweenEventEnabled = halloweenEventEnabled
        ConfigSystem.SaveConfig()
        if halloweenEventEnabled then
            print("Halloween Event Enabled - Auto Join Halloween 2025")
            executeHalloweenEvent()
        else
            print("Halloween Event Disabled - Auto Join Halloween 2025")
        end
    end
})

-- Thêm Toggle Auto Hide UI vào Settings tab
SettingsSection:AddToggle("AutoHideUIToggle", {
    Title = "Auto Hide UI",
    Description = "Tự động ẩn UI sau 3 giây khi bật",
    Default = autoHideUIEnabled,
    Callback = function(enabled)
        autoHideUIEnabled = enabled
        ConfigSystem.CurrentConfig.AutoHideUIEnabled = autoHideUIEnabled
        ConfigSystem.SaveConfig()
        if autoHideUIEnabled then
            autoHideUI()
        else
            print("Auto Hide UI đã tắt")
        end
    end
})

-- Integration with SaveManager
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Thay đổi cách lưu cấu hình để sử dụng tên người chơi
InterfaceManager:SetFolder("HTHubAllStar")
SaveManager:SetFolder("HTHubAllStar/" .. playerName)

-- Thêm thông tin vào tab Settings
SettingsTab:AddParagraph({
    Title = "Cấu hình tự động",
    Content = "Cấu hình của bạn đang được tự động lưu theo tên nhân vật: " .. playerName
})

SettingsTab:AddParagraph({
    Title = "Phím tắt",
    Content = "Nhấn LeftControl để ẩn/hiện giao diện"
})

-- Auto Save Config
local function AutoSaveConfig()
    spawn(function()
        while wait(5) do -- Lưu mỗi 5 giây
            pcall(function()
                ConfigSystem.SaveConfig()
            end)
        end
    end)
end

-- Thực thi tự động lưu cấu hình
AutoSaveConfig()

-- Thêm event listener để lưu ngay khi thay đổi giá trị
local function setupSaveEvents()
    for _, tab in pairs({ MainTab, SettingsTab }) do
        if tab and tab._components then
            for _, element in pairs(tab._components) do
                if element and element.OnChanged then
                    element.OnChanged:Connect(function()
                        pcall(function()
                            ConfigSystem.SaveConfig()
                        end)
                    end)
                end
            end
        end
    end
end

-- Thiết lập events
setupSaveEvents()

-- Tạo logo để mở lại UI khi đã minimize
task.spawn(function()
    local success, errorMsg = pcall(function()
        if not getgenv().LoadedMobileUI == true then
            getgenv().LoadedMobileUI = true
            local OpenUI = Instance.new("ScreenGui")
            local ImageButton = Instance.new("ImageButton")
            local UICorner = Instance.new("UICorner")

            -- Kiểm tra môi trường
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
            ImageButton.BackgroundColor3 = Color3.fromRGB(105, 105, 105)
            ImageButton.BackgroundTransparency = 0.8
            ImageButton.Position = UDim2.new(0.9, 0, 0.1, 0)
            ImageButton.Size = UDim2.new(0, 50, 0, 50)
            ImageButton.Image = "rbxassetid://13099788281" -- Logo HT Hub
            ImageButton.Draggable = true
            ImageButton.Transparency = 0.2

            UICorner.CornerRadius = UDim.new(0, 200)
            UICorner.Parent = ImageButton

            -- Khi click vào logo sẽ mở lại UI
            ImageButton.MouseButton1Click:Connect(function()
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
            end)
        end
    end)

    if not success then
        warn("Lỗi khi tạo nút Logo UI: " .. tostring(errorMsg))
    end
end)

print("HT Hub All Star Tower Defense Script đã tải thành công!")
print("Sử dụng Left Ctrl để thu nhỏ/mở rộng UI")
