local Sine = require('modules.waves.sine')
local EaseOut = require('modules.velocities.easeOut')

local Sheet = {
    tempo = 120,
    oscillators = {
        {
            name = 'lead',
            waveform = Sine,
            velocity = EaseOut,
            amp = 1
        }
    }
}

return Sheet
