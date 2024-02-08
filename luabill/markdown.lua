local Footnotes = require 'luabill.footnotes'

local Markdown = {
    emoji = {
        check = '\u{2705}',
        fire = '\u{1F525}',
    },
    header = {'Date', 'Charged', 'Paid', 'Note'},
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
    local footnotes = Footnotes:new{}
    local abspaths = self:sortedkeys(billdirs)
    for _, abspath in ipairs(abspaths) do
        local billdir = billdirs[abspath]
        print(string.format('## `%s`', billdir.relpath))
        print()
        print(self:tableline(self.header))
        print(self:tableline(self:tablerepeat(':-:', #self.header)))
        if billdir.frequency == 'monthly' then
            self:printmonthlybody(footnotes, billdir)
        elseif billdir.frequency == 'yearly' then
            self:printyearlybody(footnotes, billdir)
        end
        print()
    end
    footnotes:print()
end

function Markdown:printmonthlybody (footnotes, billdir)
    local minyear = self:minkey(billdir.bills)
    local maxyear = self:maxkey(billdir.bills)
    for year = minyear, maxyear do
        for month = 1, 12 do
            local date = string.format('%02d/%d', month, year)
            local bill = billdir.bills[year][month]
            self:printbill(footnotes, date, bill)
        end
    end
end

function Markdown:printyearlybody (footnotes, billdir)
    local minyear = self:minkey(billdir.bills)
    local maxyear = self:maxkey(billdir.bills)
    for year = minyear, maxyear do
        local date = string.format('%d', year)
        local bill = billdir.bills[year]
        self:printbill(footnotes, date, bill)
    end
end

function Markdown:printbill (footnotes, date, bill)
    local charged = bill and bill.charged or false
    local paid = bill and bill.paid or false
    local note
    if bill and bill.note then
        local id = footnotes:add(bill.note)
        note = string.format('[^%d]', id)
    else
        note = ''
    end
    print(self:tableline{
        date,
        self:chargedemoji(charged),
        self:paidemoji(charged, paid),
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

function Markdown:chargedemoji (charged)
    return charged and self.emoji.check or ''
end

function Markdown:paidemoji (charged, paid)
    return charged and (paid and self.emoji.check or self.emoji.fire) or ''
end

return Markdown
