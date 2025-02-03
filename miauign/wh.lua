local HttpService = game:GetService("HttpService")

local function sendWebhook(url, message)
    local response = http_request({
        Url = url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode({
            ["content"] = message,
            ["embeds"] = {
                {
                    ["title"] = "Webhook Notification",
                    ["description"] = message,
                    ["color"] = tonumber(0xffffff)
                }
            }
        })
    })
    print("Webhook Sent!")
end

return {
    sendWebhook = sendWebhook
}
