--[[
                                             
     Powerarrow Darker Awesome WM config 2.0 
     github.com/copycat-killer               
                                             
--]]

theme                               = {}

themes_dir                          = os.getenv("HOME") .. "/.config/awesome/themes/powerarrow-darker"
theme.wallpaper                     = themes_dir .. "/wall.png"

theme.font                          = "Terminus (TTF) 9"
theme.fg_normal                     = "#DDDDFF"
theme.fg_focus                      = "#F0DFAF"
theme.fg_urgent                     = "#CC9393"
theme.bg_normal                     = "#1A1A1A"
theme.bg_focus                      = "#313131"
theme.bg_urgent                     = "#1A1A1A"
theme.border_width                  = "1"
theme.border_normal                 = "#3F3F3F"
theme.border_focus                  = "#7F7F7F"
theme.border_marked                 = "#CC9393"
theme.titlebar_bg_focus             = "#39374D"
theme.titlebar_bg_normal            = "#282735"
theme.taglist_fg_focus              = "#D8D782"
theme.tasklist_bg_focus             = "#1A1A1A"
theme.tasklist_fg_focus             = "#D8D782"
theme.textbox_widget_margin_top     = 1
theme.notify_fg                     = theme.fg_normal
theme.notify_bg                     = theme.bg_normal
theme.notify_border                 = theme.border_focus
theme.awful_widget_height           = 14
theme.awful_widget_margin_top       = 2
theme.mouse_finder_color            = "#CC9393"
theme.menu_height                   = "16"
theme.menu_width                    = "140"

theme.submenu_icon                  = themes_dir .. "/icons/submenu.png"
theme.taglist_squares_sel           = themes_dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel         = themes_dir .. "/icons/square_unsel.png"

theme.layout_tile                   = themes_dir .. "/icons/tile.png"
theme.layout_tilegaps               = themes_dir .. "/icons/tilegaps.png"
theme.layout_tileleft               = themes_dir .. "/icons/tileleft.png"
theme.layout_tilebottom             = themes_dir .. "/icons/tilebottom.png"
theme.layout_tiletop                = themes_dir .. "/icons/tiletop.png"
theme.layout_fairv                  = themes_dir .. "/icons/fairv.png"
theme.layout_fairh                  = themes_dir .. "/icons/fairh.png"
theme.layout_spiral                 = themes_dir .. "/icons/spiral.png"
theme.layout_dwindle                = themes_dir .. "/icons/dwindle.png"
theme.layout_max                    = themes_dir .. "/icons/max.png"
theme.layout_fullscreen             = themes_dir .. "/icons/fullscreen.png"
theme.layout_magnifier              = themes_dir .. "/icons/magnifier.png"
theme.layout_floating               = themes_dir .. "/icons/floating.png"

theme.arrl                          = themes_dir .. "/icons/arrl.png"
theme.arrl_dl                       = themes_dir .. "/icons/arrl_dl_sf.png"
theme.arrl_ld                       = themes_dir .. "/icons/arrl_ld_sf.png"

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

theme.tasklist_disable_icon         = true
theme.tasklist_floating             = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical   = ""

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

theme.titlebar_close_button_focus               = themes_dir .. "/close_focus.png"
theme.titlebar_close_button_normal              = themes_dir .. "/close_normal.png"


---
theme.blingbling = {
background_color = "#00000000",
rounded_size = 0,
text_color = "#C7C2D9",
font = "Monospace",
font_size = 9
}

theme.blingbling.tagslist = {}
theme.blingbling.tagslist.normal ={ background_color = "#555766",
text_background_color = "#00000000", --no color
rounded_size = { 0, 0.4,0,0.4 },
text_color = theme.fg_normal,
font = "Envy Code R Bold",
font_size = 9
}

theme.blingbling.tagslist.focus = { h_margin = 1,
v_margin = 1,
background_color = red,
text_background_color = "#555766",
text_color = theme.fg_normal,
rounded_size = { 0, 0.4,0,0.4 },
font = "Envy Code R Bold italic",
font_size = 9
}


theme.blingbling.tagslist.urgent = theme.blingbling.tagslist.focus
theme.blingbling.tagslist.occupied = theme.blingbling.tagslist.normal

---

return theme
