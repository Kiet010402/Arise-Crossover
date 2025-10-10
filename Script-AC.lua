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

-- Đợi đến khi Fluent được tải hoàn tất
if not Fluent then
    warn("Không thể tải thư viện Fluent!")
    return
end

-- Hệ thống lưu trữ cấu hình
local ConfigSystem = {}
ConfigSystem.FileName = "HTHubALS_" .. game:GetService("Players").LocalPlayer.Name .. ".json"
ConfigSystem.DefaultConfig = {
    -- Auto Play Settings removed
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

-- Biến lưu trạng thái của tab Main (auto features removed)

-- Lấy tên người chơi
local playerName = game:GetService("Players").LocalPlayer.Name

-- Cấu hình UI
local Window = Fluent:CreateWindow({
    Title = "HT HUB | Anime Last Stand",
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
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "rbxassetid://90319448802378" })
-- Tạo Tab Macro
local MacroTab = Window:AddTab({ Title = "Macro", Icon = "rbxassetid://13311802307" })

-- Tab Joiner
-- Section Auto Play trong tab Joiner
local AutoPlaySection = JoinerTab:AddSection("Auto Play")

-- Settings tab configuration
local SettingsSection = SettingsTab:AddSection("Script Settings")

-- Macro helpers
local MacroSystem = {}
MacroSystem.BaseFolder = "HTHubALS_Macros"

local function ensureMacroFolder()
    pcall(function()
        if not isfolder(MacroSystem.BaseFolder) then
            makefolder(MacroSystem.BaseFolder)
        end
    end)
end

ensureMacroFolder()

local function listMacros()
    local names = {}
    local ok, files = pcall(function()
        return listfiles(MacroSystem.BaseFolder)
    end)
    if ok and files then
        for _, p in ipairs(files) do
            local name = string.match(p, "[^/\\]+$")
            if name then table.insert(names, name) end
        end
    end
    table.sort(names)
    return names
end

local function macroPath(name)
    return MacroSystem.BaseFolder .. "/" .. name
end

local selectedMacro = ConfigSystem.CurrentConfig.SelectedMacro or ""
local pendingMacroName = ""

-- Macro UI
local MacroSection = MacroTab:AddSection("Macro Recorder")

-- Dropdown select macro
local MacroDropdown = MacroSection:AddDropdown("MacroSelect", {
    Title = "Select Macro",
    Description = "Chọn file macro",
    Values = listMacros(),
    Default = selectedMacro ~= "" and selectedMacro or nil,
    Callback = function(val)
        selectedMacro = val
        ConfigSystem.CurrentConfig.SelectedMacro = val
        ConfigSystem.SaveConfig()
    end
})

-- Input macro name
MacroSection:AddInput("MacroNameInput", {
    Title = "Macro name",
    Default = "",
    Placeholder = "vd: my_macro.txt",
    Callback = function(val)
        pendingMacroName = tostring(val or "")
    end
})

-- Create macro button
MacroSection:AddButton({
    Title = "Create Macro",
    Description = "Tạo file macro .txt",
    Callback = function()
        local name = pendingMacroName ~= "" and pendingMacroName or ("macro_" .. os.time() .. ".txt")
        if not string.find(name, "%.") then name = name .. ".txt" end
        local path = macroPath(name)
        local ok, errMsg = pcall(function()
            ensureMacroFolder()
            if not isfile(path) then
                writefile(path, "-- New macro file\n")
            end
        end)
        if ok then
            selectedMacro = name
            ConfigSystem.CurrentConfig.SelectedMacro = name
            ConfigSystem.SaveConfig()
            pcall(function()
                MacroDropdown:SetValues(listMacros())
                MacroDropdown:SetValue(selectedMacro)
            end)
            print("Created macro:", name)
        else
            warn("Create macro failed:", errMsg)
        end
    end
})

-- Delete macro button
MacroSection:AddButton({
    Title = "Delete Macro",
    Description = "Xóa file macro đang chọn",
    Callback = function()
        if not selectedMacro or selectedMacro == "" then return end
        local path = macroPath(selectedMacro)
        local ok, errMsg = pcall(function()
            if isfile(path) then delfile(path) end
        end)
        if ok then
            print("Deleted macro:", selectedMacro)
            selectedMacro = ""
            ConfigSystem.CurrentConfig.SelectedMacro = ""
            ConfigSystem.SaveConfig()
            pcall(function()
                MacroDropdown:SetValues(listMacros())
                MacroDropdown:SetValue(nil)
            end)
        else
            warn("Delete macro failed:", errMsg)
        end
    end
})

-- Recorder state
local Recorder = {
    isRecording = false,
    hasStarted = false,
    pendingAction = nil,
    lastMoney = nil,
    moneyConn = nil,
    buffer = nil,
}

local function appendLine(line)
    if Recorder.buffer then
        Recorder.buffer = Recorder.buffer .. line .. "\n"
    end
end

-- Helpers for serialization
local function cfToStr(cf)
    if typeof and typeof(cf) == "CFrame" then
        local x, y, z = cf.Position.X, cf.Position.Y, cf.Position.Z
        local r00, r01, r02, r10, r11, r12, r20, r21, r22 = cf:GetComponents()
        return string.format("CFrame.new(%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f)", 
            x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22)
    end
    return tostring(cf)
end

local function isArray(tbl)
    local n = 0
    for k, _ in pairs(tbl) do
        if type(k) ~= "number" or k < 1 or math.floor(k) ~= k then
            return false
        end
        if k > n then n = k end
    end
    for i = 1, n do
        if tbl[i] == nil then return false end
    end
    return true, n
end

local function serialize(val, indent)
    indent = indent or 0
    local pad = string.rep(" ", indent)
    if type(val) == "table" then
        local arr, n = isArray(val)
        local parts = {"{"}
        if arr then
            for i = 1, n do
                local v = val[i]
                local valueStr
                if typeof and typeof(v) == "CFrame" then
                    valueStr = cfToStr(v)
                elseif type(v) == "table" then
                    valueStr = serialize(v, indent + 4)
                elseif type(v) == "string" then
                    valueStr = string.format("\"%s\"", v)
                else
                    valueStr = tostring(v)
                end
                table.insert(parts, string.format("\n%s    %s,", pad, valueStr))
            end
        else
            for k, v in pairs(val) do
                local key = tostring(k)
                local valueStr
                if typeof and typeof(v) == "CFrame" then
                    valueStr = cfToStr(v)
                elseif type(v) == "table" then
                    valueStr = serialize(v, indent + 4)
                elseif type(v) == "string" then
                    valueStr = string.format("\"%s\"", v)
                else
                    valueStr = tostring(v)
                end
                table.insert(parts, string.format("\n%s    %s = %s,", pad, key, valueStr))
            end
        end
        table.insert(parts, string.format("\n%s}", pad))
        return table.concat(parts)
    elseif type(val) == "string" then
        return string.format("\"%s\"", val)
    else
        return tostring(val)
    end
end

local function recordNow(remoteName, remoteType, args, noteMoney)
    if noteMoney and noteMoney > 0 then
        appendLine(string.format("--note money: %d", noteMoney))
    end
    local okSer, argsStr = pcall(function()
        return serialize(args)
    end)
    appendLine("--call: " .. remoteName)
    if okSer and argsStr then
        appendLine("local args = " .. argsStr)
    else
        appendLine("-- serialize error: " .. tostring(argsStr))
        appendLine("local args = {}")
    end
    if remoteType == "FireServer" then
        appendLine("game:GetService(\"ReplicatedStorage\"):WaitForChild(\"Remotes\"):WaitForChild(\"" .. remoteName .. "\"):FireServer(unpack(args))")
    else
        appendLine("game:GetService(\"ReplicatedStorage\"):WaitForChild(\"Remotes\"):WaitForChild(\"" .. remoteName .. "\"):InvokeServer(unpack(args))")
    end
end

-- Install namecall hook
local hookInstalled = false
local oldNamecall
local function installHookOnce()
    if hookInstalled then return end
    hookInstalled = true
    local ok, res = pcall(function()
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod and getnamecallmethod() or ""
            if Recorder.isRecording and (tostring(method) == "FireServer" or tostring(method) == "InvokeServer") then
                local args = {...}
                local remoteName = tostring(self and self.Name or "")
                local allowed = {
                    PlayerReady = true,
                    PlaceTower = true,
                    Upgrade = true,
                }
                if not allowed[remoteName] then
                    return oldNamecall(self, ...)
                end
                
                -- Start recording only after PlayerReady
                if not Recorder.hasStarted then
                    if remoteName ~= "PlayerReady" then
                        return oldNamecall(self, ...)
                    end
                    -- Setup money watcher
                    pcall(function()
                        local cash = game:GetService("Players").LocalPlayer:WaitForChild("Cash")
                        Recorder.lastMoney = tonumber(cash.Value)
                        if Recorder.moneyConn then Recorder.moneyConn:Disconnect() Recorder.moneyConn = nil end
                        Recorder.moneyConn = cash.Changed:Connect(function(newVal)
                            local current = tonumber(newVal)
                            if Recorder.isRecording and Recorder.hasStarted and type(current) == "number" and type(Recorder.lastMoney) == "number" then
                                if current < Recorder.lastMoney then
                                    local delta = Recorder.lastMoney - current
                                    local action = Recorder.pendingAction
                                    Recorder.pendingAction = nil
                                    if action then
                                        recordNow(action.remote, action.remoteType, action.args, delta)
                                    end
                                end
                                Recorder.lastMoney = current
                            end
                        end)
                    end)
                    Recorder.hasStarted = true
                    appendLine("--PlayerReady")
                    appendLine("game:GetService(\"ReplicatedStorage\"):WaitForChild(\"Remotes\"):WaitForChild(\"PlayerReady\"):FireServer()")
                    return oldNamecall(self, ...)
                end
                
                -- Queue money-gated actions
                if remoteName == "PlaceTower" or remoteName == "Upgrade" then
                    Recorder.pendingAction = { remote = remoteName, remoteType = tostring(method), args = args }
                end
            end
            return oldNamecall(self, ...)
        end)
    end)
    if not ok then
        warn("Failed to install hook:", res)
    end
