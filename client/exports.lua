-------------------------------------------------
--- Exports
-------------------------------------------------
exports('createLog', function (data)
    TriggerServerEvent(Config.ServerEventPrefix .. 'createLog', data)
end)