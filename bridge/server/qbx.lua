local Bridge = {}
local QBX = nil

function Bridge.Init()
    QBX = exports['qb-core']:GetCoreObject()
    return true
end

function Bridge.GetPlayerFromId(source)
    return QBX.Functions.GetPlayer(source)
end

function Bridge.GetInventoryItem(player, item)
    local count = exports.ox_inventory:GetItem(player.PlayerData.source, item, nil, true)
    return {
        name = item,
        count = count or 0,
        amount = count or 0
    }
end

function Bridge.CanCarryItem(player, item, count)
    return exports.ox_inventory:CanCarryItem(player.PlayerData.source, item, count)
end

function Bridge.AddInventoryItem(player, item, count)
    exports.ox_inventory:AddItem(player.PlayerData.source, item, count)
end

function Bridge.RemoveInventoryItem(player, item, count)
    exports.ox_inventory:RemoveItem(player.PlayerData.source, item, count)
end

function Bridge.GetFramework()
    return QBX
end

return Bridge