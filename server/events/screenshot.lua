-- Captures screenshot of player's screen and sends via a log
RegisterServerEvent(Config.ServerEventPrefix .. 'playerScreenshot')
AddEventHandler(Config.ServerEventPrefix .. 'playerScreenshot', function(Target)
    local src = Target

    -- Capture the screen
    Logger.CapturePlayerScreen(src, function (imageData)

        -- Check if it was successful
        if not imageData then
            return Logger.ConsoleError('Unable to capture player screenshot')
        end

        -- If this log is not enabled, just return early
        if not Config.Logs.Screenshot then return end

        -- Create a new log
        Logger.CreateLog({
            LogType = "Screenshot",
            Message = Language.Locale('playerScreenshot', {
                name = Framework.Server.GetPlayerName(src)
            }),
            Source = src,
            Metadata = {
                ImageUrl = imageData.url
            }
        })
    end)
end)