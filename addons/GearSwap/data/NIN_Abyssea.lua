texts = require('texts')

local msg_text = texts.new('', {
    pos = { x = 10, y = 90 }, 
    text = { size = 11, font = 'Consolas', alpha = 255, stroke = { width = 2, color = 0x000000 } }, 
    bg = { visible = true, alpha = 120 },
    padding = 5, 
})

--------------------------------------------------------------------------------------------
-- Set Keybinds
--------------------------------------------------------------------------------------------
send_command('bind f12 gs c toggle MainSet set')
send_command('bind ^f12 gs c toggle RedProc set')
-- ^ = CTRL, ! = ALT

--------------------------------------------------------------------------------------------
-- Welcome Message
--------------------------------------------------------------------------------------------
local player_name = player.name
local main_job = player.main_job
local sub_job = player.sub_job
local main_job_level = player.main_job_level
local sub_job_level = player.sub_job_level

add_to_chat(122, 'Welcome, ' .. player_name ..'')
add_to_chat(122, 'Loaded Abyssea Lua!')
add_to_chat(122, 'Current Job: ' .. main_job .. main_job_level .. '/' .. sub_job .. sub_job_level .. '')

--------------------------------------------------------------------------------------------
-- Main Functions
--------------------------------------------------------------------------------------------
RedProc_ind = 1
wsProc = false

function update_mode()
    local mode = sets.RedProc.index[RedProc_ind]
    local element_guide = {
        Wind = {'Dagger', 'Great Katana'},
        Fire = {'Sword'},
        Ice = {'Great Sword'},
        Lightning = {'Polearm'},
        Earth = {'Staff'},
        Darkness = {'Scythe', 'Katana', 'Dagger'},
        Light = {'Club', 'Great Katana', 'Sword', 'Staff'},
    }

    local ws_guide = {
        Dagger = {'Cyclone (Wind)', 'Energy Drain (Dark)'},
        Sword = {'Red Lotus Blade (Fire)', 'Seraph Blade (Light)'},
        GreatSword = {'Freezebite (Ice)'},
        Scythe = {'Shadow of Death (Dark)'},
        Polearm = {'Raiden Thrust (Lightning)'},
        Katana = {'Blade: Ei (Dark)'},
        GreatKatana = {'Tachi: Jinpu (Wind)', 'Tachi: Koki (Light)'},
        Club = {'Seraph Strike (Light)'},
        Staff = {'Earth Crusher (Earth)', 'Sunburst (Light)'},

    }

    local elements = {}
    for element, weapons in pairs(element_guide) do
        local weapons_str = table.concat(weapons, ', ')
        local ws_str = ''
        for _, weapon in ipairs(weapons) do
            if ws_guide[weapon] then
                ws_str = ws_str .. weapon .. ' ' .. table.concat(ws_guide[weapon], ', ') .. ', '
            end
        end
        ws_str = ws_str:gsub(', $', '') 
        elements[#elements + 1] = element .. ': (' .. weapons_str .. ')'
    end
    local element_text = table.concat(elements, '\n')

    local ws_elements = {}
    for weapon, wss in pairs(ws_guide) do
        ws_elements[#ws_elements + 1] = weapon .. ' - ' .. table.concat(wss, ', ') .. ''
    end
    local ws_text = table.concat(ws_elements, '\n')

    if wsProc then
        msg_text:text('Red Proc Set\nMode: ' .. mode .. '\n-------------------------------------------------------------\nElement Guide:\n' .. element_text .. '\n-------------------------------------------------------------\nWeapon Skills:\n' .. ws_text .. '')
    else
        msg_text:text('Red Proc Set\nMode: ' .. mode .. '\n')
    end

end



function self_command(command)
    if command == 'toggle RedProc set' then
        RedProc_ind = RedProc_ind + 1
        if RedProc_ind > #sets.RedProc.index then RedProc_ind = 1 end
        ChangeGear(sets.RedProc[sets.RedProc.index[RedProc_ind]])
        update_mode()  
    elseif command == 'toggle MainSet set' then
        RedProc_ind = 1
        ChangeGear(sets.RedProc[sets.RedProc.index[RedProc_ind]])
        update_mode()  
    elseif command == 'toggle ws set' then
        wsProc = not wsProc 
        update_mode()  
    end
end


function ChangeGear(GearSet)
    equipSet = GearSet
    equip(GearSet)
end

--------------------------------------------------------------------------------------------
-- Get Sets
--------------------------------------------------------------------------------------------
function get_sets()
    sets.RedProc = {}
    sets.RedProc.index = { 'MainSet', 'Staff', 'Dagger', 'Sword', 'GreatSword', 'Scythe', 'Polearm', 'Katana', 'GreatKatana', 'Club' } 
    RedProc_ind = 1
     
    sets.RedProc.MainSet = {
        main={ name="Aizushintogo", augments={'DMG:+15','STR+15','Attack+15',}},
        sub={ name="Aizushintogo", augments={'DMG:+15','STR+15','Accuracy+10',}}
    }
    sets.RedProc.Staff = {main="Lamia staff"}
    sets.RedProc.Dagger = {main="Wind knife"}
    sets.RedProc.Sword = {main="firetongue"}
    sets.RedProc.GreatSword = {main="Goujian"}
    sets.RedProc.Scythe = {main="Ark scythe"}
    sets.RedProc.Polearm = {main="tzee xicu's blade"}
    sets.RedProc.Katana = {main="Yagyu Shortblade"}
    sets.RedProc.GreatKatana = {main="Zanmato"}
    sets.RedProc.Club = {main="ash club"}

    update_mode()
end

--------------------------------------------------------------------------------------------
-- Display Texts box
--------------------------------------------------------------------------------------------
msg_text:show()

function file_unload()
    send_command('unbind f12')
    send_command('unbind ^f12')
end
