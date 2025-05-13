local Bridge = {}
local isClient = IsDuplicityVersion() == false

local function Debug(msg)
    if Config.Debug then
        print('^3[anox-drugs]^7 ' .. msg)
    end
end 

Bridge.Debug = Debug

function Bridge.Load()
    local framework = string.lower(Config.Framework)    
    local supportedFrameworks = {
        esx = true,
        qb = true,
        qbx = true,
    }
    if not supportedFrameworks[framework] then
        Debug('^1Unsupported framework: ' .. framework)
        return nil
    end
    local bridgePath = isClient and 'bridge/client/' .. framework or 'bridge/server/' .. framework
    local success, frameworkBridge = pcall(function()
        return require(bridgePath)
    end)
    if success then
        if frameworkBridge and frameworkBridge.Init() then
            Debug('^2Successfully loaded ' .. framework .. ' bridge for ' .. (isClient and 'client' or 'server'))
            if frameworkBridge.RegisterEvents then
                frameworkBridge.RegisterEvents()
            end
            return frameworkBridge
        else
            Debug('^1Failed to initialize ' .. framework .. ' bridge for ' .. (isClient and 'client' or 'server'))
            return nil
        end
    else
        Debug('^1Failed to load ' .. framework .. ' bridge for ' .. (isClient and 'client' or 'server'))
        return nil
    end
end

local UIPresets = {
    notify = {
        default = {
            backgroundColor = 'rgba(10, 25, 55, 0.65)',
            color = '#60A5FA',
            position = 'center-right',
            duration = 6000,
            icon = 'droplet'
        },
        error = {
            backgroundColor = 'rgba(10, 25, 55, 0.65)',
            color = '#60A5FA',
            position = 'center-right',
            duration = 6000,
            icon = 'droplet'
        },
        success = {
            backgroundColor = 'rgba(10, 25, 55, 0.65)',
            color = '#60A5FA',
            position = 'center-right',
            duration = 6000,
            icon = 'droplet'
        },
        info = {
            backgroundColor = 'rgba(10, 25, 55, 0.65)',
            color = '#60A5FA',
            position = 'center-right',
            duration = 6000,
            icon = 'droplet'
        },
        warning = {
            backgroundColor = 'rgba(10, 25, 55, 0.65)',
            color = '#60A5FA',
            position = 'center-right',
            duration = 6000,
            icon = 'droplet'
        }
    },
    progressBar = {
        gathering = {
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true
            },
            anim = {
                dict = 'anim@amb@business@weed@weed_sorting_seated@',
                clip = 'sorter_right_sort_v1_sorter02',
                flag = 49,
                blendIn = 8.0,
                blendOut = 8.0
            }
        },        
        processing = {
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true
            },
            anim = {
                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                clip = 'machinic_loop_mechandplayer',
                flag = 49,
                blendIn = 4.0,
                blendOut = 4.0
            },
        },        
        packaging = {
            position = 'bottom',
            canCancel = true,
            disable = {
                move = true,
                car = true,
                combat = true
            },
            anim = {
                dict = 'mp_arresting',
                clip = 'a_uncuff',
                flag = 49
            },
        }
    },
    textUI = {
        default = {
            backgroundColor = 'rgba(0, 0, 0, 0.5)',
            color = '#F87171',
            icon = 'info',
            position = 'top-center'
        },
        gather = {
            backgroundColor = 'rgba(36, 68, 17, 0.5)',
            color = '#FFFFFF',
            icon = 'leaf',
            position = 'top-center'
        },
        process = {
            backgroundColor = 'rgba(44, 98, 170, 0.5)',
            color = '#FFFFFF',
            icon = 'flask',
            position = 'top-center'
        },
        package = {
            backgroundColor = 'rgba(255, 219, 17, 0.5)',
            color = '#FFFFFF',
            icon = 'box',
            position = 'top-center'
        },
        teleport = {
            backgroundColor = 'rgba(111, 93, 211, 0.5)',
            color = '#FFFFFF',
            icon = 'door-open',
            position = 'top-center'
        }
    }
}

