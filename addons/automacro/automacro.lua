_addon.name = 'automacro'
_addon.version = '1.1'
_addon.author = 'Mapogo, Sampi'
_addon.commands = {'am','automacro'}

config = require('config')
defaults = {}
defaults.sleep_time = 6


settings = config.load('data/settings.xml', defaults)

windower.register_event('load', function()

end)
windower.register_event('addon command', function(input)
    local cmd = string.lower(input)
    if cmd == 'on' then
        windower.add_to_chat(2, 'Automacro ON')
        while (true)
        do
            coroutine.sleep(settings.sleep_time) -- Wait time
            windower.send_command('setkey ctrl down;') -- can be changed to alt if you want to use alt + 1 (for example)
            windower.send_command('setkey 1 down;') -- setkey 1 = 1st action in your macrobook
            coroutine.sleep(0.1)
            windower.send_command('setkey ctrl up;')
            windower.send_command('setkey 1 up;')
        end
    end

    if cmd == 'off' then
        windower.add_to_chat(2, 'Automacro OFF')
    end
    if cmd == 'help' then
        windower.add_to_chat(4, '------ Automacro ------')
        windower.add_to_chat(4, 'help - this message')
        windower.add_to_chat(4, 'on - Starts automacro, edit lua file for which macro action and wait time between loops')
        windower.add_to_chat(4, 'off - Stops automacro.')
    end
end)
