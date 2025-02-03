local HttpService = game:GetService("HttpService")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create the main frame (background)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.Parent = screenGui
mainFrame.Visible = false  -- Initially hidden

-- Create the left side for categories
local categoryFrame = Instance.new("Frame")
categoryFrame.Size = UDim2.new(0, 150, 1, 0)  -- Takes 150px width and the whole height
categoryFrame.Position = UDim2.new(0, 0, 0, 0)
categoryFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
categoryFrame.Parent = mainFrame

-- Create the right side for category functions
local functionFrame = Instance.new("Frame")
functionFrame.Size = UDim2.new(0, 450, 1, 0)  -- Takes remaining space
functionFrame.Position = UDim2.new(0, 150, 0, 0)
functionFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
functionFrame.Parent = mainFrame

-- Create a divider line between the left and right side
local divider = Instance.new("Frame")
divider.Size = UDim2.new(0, 1, 1, 0)
divider.Position = UDim2.new(0, 150, 0, 0)
divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
divider.Parent = mainFrame

-- Categories List
local categories = {"Webhook", "Coming Soon", "Other", "Settings"}

-- Create category buttons
local categoryButtons = {}
for i, category in ipairs(categories) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 150, 0, 40)
    button.Position = UDim2.new(0, 0, 0, (i - 1) * 40)
    button.Text = category
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Parent = categoryFrame
    categoryButtons[category] = button
end

-- Function to create content for the selected category
local function updateFunctionFrame(category)
    -- Clear the current content
    for _, child in ipairs(functionFrame:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
    -- Placeholder for dynamic content change
end

-- Initially load the "Webhook" content
updateFunctionFrame("Webhook")

-- Button click events to change categories
for category, button in pairs(categoryButtons) do
    button.MouseButton1Click:Connect(function()
        updateFunctionFrame(category)
    end)
end

-- Create the toggle button (using an example logo here)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)  -- Button size (logo)
toggleButton.Position = UDim2.new(0, 10, 0, 10)  -- Position in the top left corner
toggleButton.Text = "🔽"  -- Placeholder for logo (you can replace with image)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.Parent = screenGui

-- Toggle visibility of the main GUI
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    toggleButton.Text = mainFrame.Visible and "🔼" or "🔽"  -- Change the icon when toggling
end)

-- Create the "X" button for closing the GUI
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 10)  -- Positioned top-right
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = mainFrame

-- Confirmation for closing
local confirmationFrame = Instance.new("Frame")
confirmationFrame.Size = UDim2.new(0, 300, 0, 150)
confirmationFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
confirmationFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
confirmationFrame.Visible = false  -- Hidden until needed
confirmationFrame.Parent = screenGui

local confirmationLabel = Instance.new("TextLabel")
confirmationLabel.Size = UDim2.new(1, 0, 0.6, 0)
confirmationLabel.Text = "Are you sure you want to close?"
confirmationLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmationLabel.BackgroundTransparency = 1
confirmationLabel.Parent = confirmationFrame

-- Confirmation buttons
local yesButton = Instance.new("TextButton")
yesButton.Size = UDim2.new(0.5, 0, 0.4, 0)
yesButton.Position = UDim2.new(0, 0, 0.6, 0)
yesButton.Text = "Yes"
yesButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
yesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
yesButton.Parent = confirmationFrame

local noButton = Instance.new("TextButton")
noButton.Size = UDim2.new(0.5, 0, 0.4, 0)
noButton.Position = UDim2.new(0.5, 0, 0.6, 0)
noButton.Text = "No"
noButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
noButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noButton.Parent = confirmationFrame

closeButton.MouseButton1Click:Connect(function()
    confirmationFrame.Visible = true
end)

yesButton.MouseButton1Click:Connect(function()
    mainFrame:Destroy()
    screenGui:Destroy()
end)

noButton.MouseButton1Click:Connect(function()
    confirmationFrame.Visible = false
end)
