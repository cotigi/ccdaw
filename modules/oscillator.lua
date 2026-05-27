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

function Oscillator:appendNotes(notes)
    table.insert(
        self.pianoRoll,
        notes
    )
end

function Oscillator:ampAt(nth)
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
