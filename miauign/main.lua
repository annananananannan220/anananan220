-- List of URLs for your Lua files, in the correct order
local urls = {
    "https://raw.githubusercontent.com/annananananannan220/anananan220/main/miauign/wh.lua",  -- First, load dependent files
    "https://raw.githubusercontent.com/annananananannan220/anananan220/main/miauign/cs.lua",  -- Load supporting files
    "https://raw.githubusercontent.com/annananananannan220/anananan220/main/miauign/set.lua", -- Load settings or configuration
    "https://raw.githubusercontent.com/annananananannan220/anananan220/main/miauign/otr.lua",  -- Load other necessary files
    "https://raw.githubusercontent.com/annananananannan220/anananan220/main/miauign/gui.lua"   -- Finally, load the GUI
}

-- Function to load and execute a Lua file
local function loadAndExecute(url)
    print("Loading: " .. url)  -- Debugging log to check script loading
    local success, scriptContent = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        print("Successfully loaded: " .. url)  -- Debugging log
        -- Execute the script with loadstring
        local execSuccess, execResult = pcall(function()
            loadstring(scriptContent)()  -- Run the Lua code
        end)
        
        if execSuccess then
            print("Successfully executed: " .. url)  -- Debugging log
        else
            warn("Error executing script at " .. url .. ": " .. execResult)
        end
    else
        warn("Error loading script from " .. url .. ": " .. scriptContent)
    end
end

-- Run all scripts sequentially
for _, url in ipairs(urls) do
    loadAndExecute(url)
end

