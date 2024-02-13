_addon.name = 'Countdown'
_addon.author = 'Melucine'
_addon.version = '1.0'
_addon.command = 'countdown'

local engageTimer = {}
local countdown_handle
local countdown_active = false

------------------------------------------------------------------------------------------
-- Parse time and input
------------------------------------------------------------------------------------------

function parseTime(time)
    local hours, minutes, seconds = time:match("(%d+):(%d+):(%d+)")
    if hours and minutes and seconds then
        return tonumber(hours) * 3600 + tonumber(minutes) * 60 + tonumber(seconds)
    end
    
    local hours, minutes = time:match("(%d+)h(%d+)min")
    if hours and minutes then
        return tonumber(hours) * 3600 + tonumber(minutes) * 60
    end
    
    local seconds = time:match("(%d+)sec")
    if seconds then
        return tonumber(seconds)
    end
    
    local seconds = time:match("(%d+) sec")
    if seconds then
        return tonumber(seconds)
    end
    
    local minutes = time:match("(%d+)min")
    if minutes then
        return tonumber(minutes) * 60
    end
    
    local minutes = time:match("(%d+) min")
    if minutes then
        return tonumber(minutes) * 60
    end
    
    return tonumber(time)
end

------------------------------------------------------------------------------------------
-- Set Countdown
------------------------------------------------------------------------------------------

function engageTimer:startCountdown(time)
    if countdown_active then
        windower.add_to_chat(100, string.format('\30\03[%s]\30\01 Countdown already active.', 'Countdown'))
        return
    end
    
    local timeInSeconds = parseTime(time)
    if not timeInSeconds or timeInSeconds <= 0 then
        windower.add_to_chat(100, string.format('\30\03[%s]\30\01 Invalid time specified. Please provide a valid time format.', 'Countdown'))
        return
    end
    
    countdown_active = true
    windower.add_to_chat(207, string.format("\30\02Countdown started for \30\01%s seconds.", timeInSeconds))
    countdown_handle = coroutine.schedule(engageTimer.update, timeInSeconds)
end

------------------------------------------------------------------------------------------
-- Stop countdown
------------------------------------------------------------------------------------------

function engageTimer.stopCountdown()
    if not countdown_active then
        windower.add_to_chat(100, string.format('\30\03[%s]\30\01 No active countdown to stop.', 'Countdown'))
        return
    end
    windower.add_to_chat(100, string.format('\30\03[%s]\30\01 Stopped the countdown.', 'Countdown'))
    coroutine.close(countdown_handle)
    countdown_active = false
end

function engageTimer.update()
    windower.add_to_chat(100, string.format('\30\03[%s]\30\01 Countdown reached 0!', 'Countdown'))
    countdown_active = false
end

------------------------------------------------------------------------------------------
-- Addon Commands
------------------------------------------------------------------------------------------

windower.register_event('addon command', function(command, time)

    if command == 'help' then
        windower.add_to_chat(16, '//countdown start ###')
        windower.add_to_chat(16, 'Start a countdown with desired value (//countdown start 3min)')
        windower.add_to_chat(16, ' ')
        windower.add_to_chat(16, '//countdown stop') 
        windower.add_to_chat(16, 'Stops current countdown')

    elseif command == 'start' then
        engageTimer:startCountdown(time)

    elseif command == 'stop' then
        engageTimer:stopCountdown()
    end
end)

windower.register_event('zone change', function(new_zone_id, old_zone_id)
    engageTimer:stopCountdown()
end)