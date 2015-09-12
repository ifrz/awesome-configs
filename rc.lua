--[[
                                             
     Powerarrow Darker Awesome WM config 2.0 
     github.com/copycat-killer               
                                             
--]]

-- {{{ Required libraries
local gears     = require("gears")
local awful     = require("awful")
awful.rules     = require("awful.rules")
                  require("awful.autofocus")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local drop      = require("scratchdrop")
local lain      = require("lain")
-- }}}

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Autostart applications
function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
     findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

run_once("urxvtd")
run_once("unclutter")
-- }}}

-- {{{ Variable definitions
-- localization
os.setlocale(os.getenv("LANG"))


--------------------------
---/////////////

local config = require( "forgotten"   )

-- Theme handling library
local blind     = require( "blind"     )

local rad_taglist  = require( "radical.impl.taglist"       )
local rad_tag      = require( "radical.impl.common.tag"    )
local rad_task     = require( "radical.impl.tasklist"      )

-- Various configuration options
config.showTitleBar  = false
config.themeName     = "arrow"
config.noNotifyPopup = true
config.useListPrefix = true
config.deviceOnDesk  = true
config.desktopIcon   = true
config.advTermTB     = true
config.scriptPath    = awful.util.getdir("config") .. "/Scripts/"
config.scr           = {
    pri         = 1,
    sec         = 3,
    music       = 4,
    irc         = 2,
    media       = 5,
}


config.load()
config.themePath = awful.util.getdir("config") .. "/blind/" .. config.themeName .. "/"
config.iconPath  = config.themePath       .. "Icon/"
beautiful.init(config.themePath                .. "/themeZilla.lua")


--------------------------

-- beautiful init
--beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/powerarrow-darker/theme.lua")

-- common
modkey     = "Mod4"
altkey     = "Mod1"
terminal   = "urxvtc" or "xterm"
editor     = os.getenv("EDITOR") or "nano" or "vi"
editor_cmd = terminal .. " -e " .. editor

-- user defined
terminal2  = "terminology"
browser    = "luakit"
gui_editor = "geany"
graphics   = "gimp"
mail       = terminal .. " -e mutt "
iptraf     = terminal .. " -g 180x54-20+34 -e sudo iptraf-ng -i all "
musicplr   = terminal .. " -g 130x34-320+16 -e ncmpcpp "

local layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
}
-- }}}

--------- other tags
local blingbling = require("blingbling")

mytaglist = {}

mytaglist.buttons = awful.util.table.join(
	awful.button({ }, 1, awful.tag.viewonly),
	awful.button({ modkey }, 1, awful.client.movetotag),
	awful.button({ }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, awful.client.toggletag),
	awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
	awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
---------

-- {{{ Tags

tags = {
   names = { "Web", "Shell", "Devel", "Files", "Misc"},
   names2 = {"Shell", "Files"},
   layout = { layouts[1], layouts[2], layouts[3], layouts[4], layouts[5] },
   layout2 = {layouts[1], layouts[2]}
}

--mytag = {}

--for s = 1, screen.count() do
--   mytag[1] = blingbling.tagslist(1, awful.widget.taglist.filter.all, mytaglist.buttons)
   tags[1] = awful.tag(tags.names, 1, tags.layout)
   tags[2] = awful.tag(tags.names2, 2, tags.layout2)
--end
-- }}}

awful.tag.seticon("/home/ivan/.config/awesome/blind/arrow/Icon/tags/net.png",tags[1][1])
awful.tag.seticon("/home/ivan/.config/awesome/blind/arrow/Icon/tags/term.png",tags[1][2])
awful.tag.seticon("/home/ivan/.config/awesome/blind/arrow/Icon/tags/icon-develop.png",tags[1][3])
awful.tag.seticon("/home/ivan/.config/awesome/blind/arrow/Icon/tags/folder.png",tags[1][4])
awful.tag.seticon("/home/ivan/.config/awesome/blind/arrow/Icon/tags/other.png",tags[1][5])
awful.tag.seticon("/home/ivan/.config/awesome/blind/arrow/Icon/tags/term.png",tags[2][1])
awful.tag.seticon("/home/ivan/.config/awesome/blind/arrow/Icon/tags/folder.png",tags[2][2])

-------
--local aux
local function show_net_info(widget)
  local ip_addr
  local gateway
  local all_infos=awful.util.pread("ip route show")
  
      ip_addr=string.match(string.match(all_infos,"%ssrc%s[%d]+%.[d%]+%.[%d]+%.[%d]+"), "[%d]+%.[d%]+%.[%d]+%.[%d]+")
      --get gateway
      gateway= string.match(string.match(all_infos,"default%svia%s[%d]+%.[d%]+%.[%d]+%.[%d]+"), "[%d]+%.[d%]+%.[%d]+%.[%d]+")
      --get external ip configuration
      local ext_ip = 'n/a'--awful.util.pread("wget http://checkip.dyndns.org -O - -q | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'")
      --if time out then no external ip
      if string.match(ext_ip,"timed%sout%!") then
        ext_ip = "n/a" 
	  end
      widget:set_markup(string.format('<span font_desc="Envy Code R italic" color="#7E7E7E">Local IP: </span>'..ip_addr..'\n<span font_desc="Envy Code R italic" color="#7E7E7E">Gateway: </span>'.. gateway ..'\n<span font_desc="Envy Code R italic" color="#7E7E7E">External IP: </span>'..ext_ip))

end
----------------------------------------------------------------Radical

local widget2      = require( "awful.widget")
local menu = require( "radical.context")
local radical = require("radical")
local vicious = require("vicious")


------------------global-menu-------------------

    local gMenu = radical.context {
        style       = radical.style.arrow      ,
     --   item_style  = radical.item.style.arrow_single ,
        item_height = 140,
        width       = 200,
        height      = 140,
     --   border_width = 4,
        border_color = '#88aa00ff',
        layout      = radical.layout.horizontal,    
    }

-------------------  CPU

----

    top_widget = wibox.widget.textbox()
 --   vicious.cache(vicious.widgets.top)
 --   vicious.register(top_widget, vicious.widgets.top,'${title}\n${p1}\n${p2}\n${p3}\n${p4}\n${p5}' , 4)

-----


--- layout
    local vertical_cpu = wibox.layout.fixed.vertical()	
    local margin_cpu = wibox.layout.margin()
    local horizontal_avg = wibox.layout.flex.horizontal()	
    
--- avg - info
	local cpu_str = string.format('<span font_desc="Envy Code R italic">Intel(R) Core(TM) i3-2328M CPU @ 2.20GHz\n</span>')
	cpu_info = wibox.widget.textbox()
	cpu_info:set_markup(cpu_str)
  	horizontal_avg:add(cpu_info)
--- top
 -- 	horizontal_avg:add(top_widget)

--- add to layout
	vertical_cpu:add(horizontal_avg)
	vertical_cpu:add(top_widget)
	margin_cpu:set_margins(3)
	margin_cpu:set_top(8)
    margin_cpu:set_widget(vertical_cpu)
 --   gMenu:add_widget(margin_cpu)--, {width = 194})                               

