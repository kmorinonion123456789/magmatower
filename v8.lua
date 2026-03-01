local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- 設定
getgenv().ShiunSettings = {
    vfly = false,
    noclip = false,
    speedLevel = 1,
    baseSpeed = 50,
    magmaDisabled = true,
    nameEnabled = false,
    healthEnabled = false,
    language = "JP"
}

-- 座標設定
local IMAGE_BASE_COORDS = CFrame.new(72.0, 575.3, -2.3) -- 画像の座標
local OLD_BASE_COORDS = CFrame.new(766.0, 2022.1, -1149.5) -- 以前の基地座標
local GOAL_COORDINATES = CFrame.new(6.12, 1458.32, -29.12)

local Localization = {
    ["JP"] = {
        langBtn = "Language: 日本語",
        nameESP = "名前 ESP",
        healthESP = "体力 ESP",
        vfly = "V-Fly (飛行)",
        noclip = "Noclip (壁抜け)",
        speed = "スピード上昇",
        magma = "マグマ無効",
        frontBaseTP = "みんなの前 TPww (画像)",
        baseTP = "観戦不可座標 TP",
        goalTP = "ゴールへ TP",
        resetCam = "カメラリセット",
        devConsole = "デベロッパーコンソール",
        on = "ON",
        off = "OFF"
    },
    ["EN"] = {
        langBtn = "Language: English",
        nameESP = "Name ESP",
        healthESP = "Health ESP",
        vfly = "V-Fly",
        noclip = "Noclip",
        speed = "Speed Boost",
        magma = "Anti-Magma",
        frontBaseTP = "TP to Front Base",
        baseTP = "TP to Old Base",
        goalTP = "Teleport to Goal",
        resetCam = "Reset Camera",
        devConsole = "Dev Console",
        on = "ON",
        off = "OFF"
    }
}

-- GUI作成
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ShionHubV3_Final"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 250, 0, 440)
mainFrame.Position = UDim2.new(0, 50, 0.5, -220)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true 
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Text = "SHION HUB V3"
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

local minBtn = Instance.new("TextButton", mainFrame)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 5)
minBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local container = Instance.new("ScrollingFrame", mainFrame)
container.Size = UDim2.new(1, -10, 1, -50)
container.Position = UDim2.new(0, 5, 0, 45)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.ScrollBarThickness = 3
container.CanvasSize = UDim2.new(0, 0, 0, 0) -- 自動調整用

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
end)

local UI_Elements = {}

local function updateUILanguage()
    local lang = getgenv().ShiunSettings.language
    local data = Localization[lang]
    for key, element in pairs(UI_Elements) do
        local textBase = data[key] or key
        if element.Type == "Toggle" then
            local state = getgenv().ShiunSettings[element.SettingKey]
            element.Instance.Text = textBase .. " : " .. (state and data.on or data.off)
        elseif element.Type == "Speed" then
            element.Instance.Text = textBase .. " + (Lv: " .. getgenv().ShiunSettings.speedLevel .. ")"
        else
            element.Instance.Text = textBase
        end
    end
end

local function createButton(id, textKey, callback)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(0, 220, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    UI_Elements[id] = {Instance = btn, Type = "Button", Key = textKey}
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(id, textKey, settingKey)
    local btn = createButton(id, textKey, function()
        getgenv().ShiunSettings[settingKey] = not getgenv().ShiunSettings[settingKey]
        local state = getgenv().ShiunSettings[settingKey]
        UI_Elements[id].Instance.BackgroundColor3 = state and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(35, 35, 35)
        updateUILanguage()
    end)
    UI_Elements[id].Type = "Toggle"
    UI_Elements[id].SettingKey = settingKey
end

-- ボタン追加
createButton("langBtn", "langBtn", function()
    getgenv().ShiunSettings.language = (getgenv().ShiunSettings.language == "JP") and "EN" or "JP"
    updateUILanguage()
end)

createToggle("nameESP", "nameESP", "nameEnabled")
createToggle("healthESP", "healthESP", "healthEnabled")
createToggle("vfly", "vfly", "vfly")
createToggle("noclip", "noclip", "noclip")

createButton("speed", "speed", function()
    getgenv().ShiunSettings.speedLevel = (getgenv().ShiunSettings.speedLevel % 20) + 1
    updateUILanguage()
end)
UI_Elements["speed"].Type = "Speed"

createToggle("magma", "magma", "magmaDisabled")

-- 新規：画像座標へのTP
createButton("frontBaseTP", "frontBaseTP", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = IMAGE_BASE_COORDS
    end
end)

createButton("baseTP", "baseTP", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = OLD_BASE_COORDS
    end
end)

createButton("goalTP", "goalTP", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = GOAL_COORDINATES
    end
end)

createButton("resetCam", "resetCam", function() camera.CameraSubject = LocalPlayer.Character.Humanoid end)
createButton("devConsole", "devConsole", function() game:GetService("StarterGui"):SetCore("DevConsoleVisible", true) end)

updateUILanguage()

-- 最小化機能
local isMinimized = false
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    mainFrame:TweenSize(isMinimized and UDim2.new(0, 250, 0, 40) or UDim2.new(0, 250, 0, 440), "Out", "Quad", 0.3, true)
    minBtn.Text = isMinimized and "+" or "-"
    container.Visible = not isMinimized
end)

