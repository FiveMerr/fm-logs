-- Your API key for Fivemerr
FivemerrApiKey = "token"

-- API Urls
FivemerrApiUrls = {
    Logs = "https://api.fivemerr.com/v1/logs",
    Media = "https://api.fivemerr.com/v1/media/images"
}

-- Load the language locales
Language.SetLanguage(Config.Language).LoadLocales()

local version = GetResourceMetadata(GetCurrentResourceName(), 'version')

print('--------------------------------------------------')
print('|                                                |')
print('|                 FIVEMERR LOGGER                |')
print('|                     STARTED                    |')
print('|                  VERSION ' .. version .. '                 |')
print('|                                                |')
print('--------------------------------------------------')

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