local Sine = require('modules.waves.sine')
local Saw = require('modules.waves.saw')
local Square = require('modules.waves.square')
local EaseOut = require('modules.velocities.easeOut')

local Sheet = {
    tempo = 60,
    oscillators = {
        {
            name = 'lead',
            waveform = Saw,
            velocity = EaseOut,
            amp = 0.6
        }
    }
}

return Sheet
