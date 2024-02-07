local lfs = require 'lfs'

local Node = require 'Node'
local Bill = require 'Bill'

local luabill = {}

function luabill:load (path)
    local billpath = path .. '/bill.lua'
    local f = loadfile(billpath)
    if f ~= nil then
        local t = f()
        local bill, err = Bill:new(t)
        if not bill then
            error(string.format('"%s": %s', billpath, err))
        end
        return Node:new(bill)
    else
        local t = {}
        for file in lfs.dir(path) do
            if file ~= '.' and file ~= '..' then
                local f = path .. '/' .. file
                local attr = assert(lfs.attributes(f))
                if attr.mode == 'directory' then
                    local node = self:load(f)
                    if node.children == nil or next(node.children) ~= nil then
                        t[file] = node
                    end
                end
            end
        end
        return Node:new(nil, t)
    end
end

return luabill
