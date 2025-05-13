local Bridge = {}
local QBX = nil

function Bridge.Init()
    QBX = exports['qb-core']:GetCoreObject()
    while not QBX.Functions.GetPlayerData().citizenid do
        Wait(100)
    end
    return true
end

function Bridge.GetPlayerData()
    return QBX.Functions.GetPlayerData()
end

function Bridge.IsPlayerLoaded()
    return QBX.Functions.GetPlayerData().citizenid ~= nil
end

function Bridge.GetFramework()
    return QBX
end

return Bridge