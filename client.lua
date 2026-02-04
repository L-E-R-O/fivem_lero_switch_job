local lastSwitch = 0

-- Wait for ESX to be ready
CreateThread(function()
    while ESX == nil do
        Wait(100)
    end
    
    while not ESX.IsPlayerLoaded() do
        Wait(100)
    end
end)

-- Register command
RegisterCommand(Config.Command, function()
    TriggerServerEvent('lero_jobswitch:requestSwitch')
end, false)

-- Event from server with job data
RegisterNetEvent('lero_jobswitch:showUI', function(currentJob, currentGrade, secondJob, secondGrade)
    if not secondJob or secondJob == '' then
        ESX.ShowNotification(Config.Notifications.noSecondJob)
        return
    end

    -- Check cooldown
    if Config.Cooldown > 0 then
        local timePassed = GetGameTimer() - lastSwitch
        if timePassed < (Config.Cooldown * 1000) then
            local remaining = math.ceil((Config.Cooldown * 1000 - timePassed) / 1000)
            ESX.ShowNotification(Config.Notifications.cooldown:format(remaining))
            return
        end
    end

    -- Show ESX menu
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_switch_menu', {
        title = 'Job Wechseln',
        align = 'top-left',
        elements = {
            {label = 'Aktueller Job: ' .. currentJob .. ' (Grad ' .. currentGrade .. ')', value = 'current'},
            {label = 'Zweiter Job: ' .. secondJob .. ' (Grad ' .. secondGrade .. ')', value = 'second'}
        }
    }, function(data, menu)
        if data.current.value == 'second' then
            menu.close()
            TriggerServerEvent('lero_jobswitch:performSwitch')
            lastSwitch = GetGameTimer()
        end
    end, function(data, menu)
        menu.close()
    end)
end)

-- Event for successful switch notification
RegisterNetEvent('lero_jobswitch:switchSuccess', function()
    ESX.ShowNotification(Config.Notifications.success)
end)

-- Event for error notification
RegisterNetEvent('lero_jobswitch:switchError', function()
    ESX.ShowNotification(Config.Notifications.error)
end)

-- Export for other scripts
exports('SwitchJob', function()
    TriggerServerEvent('lero_jobswitch:requestSwitch')
end)
