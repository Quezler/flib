if ... ~= "__flib__.orientation" then
  return require("__flib__.orientation")
end

--- Functions for working with orientations.
--- ```lua
--- local flib_orientation = require("__flib__.orientation")
--- ```
--- @class flib_orientation
local flib_orientation = {}

flib_orientation.north = defines.direction.north / 16
flib_orientation.east = defines.direction.east / 16
flib_orientation.west = defines.direction.west / 16
flib_orientation.south = defines.direction.south / 16
flib_orientation.northeast = defines.direction.northeast / 16
flib_orientation.northwest = defines.direction.northwest / 16
flib_orientation.southeast = defines.direction.southeast / 16
flib_orientation.southwest = defines.direction.southwest / 16

--- Returns a 4way or 8way direction from an orientation.
--- @param orientation number
--- @param eight_way boolean
--- @return defines.direction
function flib_orientation.to_direction(orientation, eight_way)
  local ways = eight_way and 8 or 4
  local mod = eight_way and 1 or 2
  return math.floor(orientation * ways + 0.5) % ways * mod --[[@as defines.direction]]
end

--- Returns the opposite orientation.
--- @param orientation number
--- @return number
function flib_orientation.opposite(orientation)
  return (orientation + 0.5) % 1
end

--- Add two orientations together.
--- @param orientation1 number
--- @param orientation2 number
--- @return number the orientations added together
function flib_orientation.add(orientation1, orientation2)
  return (orientation1 + orientation2) % 1
end

return flib_orientation
