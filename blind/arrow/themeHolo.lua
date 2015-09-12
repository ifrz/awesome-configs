local color      = require( "gears.color"    )
local surface    = require( "gears.surface"  )
local themeutils = require( "blind.common.drawing"    )
local blind      = require( "blind"          )
local radical    = require( "radical"        )
local blind_pat  = require( "blind.common.pattern" )
local debug      = debug

local path = debug.getinfo(1,"S").source:gsub("theme.*",""):gsub("@","")

local theme = blind.theme

local function d_mask(img,cr)
    return blind_pat.to_pattern(img,cr)
end

------------------------------------------------------------------------------------------------------
--                                                                                                  --
--                                    DEFAULT COLORS, FONT AND SIZE                                 --
--                                                                                                  --
------------------------------------------------------------------------------------------------------
--------//--

themes_dir                          = os.getenv("HOME") .. "/.config/awesome/themes/powerarrow-darker"
theme.wallpaper                     = themes_dir .. "/wall.png"
theme.font                          = "Drift 10"

theme.arrl                          = themes_dir .. "/icons/arrl.png"
theme.arrl_dl                       = themes_dir .. "/icons/arrl_dl_sf.png"
theme.arrl_ld                       = themes_dir .. "/icons/arrl_ld_sf.png"

theme.arrl2                          = themes_dir .. "/icons/arrl_sf.png"

theme.arrl_dl_b                       = themes_dir .. "/icons/arrl_dl_sf_big.png"
theme.arrl_ld_b                       = themes_dir .. "/icons/arrl_ld_sf_big.png"

theme.system                     = themes_dir .. "/icons/system.png"
theme.off                     = themes_dir .. "/icons/poweroff.png"

theme.widget_ac                     = themes_dir .. "/icons/ac.png"
theme.widget_battery                = themes_dir .. "/icons/battery.png"
theme.widget_battery_low            = themes_dir .. "/icons/battery_low.png"
theme.widget_battery_empty          = themes_dir .. "/icons/battery_empty.png"
theme.widget_mem                    = themes_dir .. "/icons/mem.png"
theme.widget_cpu                    = themes_dir .. "/icons/cpu.png"
theme.widget_temp                   = themes_dir .. "/icons/temp.png"
theme.widget_net                    = themes_dir .. "/icons/net.png"
theme.widget_hdd                    = themes_dir .. "/icons/hdd.png"
theme.widget_music                  = themes_dir .. "/icons/note.png"
theme.widget_music_on               = themes_dir .. "/icons/note_on.png"
theme.widget_vol                    = themes_dir .. "/icons/vol.png"
theme.widget_vol_low                = themes_dir .. "/icons/vol_low.png"
theme.widget_vol_no                 = themes_dir .. "/icons/vol_no.png"
theme.widget_vol_mute               = themes_dir .. "/icons/vol_mute.png"
theme.widget_mail                   = themes_dir .. "/icons/mail.png"
theme.widget_mail_on                = themes_dir .. "/icons/mail_on.png"
theme.widget_awesome                = themes_dir .. "/icons/awesome_icon.png"
--theme.lock			                = themes_dir .. "/icons/lock.png"

theme.layout_tile                   = "/usr/share/awesome/themes/zenburn/layouts/tile.png"
theme.layout_tilegaps               = "/usr/share/awesome/themes/zenburn/layouts/tilegaps.png"
theme.layout_tileleft               = "/usr/share/awesome/themes/zenburn/layouts/tileleft.png"
theme.layout_tilebottom             = "/usr/share/awesome/themes/zenburn/layouts/tilebottom.png"
theme.layout_tiletop                = "/usr/share/awesome/themes/zenburn/layouts/tiletop.png"
theme.layout_fairv                  = "/usr/share/awesome/themes/zenburn/layouts/fairv.png"
theme.layout_fairh                  = "/usr/share/awesome/themes/zenburn/layouts/fairh.png"
theme.layout_spiral                 = "/usr/share/awesome/themes/zenburn/layouts/spiral.png"
theme.layout_dwindle                = "/usr/share/awesome/themes/zenburn/layouts/dwindle.png"
theme.layout_max                    = "/usr/share/awesome/themes/zenburn/layouts/max.png"
theme.layout_fullscreen             = "/usr/share/awesome/themes/zenburn/layouts/fullscreen.png"
theme.layout_magnifier              = "/usr/share/awesome/themes/zenburn/layouts/magnifier.png"
theme.layout_floating               = "/usr/share/awesome/themes/zenburn/layouts/floating.png"

