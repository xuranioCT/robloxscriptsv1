local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Variables de punto

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


-- Set Point button
local setPointButton = Instance.new("TextButton")
setPointButton.Size = UDim2.new(0, 90, 0, 30)
setPointButton.Position = UDim2.new(0, 70, 0, 15)
setPointButton.Text = "Set Point"
setPointButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
setPointButton.TextColor3 = Color3.new(1,1,1)
setPointButton.Font = Enum.Font.GothamBold
setPointButton.TextSize = 16
setPointButton.Parent = mainFrame
setPointButton.BorderSizePixel = 0
setPointButton.AutoButtonColor = true
setPointButton.ZIndex = 2
setPointButton.BackgroundTransparency = 0.2
setPointButton.UICorner = Instance.new("UICorner", setPointButton)
setPointButton.UICorner.CornerRadius = UDim.new(0.5,0)

-- TP Point button
local tpPointButton = Instance.new("TextButton")
tpPointButton.Size = UDim2.new(0, 90, 0, 30)
tpPointButton.Position = UDim2.new(0, 70, 0, 50)
tpPointButton.Text = "TP Point"
tpPointButton.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
tpPointButton.TextColor3 = Color3.new(1,1,1)
tpPointButton.Font = Enum.Font.GothamBold
tpPointButton.TextSize = 16
tpPointButton.Parent = mainFrame
tpPointButton.BorderSizePixel = 0
tpPointButton.AutoButtonColor = true
tpPointButton.ZIndex = 2
tpPointButton.BackgroundTransparency = 0.2
tpPointButton.UICorner = Instance.new("UICorner", tpPointButton)
tpPointButton.UICorner.CornerRadius = UDim.new(0.5,0)



-- Set/TP Point logic
local savedPoint = nil
setPointButton.MouseButton1Click:Connect(function()
    if character and character:FindFirstChild("HumanoidRootPart") then
        savedPoint = character.HumanoidRootPart.Position
        setPointButton.Text = "Punto Guardado"
        wait(1)
        setPointButton.Text = "Set Point"
    end
end)

tpPointButton.MouseButton1Click:Connect(function()
    if savedPoint and character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(savedPoint)
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


-- Actualizar referencias al respawnear
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
end)