------------------- CPU

    local wMenu = radical.context {
        style       = radical.style.arrow      ,
     --   item_style  = radical.item.style.arrow_alt ,
        item_height = 50,
        width       = 200,
        height      = 100,
  --      border_width = 4,
        layout      = radical.layout.vertical,    
    }
    
    
--- layout
    local vertical = wibox.layout.fixed.vertical()	
    local margin = wibox.layout.margin()
    local vertical2 = wibox.layout.fixed.vertical()	
    local hor = wibox.layout.fixed.horizontal()

--	margin:set_bottom(8)
--	margin:set_top(4)
--   margin:set_widget(vertical)
	local title = string.format('<span font_desc="Neuropol 10" color="#88aa00">Wifi:</span>')
	local wifi = wibox.widget.textbox()
--	wifi:set_markup(cpu_str)
	
    local wifiwidget = wibox.widget.textbox()
 --   vicious.cache(vicious.widgets.wifi)
    vicious.register(wifiwidget, vicious.widgets.wifi,'<span font_desc="Envy Code R italic" color="#7E7E7E">SSID:</span> ${ssid}\n<span font_desc="Envy Code R italic" color="#7E7E7E">Signal:</span> ${sign} dBm' , 10, "wlan1")
    local wifiwidget2 = wibox.widget.textbox()
    vicious.register(wifiwidget2, vicious.widgets.wifi,'\n\n<span font_desc="Envy Code R italic" color="#7E7E7E"> Rate:</span> ${rate}M' , 10, "wlan0")

    local rx = wibox.widget.textbox()
    local tx = wibox.widget.textbox()
  --  vicious.cache(vicious.widgets.net)

    vicious.register (rx, vicious.widgets.net, '<span font_desc="Envy Code R italic 8" rise="-2000" color="#7E7E7E">Rx: ${wlan1 rx_mb} MB</span>', 15)
    vicious.register (tx, vicious.widgets.net, '<span font_desc="Envy Code R italic 8" rise="2000" color="#7E7E7E">Tx: ${wlan1 tx_mb} MB</span>', 15)

    wifi:set_markup(title)
    vertical2:add(wifi)
	vertical:add(wifiwidget2)
	vertical:add(tx)
	vertical2:add(wifiwidget)
	vertical2:add(rx)
	
    local ip = wibox.widget.textbox()
    local txt = wibox.widget.textbox()
    txt:set_markup(string.format('<span font_desc="Neuropol 10" color="#88aa00">Network:</span>'))
  --  show_net_info(ip)
	--ip:set_markup(string.format(aux))
--	vertical2:add(txt)
--	vertical2:add(ip)
hor:add(vertical2)
hor:add(vertical)
    wMenu:add_widget(hor, {width = 200})   
    wMenu:add_widget(txt, {width = 120})                                                           
  --  wMenu:add_widget(ip, {width = 120})                                                           
  --  wMenu:add_widget(rx, {width = 160})                               
  --  wMenu:add_widget(tx, {width = 160})                               

------------------global-menu-------------------

-------

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Menu
mymainmenu = awful.menu.new({ items = require("menugen").build_menu(),
                              theme = { height = 16, width = 130 }})
-- }}}