theme.arr1                                      = themes_dir .. "/icons/color/arr1.png"
theme.arr2                                      = themes_dir .. "/icons/color/arr2.png"
theme.arr3                                      = themes_dir .. "/icons/color/arr3.png"
theme.arr4                                      = themes_dir .. "/icons/color/arr4.png"
theme.arr5                                      = themes_dir .. "/icons/color/arr5.png"
theme.arr6                                      = themes_dir .. "/icons/color/arr6.png"
theme.arr7                                      = themes_dir .. "/icons/color/arr7.png"
theme.arr8                                      = themes_dir .. "/icons/color/arr8.png"
theme.arr9                                      = themes_dir .. "/icons/color/arr9.png"
theme.arr0                                      = themes_dir .. "/icons/color/arr0.png"


 -- theme.awful_widget_height	= 14
  --theme.awful_widget_margin_top	= 2
-------//--

local default_height = 22--18
theme.default_height = default_height
theme.font           = "Sans DemiBold 8"
theme.path           = path

theme.bg = blind {
    normal      = "#000000",
    focus       = "#496477",
    urgent      = "#5B0000",
    minimize    = "#040A1A",
    highlight   = "#0E2051",
    alternate   = "#18191B",
    allinone    = "#0F2650"
}

theme.fg = blind {
    normal   = "#4197D4",
    focus    = "#ABCCEA",
    urgent   = "#FF7777",
    minimize = "#1577D3",
}

theme.bg_systray     = "#1590D7"


theme.button_bg_normal            = color.create_png_pattern(path .."Icon/bg/menu_bg_scifi.png"       )

--theme.border_width  = "1"
--theme.border_normal = "#555555"
--theme.border_focus  = "#535d6c"
--theme.border_marked = "#91231c"

theme.border_width   = "0"
theme.border_normal  = "#1F1F1F"
theme.border_focus   = "#535d6c"
theme.border_marked  = "#91231c"
theme.enable_glow    = false
theme.glow_color     = "#105A8B"

theme.alttab_icon_transformation = function(image,data,item)
--     return themeutils.desaturate(surface(image),1,theme.default_height,theme.default_height)
    return surface.tint(surface(image),color(theme.fg_normal),theme.default_height,theme.default_height)
end

theme.icon_grad        = "#1590D7"
theme.icon_mask        = "#2A72A5"
-- theme.icon_grad        = "#14617A"
-- theme.icon_mask        = "#2EACDA"
theme.icon_grad_invert = { type = "linear", from = { 0, 0 }, to = { 0, 20 }, stops = { { 0, "#000000" }, { 1, "#112543" }}}

theme.bottom_menu_item_style = radical.item.style.slice_prefix


------------------------------------------------------------------------------------------------------
--                                                                                                  --
--                                       TAGLIST/TASKLIST                                           --
--                                                                                                  --
------------------------------------------------------------------------------------------------------

-- Display the taglist squares
-- theme.taglist_underline                = "#094CA5"

