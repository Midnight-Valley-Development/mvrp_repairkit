lib.locale()
QBCore = exports['qb-core']:GetCoreObject()

RepairVehicle = function(vehicle, index, heading)
    BUSY = true
    local temp = Config.RepairKits[index]

    CreateThread(function()
        while BUSY do
            SetVehicleUndriveable(vehicle, true)
            Wait(1000)
        end
    end)

    if heading then
        SetHeadingToEntity(vehicle)
    end
    SetVehicleDoorOpen(vehicle, 4, false, false)
    
    ShowNotification(locale('rep_started'), 'inform')

    lib.progressBar({
        duration = temp.usetime,
        label = locale('rep_progress'),
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = temp.anim.dict,
            clip = temp.anim.lib
        },
    })

    BUSY = false
    TaskLeaveVehicle(cache.ped, vehicle, 0)
    SetVehicleDoorShut(vehicle, 4, false)
    SetVehicleUndriveable(vehicle, false)
    ShowNotification(locale('rep_success'), 'success')
    TriggerServerEvent('mvrp_repairkit:server:syncRepair', vehicle, index, NetworkGetNetworkIdFromEntity(vehicle))
end

StartThread = function(index)
    DebugPrint("Starting repair thread with index "..tostring(index))
    local temp = Config.RepairKits[index]
    DebugPrint("Repairkit at index is "..tostring(temp.item))
    local PlayerData = QBCore.PlayerData
    
    if temp.allowedJobsTypes and not temp.allowedJobsTypes[PlayerData.job.type] then
        TriggerServerEvent('mvrp_repairkit:server:cancelRepair')
        return ShowNotification(locale('rep_cannot'), 'error')
    end

    if not DoesEntityExist(cache.vehicle) then
        return ShowNotification(locale('not_in_vehicle'), 'error')
    end

    local vehicle = cache.vehicle
    local carHood = GetWorldPositionOfEntityBone(cache.vehicle, GetEntityBoneIndexByName(cache.vehicle, 'bonnet'))

    -- if temp.allowedVehicles and not temp.allowedVehicles[GetEntityModel(vehicle)] then
    --     TriggerServerEvent('mvrp_repairkit:server:cancelRepair')
    --     return ShowNotification(locale('rep_wrong'), 'error')
    -- end

    CreateThread(function()
        SHOW = true
        local pedCoords

        DebugPrint(carHood)
        if type(carHood) == 'vector3' and carHood.x > 0.0 then
            TaskLeaveVehicle(cache.ped, cache.vehicle, 0)
            Wait(1000)

            Config.TextUI('open', locale('press'))

            while SHOW do
                pedCoords = GetEntityCoords(cache.ped)

                if #(vector3(pedCoords.x, pedCoords.y, pedCoords.z) - vector3(carHood.x, carHood.y, carHood.z)) < 2 and
                not IsPedInAnyVehicle(cache.ped, false) and IsControlJustPressed(0, 51) then
                    SHOW = false
                    Config.TextUI('close')
                    RepairVehicle(vehicle, index, true)
                elseif IsPedInAnyVehicle(cache.ped, true) or #(vector3(pedCoords.x, pedCoords.y, pedCoords.z) - vector3(carHood.x, carHood.y, carHood.z)) > 2 then
                    SHOW = false
                    BUSY = false
                    Config.TextUI('close')
                    ShowNotification(locale('rep_error'), 'error')
                    TriggerServerEvent('mvrp_repairkit:server:cancelRepair')
                end

                Wait(0)
            end
        else
            RepairVehicle(vehicle, index, false)
        end
    end)
end

StartCooldown = function()
    if not Config.Cooldown then return end
    COOLDOWN = true

    CreateThread(function()
        SetTimeout(Config.Cooldown * 1000, function()
            COOLDOWN = false
        end)
    end)
end

SetHeadingToEntity = function(target)
    local carHood = GetWorldPositionOfEntityBone(target, GetEntityBoneIndexByName(target, 'bonnet'))
    local c1, c2 = GetEntityCoords(cache.ped), GetEntityCoords(target)

    if type(carHood) == 'vector3' then
        c2 = carHood
    end

    SetEntityHeading(cache.ped, GetHeadingFromVector_2d(c2.x - c1.x, c2.y - c1.y))
end