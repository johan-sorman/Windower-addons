_addon.name = 'Bufftracker'
_addon.author = 'Melucine'
_addon.version = '1.1'
_addon.commands = {'Bufftracker', 'bt'}

-----------------------------------------------------------------------------
-- Import required modules
-----------------------------------------------------------------------------

local res = require('resources')
local zones = require('restricted_zones')
local defaultSleep = require('recast')

-----------------------------------------------------------------------------
-- Check Active Buff
-----------------------------------------------------------------------------

local trackedBuffs = {}

function checkAndActivateBuff()
    if #trackedBuffs == 0 then
        windower.add_to_chat(207, "No buffs are being tracked.")
        return
    end

    while true do
        local currentZoneID = windower.ffxi.get_info().zone
        local player = windower.ffxi.get_player()

        local isRestrictedZone = false
        for _, zone in pairs(zones) do
            if currentZoneID == zone.id then
                windower.add_to_chat(207, "Cannot use buffs in this area: " .. zone.en)
                isRestrictedZone = true
                break
            end
        end

        if not isRestrictedZone then
            for _, buffName in ipairs(trackedBuffs) do
                local buffActive = false

                if player and player.buffs then
                    for _, buffId in ipairs(player.buffs) do
                        local buff = res.buffs[buffId]
                        if buff and buff.en == buffName then
                            buffActive = true
                            break
                        end
                    end

                    if not buffActive then
                        local command = buffName .. ' <me>'
                        windower.send_command(command)
                    end
                end
                coroutine.sleep(5)
            end
        end

        coroutine.sleep(defaultSleep)
    end
end



-----------------------------------------------------------------------------
-- Handle command
-----------------------------------------------------------------------------

function handleCommand(subcommand, buffName)
    if subcommand == 'add' then
        if not buffName or buffName == '' then
            windower.add_to_chat(207, "Please specify a buff name to add.")
            return
        end
        table.insert(trackedBuffs, buffName)
        local capitalizedbuffName = buffName:sub(1, 1):upper() .. buffName:sub(2)
        windower.add_to_chat(100, capitalizedbuffName .. ' was added successfully.')
    elseif subcommand == 'remove' then
        if not buffName or buffName == '' then
            windower.add_to_chat(207, "Please specify a buff name to remove.")
            return
        end
        for i, name in ipairs(trackedBuffs) do
            if name == buffName then
                table.remove(trackedBuffs, i)
                windower.add_to_chat(100, 'Removed tracked buff: ' .. buffName)
                return
            end
        end
        windower.add_to_chat(207, "Specified buff is not being tracked.")
    elseif subcommand == 'list' then
        if #trackedBuffs == 0 then
            windower.add_to_chat(207, "No buffs are being tracked.")
        else
            windower.add_to_chat(100, "Tracked Buffs:")
            for _, buff in ipairs(trackedBuffs) do
                local capitalizedBuff = buff:sub(1, 1):upper() .. buff:sub(2)
                windower.add_to_chat(100, "- " .. capitalizedBuff)
            end
        end
    elseif subcommand == 'start' then
        if #trackedBuffs == 0 then
            windower.add_to_chat(207, "No buffs are being tracked.")
            return
        else
            windower.add_to_chat(207, 'Starting ...')
            checkAndActivateBuff()
        end

    elseif subcommand == 'stop' then
        windower.add_to_chat(207, "Stopping ...")
        trackedBuffs = {}

    elseif subcommand == 'debug' then
        local currentZoneID = windower.ffxi.get_info().zone
        local currentZone = zones[currentZoneID]
        if currentZone then
            windower.add_to_chat(100, 'Current Zone: ' .. currentZone.en .. ' (ID: '.. currentZoneID .. ')')
        else
            windower.add_to_chat(207, 'Current zone not listed in restricted list.')
        end

    elseif subcommand == 'clear' then
        trackedBuffs = {}
        windower.add_to_chat(100, "Cleared tracked buffs list.")
        
    elseif subcommand == 'help' then
        windower.add_to_chat(100, "===== Bufftracker =====")
        windower.add_to_chat(100, "Commands:")
        windower.add_to_chat(100, "//bt or //bufftracker")
        windower.add_to_chat(100, " ")

        windower.add_to_chat(100, "Usage:")
        windower.add_to_chat(100, " ")

        windower.add_to_chat(100, "//bt add <buffname>")
        windower.add_to_chat(100, "Add buffname to the list to track it")
        windower.add_to_chat(100, " ")

        windower.add_to_chat(100, "//bt remove <buffname>")
        windower.add_to_chat(100, "Removes tracking of the buff")
        windower.add_to_chat(100, " ")

        windower.add_to_chat(100, "//bt list")
        windower.add_to_chat(100, "Shows list of all tracked buffs")
        windower.add_to_chat(100, " ")

        windower.add_to_chat(100, "//bt start")
        windower.add_to_chat(100, "Start using the tracked buffs")
        windower.add_to_chat(100, " ")

        windower.add_to_chat(100, "//bt clear")
        windower.add_to_chat(100, "Clear the list")

    else
        windower.add_to_chat(207, "Invalid command. See //bt help for commands.")
    end
end

windower.register_event('addon command', handleCommand)

-----------------------------------------------------------------------------
-- Reload event for zone change
-----------------------------------------------------------------------------

windower.register_event('zone change', function(new_zone_id, old_zone_id)
end)
