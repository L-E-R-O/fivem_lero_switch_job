Config = {}

-- Command to trigger job switch
Config.Command = 'jobswitch'

-- Cooldown in seconds (0 to disable)
Config.Cooldown = 0

-- Debug mode (zeigt Performance-Logs)
Config.Debug = true

-- Notification settings
Config.Notifications = {
    success = 'Job erfolgreich gewechselt!',
    noSecondJob = 'Du hast keinen zweiten Job!',
    cooldown = 'Du musst %s Sekunden warten!',
    error = 'Fehler beim Wechseln des Jobs!'
}
