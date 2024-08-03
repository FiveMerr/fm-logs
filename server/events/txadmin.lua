-------------------------------------------------
--- Update names every so often
-------------------------------------------------
names = {}
CreateThread(function()
	while true do
		Wait(1000)
		for k,v in pairs(GetPlayers()) do
			names[v] = GetPlayerName(v)
		end
	end
end)

-------------------------------------------------
--- TxAdmin Event Handlers
-------------------------------------------------

-- When a scheduled restart announcement goes out
AddEventHandler('txAdmin:events:scheduledRestart', function(data)
	-- If this log is not enabled, just return early
    if not Config.Logs.TxAdmin then return end

	Logger.CreateLog({
        LogType = "TxAdmin",
        Message = Language.Locale("txRestartServer", {
            time = Logger.SecondsToClock(data.secondsRemaining)
        })
    })
end)

-- DM logs
AddEventHandler('txAdmin:events:playerDirectMessage', function(data)
    -- If this log is not enabled, just return early
    if not Config.Logs.TxAdmin then return end


    Logger.CreateLog({
        LogType = "TxAdmin",
        Message = Language.Locale("txDM"),
        Metadata = {
            name = names[data.target],
            author = data.author,
            message = data.message
        }
    })
end)

-- When a player is kicked
AddEventHandler('txAdmin:events:playerKicked', function(data)
	-- If this log is not enabled, just return early
    if not Config.Logs.TxAdmin then return end


	Logger.CreateLog({
        LogType = "TxAdmin",
        Message = Language.Locale("txKicked"),
		Metadata = {
			name = names[data.target],
			author = data.author,
			reason = data.reason
		}
    })
end)

-- When a player is warned
AddEventHandler('txAdmin:events:playerWarned', function(data)
	-- If this log is not enabled, just return early
    if not Config.Logs.TxAdmin then return end


	Logger.CreateLog({
        LogType = "TxAdmin",
        Message = Language.Locale("txWarned"),
		Metadata = {
			actionid = data.actionId,
			name = GetPlayerName(data.target),
			author = data.author,
			reason = data.reason
		}
    })
end)

-- When a player is banned
AddEventHandler('txAdmin:events:playerBanned', function(data)
	-- If this log is not enabled, just return early
    if not Config.Logs.TxAdmin then return end


	Logger.CreateLog({
        LogType = "TxAdmin",
        Message = Language.Locale("txBanned"),
		Metadata = {
			actionid = data.actionId,
			name = names[data.target],
			author = data.author,
			reason = data.reason,
			expiration = data.expiration == false and "Permanent" or data.expiration
		}
    })
end)

-- When a player is whitelisted
AddEventHandler('txAdmin:events:playerWhitelisted', function(data)
	-- If this log is not enabled, just return early
    if not Config.Logs.TxAdmin then return end


	Logger.CreateLog({
        LogType = "TxAdmin",
        Message = Language.Locale("txWhitelist"),
		Metadata = {
			actionid = data.actionId,
			target = data.target,
			author = data.author,
		}
    })
end)

-- When the server config is changed
AddEventHandler('txAdmin:event:configChanged', function()
	-- If this log is not enabled, just return early
    if not Config.Logs.TxAdmin then return end


	Logger.CreateLog({
        LogType = "TxAdmin",
        Message = Language.Locale("txCfg"),
		Metadata = {
			author = data.target,
		}
    })
end)

-- When a player is healed
AddEventHandler('txAdmin:events:healedPlayer', function(data)
	-- If this log is not enabled, just return early
    if not Config.Logs.TxAdmin then return end


	Logger.CreateLog({
        LogType = "TxAdmin",
        Message = data.id == -1 and Language.Locale("txHealServer") or Language.Locale("txHealPlayer"),
		Metadata = {
			target = data.id,
			name = data.id == -1 and Language.Locale("txEveryone") or GetPlayerName(data.id)
		}
    })
end)

-- When an announcement is created
AddEventHandler('txAdmin:events:announcement', function(data)
	-- If this log is not enabled, just return early
    if not Config.Logs.TxAdmin then return end


	Logger.CreateLog({
        LogType = "TxAdmin",
        Message = Language.Locale("txAnnouncement"),
		Metadata = {
			author = data.author,
			message = data.message
		}
    })
end)

-- When the server is about to shut down
AddEventHandler('txAdmin:events:serverShuttingDown', function(data)
	-- If this log is not enabled, just return early
    if not Config.Logs.TxAdmin then return end


	Logger.CreateLog({
        LogType = "TxAdmin",
        Message = Language.Locale("txShutdownServer", {
            time = Logger.SecondsToClock(data.delay / 1000)
        }),
		Metadata = {
			author = data.author,
			message = data.message
		}
    })
end)