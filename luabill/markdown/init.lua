local Footnotes = require 'luabill.markdown.footnotes'

local Markdown = {
    emoji = {
        check = '\u{2705}',
        fire = '\u{1F525}',
        siren = '\u{1f6a8}',
    },
    header = {'Date', 'Status', 'Note'},
}

function Markdown:minkey (t)
    local min = next(t)
    for k in pairs(t) do
        if k < min then
            min = k
        end
    end
    return min
end

function Markdown:maxkey (t)
    local max = next(t)
    for k in pairs(t) do
        if k > max then
            max = k
        end
    end
    return max
end

function Markdown:sortedkeys (t)
    local keys = {}
    for k, v in pairs(t) do
        table.insert(keys, k)
    end
    table.sort(keys)
    return keys
end

function Markdown:print (billdirs)
    local now = os.date'*t'
    local footnotes = Footnotes:new{}
    local abspaths = self:sortedkeys(billdirs)
    for _, abspath in ipairs(abspaths) do
        local billdir = billdirs[abspath]
        print(string.format('## `%s`', billdir.relpath))
        print()
        print(self:tableline(self.header))
        print(self:tableline(self:tablerepeat(':-:', #self.header)))
        if billdir.frequency == 'monthly' then
            self:printmonthlybody(now, footnotes, billdir)
        elseif billdir.frequency == 'yearly' then
            self:printyearlybody(now, footnotes, billdir)
        end
        print()
    end
    footnotes:print()
end

function Markdown:cmpdates (now, year, month)
    if month then
        return (now.year - year) * 12 + (now.month - month)
    else
        return (now.year - year) * 12
    end
end

function Markdown:printmonthlybody (now, footnotes, billdir)
    local minyear = self:minkey(billdir.bills)
    local maxyear = math.max(now.year, self:maxkey(billdir.bills))
    local foundfirstbill = false
    for year = minyear, maxyear do
        for month = 1, 12 do
            local cmp = self:cmpdates(now, year, month)
            local date = string.format('%02d/%d', month, year)
            local bill = billdir.bills[year][month]
            if bill then
                foundfirstbill = true
            end
            if foundfirstbill then
                self:printbill(footnotes, date, bill, cmp)
            end
        end
    end
end

function Markdown:printyearlybody (now, footnotes, billdir)
    local minyear = self:minkey(billdir.bills)
    local maxyear = math.max(now.year, self:maxkey(billdir.bills))
    for year = minyear, maxyear do
        local cmp = self:cmpdates(now, year)
        local date = string.format('%d', year)
        local bill = billdir.bills[year]
        self:printbill(footnotes, date, bill, cmp)
    end
end

function Markdown:printbill (footnotes, date, bill, cmp)
    local status
    if cmp == 0 then
        status = self.emoji.siren .. ' Awaiting Bill'
    elseif cmp > 0 then
        status = self.emoji.siren .. ' Missing Bill'
    else
        status = ''
    end
    if bill then
        if bill.charged then
            if bill.paid then
                status = self.emoji.check .. ' Paid'
            else
                status = self.emoji.fire .. ' Not Paid'
            end
        else
            if bill.paid then
                status = self.emoji.siren .. ' Missing Bill'
            end
        end
    end
    local note
    if bill and bill.note then
        local id = footnotes:add(bill.note)
        note = string.format('[^%d]', id)
    else
        note = ''
    end
    print(self:tableline{
        date,
        status,
        note,
    })
end

function Markdown:tableline (t)
    return string.format('| %s |', table.concat(t, ' | '))
end

function Markdown:tablerepeat (v, n)
    local t = {}
    for i = 1, n do
        table.insert(t, v)
    end
    return t
end

return Markdown