-- {{{ Wibox
markup = lain.util.markup

-- Textclock
clockicon = wibox.widget.imagebox(beautiful.widget_clock)
mytextclock = awful.widget.textclock(" %a %d %b  %H:%M")

-- calendar
lain.widgets.calendar:attach(mytextclock, { font_size = 10, font = "DejaVu Sans Mono" })

-- MEM
memicon = wibox.widget.imagebox(beautiful.widget_mem)
memwidget = lain.widgets.mem({
    settings = function()
        widget:set_text(" " .. mem_now.used .. "MB ")
    end
})

	local circle = blingbling.wlourf_circle_graph({radius= 8, height = 24, width = 38, show_text = true, label = "ram", h_margin = 2, v_margin = 0 --[[, font = {family = "Times New Roman", slang = "italic", weight = "bold"}]]})
	circle:set_graph_colors({{"#88aa00ff",0}, --all value > 0 will be displayed using this color
                       {"#d4aa00ff", 0.5},
                       {"#d45500ff",0.77}})

	vicious.register(circle, vicious.widgets.mem,'$1',50) ---here

---------------------------

 cpu_graph2 = blingbling.line_graph({ height = 22,
                                        width = 82,
                                        show_text = true,
                                        label = "CPU: $percent%",
                                        rounded_size = 0.3,
                                        v_margin = 0, 
                                        h_margin = 0,
                                        font_size = 8,
                                --        graph_background_color = "#000000FF"
                                      })

--cpu_icon = wibox.widget.imagebox()
--cpu_icon:set_image(beautiful.cpu)
--cpu_graph2:set_background_color("#000000FF")
vicious.cache(vicious.widgets.cpu)
vicious.register(cpu_graph2, vicious.widgets.cpu,'$1',2)

cpuwidget = wibox.widget.background(cpu_graph2)--, "#313131")

---------------------------

------------
local info_menu = require("info_menu")
------------

-- CPU
cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)

-- Coretemp
tempicon = wibox.widget.imagebox(beautiful.widget_temp)
tempwidget = lain.widgets.temp({
    settings = function()
        widget:set_text(" " .. coretemp_now .. "°C ")
    end
})

-- / fs
fsicon = wibox.widget.imagebox(beautiful.widget_hdd)

----


	local disk = require("disk")

	-- the first argument is the widget to trigger the diskusage
	-- the second/third is the percentage at which a line gets orange/red
    -- true = show only local filesystems

    local dMenu = radical.context {
        style       = radical.style.arrow      ,
        item_style  = radical.item.style.classic ,
        item_height = 120,
        width       = 270,
      --  height      = 120,
      --  border_width = 4,
        layout      = radical.layout.horizontal,    
    }

    local vertical_hdd = wibox.layout.fixed.vertical()	
    local margin_hdd = wibox.layout.margin()

    hdd_use = wibox.widget.textbox()
    disk.addToWidget(hdd_use, 75, 90, false)
--- add to layout
	vertical_hdd:add(hdd_use)
	margin_hdd:set_margins(3)
	margin_hdd:set_top(8)
    margin_hdd:set_widget(vertical_hdd)
    dMenu:add_widget(hdd_use, {width = 270})  
    
----r
	local hdd = blingbling.wlourf_circle_graph({radius= 8, height = 32, width = 38, show_text = true, label = "fs /", h_margin = 4, v_margin = 0 --[[, font = {family = "Times New Roman", slang = "italic", weight = "bold"}]]})
	hdd:set_graph_colors({{"#88aa00ff",0}, --all value > 0 will be displayed using this color
                       {"#d4aa00ff", 0.5},
                       {"#d45500ff",0.77}})

	vicious.register(hdd, vicious.widgets.fs, "${/ used_p}", 120 )
--	hdd:set_label("$percent%")

--hdd_bg = wibox.widget.background(hdd)--, "#313131")

--hdd_bg:fit(52, 14)

--vicious.register(fs_usage, vicious.widgets.fs, "${/ used_p}", 120 )

--fswidget = lain.widgets.fs({
--    settings  = function()
--        widget:set_text(" " .. fs_now.used .. "% ")
--    end
--})

home_fs_usage = wibox.widget.textbox()
vicious.register(home_fs_usage, vicious.widgets.fs, "${/ used_gb}GB", 120 )

fswidgetbg2 = wibox.widget.background(home_fs_usage, "#313131")

hdd:set_menu(dMenu,1)
fswidgetbg = wibox.widget.background(fs_usage, "#313131")

-- Battery
baticon = wibox.widget.imagebox(beautiful.widget_battery)
batwidget = lain.widgets.bat({
    settings = function()
        if bat_now.perc == "N/A" then
            widget:set_markup(" AC ")
            baticon:set_image(beautiful.widget_ac)
            return
        elseif tonumber(bat_now.perc) <= 5 then
            baticon:set_image(beautiful.widget_battery_empty)
        elseif tonumber(bat_now.perc) <= 15 then
            baticon:set_image(beautiful.widget_battery_low)
        else
            baticon:set_image(beautiful.widget_battery)
        end
        widget:set_markup(" " .. bat_now.perc .. "% ")
    end
})

volicon = wibox.widget.imagebox(beautiful.widget_vol)
volume_master = blingbling.volume({height = 18, width = 40, bar =true, show_text = true, label ="$percent%"})
--volume_master:update_master()
--volume_master:set_master_control()

--volumewidget = lain.widgets.alsa({
  --  settings = function()
 --       if volume_now.status == "off" then
  --          volicon:set_image(beautiful.widget_vol_mute)
 --       elseif tonumber(volume_now.level) == 0 then
 --           volicon:set_image(beautiful.widget_vol_no)
 --       elseif tonumber(volume_now.level) <= 50 then
 --           volicon:set_image(beautiful.widget_vol_low)
 --       else
 --           volicon:set_image(beautiful.widget_vol)
 --       end

--        widget:set_text(" " .. volume_now.level .. "% ")
--    end
--})

-- Net
neticon = wibox.widget.imagebox(beautiful.widget_net)
neticon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(iptraf) end)))

netwid = blingbling.net({interface = "wlan1", show_text = true})
netwidget = wibox.widget.background(netwid, "#313131")
--netwidget = wibox.widget.background(lain.widgets.net({
--    settings = function()
--        widget:set_markup(markup("#7AC82E", " " .. net_now.received)
--                          .. " " ..
--                          markup("#46A8C3", " " .. net_now.sent .. " "))
--    end
--}), "#313131")
neticon:set_menu(wMenu,1)

-- Separators
spr = wibox.widget.textbox()
spr:set_markup(string.format('<span color="#7E7E7E" font_desc="Sans 8"> :: </span>'))
spr2 = wibox.widget.textbox()
spr2:set_markup(string.format('<span color="#7E7E7E" font_desc="Sans 8">  :: </span>'))
arrl = wibox.widget.imagebox()
arrl2 = wibox.widget.imagebox()
arrl:set_image(beautiful.arrl)
arrl2:set_image(beautiful.arrl2)
arrl_dl = wibox.widget.imagebox()
arrl_dl:set_image(beautiful.arrl_dl)
arrl_ld = wibox.widget.imagebox()
arrl_ld:set_image(beautiful.arrl_ld)

arrl_dl_big = wibox.widget.imagebox()
arrl_ld_big = wibox.widget.imagebox()
arrl_ld_big:set_image(beautiful.arrl_ld_b)
arrl_dl_big:set_image(beautiful.arrl_dl_b)

-- Create a wibox for each screen and add it
mywibox = {}
-----------------
mybottomwibox = {}
-----------------
mypromptbox = {}
mylayoutbox = {}
--mytaglist = {}
--mytaglist.buttons = awful.util.table.join(
--                    awful.button({ }, 1, awful.tag.viewonly),
--                    awful.button({ modkey }, 1, awful.client.movetotag),
--                    awful.button({ }, 3, awful.tag.viewtoggle),
--                    awful.button({ modkey }, 3, awful.client.toggletag),
--                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
--                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
--                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))


