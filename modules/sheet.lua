local Audio = require('modules.audio')
local Oscillator = require('modules.oscillator')
local Note = require('modules.note')

local Sheet = {}
Sheet.__index = Sheet

function Sheet:new(name)
    local o = {}
    setmetatable(o, self)

    o.sheetDir = '/'..fs.getDir(shell.getRunningProgram())..'/sheet/'..name..'/'
    o.name = name
    o:readComposition()

    return o
end

function Sheet:play()
    self.audio:play()
end

function Sheet:readComposition()
    local composition = require(self.sheetDir..'composition')

    self.sampleRate = 48000/(composition.tempo/60)/4 -- Samplerate adjusted for eigth notes
    self.audio = Audio:new(composition.tempo)

    for _, osc in pairs(composition.oscillators) do
        self.audio:insertOscillators(self:readSheet(osc))
    end
end

function Sheet:readSheet(osc)
    local path = self.sheetDir..osc.name..'.sheet'

    self.cellMatrix = self:getSheet(path)
    self.prevNotes = {}
    self.currentOsc = osc

    local oscillator = Oscillator:new(
        osc.amp,
        osc.waveform,
        osc.velocity
    )

    for y=3, #self.cellMatrix do
        local notes = {}

        for x=1, #self.cellMatrix[y] do
            local note = self:processCell(x, y)

            if note ~= nil then
                table.insert(
                    notes,
                    note
                )
            end
        end

        self.prevNotes = notes

        oscillator:appendNotes(notes)
    end

    return oscillator
end

function Sheet:processCell(x, y)
    local cell = self.cellMatrix[y][x]
    local note = nil

    if cell ~= '|' then
        local key = self.cellMatrix[1][x]..self.cellMatrix[2][x]

        if cell == '.' and self.prevNotes ~= {} then
            note = self:lengthenNote(key)
        else
            note = Note:new(
                nil,
                key,
                self.currentOsc.amp,
                self.sampleRate
            )

        end
    end

    return note
end

function Sheet:lengthenNote(key)
    for _, note in pairs(self.prevNotes) do
        if note.key == key then
            local origin = nil

            if note.isOrigin then
                origin = note
            else
                origin = note.origin
            end

            return Note:new(
                origin,
                key
            )
        end
    end

    return nil
end

function Sheet:getSheet(path)
    local file = io.open(path, 'r')
    io.input(file)

    local matrix = {}

    for line in io.lines() do
        if string.sub(line, 1, 1) ~= '-' then
            table.insert(
                matrix,
                self.stringToArray(line)
            )
        end
    end

    io.close(file)

    return matrix
end

function Sheet.stringToArray(s)
    local arr = {}

    for c in s:gmatch('.') do
        table.insert(
            arr,
            c
        )
    end

    return arr
end

return Sheet
