Logger = {

    --[[
        -- Example of a createLog function
        Logger.CreateLog({
            LogType = "Player", -- The log type, must be defined in the config
            Message = "Player action here", -- The message of the log
            Level = "info", -- The level of the log (can be filtered on Fivemerr)
            Resource = "script-name", -- Resource where the log is coming from
            Source = 1, -- Server id for player (Required for Player Attributes to be pulled)
            Metadata = {} -- Custom attributes to be added
        }, { Screenshot = true })

        This can also be called from server or client side:
        exports['fm-logs']:createLog(data, options)
    ]]--

    CreateLog = function (data, options)

        -- If the api token was not provided
        if not Logger.RetrieveApiToken() then
            return Logger.ApiTokenError()
        end

        -- If data is not a table
        if type(data) ~= "table" then
            return Logger.ConsoleError('CreateLog: Parameter 1 is required to be of type "table"')
        end

        -- If log type is not passed
        if not data.LogType then
            return Logger.ConsoleError('CreateLog: LogType is a required table attribute.')
        end

        -- If message is not passed
        if not data.Message then
            return Logger.ConsoleError('CreateLog: Message is a required table attribute.')
        end

        -- Setup the log data table
        local logData = {
            level = data.Level and data.Level or "info",
            message = "[" .. data.LogType .. "] " .. data.Message,
            resource = data.Resource or tostring(GetCurrentResourceName()),
            metadata = data.Metadata or {}
        }

        -- Set log type in meta data for filtering purposes
        logData.metadata.LogType = data.LogType

        -- If source is passed, assign it in metadata
        if data.Source then
            logData.metadata.source = data.Source

            -- Retrieve player details if Source is provided
            local PlayerDetails = Logger.GetPlayerDetails(data.Source)
            if type(PlayerDetails) == "table" then
                if #PlayerDetails then
                    logData.metadata.player = PlayerDetails
                end
            end

            -- Check options and if Screenshot is set to true
            if options then
                if options.Screenshot == true then

                    -- Is set to true when callback is reached for screenshot
                    local screenshotCallbackReached = false

                    -- Capture the screen
                    Logger.CapturePlayerScreen(data.Source, function (imageData)
    
                        -- Check if it was successful
                        if not imageData then
                            Logger.ConsoleError('Unable to capture player screenshot')
                        else
                            logData.metadata.screenshot = imageData.url
                        end

                        -- Tell the script it can move on
                        screenshotCallbackReached = true
                    end)

                    -- Wait for screenshot to be finished
                    while not screenshotCallbackReached do
                        Wait(50)
                    end
                end
            end
        end

        -- Merge any metadata keys here
        logData.message = Language.ProcessString(logData.message, logData.metadata)

        -- Depending on log type, convert metadata to lines
        if data.LogType ~= "Resource" and data.LogType ~= "Framework" then
            logData.message = logData.message .. "\r\n-------------------------------------------------\r\n"
            logData.message = logData.message .. Logger.ConvertLogToLines(logData.metadata)
        end

        -- Submit the request
        PerformHttpRequest(FivemerrApiUrls.Logs, function(code, text, headers)
            if code ~= 200 then
                Logger.ConsoleError('CreateLog: Fivemerr returned error response code: ' .. code)
            end
        end, 'POST', json.encode(logData), { ['Content-Type'] = 'application/json', ['Authorization'] = Logger.RetrieveApiToken() })
    end,

    -- Outputs a console error
    ConsoleError = function (message)
        print('^1Error:^0 ' .. message)
    end,

    -- Outputs api token error to console
    ApiTokenError = function ()
        print('^1Error: You have not set your Fivemerr Api token in your server.cfg. Please refer to the README.^0')
    end,

    -- Checks a table to see if a key exists
    TableContainsKey = function (t, key)
        local keyExists = false

        for k, _ in pairs(t) do
            if (k == key) then
                keyExists = true
            end
        end

        return keyExists
    end,

    -- Checks if a table has value
    TableHasValue  = function (t, value)
        local hasValue = false

        for _, v in pairs(t) do
            if (v == value) then
                hasValue = true
            end
        end

        return hasValue
    end,

    -- Gets a player id by the ped passed
    GetPlayerId = function (ped)
        for k, v in pairs(GetPlayers()) do
            if GetPlayerPed(v) == ped then
                return v
            end
        end
    end,

    SecondsToClock = function (sec)
        local minutes = math.floor(sec / 60)
        local seconds = sec - minutes * 60
        if minutes == 0 then
            return string.format("%d seconds.", seconds)
        else
            return string.format("%d minutes, %d seconds.", minutes, seconds)
        end
    end,

    -- Retrieves player details for logging
    GetPlayerDetails = function (src)
        local playerDetails = {}
        local identifiers = Logger.GetPlayerIdentifiers(src)

        if Config.Logs.PlayerAttributes.PlayerId then
            playerDetails.ServerId = src
        end

        if Config.Logs.PlayerAttributes.Postals then
            playerDetails.NearestPostal = Logger.GetPlayerPostal(src)
        end

        if Config.Logs.PlayerAttributes.PlayerHealth then
            playerDetails.Health = math.floor(GetEntityHealth(GetPlayerPed(src)) / 2) .. " / 100"
        end

        if Config.Logs.PlayerAttributes.PlayerArmor then
            playerDetails.Armor = math.floor(GetPedArmour(GetPlayerPed(src))) .. " / 100"
        end

        if Config.Logs.PlayerAttributes.PlayerPing then
            playerDetails.PlayerPing = GetPlayerPing(src)
        end

        if Config.Logs.PlayerAttributes.Ip then
            playerDetails.Ip = identifiers.ip and identifiers.ip:gsub("ip:", "") or "Not Available"
        end

        if Config.Logs.PlayerAttributes.DiscordId then
            playerDetails.DiscordId = identifiers.discord and identifiers.discord:gsub("discord:", "") or "Not Available"
        end

        if Config.Logs.PlayerAttributes.SteamId then
            playerDetails.SteamId = identifiers.steam and identifiers.steam:gsub("steam:", "") or "Not Available"
        end

        if Config.Logs.PlayerAttributes.License then
            playerDetails.License = identifiers.license and identifiers.license:gsub("license:", "") or "Not Available"
            playerDetails.License2 = identifiers.license2 and identifiers.license2:gsub("license2:", "") or "Not Available"
        end

        return playerDetails
    end,
    
    -- Gets the player's postal
    GetPlayerPostal = function (src)
        local postalsFile = LoadResourceFile(GetCurrentResourceName(), "./json/postals.json")
        local postals = json.decode(postalsFile)
        local nearest = nil
    
        local player = src
        local ped = GetPlayerPed(player)
        local playerCoords = GetEntityCoords(ped)
    
        local x, y = table.unpack(playerCoords)
    
        local ndm = -1
        local ni = -1
        for i, p in ipairs(postals) do
            local dm = (x - p.x) ^ 2 + (y - p.y) ^ 2
            if ndm == -1 or dm < ndm then
                ni = i
                ndm = dm
            end
        end
    
        if ni ~= -1 then
            local nd = math.sqrt(ndm)
            nearest = {i = ni, d = nd}
        end

        _nearest = postals[nearest.i].code

        return _nearest
    end,

    -- Returns player identifiers
    GetPlayerIdentifiers = function(src)

        local identifiers = {
            steam = false, ip = false, discord = false,
            license = false, license2 = false, xbl = false,
            live = false, fivem = false
        }

        for i = 0, GetNumPlayerIdentifiers(src) - 1 do

            local id = GetPlayerIdentifier(src, i)

            if string.find(id, "steam:") then
                identifiers.steam = id
            elseif string.find(id, "ip:") then
                identifiers.ip = id
            elseif string.find(id, "discord:") then
                identifiers.discord = id
            elseif string.find(id, "license:") then
                identifiers.license = id
            elseif string.find(id, "license2:") then
                identifiers.id = id
            elseif string.find(id, "xbl:") then
                identifiers.xbl = id
            elseif string.find(id, "live:") then
                identifiers.live = id
            elseif string.find(id, "fivem:") then
                identifiers.fivem = id
            end
        end

        return identifiers
    end,

    -- Captures player screen on client
    CapturePlayerScreen = function (src, cb)

        -- Verify that src is passed
        if not src then
            return Logger.ConsoleError('CapturePlayerScreen requires parameter 1 to be player source.')
        end

        -- If the api token was not provided
        if not Logger.RetrieveApiToken() then
            return Logger.ApiTokenError()
        end

        exports['screenshot-basic']:requestClientScreenshot(src, {
            encoding = 'webp'
        }, function(err, data)
            if err then return cb(false) end

            PerformHttpRequest(FivemerrApiUrls.Media, function(status, response)
                if status ~= 200 then
                    Logger.ConsoleError('CapturePlayerScreen - Error uploading screenshot. Status returned: ' .. status)
                    return cb(false)
                end
    
                cb(json.decode(response))
            end, "POST", json.encode({ data = data }), {
                ['Authorization'] = Logger.RetrieveApiToken(),
                ['Content-Type'] = 'application/json'
            })
        end)
    end,

    -- This will convert the full metadata table (Deep recursive) to new lines.
    -- To exclude keys, add them to the keysToExclude list below.
    ConvertLogToLines = function (data, message)

        local keysToExclude = {
            "Ip",
            "PlayerPing",
            "Level",
            "LogType",
            "Name",
            "Resource",
            "source"
        }

        if message == nil then
            message = ""
        end

        for k, v in pairs(data) do
            if type(v) == "table" then
                message = Logger.ConvertLogToLines(v, message)
            else
                if not Logger.TableHasValue(keysToExclude, k) then
                    message = message .. "\r\n" .. k:gsub("^%l", string.upper) .. ": " .. v
                end
            end
        end
    
        return message
    end,

    -- Checks if the convar is provided in server.cfg
    RetrieveApiToken = function ()
        local token = GetConvar('fivemerr:apiToken', 'token')
        if token == 'token' then return false end
        return tostring(token)
    end
}