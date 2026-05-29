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
    print('Reading')
    local composition = require(self.sheetDir..'composition')

    -- Originally 48000/(tempo/60)/4
    -- Adjusted to eigth note length
    -- One eigth note consists of "sampleRate" 
    -- or 720.000/tempo values
    self.sampleRate = 720000/composition.tempo
    self.audio = Audio:new(composition.tempo)

    for _, osc in pairs(composition.oscillators) do
        self.currentOsc = osc
        self.audio:insertOscillators(self:readSequence())
    end
end

function Sheet:readSequence()
    local oscillator = Oscillator:new(
        self.currentOsc.amp,
        self.currentOsc.waveform,
        self.currentOsc.velocity
    )


    -- Go through all the patterns specified
    -- in the given sequence array.
    for _, pattern in pairs(self.currentOsc.sequence) do
        -- Example directory structure:
        -- <path_to_main>/sheet/<sheet_name>/<osc_name>/<pattern_name>.sheet
        local path = self.sheetDir..self.currentOsc.name..'/'..pattern..'.sheet'
        print(path)

        -- Tables are always passed as reference.
        -- No need to return.
        self:readSheet(oscillator, path)
    end

    return oscillator
end

function Sheet:readSheet(oscillator, path)
    self.cellMatrix = self:getSheet(path)
    self.prevNotes = {}

    -- Starting from the 3rd line to 
    -- ignore the octave and note lines
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
end

function Sheet:processCell(x, y)
    local cell = self.cellMatrix[y][x]
    local note = nil

    if cell == '|' then return note end

    local key = self.cellMatrix[1][x]..self.cellMatrix[2][x]

    -- Check for sustain note
    if cell == '.' then
        local origin = self:containsKey(self.prevNotes, key)

        -- If origin note is nil,
        -- then I process the sustain
        -- as an impact note.
        if origin ~= nil then
            note = Note:new(
                origin,
                key
            )
        else
            note = Note:new(
                nil,
                key,
                self.currentOsc.amp,
                self.sampleRate
            )
        end
    -- Check for impact note
    elseif cell == 'X' then
        note = Note:new(
            nil,
            key,
            self.currentOsc.amp,
            self.sampleRate
        )
    end

    return note
end

function Sheet:containsKey(arr, key)
    for _, note in pairs(arr) do
        if note.key == key then
            local origin = note.origin

            if note.isOrigin then
                origin = note
            end

            return origin
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
