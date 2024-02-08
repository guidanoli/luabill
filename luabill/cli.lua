local serpent = require 'serpent'

local LuaBill = require 'luabill'
local Markdown = require 'luabill.markdown'

local help = [[
luabill - organize your bills with Lua
Usage: luabill <command> [args...]
Commands:
  status - Get status of bills
    [--markdown] - Compile to Markdown
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
    i = i + 1
    local format = 'table'
    while true do
        local arg = args[i]
        if arg == '--markdown' then
            format = 'md'
            i = i + 1
        else
            break
        end
    end
    local billdirs = {}
    LuaBill:loadbilldirs(billdirs, '.', dir)
    if format == 'table' then
        print(serpent.block(billdirs, {comment=false}))
    elseif format == 'md' then
        Markdown:print(billdirs)
    else
        error(string.format('unknown format %q', format))
    end
else
    io.stderr:write(help)
    os.exit(1)
end
