local beautiful = require("beautiful")
local radical = require("radical")
local wibox     = require("wibox")
local vicious     = require("vicious")
local blingbling     = require("blingbling")
local awful     = require("awful")

    local info_menu = radical.context {
        style      = radical.style.classic      ,
        item_style = radical.item.style.rounded ,
        item_height = 28,--48,
        width = 320,
  --      item_width = 200,
        layout = radical.layout.vertical,
        border_width = 4,
        border_color = "#88aa00",	
        item_layout = radical.layout.centerred    
    }
    
 --   info_menu:add_item {icon=beautiful.widget_hdd, text='<span font_desc="Neuropol 11" color="#8894B3">INFO</span>\n'}
    info_menu:add_widget(radical.widgets.header(info_menu,"INFO"))

	info_menu.margins.top = 6
--    info_menu.margins.bottom = 12

    info_ico = wibox.widget.imagebox()
	info_ico:set_image(beautiful.system)
    
--    info_menu:add_widget(info_ico, {height = 48  , width = 42})
    
    sys_title = wibox.widget.textbox()
    sys_title:set_markup('<span font_desc="Envy Code R Bold 9" color="#A5A5A5">System:</span> 3.17-1-amd64 Debian 7.6 GNU/Linux\n<span font_desc="Envy Code R Bold 9" color="#A5A5A5">Uptime:</span> 13 hr 34 min\n\n<span font_desc="Envy Code R Bold 9" color="#A5A5A5">Awesome:</span> v3.5.5 (Kansas City Shuffle)\n')
    info_menu:add_widget(sys_title, {width = 104})

-------------------  CPU
--- layout
    local vertical_cpu = wibox.layout.fixed.vertical()	
    local margin_cpu = wibox.layout.margin()
    
--- title
    info_menu:add_widget(radical.widgets.header(info_menu,"PROCESS"))

--    info_menu:add_item {icon=beautiful.widget_hdd, text='<span font_desc="Neuropol  11" color="#8894B3">CPU</span>\n'}

--- info
    local horizontal_avg = wibox.layout.flex.horizontal()	
	cpu_info = wibox.widget.textbox()
	cpu_info:set_markup('<span font_desc="Envy Code R Bold 9" color="#A5A5A5">Info: </span>Intel(R) Core(TM) i7-3770K CPU @ 3.50GHz\n')
	horizontal_avg:add(cpu_info)
--- top
	top = wibox.widget.textbox()
--	local txt = '<span font_desc="Envy Code R Bold 9">'..awful.util.pread("/home/ivan/.config/awesome/top.sh")..'</span>\n'
--	top:set_markup(string.gsub(txt, "PID USER", '</span><span font_desc="Envy Code R Bold 9" color="#A5A5A5">PID USER</span><span font_desc="Envy Code R Bold 9">'))
--	info_menu:add_item{text=s, style = radical.item.style.arrow_single}
	
	
--- add to layout
	vertical_cpu:add(horizontal_avg)
	vertical_cpu:add(top)
	margin_cpu:set_margins(3)
	margin_cpu:set_top(8)
    margin_cpu:set_widget(vertical_cpu)
    info_menu:add_widget(margin_cpu, {width = 194})                               


    top_widget = wibox.widget.textbox()
    vicious.cache(vicious.widgets.top)
    vicious.register(top_widget, vicious.widgets.top,'${title}\n${p1}\n${p2}\n${p3}\n${p4}\n' , 4)
    info_menu:add_widget(top_widget, {width = 194})                               



--					local wdg = {}
--                    wdg.percent       = wibox.widget.textbox()
--                    wdg.percent.fit = function()
--                        return 42,info_menu.item_height
--                    end
--                    info_menu:add_item({style=radical.item.style.arrow_prefix,text="\tluakit",suffix_widget=wdg.kill,prefix_widget=wibox.widget.textbox("2.6%")})
--                    info_menu:add_item({style=radical.item.style.arrow_prefix,text="\tawesome",suffix_widget=wdg.kill,prefix_widget=wibox.widget.textbox("1.8%")})
                    
