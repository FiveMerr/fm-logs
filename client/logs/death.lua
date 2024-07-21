-------------------------------------------------
--- Player death logs
-------------------------------------------------
CreateThread(function()
	local hasRun = false

    -- If death logs are enabled
	while Config.Logs.Death do
		Wait(0)
		local iPed = PlayerPedId()

        -- Check if the player is dead
		if IsEntityDead(iPed) then

            -- If this has not ran yet
			if not hasRun then
				hasRun = true

                -- Get all information that we need
				local kPed = GetPedSourceOfDeath(iPed)
				local cause = GetPedCauseOfDeath(iPed)
				local DeathCause = Tables.DeathCauses[cause]
				local killer = 0
				local kPlayer = NetworkGetPlayerIndexFromPed(kPed)
                local DeathReason = ""

                -- Wait for a second before continuing
				Wait(1000)

                -- Suicide
				if kPlayer == PlayerId() then
					if DeathCause ~= nil then
						if DeathCause[2] ~= nil then
                            DeathReason = Language.Locale("playerDeathSuicideFull", {
                                name = GetPlayerNameFromServerByPlayerId(PlayerId()),
                                reason = DeathCause[1],
                                reasonSecondary = DeathCause[2]
                            })
						else
                            DeathReason = Language.Locale("playerDeathSuicideFull", {
                                name = GetPlayerNameFromServerByPlayerId(PlayerId()),
                                reason = DeathCause[1],
                                reasonSecondary = DeathCause[2]
                            })
						end
					else
						DeathReason = Language.Locale("playerDeathSuicideSimple", {
                            name = GetPlayerNameFromServerByPlayerId(PlayerId())
                        })
					end

				elseif kPlayer == nil or kPlayer == -1 then

                    -- Suicide
					if kPed == 0 then

						if DeathCause ~= nil then
							if DeathCause[2] ~= nil then
                                DeathReason = Language.Locale("playerDeathSuicideFull", {
                                    name = GetPlayerNameFromServerByPlayerId(PlayerId()),
                                    reason = DeathCause[1],
                                    reasonSecondary = DeathCause[2]
                                })
							else
                                DeathReason = Language.Locale("playerDeathSuicidePartial", {
                                    name = GetPlayerNameFromServerByPlayerId(PlayerId()),
                                    reason = DeathCause[1]
                                })
							end
						else
                            DeathReason = Language.Locale("playerDeathSuicideSimple", {
                                name = GetPlayerNameFromServerByPlayerId(PlayerId())
                            })
						end

					else

						if IsEntityAPed(kPed) then
							if DeathCause ~= nil then
								if DeathCause[2] ~= nil then
                                    DeathReason = Language.Locale("playerDeathFull", {
                                        name = GetPlayerNameFromServerByPlayerId(PlayerId()),
                                        reason = DeathCause[1],
                                        reasonSecondary = DeathCause[2],
                                        responsible = "AI"
                                    })
								else
                                    DeathReason = Language.Locale("playerDeathPartial", {
                                        name = GetPlayerNameFromServerByPlayerId(PlayerId()),
                                        reason = DeathCause[1],
                                        responsible = "AI"
                                    })
								end
							else
                                DeathReason = Language.Locale("playerDeathSimple", {
                                    name = GetPlayerNameFromServerByPlayerId(PlayerId()),
                                    responsible = "AI"
                                })
							end
                        
						else
                            
							if IsEntityAVehicle(kPed) then
								if IsEntityAPed(GetPedInVehicleSeat(kPed, -1)) then
									if IsPedAPlayer(GetPedInVehicleSeat(kPed, -1)) then
										killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(kPed, -1))
                                        if DeathCause ~= nil then
                                            if DeathCause[2] ~= nil then
                                                DeathReason = Language.Locale("playerDeathFull", {
                                                    name = GetPlayerNameFromServerByPlayerId(PlayerId()),
                                                    reason = DeathCause[1],
                                                    reasonSecondary = DeathCause[2],
                                                    responsible = GetPlayerNameFromServerByPlayerId(killer)
                                                })
                                            else
                                                DeathReason = Language.Locale("playerDeathPartial", {
                                                    name = GetPlayerNameFromServerByPlayerId(PlayerId()),
                                                    reason = DeathCause[1],
                                                    responsible = GetPlayerNameFromServerByPlayerId(killer)
                                                })
                                            end
                                        else
                                            DeathReason = Language.Locale("playerDeathSimple", {
                                                name = GetPlayerNameFromServerByPlayerId(PlayerId()),
                                                responsible = GetPlayerNameFromServerByPlayerId(killer)
                                            })
                                        end
									else
										if DeathCause ~= nil then
                                            if DeathCause[2] ~= nil then
                                                DeathReason = Language.Locale("playerDeathFull", {
                                                    name = GetPlayerNameFromServerByPlayerId(PlayerId()),
                                                    reason = DeathCause[1],
                                                    reasonSecondary = DeathCause[2],
                                                    responsible = "AI"
                                                })
                                            else
                                                DeathReason = Language.Locale("playerDeathPartial", {
                                                    name = GetPlayerNameFromServerByPlayerId(PlayerId()),
                                                    reason = DeathCause[1],
                                                    responsible = "AI"
                                                })
                                            end
                                        else
                                            DeathReason = Language.Locale("playerDeathSimple", {
                                                name = GetPlayerNameFromServerByPlayerId(PlayerId()),
                                                responsible = "AI"
                                            })
                                        end
									end
								else
									if DeathCause ~= nil then
                                        if DeathCause[2] ~= nil then
                                            DeathReason = Language.Locale("playerDeathFull", {
                                                name = GetPlayerNameFromServerByPlayerId(PlayerId()),
                                                reason = DeathCause[1],
                                                reasonSecondary = DeathCause[2],
                                                responsible = "Unknown"
                                            })
                                        else
                                            DeathReason = Language.Locale("playerDeathPartial", {
                                                name = GetPlayerNameFromServerByPlayerId(PlayerId()),
                                                reason = DeathCause[1],
                                                responsible = "Unknown"
                                            })
                                        end
                                    else
                                        DeathReason = Language.Locale("playerDeathSimple", {
                                            name = GetPlayerNameFromServerByPlayerId(PlayerId()),
                                            responsible = "Unknown"
                                        })
                                    end
								end
							end
						end
					end
				else
					killer = NetworkGetPlayerIndexFromPed(kPed)

					if DeathCause ~= nil then
                        if DeathCause[2] ~= nil then
                            DeathReason = Language.Locale("playerDeathFull", {
                                name = GetPlayerNameFromServerByPlayerId(PlayerId()),
                                reason = DeathCause[1],
                                reasonSecondary = DeathCause[2],
                                responsible = GetPlayerNameFromServerByPlayerId(killer)
                            })
                        else
                            DeathReason = Language.Locale("playerDeathPartial", {
                                name = GetPlayerNameFromServerByPlayerId(PlayerId()),
                                reason = DeathCause[1],
                                responsible = GetPlayerNameFromServerByPlayerId(killer)
                            })
                        end
                    else
                        DeathReason = Language.Locale("playerDeathSimple", {
                            name = GetPlayerNameFromServerByPlayerId(PlayerId()),
                            responsible = GetPlayerNameFromServerByPlayerId(killer)
                        })
                    end
				end

				TriggerServerEvent(Config.ServerEventPrefix .. 'playerDied', {
                    reason = DeathReason, 
                    killer = GetPlayerServerId(killer) 
                })
			end
		else
			Wait(500)
			hasRun = false
		end
	end
end)