-- Arise Crossover - UI Glassmorphic
-- Thiết kế bởi Claude

local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Tạo ScreenGui chính
local AriseUI = Instance.new("ScreenGui")
AriseUI.Name = "AriseUI"
AriseUI.Parent = player:WaitForChild("PlayerGui")
AriseUI.ResetOnSpawn = false
AriseUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Nền mờ cho toàn màn hình
local BlurBackground = Instance.new("Frame")
BlurBackground.Name = "BlurBackground"
BlurBackground.Parent = AriseUI
BlurBackground.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BlurBackground.BackgroundTransparency = 1
BlurBackground.Position = UDim2.new(0, 0, 0, 0)
BlurBackground.Size = UDim2.new(1, 0, 1, 0)

-- Tạo hiệu ứng mờ nền
local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Name = "BlurEffect"
BlurEffect.Parent = game:GetService("Lighting")
BlurEffect.Size = 0

-- Tạo Main Frame với hiệu ứng kính trong suốt
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = AriseUI
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BackgroundTransparency = 0.9
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.ClipsDescendants = true

-- Tạo hiệu ứng bo tròn cho frame chính
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

-- Tạo hiệu ứng viền sáng
local Stroke = Instance.new("UIStroke")
Stroke.Parent = MainFrame
Stroke.Color = Color3.fromRGB(255, 255, 255)
Stroke.Transparency = 0.7
Stroke.Thickness = 1.5

-- Tạo gradient màu cho nền
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 120, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 70, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 80, 255))
})
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

-- Tạo TopBar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TopBar.BackgroundTransparency = 0.9
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 40)

-- Tạo viền cho TopBar
local TopBarStroke = Instance.new("UIStroke")
TopBarStroke.Parent = TopBar
TopBarStroke.Color = Color3.fromRGB(255, 255, 255)
TopBarStroke.Transparency = 0.8
TopBarStroke.Thickness = 1
TopBarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Tạo hiệu ứng bo tròn cho TopBar
local UICornerTopBar = Instance.new("UICorner")
UICornerTopBar.CornerRadius = UDim.new(0, 15)
UICornerTopBar.Parent = TopBar

-- Logo Game
local LogoFrame = Instance.new("Frame")
LogoFrame.Name = "LogoFrame"
LogoFrame.Parent = TopBar
LogoFrame.BackgroundTransparency = 1
LogoFrame.Position = UDim2.new(0, 10, 0, 0)
LogoFrame.Size = UDim2.new(0, 40, 0, 40)

-- Logo hình ảnh
local LogoImage = Instance.new("ImageLabel")
LogoImage.Name = "LogoImage"
LogoImage.Parent = LogoFrame
LogoImage.BackgroundTransparency = 1
LogoImage.Position = UDim2.new(0, 0, 0, 0)
LogoImage.Size = UDim2.new(1, 0, 1, 0)
LogoImage.Image = "rbxassetid://14513361054" -- Logo giả định, thay bằng ID ảnh thực tế
LogoImage.ImageTransparency = 0.1

