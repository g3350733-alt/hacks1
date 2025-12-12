local Players = game:GetService("Players")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

---------------------------------------------------------
-- GUI
---------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimpleEquipGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Size = UDim2.new(0, 260, 0, 120)
frame.Position = UDim2.new(0.5, 0, 0.8, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Search bar
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -20, 0, 40)
textBox.Position = UDim2.new(0, 10, 0, 10)
textBox.PlaceholderText = "Enter tool name..."
textBox.Text = ""
textBox.ClearTextOnFocus = false
textBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
textBox.TextColor3 = Color3.fromRGB(255,255,255)
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 20
textBox.Parent = frame

Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 8)

-- Equip button
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.new(0, 10, 0, 65)
button.Text = "Equip"
button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Font = Enum.Font.GothamBold
button.TextSize = 20
button.Parent = frame

Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

---------------------------------------------------------
-- EQUIP FUNCTION
---------------------------------------------------------
local function equipByName(name)
    if not name or name == "" then
        warn("No tool name entered")
        return
    end

    local char = player.Character or player.CharacterAdded:Wait()
    local tool = backpack:FindFirstChild(name)

    if tool and tool:IsA("Tool") then
        tool.Parent = char
        print("Equipped:", name)
    else
        warn("Tool not found:", name)
    end
end

---------------------------------------------------------
-- BUTTON CLICK
---------------------------------------------------------
button.MouseButton1Click:Connect(function()
    equipByName(textBox.Text)
end)
