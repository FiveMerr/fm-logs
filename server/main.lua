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