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
    local scriptContent = game:HttpGet(url)
    loadstring(scriptContent)()
end

-- Run all scripts concurrently using coroutines
for _, url in ipairs(urls) do
    coroutine.wrap(loadAndExecute)(url)
end
