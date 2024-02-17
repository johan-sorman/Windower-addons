--[[
Copyright © 2022, 2024, Kwech of Bahamut, Melucine of Bahamut
All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of "Trove" or "Trove-HUD" nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Kwech BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]

_addon.name = 'Trove'
_addon.author = 'Melucine@Bahamut'
_addon.version = '1.1'
_addon.command = 'trove'
_addon.description = 'Core functionality based off Kwech addon, "Trove-HUD", will display a on-screen suggestion to which chest to open'

-- local packets = require('packets')
require('logger')
res = require('resources')

local iPosition_x = 250
local iPosition_y = 150
local offSet = 48

local seed = {}
local r = 0
local cIterator = 0

local allowed_zones = {
    ['Horlais Peak'] = true,
    ['Waughroon Shrine'] = true,
    ['Balga\'s Dais'] = true,
}

windower.register_event('load', function()
    math.randomseed(os.time())
    local zone_id = windower.ffxi.get_info().zone
    local zone_name = res.zones[zone_id] and res.zones[zone_id].name or 'Unknown'
                
    if allowed_zones[zone_name] then
        createAddonElements()
		windower.add_to_chat(100, string.format('\30\03[%s]\30\01 //trove help for assistance.', 'Trove'))
    end
end)

windower.register_event('zone change', function(new_zone_id)
    local zone_name = res.zones[new_zone_id] and res.zones[new_zone_id].name or 'Unknown'
    if allowed_zones[zone_name] then
		windower.add_to_chat(100, string.format('\30\03[%s]\30\01 //trove help for assistance.', 'Trove'))
        createAddonElements()
    else
        hideAddonElements()
    end
end)

function hideAddonElements()
    for i = 1, 10 do
        windower.prim.set_visibility('chest ' .. i, false)
        windower.prim.set_visibility('chest glow ' .. i, false)
        windower.prim.set_visibility('chest open ' .. i, false)
    end
end


function createAddonElements()
    for i = 1, 5, 1 do
        windower.prim.create('chest ' .. i)
        windower.prim.set_color('chest ' .. i, 255, 255, 255, 255)
        windower.prim.set_fit_to_texture('chest ' .. i, false)
        windower.prim.set_texture('chest ' .. i, windower.addon_path .. 'assets/chest.png')
        windower.prim.set_repeat('chest ' .. i,1,1)
        windower.prim.set_visibility('chest ' .. i,true)
        windower.prim.set_position('chest ' .. i, iPosition_x + offSet*(i), iPosition_y)
        windower.prim.set_size('chest ' .. i, 48, 48)
    end
    
    for i = 6, 10, 1 do
        windower.prim.create('chest ' .. i)
        windower.prim.set_color('chest ' .. i, 255, 255, 255, 255)
        windower.prim.set_fit_to_texture('chest ' .. i, false)
        windower.prim.set_texture('chest ' .. i, windower.addon_path .. 'assets/chest.png')
        windower.prim.set_repeat('chest ' .. i,1,1)
        windower.prim.set_visibility('chest ' .. i,true)
        windower.prim.set_position('chest ' .. i, iPosition_x + offSet*(i-5), iPosition_y+80)
        windower.prim.set_size('chest ' .. i, 48, 48)
    end
    
    for i = 1, 5, 1 do
        windower.prim.create('chest glow ' .. i)
        windower.prim.set_color('chest glow ' .. i, 255, 255, 255, 255)
        windower.prim.set_fit_to_texture('chest glow ' .. i, false)
        windower.prim.set_texture('chest glow ' .. i, windower.addon_path .. 'assets/chest glow.png')
        windower.prim.set_repeat('chest glow ' .. i,1,1)
        windower.prim.set_visibility('chest glow ' .. i,false)
        windower.prim.set_position('chest glow ' .. i, iPosition_x + offSet*(i), iPosition_y)
        windower.prim.set_size('chest glow ' .. i, 48,48)
    end
    
    for i = 6, 10, 1 do
        windower.prim.create('chest glow ' .. i)
        windower.prim.set_color('chest glow ' .. i, 255, 255, 255, 255)
        windower.prim.set_fit_to_texture('chest glow ' .. i, false)
        windower.prim.set_texture('chest glow ' .. i, windower.addon_path .. 'assets/chest glow.png')
        windower.prim.set_repeat('chest glow ' .. i,1,1)
        windower.prim.set_visibility('chest glow ' .. i,false)
        windower.prim.set_position('chest glow ' .. i, iPosition_x + offSet*(i-5), iPosition_y+80)
        windower.prim.set_size('chest glow ' .. i, 48, 48)
    end
    
    for i = 1, 5, 1 do
        windower.prim.create('chest open ' .. i)
        windower.prim.set_color('chest open ' .. i, 255, 255, 255, 255)
        windower.prim.set_fit_to_texture('chest open ' .. i, false)
        windower.prim.set_texture('chest open ' .. i, windower.addon_path .. 'assets/chest open.png')
        windower.prim.set_repeat('chest open ' .. i,1,1)
        windower.prim.set_visibility('chest open ' .. i,false)
        windower.prim.set_position('chest open ' .. i, iPosition_x + offSet*(i), iPosition_y)
        windower.prim.set_size('chest open ' .. i, 48, 48)
    end
    
    for i = 6, 10, 1 do
        windower.prim.create('chest open ' .. i)
        windower.prim.set_color('chest open ' .. i, 255, 255, 255, 255)
        windower.prim.set_fit_to_texture('chest open ' .. i, false)
        windower.prim.set_texture('chest open ' .. i, windower.addon_path .. 'assets/chest open.png')
        windower.prim.set_repeat('chest open ' .. i,1,1)
        windower.prim.set_visibility('chest open ' .. i,false)
        windower.prim.set_position('chest open ' .. i, iPosition_x + offSet*(i-5), iPosition_y+80)
        windower.prim.set_size('chest open ' .. i, 48, 48)
    end

    r = math.random(1,10)
    r = math.random(1,10)
    r = math.random(1,10)
    seed[0] = r
    r = math.random(1,10)
    
    for i = 1, 9, 1 do
        while contains(seed, r) do
            r = math.random(1,10)
        end
        seed[i] = r
    end
    
    windower.prim.set_visibility('chest glow ' .. seed[0],true)
end

windower.register_event('addon command', function(...)
    local args = T{...}
    local cmd = args[1]

    if cmd == 'next' then
        nextChest()
    end
    
    if cmd == 'reset' then
        resetChests()
    end

    if cmd == 'mars' then
        windower.send_command('input /targetnpc')
        windower.send_command('input /item "Mars Orb" <t>')
    end
    if cmd == 'venus' then
        windower.send_command('input /targetnpc')
        windower.send_command('input /item "Venus Orb" <t>')
    end

    if cmd == 'help' then
        log('Usage:')
        log('//trove next - Suggests next chest to open')
        log('//trove reset - Reset chest suggestion')
        log('//trove mars - Trade Mars Orb')
        log('//trove venus - Trade Venus Orb')
        log('//trove help - This message')
    end
    
end)

function nextChest()
    if cIterator < 8 then
        windower.prim.set_visibility('chest ' .. seed[cIterator],false)
        windower.prim.set_visibility('chest glow ' .. seed[cIterator],false)
        windower.prim.set_visibility('chest open ' .. seed[cIterator],true)
        cIterator = cIterator + 1
        if cIterator ~= 8 then
            windower.prim.set_visibility('chest glow ' .. seed[cIterator],true)
        end
    end
end

function resetChests()
    for i = 1, 10, 1 do
        windower.prim.set_visibility('chest ' .. i,true)
        windower.prim.set_visibility('chest glow ' .. i,false)
        windower.prim.set_visibility('chest open ' .. i,false)
    end
    
    seed = {}
    
    r = math.random(1,10)
    r = math.random(1,10)
    r = math.random(1,10)
    seed[0] = r
    r = math.random(1,10)
    
    for i = 1, 9, 1 do
        while contains(seed, r) do
            r = math.random(1,10)
        end
        seed[i] = r
    end
    
    cIterator = 0
    
    windower.prim.set_visibility('chest glow ' .. seed[0],true)
end

function contains(table, val)
    for i=0,#table do
        if table[i] == val then 
            return true
        end
    end
    return false
end

function delete()
end

windower.register_event('unload',function()
end)
