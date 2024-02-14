local defaults = {}

defaults.main = {
    pos = {
        x = 180,
        y = 765
    },
    text = {
        font = 'Consolas',
        size = 12,
        bold = true,
        stroke = {
            alpha = 255,
            red = 0,
            green = 0,
            blue = 0,
            width = 2
        }
    },
    flags = {
        draggable = true,
        bold = true
    },
    bg = {
        alpha = 128,
        red = 0,
        green = 0,
        blue = 0,
        visible = true
    }
}

defaults.marktxt = {
    pos = {
        x = 180,
        y = 765
    },
    text = {
        font = 'Consolas',
        size = 12,
        bold = true,
        stroke = {
            alpha = 255,
            red = 0,
            green = 0,
            blue = 0,
            width = 1
        }
    },
    flags = {
        bold = true,
        draggable = true
    },
    padding = 1,
    bg = {
        alpha = 128,
        red = 0,
        green = 0,
        blue = 0,
        visible = true
    }
}

return defaults
