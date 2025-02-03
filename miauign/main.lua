-- List of URLs for your Lua files
local urls = {
    "https://raw.githubusercontent.com/annananananannan220/anananan220/main/miauign/gui.lua",
    "https://raw.githubusercontent.com/annananananannan220/anananan220/main/miauign/wh.lua",
    "https://raw.githubusercontent.com/annananananannan220/anananan220/main/miauign/cs.lua",
    "https://raw.githubusercontent.com/annananananannan220/anananan220/main/miauign/set.lua",
    "https://raw.githubusercontent.com/annananananannan220/anananan220/main/miauign/otr.lua"
}

-- Function to load and execute a Lua file
local function loadAndExecute(url)
    local success, scriptContent = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        local success, result = pcall(function()
            loadstring(scriptContent)()
        end)
        if not success then
            warn("Error executing script at " .. url .. ": " .. result)
        end
    else
        warn("Error loading script from " .. url .. ": " .. scriptContent)
    end
end

-- Run all scripts sequentially
for _, url in ipairs(urls) do
    loadAndExecute(url)
end
