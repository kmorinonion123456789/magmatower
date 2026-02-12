local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")


local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MagmaBypassUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local AlertFrame = Instance.new("Frame")
AlertFrame.Name = "AlertFrame"
AlertFrame.Parent = ScreenGui
AlertFrame.Size = UDim2.new(1, 0, 1, 0) -- 画面全体
AlertFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AlertFrame.BackgroundTransparency = 0.5
AlertFrame.Visible = true 
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
CloseAlertButton.Name = "CloseAlertButton"
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
    local character = Player.Character
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
