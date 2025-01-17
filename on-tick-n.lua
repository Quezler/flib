if ... ~= "__flib__.on-tick-n" then
  return require("__flib__.on-tick-n")
end

--- Schedule tasks to be executed later.
--- ```lua
--- local flib_on_tick_n = require("__flib__.on-tick-n")
--- ```
--- @class flib_on_tick_n
local on_tick_n = {}

--- Initialize the module's script data table.
---
--- Must be called at the **beginning** of `on_init`. Can also be used to delete all current tasks.
function on_tick_n.init()
  if not storage.__flib then
    storage.__flib = {}
  end
  --- @type table<number, flib.OnTickNTasks>
  storage.__flib.on_tick_n = {}
end

--- Retrieve the tasks for the given tick, if any.
---
--- Must be called **during** `on_tick`.
--- @param tick number
--- @return flib.OnTickNTasks?
function on_tick_n.retrieve(tick)
  -- Failsafe for rare cases where on_tick can fire before on_init
  if not storage.__flib or not storage.__flib.on_tick_n then
    return
  end
  local actions = storage.__flib.on_tick_n[tick]
  if actions then
    storage.__flib.on_tick_n[tick] = nil
    return actions
  end
end

--- Add a task to execute on the given tick.
--- @param tick number
--- @param task any The data representing this task. This can be anything except for a `function`.
--- @return flib.OnTickNTaskID ident An identifier for the task. Save this if you might remove the task before execution.
function on_tick_n.add(tick, task)
  local list = storage.__flib.on_tick_n
  local tick_list = list[tick]
  if tick_list then
    local index = #tick_list + 1
    tick_list[index] = task
    return { index = index, tick = tick }
  else
    list[tick] = { task }
    return { index = 1, tick = tick }
  end
end

--- Remove a scheduled task.
--- @param ident flib.OnTickNTaskID The identifier object for the task, as returned from `on-tick-n.add`.
function on_tick_n.remove(ident)
  local tick_list = storage.__flib.on_tick_n[ident.tick]
  if not tick_list or not tick_list[ident.index] then
    return false
  end

  tick_list[ident.index] = nil

  return true
end

--- A unique identifier for a previously added task, used in `on-tick-n.remove`.
--- @class flib.OnTickNTaskID
--- @field tick number The tick this task is scheduled for.
--- @field index number The tasks' index in the tick's `Tasks` table.

--- A table of tasks.
---
--- Each task can be anything that is not a function, as specified in `on-tick-n.add`.
---
--- **This is not an array, there may be gaps. Always use `pairs` to iterate this table.**
---
--- # Example
---
--- ```lua
--- event.on_tick(function(e)
---   for _, task in pairs(on_tick_n.retrieve(e.tick) or {}) do
---     if task == "say_hi" then
---       game.print("Hello there!")
---     elseif task == "order_66" then
---       for _, player in pairs(game.players) do
---         player.die()
---       end
---     end
---   end
--- end)
--- ```
--- @alias flib.OnTickNTasks table<number, any>

return on_tick_n
