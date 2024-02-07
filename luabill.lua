local lfs = require 'lfs'

local Node = require 'Node'
local Bill = require 'Bill'

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
        return Node:new(bill)
    else
        local t = {}
        for file in lfs.dir(path) do
            if file ~= '.' and file ~= '..' then
                local f = path .. '/' .. file
                local attr = assert(lfs.attributes(f))
                if attr.mode == 'directory' then
                    local node = self:tree(f)
                    if node.children == nil or next(node.children) ~= nil then
                        t[file] = node
                    end
                end
            end
        end
        return Node:new(nil, t)
    end
end

function luabill:flatten (node, array, path)
    if node.children == nil then
        table.insert(array, {
            path = path,
            data = node.data,
        })
    else
        for name, child in pairs(node.children) do
            self:flatten(child, array, path .. '/' .. name)
        end
    end
end

return luabill
