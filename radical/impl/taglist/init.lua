---------------------------------------------------------------------------
-- @author Emmanuel Lepage Vallee <elv1313@gmail.com>
-- @copyright 2014 Emmanuel Lepage Vallee
-- @release devel
-- @license BSD
---------------------------------------------------------------------------

local capi = {tag=tag,client=client,screen=screen}

local radical   = require( "radical"      )
local tag       = require( "awful.tag"    )
local beautiful = require( "beautiful"    )
local color     = require( "gears.color"  )
local client    = require( "awful.client" )
local wibox     = require( "wibox"        )
local awful     = require( "awful"        )
local theme     = require( "radical.theme")
local surface   = require( "gears.surface" )
local tracker   = require( "radical.impl.taglist.tracker" )
local tag_menu  = require( "radical.impl.taglist.tag_menu" )

local CLONED      = 100
local HIGHLIGHTED = -2
local EMPTY       = 412345

local last_idx = EMPTY

theme.register_color(CLONED , "cloned" , "cloned" , true )
theme.register_color(HIGHLIGHTED , "highlight" , "highlight" , true )
theme.register_color(EMPTY , "empty" , "empty" , true )

local module,instances = {},{}

-- The cache can be global, this is unsupported by Radical, but for now it
-- doesn't cause too many issues. This make it easier to track state
local cache = setmetatable({}, { __mode = 'k' })


module.buttons = { [1] = awful.tag.viewonly,
                      [2] = awful.tag.viewtoggle,
                      [3] = function(q,w,e,r)
                              local menu = tag_menu(q)
                              menu.visible = true
                            end,
                      [4] = function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end,
                      [5] = function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end,
                    }
--                     awful.button({ modkey }, 1, awful.client.movetotag),
--                     awful.button({ modkey }, 3, awful.client.toggletag),



local function index_draw(self,w, cr, width, height)
  cr:save()
  cr:set_source(color(self._color or beautiful.taglist_fg_prefix or beautiful.fg_normal))
  local d = wibox.widget.textbox._draw or wibox.widget.textbox.draw
  d(self,wibox, cr, width, height)
  cr:restore()
end

local function create_item(t,s)
  local menu,ib,original = instances[s],nil,tag.geticon(t) or beautiful.taglist_default_icon
  if not menu or not t then return end
  local w = wibox.layout.fixed.horizontal()
  if beautiful.taglist_disable_icon ~= true then
    local icon = original
    if icon and beautiful.taglist_icon_transformation then
      icon = beautiful.taglist_icon_transformation(icon,menu,nil)
    end

    ib = wibox.widget.imagebox()
    ib:set_image(icon)
    original = surface(original)
    w:add(ib)
  end
  local tw = nil
  if beautiful.taglist_disable_index ~= true then
    tw = wibox.widget.textbox()
    tw.draw = index_draw
    local index = tag.getproperty(t,"index") or tag.getidx(t)
    tw:set_markup((menu.index_prefix or " <b>#")..(index)..(menu.index_suffix or "</b>: "))
    w:add(tw)
  end
  local suf_w = wibox.layout.fixed.horizontal()
  local item = menu:add_item { text = t.name, prefix_widget = w,suffix_widget=suf_w,bg_normal="#ff0000"--[[beautiful.taglist_bg_unused]]}
  item.state[EMPTY] = true
  item._internal.icon_w = ib

  item.add_suffix = function(_,w2)
    suf_w:add(w2)
  end
  item.add_prefix = function(_,w2)
    w:add(w2)
  end

  -- Redraw the icon when necessary
  if menu.icon_per_state == true then
    item:connect_signal("state::changed",function(i,d,st)
      if original and beautiful.taglist_icon_transformation then
        wibox.widget.imagebox.set_image(ib,beautiful.taglist_icon_transformation(original,menu,item))
        if tw and beautiful.taglist_index_per_state then
          local current_state = item.state._current_key or nil
          local state_name = radical.base.colors_by_id[current_state] or "normal"
          tw._color = beautiful["taglist_index_fg_"..state_name]
        end
      end
    end)
  end


  item.tw = tw

  if tag.getproperty(t,"clone_of") then
    item.state[CLONED] = true
  end
--   menu:move(item,index)

  menu:connect_signal("button::press",function(menu,item,button_id,mod)
    if module.buttons and module.buttons[button_id] then
      if item.tag[1] then
        module.buttons[button_id](item.tag[1],menu,item,button_id,mod)
      else
        print("Invalid tag")
      end
    end
  end)

  item._internal.screen = s
  item.state[radical.base.item_flags.SELECTED] = t.selected or nil
  cache[t] = item
  item.tag = setmetatable({}, { __mode = 'v' })
  item.tag[1] = t
  return item
end

