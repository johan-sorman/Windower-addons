_addon.name = 'Repeat'
_addon.author = 'Melucine'
_addon.version = '1.1.1'
_addon.commands = {'rp', 'repeat'}

local repeat_on = false
local max_repeats = -1 
local repeat_delay = 5 
local command_filename = nil

local function execute_command(filename)
    windower.send_command('exec ' .. filename)
end

local function handle_command(action, ...)
    if action == 'set' then
        local new_filename = ...
        if new_filename then
            command_filename = new_filename
            windower.add_to_chat(207, 'Command file set to: ' .. new_filename)
        else
            windower.add_to_chat(207, 'Missing name.')
        end
    elseif action == 'delay' then
        local new_delay = tonumber(...)
        if new_delay then
            repeat_delay = new_delay
            windower.add_to_chat(207, 'Delay set to: ' .. new_delay .. ' seconds')
        else
            windower.add_to_chat(207, 'Invalid delay value.')
        end
    elseif action == 'loop' then
        local new_loop_count = tonumber(...) 
        if new_loop_count then
            max_repeats = new_loop_count 
            windower.add_to_chat(207, 'Loop set to: ' .. new_loop_count)
        else
            windower.add_to_chat(207, 'Invalid loop value.')
        end
    elseif action == 'start' or action == 'on' then
        if max_repeats > 0 or max_repeats <= 0 then 
            repeat_on = true
            windower.add_to_chat(207, 'Repeating started.')
        else
            windower.add_to_chat(207, 'Loop not set. Use //rp loop <number> to set it.')
        end
    elseif action == 'stop' or action == 'off' then
        repeat_on = false
        windower.add_to_chat(207, 'Repeating stopped.')
    elseif action == 'reset' then
        repeat_on = false
        windower.send_command('lua r repeat')
    else
        windower.add_to_chat(207, 'Invalid command.')
    end
end



local function handle_addon_command(command, ...)
    local action = command:lower()
    handle_command(action, ...)
end

windower.register_event('addon command', handle_addon_command)

while true do
    if repeat_on and command_filename then
        execute_command(command_filename)
        if max_repeats > 0 then 
            max_repeats = max_repeats - 1
        end
        if max_repeats == 0 then
            repeat_on = false
            windower.add_to_chat(207, 'Loop finished. Stopping loop.')
        end
        coroutine.sleep(repeat_delay) 
    else
        coroutine.sleep(1) 
    end
end

