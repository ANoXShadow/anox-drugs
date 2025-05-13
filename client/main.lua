local Bridge = require('bridge/loader')
local Framework = Bridge.Load()
local vector3 = vector3
local IsControlJustPressed = IsControlJustPressed
local SetEntityCoords = SetEntityCoords
local Wait = Wait
local PlayerPedId = PlayerPedId

local function DebugLog(msg)
    Bridge.Debug(msg)
end

local currentGather = {
    active = false,
    drugType = nil,
    location = nil,
    cancelRequested = false
}

local animDicts = {
    gather = 'anim@amb@business@weed@weed_sorting_seated@',
    process = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
    package = 'mp_arresting'
}

for _, dict in pairs(animDicts) do
    Bridge.LoadAnimDict(dict)
end

local function performGathering(drugType, location, isLoop)
    DebugLog(string.format("Attempting to gather %s at location %s (loop: %s)", 
        drugType, 
        json.encode({x = location.pos.x, y = location.pos.y, z = location.pos.z}), 
        tostring(isLoop)
    ))
    local drugsGatherData = DrugsGather[drugType]
    local success = Bridge.ProgressBar(
        _L('progress.gathering', drugsGatherData.label),
        drugsGatherData.collectionspeed,
        'gathering',
        not isLoop
    )
    if success then
        DebugLog("Progress bar completed, calling server callback")
        local gatherSuccess = lib.callback.await('anox-drugs:attemptGather', false, drugType, location)
        if not gatherSuccess then
            DebugLog("Server rejected gathering attempt")
            if isLoop then
                currentGather.active = false
                currentGather.cancelRequested = false
                Bridge.Notify(
                    _L('notifications.gathering.cannot_gather.description'),
                    'info',
                    _L('notifications.gathering.cannot_gather.title')
                )
            end
            return false
        end
        DebugLog("Gather successful for " .. drugType)
        return true
    end
    DebugLog("Progress bar cancelled or failed")
    return false
end

local function createMarker(markerType, position, settings)
    return lib.marker.new({
        type = settings.type,
        coords = position,
        width = settings.scale.x,
        height = settings.scale.y,
        color = {
            r = settings.color.r,
            g = settings.color.g,
            b = settings.color.b,
            a = settings.color.a or MarkerSettings.teleportAlpha
        },
        direction = vector3(0.0, 0.0, 0.0),
        rotation = vector3(0.0, 0.0, 0.0)
    })
end

