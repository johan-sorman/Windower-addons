_addon.name = 'VoidWalker'
_addon.author = 'Garyfromwork, Modified by Melucine'
_addon.version = '1.2.0.0'
_addon.command = 'vw'

require('tables')

res = require 'resources'
config = require('config')
texts = require('texts')
defaults = require('settings')

settings = config.load(defaults)

mark = texts.new('Direction: ${direction} Distance: ${distance||%.2f}', settings.marktxt)

voidwalker_mode = true
local direction = nil -- Define direction as a local variable here

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
                mark:text(string.format('NM Direction → [%s] Distance: [%.2f]', direction or 'Unknown', distance))
            else
                mark:text('NM Direction → [Unknown] Distance: [0.00]')
            end
        end      
    end

    if voidwalker_mode == true then
        mark:visible(s ~= nil)
    end
end)

windower.register_event('incoming text', function(original, modified)
    direction = nil -- Update the global direction variable
    
    if string.find(original:lower(), '%ssouth%s*west%s') then
        direction = "South-West"
        windower.ffxi.turn(3*math.pi/4)
    elseif string.find(original:lower(), '%ssouth%s*east%s') then
        direction = "South-East"
        windower.ffxi.turn(math.pi/4)
    elseif string.find(original:lower(), '%snorth%s*west%s') then
        direction = "North-West"
        windower.ffxi.turn(5*math.pi/4)
    elseif string.find(original:lower(), '%snorth%s*east%s') then
        direction = "North-East"
        windower.ffxi.turn(7*math.pi/4)
    elseif string.find(original:lower(), '%seast%s') then
        direction = "East"
        windower.ffxi.turn(0)
    elseif string.find(original:lower(), '%swest%s') then
        direction = "West"
        windower.ffxi.turn(math.pi)
    elseif string.find(original:lower(), '%snorth%s') then
        direction = "North"
        windower.ffxi.turn(3*math.pi/2)
    elseif string.find(original:lower(), '%ssouth%s') then
        direction = "South"
        windower.ffxi.turn(math.pi/2)
    end
    
    if direction then
        -- Update the text element with the detected direction
        mark:visible(true)  -- Ensure the text element is visible
        mark.value = string.format('NM Direction → [%s] Distance: [%.2f]', direction, distance or 0)
    end
end)

windower.register_event('addon command', function(command)
    if command:lower() == 'help' then
        windower.add_to_chat(8,'VoidWalker: //VW <command>:')
    elseif command:lower() == 'on' then
        if voidwalker_mode == false then
            windower.add_to_chat(8, 'VoidWalker = On')
            voidwalker_mode = true
            mark:visible(true)
        end
    elseif command:lower() == 'off' then
        if voidwalker_mode == true then
            windower.add_to_chat(8, 'VoidWalker = Off')
            mark:visible(false)
            voidwalker_mode = false
        end
    end
end)

windower.register_event('load', function()
    if windower.ffxi.get_player() then 
        coroutine.sleep(2) -- sleeping because jobchange too fast doesn't show new abilities
        self = windower.ffxi.get
    end
end)
