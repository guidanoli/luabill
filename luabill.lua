local lfs = require "lfs"

local Bill = require "Bill"
local Group = require "Group"

local luabill = {}

function luabill:tree (path)
    local billpath = path .. '/bill.lua'
    local fp = io.open(billpath)
    if fp ~= nil then
        local chunk = fp:read'*a'
        local f = load(chunk)
        local t = f()
        if type(t) ~= 'table' then
            error(billpath .. ' does not return table')
        end
        return Bill:new(t)
    else
        local t = {}
        for file in lfs.dir(path) do
            if file ~= '.' and file ~= '..' then
                local f = path .. '/' .. file
                local attr = assert(lfs.attributes(f))
                if attr.mode == 'directory' then
                    local child = self:tree(f)
                    if not child:isempty() then
                        t[file] = child
                    end
                end
            end
        end
        return Group:new(t)
    end
end

return luabill
