-------------------------------------------------
--- QB CORE LOGS
--- Event handler for qb-logs
-------------------------------------------------
if Config.Logs.Framework and Config.Framework == "qb" then
    AddEventHandler('qb-log:server:CreateLog', function(name, title, color, message, tagEveryone, imageUrl)

        -- Events from QB to exclude
        local EventsToExclude = {
            "SetInventory"
        }

        -- If excluded
        if Logger.TableHasValue(EventsToExclude, title) then return end

        -- Create the log with the data passed from qb-log
        Logger.CreateLog({
            LogType = "Framework",
            Level = tagEveryone and 'warn' or 'info',
            Message = title .. " - " .. message:gsub("*", ""),
            Resource = "qb-logs",
            Metadata = {
                image = imageUrl
            }
        })
    end)
end