_addon.name = 'VoidWalker'
_addon.author = 'Garyfromwork, Modified by Melucine'
_addon.version = '1.2.0.0'
_addon.command = 'vw'

require('tables')

res = require 'resources'
config = require('config')
texts = require('texts')
defaults = require('settings')

local function angle_to_cardinal(angle)
    local directions = {
        { "North", 0 },
        { "North-East", 45 },
        { "East", 90 },
        { "South-East", 135 },
        { "South", 180 },
        { "South-West", 225 },
        { "West", 270 },
        { "North-West", 315 },
        { "North", 360 }
    }

    for i = 1, #directions - 1 do
        if angle >= directions[i][2] and angle < directions[i + 1][2] then
            return directions[i][1]
        end
    end

    return directions[#directions][1]
end


settings = config.load(defaults)


mark = texts.new('Direction: ${direction}  | Distance: ${distance||%.2f}', settings.marktxt)

voidwalker_mode = true

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
                local direction = math.atan2(y, x)
                if direction < 0 then
                    direction = direction + 2 * math.pi
                end
                direction = math.deg(direction)
                
                local cardinal_direction = angle_to_cardinal(direction)

                mark:text(string.format('Direction: [%s]  | Distance: [%.2f]', cardinal_direction, distance))
            else
                mark:text('Direction: [Unknown]  | Distance: [0.00]')
            end
        end      
    end

    if voidwalker_mode == true then
        mark:visible(s ~= nil)
    end
end)

windower.register_event('incoming text', function(original, modified)
    local direction = nil
    
    if string.find(original:lower(), 'yalms northeast') then
        direction = "North-East"
        windower.ffxi.turn(7*math.pi/4)
    elseif string.find(original:lower(), 'yalms northwest') then
        direction = "North-West"
        windower.ffxi.turn(5*math.pi/4)
    elseif string.find(original:lower(), 'yalms southwest') then
        direction = "South-West"
        windower.ffxi.turn(3*math.pi/4)
    elseif string.find(original:lower(), 'yalms southeast') then
        direction = "South-East"
        windower.ffxi.turn(math.pi/4)
    elseif string.find(original:lower(), 'yalms east') then
        direction = "East"
        windower.ffxi.turn(0)
    elseif string.find(original:lower(), 'yalms west') then
        direction = "West"
        windower.ffxi.turn(math.pi)
    elseif string.find(original:lower(), 'yalms north') then
        direction = "North"
        windower.ffxi.turn(3*math.pi/2)
    elseif string.find(original:lower(), 'yalms south') then
        direction = "South"
        windower.ffxi.turn(math.pi/2)
    end
    
    if direction then
        mark:text(string.format('Direction: [%s]  | Distance: [%.2f]', direction, distance or 0))
    end
end)

windower.register_event('addon command', function(command)
    if command:lower() == 'help' then
        windower.add_to_chat(8,'VoidWalker: //VW <command>:')
        windower.add_to_chat(8,' On, Off (Not case sensitive')
    elseif command:lower() == 'on' then
        if voidwalker_mode == false then
            windower.add_to_chat(8, 'VoidWalker = On')
            voidwalker_mode = true
        end
    elseif command:lower() == 'off' then
        if voidwalker_mode == true then
            windower.add_to_chat(8, 'VoidWalker = Off')
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