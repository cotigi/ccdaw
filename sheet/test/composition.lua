local Sine = require('modules.waves.sine')
local Saw = require('modules.waves.saw')
local Square = require('modules.waves.square')
local EaseOut = require('modules.velocities.easeOut')

local Sheet = {
    tempo = 110,
    oscillators = {
        {
            name = 'lead',
            waveform = Square,
            velocity = EaseOut,
            amp = 1, --0.8
            sequence = {
                'lead',
                'lead',
                'lead2',
                'lead2',
                'lead3',
                'lead3',
                'lead4',
                'lead4'
            }
        }
    }
}

return Sheet