-- ESP / 飛行 / 壁抜け / マグマ無効のロジック (既存コードを維持)
local function applyESP(player)
    if player == LocalPlayer then return end
    local function setupChar(character)
        local hum = character:WaitForChild("Humanoid", 10)
        if not hum then return end
        local highlight = Instance.new("Highlight", character)
        local tag = Instance.new("BillboardGui", character)
        tag.Size = UDim2.new(0,100,0,40); tag.StudsOffset = Vector3.new(0,3,0); tag.AlwaysOnTop = true
        local nl = Instance.new("TextLabel", tag)
        nl.Size = UDim2.new(1,0,0.5,0); nl.BackgroundTransparency = 1; nl.TextColor3 = Color3.new(1,1,1); nl.Text = player.Name; nl.Font = "GothamBold"
        local hb = Instance.new("Frame", tag); hb.Name = "HealthBg"; hb.Size = UDim2.new(0.8,0,0.1,0); hb.Position = UDim2.new(0.1,0,0.7,0); hb.BackgroundColor3 = Color3.new(0,0,0)
        local hf = Instance.new("Frame", hb); hf.Size = UDim2.new(1,0,1,0); hf.BackgroundColor3 = Color3.new(0,1,0.5); hf.BorderSizePixel = 0
        local conn; conn = RunService.RenderStepped:Connect(function()
            if not character.Parent then conn:Disconnect() return end
            highlight.Enabled = (getgenv().ShiunSettings.nameEnabled or getgenv().ShiunSettings.healthEnabled)
            tag.Enabled = (getgenv().ShiunSettings.nameEnabled or getgenv().ShiunSettings.healthEnabled)
            nl.Visible = getgenv().ShiunSettings.nameEnabled
            hb.Visible = getgenv().ShiunSettings.healthEnabled
            hf.Size = UDim2.new(math.clamp(hum.Health/hum.MaxHealth, 0, 1), 0, 1, 0)
        end)
    end
    player.CharacterAdded:Connect(setupChar)
    if player.Character then setupChar(player.Character) end
end

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local hum = char.Humanoid
    
    if getgenv().ShiunSettings.vfly then
        local bv = root:FindFirstChild("ShiunBV") or Instance.new("BodyVelocity", root)
        bv.Name = "ShiunBV"; bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        local bg = root:FindFirstChild("ShiunBG") or Instance.new("BodyGyro", root)
        bg.Name = "ShiunBG"; bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.CFrame = camera.CFrame
        bv.Velocity = (hum.MoveDirection.Magnitude > 0) and (camera.CFrame.LookVector * (getgenv().ShiunSettings.speedLevel * getgenv().ShiunSettings.baseSpeed)) or Vector3.new(0,0,0)
    else
        if root:FindFirstChild("ShiunBV") then root.ShiunBV:Destroy() end
        if root:FindFirstChild("ShiunBG") then root.ShiunBG:Destroy() end
    end
    
    if getgenv().ShiunSettings.noclip then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if getgenv().ShiunSettings.magmaDisabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("magma") or obj.Name:lower():find("lava")) then
                obj.CanTouch = false
            end
        end
    end
end)

for _, p in ipairs(Players:GetPlayers()) do applyESP(p) end
Players.PlayerAdded:Connect(applyESP)
