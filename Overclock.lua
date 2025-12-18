local Players = game:GetService("Players")

local MESSAGE_TEXT = "Overclock here im the best hacker on roblox muahahahahahahhahahaaa!"
local DISPLAY_TIME = 6 -- seconds

local function showMessage(player)
    local gui = Instance.new("ScreenGui")
    gui.Name = "OverclockMessage"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.7, 0, 0.2, 0)
    frame.Position = UDim2.new(0.15, 0, 0.4, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = frame

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -20, 1, -20)
    text.Position = UDim2.new(0, 10, 0, 10)
    text.BackgroundTransparency = 1
    text.TextWrapped = true
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.TextColor3 = Color3.fromRGB(255, 80, 80)
    text.Text = MESSAGE_TEXT
    text.Parent = frame

    task.delay(DISPLAY_TIME, function()
        if gui then
            gui:Destroy()
        end
    end)
end

-- Show to players already in game
for _, player in ipairs(Players:GetPlayers()) do
    showMessage(player)
end

-- Show to players who join later
Players.PlayerAdded:Connect(showMessage)