local function createDrugLabTeleports()
    local teleportPoints = {}
    local showingUI = false
    local teleportMarkers = {}
    DebugLog("Creating drug lab teleport markers")
    for labType, teleportData in pairs(DrugLabTeleports) do
        local outsidePoint = {
            coords = teleportData.outside.xyz,
            distance = MarkerSettings.teleportDistance,
            labType = labType,
            isInside = false,
            teleportTo = teleportData.inside,
            requiredItem = teleportData.requiredItem,
            uiText = teleportData.requiredItem and 
            _L('markers.teleport.enter_with_requirement',labType:gsub("^%l", string.upper),teleportData.requiredItem) or 
            _L('markers.teleport.enter', labType:gsub("^%l", string.upper))
        }
        local markerCoords = vector3(
            teleportData.outside.x,
            teleportData.outside.y,
            teleportData.outside.z - 0.9
        )
        local outsideMarker = createMarker('teleport', markerCoords, {
            type = MarkerSettings.teleportType,
            scale = MarkerSettings.teleportScale,
            color = MarkerSettings.teleportEnterColor
        })
        table.insert(teleportPoints, outsidePoint)
        table.insert(teleportMarkers, {
            marker = outsideMarker,
            point = outsidePoint
        })
        local insidePoint = {
            coords = teleportData.inside.xyz,
            distance = MarkerSettings.teleportDistance,
            labType = labType,
            isInside = true,
            teleportTo = teleportData.outside,
            uiText = _L('markers.teleport.exit', labType:gsub("^%l", string.upper))
        }
        local insideMarkerCoords = vector3(
            teleportData.inside.x,
            teleportData.inside.y,
            teleportData.inside.z - 0.9
        )
        local insideMarker = createMarker('teleport', insideMarkerCoords, {
            type = MarkerSettings.teleportType,
            scale = MarkerSettings.teleportScale,
            color = MarkerSettings.teleportExitColor
        })
        table.insert(teleportPoints, insidePoint)
        table.insert(teleportMarkers, {
            marker = insideMarker,
            point = insidePoint
        })
        DebugLog(string.format("Created teleport markers for %s lab", labType))
    end
    CreateThread(function()
        while true do
            local ped = PlayerPedId()
            local playerCoords = GetEntityCoords(ped)
            local closestPoint = nil
            local closestDistance = MarkerSettings.teleportDistance + 1.0
            local isNearTeleport = false
            local insideTeleportArea = false
            for _, point in ipairs(teleportPoints) do
                local distance = #(playerCoords - point.coords)
                if distance < MarkerSettings.teleportUIDistance then
                    insideTeleportArea = true
                    closestPoint = point
                    closestDistance = distance
                    isNearTeleport = true
                elseif distance < MarkerSettings.teleportDistance then
                    isNearTeleport = true
                    if not insideTeleportArea and distance < closestDistance then
                        closestPoint = point
                        closestDistance = distance
                    end
                end
            end
            if isNearTeleport and closestPoint and insideTeleportArea then
                if not showingUI then
                    Bridge.ShowTextUI(closestPoint.uiText, 'teleport')
                    showingUI = true
                end
                if IsControlJustPressed(0, 51) then -- E key
                    if closestPoint.isInside then
                        DebugLog(string.format("Teleporting player out of %s lab", closestPoint.labType))
                        SetEntityCoords(ped, 
                            closestPoint.teleportTo.x, 
                            closestPoint.teleportTo.y, 
                            closestPoint.teleportTo.z, 
                            false, false, false, false
                        )
                        if showingUI then
                            Bridge.HideTextUI()
                            showingUI = false
                        end
                    else
                        DebugLog(string.format("Attempting to enter %s lab, checking requirements", closestPoint.labType))
                        lib.callback('anox-drugs:checkLabEntry', false, function(canEnter, missingItem)
                            if canEnter then
                                DebugLog(string.format("Entry allowed to %s lab", closestPoint.labType))
                                SetEntityCoords(ped, 
                                    closestPoint.teleportTo.x, 
                                    closestPoint.teleportTo.y, 
                                    closestPoint.teleportTo.z, 
                                    false, false, false, false
                                )
                                if showingUI then
                                    Bridge.HideTextUI()
                                    showingUI = false
                                end
                            elseif missingItem then
                                DebugLog(string.format("Entry denied to %s lab, missing item: %s", closestPoint.labType, missingItem))
                                Bridge.Notify(
                                    _L('notifications.entry_blocked.description', missingItem),
                                    'info',
                                    _L('notifications.entry_blocked.title')
                                )
                            end
                        end, closestPoint.labType)
                    end
                end
            elseif showingUI then
                Bridge.HideTextUI()
                showingUI = false
            end
            if isNearTeleport then
                for _, markerData in ipairs(teleportMarkers) do
                    local distance = #(playerCoords - markerData.point.coords)
                    if distance < MarkerSettings.teleportDrawDistance then
                        markerData.marker:draw()
                    end
                end
            end
            Wait(isNearTeleport and 0 or 500)
        end
    end)
end

local function createDrugBlips()
    DebugLog("Creating drug blips")
    for _, blipData in pairs(DrugBlips) do
        if blipData.enabled then
            local blip = AddBlipForCoord(blipData.coords)
            SetBlipSprite(blip, blipData.sprite)
            SetBlipColour(blip, blipData.color)
            SetBlipScale(blip, blipData.scale)
            SetBlipDisplay(blip, blipData.display)
            SetBlipAsShortRange(blip, blipData.shortRange)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(_L('blips.' .. string.lower(string.gsub(blipData.name, " ", "_"))))
            EndTextCommandSetBlipName(blip)
            DebugLog(string.format("Created blip for %s", blipData.name))
        end
    end
end

