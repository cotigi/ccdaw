local Oscillator = {}
Oscillator.__index = Oscillator

function Oscillator:new(
        amp,
        waveform,
        velocity
    )
    local o = {}
    setmetatable(o, self)

    o.amp = amp
    o.waveform = waveform
    o.velocity = velocity
    o.pianoRoll = {}

    return o
end

function Oscillator:insertNotesAt(nth, notes)
    -- Nth position is prefixed with empty ones
    if #self.pianoRoll+1 < nth then
        -- Fill empty positions
        for _=1, nth-#self.pianoRoll-1 do
            table.insert(
                self.pianoRoll,
                {}
            )
        end

        -- Insert notes at nth position
        table.insert(
            self.pianoRoll,
            notes
        )

    -- Nth position is exactly the next
    elseif #self.pianoRoll+1 == nth then
        table.insert(
            self.pianoRoll,
            notes
        )
    -- Nth position should be concatinated
    -- with the new notes
    else
        self.pianoRoll[nth] = {
            table.unpack(self.pianoRoll[nth]),
            table.unpack(notes)
        }
    end
end

function Oscillator:getNotesAt(nth)
    local notes = {}

    for _, col in pairs(self.pianoRoll) do
        for _, note in pairs(col) do
            if note.sampleStart <= nth and
               nth <= note.sampleEnd then
                table.insert(
                    notes,
                    note
                )
            end
        end
    end

    return notes
end

function Oscillator:ampAt(nth, sampleIndex)
    local notes = self.pianoRoll[nth]
    if notes == nil then return 0 end
    if #notes == 0 then return 0 end

    local amp = 0

    for _, note in pairs(notes) do
        local origin = nil

        if note.isOrigin then
            origin = note
        else
            origin = note.origin
        end

        local pTime, vTime = origin:getTime()
        amp = amp + (
            origin.amp*self.velocity.at(vTime)
        )*self.waveform.at(origin.freq, pTime)
    end

    return amp/#notes
end

return Oscillator