if IsDuplicityVersion() then
    Bridge.Notify = function(playerId, message, type, title)
        local msgStr = tostring(message or "")
        local notifyType = type or 'info'
        local notifyStyle = UIPresets.notify[notifyType] or UIPresets.notify.info
        TriggerClientEvent('ox_lib:notify', playerId, {
            title = title or 'Notification',
            description = msgStr,
            type = notifyType,
            icon = notifyStyle.icon,
            position = notifyStyle.position,
            duration = notifyStyle.duration,
            style = {
                backgroundColor = notifyStyle.backgroundColor,
                color = notifyStyle.color,
                borderRadius = 14,
                fontSize = '16px',
                fontWeight = 'bold',
                textAlign = 'left',
                padding = '14px 20px',
                border = '1px solid ' .. notifyStyle.color
            }
        })
    end
else
    Bridge.Notify = function(message, type, title)
        if Config.UISystem.Notify == 'ox' then
            local msgStr = tostring(message or "")
            local notifyType = type or 'info'
            local notifyStyle = UIPresets.notify[notifyType] or UIPresets.notify.info
            lib.notify({
                title = title,
                description = msgStr,
                type = notifyType,
                icon = notifyStyle.icon,
                position = notifyStyle.position,
                duration = notifyStyle.duration,
                style = {
                    backgroundColor = 'rgba(10, 25, 55, 0.65)',
                    color = '#60A5FA',
                    borderRadius = 14,
                    fontSize = '16px',
                    fontWeight = 'bold',
                    textAlign = 'left',
                    padding = '14px 20px',
                    border = '1px solid rgba(96, 165, 250, 0.6)',
                    boxShadow = '0 0 12px rgba(96, 165, 250, 0.4)'
                }
                
            })
        else
            BeginTextCommandThefeedPost('STRING')
            AddTextComponentSubstringPlayerName(tostring(message or ""))
            EndTextCommandThefeedPostTicker(false, false)
        end
    end
end

Bridge.ProgressBar = function(label, duration, style, canCancel)
    if Config.UISystem.ProgressBar == 'ox' then
        local progressStyle = style and UIPresets.progressBar[style] or UIPresets.progressBar.gathering
        local progressOptions = {
            duration = duration,
            label = label,
            position = progressStyle.position,
            useWhileDead = progressStyle.useWhileDead,
            canCancel = canCancel ~= nil and canCancel or progressStyle.canCancel,
            disable = progressStyle.disable,
            anim = progressStyle.anim
        }
        if progressStyle.prop then
            progressOptions.prop = progressStyle.prop
        end
        return lib.progressCircle(progressOptions)
    else
        Citizen.Wait(duration)
        return true
    end
end

Bridge.ShowTextUI = function(message, style)
    if Config.UISystem.TextUI == 'ox' then
        local textUIStyle = style and UIPresets.textUI[style] or UIPresets.textUI.default
        lib.showTextUI(message, {
            position = textUIStyle.position,
            icon = textUIStyle.icon,
            style = {
                backgroundColor = textUIStyle.backgroundColor,
                color = textUIStyle.color,
                borderRadius = 6,
                border = '1px solid ' .. textUIStyle.color,
                fontSize = '15px',
                fontWeight = '600',
                padding = '6px 12px',
                letterSpacing = '0.5px',
            }
        })
    else
        -- 
    end
end

Bridge.HideTextUI = function()
    if Config.UISystem.TextUI == 'ox' then
        lib.hideTextUI()
    end
end

Bridge.LoadAnimDict = function(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        local timeout = GetGameTimer() + 1000
        while not HasAnimDictLoaded(dict) and GetGameTimer() < timeout do
            Wait(10)
        end
    end
    return HasAnimDictLoaded(dict)
end

return Bridge