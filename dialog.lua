

local radical = require("radical")


local function new()

	local dialog = radical.context 
	{
		style		= radical.style.classic      ,
		item_style	= radical.item.style.arrow_prefix ,
		item_height	= 36,
		width		= 240,
		layout		= radical.layout.horizontal,
		item_layout = radical.layout.centerred,    
		autodiscard = false
	}
    local off = wibox.widget.textbox()
	off:set_text("Shutdown")
	local reboot = wibox.widget.textbox()
	off:set_text("Reboot")
	local suspend = wibox.widget.textbox()
	off:set_text("Suspend")
	
    dialog:add_widget(off)
    dialog:add_widget(reboot)
    dialog:add_widget(suspend)
    
    return dialog 
end
