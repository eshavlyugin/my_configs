local wibox = require("wibox")
local awful = require("awful")
local io = io
local string = string
local tonumber = tonumber
local math = require("math")
local timer = timer
local capi = {
   button = button
}

module("volume")

volume_widget_real = wibox.widget.textbox()
volume_widget_real:set_align("right")
volume_widget_real.font = "dejavu 16"

volume_widget = wibox.widget.background(volume_widget_real)

function get_volume()
   local fd = io.popen("amixer sget Master", "r")
   local status = fd:read("*a")
   fd:close()

   return tonumber(string.match(status, "(%d?%d?%d)%%"))
end

function update_volume(widget)
   local fd = io.popen("amixer sget Master", "r")
   local status = fd:read("*a")
   fd:close()

   local volume = tonumber(string.match(status, "(%d?%d?%d)%%"))

   status = string.match(status, "%[(o[^%]]*)%]")

   if string.find(status, "on", 1, true) then
      -- For the volume numbers
      volume = volume .. "%"
   else
      -- For the mute button
      volume = volume .. "M"
   end
   widget:set_markup(volume)
end

function get_playback()
   local fd = io.popen("amixer sget Master", "r")
   local status = fd:read("*a")
   fd:close()
   return tonumber(string.match(status, "Playback %d+ %- (%d+)"))
end

function inc_volume(dx)
   local old_volume = get_volume()
   local volume = old_volume + dx
   if volume > 100 then
      volume = 100
   elseif volume < 0 then
      volume = 0
   end
   if old_volume ~= volume then
      local fd = io.popen(string.format("amixer sset Master %d", math.floor(get_playback() * volume / 100)))
      local status = fd:read("*a")
      fd:close()
   end
   update_volume(volume_widget_real)
end


volume_widget:buttons(awful.util.table.join(
   awful.button({ }, 4, function(t) inc_volume(5) end),
   awful.button({ }, 5, function(t) inc_volume(-5) end))
)

update_volume(volume_widget_real)

mytimer = timer({ timeout = 1 })
mytimer:connect_signal("timeout", function () update_volume(volume_widget_real) end)
mytimer:start()

