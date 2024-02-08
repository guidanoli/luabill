local serpent = require 'serpent'

local LuaBill = require 'luabill'
local Markdown = require 'luabill.markdown'

local help = [[
luabill - organize your bills with Lua
Usage: luabill [opts...] <command>
Commands:
  status - Show the current status of bills
Options:
  --format <fmt> - Define output format
                   + lua : Lua (default)
                   + md : Markdown
]]

-- command-line arguments

local args = {...}
local i = 1

-- default options

local dir = '.'
local format = 'lua'

-- parse options

while true do
    local arg = args[i]
    if arg == '--dir' then
        dir = assert(args[i + 1], 'expected argument after --dir')
        i = i + 2
    elseif arg == '--format' then
        format = assert(args[i + 1], 'expected argument after --format')
        i = i + 2
    else
        break
    end
end

-- parse command

local cmd = args[i]
if cmd == 'status' then
    local billdirs = {}
    LuaBill:loadbilldirs(billdirs, '.', dir)
    if format == 'lua' then
        print('return ' .. serpent.block(billdirs, {comment=false}))
    elseif format == 'md' then
        Markdown:print(billdirs)
    else
        error(string.format('unknown format %q', format))
    end
else
    io.stderr:write(help)
    os.exit(1)
end
