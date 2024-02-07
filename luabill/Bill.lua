local Bill = {}

Bill.__index = Bill

local isfrequency = {
    m = true,
    y = true,
}

function Bill:new(t)
    if type(t) ~= 'table' then
        return nil, 'not a table'
    end
    if not isfrequency[t.frequency] then
        return nil, string.format('invalid frequency %q', t.frequency)
    end
    return setmetatable(t, self)
end

return Bill
