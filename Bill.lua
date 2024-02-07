local Bill = {}

Bill.__index = Bill

function Bill:new(t)
    local bill = {}
    bill.frequency = t.frequency or 'monthly'
    bill.slip = t.slip or 'Boleto'
    bill.payment = t.payment or 'Comprovante'
    return setmetatable(bill, self)
end

function Bill:isempty()
    return false
end

return Bill