-- Tên Game
local GameTitle = Instance.new("TextLabel")
GameTitle.Name = "GameTitle"
GameTitle.Parent = TopBar
GameTitle.BackgroundTransparency = 1
GameTitle.Position = UDim2.new(0, 60, 0, 0)
GameTitle.Size = UDim2.new(0, 200, 1, 0)
GameTitle.Font = Enum.Font.GothamBold
GameTitle.Text = "ARISE CROSSOVER"
GameTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
GameTitle.TextSize = 18
GameTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Nút đóng
local CloseButton = Instance.new("ImageButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(1, -40, 0.5, -15)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Image = "rbxassetid://7734010488" -- X icon
CloseButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.ImageTransparency = 0.3

-- Nút thu nhỏ
local MinimizeButton = Instance.new("ImageButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TopBar
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Position = UDim2.new(1, -80, 0.5, -15)
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Image = "rbxassetid://7734053495" -- Minimize icon
MinimizeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.ImageTransparency = 0.3

-- Container cho nội dung
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 0, 0, 40)
ContentContainer.Size = UDim2.new(1, 0, 1, -40)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = ContentContainer
Sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Sidebar.BackgroundTransparency = 0.9
Sidebar.BorderSizePixel = 0
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.Size = UDim2.new(0, 150, 1, 0)

-- Hiệu ứng bo tròn cho Sidebar
local UICornerSidebar = Instance.new("UICorner")
UICornerSidebar.CornerRadius = UDim.new(0, 15)
UICornerSidebar.Parent = Sidebar

-- Tạo cắt góc cho Sidebar chỉ bo tròn bên phải
local SidebarCutout = Instance.new("Frame")
SidebarCutout.Name = "SidebarCutout"
SidebarCutout.Parent = Sidebar
SidebarCutout.BackgroundColor3 = Sidebar.BackgroundColor3
SidebarCutout.BackgroundTransparency = Sidebar.BackgroundTransparency
SidebarCutout.BorderSizePixel = 0
SidebarCutout.Position = UDim2.new(0, 0, 0, 0)
SidebarCutout.Size = UDim2.new(0.5, 0, 1, 0)

-- Tạo danh sách tab
local TabButtons = {}
local TabFrames = {}
local tabList = {"General", "Dungeon", "Jeju Island", "Extra"}

-- Container cho tab buttons trên sidebar
local TabsContainer = Instance.new("Frame")
TabsContainer.Name = "TabsContainer"
TabsContainer.Parent = Sidebar
TabsContainer.BackgroundTransparency = 1
TabsContainer.Position = UDim2.new(0, 0, 0, 20)
TabsContainer.Size = UDim2.new(1, 0, 0, #tabList * 50)

-- Tạo các tab
for i, tabName in ipairs(tabList) do
    -- Tab button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName.."Tab"
    TabButton.Parent = TabsContainer
    TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.BackgroundTransparency = 0.95
    TabButton.Position = UDim2.new(0, 10, 0, (i-1) * 50)
    TabButton.Size = UDim2.new(1, -20, 0, 40)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.TextSize = 14
    TabButton.TextTransparency = 0.2
    
    -- Bo tròn cho button
    local TabButtonCorner = Instance.new("UICorner")
    TabButtonCorner.CornerRadius = UDim.new(0, 10)
    TabButtonCorner.Parent = TabButton
    
    -- Tab content frame
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = tabName.."Content"
    TabContent.Parent = ContentContainer
    TabContent.BackgroundTransparency = 1
    TabContent.Position = UDim2.new(0, 160, 0, 10)
    TabContent.Size = UDim2.new(1, -170, 1, -20)
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    TabContent.ScrollBarImageTransparency = 0.5
    TabContent.Visible = (i == 1) -- Chỉ hiển thị tab đầu tiên
    
    -- Thêm vào bảng để dễ quản lý
    TabButtons[tabName] = TabButton
    TabFrames[tabName] = TabContent
    
    -- Thêm hiệu ứng cho nút tab
    local function updateTabButtonState()
        for name, button in pairs(TabButtons) do
            if name == tabName and TabFrames[name].Visible then
                -- Nút được chọn
                TweenService:Create(button, TweenInfo.new(0.3), {
                    BackgroundTransparency = 0.8,
                    TextTransparency = 0
                }):Play()
            else
                -- Nút không được chọn
                TweenService:Create(button, TweenInfo.new(0.3), {
                    BackgroundTransparency = 0.95,
                    TextTransparency = 0.4
                }):Play()
            end
        end
    end
    
    -- Tab switch logic
    TabButton.MouseButton1Click:Connect(function()
        for _, frame in pairs(TabFrames) do
            frame.Visible = false
        end
        
        TabFrames[tabName].Visible = true
        updateTabButtonState()
    end)
    
    -- Khởi tạo trạng thái ban đầu
    updateTabButtonState()
end

-- Tạo hàm giúp tạo dropdown
local function createDropdown(parent, position, size, options, defaultText)
    -- Container chính
    local dropdown = Instance.new("Frame")
    dropdown.Name = "Dropdown"
    dropdown.Parent = parent
    dropdown.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    dropdown.BackgroundTransparency = 0.5
    dropdown.Position = position
    dropdown.Size = size
    dropdown.ClipsDescendants = true
    
    -- Bo tròn
    local UICornerDropdown = Instance.new("UICorner")
    UICornerDropdown.CornerRadius = UDim.new(0, 8)
    UICornerDropdown.Parent = dropdown
    
    -- Viền
    local UIStrokeDropdown = Instance.new("UIStroke")
    UIStrokeDropdown.Parent = dropdown
    UIStrokeDropdown.Color = Color3.fromRGB(0, 255, 255)
    UIStrokeDropdown.Transparency = 0.8
    UIStrokeDropdown.Thickness = 1
    
    -- Nút chính
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Parent = dropdown
    dropdownButton.BackgroundTransparency = 1
    dropdownButton.Size = UDim2.new(1, 0, 1, 0)
    dropdownButton.Font = Enum.Font.GothamSemibold
    dropdownButton.Text = defaultText
    dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownButton.TextSize = 14
    
    -- Icon mũi tên
    local arrowIcon = Instance.new("TextLabel")
    arrowIcon.Name = "ArrowIcon"
    arrowIcon.Parent = dropdown
    arrowIcon.BackgroundTransparency = 1
    arrowIcon.Position = UDim2.new(1, -30, 0, 0)
    arrowIcon.Size = UDim2.new(0, 30, 1, 0)
    arrowIcon.Font = Enum.Font.GothamBold
    arrowIcon.Text = "▼"
    arrowIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    arrowIcon.TextSize = 14
    
    -- Tạo dropdown items container
    local itemsContainer = Instance.new("Frame")
    itemsContainer.Name = "ItemsContainer"
    itemsContainer.Parent = dropdown
    itemsContainer.BackgroundColor3 = dropdown.BackgroundColor3
    itemsContainer.BackgroundTransparency = 0.3
    itemsContainer.Position = UDim2.new(0, 0, 1, 5)
    itemsContainer.Size = UDim2.new(1, 0, 0, #options * 30)
    itemsContainer.Visible = false
    itemsContainer.ZIndex = 10
    
    -- Bo tròn
    local UICornerItems = Instance.new("UICorner")
    UICornerItems.CornerRadius = UDim.new(0, 8)
    UICornerItems.Parent = itemsContainer
    
    -- Viền
    local UIStrokeItems = Instance.new("UIStroke")
    UIStrokeItems.Parent = itemsContainer
    UIStrokeItems.Color = UIStrokeDropdown.Color
    UIStrokeItems.Transparency = UIStrokeDropdown.Transparency
    UIStrokeItems.Thickness = UIStrokeDropdown.Thickness
    
    -- Tạo các option
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option"..i
        optionButton.Parent = itemsContainer
        optionButton.BackgroundTransparency = 1
        optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.Font = Enum.Font.Gotham
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionButton.TextSize = 14
        optionButton.ZIndex = 10
        
        -- Hiệu ứng hover
        optionButton.MouseEnter:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.3), {
                BackgroundTransparency = 0.9
            }):Play()
        end)
        
        optionButton.MouseLeave:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.3), {
                BackgroundTransparency = 1
            }):Play()
        end)
        
        -- Khi click vào option
        optionButton.MouseButton1Click:Connect(function()
            dropdownButton.Text = option
            itemsContainer.Visible = false
        end)
    end
    
    -- Hiệu ứng đóng mở dropdown
    local dropdownOpen = false
    dropdownButton.MouseButton1Click:Connect(function()
        dropdownOpen = not dropdownOpen
        itemsContainer.Visible = dropdownOpen
        
        if dropdownOpen then
            TweenService:Create(arrowIcon, TweenInfo.new(0.3), {
                Rotation = 180
            }):Play()
        else
            TweenService:Create(arrowIcon, TweenInfo.new(0.3), {
                Rotation = 0
            }):Play()
        end
    end)
    
    return dropdown, dropdownButton
end

