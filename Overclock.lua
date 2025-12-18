-- Overclock flashy message (single StarterPlayerScript)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

local MESSAGE_TEXT = "Overclock here im the best hacker on Roblox muahahahahahahhahahaaa!"
local DISPLAY_TIME = 6

-- Create RemoteEvent if missing
local sendOverclockMessage = ReplicatedStorage:FindFirstChild("SendOverclockMessage")
if not sendOverclockMessage then
    sendOverclockMessage = Instance.new("RemoteEvent")
    sendOverclockMessage.Name = "SendOverclockMessage"
    sendOverclockMessage.Parent = ReplicatedStorage
end

-- SERVER-SIDE BROADCAST
if RunService:IsServer() then
    local function broadcastMessage()
        for _, player in pairs(Players:GetPlayers()) do
            sendOverclockMessage:FireClient(player, MESSAGE_TEXT)
        end
    end

    broadcastMessage()
    Players.PlayerAdded:Connect(function(player)
        sendOverclockMessage:FireClient(player, MESSAGE_TEXT)
    end)

    return
end

-- CLIENT-SIDE GUI DISPLAY
local function displayMessage(message)
    local gui = Instance.new("ScreenGui")
    gui.Name = "OverclockMessage"
    gui.ResetOnSpawn = false
    gui.Parent = localPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.7, 0, 0.2, 0)
    frame.Position = UDim2.new(0.15, 0, -0.25, 0) -- start off-screen top
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = frame

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.Position = UDim2.new(0, 0, 0, 0)
    text.BackgroundTransparency = 1
    text.TextWrapped = true
    text.TextScaled = true
    text.Font = Enum.Font.GothamBlack
    text.TextColor3 = Color3.fromRGB(255, 50, 50)
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    text.Text = message
    text.Parent = frame

    -- Slide in animation
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
    local tween = tweenService:Create(frame, tweenInfo, {Position = UDim2.new(0.15, 0, 0.4, 0)})
    tween:Play()

    -- Shake effect
    local elapsed = 0
    local shakeMagnitude = 5
    local runConnection
    runConnection = RunService.RenderStepped:Connect(function(dt)
        elapsed = elapsed + dt
        frame.Position = UDim2.new(0.15, math.sin(elapsed * 30) * shakeMagnitude, 0.4, 0)
    end)

    -- Remove GUI after DISPLAY_TIME
    task.delay(DISPLAY_TIME, function()
        if runConnection then runConnection:Disconnect() end
        if gui then
            gui:Destroy()
        end
    end)
end

sendOverclockMessage.OnClientEvent:Connect(displayMessage)
