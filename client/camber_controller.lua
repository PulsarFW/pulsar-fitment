local wheelMenu = false
local wheelMenuOpen = false

function OpenControllerMenu()
    if wheelMenuOpen then return end

    if not costMultiplier then
        costMultiplier = 1.0
    end

    wheelMenuOpen = true

    EDITING_VEHICLE = GetVehiclePedIsIn(PlayerPedId(), false)

    local editedFrontCamber, editedRearCamber

    wheelMenu = plsr.Menu:Create('vehicle_wheels', 'Vehicle Wheels', function()
        wheelMenuOpen = true

        CreateThread(function()
            while wheelMenuOpen do
                if editedFrontCamber then
                    SetVehicleFrontCamber(EDITING_VEHICLE, editedFrontCamber)
                end

                if editedRearCamber then
                    SetVehicleRearCamber(EDITING_VEHICLE, editedRearCamber)
                end
                Wait(0)
            end
        end)
    end, function()
        Wait(100)
        wheelMenu = false
        collectgarbage()
        wheelMenuOpen = false

        EDITING_VEHICLE = nil
        RunFitmentDataUpdate()
    end, true)

    local fitmentState = plsr.State.Entity(EDITING_VEHICLE).WheelFitment

    local currentFrontCamberWidth
    if fitmentState and fitmentState?.frontCamber then
        currentFrontCamberWidth = fitmentState?.frontCamber
    else
        currentFrontCamberWidth = plsr.Utils:Round(GetVehicleWheelYRotation(EDITING_VEHICLE, 1) * 2, 2)
    end

    wheelMenu.Add:Slider('Front Track Camber', {
        current = currentFrontCamberWidth,
        min = 0.0,
        max = 0.25,
        step = 0.01,
    }, function(data)
        editedFrontCamber = tonumber(data.data.value) + 0.0
    end)

    local currentRearCamberWidth
    if fitmentState and fitmentState?.rearCamber then
        currentRearCamberWidth = fitmentState?.rearCamber
    else
        currentRearCamberWidth = plsr.Utils:Round(GetVehicleWheelYRotation(EDITING_VEHICLE, 3) * 2, 2)
    end

    wheelMenu.Add:Slider('Rear Track Camber', {
        current = currentRearCamberWidth,
		min = 0.0,
        max = 0.25,
        step = 0.01,
    }, function(data)
        editedRearCamber = tonumber(data.data.value) + 0.0
    end)

    wheelMenu.Add:Button('Save', { success = true }, function()
        plsr.Logger:Trace('Fitment', 'Attempt Save')

        if editedFrontCamber or editedRearCamber then
            plsr.Callbacks:ServerCallback('Vehicles:WheelFitment', {
                vNet = VehToNet(EDITING_VEHICLE),
                fitment = {
                    rearCamber = editedRearCamber,
                    frontCamber = editedFrontCamber,
                },
            }, function(success, newNewData)
                if success then
                    plsr.Notification:Success('Wheel Camber Saved')
                else
                    plsr.Notification:Error('Wheel Camber Saving Failed')
                end
            end)

            wheelMenu:Close()
        else
            plsr.Notification:Error('There Was Nothing to Save')
        end
    end)

    wheelMenu.Add:Button('Discard', { error = true }, function()
        wheelMenu:Close()
    end)

    wheelMenu.Add:Button('Reset', { error = true }, function()
        plsr.Logger:Trace('Fitment', 'Attempt Reset')

        plsr.Callbacks:ServerCallback('Vehicles:WheelFitment', {
            vNet = VehToNet(EDITING_VEHICLE),
            fitment = {
                rearCamber = nil,
                frontCamber = nil,
            },
        }, function(success, newNewData)
            if success then
                plsr.Notification:Success('Wheel Camber Reset')
            else
                plsr.Notification:Error('Wheel Camber Reset Failed')
            end
        end)

        wheelMenu:Close()
    end)

    wheelMenu:Show()
end

function ForceCloseMenu()
    if wheelMenu then
        wheelMenu:Close()
    end
end

AddEventHandler('Vehicles:Client:ExitVehicle', function()
    ForceCloseMenu()
end)