local function createDrugMarkers()
    DebugLog("Creating drug markers")
    local markersData = {
        gather = {},
        process = {},
        package = {}
    }
    local libMarkers = {
        gather = {},
        process = {},
        package = {}
    }
    local markerSettings = {
        gather = {
            type = MarkerSettings.gatherType,
            color = MarkerSettings.gatherColor,
            scale = MarkerSettings.gatherScale,
            distance = MarkerSettings.gatherDistance
        },
        process = {
            type = MarkerSettings.processType,
            color = MarkerSettings.processColor,
            scale = MarkerSettings.processScale,
            distance = MarkerSettings.processDistance
        },
        package = {
            type = MarkerSettings.packageType,
            color = MarkerSettings.packageColor,
            scale = MarkerSettings.packageScale,
            distance = MarkerSettings.packageDistance
        }
    }
    for drugType, drugData in pairs(DrugsGather) do
        for _, location in ipairs(drugData.location) do
            local markerPos = location.pos.xyz - vector3(0, 0, 1.0)
            local markerData = {
                coords = location.pos.xyz,
                markerPos = markerPos,
                drugType = drugType,
                location = location,
                label = drugData.label,
                loopGather = drugData.loopGather
            }
            local libMarker = createMarker('gather', markerPos, markerSettings.gather)
            table.insert(markersData.gather, markerData)
            table.insert(libMarkers.gather, {
                marker = libMarker,
                data = markerData
            })
        end
        DebugLog(string.format("Created gather markers for %s", drugType))
    end
    for drugType, drugData in pairs(ProcessDrug) do
        for _, location in ipairs(drugData.location) do
            local markerPos = location.pos.xyz - vector3(0, 0, 1.0)
            local markerData = {
                coords = location.pos.xyz,
                markerPos = markerPos,
                drugType = drugType,
                label = drugData.label
            }
            local libMarker = createMarker('process', markerPos, markerSettings.process)
            table.insert(markersData.process, markerData)
            table.insert(libMarkers.process, {
                marker = libMarker,
                data = markerData
            })
        end
        DebugLog(string.format("Created process markers for %s", drugType))
    end
    for drugType, drugData in pairs(PackageDrug) do
        for _, location in ipairs(drugData.location) do
            local markerPos = location.pos.xyz - vector3(0, 0, 1.0)
            local markerData = {
                coords = location.pos.xyz,
                markerPos = markerPos,
                drugType = drugType,
                label = drugData.label
            }
            local libMarker = createMarker('package', markerPos, markerSettings.package)
            table.insert(markersData.package, markerData)
            table.insert(libMarkers.package, {
                marker = libMarker,
                data = markerData
            })
        end
        DebugLog(string.format("Created package markers for %s", drugType))
    end
    CreateThread(function()
        while true do
            if currentGather.active and IsControlJustPressed(0, 74) then -- H key
                DebugLog("Cancel key pressed for loop gathering")
                currentGather.cancelRequested = true
            end
            Wait(0)
        end
    end)
    CreateThread(function()
        local showingUI = false
        local currentUIData = nil
        while true do
            local ped = PlayerPedId()
            local playerCoords = GetEntityCoords(ped)
            local isNearMarker = false
            local closestMarker = nil
            local closestDistance = 5.0
            local markerType = nil
            for type, markers in pairs(markersData) do
                for _, markerData in ipairs(markers) do
                    local distance = #(playerCoords - markerData.coords)
                    if distance < markerSettings[type].distance * 1.5 and distance < closestDistance then
                        closestMarker = markerData
                        closestDistance = distance
                        markerType = type
                        isNearMarker = true
                    end
                end
            end
            if isNearMarker and closestMarker then
                for _, markerObj in ipairs(libMarkers[markerType]) do
                    if markerObj.data.coords == closestMarker.coords then
                        markerObj.marker:draw()
                        break
                    end
                end
                local newUIData = nil
                if markerType == 'gather' then
                    newUIData = closestMarker.loopGather and 
                        {text = _L('markers.gather.loop_start', closestMarker.label), style = 'gather'} or
                        {text = _L('markers.gather.single_start', closestMarker.label), style = 'gather'}
                elseif markerType == 'process' then
                    newUIData = {text = _L('markers.process', closestMarker.label), style = 'process'}
                elseif markerType == 'package' then
                    newUIData = {text = _L('markers.package', closestMarker.label), style = 'package'}
                end
                if not showingUI or (currentUIData and currentUIData.text ~= newUIData.text) then
                    if showingUI then Bridge.HideTextUI() end
                    Bridge.ShowTextUI(newUIData.text, newUIData.style)
                    showingUI = true
                    currentUIData = newUIData
                end
                if IsControlJustPressed(0, 51) then -- E key
                    if markerType == 'gather' then
                        DebugLog(string.format("Player initiated gather for %s at %s", 
                            closestMarker.drugType, 
                            json.encode({x = closestMarker.coords.x, y = closestMarker.coords.y, z = closestMarker.coords.z})
                        ))
                        if closestMarker.loopGather and not currentGather.active then
                            DebugLog("Starting loop gathering for " .. closestMarker.drugType)
                            currentGather.active = true
                            currentGather.cancelRequested = false
                            currentGather.drugType = closestMarker.drugType
                            currentGather.location = closestMarker.location
                            CreateThread(function()
                                while currentGather.active and currentGather.drugType == closestMarker.drugType do
                                    if currentGather.cancelRequested then
                                        currentGather.active = false
                                        currentGather.cancelRequested = false
                                        DebugLog("Loop gathering cancelled by player")
                                        Bridge.Notify(
                                            _L('notifications.gathering.stopped.description', closestMarker.label),
                                            'info',
                                            _L('notifications.gathering.stopped.title')
                                        )
                                        break
                                    end
                                    local gatherResult = performGathering(
                                        currentGather.drugType,
                                        currentGather.location,
                                        true
                                    )
                                    if not gatherResult then 
                                        DebugLog("Loop gathering stopped due to gather failure")
                                        break 
                                    end
                                end
                            end)
                        elseif not closestMarker.loopGather then
                            DebugLog("Starting single gather for " .. closestMarker.drugType)
                            performGathering(closestMarker.drugType, closestMarker.location, false)
                        end
                    elseif markerType == 'process' then
                        DebugLog("Player initiated processing for " .. closestMarker.drugType)
                        TriggerServerEvent('anox-drugs:attemptProcess', closestMarker.drugType)
                    elseif markerType == 'package' then
                        DebugLog("Player initiated packaging for " .. closestMarker.drugType)
                        TriggerServerEvent('anox-drugs:attemptPackage', closestMarker.drugType)
                    end
                end
            elseif showingUI then
                Bridge.HideTextUI()
                showingUI = false
                currentUIData = nil
                if currentGather.active then
                    DebugLog("Player left gathering area, stopping loop gather")
                    currentGather.active = false
                    currentGather.cancelRequested = false
                    Bridge.Notify(
                        _L('notifications.gathering.left_area.description'),
                        'info',
                        _L('notifications.gathering.left_area.title')
                    )
                end
            end
            Wait(isNearMarker and 0 or 250)
        end
    end)
