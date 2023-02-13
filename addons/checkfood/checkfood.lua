_addon.name = 'checkfood'
_addon.version = '1.0'
_addon.author = 'Sampi'
_addon.commands = { 'checkfood', 'cf' }

res = require('resources')
config = require('config')

defaults = {}
defaults.food = "B.E.W. Pitaru"
settings = config.load(defaults)


windower.register_event('load', function()
end)

windower.register_event('addon command', function(input)
    local cmd = string.lower(input)

    if cmd == 'on' then
        windower.add_to_chat(123, '------ food tracking ON (checkfood) ------')
        local player = windower.ffxi.get_player()
        if player ~= nil then
            if not S(player.buffs):contains(251) then
                windower.send_command('input /item "' .. settings.food .. '" <me>')
            end
        end
    end
    if cmd == 'off' then
        windower.add_to_chat(123, '------ food tracking OFF (checkfood) ------')
    end

    if cmd == 'help' then
        windower.add_to_chat(4, '------ Checkfood ------')
        windower.add_to_chat(4, 'help - this message')
        windower.add_to_chat(4, 'on - Enables food tracking.')
        windower.add_to_chat(4, 'off - Disables food tracking.')
    end
end)
