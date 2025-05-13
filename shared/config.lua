--[[                                                --------------------------------->     FOR ASSISTANCE,SCRIPTS AND MORE JOIN OUR DISCORD (https://discord.gg/gbJ5SyBJBv) <---------------------------------                                                                                                                                                                                    
                                                                                                                                                                                                                                 
               AAA               NNNNNNNN        NNNNNNNN                 XXXXXXX       XXXXXXX   SSSSSSSSSSSSSSS TTTTTTTTTTTTTTTTTTTTTTTUUUUUUUU     UUUUUUUUDDDDDDDDDDDDD      IIIIIIIIII     OOOOOOOOO        SSSSSSSSSSSSSSS 
              A:::A              N:::::::N       N::::::N                 X:::::X       X:::::X SS:::::::::::::::ST:::::::::::::::::::::TU::::::U     U::::::UD::::::::::::DDD   I::::::::I   OO:::::::::OO    SS:::::::::::::::S
             A:::::A             N::::::::N      N::::::N                 X:::::X       X:::::XS:::::SSSSSS::::::ST:::::::::::::::::::::TU::::::U     U::::::UD:::::::::::::::DD I::::::::I OO:::::::::::::OO S:::::SSSSSS::::::S
            A:::::::A            N:::::::::N     N::::::N                 X::::::X     X::::::XS:::::S     SSSSSSST:::::TT:::::::TT:::::TUU:::::U     U:::::UUDDD:::::DDDDD:::::DII::::::IIO:::::::OOO:::::::OS:::::S     SSSSSSS
           A:::::::::A           N::::::::::N    N::::::N   ooooooooooo   XXX:::::X   X:::::XXXS:::::S            TTTTTT  T:::::T  TTTTTT U:::::U     U:::::U   D:::::D    D:::::D I::::I  O::::::O   O::::::OS:::::S            
          A:::::A:::::A          N:::::::::::N   N::::::N oo:::::::::::oo    X:::::X X:::::X   S:::::S                    T:::::T         U:::::D     D:::::U   D:::::D     D:::::DI::::I  O:::::O     O:::::OS:::::S            
         A:::::A A:::::A         N:::::::N::::N  N::::::No:::::::::::::::o    X:::::X:::::X     S::::SSSS                 T:::::T         U:::::D     D:::::U   D:::::D     D:::::DI::::I  O:::::O     O:::::O S::::SSSS         
        A:::::A   A:::::A        N::::::N N::::N N::::::No:::::ooooo:::::o     X:::::::::X       SS::::::SSSSS            T:::::T         U:::::D     D:::::U   D:::::D     D:::::DI::::I  O:::::O     O:::::O  SS::::::SSSSS    
       A:::::A     A:::::A       N::::::N  N::::N:::::::No::::o     o::::o     X:::::::::X         SSS::::::::SS          T:::::T         U:::::D     D:::::U   D:::::D     D:::::DI::::I  O:::::O     O:::::O    SSS::::::::SS  
      A:::::AAAAAAAAA:::::A      N::::::N   N:::::::::::No::::o     o::::o    X:::::X:::::X           SSSSSS::::S         T:::::T         U:::::D     D:::::U   D:::::D     D:::::DI::::I  O:::::O     O:::::O       SSSSSS::::S 
     A:::::::::::::::::::::A     N::::::N    N::::::::::No::::o     o::::o   X:::::X X:::::X               S:::::S        T:::::T         U:::::D     D:::::U   D:::::D     D:::::DI::::I  O:::::O     O:::::O            S:::::S
    A:::::AAAAAAAAAAAAA:::::A    N::::::N     N:::::::::No::::o     o::::oXXX:::::X   X:::::XXX            S:::::S        T:::::T         U::::::U   U::::::U   D:::::D    D:::::D I::::I  O::::::O   O::::::O            S:::::S
   A:::::A             A:::::A   N::::::N      N::::::::No:::::ooooo:::::oX::::::X     X::::::XSSSSSSS     S:::::S      TT:::::::TT       U:::::::UUU:::::::U DDD:::::DDDDD:::::DII::::::IIO:::::::OOO:::::::OSSSSSSS     S:::::S
  A:::::A               A:::::A  N::::::N       N:::::::No:::::::::::::::oX:::::X       X:::::XS::::::SSSSSS:::::S      T:::::::::T        UU:::::::::::::UU  D:::::::::::::::DD I::::::::I OO:::::::::::::OO S::::::SSSSSS:::::S
 A:::::A                 A:::::A N::::::N        N::::::N oo:::::::::::oo X:::::X       X:::::XS:::::::::::::::SS       T:::::::::T          UU:::::::::UU    D::::::::::::DDD   I::::::::I   OO:::::::::OO   S:::::::::::::::SS 
AAAAAAA                   AAAAAAANNNNNNNN         NNNNNNN   ooooooooooo   XXXXXXX       XXXXXXX SSSSSSSSSSSSSSS         TTTTTTTTTTT            UUUUUUUUU      DDDDDDDDDDDDD      IIIIIIIIII     OOOOOOOOO      SSSSSSSSSSSSSSS     

                                                 --------------------------------->     FOR ASSISTANCE,SCRIPTS AND MORE JOIN OUR DISCORD (https://discord.gg/gbJ5SyBJBv) <---------------------------------                                                                                                                                                                                                                                    
--]]
Config = {}
Config.Debug = false -- Enable debug logs
Config.Framework = 'qb' -- 'esx', 'qb', 'qbx'
Config.Language = 'en' -- 'en'

Config.UISystem = {
    Notify = 'ox',        -- 'ox'
    ProgressBar = 'ox',   -- 'ox'
    TextUI = 'ox',        -- 'ox'
}

MarkerSettings = {
    gatherType = 1,
    gatherColor = { r = 46, g = 139, b = 87, a = 100 },
    gatherScale = { x = 1.5, y = 0.1, z = 0.1 },
    gatherDistance = 0.9,

    processType = 1,
    processColor = { r = 40, g = 67, b = 135, a = 100 },
    processScale = { x = 1.5, y = 0.1, z = 0.1 },
    processDistance = 0.9,

    packageType = 1,
    packageColor = { r = 255, g = 191, b = 0, a = 100 },
    packageScale = { x = 1.5, y = 0.1, z = 0.1 },
    packageDistance = 0.9,

    teleportType = 1,
    teleportScale = { x = 1.5, y = 0.1, z = 0.1 },
    teleportAlpha = 100,
    teleportEnterColor = { r = 255, g = 255, b = 255 },
    teleportExitColor = { r = 128, g = 0, b = 128 },
    teleportDistance = 2.0,
    teleportUIDistance = 0.5,
    teleportDrawDistance = 5.0
}

DrugLabTeleports = {
    coke = {
        outside = vector4(-55.1237, 6392.6553, 31.4908, 213.9954),
        inside = vector4(1088.6418, -3187.5679, -38.9934, 356.9262),
        requiredItem = nil,
    },
    weed = {
        outside = vector4(116.7403, -1990.0588, 18.4042, 166.6594),
        inside = vector4(1066.3059, -3183.4929, -39.1636, 265.6844),
        requiredItem = "lockpick",
    }
}

DrugBlips = {
    coke = {
        enabled = true,
        name = "coke_lab",
        sprite = 501,
        color = 0,
        scale = 0.8,
        display = 4,
        shortRange = true,
        coords = vector3(-55.1237, 6392.6553, 31.4908)
    },
    weed = {
        enabled = true,
        name = "weed_lab",
        sprite = 496,
        color = 43,
        scale = 0.8,
        display = 4,
        shortRange = true,
        coords = vector3(116.7403, -1990.0588, 18.4042)
    },
    heroin = {
        enabled = true,
        name = "heroin_lab",
        sprite = 403,
        color = 21,
        scale = 0.8,
        display = 4,
        shortRange = true,
        coords = vector3(1394.54, 3601.74, 37.97)
    },
}

DrugsGather = {
    cocaleaves = {
        label = "Coca Leaves",
        amountcollected = 1,
        collectionspeed = 4000,
        loopGather = true,
        location = {
            [1] = {pos =  vector3(1090.41, -3194.91, -38.99)},
            [2] = {pos =  vector3(1092.94, -3194.87, -38.99)},
            [3] = {pos =  vector3(1095.36, -3194.87, -38.99)},
            [4] = {pos =  vector3(1095.36, -3196.60, -38.99)},
            [5] = {pos =  vector3(1092.82, -3196.60, -38.99)},
            [6] = {pos =  vector3(1090.33, -3196.62, -38.99)},
        },
    },
    weedleaves = {
        label = "Weed Leaves",
        amountcollected = 1,
        collectionspeed = 4000,
        loopGather = false,
        location = {
            [1] = {pos = vector3(1057.3657, -3197.8340, -39.1394)},
            [2] = {pos = vector3(1053.9723, -3191.9675, -39.1613)},
            [3] = {pos = vector3(1060.4640, -3193.3918, -39.1436)},
        },
    },
    rawopium = {
        label = "Raw Opium",
        amountcollected = 1,
        collectionspeed = 4000,
        loopGather = false,
        location = {
            [1] = {pos = vector3(1388.9994, 3605.6006, 38.9419)},
            [2] = {pos = vector3(1389.7484, 3603.3496, 38.9407)},
        },
    },
}

ProcessDrug = {
    cocainepowder = {
        label = "Cocaine Powder",
        rawMaterial = "cocaleaves",
        amountRequired = 10,
        amountProcessed = 1,
        processSpeed = 5000,
        location = {
            [1] = {pos =  vector3(1087.46, -3195.05, -38.99)},
            [2] = {pos =  vector3(1087.26, -3197.48, -38.99)},
        },
    },
    weedpowder = {
        label = "Weed Powder",
        rawMaterial = "weedleaves",
        amountRequired = 10,
        amountProcessed = 1,
        processSpeed = 5000,
        location = {
            [1] = {pos = vector3(1039.2117, -3205.3369, -38.1666)},
            [2] = {pos = vector3(1034.7933, -3205.5552, -38.1764)},
            [3] = {pos = vector3(1036.6052, -3203.8145, -38.1729)},
        },
    },
    heroinpowder = {
        label = "Heroin Powder",
        rawMaterial = "rawopium",
        amountRequired = 10,
        amountProcessed = 1,
        processSpeed = 5000,
        location = {
            [1] = {pos = vector3(1391.7032, 3606.1094, 38.9420)},
            [2] = {pos = vector3(1394.4039, 3601.7231, 38.9419)},
        },
    },
}

PackageDrug = {
    cokepouch = {
        label = "Coke Pouch",
        processedDrug = "cocainepowder",
        amountRequired = 1,
        amountPackaged = 1,
        packagingMaterial = {"plastic_bag", 1},
        packageSpeed = 5000,
        location = {
            [1] = {pos = vector3(1100.7789, -3198.7288, -38.9935)},
        },
    },
    weedpouch = {
        label = "Weed Pouch",
        processedDrug = "weedpowder",
        amountRequired = 1,
        amountPackaged = 1,
        packagingMaterial = {"plastic_bag", 1},
        packageSpeed = 5000,
        location = {
            [1] = {pos = vector3(1044.5031, -3194.9688, -38.1580)},
        },
    },
    heroinpouch = {
        label = "Heroin Pouch",
        processedDrug = "heroinpowder",
        amountRequired = 1,
        amountPackaged = 1,
        packagingMaterial = {"plastic_bag", 1},
        packageSpeed = 5000,
        location = {
            [1] = {pos = vector3(1389.8549, 3608.7974, 38.9421)},
        },
    },
}