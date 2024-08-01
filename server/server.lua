lib.locale()

QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    -- Creates a usable item for each repair kit
    for i, data in pairs(Config.RepairKits) do
        QBCore.Functions.CreateUseableItem(data.item, function(source, item)
            -- Probably need to check jobs
            -- Maybe some other validation perhaps. Experiment!
            DebugPrint("Using usable item for repair kit: " .. data.item)
            TriggerClientEvent("mvrp_repairkit:client:startRepair", source, i)
        end)
    end
end)

RegisterNetEvent('mvrp_repairkit:server:syncRepair', function(vehicle, index)
    DebugPrint("Syncing repair for vehicle: " .. vehicle .. " with repair kit index: " .. index)
    if type(vehicle) == 'number' and type(index) == 'number' then
        local repairItem = Config.RepairKits[index].item
        local player = Framework.getPlayerFromId(source)
        player:removeItem(repairItem, 1)
        TriggerClientEvent('mvrp_repairkit:client:syncRepair', -1, vehicle, index)
    end
end)

RegisterNetEvent('mvrp_repairkit:server:cancelRepair', function()
    DebugPrint("Cancelling repair for player: " .. source) -- Probably remove lol gottem rekt
end)