-- Tạo hàm giúp tạo toggle switch
local function createToggleSwitch(parent, position, text)
    -- Container chính
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = "ToggleContainer"
    toggleContainer.Parent = parent
    toggleContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    toggleContainer.BackgroundTransparency = 0.5
    toggleContainer.Position = position
    toggleContainer.Size = UDim2.new(1, -10, 0, 40)
    
    -- Bo tròn
    local UICornerToggle = Instance.new("UICorner")
    UICornerToggle.CornerRadius = UDim.new(0, 8)
    UICornerToggle.Parent = toggleContainer
    
    -- Viền 
    local UIStrokeToggle = Instance.new("UIStroke")
    UIStrokeToggle.Parent = toggleContainer
    UIStrokeToggle.Color = Color3.fromRGB(0, 255, 255)
    UIStrokeToggle.Transparency = 0.8
    UIStrokeToggle.Thickness = 1
    
    -- Label
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "ToggleLabel"
    toggleLabel.Parent = toggleContainer
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Position = UDim2.new(0, 10, 0, 0)
    toggleLabel.Size = UDim2.new(1, -90, 1, 0)
    toggleLabel.Font = Enum.Font.GothamSemibold
    toggleLabel.Text = text
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.TextSize = 14
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Toggle Background
    local toggleBackground = Instance.new("Frame")
    toggleBackground.Name = "ToggleBackground"
    toggleBackground.Parent = toggleContainer
    toggleBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    toggleBackground.Position = UDim2.new(1, -80, 0.5, -15)
    toggleBackground.Size = UDim2.new(0, 70, 0, 30)
    
    -- Bo tròn
    local UICornerToggleBG = Instance.new("UICorner")
    UICornerToggleBG.CornerRadius = UDim.new(1, 0)
    UICornerToggleBG.Parent = toggleBackground
    
    -- Circle
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "ToggleCircle"
    toggleCircle.Parent = toggleBackground
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.Position = UDim2.new(0, 5, 0.5, -10)
    toggleCircle.Size = UDim2.new(0, 20, 0, 20)
    
    -- Bo tròn
    local UICornerCircle = Instance.new("UICorner")
    UICornerCircle.CornerRadius = UDim.new(1, 0)
    UICornerCircle.Parent = toggleCircle
    
    -- Tạo toggle button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Parent = toggleBackground
    toggleButton.BackgroundTransparency = 1
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.Text = ""
    
    -- Toggle state
    local toggleEnabled = false
    
    -- Toggle logic
    toggleButton.MouseButton1Click:Connect(function()
        toggleEnabled = not toggleEnabled
        
        if toggleEnabled then
            TweenService:Create(toggleBackground, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(0, 255, 255)
            }):Play()
            
            TweenService:Create(toggleCircle, TweenInfo.new(0.3), {
                Position = UDim2.new(1, -25, 0.5, -10)
            }):Play()
        else
            TweenService:Create(toggleBackground, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            }):Play()
            
            TweenService:Create(toggleCircle, TweenInfo.new(0.3), {
                Position = UDim2.new(0, 5, 0.5, -10)
            }):Play()
        end
    end)
    
    return toggleContainer, toggleButton, toggleEnabled
end

-- ===== TAB GENERAL =====
local GeneralTab = TabFrames["General"]

-- Island Dropdown
local islandOptions = {"Leveling City", "Grass Village", "Brum Island", "Faceheal Town", "Lucky Kingdom", "Nipon City", "Mori Town"}
local islandDropdown, islandButton = createDropdown(
    GeneralTab, 
    UDim2.new(0, 0, 0, 10), 
    UDim2.new(1, -10, 0, 40), 
    islandOptions, 
    "Select Island : Leveling City"
)

-- Enemy Dropdown
local enemyOptions = {"None", "Marine", "Prisoner", "Marine Officer", "Warden"}
local enemyDropdown, enemyButton = createDropdown(
    GeneralTab, 
    UDim2.new(0, 0, 0, 60), 
    UDim2.new(1, -10, 0, 40), 
    enemyOptions, 
    "Select Enemy : [ None ]"
)

-- Method Dropdown
local methodOptions = {"Running", "Tween", "Teleport"}
local methodDropdown, methodButton = createDropdown(
    GeneralTab, 
    UDim2.new(0, 0, 0, 110), 
    UDim2.new(1, -10, 0, 40), 
    methodOptions, 
    "Select Method : Running"
)

-- Result Dropdown
local resultOptions = {"Destroy", "Arise", "Collect"}
local resultDropdown, resultButton = createDropdown(
    GeneralTab, 
    UDim2.new(0, 0, 0, 160), 
    UDim2.new(1, -10, 0, 40), 
    resultOptions, 
    "Select Result : Destroy"
)

-- Auto Farm Enemy Toggle
local autoFarmToggle, autoFarmButton = createToggleSwitch(
    GeneralTab,
    UDim2.new(0, 0, 0, 210),
    "Auto Farm Enemy"
)

-- Send Pet To Enemy Toggle
local sendPetToggle, sendPetButton = createToggleSwitch(
    GeneralTab,
    UDim2.new(0, 0, 0, 260),
    "Send Pet To Enemy"
)

-- Set Canvas Size for General Tab
GeneralTab.CanvasSize = UDim2.new(0, 0, 0, 310)

-- ===== TAB DUNGEON =====
local DungeonTab = TabFrames["Dungeon"]

-- Header Info
local islandInfoLabel = Instance.new("TextLabel")
islandInfoLabel.Name = "IslandInfoLabel"
islandInfoLabel.Parent = DungeonTab
islandInfoLabel.BackgroundTransparency = 1
islandInfoLabel.Position = UDim2.new(0, 5, 0, 10)
islandInfoLabel.Size = UDim2.new(1, -10, 0, 30)
islandInfoLabel.Font = Enum.Font.GothamBold
islandInfoLabel.Text = "Island : N/a , Rank : N/a"
islandInfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
islandInfoLabel.TextSize = 16
islandInfoLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Rank Dropdown
local rankOptions = {"None", "Bronze", "Silver", "Gold", "Platinum"}
local rankDropdown, rankButton = createDropdown(
    DungeonTab, 
    UDim2.new(0, 0, 0, 50), 
    UDim2.new(1, -10, 0, 40), 
    rankOptions, 
    "Select Rank : [ None ]"
)

-- Map Dropdown
local mapOptions = {"None", "Ninja Village", "Pirate Island", "Hero City"}
local mapDropdown, mapButton = createDropdown(
    DungeonTab, 
    UDim2.new(0, 0, 0, 100), 
    UDim2.new(1, -10, 0, 40), 
    mapOptions, 
    "Select Map : [ None ]"
)

