local Group = {}

Group.__index = Group

function Group:new(t)
    local group = {}
    group.children = t
    return setmetatable(group, self)
end

function Group:isempty()
    for key, child in pairs(self.children) do
        if not child:isempty() then
            return false
        end
    end
    return true
end

return Group
