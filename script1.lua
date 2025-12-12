local Players = game:GetService("Players")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

local SEARCH_AREAS = {
    game.Workspace,
    game.ReplicatedStorage,
    game.ServerStorage,
    game.StarterPack,
}

---------------------------------------------------------
-- GUI CREATION (Mobile Friendly)
---------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToolFinderGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Size = UDim2.new(0.45, 0, 0.55, 0)  -- Scales well on all screens
frame.Position = UDim2.new(0.5, 0, 0.48, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "Tool Finder"
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = frame

-- SEARCH BAR (Bigger for mobile)
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -30, 0, 45)
searchBox.Position = UDim2.new(0, 15, 0, 55)
searchBox.PlaceholderText = "Search tools..."
searchBox.Text = ""
searchBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
searchBox.TextColor3 = Color3.fromRGB(255,255,255)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 22
searchBox.Parent = frame
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 8)

-- TOOL LIST
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -120)
scroll.Position = UDim2.new(0, 10, 0, 105)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 8
scroll.BackgroundColor3 = Color3.fromRGB(30,30,30)
scroll.BorderSizePixel = 0
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.Name
layout.Parent = scroll

---------------------------------------------------------
-- TOOL SCANNING
---------------------------------------------------------
local function getAllTools()
    local found = {}

    for _, area in ipairs(SEARCH_AREAS) do
        for _, obj in ipairs(area:GetDescendants()) do
            if obj:IsA("Tool") then
                table.insert(found, obj)
            end
        end
    end

    return found
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
-- REFRESH LIST (with search)
---------------------------------------------------------
local function refreshList(search)
    search = string.lower(search or "")

    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, tool in ipairs(allTools) do
        if string.lower(tool.Name):find(search, 1, true) then
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -10, 0, 45) -- bigger for touch
            button.BackgroundColor3 = Color3.fromRGB(70,70,70)
            button.TextColor3 = Color3.fromRGB(255,255,255)
            button.Font = Enum.Font.GothamMedium
            button.TextSize = 22
            button.Text = tool.Name
            button.Parent = scroll

            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

            button.MouseButton1Click:Connect(function()
                equipTool(tool)
            end)
        end
    end

    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end

---------------------------------------------------------
-- INIT
---------------------------------------------------------
refreshList("")

---------------------------------------------------------
-- LIVE SEARCH
---------------------------------------------------------
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    refreshList(searchBox.Text)
end)

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    refreshList(searchBox.Text)
end)
