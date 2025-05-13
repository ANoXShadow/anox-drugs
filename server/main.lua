local Bridge = require('bridge/loader')
local Framework = Bridge.Load()

local function DebugLog(msg)
    Bridge.Debug(msg)
end

lib.callback.register('anox-drugs:attemptGather', function(source, drugType, locationData)
    local xPlayer = Framework.GetPlayerFromId(source)
    local config = DrugsGather[drugType]
    DebugLog(string.format("Player %d attempting to gather %s", source, drugType))
    if not config then 
        DebugLog(string.format("Invalid drug type: %s", drugType))
        return false 
    end
    if not Framework.CanCarryItem(xPlayer, drugType, config.amountcollected) then
        DebugLog(string.format("Player %d has insufficient inventory space for %d x %s", 
            source, config.amountcollected, drugType))
        Bridge.Notify(source,
            _L('notifications.gathering.inventory_full.description'),
            'info',
            _L('notifications.gathering.inventory_full.title')
        )
        return false
    end
    DebugLog(string.format("Player %d gathering successful, adding %d x %s", 
        source, config.amountcollected, drugType))
    Framework.AddInventoryItem(xPlayer, drugType, config.amountcollected)
    return true
end)

lib.callback.register('anox-drugs:checkLabEntry', function(source, labType)
    local xPlayer = Framework.GetPlayerFromId(source)
    local teleportData = DrugLabTeleports[labType]
    DebugLog(string.format("Player %d attempting to enter %s lab", source, labType))
    if not teleportData.requiredItem then 
        DebugLog(string.format("No required item for %s lab, allowing entry", labType))
        return true 
    end
    local itemCount = Framework.GetInventoryItem(xPlayer, teleportData.requiredItem).count
    local hasItem = itemCount > 0
    DebugLog(string.format("Player %d has %d x %s (required for %s lab entry): %s", 
        source, itemCount, teleportData.requiredItem, labType, tostring(hasItem)))
    return hasItem, teleportData.requiredItem
end)

RegisterServerEvent('anox-drugs:attemptProcess', function(drugType)
    local src = source
    local xPlayer = Framework.GetPlayerFromId(src)
    local config = ProcessDrug[drugType]
    DebugLog(string.format("Player %d attempting to process %s", src, drugType))
    if not config then
        DebugLog(string.format("Invalid drug type for processing: %s", drugType))
        Bridge.Notify(src,
            _L('processing.invalid_type'),
            'info', 
            _L('processing.failed_title')
        )
        return
    end
    local rawMaterialCount = Framework.GetInventoryItem(xPlayer, config.rawMaterial).count
    if rawMaterialCount < config.amountRequired then
        DebugLog(string.format("Player %d has insufficient materials for processing %s: has %d, needs %d", 
            src, drugType, rawMaterialCount, config.amountRequired))
        Bridge.Notify(src,
            _L('notifications.processing.insufficient_materials.description', 
                config.amountRequired, 
                config.rawMaterial
            ),
            'info',
            _L('notifications.processing.insufficient_materials.title')
        )
        return
    end
    if not Framework.CanCarryItem(xPlayer, drugType, config.amountProcessed) then
        DebugLog(string.format("Player %d has insufficient inventory space for processing %s", 
            src, drugType))
        Bridge.Notify(src,
            _L('notifications.processing.inventory_full.description'),
            'info',
            _L('notifications.processing.inventory_full.title')
        )
        return
    end
    DebugLog(string.format("Player %d starting processing progress for %s", src, drugType))
    TriggerClientEvent('anox-drugs:startProcessProgress', src, drugType, ProcessDrug[drugType].processSpeed)
end)

RegisterServerEvent('anox-drugs:completeProcess', function(drugType)
    local src = source
    local xPlayer = Framework.GetPlayerFromId(src)
    local config = ProcessDrug[drugType]
    DebugLog(string.format("Player %d completing processing for %s", src, drugType))
    if not config then 
        DebugLog(string.format("Invalid drug type for processing completion: %s", drugType))
        return 
    end
    local rawMaterialCount = Framework.GetInventoryItem(xPlayer, config.rawMaterial).count
    if rawMaterialCount < config.amountRequired then 
        DebugLog(string.format("Security check failed: Player %d has insufficient materials for processing %s: has %d, needs %d", 
            src, drugType, rawMaterialCount, config.amountRequired))
        return 
    end
    DebugLog(string.format("Removing %d x %s from player %d", 
        config.amountRequired, config.rawMaterial, src))
    Framework.RemoveInventoryItem(xPlayer, config.rawMaterial, config.amountRequired)
    DebugLog(string.format("Adding %d x %s to player %d", 
        config.amountProcessed, drugType, src))
    Framework.AddInventoryItem(xPlayer, drugType, config.amountProcessed)
    Bridge.Notify(src,
        _L('notifications.processing.complete.description', config.amountProcessed, config.label),
        'success',
        _L('notifications.processing.complete.title')
    )
end)