end

RegisterNetEvent('anox-drugs:startProcessProgress', function(drugType, processTime)
    DebugLog(string.format("Starting process progress for %s, duration: %d", drugType, processTime))
    local success = Bridge.ProgressBar(
        _L('progress.processing', ProcessDrug[drugType].label),
        processTime,
        'processing',
        true
    )
    if success then
        DebugLog("Process progress complete for " .. drugType)
        TriggerServerEvent('anox-drugs:completeProcess', drugType)
    else
        DebugLog("Process progress cancelled for " .. drugType)
        Bridge.Notify(
            _L('notifications.processing.cancelled.description', ProcessDrug[drugType].label),
            'info',
            _L('notifications.processing.cancelled.title')
        )
    end
end)

RegisterNetEvent('anox-drugs:startPackageProgress', function(drugType, packageTime)
    DebugLog(string.format("Starting package progress for %s, duration: %d", drugType, packageTime))
    local success = Bridge.ProgressBar(
        _L('progress.packaging', PackageDrug[drugType].label),
        packageTime,
        'packaging',
        true
    )
    if success then
        DebugLog("Package progress complete for " .. drugType)
        TriggerServerEvent('anox-drugs:completePackage', drugType)
    else
        DebugLog("Package progress cancelled for " .. drugType)
        Bridge.Notify(
            _L('notifications.packaging.cancelled.description', PackageDrug[drugType].label),
            'info',
            _L('notifications.packaging.cancelled.title')
        )
    end
end)

CreateThread(function()
    while not Framework.IsPlayerLoaded() do
        Wait(100)
    end
    DebugLog("Player loaded, initializing drug system")
    createDrugMarkers()
    createDrugLabTeleports()
    createDrugBlips()
    DebugLog("Drug system initialized")
end)