--[[
Countdown v1.0.0

Copyright © 2024 Melucine
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.
* Neither the name of Countdown nor the names of its contributors may be
used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Mojo BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]

_addon.name = 'Countdown'
_addon.author = 'Melucine'
_addon.version = '1.0.0'
_addon.command = 'countdown'

local countdownTimer = {}
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

function countdownTimer:startCountdown(time)
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
    countdown_handle = coroutine.schedule(countdownTimer.update, timeInSeconds)
end

------------------------------------------------------------------------------------------
-- Stop countdown
------------------------------------------------------------------------------------------

function countdownTimer.stopCountdown()
    if not countdown_active then
        windower.add_to_chat(100, string.format('\30\03[%s]\30\01 No active countdown to stop.', 'Countdown'))
        return
    end
    windower.add_to_chat(100, string.format('\30\03[%s]\30\01 Stopped the countdown.', 'Countdown'))
    coroutine.close(countdown_handle)
    countdown_active = false
end

function countdownTimer.update()
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
        countdownTimer:startCountdown(time)

    elseif command == 'stop' then
        countdownTimer:stopCountdown()
    end
end)

windower.register_event('zone change', function(new_zone_id, old_zone_id)
    countdownTimer:stopCountdown()
end)
