-- Log for when the player starts connecting to the server
AddEventHandler("playerConnecting", function(name, setReason, deferrals)
	local src = source

    -- If this log is not enabled, just return early
    if not Config.Logs.Player then return end

	Logger.CreateLog({
        LogType = "Player",
        Message = Language.Locale('playerJoin', {
            name = Framework.Server.GetPlayerName(src)
        }),
        Source = src
    })
end)

-- Log for when a player drops from the server
AddEventHandler('playerDropped', function(reason)
	local src = source

    -- If this log is not enabled, just return early
    if not Config.Logs.Player then return end

	Logger.CreateLog({
        LogType = "Player",
        Message = Language.Locale('playerLeave', {
            name = Framework.Server.GetPlayerName(src)
        }),
        Source = src,
        Metadata = {
            Reason = reason
        }
    })
end)

-- Log when a player connects (Only when qb or esx is set)
RegisterServerEvent(Config.ServerEventPrefix .. 'playerConnected')
AddEventHandler(Config.ServerEventPrefix .. 'playerConnected', function()
    local src = source

    -- If this log is not enabled, just return early
    if not Config.Logs.Player then return end

    Logger.CreateLog({
        LogType = "Player",
        Message = Language.Locale('playerConnected', {
            name = Framework.Server.GetPlayerName(src)
        }),
        Source = src
    })
end)

-- Log when a player shoots a weapon
RegisterServerEvent(Config.ServerEventPrefix .. 'playerShotWeapon')
AddEventHandler(Config.ServerEventPrefix .. 'playerShotWeapon', function(weapon, count)
    local src = source

    -- If this log is not enabled, just return early
    if not Config.Logs.Weapon then return end

    Logger.CreateLog({
        LogType = "Weapon",
        Message = Language.Locale('playerShot', {
            name = Framework.Server.GetPlayerName(src)
        }),
        Source = src,
        Metadata = {
            WeaponType = weapon,
            ShoutCount = count
        }
    })
end)

-- Log when a player dies
RegisterServerEvent(Config.ServerEventPrefix .. 'playerDied')
AddEventHandler(Config.ServerEventPrefix .. 'playerDied', function(args)
    local src = source

    -- If this log is not enabled, just return early
    if not Config.Logs.Death then return end

    -- If the player died without being killed
	if args.killer == 0 then
        return Logger.CreateLog({
            LogType = "Death",
            Message = Language.Locale('playerDied', {
                name = Framework.Server.GetPlayerName(src)
            }),
            Source = src,
            Metadata = {
                Reason = args.reason
            }
        })
	end

    -- If player killed another player
    return Logger.CreateLog({
        LogType = "Death",
        Message = Language.Locale('playerKilled', {
            name = Framework.Server.GetPlayerName(src),
            target = Framework.Server.GetPlayerName(args.killer)
        }),
        Source = src,
        Metadata = {
            Reason = args.reason
        }
    })
end)

-- Log when a player loses health
RegisterServerEvent(Config.ServerEventPrefix .. 'playerDamage')
AddEventHandler(Config.ServerEventPrefix .. 'playerDamage', function(args)
    local src = source

    -- If this log is not enabled, just return early
    if not Config.Logs.Damage then return end

    local ThisPed = GetPlayerPed(source)
    local Cause = GetPedSourceOfDamage(ThisPed)
    local DamageType = GetEntityType(Cause)
    local DamageCause = Language.Locale("playerDamageThemself")

    -- If another player damaged them, check if it was in a vehicle or not.
    if DamageType == 1 then

        -- If it was caused by another player
        if IsPedAPlayer(Cause) then

            -- If it was by a vehicle driven by another player
            if GetVehiclePedIsIn(Cause, false) ~= 0 then
                DamageCause = Language.Locale("playerDamageVehicle", {
                    cause = Framework.Server.GetPlayerName(Logger.GetPlayerId(Cause))
                })

            -- If it was by another player
            else
                DamageCause = Language.Locale("playerDamageByPlayer", {
                    name = Framework.Server.GetPlayerName(Logger.GetPlayerId(Cause))
                })
            end
        else
            if GetVehiclePedIsIn(cause, false) ~= 0 then
                DamageCause = Language.Locale("playerDamageVehicle", {
                    cause = "AI"
                })
            else
                DamageCause = Language.Locale("playerDamageByPlayer", {
                    name = "AI"
                })
            end
        end

    -- If they were driving
    elseif DamageType == 2 then
        local driver = GetPedInVehicleSeat(Cause, -1)

        -- If driver was a player
        if IsPedAPlayer(driver) then
            DamageCause = Language.Locale("playerDamageVehicle", {
                cause = Framework.Server.GetPlayerName(Cause)
            })
        else
            DamageCause = Language.Locale("playerDamageVehicleUnknown")
        end

    -- If by an object
    elseif DamageType == 3 then
        DamageCause = Language.Locale("playerDamageByObject")
    end

    -- Create the log
    return Logger.CreateLog({
        LogType = "Damage",
        Message = Language.Locale("playerDamage", {
            name = Framework.Server.GetPlayerName(src),
            cause = DamageCause,
            health = args
        }),
        Source = src,
        Metadata = {
            Name = Framework.Server.GetPlayerName(src),
            DamageCause = DamageCause,
            HealthLost = args
        }
    })
end)