local Bill = {}

Bill.__index = Bill

function Bill:new(t)
    return setmetatable(t, self)
end

function Bill:isempty()
    return false
end

return Bill
