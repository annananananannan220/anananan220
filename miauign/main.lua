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
    local scriptContent = game:HttpGet(url)
    loadstring(scriptContent)()  -- Execute the Lua script content
end

-- Run all scripts sequentially with a 1.5-second delay
for _, url in ipairs(urls) do
    loadAndExecute(url)
    wait(1.5)  -- 1.5-second delay after each script execution
end

-- Wait for additional 1.5 seconds before showing the GUI
wait(1.5)
