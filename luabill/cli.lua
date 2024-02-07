local serpent = require 'serpent'

local luabill = require 'luabill'

local help = [[
luabill - organize your bills with Lua
Usage: luabill <command> [args...]
Commands:
  status - Get status of bills
]]

-- command-line arguments

local args = {...}
local i = 1

-- default options

local dir = '.'

-- parse options

while true do
    local arg = args[i]
    if arg == '--dir' then
        dir = assert(args[i + 1], 'expected argument after --dir')
        i = i + 2
    else
        break
    end
end

-- parse command

local cmd = args[i]
if cmd == 'status' then
    local billdirs = {}
    luabill:loadbilldirs(billdirs, dir)
    print(serpent.block(billdirs, {comment=false}))
else
    io.stderr:write(help)
    os.exit(1)
end
