------------------------------------------------------------
--                 CORE BRIDGE DETERMINATION
------------------------------------------------------------

Framework = {
    Core = false,
    Client = {
        EventPlayerLoaded = false
    },
    Server = {}
}

-- Get the core object based on framework provided
function Framework.GetCoreObject()

    if not Framework.Core then
        if Config.Framework == 'esx' then
            Framework.Core = exports['es_extended']:getSharedObject()
            Framework.Client.EventPlayerLoaded = "esx:playerLoaded"
        elseif Config.Framework == 'qb' then
            Framework.Core = exports['qb-core']:GetCoreObject()
            Framework.Client.EventPlayerLoaded = "QBCore:Client:OnPlayerLoaded"
        else
            Framework.Core = "standalone"
        end
    end
    
    return Framework.Core
end

Framework.Core = Config.Framework ~= 'none' and Framework.GetCoreObject() or nil

------------------------------------------------------------
--                  FRAMEWORK SERVER FUNCTIONS
------------------------------------------------------------

-- Returns the player name based on framework
function Framework.Server.GetPlayerName (src)
    if Config.Framework == 'esx' and Framework.Core then

        -- Attempt to get Player table
        local xPlayer = Framework.Core.GetPlayerFromId(src)

        -- If unavailable, return server player name
        if xPlayer == nil then return GetPlayerName(src) end

        -- Return player name
        return xPlayer.getName()
    elseif Config.Framework == 'qb' and Framework.Core then

        -- Attempt to get Player table
        local Player = Framework.Core.Functions.GetPlayer(src)

        -- If unavailable, return server player name
        if Player == nil then return GetPlayerName(src) end

        -- Return player name
        return Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    else
        return GetPlayerName(src)
    end
end