-- Auto Join Dungeon Toggle
local autoJoinToggle, autoJoinButton = createToggleSwitch(
    DungeonTab,
    UDim2.new(0, 0, 0, 150),
    "Auto Join Dungeon"
)

-- Separator
local separator1 = Instance.new("Frame")
separator1.Name = "Separator1"
separator1.Parent = DungeonTab
separator1.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
separator1.BackgroundTransparency = 0.8
separator1.Position = UDim2.new(0, 0, 0, 200)
separator1.Size = UDim2.new(1, -10, 0, 1)

-- Currency Dropdown
local currencyOptions = {"Gems", "Coins", "Tickets"}
local currencyDropdown, currencyButton = createDropdown(
    DungeonTab, 
    UDim2.new(0, 0, 0, 210), 
    UDim2.new(1, -10, 0, 40), 
    currencyOptions, 
    "Select Buy : Gems"
)

-- Auto Buy Ticket Toggle
local autoBuyToggle, autoBuyButton = createToggleSwitch(
    DungeonTab,
    UDim2.new(0, 0, 0, 260),
    "Auto Buy Ticket"
)

-- Separator
local separator2 = Instance.new("Frame")
separator2.Name = "Separator2"
separator2.Parent = DungeonTab
separator2.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
separator2.BackgroundTransparency = 0.8
separator2.Position = UDim2.new(0, 0, 0, 310)
separator2.Size = UDim2.new(1, -10, 0, 1)

-- Auto Farm Dungeon Toggle
local farmDungeonToggle, farmDungeonButton = createToggleSwitch(
    DungeonTab,
    UDim2.new(0, 0, 0, 320),
    "Auto Farm Dungeon"
)

-- Send Pet Toggle
local dungeonPetToggle, dungeonPetButton = createToggleSwitch(
    DungeonTab,
    UDim2.new(0, 0, 0, 370),
    "Send Pet To Enemy"
)

-- Result Dropdown
local dungeonResultOptions = {"Destroy", "Arise", "Collect"}
local dungeonResultDropdown, dungeonResultButton = createDropdown(
    DungeonTab, 
    UDim2.new(0, 0, 0, 420), 
    UDim2.new(1, -10, 0, 40), 
    dungeonResultOptions, 
    "Select Result : Destroy"
)

-- Set Canvas Size for Dungeon Tab
DungeonTab.CanvasSize = UDim2.new(0, 0, 0, 470)

-- ===== TAB JEJU ISLAND =====
local JejuTab = TabFrames["Jeju Island"]

-- Method Dropdown
local jejuMethodOptions = {"Running", "Tween", "Teleport"}
local jejuMethodDropdown, jejuMethodButton = createDropdown(
    JejuTab, 
    UDim2.new(0, 0, 0, 10), 
    UDim2.new(1, -10, 0, 40), 
    jejuMethodOptions, 
    "Select Method : Tween"
)

-- Kill Method Dropdown
local killMethodOptions = {"None", "Normal", "Skill"}
local killMethodDropdown, killMethodButton = createDropdown(
    JejuTab, 
    UDim2.new(0, 0, 0, 60), 
    UDim2.new(1, -10, 0, 40), 
    killMethodOptions, 
    "Select Method [Kill] : [ None ]"
)

-- Result Dropdown
local jejuResultOptions = {"Destroy", "Arise", "Collect"}
local jejuResultDropdown, jejuResultButton = createDropdown(
    JejuTab, 
    UDim2.new(0, 0, 0, 110), 
    UDim2.new(1, -10, 0, 40), 
    jejuResultOptions, 
    "Select Result : Arise"
)

-- Auto Farm Jeju Toggle
local autoFarmJejuToggle, autoFarmJejuButton = createToggleSwitch(
    JejuTab,
    UDim2.new(0, 0, 0, 160),
    "Auto Farm Jeju"
)

-- Send Pet To Enemy Toggle
local jejuPetToggle, jejuPetButton = createToggleSwitch(
    JejuTab,
    UDim2.new(0, 0, 0, 210),
    "Send Pet To Enemy"
)

-- Info Text
local infoLabel = Instance.new("TextLabel")
infoLabel.Name = "InfoLabel"
infoLabel.Parent = JejuTab
infoLabel.BackgroundTransparency = 1
infoLabel.Position = UDim2.new(0, 5, 0, 260)
infoLabel.Size = UDim2.new(1, -10, 0, 30)
infoLabel.Font = Enum.Font.GothamSemibold
infoLabel.Text = "Can use other func at same time"
infoLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
infoLabel.TextSize = 14
infoLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Set Canvas Size for Jeju Tab
JejuTab.CanvasSize = UDim2.new(0, 0, 0, 300)

-- ===== TAB EXTRA =====
local ExtraTab = TabFrames["Extra"]

-- Auto Attack Toggle
local autoAttackToggle, autoAttackButton = createToggleSwitch(
    ExtraTab,
    UDim2.new(0, 0, 0, 10),
    "Auto Attack (Send Pet, Click)"
)

-- Auto Take Result Toggle
local autoTakeToggle, autoTakeButton = createToggleSwitch(
    ExtraTab,
    UDim2.new(0, 0, 0, 60),
    "Auto Take Result (Use With Auto Attack Only)"
)

-- Result Dropdown
local attackResultOptions = {"Destroy", "Arise", "Collect"}
local attackResultDropdown, attackResultButton = createDropdown(
    ExtraTab, 
    UDim2.new(0, 0, 0, 110), 
    UDim2.new(1, -10, 0, 40), 
    attackResultOptions, 
    "Select Result : Arise"
)

-- Attack Type Dropdown
local attackTypeOptions = {"Animation", "Normal", "Special"}
local attackTypeDropdown, attackTypeButton = createDropdown(
    ExtraTab, 
    UDim2.new(0, 0, 0, 160), 
    UDim2.new(1, -10, 0, 40), 
    attackTypeOptions, 
    "Select Attack Type : Animation"
)