for s = 1, screen.count() do

    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()

    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                            awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                            awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                            awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                            awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    -- Create a taglist widget
    mybottomwibox[s] = awful.wibox({ position = "bottom", screen = s, height=beautiful.default_height, bg = beautiful.bar_bg_normal or beautiful.bg_normal })--, ontop = true})--, bg = "#1A1A1A"})
    -- mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
--
	
--
    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
 --   mywibox[s] = awful.wibox({ position = "top", screen = s, height = 18 })
    mywibox[s] = awful.wibox({ position = "top", screen = s, height=beautiful.default_height, bg = beautiful.bar_bg_normal or beautiful.bg_normal })
end

mylauncher = awful.widget.launcher({ image = beautiful.widget_awesome,
                                     menu = mymainmenu })
mylauncher2 = awful.widget.launcher({ image = beautiful.widget_awesome,
                                     menu = mymainmenu })
                                     
                                     
    -- Widgets that are aligned to the upper left
    local left_layout1 = wibox.layout.fixed.horizontal()
    local left_layout2 = wibox.layout.fixed.horizontal()
--
    left_layout1:add(mylauncher)
    left_layout2:add(mylauncher2)
--
  --  left_layout:add(spr)
  --  left_layout:add(mytaglist[s])
--    left_layout:add(wibox.layout.margin(mytag[s],0,0,2,2))
    left_layout1:add(rad_taglist(1)._internal.margin)
    left_layout2:add(rad_taglist(2)._internal.margin)
--tmp--
	addicon = wibox.widget.imagebox()
	addicon:set_image(themes_dir .. "/icons/add.png")
	addicon:buttons(awful.util.table.join(
		awful.button({ }, 1, function()
			if not awful.tag.gettags(2)[3] then
				awful.tag.viewonly(awful.tag.add("Virt",{screen= (mouse.screen)}))
			else
				if not awful.tag.gettags(2)[4] then
					awful.tag.viewonly(awful.tag.add("Media",{screen= (mouse.screen)})) 	
				end	
			end	
        end)
	))
	left_layout2:add(addicon)
	delicon = wibox.widget.imagebox()
	delicon:set_image(themes_dir .. "/icons/del.png")
	delicon:buttons(awful.util.table.join(
		awful.button({ }, 1, function()
            awful.tag.delete(client.focus and awful.tag.selected(client.focus.screen) or awful.tag.selected(mouse.screen)) end)
	))
	local lmar = wibox.layout.margin()
	lmar:set_left(2)
	lmar:set_widget(delicon)
	left_layout2:add(lmar)
--tmp--
    left_layout1:add(mypromptbox[1])
    left_layout2:add(mypromptbox[2])
   -- left_layout:add(spr)

    -- Widgets that are aligned to the upper right
    -- If you are moving widgets from a section with light grey background to dark grey or vice versa,
    -- use a replacement icon as appropriate from themes/powerarrow-darker/alticons so your icons match the bg.
    ----
    local right_layout1 = wibox.layout.fixed.horizontal()--{height=20})
    local right_layout2 = wibox.layout.fixed.horizontal()--{height=20})
  --  right_layout:set_max_widget_size (18)

  --  local const = wibox.layout.constraint()
   -- const:set_strategy("exact")                              
--	const:set_height(20)
--	const:set_widget(cpuwidget)
    ----
  --  if s == 1 then 
    right_layout1:add(wibox.widget.systray()) --end
  --  right_layout:add(spr)------------
  --  right_layout:add(arrl)-----------
  local lmar000 = wibox.layout.margin()
	lmar000:set_top(2)
	lmar000:set_bottom(2)
	lmar000:set_widget(arrl2)
--    right_layout:add(arrl)--_ld)
 --   right_layout:add(mpdicon)
  --  right_layout:add(mpdwidgetbg)
 --   right_layout:add(arrl_ld)---------------
  --  right_layout:add(volicon)
   -- right_layout:add(volumewidget)
  --  right_layout:add(arrl_ld)
  --  right_layout:add(mailicon)
    --right_layout:add(mailwidget)
 --   right_layout:add(lmar000)--_dl)--------------
--	local lmar = wibox.layout.margin()
--	local lmar1 = wibox.layout.margin()

--	local lmar3 = wibox.layout.margin()
--	lmar3:set_top(2)
--	lmar3:set_bottom(2)
--	lmar3:set_widget(tempicon)
--    right_layout2:add(lmar3)
    ----------------
   -- tempbg = wibox.widget.background()
--    tempbg:set_bgimage(themes_dir .. "/icons/bg2.png")
  --  tempbg:set_widget(tempwidget)
--  	local lmar4 = wibox.layout.margin()
--	lmar4:set_top(3)
--	lmar4:set_bottom(3)
--	lmar4:set_widget(wibox.widget.background(tempwidget, "#3e414e"))
    right_layout2:add(tempwidget)
    ----------------
    --right_layout:add(tempwidget)
  --  right_layout:add(lmar20)-----------
   right_layout2:add(spr)
   
--	local lmar00 = wibox.layout.margin()

--	local lmar20 = wibox.layout.margin()
--	lmar20:set_top(3)
--	lmar20:set_bottom(3)
--	lmar20:set_widget(arrl_ld)    
  --  right_layout:add(lmar20)---------------
--	lmar00:set_top(2)
--	lmar00:set_bottom(2)	
--	lmar00:set_widget(cpuicon)
 --   right_layout2:add(lmar00)
    -------------
  --  cpubg = wibox.widget.background()
  --  cpubg:set_bgimage(themes_dir .. "/icons/bg1.png")
  --  cpubg:set_widget(cpuwidget)
  --  right_layout:add(const)
    -------------
