<sup>**Author:** <br>[garyfromwork](https://github.com/garyfromwork/ffxi-windower/tree/master/VoidWalker), Updated by Melucine
<br>
**Version:** <br>1.2.0.0</sup>

```
Changes by Melucine:
- Reworked settings for texts module so they get imported from a separate file to make code more readable
- Reworked the texts element to display;
  General direction
  Which tier the NM is
  Traveled Distance
  Target Distance based on what the /heal responded with, and the general direction (repeated)
```


## VoidWalker

![demo](https://github.com/johan-sorman/Windower-addons/blob/main/addons/Voidwalker/demo-1.jpg?raw=true)




Overview: This Windower Addon tracks the distance you've traveled in yalms from the last place you /healed.
It is designed to more accurately track down Voidwalker NM distances. If you receive a reading with a distance and direction
the addon will also turn your character to face the appropriate direction.

Instructions for use: Create a folder in your Windower/Addons directory named VoidWalker, then paste in the VoidWalker.lua.
In game type //lua l voidwalker, this loads the addon in game. To confirm it's working, simply /heal in game then start walking.

Addon commands:
  //vw help (displays all commands for the addon, currently only "on/off"
  //vw on/off this turns on or off the distance tracking. When //vw off the distance counter won't increase while moving.

To unload the addon: //lua u voidwalker

Please enjoy!