-- Separator
local separator3 = Instance.new("Frame")
separator3.Name = "Separator3"
separator3.Parent = ExtraTab
separator3.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
separator3.BackgroundTransparency = 0.8
separator3.Position = UDim2.new(0, 0, 0, 210)
separator3.Size = UDim2.new(1, -10, 0, 1)

-- Auto Upgrade Rank Toggle
local autoUpgradeToggle, autoUpgradeButton = createToggleSwitch(
    ExtraTab,
    UDim2.new(0, 0, 0, 220),
    "Auto Upgrade Rank"
)

-- Auto Find Mount Toggle
local autoMountToggle, autoMountButton = createToggleSwitch(
    ExtraTab,
    UDim2.new(0, 0, 0, 270),
    "Auto Find Mount"
)

-- Separator
local separator4 = Instance.new("Frame")
separator4.Name = "Separator4"
separator4.Parent = ExtraTab
separator4.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
separator4.BackgroundTransparency = 0.8
separator4.Position = UDim2.new(0, 0, 0, 320)
separator4.Size = UDim2.new(1, -10, 0, 1)

-- Dash No CD Toggle
local dashNoCDToggle, dashNoCDButton = createToggleSwitch(
    ExtraTab,
    UDim2.new(0, 0, 0, 330),
    "Dash No CD"
)

-- Set default to enabled with cyan color
TweenService:Create(dashNoCDToggle:FindFirstChild("ToggleBackground"), TweenInfo.new(0.3), {
    BackgroundColor3 = Color3.fromRGB(0, 255, 255)
}):Play()

TweenService:Create(dashNoCDToggle:FindFirstChild("ToggleBackground"):FindFirstChild("ToggleCircle"), TweenInfo.new(0.3), {
    Position = UDim2.new(1, -25, 0.5, -10)
}):Play()

-- Attack No CD Toggle
local attackNoCDToggle, attackNoCDButton = createToggleSwitch(
    ExtraTab,
    UDim2.new(0, 0, 0, 380),
    "Attack No CD (Just For Fun :D)"
)

-- Set Canvas Size for Extra Tab
ExtraTab.CanvasSize = UDim2.new(0, 0, 0, 430)

-- Chức năng tự động farm
local function setupAutoFarm()
    -- Mã logic cho tự động farm sẽ được thêm vào đây sau
    print("Auto Farm đã được thiết lập")
end

-- Kết nối chức năng với các nút
autoFarmButton.MouseButton1Click:Connect(setupAutoFarm)
autoJoinButton.MouseButton1Click:Connect(setupAutoFarm)
autoFarmJejuButton.MouseButton1Click:Connect(setupAutoFarm)
autoAttackButton.MouseButton1Click:Connect(setupAutoFarm)

-- Thay đổi giao diện/nội dung của GameTitle
GameTitle.Text = "Arise Crossover - Skyhub"

-- ===== TẠO TAB TELEPORT =====
-- Tạo container chứa các nút teleport
local TeleportUI = Instance.new("Frame")
TeleportUI.Name = "TeleportUI"
TeleportUI.Parent = AriseUI
TeleportUI.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TeleportUI.BackgroundTransparency = 0.2
TeleportUI.BorderSizePixel = 0
TeleportUI.Position = UDim2.new(0, 10, 0.2, 0)
TeleportUI.Size = UDim2.new(0, 300, 0, 420)
TeleportUI.Visible = false

-- Tạo hiệu ứng bo tròn cho UI teleport
local TeleportUICorner = Instance.new("UICorner")
TeleportUICorner.CornerRadius = UDim.new(0, 12)
TeleportUICorner.Parent = TeleportUI

-- Tạo viền
local TeleportUIStroke = Instance.new("UIStroke")
TeleportUIStroke.Parent = TeleportUI
TeleportUIStroke.Color = Color3.fromRGB(0, 255, 255)
TeleportUIStroke.Transparency = 0.7
TeleportUIStroke.Thickness = 1.5

-- Tạo header cho UI teleport
local TeleportHeader = Instance.new("Frame")
TeleportHeader.Name = "TeleportHeader"
TeleportHeader.Parent = TeleportUI
TeleportHeader.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
TeleportHeader.BackgroundTransparency = 0.3
TeleportHeader.BorderSizePixel = 0
TeleportHeader.Size = UDim2.new(1, 0, 0, 40)

-- Bo tròn cho header
local TeleportHeaderCorner = Instance.new("UICorner")
TeleportHeaderCorner.CornerRadius = UDim.new(0, 12)
TeleportHeaderCorner.Parent = TeleportHeader

-- Chỉ bo tròn phía trên cho header
local TeleportHeaderBottomFrame = Instance.new("Frame")
TeleportHeaderBottomFrame.Name = "TeleportHeaderBottomFrame"
TeleportHeaderBottomFrame.Parent = TeleportHeader
TeleportHeaderBottomFrame.BackgroundColor3 = TeleportHeader.BackgroundColor3
TeleportHeaderBottomFrame.BackgroundTransparency = TeleportHeader.BackgroundTransparency
TeleportHeaderBottomFrame.BorderSizePixel = 0
TeleportHeaderBottomFrame.Position = UDim2.new(0, 0, 1, -12)
TeleportHeaderBottomFrame.Size = UDim2.new(1, 0, 0, 12)

-- Tiêu đề Teleport
local TeleportTitle = Instance.new("TextLabel")
TeleportTitle.Name = "TeleportTitle"
TeleportTitle.Parent = TeleportHeader
TeleportTitle.BackgroundTransparency = 1
TeleportTitle.Position = UDim2.new(0, 50, 0, 0)
TeleportTitle.Size = UDim2.new(1, -100, 1, 0)
TeleportTitle.Font = Enum.Font.GothamBold
TeleportTitle.Text = "Teleport"
TeleportTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportTitle.TextSize = 18

-- Icon Teleport
local TeleportIcon = Instance.new("ImageLabel")
TeleportIcon.Name = "TeleportIcon"
TeleportIcon.Parent = TeleportHeader
TeleportIcon.BackgroundTransparency = 1
TeleportIcon.Position = UDim2.new(0, 10, 0.5, -15)
TeleportIcon.Size = UDim2.new(0, 30, 0, 30)
TeleportIcon.Image = "rbxassetid://7733920644" -- Thay bằng icon dịch chuyển
TeleportIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)