------------------- CPU
------------------- MEM
--- layout
    local vertical_mem = wibox.layout.fixed.vertical()	
    local margin_mem = wibox.layout.margin()
--- icon
--    mem_ico = wibox.widget.imagebox()
--	mem_ico:set_image(beautiful.widget_mem)
   -- info_menu:add_widget(mem_ico, {height = 48  , width = 42})
   --     info_menu:add_item {icon=beautiful.widget_hdd, text='<span font_desc="Neuropol 11" color="#8894B3">MEM</span>\n'}
 --   info_menu:add_widget(radical.widgets.header(info_menu,"MEM"))
--- title
 --   mem_title = wibox.widget.textbox()
 --   mem_title:set_text("MEM")
--- usage - graph
    local horizontal_use = wibox.layout.fixed.horizontal()    

--	horizontal_use:add(mem)
--	horizontal_use:add(circle)

--- top

--- add to layout
--	vertical_mem:add(mem_title)
	vertical_mem:add(horizontal_use)
--	vertical_mem:add(cpu_gh)
	margin_mem:set_margins(3)
	margin_mem:set_top(8)
    margin_mem:set_widget(vertical_mem)
    info_menu:add_widget(margin_mem, {width = 164})                               

------------------- MEM
------------------- HDD
--- layout
    local vertical_hdd = wibox.layout.flex.vertical()	
    local margin_hdd = wibox.layout.margin()


	local disk = require("disk")

    info_menu:add_widget(radical.widgets.header(info_menu,"HDD"))



units = {"KB", "MB", "GB", "TB", "PB", "EB"}
local usage = {}
-- }}}

-- {{{ local functions
-- {{{ Unit formatter
-- formats a value to the corresponding unit
local function uformat(value)
    local ret = tonumber(value)
    for i, u in pairs(units) do
        if ret < 1024 then
            return string.format("%.1f" .. u, ret)
        end
        ret = ret / 1024;
    end
    return "N/A"
end
-- }}}

-- {{{ getData
-- gets the required data from df
local function getData(onlyLocal)
    -- Fallback to listing local filesystems
    local warg = ""
    if onlyLocal == true then
        warg = "-l"
    end

    local fs_info = {} -- Get data from df
    local f = io.popen("LC_ALL=C df -kP " .. warg)

    for line in f:lines() do -- Match: (size) (used)(avail)(use%) (mount)
        local s     = string.match(line, "^.-[%s]([%d]+)")
        local u,a,p = string.match(line, "([%d]+)[%D]+([%d]+)[%D]+([%d]+)%%")
        local m     = string.match(line, "%%[%s]([%p%w]+)")

        if u and m then -- Handle 1st line and broken regexp
            fs_info[m] = {}
            fs_info[m]["size"] = s
            fs_info[m]["used"] = u
            fs_info[m]["avail"] = a
            fs_info[m]["used_p"]  = tonumber(p)
            fs_info[m]["avail_p"] = 100 - tonumber(p)
        end
    end
    f:close()
    return fs_info
end

local data = getData(true)
local j=0		
local hdd_use = {}

info_menu:add_widget(wibox.widget.textbox(" "))
for i, m in pairs(data) do
		hdd_use[j] = blingbling.progress_graph({height = 18, width = 312, rounded_size = 0.2, horizontal=true, v_margin = 4})
		vicious.register(hdd_use[j], vicious.widgets.fs, "${".. i .." used_p}", 120)
		local txt = wibox.widget.textbox()
		txt:set_markup('<span font_desc="Envy Code R 8">' .. i .. " (" .. m["used_p"] .. "%)</span>")		
		info_menu:add_widget(txt)
		info_menu:add_widget(hdd_use[j])
		j=j+1
 end                       
------------------- HDD


return info_menu
