-------------------------------------------------
--- Setup
-------------------------------------------------

-- API Urls
FivemerrApiUrls = {
    Logs = "https://api.fivemerr.com/v1/logs",
    Media = "https://api.fivemerr.com/v1/media/images"
}

-- Load the language locales
Language.SetLanguage(Config.Language).LoadLocales()

-------------------------------------------------
--- Logger status / version
-------------------------------------------------

-- Get the version
local version = GetResourceMetadata(GetCurrentResourceName(), 'version')

-- Output the status of the logger
print('--------------------------------------------------')
print('|                                                |')
print('|                 FIVEMERR LOGGER                |')

-- Check if api token is set
if not Logger.RetrieveApiToken() then
    print('|                   ^1NOT STARTED^0                  |')
else
    print('|                     ^2STARTED^0                    |')
end

print('|                  VERSION ' .. version .. '                 |')
print('|                                                |')
print('--------------------------------------------------')

-- If the api token is not set
if not Logger.RetrieveApiToken() then
    Logger.ApiTokenError()
end

-------------------------------------------------
--- Callbacks
-------------------------------------------------

-- Return locales from language state
lib.callback.register(Config.ServerEventPrefix .. 'retrieveLocales', function ()
    return Language.State.Locales
end)

-- Returns player name
lib.callback.register(Config.ServerEventPrefix .. 'playerName', function (source, target)
    return Framework.Server.GetPlayerName(target)
end)

-------------------------------------------------
--- Commands
-------------------------------------------------
lib.addCommand(Config.Commands.Screenshot, {
    help = 'Take screenshot of player\'s screen',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
        },
    },
    restricted = Config.Commands.Permissions
}, function(source, args, raw)

    -- Make sure source is a number
    SourceId = (type(args.target) == "number" and args.target or tonumber(args.target))

    -- Trigger server event to take screenshot
    TriggerEvent(Config.ServerEventPrefix .. 'playerScreenshot', SourceId)
end)

-------------------------------------------------
--- Log Event
-------------------------------------------------
RegisterNetEvent(Config.ServerEventPrefix .. 'createLog')
AddEventHandler (Config.ServerEventPrefix .. 'createLog', function(data, options)
    return Logger.CreateLog(data, options)
end)