RegisterServerEvent('anox-drugs:attemptPackage', function(drugType)
    local src = source
    local xPlayer = Framework.GetPlayerFromId(src)
    local config = PackageDrug[drugType]
    DebugLog(string.format("Player %d attempting to package %s", src, drugType))
    if not config then
        DebugLog(string.format("Invalid drug type for packaging: %s", drugType))
        Bridge.Notify(src,
            _L('notifications.packaging.failed.description.invalid_type'),
            'info',
            _L('notifications.packaging.failed.title')
        )
        return
    end
    local processedDrugCount = Framework.GetInventoryItem(xPlayer, config.processedDrug).count
    local packageMaterialName, packageMaterialQuantity = config.packagingMaterial[1], config.packagingMaterial[2]
    local packageMaterialCount = Framework.GetInventoryItem(xPlayer, packageMaterialName).count
    if processedDrugCount < config.amountRequired then
        DebugLog(string.format("Player %d has insufficient processed drug for packaging %s: has %d, needs %d", 
            src, drugType, processedDrugCount, config.amountRequired))
        Bridge.Notify(src,
            _L('notifications.packaging.failed.description.insufficient_processed_drug', 
                config.amountRequired, config.processedDrug),
            'info',
            _L('notifications.packaging.failed.title')
        )
        return
    end
    if packageMaterialCount < packageMaterialQuantity then
        DebugLog(string.format("Player %d has insufficient packaging material for %s: has %d %s, needs %d", 
            src, drugType, packageMaterialCount, packageMaterialName, packageMaterialQuantity))
        Bridge.Notify(src,
            _L('notifications.packaging.failed.description.insufficient_packaging_material', 
                packageMaterialQuantity, packageMaterialName),
            'info',
            _L('notifications.packaging.failed.title')
        )
        return
    end
    if not Framework.CanCarryItem(xPlayer, drugType, config.amountPackaged) then
        DebugLog(string.format("Player %d has insufficient inventory space for packaging %s", 
            src, drugType))
        Bridge.Notify(src,
            _L('notifications.packaging.inventory_full.description'),
            'info',
            _L('notifications.packaging.inventory_full.title')
        )
        return
    end
    DebugLog(string.format("Player %d starting packaging progress for %s", src, drugType))
    TriggerClientEvent('anox-drugs:startPackageProgress', src, drugType, PackageDrug[drugType].packageSpeed)
end)

RegisterServerEvent('anox-drugs:completePackage', function(drugType)
    local src = source
    local xPlayer = Framework.GetPlayerFromId(src)
    local config = PackageDrug[drugType]
    DebugLog(string.format("Player %d completing packaging for %s", src, drugType))
    if not config then 
        DebugLog(string.format("Invalid drug type for packaging completion: %s", drugType))
        return 
    end
    local processedDrugCount = Framework.GetInventoryItem(xPlayer, config.processedDrug).count
    local packageMaterialName, packageMaterialQuantity = config.packagingMaterial[1], config.packagingMaterial[2]
    local packageMaterialCount = Framework.GetInventoryItem(xPlayer, packageMaterialName).count
    if processedDrugCount < config.amountRequired or packageMaterialCount < packageMaterialQuantity then
        DebugLog(string.format("Security check failed: Player %d has insufficient materials for packaging %s", src, drugType))
        DebugLog(string.format("Has %d/%d processed drug and %d/%d packaging material", 
            processedDrugCount, config.amountRequired, packageMaterialCount, packageMaterialQuantity))
        return
    end
    DebugLog(string.format("Removing %d x %s and %d x %s from player %d", 
        config.amountRequired, config.processedDrug, packageMaterialQuantity, packageMaterialName, src))
    Framework.RemoveInventoryItem(xPlayer, config.processedDrug, config.amountRequired)
    Framework.RemoveInventoryItem(xPlayer, packageMaterialName, packageMaterialQuantity)
    DebugLog(string.format("Adding %d x %s to player %d", 
        config.amountPackaged, drugType, src))
    Framework.AddInventoryItem(xPlayer, drugType, config.amountPackaged)
    Bridge.Notify(src,
        _L('notifications.packaging.complete.description', config.amountPackaged, config.label),
        'success',
        _L('notifications.packaging.complete.title')
    )
end)