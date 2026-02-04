-- Cache für Job-Daten um doppelte DB-Abfragen zu vermeiden
local jobCache = {}

-- Debug-Funktion
local function DebugLog(message, duration)
    if Config.Debug then
        if duration then
            print(('[^3JOBSWITCH^7] %s - ^2%sms^7'):format(message, duration))
        else
            print(('[^3JOBSWITCH^7] %s'):format(message))
        end
    end
end

-- Request switch - fetch user data and send to client
RegisterNetEvent('lero_jobswitch:requestSwitch', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    if not xPlayer then return end
    
    local startTime = GetGameTimer()
    
    -- Prüfe zuerst ob Daten schon im Cache sind
    if jobCache[_source] then
        local cached = jobCache[_source]
        DebugLog('Cache hit für Spieler ' .. _source, GetGameTimer() - startTime)
        TriggerClientEvent('lero_jobswitch:showUI', _source, cached.job, cached.job_grade, cached.job2, cached.job2_grade)
        return
    end
    
    DebugLog('Starte DB-Abfrage für Spieler ' .. _source)
    local queryStart = GetGameTimer()
    
    -- Asynchrone DB-Abfrage
    MySQL.query('SELECT job, job_grade, job2, job2_grade FROM users WHERE identifier = ? LIMIT 1', {
        xPlayer.identifier
    }, function(result)
        local queryDuration = GetGameTimer() - queryStart
        DebugLog('SELECT Query abgeschlossen', queryDuration)
        
        if result and result[1] then
            local data = result[1]
            jobCache[_source] = {
                job = data.job,
                job_grade = data.job_grade,
                job2 = data.job2,
                job2_grade = data.job2_grade,
                timestamp = os.time()
            }
            TriggerClientEvent('lero_jobswitch:showUI', _source, data.job, data.job_grade, data.job2, data.job2_grade)
            
            local totalDuration = GetGameTimer() - startTime
            DebugLog('Gesamtdauer requestSwitch', totalDuration)
        end
    end)
end)

-- Perform the actual switch
RegisterNetEvent('lero_jobswitch:performSwitch', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    if not xPlayer then return end
    
    local startTime = GetGameTimer()
    local cachedData = jobCache[_source]
    
    if not cachedData or not cachedData.job2 or cachedData.job2 == '' then
        jobCache[_source] = nil
        TriggerClientEvent('lero_jobswitch:switchError', _source)
        DebugLog('Fehler: Keine gecachten Daten oder kein job2 für Spieler ' .. _source)
        return
    end
    
    DebugLog('Starte Job-Wechsel für Spieler ' .. _source)
    
    -- Sofortiges ESX Update
    local esxStart = GetGameTimer()
    xPlayer.setJob(cachedData.job2, cachedData.job2_grade)
    DebugLog('ESX setJob abgeschlossen', GetGameTimer() - esxStart)
    
    TriggerClientEvent('lero_jobswitch:switchSuccess', _source)
    
    -- DB-Update asynchron im Hintergrund OHNE Callback (fire and forget)
    local updateStart = GetGameTimer()
    MySQL.Async.execute('UPDATE users SET job = ?, job_grade = ?, job2 = ?, job2_grade = ? WHERE identifier = ?', {
        cachedData.job2,
        cachedData.job2_grade,
        cachedData.job,
        cachedData.job_grade,
        xPlayer.identifier
    })
    DebugLog('UPDATE Query gestartet (async)', GetGameTimer() - updateStart)
    
    -- Cache invalidieren
    jobCache[_source] = nil
    
    local totalDuration = GetGameTimer() - startTime
    DebugLog('Gesamtdauer performSwitch', totalDuration)
end)

-- Cache cleanup bei Player Disconnect
AddEventHandler('playerDropped', function()
    local _source = source
    jobCache[_source] = nil
end)

-- Cache cleanup alle 5 Minuten (alte Einträge)
CreateThread(function()
    while true do
        Wait(300000) -- 5 Minuten
        local currentTime = os.time()
        for playerId, data in pairs(jobCache) do
            if data.timestamp and (currentTime - data.timestamp) > 600 then -- 10 Minuten alt
                jobCache[playerId] = nil
            end
        end
    end
end)

-- Export for other scripts
exports('SwitchPlayerJob', function(playerId)
    if not playerId then return false end
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer then
        TriggerEvent('lero_jobswitch:requestSwitch')
        return true
    end
    return false
end)
