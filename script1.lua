local Players = game:GetService("Players")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

-- SEARCH AREAS (add more if needed)
local SEARCH_AREAS = {
    game.Workspace,
    game.ReplicatedStorage,
    game.ServerStorage,
    game.StarterPack,
}

---------------------------------------------------------
-- GUI CREATION
---------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToolFinderGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 380)
frame.Position = UDim2.new(0, 20, 0.35, -175)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Tool Finder"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = frame

-- SEARCH BAR
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -20, 0, 30)
searchBox.Position = UDim2.new(0, 10, 0, 45)
searchBox.PlaceholderText = "Search tools..."
searchBox.Text = ""
searchBox.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
searchBox.TextColor3 = Color3.fromRGB(255,255,255)
searchBox.Font = Enum.Font.SourceSans
searchBox.TextSize = 20
searchBox.Parent = frame
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)

-- TOOL LIST AREA
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -90)
scroll.Position = UDim2.new(0, 5, 0, 80)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6
scroll.BackgroundColor3 = Color3.fromRGB(30,30,30)
scroll.BorderSizePixel = 0
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.Name
layout.Parent = scroll

---------------------------------------------------------
-- SCAN FOR TOOLS
---------------------------------------------------------
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

local allTools = getAllTools()

---------------------------------------------------------
-- EQUIP TOOL
---------------------------------------------------------
local function equipTool(tool)
    local char = player.Character or player.CharacterAdded:Wait()

    local toolToEquip = backpack:FindFirstChild(tool.Name)
    if not toolToEquip then
        toolToEquip = tool:Clone()
        toolToEquip.Parent = backpack
    end

    toolToEquip.Parent = char
end

---------------------------------------------------------
-- BUILD TOOL LIST WITH FILTERING
---------------------------------------------------------
local function refreshList(search)
    search = string.lower(search or "")

    -- Clear previous buttons
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, tool in ipairs(allTools) do
        local toolName = string.lower(tool.Name)

        -- Filter by search
        if toolName:find(search, 1, true) then
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -10, 0, 30)
            button.BackgroundColor3 = Color3.fromRGB(60,60,60)
            button.TextColor3 = Color3.fromRGB(255,255,255)
            button.Font = Enum.Font.SourceSans
            button.TextSize = 20
            button.Text = tool.Name
            button.Parent = scroll

            button.MouseButton1Click:Connect(function()
                equipTool(tool)
            end)
        end
    end

    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end

---------------------------------------------------------
-- INITIAL LOAD
---------------------------------------------------------
refreshList("")

---------------------------------------------------------
-- SEARCH BAR UPDATES LIST LIVE
---------------------------------------------------------
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    refreshList(searchBox.Text)
end)

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    refreshList(searchBox.Text)
end)
