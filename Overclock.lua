local Players = game:GetService("Players")

local MESSAGE_TEXT = "Overclock here im the best hacker on Roblox muahahahahahahhahahaaa!"
local DISPLAY_TIME = 6 -- seconds

local function showMessage(player)
    -- Create ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "OverclockMessage"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    -- Create Frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.7, 0, 0.2, 0) -- width 70%, height 20%
    frame.Position = UDim2.new(0.15, 0, 0.4, 0) -- centered
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = frame

    -- TextLabel
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.Position = UDim2.new(0, 0, 0, 0)
    text.BackgroundTransparency = 1
    text.TextWrapped = true
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.TextColor3 = Color3.fromRGB(255, 255, 255) -- white text
    text.Text = MESSAGE_TEXT
    text.Parent = frame

    -- Auto-remove after DISPLAY_TIME
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
