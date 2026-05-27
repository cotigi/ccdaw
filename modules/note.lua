local Note = {}
Note.__index = Note

local NOTES = {
    c = 16.35,
    C = 17.32,
    d = 18.35,
    D = 19.45,
    e = 20.6,
    f = 21.83,
    F = 23.12,
    g = 24.5,
    G = 25.96, a = 27.5,
    A = 29.14,
    b = 30.87
}

function Note:new(
        origin,
        key,
        amp,
        sampleRate
    )
    local o = {}
    setmetatable(
        o,
        self
    )

    o.isOrigin = (origin == nil)
    o.origin = origin

    local octave = tonumber(string.sub(key, 1, 1))
    local note = string.sub(key, 2, 2)

    o.key = key

    if origin == nil then
        o.amp = amp
        o.freq = NOTES[note] * math.pow(2, octave)

        o.sampleRate = sampleRate
        o.sampleStep = 1-- sampleRate/48000
        o.sampleIndex = 0

        o.vTime = 0
        o.pTime = 0
    end

    return o
end

function Note:getTime()
    local pTime = self.sampleIndex/48000
    local vTime = self.sampleIndex/self.sampleRate

    self:next()

    return pTime, vTime
end

function Note:next()
    self.sampleIndex = self.sampleIndex + self.sampleStep
end

return Note
