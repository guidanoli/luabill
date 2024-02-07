local lfs = require 'lfs'

local Bill = require 'Bill'
local Group = require 'Group'

local luabill = {}

function luabill:tree (path)
    local billpath = path .. '/bill.lua'
    local f = loadfile(billpath)
    if f ~= nil then
        local t = f()
        local bill, err = Bill:new(t)
        if not bill then
            error(string.format('"%s": %s', billpath, err))
        end
        return bill
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
