-- Custom Functions for RedProc in Abyssea
-- Set up texts element
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
send_command('bind f11 exec redproc')
-- ^ = CTRL, ! = ALT

--------------------------------------------------------------------------------------------
-- Main Functions
--------------------------------------------------------------------------------------------
RedProc_ind = 1

local allowd_zones = {
    'Abyssea - Tahrongi', 
    'Abyssea - La Theine', 
    'Abyssea - Konschtat', 
    'Abyssea - Attohwa', 
    'Abyssea - Misareaux', 
    'Abyssea - Vunkerl', 
    'Abyssea - Altepa',
    'Abyssea - Grauberg',
    'Abyssea - Uleguerand',
    'Abyssea - Empyreal Paradox',
}

local function in_allowed_zones()
    return T(allowd_zones):contains(world.area)
end

local ws_guide = {
    main = {},
    dagger = {
        wind = {'Cyclone'},
        dark = {'Energy Drain'}
    },
    sword = {
        fire = {'Red Lotus Blade'},
        light = {'Seraph Blade'}
    },
    greatsword = {
        ice = {'Freezebite'},
    },
    scythe = {
        dark = {'Shadow of Death'},
    },
    polearm = {
        lightning = {'Raiden Thrust'},
    },
    katana = {
        dark = {'Blade: Ei'},
    },
    greatkatana = {
        light = {'Tachi: Koki'},
        wind = {'Tachi: Jinpu'},
    },
    club = {
        light = {'Seraph Strike'},
    },
    staff = {
        light = {'Starburst'},
        earth = {'Earth Crusher'},
    },
}

local current_mode = "None"
local current_element = "Unknown"
local proc_status = false

windower.register_event('incoming text', function(original, modified)
    local pattern = "The fiend appears vulnerable to (%a+) elemental weapon skills!"
    local elemental_attribute = string.match(original, pattern)

    if elemental_attribute then
        update_mode(nil, elemental_attribute)
    end

    if original:contains("The fiend is frozen in its tracks.") then
        proc_status = true
        update_mode(nil, nil)
    end
end)

function update_mode(mode, element)
    if mode then
        local mode_display = mode:sub(1, 1):upper() .. mode:sub(2)
        current_mode = mode_display
    end
    
    if element then
        local element_display = element:sub(1, 1):upper() .. element:sub(2)
        current_element = element_display
    end
    
    local proc_display = tostring(proc_status):sub(1, 1):upper() .. tostring(proc_status):sub(2)
    
    msg_text:text('Red Proc Set\nMode: ' .. current_mode .. '\n------------------\nWeak To: ' .. current_element .. '\nProc Status: ' .. proc_display)
end

function self_command(command)
    command = command:lower() 
    if command == 'toggle redproc set' then 
        RedProc_ind = RedProc_ind + 1
        if RedProc_ind > #sets.RedProc.index then RedProc_ind = 1 end
        ChangeGear(sets.RedProc[sets.RedProc.index[RedProc_ind]])
        update_mode(sets.RedProc.index[RedProc_ind], nil) 
        local mode = sets.RedProc.index[RedProc_ind]
        add_to_chat(122, 'Mode: ' .. mode)
    elseif command == 'toggle mainset set' then 
        RedProc_ind = 1
        ChangeGear(sets.RedProc[sets.RedProc.index[RedProc_ind]])
        update_mode(sets.RedProc.index[RedProc_ind], nil)  
        local mode = sets.RedProc.index[RedProc_ind]
        add_to_chat(122, 'Mode: ' .. mode)
    elseif command:sub(1, 3) == 'ws ' then
        local element = command:sub(4)
        use_element_ws(element)
    elseif command == "hide" then
        msg_text:hide()
    end
end

function use_element_ws(element)
    local element_lower = element:lower()
    local current_mode = sets.RedProc.index[RedProc_ind]
    local current_mode_lower = current_mode:lower() 
    local ws_to_use = ws_guide[current_mode_lower][element_lower]

    if ws_to_use and #ws_to_use > 0 then
        send_command('input /ws "' .. ws_to_use[1] .. '" <t>') 
        update_mode(current_mode, element)  
    else
        add_to_chat(122, 'No valid weapon skill found for the current mode and element. ')
        add_to_chat(122, 'Please check selected Mode and Element.')
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
    sets.RedProc.index = { 'Main', 'Staff', 'Dagger', 'Sword', 'GreatSword', 'Scythe', 'Polearm', 'Katana', 'GreatKatana', 'Club' } 
    RedProc_ind = 1
     
    sets.RedProc.Main = {
        main="Kaja Knife",
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

    update_mode(sets.RedProc.index[RedProc_ind], nil)
end

--------------------------------------------------------------------------------------------
-- Display Texts box
--------------------------------------------------------------------------------------------
-- Display only inside Abyssea areas
--------------------------------------------------------------------------------------------
if in_allowed_zones() then
    msg_text:show()
else
    msg_text:hide()
end

--------------------------------------------------------------------------------------------
-- Reset values on zone change
--------------------------------------------------------------------------------------------

windower.register_event('zone change', function(new_zone_id, old_zone_id)
current_element = 'Unknown'
proc_status = false
update_mode(nil, nil)
end)

function file_unload()
    send_command('unbind f12')
    send_command('unbind ^f12')
    send_command('unbind f11')
end
