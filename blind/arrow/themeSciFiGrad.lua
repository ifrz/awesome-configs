local color      = require( "gears.color"    )
local surface    = require( "gears.surface"  )
local themeutils = require( "blind.common.drawing"    )
local blind      = require( "blind"          )
local radical    = require( "radical"        )
local debug      = debug
local cairo      = require( "lgi"            ).cairo
local pango      = require( "lgi"            ).Pango
local blind_pat  = require( "blind.common.pattern" )
local wibox_w    = require( "wibox.widget"   )
local debug      = debug

local path = debug.getinfo(1,"S").source:gsub("theme.*",""):gsub("@","")

local theme = blind.theme

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

------------------------------------------------------------------------------------------------------
--                                                                                                  --
--                                    DEFAULT COLORS, FONT AND SIZE                                 --
--                                                                                                  --
------------------------------------------------------------------------------------------------------

local default_height = 22--16

theme.default_height = default_height

local function d_mask(img,cr)
    return blind_pat.to_pattern(blind_pat.mask.ThreeD(img,cr))
end

theme.path = path

-- Background
theme.bg = blind {
    normal      = "#000000",
    focus       = "#496477",
    urgent      = "#5B0000",
    minimize    = "#040A1A",
    highlight   = "#0E2051",
    alternate   = "#081B37",
    allinone    = { type = "linear", from = { 0, 0 }, to = { 0, 20 }, stops = { { 0, "#1D4164" }, { 1, "#0D2144" }}},
}

-- Wibar background
local bargrad = { type = "linear", from = { 0, 0 }, to = { 0, 16 }, stops = { { 0, "#000000" }, { 1, "#040405" }}}
theme.bar_bg = blind {
    alternate = d_mask(blind_pat.mask.noise(0.04,"#AAAACC", blind_pat.sur.plain("#081B37",default_height))),
    normal    = d_mask(blind_pat.sur.flat_grad(bargrad,"#1C1C22",default_height)),
    buttons   = d_mask(blind_pat.sur.flat_grad("#00091A","#04204F",default_height)),
}

-- Forground
theme.fg = blind {
    normal   = "#6DA1D4",
    focus    = "#ABCCEA",
    urgent   = "#FF7777",
    minimize = "#1577D3",
}

-- Other
theme.awesome_icon         = path .."Icon/awesome2.png"
theme.systray_icon_spacing = 4
theme.button_bg_normal     = color.create_png_pattern(path .."Icon/bg/menu_bg_scifi.png"       )
theme.enable_glow          = true
theme.glow_color           = "#105A8B"
theme.naughty_bg           = theme.bg_alternate
theme.naughty_border_color = theme.fg_normal
theme.bg_dock              = color.create_png_pattern(path .."Icon/bg/bg_dock.png"             )
theme.fg_dock_1            = "#1889F2"
theme.fg_dock_2            = "#0A3E6E"
theme.bg_systray           = theme.fg_normal
theme.bg_resize_handler    = "#aaaaff55"

-- Border
theme.border = blind {
    width  = 1         ,
    normal = "#1F1F1F" ,
    focus  = "#535d6c" ,
    marked = "#91231c" ,
}

theme.alttab_icon_transformation = function(image,data,item)
--     return themeutils.desaturate(surface(image),1,theme.default_height,theme.default_height)
    return surface.tint(surface(image),color(theme.fg_normal),theme.default_height,theme.default_height)
end

theme.icon_grad        = d_mask(blind_pat.mask.noise(0.4,"#777788", blind_pat.sur.plain("#507289",default_height)))
theme.icon_mask        = { type = "linear", from = { 0, 0 }, to = { 0, 20 }, stops = { { 0, "#8AC2D5" }, { 1, "#3D619C" }}}
theme.icon_grad_invert = { type = "linear", from = { 0, 0 }, to = { 0, 20 }, stops = { { 0, "#000000" }, { 1, "#112543" }}}


