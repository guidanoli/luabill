local lfs = require 'lfs'

local Config = require 'luabill.config'

local LuaBill = {}

function LuaBill:loadbilldirs (billdirs, relpath, abspath)
    local billdir = self:loadbilldir(relpath, abspath)
    if billdir ~= nil then
        billdirs[abspath] = billdir
    else
        for file in lfs.dir(abspath) do
            if file ~= '.' and file ~= '..' then
                local relpath = relpath .. '/' .. file
                local abspath = abspath .. '/' .. file
                local attr = assert(lfs.attributes(abspath))
                if attr.mode == 'directory' then
                    self:loadbilldirs(billdirs, relpath, abspath)
                end
            end
        end
    end
end

function LuaBill:loadbilldir (relpath, abspath)
    local f = loadfile(abspath .. '/bills.lua')
    if f ~= nil then
        local config = Config:new(f())
        local bills = {}
        self:foreachnumdir(abspath, function (year)
            local abspath = abspath .. '/' .. year
            local billsonyear
            if config.frequency == 'monthly' then
                billsonyear = {}
                self:foreachnumdir(abspath, function (month)
                    local abspath = abspath .. '/' .. month
                    billsonyear[tonumber(month)] = self:loadbill(abspath, config)
                end)
            else
                billsonyear = self:loadbill(abspath, config)
            end
            bills[tonumber(year)] = billsonyear
        end)
        return {
            relpath = relpath,
            frequency = config.frequency,
            bills = bills,
        }
    end
end

function LuaBill:foreachnumdir (path, visit)
    for file in lfs.dir(path) do
        if file:match'^%d+$' then
            local attr = assert(lfs.attributes(path .. '/' .. file))
            if attr.mode == 'directory' then
                visit(file)
            end
        end
    end
end

function LuaBill:foreachfile (path, visit)
    for file in lfs.dir(path) do
        local attr = assert(lfs.attributes(path .. '/' .. file))
        if attr.mode == 'file' then
            visit(file)
        end
    end
end

function LuaBill:readandrstrip (path)
    local fp = assert(io.open(path))
    local text = fp:read'*a'
    fp:close()
    return text:gsub('%s+$', '')
end

function LuaBill:loadbill (path, config)
    local charged = false
    local paid = false
    local note
    self:foreachfile(path, function (file)
        charged = charged or (config.billname:match(file) ~= nil)
        paid = paid or (config.receiptname:match(file) ~= nil)
        if config.notename:match(file) then
            note = self:readandrstrip(path .. '/' .. file)
        end
    end)
    return {
        charged = charged,
        paid = paid,
        note = note,
    }
end

return LuaBill
