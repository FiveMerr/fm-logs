-- Log for when a resource is started
AddEventHandler('onResourceStart', function (resourceName)
	Wait(100)

    -- If this log is not enabled, just return early
    if not Config.Logs.Resource then return end

	Logger.CreateLog({
        LogType = "Resource",
        Message = Language.Locale('resourceStart', {
            resource = resourceName
        }),
        Metadata = {
            Resource = resourceName
        }
    })
end)

-- Log for when a resource is stopped
AddEventHandler('onResourceStop', function (resourceName)

    -- If this log is not enabled, just return early
    if not Config.Logs.Resource then return end

	Logger.CreateLog({
        LogType = "Resource",
        Message = Language.Locale('resourceStop', {
            resource = resourceName
        }),
        Metadata = {
            Resource = resourceName
        }
    })
end)