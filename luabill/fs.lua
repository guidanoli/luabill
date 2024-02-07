local lfs = require 'lfs'

local Bill = require 'luabill.Bill'

local fs = {}

function fs:loadbills (path, bills)
    local loadt = loadfile(path .. '/bill.lua')
    if loadt ~= nil then
        local t = loadt()
        local bill, err = Bill:new(t)
        if not bill then
            error(string.format('"%s": %s', path, err))
        end
        table.insert(bills, {
            bill = bill,
            path = path,
        })
    else
        for file in lfs.dir(path) do
            if file ~= '.' and file ~= '..' then
                local childpath = path .. '/' .. file
                local attr = assert(lfs.attributes(childpath))
                if attr.mode == 'directory' then
                    self:loadbills(childpath, bills)
                end
            end
        end
    end
end

return fs
