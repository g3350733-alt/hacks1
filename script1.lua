-- StarterPlayerScripts LocalScript
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local backpack = player:WaitForChild("Backpack")

-- GUI Creation
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DevToolsGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.4, 0, 0.6, 0)
frame.Position = UDim2.new(0.3, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- UI Layout
local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0.02,0)
uiList.FillDirection = Enum.FillDirection.Vertical
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiList.VerticalAlignment = Enum.VerticalAlignment.Top
uiList.Parent = frame

-- Button Creator
local function createButton(text, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.9, 0, 0, 50)
	button.Text = text
	button.BackgroundColor3 = Color3.fromRGB(40,120,40)
	button.TextColor3 = Color3.new(1,1,1)
	button.Font = Enum.Font.SourceSansBold
	button.TextScaled = true
	button.Parent = frame
	button.MouseButton1Click:Connect(callback)
	return button
end

-- Slider Creator
local function createSlider(min,max,default,callback)
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Size = UDim2.new(0.9,0,0,60)
	sliderFrame.BackgroundColor3 = Color3.fromRGB(70,70,70)
	sliderFrame.Parent = frame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,0,0.4,0)
	label.BackgroundTransparency = 1
	label.Text = "Speed: "..default
	label.TextColor3 = Color3.new(1,1,1)
	label.TextScaled = true
	label.Parent = sliderFrame

	local slider = Instance.new("TextButton")
	slider.Size = UDim2.new(1,0,0.6,0)
	slider.Position = UDim2.new(0,0,0.4,0)
	slider.BackgroundColor3 = Color3.fromRGB(100,100,100)
	slider.Text = ""
	slider.Parent = sliderFrame

	local dragging = false
	slider.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)
	slider.InputEnded:Connect(function(input)
		dragging = false
	end)
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local pos = input.Position.X - slider.AbsolutePosition.X
			pos = math.clamp(pos,0,slider.AbsoluteSize.X)
			local val = math.floor(min + (pos/slider.AbsoluteSize.X)*(max-min))
			callback(val)
			label.Text = "Speed: "..val
		end
	end)
	callback(default)
	return sliderFrame
end

--================= FUNCTIONS =================

-- Get All Tools
local function giveTools()
	local containers = {game.Workspace, game.ReplicatedStorage, game.ServerStorage}
	for _, container in ipairs(containers) do
		for _, obj in ipairs(container:GetDescendants()) do
			if obj:IsA("Tool") then
				local clone = obj:Clone()
				clone.Parent = backpack
			end
		end
	end
end

-- Fly
local flying = false
local flySpeed = 50
local hrp = char:WaitForChild("HumanoidRootPart")

local function startFly()
	flying = true
	while flying and hrp.Parent do
		task.wait()
		local move = player:GetMouse()
		local direction = (move.Hit.Position - hrp.Position)
		direction = Vector3.new(direction.X,0,direction.Z).Unit
		if direction.Magnitude > 0 then
			hrp.Velocity = direction * flySpeed
		else
			hrp.Velocity = Vector3.new(0,0,0)
		end
	end
end

local function stopFly()
	flying = false
	hrp.Velocity = Vector3.new(0,0,0)
end

-- Noclip
local noclip = false
game:GetService("RunService").Stepped:Connect(function()
	if noclip and char then
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Speed
local humanoid = char:WaitForChild("Humanoid")
local function setSpeed(val)
	humanoid.WalkSpeed = val
end

--================= BUTTONS =================

createButton("Get All Tools", giveTools)

local flyButton
flyButton = createButton("Fly OFF", function()
	if flying then
		stopFly()
		flyButton.Text = "Fly OFF"
	else
		startFly()
		flyButton.Text = "Fly ON"
	end
end)

local noclipButton
noclipButton = createButton("Noclip OFF", function()
	noclip = not noclip
	noclipButton.Text = noclip and "Noclip ON" or "Noclip OFF"
end)

createSlider(16,200,16,setSpeed) -- Default Roblox WalkSpeed 16

