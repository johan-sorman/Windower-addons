_addon.name = 'init'
_addon.author = 'Selk, modified by Sampi'
_addon.version = '1.1'

files = require 'files'
default = 'init_default'

windower.register_event('login',function (name)
char = 'init_%s':format(name:lower())
charname = '%s':format(name:lower())

function firstToUpper(str)
    return (str:lower():gsub("^%l", string.upper))
end

if files.exists('..\\..\\scripts\\%s.txt':format(char)) then
default = char
end

windower.send_command('exec %s':format(default))
coroutine.sleep(15) -- Sleep to allow all system messages to load, so log message will appear in the bottom
windower.add_to_chat(123,'------- Loaded ('.. firstToUpper(charname) .. ') init profile -------')
end)

windower.register_event('logout', function(name)
    windower.send_command('lua unloadall')
    windower.send_command('lua load init')
end:delay(3))
