_addon.name = 'follow'
_addon.version = '0.0.1'
_addon.author = 'Melucine'
_addon.description = 'A basic addon to start follow a player, for multiboxers for example. It\'s not any difference to /follow but easier to handle or use with other addons like send.'
_addon.commands = {'fo'}


windower.register_event('load', function()
end)


-- Command handler function
function handleCommand(command, argument)
    local cmd = string.lower(command)

    -- Help text
    if cmd == 'help' then
        windower.add_to_chat(207, 'Follow Help: ')
        windower.add_to_chat(207, '//fo help - This command/info. ')
        windower.add_to_chat(207, '//fo follow <name> - To start follow.  ')
        windower.add_to_chat(207, '//fo follow stop - Stops follow.')
    end

    -- Stop command
    if  cmd == 'stop' then
        windower.ffxi.follow(0)  -- Stop following
        windower.add_to_chat(207, 'Stopped Follow ')
    end
    
    -- Follow <playername>
    if  cmd == 'follow' and argument then
        local targetName = capitalize(argument)
        local target = windower.ffxi.get_mob_by_name(targetName)

        if target then
            windower.ffxi.follow(target.index)
            windower.add_to_chat(207, 'Now following ' .. targetName)
        else
            windower.add_to_chat(207, 'Player not found: ' .. targetName)
        end
    end
end

-- Register the command handler
windower.register_event('addon command', handleCommand)

-- Unload event
windower.register_event('unload', function()
    windower.ffxi.follow(0)  -- Stop following before unloading
end)

-------------------------------------------------------------------------------------------
-- Custom functions required for some logic
-------------------------------------------------------------------------------------------
-- Function to capitalize the first letter of player name
function capitalize(str)
    return str:gsub("^%l", string.upper)
end