lib.locale()

COOLDOWN, BUSY = false, false -- no touchy
QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('mvrp_repairkit:client:startRepair', function(index)
    DebugPrint("Running client startRepair event with index "..tostring(index))
    if BUSY then
        ShowNotification(locale('rep_busy'), 'error')
    elseif COOLDOWN then
        ShowNotification(locale('rep_cooldown'), 'error')
    end

    StartCooldown()
    StartThread(index)
end)

RegisterNetEvent('mvrp_repairkit:client:syncRepair', function(vehicle, index)
    local repairKitItemConfig = Config.RepairKits[index]
    DebugPrint("DEBUG: Syncing repair for vehicle "..tostring(vehicle).." with repair item "..tostring(repairKitItemConfig.item))
    if not DoesEntityExist(vehicle) then return end
    local tyres = { 0, 1, 2, 3, 4, 5, 45, 47 }

    -- Massive rework incoming, leaving to repair all for now
    -- but can specify parts later on

    -- Loop through repairKitItemConfig.repairParts and fix each that is set to true
    for part, value in pairs(repairKitItemConfig.repairParts) do
        if value then
            if part == 'wheels' then
                for _, data in pairs(tyres) do
                    SetVehicleTyreFixed(vehicle, data)
                end
            elseif part == 'body' then
                SetVehicleFixed(vehicle)
                SetVehicleDeformationFixed(vehicle)
            elseif part == 'engine' then
                SetVehicleEngineHealth(vehicle, 1000)
            elseif part == 'cleaning' then
                SetVehicleDirtLevel(vehicle, 0)
            elseif part == 'anticleaning' then
                SetVehicleDirtLevel(vehicle, 15)
            end
        end
    end
end)

exports('isBusy', function()
    return BUSY
end)

exports('hasCooldown', function()
    return COOLDOWN
end)