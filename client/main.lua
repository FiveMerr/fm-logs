-------------------------------------------------
--- Language setup
-------------------------------------------------
local LanguageLocales = lib.callback.await(Config.ServerEventPrefix .. 'retrieveLocales', false)
if LanguageLocales then
    Language.SetLanguage(Config.Language).SetLocales(LanguageLocales)
end

-------------------------------------------------
--- Callback Functions
-------------------------------------------------
function GetPlayerNameFromServerByPlayerId (PlayerId)
    return lib.callback.await(Config.ServerEventPrefix .. 'playerName', false, GetPlayerServerId(PlayerId))
end