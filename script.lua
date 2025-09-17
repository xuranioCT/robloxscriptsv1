local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local UIS = game:GetService("UserInputService")
local runSpeed = 32 -- Increased speed
local normalSpeed = 16 -- Default speed
local running = false

-- Create a ScreenGui and Button
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 120, 0, 40)
button.Position = UDim2.new(0.5, -60, 0.9, 0)
button.Text = "Run"
button.Parent = screenGui

button.MouseButton1Click:Connect(function()
    running = not running
    if running then
        humanoid.WalkSpeed = runSpeed
        button.Text = "Stop Running"
    else
        humanoid.WalkSpeed = normalSpeed
        button.Text = "Run"
    end
end)

-- Reset speed if character respawns
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = normalSpeed
    running = false
    button.Text = "Run"
end)