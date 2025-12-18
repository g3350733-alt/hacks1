-- ADMIN / TEST GUI
-- FOR YOUR OWN GAME ONLY

local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")
local player = Players.LocalPlayer

-- ===== GUI SETUP =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdminGUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.fromScale(0.3, 0.45)
Frame.Position = UDim2.fromScale(0.05, 0.3)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)

local UIList = Instance.new("UIListLayout", Frame)
UIList.Padding = UDim.new(0, 8)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ===== BUTTON CREATOR =====
local function makeButton(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.fromScale(0.95, 0.12)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.Parent = Frame

	local c = Instance.new("UICorner", btn)
	c.CornerRadius = UDim.new(0, 8)

	return btn
end

-- ===== BUTTONS =====
local invisBtn = makeButton("Toggle Invisibility")
local noclipBtn = makeButton("Toggle No Hitbox")
local godBtn = makeButton("Toggle God Mode")
local speedBtn = makeButton("Set WalkSpeed (50)")
local toolsBtn = makeButton("Give All Tools (StarterPlayerScripts)")

-- ===== CHARACTER =====
local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

-- ===== INVISIBILITY =====
local invisible = false
invisBtn.MouseButton1Click:Connect(function()
	invisible = not invisible
	for _, v in pairs(getChar():GetDescendants()) do
		if v:IsA("BasePart") then
			v.Transparency = invisible and 1 or 0
			v.LocalTransparencyModifier = v.Transparency
		end
	end
end)

-- ===== NO HITBOX =====
local noclip = false
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	for _, v in pairs(getChar():GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = not noclip
		end
	end
end)

-- ===== GOD MODE =====
local god = false
godBtn.MouseButton1Click:Connect(function()
	local hum = getChar():FindFirstChildOfClass("Humanoid")
	if hum then
		god = not god
		if god then
			hum.MaxHealth = math.huge
			hum.Health = hum.MaxHealth
		else
			hum.MaxHealth = 100
			hum.Health = 100
		end
	end
end)

-- ===== WALKSPEED =====
speedBtn.MouseButton1Click:Connect(function()
	local hum = getChar():FindFirstChildOfClass("Humanoid")
	if hum then
		hum.WalkSpeed = 50
	end
end)

-- ===== GIVE ALL TOOLS FROM STARTERPLAYERSCRIPTS =====
toolsBtn.MouseButton1Click:Connect(function()
	local scriptsFolder = StarterPlayer:WaitForChild("StarterPlayerScripts")

	for _, obj in ipairs(scriptsFolder:GetDescendants()) do
		if obj:IsA("Tool") then
			-- Prevent duplicates
			if not player.Backpack:FindFirstChild(obj.Name) then
				obj:Clone().Parent = player.Backpack
			end
		end
	end
end)
