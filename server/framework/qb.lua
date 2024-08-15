-------------------------------------------------
--- QB CORE LOGS
--- Event handler for qb-logs
-------------------------------------------------
if Config.Logs.Framework and Config.Framework == "qb" then
    RegisterNetEvent('qb-log:server:CreateLog', function(name, title, color, message, tagEveryone, imageUrl)

        -- Events from QB to exclude
        local EventsToExclude = {
            "SetInventory"
        }

        -- If excluded
        if Logger.TableHasValue(EventsToExclude, title) then return end

        -- Create the log with the data passed from qb-log
        Logger.CreateLog({
            LogType = "Framework",
            Level = 'warn' or 'info',
            Message = title .. " - " .. message:gsub("*", ""),
            Resource = "qb-logs",
            Metadata = {
                description = message,
                playerId = source,
                playerLicense = GetPlayerIdentifierByType(source, 'license'),
                playerDiscord = GetPlayerIdentifierByType(source, 'discord')
            }
        })
    end)
end
