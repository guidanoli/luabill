local Node = {}

Node.__index = Node

function Node:new(data, children)
    local node = {}
    node.data = data
    node.children = children
    return setmetatable(node, self)
end

return Node
