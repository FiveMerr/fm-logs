-------------------------------------------------
--- Weapon Logs
-------------------------------------------------
CreateThread(function()
    local FireWeapon = nil
    local Timeout = 0
    local FireCount = 0

    while Config.Logs.Weapon do
        Wait(0)
    
        local PlayerPed = GetPlayerPed(PlayerId())

        -- Get the weapon, shot count, and set timeout
        if IsPedShooting(PlayerPed) then
            FireWeapon = GetSelectedPedWeapon(PlayerPed)
            FireCount = FireCount + 1
            Timeout = 1000

        -- If they are not shooting
        elseif not IsPedShooting(PlayerPed) and FireCount ~= 0 and Timeout ~= 0 then

            -- Decrement the timeout
            if Timeout ~= 0 then
                Timeout = Timeout - 1
            end

            -- If the weapon is no longer the same, zero out the timeout
            if FireWeapon ~= GetSelectedPedWeapon(PlayerPed) then
                Timeout = 0
            end

            -- If checks pass
            if FireCount ~= 0 and Timeout == 0 then
                if not Tables.WeaponNames[tostring(FireWeapon)] then
                    return TriggerServerEvent(Config.ServerEventPrefix .. 'playerShotWeapon', "Unknown")
                end

                -- This weapon exists in our weapons table
                isLoggedWeapon = true

                -- Check if this weapon is to be ignored
                for k,v in pairs(Config.Logs.WeaponsNotLogged) do
                    if FireWeapon == GetHashKey(v) then
                        isLoggedWeapon = false
                    end
                end

                -- If this should be logged, log it.
                if isLoggedWeapon then
                    TriggerServerEvent(Config.ServerEventPrefix .. 'playerShotWeapon', Tables.WeaponNames[tostring(FireWeapon)], FireCount)
                end

                -- Reset fire count
                FireCount = 0
            end
        end
    end
end)