theme.taglist = blind {

    bg = blind {
        hover     = "#91D1FF",
        selected  = "#00A6FF",
        used      = "#123995",
        urgent    = "#ff0000",
        changed   = "#95127D",
--         empty     = d_mask(blind_pat.sur.flat_grad("#090B10","#181E39",default_height)),
        highlight = "#bbbb00"
    },

    fg = blind {
        selected  = "#ffffff",
--         used      = "#7EA5E3",
        urgent    = "#FF7777",
        changed   = "#B78FEE",
        highlight = "#000000",
        prefix    = theme.bg_normal,
    },

    default = blind {
        item_margins = {
            LEFT   = 3,
            RIGHT  = 4,
            TOP    = 2,
            BOTTOM = 6,
        },
        margins = {
            LEFT   = 2,
            RIGHT  = 20,
            TOP    = 0,
            BOTTOM = 1,
        },
    },

--     default_icon = path .."Icon/tags/other.png",
    disable_icon  = true,
    disable_index = true,
    spacing      = 2,
    item_style   = radical.item.style.holo,
--     icon_transformation = function(image,data,item)
--         return color.apply_mask(image,color("#8186C3"))
--     end
}

theme.tasklist = blind {
    item_style              = radical.item.style.holo_top,

    bg = blind {
        urgent         = "#D30000",
        hover          = "#91D1FF",
        focus          = "#00A6FF",
        image_selected = path .."Icon/bg/selected_bg_scifi.png",
        minimized      = "#200058",
    },

    underlay_bg = blind {
        urgent    = "#ff0000",
        minimized = "#4F269C",
        focus     = "#0746B2",
    },

    default = blind {
        item_margins = {
            LEFT   = 8,
            RIGHT  = 4,
            TOP    = 6,
            BOTTOM = 2,
        },
        margins = {
            LEFT   = 7,
            RIGHT  = 7,
            TOP    = 1,
            BOTTOM = 0,
        },
    },

    fg_minimized        = "#985FEE",
    default_icon        = path .."Icon/tags/other.png",
    spacing             = 4,
    disable_icon        = true,
    plain_task_name     = true,
    icon_transformation = loadfile(theme.path .."bits/icon_transformation/state.lua")(theme,path)
}


------------------------------------------------------------------------------------------------------
--                                                                                                  --
--                                               MENU                                               --
--                                                                                                  --
------------------------------------------------------------------------------------------------------

theme.border_width              = 1
theme.border_color              = theme.fg_normal
theme.awesome_icon              = path .."Icon/awesome2.png"
theme.bg_dock                   = "#000000"
theme.fg_dock_1                 = "#1889F2"
theme.fg_dock_2                 = "#0A3E6E"
theme.dock_corner_radius        = 4

theme.draw_underlay = themeutils.draw_underlay

theme.menu = blind {
    submenu_icon         = path .."Icon/tags/arrow.png",
    height               = 20,
    width                = 170,
    border_width         = 2,
    opacity              = 0.9,
    fg_normal            = "#ffffff",
    corner_radius        = 5,
    border_color         = "#252525",
    outline_color        = "#B7B7B7",
    table_bg_header      = "#999999",
    checkbox_style       = "holo",

    bg = blind {
        focus     = "#14617A",
        header    = "#1A1A1A",
        normal    = "#1A1A1A",
        highlight = "#252525",
    }
}


------------------------------------------------------------------------------------------------------
--                                                                                                  --
--                                             TITLEBAR                                             --
--                                                                                                  --
------------------------------------------------------------------------------------------------------

-- Titlebar
loadfile(theme.path .."bits/titlebar_minde.lua")(theme,path)
theme.titlebar = blind {
    bg_normal = "#000000",
    bg_focus  = "#184E99",
    fg_focus  = "#ffffff",
}

-- Layouts
loadfile(theme.path .."bits/layout.lua")(theme,path)



------------------------------------------------------------------------------------------------------
--                                                                                                  --
--                                               DOCK                                               --
--                                                                                                  --
------------------------------------------------------------------------------------------------------

theme.dock_icon_transformation = function(image,data,item) return surface.outline( surface(image), theme.icon_grad) end


require( "chopped.slice" )

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