-- Taglist
theme.taglist = blind {
    bg = blind {
        hover     = d_mask(blind_pat.sur.thick_stripe("#19324E","#132946",14,default_height,true)),
        selected  = d_mask(blind_pat.sur.thick_stripe("#0D3685","#05297F",4 ,default_height,true)),
        used      = d_mask(blind_pat.sur.flat_grad("#00143B","#052F77",default_height)),
        urgent    = d_mask(blind_pat.sur.flat_grad("#5B0000","#300000",default_height)),
        changed   = d_mask(blind_pat.sur.flat_grad("#4D004D","#210021",default_height)),
        empty     = d_mask(blind_pat.sur.flat_grad("#090B10","#181E39",default_height)),
        highlight = "#bbbb00"
    },
    fg = blind {
        selected  = "#ffffff",
        used      = "#7EA5E3",
        urgent    = "#FF7777",
        changed   = "#B78FEE",
        highlight = "#000000",
        prefix    = theme.bg_normal,
    },
    custom_color = function (...) d_mask(blind_pat.sur.flat_grad(...)) end,
    default_icon       = path .."Icon/tags/other.png",
}
theme.taglist_bg                 = d_mask(blind_pat.sur.plain("#070A0C",default_height))

-- Tasklist
theme.tasklist = blind {
    underlay_bg_urgent      = "#ff0000",
    underlay_bg_minimized   = "#4F269C",
    underlay_bg_focus       = "#0746B2",
    bg_image_selected       = d_mask(blind_pat.sur.flat_grad("#00091A","#04204F",default_height)),
    bg_minimized            = d_mask(blind_pat.sur.flat_grad("#0E0027","#04000E",default_height)),
    fg_minimized            = "#985FEE",
    bg_urgent               = d_mask(blind_pat.sur.flat_grad("#5B0000","#070016",default_height)),
    bg_hover                = d_mask(blind_pat.sur.thick_stripe("#19324E","#132946",14,default_height,true)),
    bg_focus                = d_mask(blind_pat.sur.flat_grad("#00143B","#052F77",default_height)),
    default_icon            = path .."Icon/tags/other.png",
    bg                      = "#00000088",
    icon_transformation     = loadfile(theme.path .."bits/icon_transformation/state.lua")(theme,path)
}


-- Menu
theme.menu = blind {
    submenu_icon = path .."Icon/tags/arrow.png",
    height       = 20,
    width        = 170,
    border_width = 2,
    opacity      = 0.9,
    fg_normal    = "#ffffff",
    bg_focus     = color.create_png_pattern(path .."Icon/bg/menu_bg_focus_scifi.png" ),
    bg_header    = color.create_png_pattern(path .."Icon/bg/menu_bg_header_scifi.png"),
    bg_normal    = color.create_png_pattern(path .."Icon/bg/menu_bg_scifi.png"       ),
    bg_highlight = color.create_png_pattern(path .."Icon/bg/menu_bg_highlight.png"   ),
    border_color = theme.fg_normal,
}

-- Shorter
theme.shorter = blind {
--     bg = blind_pat.to_pattern(blind_pat.mask.noise(0.14,"#AAAACC", blind_pat.mask.triangle(80,3,{color("#0D1E37"),color("#122848")},"#25324A",blind_pat.sur.plain("#081B37",80))))
    bg = blind_pat.to_pattern(blind_pat.mask.noise(0.14,"#AAAACC", blind_pat.mask.triangle(80,3,{color("#091629"),color("#0E2039")},"#25324A",blind_pat.sur.plain("#081B37",79))))
}

-- theme.draw_underlay = themeutils.draw_underlay


-- Titlebar
loadfile(theme.path .."bits/titlebar.lua")(theme,path)
theme.titlebar = blind {
    bg_normal = d_mask(blind_pat.mask.noise(0.02,"#AAAACC", blind_pat.sur.plain("#070A0C",default_height))),
    bg_focus  = d_mask(blind_pat.sur.flat_grad("#2A2A32",nil,default_height))
}

-- Layouts
loadfile(theme.path .."bits/layout.lua")(theme,path)

-- Textbox glow
loadfile(theme.path .."bits/textbox/glow.lua")(theme,path)

-- The separator theme
require( "chopped.arrow" )

-- Add round corner to floating clients
loadfile(theme.path .."bits/client_shape.lua")(3)

return theme
