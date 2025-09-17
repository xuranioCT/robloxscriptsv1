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

local tpPointButton = Instance.new("TextButton")
tpPointButton.Size = UDim2.new(0, 200, 0, 40)
tpPointButton.Position = UDim2.new(0, 10, 0, 50)
tpPointButton.Text = "TP Point x1000"
tpPointButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
tpPointButton.TextColor3 = Color3.new(1,1,0)
tpPointButton.Font = Enum.Font.GothamBold
tpPointButton.TextSize = 22
tpPointButton.Parent = mainFrame
tpPointButton.BorderSizePixel = 2
tpPointButton.AutoButtonColor = true
tpPointButton.ZIndex = 10
tpPointButton.BackgroundTransparency = 0.1
local tpCorner = Instance.new("UICorner", tpPointButton)
tpCorner.CornerRadius = UDim.new(0.5,0)
tpPointButton.Visible = true



-- Set/TP Point logic
local savedPoint = nil
setPointButton.MouseButton1Click:Connect(function()
    if character and character:FindFirstChild("HumanoidRootPart") then
        savedPoint = character.HumanoidRootPart.Position
        setPointButton.Text = "Punto Guardado"
        -- Mensaje visual
        local msg = Instance.new("TextLabel")
        msg.Size = UDim2.new(0, 180, 0, 30)
        msg.Position = UDim2.new(0.5, -90, 0.5, -70)
        msg.BackgroundTransparency = 0.3
        msg.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        msg.Text = "Set Point Successful!"
        msg.TextColor3 = Color3.new(1,1,1)
        msg.Font = Enum.Font.GothamBold
        msg.TextSize = 18
        msg.Parent = screenGui
        wait(1)
        msg:Destroy()
        setPointButton.Text = "Set Point"
    end
end)

tpPointButton.MouseButton1Click:Connect(function()
    if savedPoint and character and character:FindFirstChild("HumanoidRootPart") then
        for i = 1, 1000 do
            character.HumanoidRootPart.CFrame = CFrame.new(savedPoint)
        end
    end
end)

-- Minimize/maximize logic y arrastre
local minimized = false
local dragging = false
local dragStart, startPos
local UIS = game:GetService("UserInputService")

logoButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    setPointButton.Visible = not minimized
    tpPointButton.Visible = not minimized
    if minimized then
        mainFrame.Size = UDim2.new(0, 60, 0, 60)
    else
        mainFrame.Size = UDim2.new(0, 220, 0, 80)
    end
end)

mainFrame.MouseEnter:Connect(function()
    mainFrame.Active = true
end)

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = UIS:GetMouseLocation()
        startPos = mainFrame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UIS:GetMouseLocation()
        local delta = mousePos - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)


-- Actualizar referencias al respawnear
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
end)
