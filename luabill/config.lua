local lpeg = require 'lpeg'

local Config = {
    frequency = 'monthly',
    billname = lpeg.P'Bill',
    receiptname = lpeg.P'Receipt',
    notename = lpeg.P'README',
}

Config.__index = Config

function Config:new (t)
    return setmetatable(t, self)
end

return Config