local function track_used(c,t)
  if t then
    local item = cache[t] or create_item(t,tag.getscreen(t))
    if not item then return end -- Yes, it happen if the screen is still nil
    item.state[radical.base.item_flags.USED] = #t:clients() > 0 and true or nil
    item.state[radical.base.item_flags.CHANGED] = ((not t.selected) and #t:clients() > 0) and true or nil
  end
end

local function track_title(c)
  for _,t in ipairs(c:tags()) do
    if t.selected ~= true and cache[t] then
      cache[t].state[radical.base.item_flags.CHANGED] = true
    end
  end
end

local function tag_activated(t)
  if not t.activated and cache[t] then
    instances[cache[t]._internal.screen]:remove(cache[t])
    cache[t] = nil
  end
end

local function tag_added(t,b)
  if not t then return end

  local s = tag.getscreen(t)
  local item = cache[t]

  -- Creating items when there is no screen cause random behaviors
  if not item and s then
    create_item(t,s)
  elseif item._internal.screen ~= s then
    if item._internal.screen then
      instances[item._internal.screen]:remove(item)
    end
    if s then
      instances[s]:append(item)
    end

    --Allow nil
    item._internal.screen = s
  end
end

local function select(t)
  local s = t.selected
  local item = cache[t] or create_item(t,tag.getscreen(t))
  if item then
    item.state[radical.base.item_flags.SELECTED] = s or nil
--     if s then --We also want to unset those when we quit the tag
      item.state[radical.base.item_flags.CHANGED] = nil
      item.state[radical.base.item_flags.URGENT] = nil
--     end
  end
end

local function urgent_callback(t)
  local modif = tag.getproperty(t,"urgent")
  local item = cache[t] or create_item(t,tag.getscreen(t))
  if item then
    item.state[radical.base.item_flags.URGENT] = modif and true or nil
  end
end

local is_init = false
local function init()
  if is_init then return end

  -- Global signals
  capi.client.connect_signal("tagged"          , track_used      )
  capi.client.connect_signal("untagged"        , track_used      )
  capi.client.connect_signal("unmanage"        , track_used      )
  capi.tag.connect_signal("property::activated", tag_activated   )
  capi.tag.connect_signal("property::screen"   , tag_added       )
  capi.tag.connect_signal("property::urgent"   , urgent_callback )
  if module.taglist_watch_name_changes then
    capi.client.connect_signal("property::name", track_title     )
  end

  -- Property bindings
  capi.tag.connect_signal("property::name", function(t)
    local item = cache[t]
    if item then
      item.text = t.name
    end
  end)
  capi.tag.connect_signal("property::icon", function(t)
    local item = cache[t]
    if item then
      item._internal.icon_w:set_image(tag.geticon(t) or beautiful.taglist_default_icon)
    end
  end)
  is_init = true
end

local highlighted = {}
function module.highlight(t)
  local tp = type(t)
  if highlighted and highlighted ~= t then
    for k,v in ipairs(highlighted) do
      v.state[HIGHLIGHTED] = nil
    end
    highlighted = {}
  end
  if t then
    for k,v in ipairs(tp == "table" and t or {t}) do
      local item = cache[v]
      if item then
        highlighted[#highlighted+1] = item
        item.state[HIGHLIGHTED] = true
      end
    end
  end
end

local function new(s)

  local track = tracker(s)

  local args = {
    item_style = beautiful.taglist_item_style or radical.item.style.arrow_prefix,
    style      = beautiful.taglist_style,
    select_on  = radical.base.event.NEVER,
    fg         = beautiful.taglist_fg or beautiful.fg_normal,
    bg         = beautiful.taglist_bg or beautiful.bg_normal,
    bg_focus   = beautiful.taglist_bg_selected,
    fg_focus   = beautiful.taglist_fg_selected,
    bg_empty   = beautiful.taglist_bg_empty,
    fg_empty   = beautiful.taglist_fg_empty,
    spacing    = beautiful.taglist_spacing,
    default_item_margins = beautiful.taglist_default_item_margins,
    default_margins      = beautiful.taglist_default_margins     ,
    icon_per_state       = beautiful.taglist_icon_per_state,
--     fkeys_prefix = true,
  }
  for k,v in ipairs {"hover","used","urgent","cloned","changed","highlight"} do
    args["bg_"..v] = beautiful["taglist_bg_"..v]
    args["fg_"..v] = beautiful["taglist_fg_"..v]
  end

  instances[s] = radical.bar(args)

  --Add some settings
  rawset(instances[s],"index_prefix",beautiful.taglist_index_prefix)
  rawset(instances[s],"index_suffix",beautiful.taglist_index_suffix)


  -- Load the innitial set of tags
  for k,t in ipairs(tag.gettags(s)) do
    create_item(t,s)
  end

  -- Per screen signals
--   tag.attached_connect_signal(screen, "property::hide", ut)!

  instances[s]:connect_signal("button::press",function(m,item,button_id,mod)
    if module.buttons and module.buttons[button_id] then
      module.buttons[button_id](item.tag[1],m,item,button_id,mod)
    end
  end)

  init()
  track:reload()
  return instances[s]
end

capi.tag.connect_signal("property::selected" , select)
capi.tag.connect_signal("property::index2",function(t,i)
  if t and not beautiful.taglist_disable_index then
    local s = tag.getscreen(t)
    local item = cache[t]
    if item then
      local menu = instances[s]
      menu:move(item,i)
      if item.tw then
        item.tw:set_markup((menu.index_prefix or " <b>#")..(i)..(menu.index_suffix or "</b>: "))
      end
    end
  end
end)

function module.item(t)
  return cache[t]
end

function module.register_color(col)
  last_idx = last_idx - 1
  theme.register_color(last_idx , "color_"..last_idx , "color_"..last_idx , true )
  for k,v in pairs(instances) do
    v["bg_color_"..last_idx] = col
  end
  return last_idx,"color_"..last_idx
end


return setmetatable(module, { __call = function(_, ...) return new(...) end })
-- kate: space-indent on; indent-width 2; replace-tabs on;
