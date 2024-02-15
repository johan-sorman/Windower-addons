--------------------------------------------------------------------------------------------
-- Custom Functions for RedProc in Abyssea
-- It's not compatable with Mote includes, suggestion is keep it in a seperate GS profile
--------------------------------------------------------------------------------------------
-- Set up texts element
--------------------------------------------------------------------------------------------

texts = require('texts')
local msg_text = texts.new('', {
    pos = { x = 400, y = 450 }, 
    text = { size = 11, font = 'Consolas', alpha = 255 }, 
    bg = { visible = true, alpha = 90 },
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

local player_name= player.name
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

function update_mode()
    local mode = sets.RedProc.index[RedProc_ind]
    msg_text:text('Red Proc Set\n----------------\n' .. 'Mode: ' .. mode .. '\n----------------')
    windower.add_to_chat(100, 'RedProc: ' .. mode ..'')
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
    send_command('unbind ^`')   
    send_command('unbind !=')
    send_command('unbind ^[')
    send_command('unbind ![')
    send_command('unbind @f9')
    send_command('unbind @w')
end