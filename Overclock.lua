-- LocalScript (e.g., inside StarterGui or StarterPlayer)

-- Example 1: Basic local loadstring
local codeString = "print('This is a local message!')"
local success, func = loadstring(codeString)

if success then
    func() -- Executes the code string on the client
else
    warn("Error loading string:", func) -- 'func' will contain the error message
end

-- Example 2: Loading a local function to show a message
local messageCode = [[
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    local frame = playerGui:WaitForChild("ScreenGui"):WaitForChild("MessageFrame")
    frame.TextLabel.Text = "Welcome, Player!"
]]

local loadMessage, err = loadstring(messageCode)
if loadMessage then
    loadMessage()
end