end

-- Toggle record macro
MacroSection:AddToggle("RecordMacroToggle", {
    Title = "Record Macro",
    Description = "Ghi macro và tiền",
    Default = false,
    Callback = function(enabled)
        if enabled then
            installHookOnce()
            if not selectedMacro or selectedMacro == "" then
                selectedMacro = "macro_" .. os.time() .. ".txt"
                ConfigSystem.CurrentConfig.SelectedMacro = selectedMacro
                ConfigSystem.SaveConfig()
            end
            Recorder.isRecording = true
            Recorder.hasStarted = false
            Recorder.buffer = "-- Macro recorded by HT Hub ALS\n"
            print("Recording started ->", selectedMacro)
        else
            if Recorder.isRecording then
                Recorder.isRecording = false
                local path = macroPath(selectedMacro)
                local ok, errMsg = pcall(function()
                    writefile(path, Recorder.buffer or "-- empty macro\n")
                end)
                if ok then
                    print("Recording saved:", selectedMacro)
                    pcall(function()
                        MacroDropdown:SetValues(listMacros())
                        MacroDropdown:SetValue(selectedMacro)
                    end)
                else
                    warn("Save macro failed:", errMsg)
                end
                if Recorder.moneyConn then
                    Recorder.moneyConn:Disconnect()
                    Recorder.moneyConn = nil
                end
            end
        end
    end
})

