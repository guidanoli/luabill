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

return Group
