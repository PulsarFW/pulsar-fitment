CreateThread(function()
	plsr.Inventory.Items:RegisterUse("camber_controller", "Vehicles", function(source, item)
		plsr.Callbacks:ClientCallback(source, "Vehicles:UseCamberController", {}, function(veh)
			if not veh then
				return
			end
			veh = NetworkGetEntityFromNetworkId(veh)
			if veh and DoesEntityExist(veh) then
				local vehState = plsr.State.Entity(veh)
				if not vehState.VIN then
					return
				end

				TriggerClientEvent("Fitment:Client:CamberController:UseItem", source)
			end
		end)
	end)
end)
