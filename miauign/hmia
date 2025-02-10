local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Create a ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Circle size and position adjustments
local circleSize = 150 -- Increased size of the circle
local offsetX = 70 -- Move the circle a little bit to the right (adjustable)
local offsetY = 40 -- Move the circle a little bit down (adjustable)

-- Create the outline frame (transparent circle)
local outline = Instance.new("Frame")
outline.Size = UDim2.new(0, circleSize, 0, circleSize) -- Set size based on circleSize variable
outline.Position = UDim2.new(0.5, -circleSize / 2 + offsetX, 0.5, -circleSize / 2 + offsetY) -- Center of the screen with offset
outline.BackgroundColor3 = Color3.new(1, 0, 0) -- Outline color (adjustable)
outline.BackgroundTransparency = 1 -- Fully transparent background (no color inside the circle)
outline.AnchorPoint = Vector2.new(0.5, 0.5) -- Anchor point for centering
outline.BorderSizePixel = 0 -- No border for the outline itself
outline.Parent = screenGui

-- Optional: Make the outline round
local function makeCircle(frame)
    frame.ClipsDescendants = true
    local cornerRadius = Instance.new("UICorner")
    cornerRadius.CornerRadius = UDim.new(0.5, 0) -- Makes the frame round
    cornerRadius.Parent = frame
end

makeCircle(outline)

-- Create a border for the outline (highlighted)
local border = Instance.new("Frame")
border.Size = UDim2.new(0, circleSize, 0, circleSize) -- Set size based on circleSize variable
border.Position = UDim2.new(0.5, -circleSize / 2 + offsetX, 0.5, -circleSize / 2 + offsetY) -- Center of the screen with offset
border.BackgroundColor3 = Color3.new(0, 0, 0) -- Black border color
border.BackgroundTransparency = 1 -- Fully transparent background in the middle
border.AnchorPoint = Vector2.new(0.5, 0.5) -- Anchor point for centering
border.BorderSizePixel = 0 -- No border for the outline
border.Parent = screenGui

-- Make the border round
makeCircle(border)

-- Add a bold black glowing effect (UIStroke)
local uiStroke = Instance.new("UIStroke")
uiStroke.Parent = border
uiStroke.Thickness = 2  -- Reduced thickness to half for a thinner border
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Color = Color3.fromRGB(0, 0, 0)  -- Solid black color for the border
uiStroke.Transparency = 0  -- Set transparency to 0 for solid black color
uiStroke.Enabled = true

-- Aimbot state
local aimbotEnabled = false -- Variable to track aimbot state

-- Function to find the nearest player's head
local function getNearestPlayerHead()
    local nearestPlayer = nil
    local nearestDistance = math.huge -- Start with a very large number

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local distance = (head.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude

            if distance < nearestDistance and distance <= 200 then -- Adjust 200 to your desired detection range
                nearestDistance = distance
                nearestPlayer = player
            end
        end
    end

    return nearestPlayer and nearestPlayer.Character and nearestPlayer.Character.Head
end

-- Function to check if a player's head is within the FOV circle
local function isHeadInFOV(headPosition)
    local screenPosition, onScreen = Camera:WorldToScreenPoint(headPosition)
    if onScreen then
        local circleCenter = Vector2.new(screenGui.AbsoluteSize.X / 2, screenGui.AbsoluteSize.Y / 2)
        local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - circleCenter).Magnitude
        return distance <= (outline.Size.X.Offset / 2) -- Check if within radius based on updated circle size
    end
    return false
end

-- Function to lock the camera on the nearest player's head
local function lockOnNearestPlayerHead()
    if not aimbotEnabled then return end -- Exit if aimbot is not enabled

    local targetHead = getNearestPlayerHead()

    if targetHead and isHeadInFOV(targetHead.Position) then
        -- Set the camera to look at the target head
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
    end
end

-- Function to toggle aimbot on key press
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then
        if input.KeyCode == Enum.KeyCode.F then
            aimbotEnabled = not aimbotEnabled -- Toggle the aimbot state
            print("Aimbot " .. (aimbotEnabled and "enabled" or "disabled")) -- Print the current state
        end
    end
end)

-- Continuously update the aim every frame
RunService.RenderStepped:Connect(function()
    lockOnNearestPlayerHead()
end)

-- Print confirmation
print("Aimbot functionality integrated with key toggle using 'F'.")
