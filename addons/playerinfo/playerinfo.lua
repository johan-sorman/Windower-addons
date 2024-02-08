_addon.name = 'playerinfo'
_addon.author = 'Melucine'
_addon.version = '1.0.0'
 
texts = require('texts')
config = require('config')
 
--------------------------------------------------------------------------
-- Default Settings
--------------------------------------------------------------------------

default_settings = {
    bg = {
        alpha = 100,
        padding = { top = 0, bottom = -5, left = 0, right = 0 }
    },
    padding = 0,
    text = {
        font = 'Consolas',  
        size = 10,
        bold = true,
        stroke = {
            width = 3,
            red = 0,
            green = 0,
            blue = 0,
            alpha = 255
        }
    }
}

settings = config.load(default_settings)
text_box = texts.new(settings)
 
--------------------------------------------------------------------------
-- OnLoad event
--------------------------------------------------------------------------

windower.register_event('load', function()
  local player = windower.ffxi.get_player()
  local new_text = player.main_job .. player.main_job_level ..'/' .. player.sub_job .. player.sub_job_level
  text_box:text(new_text)
  text_box:visible(true) -- Display the box with Job/SubJob
end)

--------------------------------------------------------------------------
-- UnLoad event
--------------------------------------------------------------------------

windower.register_event('unload', function()
    text_box:visible(false) -- Hide the textbox
  end)