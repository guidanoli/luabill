local lfs = require 'lfs'

local Config = require 'luabill.config'

local LuaBill = {}

function LuaBill:loadbilldirs (billdirs, path)
    local billdir = self:loadbilldir(path)
    if billdir ~= nil then
        billdirs[path] = billdir
    else
        for file in lfs.dir(path) do
            if file ~= '.' and file ~= '..' then
                local childpath = path .. '/' .. file
                local attr = assert(lfs.attributes(childpath))
                if attr.mode == 'directory' then
                    self:loadbilldirs(billdirs, childpath)
                end
            end
        end
    end
end

function LuaBill:loadbilldir (path)
    local f = loadfile(path .. '/bills.lua')
    if f ~= nil then
        local config = Config:new(f())
        local history = {}
        self:foreachnumdir(path, function (year)
            local path = path .. '/' .. year
            local yearhistory
            if config.frequency == 'monthly' then
                yearhistory = {}
                self:foreachnumdir(path, function (month)
                    local path = path .. '/' .. month
                    yearhistory[tonumber(month)] = self:loadhistory(path, config)
                end)
            else
                yearhistory = self:loadhistory(path, config)
            end
            history[tonumber(year)] = yearhistory
        end)
        return {
            frequency = config.frequency,
            history = history,
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

function LuaBill:loadhistory (path, config)
    local charged = false
    local paid = false
    local info
    self:foreachfile(path, function (file)
        charged = charged or (config.billname:match(file) ~= nil)
        paid = paid or (config.receiptname:match(file) ~= nil)
        if config.infoname:match(file) then
            info = self:readandrstrip(path .. '/' .. file)
        end
    end)
    return {
        charged = charged,
        paid = paid,
        info = info,
    }
end

return LuaBill
