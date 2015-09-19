local string = string
local io = io
local assert = assert
local table = table
local ipairs = ipairs
local awful = require("awful")

module("ibus")

function readLayouts ()
   local cmd = "ibus read-config | grep engines-order | tr \\' \"\\n\"| awk 'NR % 2 == 0'"
   local f = assert(io.popen(cmd, 'r'))
   local s = assert(f:read('*a'))
   f:close()
   fields = {}
   for field in string.gmatch(s, "%S+") do
      table.insert(fields, field)
   end
   return fields
end

function toggleLayout (dx)
   local cmd = "ibus engine"
   local f = assert(io.popen(cmd, 'r'))
   local s = assert(f:read('*a'))
   for ss in string.gmatch(s, "%S+") do
      s = ss
   end
   f:close()
   local layouts = readLayouts()
   for i,v in ipairs(layouts) do
      if v == s then
	 local newLayout = layouts[(i+dx-1) % #layouts + 1]
	 local cmd = "ibus engine " .. newLayout
	 awful.util.spawn(cmd)
      end
   end
end
