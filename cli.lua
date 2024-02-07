local serpent = require 'serpent'

local luabill = require 'luabill'

local help = [[
luabill - organize your bills with Lua
Usage: luabill <command> [args...]
Commands:
  dump - Dump tree
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
if cmd == 'dump' then
    local tree = luabill:tree(dir)
    print(serpent.block(tree, { comment = false }))
else
    io.stderr:write(help)
    os.exit(1)
end
