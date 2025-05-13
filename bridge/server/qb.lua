local Bridge = {}
local QBCore = nil

function Bridge.Init()
    QBCore = exports['qb-core']:GetCoreObject()
    return true
end

function Bridge.GetPlayerFromId(source)
    return QBCore.Functions.GetPlayer(source)
end

function Bridge.GetInventoryItem(player, item)
    local itemData = player.Functions.GetItemByName(item)
    if itemData then
        return {name = itemData.name, count = itemData.amount, amount = itemData.amount}
    else
        return {count = 0, amount = 0, name = item}
    end
end

function Bridge.CanCarryItem(player, item, count)
    if QBCore.Functions.CanCarryItem then
        local src = player.PlayerData and player.PlayerData.source or source
        if src then
            return QBCore.Functions.CanCarryItem(src, item, count)
        end
    end
    if player.Functions and player.Functions.CanCarryItem then
        return player.Functions.CanCarryItem(item, count)
    end
    local playerItems = player.PlayerData and player.PlayerData.items or {}
    if not playerItems then return true end
    local itemInfo = QBCore.Shared.Items[item]
    if not itemInfo then return true end
    if itemInfo.weight then
        local maxWeight = QBCore.Config.Player.MaxWeight or 120000
        local currentWeight = 0
        for _, v in pairs(playerItems) do
            if QBCore.Shared.Items[v.name] then
                currentWeight = currentWeight + (QBCore.Shared.Items[v.name].weight * v.amount)
            end
        end
        local addWeight = itemInfo.weight * count
        return (currentWeight + addWeight) <= maxWeight
    else
        local slotsUsed = 0
        for _ in pairs(playerItems) do
            slotsUsed = slotsUsed + 1
        end
        local maxSlots = QBCore.Config.Player.MaxInvSlots or 41
        return (slotsUsed + 1) <= maxSlots
    end
end

function Bridge.AddInventoryItem(player, item, count)
    player.Functions.AddItem(item, count)
    TriggerClientEvent('qb-inventory:client:ItemBox', player.PlayerData.source, QBCore.Shared.Items[item], "add", count)
end

function Bridge.RemoveInventoryItem(player, item, count)
    player.Functions.RemoveItem(item, count)
    TriggerClientEvent('qb-inventory:client:ItemBox', player.PlayerData.source, QBCore.Shared.Items[item], "remove", count)
end

function Bridge.GetFramework()
    return QBCore
end

return Bridge