local Sine = require('modules.waves.sine')
local EaseOut = require('modules.velocities.easeOut')

local Sheet = {
    tempo = 80,
    oscillators = {
        {
            name = 'lead',
            waveform = Sine,
            velocity = EaseOut,
            amp = 1,
            sequence = {
                'intro-1'--,
                --'intro-2'
            }
        }
    }
}

return Sheet
