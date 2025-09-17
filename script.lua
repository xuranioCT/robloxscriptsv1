local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local runSpeed = 32
local normalSpeed = 16
local running = false

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Main frame (centered)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 80)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -40)
mainFrame.BackgroundTransparency = 1
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = false -- Usaremos lógica personalizada para arrastrar

-- Circular logo button (minimize/maximize)
local logoButton = Instance.new("ImageButton")
logoButton.Size = UDim2.new(0, 60, 0, 60)
logoButton.Position = UDim2.new(0, 0, 0, 10)
logoButton.BackgroundTransparency = 1
logoButton.Image = "rbxassetid://13762329877" -- Puedes cambiar el assetId por tu logo
logoButton.Parent = mainFrame

-- Run button (circular)
local runButton = Instance.new("TextButton")
runButton.Size = UDim2.new(0, 60, 0, 60)
runButton.Position = UDim2.new(0, 70, 0, 10)
runButton.Text = "Run"
runButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
runButton.TextColor3 = Color3.new(1,1,1)
runButton.Font = Enum.Font.GothamBold
runButton.TextSize = 18
runButton.Parent = mainFrame
runButton.BorderSizePixel = 0
runButton.AutoButtonColor = true
runButton.ClipsDescendants = true
runButton.ZIndex = 2
runButton.BackgroundTransparency = 0.2
runButton.AnchorPoint = Vector2.new(0,0)
runButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
runButton.UICorner = Instance.new("UICorner", runButton)
runButton.UICorner.CornerRadius = UDim.new(1,0)

-- Speed percent bar
local speedBar = Instance.new("Frame")
speedBar.Size = UDim2.new(0, 70, 0, 12)
speedBar.Position = UDim2.new(0, 140, 0, 24)
speedBar.BackgroundColor3 = Color3.fromRGB(200,200,200)
speedBar.Parent = mainFrame
speedBar.BorderSizePixel = 0
speedBar.UICorner = Instance.new("UICorner", speedBar)
speedBar.UICorner.CornerRadius = UDim.new(0.5,0)

local fillBar = Instance.new("Frame")
fillBar.Size = UDim2.new((runSpeed-normalSpeed)/84, 0, 1, 0) -- 100 max speed
fillBar.Position = UDim2.new(0,0,0,0)
fillBar.BackgroundColor3 = Color3.fromRGB(0,170,255)
fillBar.Parent = speedBar
fillBar.BorderSizePixel = 0
fillBar.UICorner = Instance.new("UICorner", fillBar)
fillBar.UICorner.CornerRadius = UDim.new(0.5,0)

local percentLabel = Instance.new("TextLabel")
percentLabel.Size = UDim2.new(0, 70, 0, 16)
percentLabel.Position = UDim2.new(0, 140, 0, 40)
percentLabel.BackgroundTransparency = 1
percentLabel.Text = "Velocidad: " .. math.floor((runSpeed-normalSpeed)/84*100) .. "%"
percentLabel.TextColor3 = Color3.new(1,1,1)
percentLabel.Font = Enum.Font.Gotham
percentLabel.TextSize = 14
percentLabel.Parent = mainFrame

-- Slider to change speed
local slider = Instance.new("TextButton")
slider.Size = UDim2.new(0, 70, 0, 12)
slider.Position = UDim2.new(0, 140, 0, 24)
slider.BackgroundTransparency = 1
slider.Text = ""
slider.Parent = mainFrame
slider.ZIndex = 3

local maxSpeed = 100
local minSpeed = normalSpeed

slider.MouseButton1Down:Connect(function(x, y)
    local mouse = game:GetService("Players").LocalPlayer:GetMouse()
    local conn
    conn = mouse.Move:Connect(function()
        local relX = math.clamp(mouse.X - speedBar.AbsolutePosition.X, 0, speedBar.AbsoluteSize.X)
        local percent = relX / speedBar.AbsoluteSize.X
        runSpeed = math.floor(minSpeed + percent * (maxSpeed-minSpeed))
        fillBar.Size = UDim2.new(percent, 0, 1, 0)
        percentLabel.Text = "Velocidad: " .. math.floor(percent*100) .. "%"
        if running then
            humanoid.WalkSpeed = runSpeed
        end
    end)
    mouse.Button1Up:Connect(function()
        if conn then conn:Disconnect() end
    end)
end)

-- Run button logic (bypass humanoid speed limit)
runButton.MouseButton1Click:Connect(function()
    running = not running
    if running then
        humanoid:SetAttribute("WalkSpeed", runSpeed)
        humanoid.WalkSpeed = runSpeed
        runButton.Text = "Stop"
    else
        humanoid:SetAttribute("WalkSpeed", normalSpeed)
        humanoid.WalkSpeed = normalSpeed
        runButton.Text = "Run"
    end
end)

-- Minimize/maximize logic y arrastre
local minimized = false
local dragging = false
local dragInput, dragStart, startPos

logoButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, v in ipairs(mainFrame:GetChildren()) do
        if v ~= logoButton then
            v.Visible = not minimized
        end
    end
    if minimized then
        mainFrame.Size = UDim2.new(0, 60, 0, 60)
    else
        mainFrame.Size = UDim2.new(0, 220, 0, 80)
    end
end)

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Reset speed if character respawns
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = normalSpeed
    running = false
    runButton.Text = "Run"
end)