-- Nút đóng Teleport UI
local TeleportCloseButton = Instance.new("ImageButton")
TeleportCloseButton.Name = "TeleportCloseButton"
TeleportCloseButton.Parent = TeleportHeader
TeleportCloseButton.BackgroundTransparency = 1
TeleportCloseButton.Position = UDim2.new(1, -35, 0.5, -15)
TeleportCloseButton.Size = UDim2.new(0, 30, 0, 30)
TeleportCloseButton.Image = "rbxassetid://7734010488" -- X icon
TeleportCloseButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
TeleportCloseButton.ImageTransparency = 0.3

-- Container cho danh sách teleport
local TeleportList = Instance.new("ScrollingFrame")
TeleportList.Name = "TeleportList"
TeleportList.Parent = TeleportUI
TeleportList.BackgroundTransparency = 1
TeleportList.Position = UDim2.new(0, 0, 0, 50)
TeleportList.Size = UDim2.new(1, 0, 1, -60)
TeleportList.CanvasSize = UDim2.new(0, 0, 0, 400)
TeleportList.ScrollBarThickness = 4
TeleportList.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
TeleportList.ScrollBarImageTransparency = 0.5

-- Danh sách các địa điểm
local teleportLocations = {
    "Leveling City",
    "Grass Village",
    "Brum Island",
    "Faceheal Town",
    "Lucky Kingdom",
    "Nipon City",
    "Mori Town"
}

-- Hàm tạo nút teleport
local function createTeleportButton(text, position)
    local teleportButton = Instance.new("TextButton")
    teleportButton.Name = text.."TeleportButton"
    teleportButton.Parent = TeleportList
    teleportButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    teleportButton.BackgroundTransparency = 0.5
    teleportButton.Position = position
    teleportButton.Size = UDim2.new(1, -20, 0, 50)
    teleportButton.Font = Enum.Font.GothamSemibold
    teleportButton.Text = "Teleport To " .. text
    teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportButton.TextSize = 16
    
    -- Bo tròn cho nút
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = teleportButton
    
    -- Viền cho nút
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Parent = teleportButton
    buttonStroke.Color = Color3.fromRGB(0, 255, 255)
    buttonStroke.Transparency = 0.8
    buttonStroke.Thickness = 1
    
    -- Hiệu ứng hover
    teleportButton.MouseEnter:Connect(function()
        TweenService:Create(teleportButton, TweenInfo.new(0.3), {
            BackgroundTransparency = 0.3
        }):Play()
    end)
    
    teleportButton.MouseLeave:Connect(function()
        TweenService:Create(teleportButton, TweenInfo.new(0.3), {
            BackgroundTransparency = 0.5
        }):Play()
    end)
    
    -- Hiệu ứng click
    teleportButton.MouseButton1Down:Connect(function()
        teleportButton.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
    end)
    
    teleportButton.MouseButton1Up:Connect(function()
        teleportButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        print("Teleporting to " .. text)
    end)
    
    return teleportButton
end

-- Tạo các nút teleport
for i, location in ipairs(teleportLocations) do
    createTeleportButton(location, UDim2.new(0, 10, 0, (i-1) * 60 + 10))
end

