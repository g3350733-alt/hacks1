-- Fully self-contained chat system
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Create RemoteEvent if it doesn't exist
local sendMessageEvent = ReplicatedStorage:FindFirstChild("SendMessageEvent")
if not sendMessageEvent then
    sendMessageEvent = Instance.new("RemoteEvent")
    sendMessageEvent.Name = "SendMessageEvent"
    sendMessageEvent.Parent = ReplicatedStorage
end

-- Only the server should handle broadcasting
if game:GetService("RunService"):IsServer() then
    sendMessageEvent.OnServerEvent:Connect(function(plr, msg)
        for _, p in pairs(Players:GetPlayers()) do
            sendMessageEvent:FireClient(p, plr.Name .. ": " .. msg)
        end
    end)
    return
end

-- CLIENT SIDE BELOW --

-- GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChatSystem"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0, 20, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -10, 1, -50)
scrollingFrame.Position = UDim2.new(0, 5, 0, 5)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.Parent = frame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = scrollingFrame
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 5)

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -10, 0, 30)
textBox.Position = UDim2.new(0, 5, 1, -35)
textBox.PlaceholderText = "Type a message..."
textBox.ClearTextOnFocus = false
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.BorderSizePixel = 0
textBox.Parent = frame

-- Function to display message
local function displayMessage(msg)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = msg
    label.Parent = scrollingFrame

    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
    scrollingFrame.CanvasPosition = Vector2.new(0, scrollingFrame.CanvasSize.Y.Offset) -- auto-scroll
end

-- Receive messages from server
sendMessageEvent.OnClientEvent:Connect(displayMessage)

-- Send message on Enter
textBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and textBox.Text ~= "" then
        sendMessageEvent:FireServer(textBox.Text)
        textBox.Text = ""
    end
end)
