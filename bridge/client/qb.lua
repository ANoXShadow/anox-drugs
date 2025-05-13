local Bridge = {}
local QBCore = nil

function Bridge.Init()
    QBCore = exports['qb-core']:GetCoreObject()
    while not QBCore.Functions.GetPlayerData().citizenid do
        Wait(100)
    end
    return true
end

function Bridge.GetPlayerData()
    return QBCore.Functions.GetPlayerData()
end

function Bridge.IsPlayerLoaded()
    return QBCore.Functions.GetPlayerData().citizenid ~= nil
end

function Bridge.GetFramework()
    return QBCore
end

return Bridge