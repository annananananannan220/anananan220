local function updateSettings(setting, value)
    -- Example setting and value update
    print("Setting updated: " .. setting .. " to " .. tostring(value))
end

return {
    updateSettings = updateSettings
}
