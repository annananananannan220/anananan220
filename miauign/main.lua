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

    if category == "Webhook" then
        -- Create Webhook content
        local webhookLabel = Instance.new("TextLabel")
        webhookLabel.Size = UDim2.new(0, 450, 0, 30)
        webhookLabel.Position = UDim2.new(0, 0, 0, 20)
        webhookLabel.Text = "Enter Webhook URL:"
        webhookLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        webhookLabel.BackgroundTransparency = 1
        webhookLabel.Parent = functionFrame

        local webhookInput = Instance.new("TextBox")
        webhookInput.Size = UDim2.new(0, 450, 0, 30)
        webhookInput.Position = UDim2.new(0, 0, 0, 60)
        webhookInput.PlaceholderText = "Webhook URL"
        webhookInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        webhookInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        webhookInput.Parent = functionFrame

        local sendButton = Instance.new("TextButton")
        sendButton.Size = UDim2.new(0, 150, 0, 40)
        sendButton.Position = UDim2.new(0, 0, 0, 100)
        sendButton.Text = "Send Webhook"
        sendButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        sendButton.Parent = functionFrame

        sendButton.MouseButton1Click:Connect(function()
            local webhookURL = webhookInput.Text
            if webhookURL == "" then
                warn("Please enter a valid Webhook URL.")
                return
            end

            local response = http_request({
                Url = webhookURL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode({
                    ["content"] = "",
                    ["embeds"] = { {
                        ["title"] = "Webhook Test",
                        ["description"] = "Sent from GUI",
                        ["color"] = tonumber(0xffffff)
                    }}
                })
            })
            print("Webhook Sent!")
        end)
    elseif category == "Coming Soon" then
        -- Create Coming Soon content
        local comingSoonLabel = Instance.new("TextLabel")
        comingSoonLabel.Size = UDim2.new(0, 450, 0, 30)
        comingSoonLabel.Position = UDim2.new(0, 0, 0, 20)
        comingSoonLabel.Text = "This feature is coming soon..."
        comingSoonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        comingSoonLabel.BackgroundTransparency = 1
        comingSoonLabel.Parent = functionFrame
    elseif category == "Other" then
        -- Add content for "Other" category
        local otherLabel = Instance.new("TextLabel")
        otherLabel.Size = UDim2.new(0, 450, 0, 30)
        otherLabel.Position = UDim2.new(0, 0, 0, 20)
        otherLabel.Text = "Other functions can go here."
        otherLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        otherLabel.BackgroundTransparency = 1
        otherLabel.Parent = functionFrame
    elseif category == "Settings" then
        -- Add content for "Settings" category
        local settingsLabel = Instance.new("TextLabel")
        settingsLabel.Size = UDim2.new(0, 450, 0, 30)
        settingsLabel.Position = UDim2.new(0, 0, 0, 20)
        settingsLabel.Text = "Settings options can go here."
        settingsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        settingsLabel.BackgroundTransparency = 1
        settingsLabel.Parent = functionFrame
    end
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

-- Function to make GUI draggable
local dragging = false
local dragInput, dragStart, startPos

-- Draggable function for mainFrame
local function onDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

local function onDragEnd(input)
    dragging = false
end

local function onDragStart(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(onDrag)
    end
end

-- Connect dragging to mainFrame
mainFrame.InputBegan:Connect(onDragStart)
mainFrame.InputEnded:Connect(onDragEnd)

-- Draggable function for toggleButton
local function onToggleDragStart(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = toggleButton.Position
        input.Changed:Connect(function()
            if dragging then
                local delta = input.Position - dragStart
                toggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
end

local function onToggleDragEnd(input)
    dragging = false
end

toggleButton.InputBegan:Connect(onToggleDragStart)
toggleButton.InputEnded:Connect(onToggleDragEnd)

-- Create the "X" button for closing the GUI
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 10)  -- Positioned top-right
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = mainFrame

-- Create the confirmation window (initially hidden)
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

-- Close button event to show confirmation frame
closeButton.MouseButton1Click:Connect(function()
    confirmationFrame.Visible = true
end)

-- Handle Yes/No confirmation
yesButton.MouseButton1Click:Connect(function()
    mainFrame:Destroy()  -- Remove the GUI
    screenGui:Destroy()  -- Remove the screenGui
end)

noButton.MouseButton1Click:Connect(function()
    confirmationFrame.Visible = false  -- Hide confirmation
end)
