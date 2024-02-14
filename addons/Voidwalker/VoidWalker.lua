_addon.name = 'VoidWalker'
_addon.author = 'Garyfromwork, Modified by Melucine'
_addon.version = '1.2.0.0'
_addon.command = 'vw'

require('tables')

res = require ('resources')
config = require('config')
texts = require('texts')
require('logger')

defaults = require('settings')

settings = config.load(defaults)

mark = texts.new('NM Direction → [${direction} (Tier: ${tier})]  Traveled Distance: [${distance||%.2f}]  Target Distance: [${target_distance||0} - ${direction] ', settings.marktxt)

voidwalker_mode = true
local direction = nil
local tier = nil
local target_distance = 0

windower.register_event('status change', function(new, old)
    local s = windower.ffxi.get_mob_by_target('me')
    if new == 33 then 
        marker = s
    end
end)

windower.register_event('zone change', function()
    marker = nil
    mark.value = '0.00'
end)

windower.register_event('prerender', function()
    local s = windower.ffxi.get_mob_by_target('me')

    if s then
        if voidwalker_mode == true then
            if marker ~= nil then
                local x = marker.x - s.x
                local y = marker.y - s.y
                local z = marker.z - s.z
                distance = math.sqrt(x * x + y * y + z * z) 
                mark:text(string.format(' NM Direction → [%s (Tier: %s)]   Traveled Distance: [%.2f]  Target Distance: [%d - %s] ', direction or 'Unknown', tier or 'Unknown', distance or 0, target_distance or 0, direction or 'Unknown'))
            else
                mark:text(' NM Direction → [Unknown (Tier: Unknown)]  Traveled Distance: [0.00]  Target Distance: [0 - Unknown] ')
            end
        end      
    end

    if voidwalker_mode == true then
        mark:visible(s ~= nil)
    end
end)

windower.register_event('incoming text', function(original, modified)
    local updated = false
    local new_direction = nil 
    local new_tier = nil 
    local new_distance = nil
    local new_target_distance = nil
    
    if string.find(original:lower(), '%ssouth%s*west%s') then
        new_direction = "SW"
        windower.ffxi.turn(3*math.pi/4)
    elseif string.find(original:lower(), '%ssouth%s*east%s') then
        new_direction = "SE"
        windower.ffxi.turn(math.pi/4)
    elseif string.find(original:lower(), '%snorth%s*west%s') then
        new_direction = "NW"
        windower.ffxi.turn(5*math.pi/4)
    elseif string.find(original:lower(), '%snorth%s*east%s') then
        new_direction = "NE"
        windower.ffxi.turn(7*math.pi/4)
    elseif string.find(original:lower(), '%seast%s') then
        new_direction = "E"
        windower.ffxi.turn(0)
    elseif string.find(original:lower(), '%swest%s') then
        new_direction = "W"
        windower.ffxi.turn(math.pi)
    elseif string.find(original:lower(), '%snorth%s') then
        new_direction = "N"
        windower.ffxi.turn(3*math.pi/2)
    elseif string.find(original:lower(), '%ssouth%s') then
        new_direction = "S"
        windower.ffxi.turn(math.pi/2)
    end

    if string.find(original:lower(), '.*there seem to be no monsters.*') then
        new_tier = 0
    elseif string.find(original:lower(), '.*feebl.*') then
        new_tier = 1
    elseif string.find(original:lower(), '.*soft.*') then
        new_tier = 2
    elseif string.find(original:lower(), '.*solid.*') then
        new_tier = 3
    end
    
    local distance_pattern = "%s*(%d+)%s*yalms[^%d]*%s*(%d+)"
    local captured_distance, captured_target_distance = string.match(original:lower(), distance_pattern)
    if captured_distance and captured_target_distance then
        new_distance = tonumber(captured_distance)
        new_target_distance = tonumber(captured_target_distance)
    end

    if new_direction then
        direction = new_direction
        updated = true
    end
    
    if new_tier ~= nil and new_tier >= 0 and new_tier <= 3 then
        tier = new_tier
        updated = true
    end
    
    if new_distance then
        distance = new_distance
        updated = true
    end

    if new_target_distance then
        target_distance = new_distance
        updated = true
    end
    
    if updated then
        
        if tier == 0 then
            mark:text(' No NM Detected ')
            mark:visible(true)
            voidwalker_mode = false       

        elseif tier == 1 or tier == 2 or tier == 3 then
            mark.value = string.format(' NM Direction → [%s (Tier: %s)]   Traveled Distance: [%.2f]  Target Distance: [%d - %s] ', direction or 'Unknown', tier or 'Unknown', distance or 0, target_distance or 0, direction or 'Unknown')
            mark:visible(true)
            voidwalker_mode = true
        end
    end
    if string.find(original:lower(), 'A monster materializes out of nowhere!') then
        mark:visible(false)
        voidwalker_mode = false
    end
end)



windower.register_event('addon command', function(command)
    if command:lower() == 'help' then
        log('Commands:')
        log('//vw help - This message')
        log('//vw on - display textbox and track VNM')
        log('//vw off - hide textbox and disable tracking')
    elseif command:lower() == 'on' then
        if voidwalker_mode == false then
            windower.add_to_chat(100, string.format('\30\03[%s]\30\01 ON', 'VoidWalker'))
            voidwalker_mode = true
            mark:visible(true)
        end
    elseif command:lower() == 'off' then
        if voidwalker_mode == true then
            windower.add_to_chat(100, string.format('\30\03[%s]\30\01 OFF', 'VoidWalker'))
            mark:visible(false)
            voidwalker_mode = false
        end
    end
end)

windower.register_event('load', function()
    if windower.ffxi.get_player() then 
        coroutine.sleep(2)
        self = windower.ffxi.get
    end
end)
