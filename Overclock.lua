-- Full StarterPlayer LocalScript: Overclock message for all players
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

local MESSAGE_TEXT = "Overclock here im the best hacker on Roblox muahahahahahahhahahaaa!"
local DISPLAY_TIME = 6

-- 1️⃣ Create RemoteEvent if missing
local sendOverclockMessage = ReplicatedStorage:FindFirstChild("SendOverclockMessage")
if not sendOverclockMessage then
    sendOverclockMessage = Instance.new("RemoteEvent")
    sendOverclockMessage.Name = "SendOverclockMessage"
    sendOverclockMessage.Parent = ReplicatedStorage
end

-- 2️⃣ Server-side broadcasting (only run on server)
if RunService:IsServer() then
    local function broadcastMessage()
        for _, player in pairs(Players:GetPlayers()) do
            sendOverclockMessage:FireClient(player, MESSAGE_TEXT)
        end
    end

    -- Show to all current players
    broadcastMessage()

    -- Show to players who join later
    Players.PlayerAdded:Connect(function(player)
        sendOverclockMessage:FireClient(player, MESSAGE_TEXT)
    end)

    return -- stop server from running client code
end

-- 3️⃣ Client-side: display GUI
local function displayMessage(message)
    local gui = Instance.new("ScreenGui")
    gui.Name = "OverclockMessage"
    gui.ResetOnSpawn = false
    gui.Parent = localPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.7, 0, 0.2, 0)
    frame.Position = UDim2.new(0.15, 0, 0.4, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
    text.Font = Enum.Font.GothamBold
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.Text = message
    text.Parent = frame

    task.delay(DISPLAY_TIME, function()
        if gui then gui:Destroy() end
    end)
end

-- 4️⃣ Connect RemoteEvent to display GUI
sendOverclockMessage.OnClientEvent:Connect(displayMessage)
