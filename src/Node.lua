local Node = {}

Node.__index = Node

function Node:new(data, children)
    local node = {}
    node.data = data
    assert(children == nil or type(children) == 'table')
    node.children = children
    return setmetatable(node, self)
end

function Node:flatten(array, path)
    if self.children == nil then
        table.insert(array, {
            path = path,
            data = self.data,
        })
    else
        for name, child in pairs(self.children) do
            child:flatten(array, path .. '/' .. name)
        end
    end
end

return Node
