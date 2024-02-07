local serpent = require 'serpent'

local fs = require 'fs'

local help = [[
luabill - organize your bills with Lua
Usage: luabill <command> [args...]
Commands:
  dump - Dump bills
]]

local function usage ()
    io.stderr:write(help)
    os.exit(1)
end

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
if cmd == 'dump' then
    local bills = {}
    fs:loadbills(dir, bills)
    print(serpent.block(bills, { comment = false }))
else
    usage()
end
