-------------------------------------------------
--- Player damage logs
-------------------------------------------------
CreateThread(function()
	local Health = nil
	while Config.Logs.Damage do

		Wait(0)
		if Health == nil then Health = GetEntityHealth(PlayerPedId()) end
		if Health < GetEntityHealth(PlayerPedId()) then Health = GetEntityHealth(PlayerPedId()) end
		if Health > GetEntityHealth(PlayerPedId()) then
            
            -- Get their new health
			local NewHealth = GetEntityHealth(PlayerPedId())

            -- Trigger the server event to log
			TriggerServerEvent(Config.ServerEventPrefix .. 'playerDamage', math.floor((Health - NewHealth) / 2))

            -- Update the health tracking variable
			Health = NewHealth

			Wait(1000)
		else
			Wait(1000)
		end
	end
end)