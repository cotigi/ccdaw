local Sine = require('modules.waves.sine')
local Square = require('modules.waves.square')
local EaseOut = require('modules.velocities.easeOut')

local Sheet = {
    tempo = 80,
    oscillators = {
        {
            name = 'lead',
            waveform = Square,
            velocity = EaseOut,
            amp = 1
        }
    }
}

return Sheet
