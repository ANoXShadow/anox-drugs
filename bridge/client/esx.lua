local Bridge = {}
local ESX = nil

function Bridge.Init()
    ESX = exports['es_extended']:getSharedObject()
    while not ESX.IsPlayerLoaded() do
        Wait(100)
    end
    return true
end

function Bridge.GetPlayerData()
    return ESX.GetPlayerData()
end

function Bridge.IsPlayerLoaded()
    return ESX.IsPlayerLoaded()
end

function Bridge.GetFramework()
    return ESX
end

return Bridge