--    local lmar2 = wibox.layout.margin()
--	lmar2:set_top(3)
--	lmar2:set_bottom(3)
 --	lmar2:set_widget(cpuwidget)
    right_layout2:add(cpuwidget)
--   	local lmar21 = wibox.layout.margin()
--	lmar21:set_top(3)
--	lmar21:set_bottom(3)
--	lmar21:set_widget(arrl_dl)    
--    right_layout:add(lmar21)
--    right_layout:add(arrl_dl)---------
	right_layout2:add(spr2)
	
     -- 	local lmar0 = wibox.layout.margin()
--	lmar:set_top(3)
--	lmar:set_bottom(3)
--	lmar:set_widget(wibox.widget.background(memwidget, "#3e414eb3"))
--	lmar0:set_top(2)
--	lmar0:set_bottom(2)
--	lmar0:set_widget(memicon)
--	lmar1:set_top(3)
--	lmar1:set_bottom(3)
--	lmar1:set_widget(wibox.widget.background(circle, "#3e414eb3"))
  --  right_layout2:add(lmar0)---------------
    right_layout2:add(circle)
    right_layout2:add(memwidget)
    right_layout2:add(spr)
    
 --  	local lmar4 = wibox.layout.margin()
  --  lmar4:set_top(2)
	--lmar4:set_bottom(2)
	--lmar4:set_widget(fsicon)
  --  right_layout2:add(lmar4)
 --   local lmar5 = wibox.layout.margin()
--	lmar5:set_top(3)
--	lmar5:set_bottom(3)
--	lmar5:set_widget(wibox.widget.background(hdd, "#313131"))
    right_layout2:add(hdd)
    right_layout2:add(home_fs_usage)
    right_layout2:add(spr)
--	local label = wibox.widget.textbox()
--	label:set_markup(string.format('<span color="#88aa00" font_desc="Sans 8">eth0</span>'))
--	local vlay = wibox.layout.fixed.vertical()
--	vlay:add(label)
--	right_layout2:add(label)
    right_layout2:add(rx)
    right_layout2:add(wibox.widget.imagebox(beautiful.widget_net))
    right_layout2:add(tx)
    right_layout2:add(spr)
  -- 	local lmar6 = wibox.layout.margin()
--	lmar6:set_top(3)
--	lmar6:set_bottom(3)
--	lmar6:set_widget(hdd)    
 --   right_layout:add(lmar6)
  --  right_layout:add(lmar21)--------------
  --  local lmar7 = wibox.layout.margin()
	--lmar7:set_top(2)
	--lmar7:set_bottom(2)
	--lmar7:set_widget(baticon)    
  --  right_layout:add(lmar7)
 --   local lmar8 = wibox.layout.margin()
--	lmar8:set_top(3)
--	lmar8:set_bottom(3)
--	lmar8:set_widget(wibox.widget.background(batwidget, "#3e414e"))    
  --  right_layout:add(batwidget)
 --  right_layout:add(lmar20)-------------
 -- right_layout:add(spr)
  --  local lmar9 = wibox.layout.margin()
	--lmar9:set_top(2)
	--lmar9:set_bottom(2)
	--lmar9:set_widget(neticon) 
   -- right_layout1:add(lmar9)
  --  local lmar10 = wibox.layout.margin()
