_addon.name = 'Currencies'
_addon.author = 'Ivaar, Modified by Melucine'
_addon.version = '0.0.0.4'
_addon.commands = {'currencies','curr'}

require('lists')
require('logger')
packets = require('packets')

texts = require('texts')
config = require('config')

default_settings = {
    text = {
        font = 'Consolas', size = 11, bold = true
    },
    bg = {
        visible = true, alpha = 80
    }, 
}

settings = config.load(default_settings)
text_box = texts.new(settings)


text_box:visible(false)

local log_results
local player_name = windower.ffxi.get_info().logged_in and windower.ffxi.get_player().name
local check = {}
local requests = {
    [0x113] = packets.new('outgoing', 0x10F),
    [0x118] = packets.new('outgoing', 0x115),
}

function comma_value(n)
    local left, num, right = string.match(n, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1,'):reverse()) .. right
end

windower.register_event('incoming chunk', function(id, data)
    if check[id] then
        local header_length = #('Currency Request for ' .. player_name .. ':') * 1
        local separator_line = string.rep('-', header_length)
        local packet = packets.parse('incoming', data)
        local results = 'Currency Request for ' .. player_name .. ':\n' .. separator_line .. '\n'

        for field in check[id]:it() do
            local msg = '%s: [%s]\n':format(field, comma_value(packet[field]))
            results = results .. msg 
        end

        results = results .. separator_line .. '\n'

        if log_results then
            -- log(results)
        else
            windower.send_ipc_message(results)
        end

        text_box:text(results)
        text_box:visible(true)

        check[id] = nil
    end
end)


local function search_fields(terms)
    terms = terms:split('|'):map(string.gsub - {'[%s%p]', '.*'} .. string.lower)

    if windower.ffxi.get_info().logged_in then
        check = {}
        local results

        for id, packet in pairs(requests) do
            local fields = packets.fields('incoming', id)

            for field in fields:it() do
                if field.type ~= 'data' then
                    local str = field.label:gsub('[%s%p]', ''):lower()

                    for term in terms:it() do
                        if str:find(term) then
                            check[id] = check[id] or L{}
                            check[id]:append(field.label)
                        end
                    end
                end
            end

            if check[id] then
                packets.inject(packet)
                results = true
            end
        end
        return results
    end
end

windower.register_event('addon command', function(...)
    local commands = T{...}
    commands[1] = commands[1] and commands[1]:lower() or 'help'

    if commands[1] == 'help' then
        log('Command: //curr [all] <search term>')
        log(' Use | to seperate search terms')
        log(' e.g. //curr seals //curr beads|silt')
        log(' Use //curr hide to hide UI box')
        log(' Use //curr show to display UI box again')
        return
    end

    if commands[1] == 'hide' then
        text_box:visible(false)
    end

    if commands[1] == 'show' then
        text_box:visible(true)
    end

    local send_all

    if commands[1] == 'all' then
        commands:remove(1)
        send_all = true
    end

    local term = commands:concat(' ')

    log_results = true

    if not search_fields(term) then
        -- error('No currencies matching: %s':format(term))
        return
    end

    if not send_all then return end

    windower.send_ipc_message('check %s':format(term))
end)

windower.register_event('ipc message', function(msg)
    if msg:sub(1, 5) == 'check' then
        log_results = false
        search_fields(msg:sub(7))
    elseif log_results then
        log(msg)
    end
end)

windower.register_event('login', function(name)
    player_name = name
end)
