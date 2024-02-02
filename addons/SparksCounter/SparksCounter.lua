_addon.name = 'SparksCounter'
_addon.author = 'Dean James (Xurion of Bismarck), Melucine@Bahamut'
_addon.version = '1.1.0'

texts = require('texts')
config = require('config')
packets = require('packets')

settings = config.load({
  bg = {
    alpha = 125
  },
  padding = 1,
  text = {
    font = 'Consolas',  
    size = 10        
  }
})
text_box = texts.new(settings)


sparks_packet_id = 0x110

function init()
  local sparks_count = get_sparks()
  regenerate_text(sparks_count, 99999)
end

function comma_value(n) --credit http://richard.warburton.it
  local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
  return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

windower.register_event('load', function()
  if windower.ffxi.get_player() ~= nil then
    init()
  end
end)

windower.register_event('login', init)

windower.register_event('logout', function()
  text_box:hide()
end)

function regenerate_text(sparks_count, sparks_max)
  local normal = '\\cs(255,255,255)'
  local warning = '\\cs(255,170,0)'
  local danger = '\\cs(255,0,0)'

  local text = 'Sparks: '

  if sparks_max == sparks_count then
    text = text .. danger
  elseif sparks_max - sparks_count < 10000 then
    text = text .. warning
  else
    text = text .. normal
  end

  text = text .. comma_value(sparks_count) .. '\\cr'

  text_box:text(text)
  text_box:show()
end

function get_sparks_value_from_packet(packet)
  local parsed = packets.parse('incoming', packet)
  local total_sparks = 0
  if parsed['_unknown1'] == 1 then --This field is used to determine if your sparks are over 65,536. If so, the 'Sparks Total' field is only the value above that.
    total_sparks = 65536
  end
  total_sparks = total_sparks + parsed['Sparks Total']
  return total_sparks
end

function get_sparks()
  local sparks_packet = windower.packets.last_incoming(sparks_packet_id)
  if sparks_packet == nil then
    return 0
  else
    return get_sparks_value_from_packet(sparks_packet)
  end
end

windower.register_event('incoming chunk', function(id, packet)
  if id == sparks_packet_id then
    init()
  end
end)