--	lmar10:set_top(3)
--	lmar10:set_bottom(3)
--	lmar10:set_widget(netwidget)    
    right_layout1:add(netwid)
 --   right_layout:add(arrl_dl_big)------------
  right_layout1:add(spr)
    right_layout1:add(mytextclock)
      right_layout1:add(spr)
 --   right_layout:add(spr)-----------
 --   right_layout:add(arrl_ld_big)----------------
    right_layout1:add(mylayoutbox[1])
    right_layout2:add(mylayoutbox[2])

    -- Now bring it all together (with the tasklist in the middle)
    local layout1 = wibox.layout.align.horizontal()
    layout1:set_left(left_layout1)
  --  layout:set_middle(mytasklist[s])
  --    layout:set_middle(rad_task(s or 1)._internal.margin
   -- local right_layout2 = wibox.layout.fixed.horizontal({height=20})

    layout1:set_right(right_layout1)
    
    local layout2 = wibox.layout.align.horizontal()
    layout2:set_left(left_layout2)
    layout2:set_right(right_layout2)
    
    mywibox[1]:set_widget(layout1)
    mywibox[2]:set_widget(layout2)

	udisks_glue = blingbling.udisks_glue.new({ menu_icon = themes_dir .. "/icons/usb.png"})
--	udisks_glue:set_mount_icon(beautiful.widget_mem)
--	udisks_glue:set_umount_icon(beautiful.widget_mem)
--	udisks_glue:set_detach_icon(beautiful.widget_mem)
--	udisks_glue:set_Usb_icon(beautiful.widget_mem)
--	udisks_glue:set_Cdrom_icon(beautiful.widget_mem)
 
    local bottom_layout1 = wibox.layout.align.horizontal()
    local bottom_layout2 = wibox.layout.align.horizontal()

    local bottom_left_layout = wibox.layout.fixed.horizontal()
    local bottom_right_layout = wibox.layout.fixed.horizontal()

---------

    local m_fav = radical.context {
        style      = radical.style.classic      ,
        item_style = radical.item.style.arrow_prefix ,
        item_height = 36,--48,
        width = 240,
        layout = radical.layout.vertical, --horizontal,
        border_width = 4,
        border_color = "#88aa00",	
        item_layout = radical.layout.centerred    
    }
    
 
    m_fav:add_item {icon=themes_dir .. "/icons/luakit.png", text='<span font_desc="Neuropol">Luakit</span>\n<span color="#7E7E7E" font_desc="Sans Italic 7">Fast and lightweight web browser</span>'}
    m_fav:add_item {icon=themes_dir .. "/icons/geany.svg", text='<span font_desc="Neuropol">Geany</span>\n<span color="#7E7E7E" font_desc="Sans Italic 7">Lightweight cross-platform text editor</span>'}
    m_fav:add_item {icon=themes_dir .. "/icons/xterm_48x48.svg", text='<span font_desc="Neuropol">XTerm</span>\n<span color="#7E7E7E" font_desc="Sans Italic 7">The standard terminal for the X</span>'}
    m_fav:add_item {icon=themes_dir .. "/icons/terminator.svg", text='<span font_desc="Neuropol">Terminology</span>\n<span color="#7E7E7E" font_desc="Sans Italic 7">Fancy EFL based terminal</span>'}
    
   	fav_widget = wibox.widget.imagebox()
	fav_widget:set_image(themes_dir .. "/icons/fav.png")
    fav_widget:set_menu(m_fav,1)
	
------------------------------------------------------------------------------------------------
--local function internal_vol(uuid, action)
--	os.execute("udisks --" .. action .. " /dev/disk/by-uuid/" .. uuid)
--	naughty.notify({title = action ..":", text = uuid, timeout = 10})
--	return
--end 
---------
--function generate_menu(diskmenu)
--diskmenu = {
--   {"Almaceamento", {{"mount", internal_vol("46F5643B42C1A798", "mount")}, 
--					{"umount", internal_vol("46F5643B42C1A798", "unmount")}}},-- 46F5643B42C1A798
--   {"Novo_volume", {{"mount", internal_vol("36d7de8f-07ec-4ce5-b39e-dad49b25b257", "mount")},
--					{"umount", internal_vol("36d7de8f-07ec-4ce5-b39e-dad49b25b257", "unmount")}}},-- 36d7de8f-07ec-4ce5-b39e-dad49b25b257
--   {"Sistema de 250.1GB", os.execute("udisks --mount /dev/disk/by-uuid/7562FDC86F40B2BE")}, -- 7562FDC86F40B2BE
--   {"Fedora 18", os.execute("udisks --mount /dev/disk/by-uuid/e37a0bf8-0922-4337-8ef7-136eadcaa3c8")}, -- e37a0bf8-0922-4337-8ef7-136eadcaa3c8
--   {"Sistema de 93.8GB", os.execute("udisks --mount /dev/disk/by-uuid/203EB7903EB75E0A")},	-- 203EB7903EB75E0A
--   {"System Reserved", os.execute("udisks --mount /dev/disk/by-uuid/D2B2A6B4B2A69C8B")} 		-- D2B2A6B4B2A69C8B
--}
--	return diskmenu
--end
--mount_1 = internal_vol("46F5643B42C1A798", "mount")
--mount_2 = internal_vol("36d7de8f-07ec-4ce5-b39e-dad49b25b257", "mount")


diskmenu = {
	{"Almaceamento", {{"mount", function () os.execute("udisks --mount /dev/disk/by-uuid/46F5643B42C1A798")
						   naughty.notify({title = "Mount: Almaceamento", text = "/media/46F5643B42C1A798", timeout = 10}) end},
					 {"unmount", function () os.execute("udisks --unmount /dev/disk/by-uuid/46F5643B42C1A798")
						   naughty.notify({title = "Unmount: Almaceamento", text = "/media/46F5643B42C1A798", timeout = 10}) end}}},
	{"Novo_volume", {{"mount", function () os.execute("udisks --mount /dev/disk/by-uuid/36d7de8f-07ec-4ce5-b39e-dad49b25b257")
						   naughty.notify({title = "Mount: Novo_volume", text = "/media/36d7de8f-07ec-4ce5-b39e-dad49b25b257", timeout = 10}) end},
					 {"unmount", function () os.execute("udisks --unmount /dev/disk/by-uuid/36d7de8f-07ec-4ce5-b39e-dad49b25b257")
						   naughty.notify({title = "Unmount: Novo_volume", text = "/media/36d7de8f-07ec-4ce5-b39e-dad49b25b257", timeout = 10}) end}}},
	{"Sistema de 250.1GB", {{"mount", function () os.execute("udisks --mount /dev/disk/by-uuid/7562FDC86F40B2BE")
						   naughty.notify({title = "Mount: Sistema de 250.1GB", text = "/media/7562FDC86F40B2BE", timeout = 10}) end},
					 {"unmount", function () os.execute("udisks --unmount /dev/disk/by-uuid/7562FDC86F40B2BE")
						   naughty.notify({title = "Unmount: Sistema de 250.1GB", text = "/media/7562FDC86F40B2BE", timeout = 10}) end}}},
	{"Fedora 18", {{"mount", function () os.execute("udisks --mount /dev/disk/by-uuid/e37a0bf8-0922-4337-8ef7-136eadcaa3c8")
						   naughty.notify({title = "Mount: Fedora 18", text = "/media/e37a0bf8-0922-4337-8ef7-136eadcaa3c8", timeout = 10}) end},
					 {"unmount", function () os.execute("udisks --unmount /dev/disk/by-uuid/e37a0bf8-0922-4337-8ef7-136eadcaa3c8")
						   naughty.notify({title = "Unmount: Fedora 18", text = "/media/e37a0bf8-0922-4337-8ef7-136eadcaa3c8", timeout = 10}) end}}},
	{"Sistema de 93.8GB", {{"mount", function () os.execute("udisks --mount /dev/disk/by-uuid/203EB7903EB75E0A")
						   naughty.notify({title = "Mount: Sistema de 93.8GB", text = "/media/203EB7903EB75E0A", timeout = 10}) end},
					 {"unmount", function () os.execute("udisks --unmount /dev/disk/by-uuid/203EB7903EB75E0A")
						   naughty.notify({title = "Unmount: Sistema de 93.8GB", text = "/media/203EB7903EB75E0A", timeout = 10}) end}}},
	{"System Reserved", {{"mount", function () os.execute("udisks --mount /dev/disk/by-uuid/D2B2A6B4B2A69C8B")
						   naughty.notify({title = "Mount: System Reserved", text = "/media/D2B2A6B4B2A69C8B", timeout = 10}) end},
					 {"unmount", function () os.execute("udisks --unmount /dev/disk/by-uuid/D2B2A6B4B2A69C8B")
						   naughty.notify({title = "Unmount: System Reserved", text = "/media/D2B2A6B4B2A69C8B", timeout = 10}) end}}}	  
}
--local fsda1 = io.popen("LC_ALL=C  udisks --dump | grep sda1 -B26 | grep Attribute -B1 -A19 ")

local txt = string.format('<span font_desc="Envy Code R 9">'..awful.util.pread("/home/ivan/.config/awesome/disks.sh")..'</span>\n')
local txtsub = string.format('</span><span color="#008000" font_desc="Envy Code R 9">good</span><span font_desc="Envy Code R 9">')
local txtsub2 = string.format('</span><span color="#FF0000" font_desc="Envy Code R 9">FAIL_PAST</span><span font_desc="Envy Code R 9">')
local txtsub3 = string.format('</span><span color="#7F7F7F" font_desc="Envy Code R 9">n/a</span><span font_desc="Envy Code R 9">')

hddmenu = {
	{"sda", function () naughty.notify({title = "Disk: WDC WD1600JS-75NCB1\n", 
		text = string.gsub(string.gsub(string.gsub(txt, "good", txtsub),"FAIL_PAST", txtsub2), "n/a", txtsub3), timeout = 20}) end},
	-- ST3250318AS
	{"sdb", ""},
	{"sdc", ""}
}
    local bottom_left_layout2 = wibox.layout.fixed.horizontal()
    local bottom_right_layout2 = wibox.layout.fixed.horizontal()


mystomenu = awful.menu.new({ items = { { "Partitions", diskmenu},
									   { "Disk Health", hddmenu}
                                     }
                          })

--mystomenu = radical.context {
--        style      = radical.style.classic,
--        item_style = radical.item.style.rounded 
--} 

--mystomenu:add_item{text="Partitions", sub_menu = function() 
--        local smenu = radical.context{}
--        smenu:add_item{mystomenu2}
--        return smenu
--    end}       
--mystomenu:add_item{text="Disk Health", hddmenu}       

                            
mystolaunch = awful.widget.launcher({ image = themes_dir .. "/icons/removable.png",
                                     menu = mystomenu })

--mystolaunch = wibox.widget.imagebox()
--mystolaunch:set_image(themes_dir .. "/icons/removable.png")
	
--mystolaunch:set_menu(mystomenu,1) 

    bottom_left_layout:add(mystolaunch)
   -- bottom_left_layout2:add(fav_widget)
--	bottom_left_layout2:add(spr)
    local bmar2 = wibox.layout.margin()
	bmar2:set_top(2)
	bmar2:set_bottom(2)
	bmar2:set_widget(udisks_glue) 
	
	bottom_left_layout2:add(bmar2)
	
    local bmar = wibox.layout.margin()
	bmar:set_top(2)
	bmar:set_bottom(2)
	bmar:set_widget(volicon) 


--session:add_key_binding({modkey, "Control"},"q")
local foowid = wibox.widget.imagebox(beautiful.off)
foowid:set_menu(session)

--    bottom_right_layout:add(foowid)

--	bottom_left_layout:add()
--	local lock=blingbling.system.lockmenu({button_image = themes_dir .. "/icons/lock.png"})
    --bottom_right_layout:add(bmar2)

  --  bottom_right_layout:add(spr)
  --  bottom_right_layout:add(arrl_ld)

 --   up = wibox.widget.textbox()
  --  vicious.register(up, vicious.widgets.top,'${uptime}' , 60)
  --  bottom_right_layout:add(wibox.widget.background(up, "#313131"))
    
  --  bottom_right_layout:add(arrl_dl)
    bottom_right_layout:add(bmar)
    bottom_right_layout:add(volume_master)

    bottom_layout1:set_left(bottom_left_layout)    
   
  --  bottom_layout:set_middle(mytasklist[s])
    bottom_layout1:set_middle(rad_task(1)._internal.margin)
    bottom_layout1:set_right(bottom_right_layout)
    
	local dialog = radical.box 
	{
		item_width=90,
		item_height=92,--88,
		icon_size=74,
		style = radical.style.classic, 
		border_width = 2,
		layout = radical.layout.horizontal,
		item_layout = radical.layout.centerred,
        item_style = radical.item.style.basic,
		autodiscard = false
	}
	
	dialog.margins.top = 8
	dialog.margins.bottom = 8

    dialog:add_item{text="Shutdown", icon=themes_dir .. "/icons/shutdown.png"}
    dialog:add_item{text="Reboot", icon=themes_dir .. "/icons/restart.png"}
    dialog:add_item{text="Suspend", icon=themes_dir .. "/icons/suspend.png"}
    dialog:add_item{text="Cancel", icon=themes_dir .. "/icons/cancel.png", button1 = function() dialog.visible = false end}
--
--
    local ico = wibox.widget.imagebox(beautiful.system)
    ico:set_menu(info_menu,1)
    bottom_right_layout2:add(ico)
    
    bottom_layout2:set_left(bottom_left_layout2) 
    bottom_layout2:set_middle(rad_task(2)._internal.margin)
    bottom_layout2:set_right(bottom_right_layout2)
    
    mybottomwibox[1]:set_widget(bottom_layout1)
    mybottomwibox[2]:set_widget(bottom_layout2)

-- }}}

