-------------------------------------------------
--- Player logs
-------------------------------------------------
if Framework.Client.EventPlayerLoaded then
    RegisterNetEvent(Framework.Client.EventPlayerLoaded)
    AddEventHandler (Framework.Client.EventPlayerLoaded, function()
      TriggerServerEvent(Config.ServerEventPrefix .. 'playerConnected')
    end)
end