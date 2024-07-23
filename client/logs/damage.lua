-------------------------------------------------
--- Player damage logs
-------------------------------------------------
CreateThread(function()
	local Health = nil
	while Config.Logs.Damage do
		local pedHealth = GetEntityHealth(cache.ped)
		local newHealth = math.floor(pedHealth) / 2

		if not Health then
			Health = newHealth
		end

		if Health ~= newHealth then
            
			if Health > newHealth then
				-- Trigger the server event to log
				TriggerServerEvent(Config.ServerEventPrefix .. 'playerDamage', math.floor((Health - newHealth)))
			end
			
            -- Update the health tracking variable
			Health = newHealth
		end

		Wait(1000)
	end
end)