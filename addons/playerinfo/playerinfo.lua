_addon.name = 'playerinfo'
_addon.author = 'Melucine@Bahamut'
_addon.version = '1.0.1'
 
texts = require('texts')
config = require('config')
 
--------------------------------------------------------------------------
-- Default Settings
--------------------------------------------------------------------------

default_settings = {
    bg = {
        alpha = 70,
    },
    text = {
        font = 'Consolas',  
        size = 10,
        bold = true,
    }
}

settings = config.load(default_settings)
text_box = texts.new(settings)
 
--------------------------------------------------------------------------
-- OnLoad event
--------------------------------------------------------------------------

windower.register_event('load', function()
    local main_color = '\\cs(255,170,0)'  -- Orange color
    local sub_color = '\\cs(255,0,0)'     -- Red color
    local player = windower.ffxi.get_player()

    jobinfo = ' ' ..
        main_color .. player.main_job .. ' ' .. player.main_job_level ..
        ' \\cr/ ' ..
        sub_color .. player.sub_job .. ' ' .. player.sub_job_level ..
        '\\cr'
    
    text_box:text(jobinfo)
    text_box:visible(true)
    
end)

--------------------------------------------------------------------------
-- UnLoad event
--------------------------------------------------------------------------

windower.register_event('unload', function()
    text_box:visible(false)
  end)