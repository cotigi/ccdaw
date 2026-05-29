local Sine = require('modules.waves.sine')
local Const = require('modules.velocities.const')

local Oscillator = {}
Oscillator.__index = Oscillator

function Oscillator:new(
        amp,
        waveform,
        velocity
    )
    local o = {}
    setmetatable(o, self)

    -- If an argument is nil then
    -- use the default value:
    --  - waveform -> Sine
    --  - velocity -> Const
    --  - amp      -> 1
    o.waveform = waveform or Sine
    o.velocity = velocity or Const
    o.amp = amp or 1
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
    -- Incase of a shorter oscillator return amp = 0
    if notes == nil then return 0 end
    -- Incase of a rest (no notes played) return amp = 0
    if #notes == 0 then return 0 end

    local amp = 0

    for _, note in pairs(notes) do
        local origin = nil

        -- Get origin in case of
        -- a sustain note
        if note.isOrigin then
            origin = note
        else
            origin = note.origin
        end

        -- Get primary and velocity time
        local pTime, vTime = origin:getTime()
        -- get amplitude with the following equation:
        -- amp*v(vtime)*w(freq, ptime)
        amp = amp + (
            origin.amp*self.velocity.at(vTime)
        )*self.waveform.at(origin.freq, pTime)
    end

    -- Normalize the amplitude
    return amp--/#notes
end

return Oscillator
