local Footnotes = {}

Footnotes.__index = Footnotes

function Footnotes:new (t)
    return setmetatable(t, self)
end

function Footnotes:add (footnote)
    table.insert(self, footnote)
    return #self
end

function Footnotes:print ()
    for id, footnote in ipairs(self) do
        print(string.format('[^%d]: %s', id, footnote))
    end
end

return Footnotes