secmenu = {
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}
favs_app = {
   {"Terminology", terminal2},
   {"XTerm", terminal},
   {"Luakit", browser},
   {"Geany", gui_editor}
}


mysecmenu = awful.menu.new({ items = { { "favourite", favs_app},
									   { "awesome", secmenu, beautiful.awesome_icon },
                                       { "power off", function () dialog.visible = true end}
                                     }
                            })
-- {{{ Mouse Bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 1, function () mysecmenu:toggle() end),
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

local alttab = require("radical.impl.alttab")

-- {{{ Key bindings
globalkeys = awful.util.table.join(
----------------alttab

    awful.key({ modkey,           }, "Tab"   , function () alttab.altTab()          end ),
    awful.key({ modkey, "Shift"   }, "Tab"   , function () alttab.altTabBack()      end ),
    awful.key({ "Mod1",           }, "Tab"   , function () alttab.altTab({auto_release=true})          end ),
    awful.key({ "Mod1", "Shift"   }, "Tab"   , function () alttab.altTabBack({auto_release=true})      end ),

----------------alttab

    -- Take a screenshot
    -- https://github.com/copycat-killer/dots/blob/master/bin/screenshot
    awful.key({ altkey }, "p", function() os.execute("screenshot") end),

    -- Tag browsing
    awful.key({ modkey }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey }, "Escape", awful.tag.history.restore),

    -- Non-empty tag browsing
    awful.key({ altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end),
    awful.key({ altkey }, "Right", function () lain.util.tag_view_nonempty(1) end),

    -- Default client focus
    awful.key({ altkey }, "k",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ altkey }, "j",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),

    -- Show Menu
    awful.key({ modkey }, "w",
        function ()
            mymainmenu:show({ keygrabber = true })
        end),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
        mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
    end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),
    awful.key({ altkey, "Shift"   }, "l",      function () awful.tag.incmwfact( 0.05)     end),
    awful.key({ altkey, "Shift"   }, "h",      function () awful.tag.incmwfact(-0.05)     end),
    awful.key({ modkey, "Shift"   }, "l",      function () awful.tag.incnmaster(-1)       end),
    awful.key({ modkey, "Shift"   }, "h",      function () awful.tag.incnmaster( 1)       end),
    awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol(-1)          end),
    awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol( 1)          end),
    awful.key({ modkey,           }, "space",  function () awful.layout.inc(layouts,  1)  end),
    awful.key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(layouts, -1)  end),
    awful.key({ modkey, "Control" }, "n",      awful.client.restore),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r",      awesome.restart),
    awful.key({ modkey, "Shift"   }, "q",      awesome.quit),

    -- Dropdown terminal
    awful.key({ modkey,	          }, "z",      function () drop(terminal) end),

    -- Widgets popups
    awful.key({ altkey,           }, "c",      function () lain.widgets.calendar:show(7) end),
    awful.key({ altkey,           }, "h",      function () fswidget.show(7) end),

    -- ALSA volume control
    awful.key({ altkey }, "Up",
        function ()
            awful.util.spawn("amixer -q set Master 1%+")
            volumewidget.update()
        end),
    awful.key({ altkey }, "Down",
        function ()
            awful.util.spawn("amixer -q set Master 1%-")
            volumewidget.update()
        end),
    awful.key({ altkey }, "m",
        function ()
            awful.util.spawn("amixer -q set Master playback toggle")
            volumewidget.update()
        end),
    awful.key({ altkey, "Control" }, "m",
        function ()
            awful.util.spawn("amixer -q set Master playback 100%")
            volumewidget.update()
        end),

    -- MPD control
    awful.key({ altkey, "Control" }, "Up",
        function ()
            awful.util.spawn_with_shell("mpc toggle || ncmpc toggle || pms toggle")
            mpdwidget.update()
        end),
    awful.key({ altkey, "Control" }, "Down",
        function ()
            awful.util.spawn_with_shell("mpc stop || ncmpc stop || pms stop")
            mpdwidget.update()
        end),
    awful.key({ altkey, "Control" }, "Left",
        function ()
            awful.util.spawn_with_shell("mpc prev || ncmpc prev || pms prev")
            mpdwidget.update()
        end),
    awful.key({ altkey, "Control" }, "Right",
        function ()
            awful.util.spawn_with_shell("mpc next || ncmpc next || pms next")
            mpdwidget.update()
        end),

    -- Copy to clipboard
    awful.key({ modkey }, "c", function () os.execute("xsel -p -o | xsel -i -b") end),

    -- User programs
    awful.key({ modkey }, "q", function () awful.util.spawn(browser) end),
    awful.key({ modkey }, "i", function () awful.util.spawn(browser2) end),
    awful.key({ modkey }, "s", function () awful.util.spawn(gui_editor) end),
    awful.key({ modkey }, "g", function () awful.util.spawn(graphics) end),

    -- Prompt
    awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons,
	                   size_hints_honor = false } },
    { rule = { class = "URxvt" },
          properties = { opacity = 0.99 } },

    { rule = { class = "Geany" },
          properties = { tag = tags[1][3], floating = false } },

    { rule = { class = "Dwb" },
          properties = { tag = tags[1][1] } },

    { rule = { class = "Iron" },
          properties = { tag = tags[1][1] } },

	  { rule = { class = "Gimp" },
     	    properties = { tag = tags[1][5] , floating = false}},

    { rule = { class = "Gimp", role = "gimp-image-window" },
          properties = { maximized_horizontal = true,
                         maximized_vertical = true } },
}
-- }}}