-- Play macro with wave detection
local macroPlaying = false
local waveConnection = nil
MacroSection:AddToggle("PlayMacroToggle", {
    Title = "Play Macro",
    Description = "Bật/tắt phát macro (tự lặp khi wave = 1)",
    Default = false,
    Callback = function(isOn)
        if isOn then
            if not selectedMacro or selectedMacro == "" then
                warn("Chưa chọn macro để phát")
                return
            end
            local path = macroPath(selectedMacro)
            local ok, content = pcall(function()
                if isfile(path) then return readfile(path) end
                return nil
            end)
            if not (ok and content) then
                warn("Read macro failed")
                return
            end
            
            _G.__HT_MACRO_PLAYING = true
            macroPlaying = true
            
            -- Setup wave detection
            local waveObj = game:GetService("ReplicatedStorage"):WaitForChild("Wave", 10)
            if waveObj then
                waveConnection = waveObj.Changed:Connect(function(newVal)
                    if _G.__HT_MACRO_PLAYING and tonumber(newVal) == 1 then
                        print("Wave reset to 1, replaying macro...")
                        task.wait(0.5)
                        -- Replay macro
                        local runnerCode = table.concat({
                            "return function()\n",
                            tostring(content),
                            "\nend"
                        })
                        local loadOk, fnOrErr = pcall(function() return loadstring(runnerCode)() end)
                        if loadOk and type(fnOrErr) == "function" then
                            task.spawn(function()
                                local runOk, runErr = pcall(fnOrErr)
                                if not runOk then warn("Run macro error:", runErr) end
                            end)
                        end
                    end
                end)
            end
            
            -- Initial play
            local runnerCode = table.concat({
                "return function()\n",
                tostring(content),
                "\nend"
            })
            local loadOk, fnOrErr = pcall(function() return loadstring(runnerCode)() end)
            if loadOk and type(fnOrErr) == "function" then
                task.spawn(function()
                    local runOk, runErr = pcall(fnOrErr)
                    if not runOk then warn("Run macro error:", runErr) end
                end)
            else
                warn("Load macro error:", fnOrErr)
            end
        else
            _G.__HT_MACRO_PLAYING = false
            macroPlaying = false
            if waveConnection then
                waveConnection:Disconnect()
                waveConnection = nil
            end
            print("Macro stopped")
        end
    end
})

-- Integration with SaveManager
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Thay đổi cách lưu cấu hình để sử dụng tên người chơi
InterfaceManager:SetFolder("HTHubALS")
SaveManager:SetFolder("HTHubALS/" .. playerName)

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
    for _, tab in pairs({JoinerTab, SettingsTab}) do
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
            ImageButton.BackgroundColor3 = Color3.fromRGB(105,105,105)
            ImageButton.BackgroundTransparency = 0.8
            ImageButton.Position = UDim2.new(0.9,0,0.1,0)
            ImageButton.Size = UDim2.new(0,50,0,50)
            ImageButton.Image = "rbxassetid://90319448802378" -- Logo HT Hub
            ImageButton.Draggable = true
            ImageButton.Transparency = 0.2
            
            UICorner.CornerRadius = UDim.new(0,200)
            UICorner.Parent = ImageButton
            
            -- Khi click vào logo sẽ mở lại UI
            ImageButton.MouseButton1Click:Connect(function()
                game:GetService("VirtualInputManager"):SendKeyEvent(true,Enum.KeyCode.LeftControl,false,game)
            end)
        end
    end)
    
    if not success then
        warn("Lỗi khi tạo nút Logo UI: " .. tostring(errorMsg))
    end
end)

print("HT Hub Anime Last Stand Script đã tải thành công!")
print("Sử dụng Left Ctrl để thu nhỏ/mở rộng UI")
