local Sine = require('modules.waves.sine')
local Square = require('modules.waves.square')
local EaseOut = require('modules.velocities.easeOut')

local Sheet = {
    tempo = 60,
    oscillators = {
        {
            name = 'lead',
            waveform = Sine, --Square,
            velocity = EaseOut,
            amp = 0.8
        }
    }
}

return Sheet
