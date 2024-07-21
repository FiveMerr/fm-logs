-- Log for when a new chat message is sent
AddEventHandler('chatMessage', function(source, name, msg)
	local src = source

    -- If this log is not enabled, just return early
    if not Config.Logs.Chat then return end

    -- If not a command
	if msg:sub(1, 1) ~= '/' then
		Logger.CreateLog({
            LogType = "Chat",
            Message = Language.Locale('chatMessage', {
                name = Framework.Server.GetPlayerName(src)
            }),
            Source = src,
            Metadata = {
                Name = Framework.Server.GetPlayerName(src),
                Message = msg
            }
        })
	end
end)