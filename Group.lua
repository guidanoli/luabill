local Group = {}

Group.__index = Group

function Group:new(t)
    return setmetatable(t, self)
end

function Group:isempty()
    for name, child in pairs(self) do
        if not child:isempty() then
            return false
        end
    end
    return true
end

function Group:isleaf()
    return false
end

function Group:children()
    return pairs(self)
end

return Group
