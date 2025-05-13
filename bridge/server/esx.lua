local Bridge = {}
local ESX = nil

function Bridge.Init()
    ESX = exports['es_extended']:getSharedObject()
    return true
end

function Bridge.GetPlayerFromId(source)
    return ESX.GetPlayerFromId(source)
end

function Bridge.GetInventoryItem(player, item)
    return player.getInventoryItem(item)
end

function Bridge.CanCarryItem(player, item, count)
    return player.canCarryItem(item, count)
end

function Bridge.AddInventoryItem(player, item, count)
    player.addInventoryItem(item, count)
end

function Bridge.RemoveInventoryItem(player, item, count)
    player.removeInventoryItem(item, count)
end

function Bridge.GetFramework()
    return ESX
end

return Bridge