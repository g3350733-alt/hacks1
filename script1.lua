local Players = game:GetService("Players")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

-- SERVICES TO SEARCH
local SEARCH_AREAS = {
    game.Workspace,
    game.ReplicatedStorage,
    game.ServerStorage,
    game.StarterPack,
}

-- CREATE GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToolFinderGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 350)
frame.Position = UDim2.new(0, 20, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Tool Finder"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6
scroll.BackgroundColor3 = Color3.fromRGB(30,30,30)
scroll.BorderSizePixel = 0
scroll.Parent = frame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = scroll

--// FUNCTION: Scan game for tools
local function getAllTools()
    local foundTools = {}

    for _, container in ipairs(SEARCH_AREAS) do
        for _, obj in ipairs(container:GetDescendants()) do
            if obj:IsA("Tool") then
                table.insert(foundTools, obj)
            end
        end
    end

    return foundTools
end

--// FUNCTION: Equip a tool (clone if needed)
local function equipTool(tool)
    local char = player.Character or player.CharacterAdded:Wait()

    local toolToEquip

    -- If it's already in the backpack, use it
    local existing = backpack:FindFirstChild(tool.Name)
    if existing then
        toolToEquip = existing
    
    -- Otherwise clone it from the game
    elseif tool:IsDescendantOf(game) then
        toolToEquip = tool:Clone()
        toolToEquip.Parent = backpack
    else
        warn("Cannot access tool:", tool.Name)
        return
    end

    -- Equip it
    toolToEquip.Parent = char
    print("Equipped:", toolToEquip.Name)
end

--// FUNCTION: Build tool list GUI
local function refreshGUI()
    scroll:ClearAllChildren()

    local layout = listLayout
    layout.Parent = scroll

    local tools = getAllTools()

    for _, tool in ipairs(tools) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -10, 0, 30)
        button.BackgroundColor3 = Color3.fromRGB(60,60,60)
        button.TextColor3 = Color3.fromRGB(255,255,255)
        button.Text = tool.Name
        button.Parent = scroll

        button.MouseButton1Click:Connect(function()
            equipTool(tool)
        end)
    end

    scroll.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 10)
end

-- Build the GUI immediately
refreshGUI()

-- Optional: refresh automatically when character respawns
player.CharacterAdded:Connect(refreshGUI)