-- {{{ Signals
-- signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup and not c.size_hints.user_position
       and not c.size_hints.program_position then
        awful.placement.no_overlap(c)
        awful.placement.no_offscreen(c)
    end

    local titlebars_enabled = true
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
      --  right_layout:add(awful.titlebar.widget.floatingbutton(c))
      --  right_layout:add(awful.titlebar.widget.maximizedbutton(c))
      --  right_layout:add(awful.titlebar.widget.stickybutton(c))
      --  right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- the title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c,{size=16}):set_widget(layout)
    end
end)

-- No border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized_horizontal == true and c.maximized_vertical == true then
            c.border_color = "#3F3F3F"-- beautiful.border_normal
        else
            c.border_color = "#3F3F3F"--beautiful.border_focus
        end
    end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
        local clients = awful.client.visible(s)
        local layout  = awful.layout.getname(awful.layout.get(s))

        if #clients > 0 then -- Fine grained borders and floaters control
            for _, c in pairs(clients) do -- Floaters always have borders
                if awful.client.floating.get(c) or layout == "floating" then
                    c.border_width = 1--beautiful.border_width

                -- No borders with only one visible client
                elseif #clients == 1 or layout == "max" then
                    clients[1].border_width = 0
                else
                    c.border_width = beautiful.border_width
                end
            end
        end
      end)
end
-- }}}
