local serpent = require 'serpent'

local luabill = require 'luabill'

local help = [[
luabill - organize your bills with Lua
Usage: luabill <command> [args...]
Commands:
  dump - Dump node
    [--flatten] - Flatten node
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
    local node = luabill:load(dir)
    i = i + 1
    local flatten = false
    while true do
        local arg = args[i]
        if arg == '--flatten' then
            flatten = true
            i = i + 1
        elseif arg == nil then
            break
        else
            usage()
        end
    end
    if flatten then
        local array = {}
        node:flatten(array, '.')
        print(serpent.block(array, { comment = false }))
    else
        print(serpent.block(node, { comment = false }))
    end
else
    usage()
end
