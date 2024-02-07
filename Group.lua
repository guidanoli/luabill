local Group = {}

Group.__index = Group

function Group:new(t)
    local group = {}
    group.children = t
    return setmetatable(group, self)
end

function Group:isempty()
    return next(self.children) == nil
end

return Group
