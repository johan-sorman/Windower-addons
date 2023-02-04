_addon.name = 'blockmouse'
_addon.version = '0.0.1'
_addon.author = 'Sampi'
_addon.commands = {'blockmouse', 'bm'}


windower.register_event('load', function()
end)
windower.register_event('unload', function()
    windower.register_event('mouse', function() return false end)
end)

windower.register_event('addon command', function(input, ...)
    local cmd = string.lower(input)
    local args = {...}

    if cmd == 'on' then
        windower.register_event('mouse', function() return true end)
        windower.add_to_chat(123, '------ Mouseinput blocked ------')
    end

    if cmd == 'off' then
        windower.send_command('lua reload blockmouse')
        windower.add_to_chat(123, '------ Mouseinput unblocked ------')
    end
    if cmd == 'help' then
        windower.add_to_chat(4, '------ Blockmouse ------')
        windower.add_to_chat(4, 'help - this message')
        windower.add_to_chat(4, 'on - Blocks input from mouse. Note, sometimes buggs out if write in console')
        windower.add_to_chat(4, 'off - Unblocks input from mouse.')
    end
end)