-- Tạo nút Teleport to AFKRewards ở dưới cùng
local afkRewardsButton = createTeleportButton("AFKRewards", UDim2.new(0, 10, 0, #teleportLocations * 60 + 20))
afkRewardsButton.BackgroundColor3 = Color3.fromRGB(60, 100, 200)

-- Cập nhật kích thước canvas
TeleportList.CanvasSize = UDim2.new(0, 0, 0, #teleportLocations * 60 + 90)

-- Nút mở UI Teleport trên sidebar
local TeleportTabButton = Instance.new("TextButton")
TeleportTabButton.Name = "TeleportTabButton"
TeleportTabButton.Parent = Sidebar
TeleportTabButton.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
TeleportTabButton.BackgroundTransparency = 0.8
TeleportTabButton.Position = UDim2.new(0, 10, 0, #tabList * 50 + 30)
TeleportTabButton.Size = UDim2.new(1, -20, 0, 40)
TeleportTabButton.Font = Enum.Font.GothamSemibold
TeleportTabButton.Text = "Teleport"
TeleportTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportTabButton.TextSize = 14

-- Bo tròn cho nút teleport
local TeleportTabButtonCorner = Instance.new("UICorner")
TeleportTabButtonCorner.CornerRadius = UDim.new(0, 10)
TeleportTabButtonCorner.Parent = TeleportTabButton

-- Thêm hiệu ứng hover cho nút teleport
applyButtonHoverEffect(TeleportTabButton)

-- Đóng/mở UI Teleport
TeleportTabButton.MouseButton1Click:Connect(function()
    TeleportUI.Visible = not TeleportUI.Visible
end)

TeleportCloseButton.MouseButton1Click:Connect(function()
    TeleportUI.Visible = false
end)

print("Arise Crossover UI đã được tải với các chức năng mới!")

-- Thêm nội dung cho tab Trang chủ
local HomeTab = TabFrames["Trang chủ"]

-- Banner trò chơi
local Banner = Instance.new("ImageLabel")
Banner.Name = "Banner"
Banner.Parent = HomeTab
Banner.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Banner.BackgroundTransparency = 0.5
Banner.Position = UDim2.new(0, 0, 0, 0)
Banner.Size = UDim2.new(1, 0, 0, 120)
Banner.Image = "rbxassetid://14513378650" -- Banner giả định
Banner.ScaleType = Enum.ScaleType.Crop

-- Bo tròn cho banner
local BannerCorner = Instance.new("UICorner")
BannerCorner.CornerRadius = UDim.new(0, 10)
BannerCorner.Parent = Banner

-- Tiêu đề chào mừng
local WelcomeTitle = Instance.new("TextLabel")
WelcomeTitle.Name = "WelcomeTitle"
WelcomeTitle.Parent = HomeTab
WelcomeTitle.BackgroundTransparency = 1
WelcomeTitle.Position = UDim2.new(0, 0, 0, 130)
WelcomeTitle.Size = UDim2.new(1, 0, 0, 50)
WelcomeTitle.Font = Enum.Font.GothamBold
WelcomeTitle.Text = "Chào mừng đến Arise Crossover"
WelcomeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
WelcomeTitle.TextSize = 24
WelcomeTitle.TextStrokeTransparency = 0.8

-- Mô tả
local Description = Instance.new("TextLabel")
Description.Name = "Description"
Description.Parent = HomeTab
Description.BackgroundTransparency = 1
Description.Position = UDim2.new(0, 0, 0, 180)
Description.Size = UDim2.new(1, 0, 0, 60)
Description.Font = Enum.Font.Gotham
Description.Text = "Điều khiển nhân vật của bạn, sử dụng chiêu thức đặc biệt và chiến đấu với người chơi khác trong thế giới của Arise Crossover."
Description.TextColor3 = Color3.fromRGB(230, 230, 230)
Description.TextSize = 16
Description.TextWrapped = true

-- Nút bắt đầu
local PlayButton = Instance.new("TextButton")
PlayButton.Name = "PlayButton"
PlayButton.Parent = HomeTab
PlayButton.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
PlayButton.BackgroundTransparency = 0.2
PlayButton.Position = UDim2.new(0.5, -100, 0, 260)
PlayButton.Size = UDim2.new(0, 200, 0, 50)
PlayButton.Font = Enum.Font.GothamBold
PlayButton.Text = "CHƠI NGAY"
PlayButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayButton.TextSize = 18

-- Bo tròn cho nút chơi
local PlayButtonCorner = Instance.new("UICorner")
PlayButtonCorner.CornerRadius = UDim.new(0, 10)
PlayButtonCorner.Parent = PlayButton

-- Hiệu ứng viền sáng cho nút chơi
local PlayButtonStroke = Instance.new("UIStroke")
PlayButtonStroke.Parent = PlayButton
PlayButtonStroke.Color = Color3.fromRGB(120, 170, 255)
PlayButtonStroke.Transparency = 0.5
PlayButtonStroke.Thickness = 2

-- Thêm nội dung cho tab Chiêu thức
local SkillTab = TabFrames["Chiêu thức"]

-- Tiêu đề chiêu thức
local SkillTitle = Instance.new("TextLabel")
SkillTitle.Name = "SkillTitle"
SkillTitle.Parent = SkillTab
SkillTitle.BackgroundTransparency = 1
SkillTitle.Position = UDim2.new(0, 0, 0, 0)
SkillTitle.Size = UDim2.new(1, 0, 0, 40)
SkillTitle.Font = Enum.Font.GothamBold
SkillTitle.Text = "Chiêu Thức Của Bạn"
SkillTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SkillTitle.TextSize = 20

-- Danh sách chiêu thức
local skills = {
    {name = "Đòn đánh thường", description = "Tấn công cơ bản, gây sát thương nhỏ.", cooldown = "0.5s"},
    {name = "Kỹ năng đặc biệt", description = "Tấn công phép thuật mạnh, gây sát thương khu vực.", cooldown = "5s"},
    {name = "Chiêu cuối", description = "Chiêu thức mạnh nhất, gây sát thương lớn cho tất cả kẻ địch.", cooldown = "30s"},
    {name = "Chiêu hỗ trợ", description = "Tăng tốc độ di chuyển và khả năng phòng thủ.", cooldown = "15s"}
}

-- Tạo UI cho từng chiêu thức
for i, skill in ipairs(skills) do
    local SkillFrame = Instance.new("Frame")
    SkillFrame.Name = "Skill"..i
    SkillFrame.Parent = SkillTab
    SkillFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    SkillFrame.BackgroundTransparency = 0.7
    SkillFrame.Position = UDim2.new(0, 0, 0, 50 + (i-1) * 90)
    SkillFrame.Size = UDim2.new(1, -10, 0, 80)

    -- Bo tròn cho frame kỹ năng
    local SkillFrameCorner = Instance.new("UICorner")
    SkillFrameCorner.CornerRadius = UDim.new(0, 10)
    SkillFrameCorner.Parent = SkillFrame

    -- Viền sáng cho frame kỹ năng
    local SkillFrameStroke = Instance.new("UIStroke")
    SkillFrameStroke.Parent = SkillFrame
    SkillFrameStroke.Color = Color3.fromRGB(100, 100, 255)
    SkillFrameStroke.Transparency = 0.7
    SkillFrameStroke.Thickness = 1.5

    -- Icon kỹ năng
    local SkillIcon = Instance.new("ImageLabel")
    SkillIcon.Name = "SkillIcon"
    SkillIcon.Parent = SkillFrame
    SkillIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    SkillIcon.BackgroundTransparency = 0.5
    SkillIcon.Position = UDim2.new(0, 10, 0.5, -30)
    SkillIcon.Size = UDim2.new(0, 60, 0, 60)
    SkillIcon.Image = "rbxassetid://14513390289" -- Thay bằng icon thực tế
    
    -- Bo tròn cho icon
    local SkillIconCorner = Instance.new("UICorner")
    SkillIconCorner.CornerRadius = UDim.new(0, 10)
    SkillIconCorner.Parent = SkillIcon

    -- Tên kỹ năng
    local SkillName = Instance.new("TextLabel")
    SkillName.Name = "SkillName"
    SkillName.Parent = SkillFrame
    SkillName.BackgroundTransparency = 1
    SkillName.Position = UDim2.new(0, 80, 0, 5)
    SkillName.Size = UDim2.new(1, -160, 0, 25)
    SkillName.Font = Enum.Font.GothamBold
    SkillName.Text = skill.name
    SkillName.TextColor3 = Color3.fromRGB(255, 255, 255)
    SkillName.TextSize = 16
    SkillName.TextXAlignment = Enum.TextXAlignment.Left

    -- Mô tả kỹ năng
    local SkillDescription = Instance.new("TextLabel")
    SkillDescription.Name = "SkillDescription"
    SkillDescription.Parent = SkillFrame
    SkillDescription.BackgroundTransparency = 1
    SkillDescription.Position = UDim2.new(0, 80, 0, 30)
    SkillDescription.Size = UDim2.new(1, -160, 0, 25)
    SkillDescription.Font = Enum.Font.Gotham
    SkillDescription.Text = skill.description
    SkillDescription.TextColor3 = Color3.fromRGB(200, 200, 200)
    SkillDescription.TextSize = 12
    SkillDescription.TextXAlignment = Enum.TextXAlignment.Left
    SkillDescription.TextWrapped = true

    -- Thời gian hồi chiêu
    local SkillCooldown = Instance.new("TextLabel")
    SkillCooldown.Name = "SkillCooldown"
    SkillCooldown.Parent = SkillFrame
    SkillCooldown.BackgroundTransparency = 1
    SkillCooldown.Position = UDim2.new(0, 80, 0, 55)
    SkillCooldown.Size = UDim2.new(0, 100, 0, 20)
    SkillCooldown.Font = Enum.Font.GothamBold
    SkillCooldown.Text = "Hồi chiêu: " .. skill.cooldown
    SkillCooldown.TextColor3 = Color3.fromRGB(150, 200, 255)
    SkillCooldown.TextSize = 12
    SkillCooldown.TextXAlignment = Enum.TextXAlignment.Left

    -- Nút kích hoạt kỹ năng
    local SkillButton = Instance.new("TextButton")
    SkillButton.Name = "SkillButton"
    SkillButton.Parent = SkillFrame
    SkillButton.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
    SkillButton.BackgroundTransparency = 0.3
    SkillButton.Position = UDim2.new(1, -70, 0.5, -15)
    SkillButton.Size = UDim2.new(0, 60, 0, 30)
    SkillButton.Font = Enum.Font.GothamBold
    SkillButton.Text = "TRANG BỊ"
    SkillButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SkillButton.TextSize = 12

    -- Bo tròn cho nút
    local SkillButtonCorner = Instance.new("UICorner")
    SkillButtonCorner.CornerRadius = UDim.new(0, 6)
    SkillButtonCorner.Parent = SkillButton
end

-- Cập nhật CanvasSize cho tab Skills
SkillTab.CanvasSize = UDim2.new(0, 0, 0, 50 + #skills * 90)

-- Thêm hiệu ứng đồ họa - hạt lấp lánh
local ParticleEmitter = Instance.new("Frame")
ParticleEmitter.Name = "ParticleEmitter"
ParticleEmitter.Parent = MainFrame
ParticleEmitter.BackgroundTransparency = 1
ParticleEmitter.Size = UDim2.new(1, 0, 1, 0)
ParticleEmitter.ZIndex = 0

-- Hàm tạo hạt lấp lánh
local function createParticle()
    local particle = Instance.new("Frame")
    particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    particle.BackgroundTransparency = math.random(40, 80)/100
    particle.BorderSizePixel = 0
    particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
    particle.Position = UDim2.new(math.random(0, 100)/100, 0, math.random(0, 100)/100, 0)
    particle.Parent = ParticleEmitter
    
    -- Bo tròn cho hạt
    local particleCorner = Instance.new("UICorner")
    particleCorner.CornerRadius = UDim.new(1, 0)
    particleCorner.Parent = particle
    
    -- Hiệu ứng di chuyển và mờ dần
    spawn(function()
        local duration = math.random(3, 8)
        local startTime = tick()
        
        while tick() - startTime < duration do
            local delta = tick() - startTime
            local progress = delta / duration
            
            particle.Position = UDim2.new(
                particle.Position.X.Scale,
                particle.Position.X.Offset,
                particle.Position.Y.Scale + (0.02 * delta/duration), 
                particle.Position.Y.Offset
            )
            
            particle.BackgroundTransparency = 0.4 + (0.6 * progress)
            
            RunService.Heartbeat:Wait()
        end
        
        particle:Destroy()
    end)
    
    return particle
end

-- Tạo hạt liên tục
spawn(function()
    while wait(0.3) do
        if MainFrame.Parent then
            createParticle()
        else
            break
        end
    end
end)

-- Hiệu ứng mở UI
MainFrame.Position = UDim2.new(0.5, -300, 1.5, 0)
BlurEffect.Size = 0

-- Tween mở UI
local openTween = TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local blurTween = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

TweenService:Create(MainFrame, openTween, {Position = UDim2.new(0.5, -300, 0.5, -200)}):Play()
TweenService:Create(BlurEffect, blurTween, {Size = 10}):Play()
TweenService:Create(BlurBackground, blurTween, {BackgroundTransparency = 0.7}):Play()

-- Hiệu ứng đóng UI
CloseButton.MouseButton1Click:Connect(function()
    local closeTween = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    local unblurTween = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    TweenService:Create(MainFrame, closeTween, {Position = UDim2.new(0.5, -300, 1.5, 0)}):Play()
    TweenService:Create(BlurEffect, unblurTween, {Size = 0}):Play()
    TweenService:Create(BlurBackground, unblurTween, {BackgroundTransparency = 1}):Play()
    
    wait(0.7)
    AriseUI:Destroy()
    BlurEffect:Destroy()
end)

-- Hiệu ứng thu nhỏ UI
local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    
    local sizeTween = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if minimized then
        TweenService:Create(MainFrame, sizeTween, {Size = UDim2.new(0, 600, 0, 40)}):Play()
        TweenService:Create(ContentContainer, sizeTween, {Visible = false}):Play()
    else
        TweenService:Create(MainFrame, sizeTween, {Size = UDim2.new(0, 600, 0, 400)}):Play()
        wait(0.2)
        ContentContainer.Visible = true
    end
end)

-- Hiệu ứng kéo thả UI
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Thêm hiệu ứng hover cho các nút
local function applyButtonHoverEffect(button)
    local originalTransparency = button.BackgroundTransparency
    local originalColor = button.BackgroundColor3
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.3), {
            BackgroundTransparency = originalTransparency - 0.2,
            BackgroundColor3 = Color3.new(
                math.min(originalColor.R + 0.1, 1),
                math.min(originalColor.G + 0.1, 1),
                math.min(originalColor.B + 0.1, 1)
            )
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.3), {
            BackgroundTransparency = originalTransparency,
            BackgroundColor3 = originalColor
        }):Play()
    end)
end

-- Áp dụng hiệu ứng cho nút Play
applyButtonHoverEffect(PlayButton)

-- Áp dụng hiệu ứng cho các tab button
for _, button in pairs(TabButtons) do
    applyButtonHoverEffect(button)
end
