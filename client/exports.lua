-------------------------------------------------
--- Exports
-------------------------------------------------
exports('createLog', function (data, options)
    TriggerServerEvent(Config.ServerEventPrefix .. 'createLog', data, options)
end)