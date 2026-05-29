local Sine = require('modules.waves.sine')
local Saw = require('modules.waves.saw')
local Square = require('modules.waves.square')
local EaseOut = require('modules.velocities.easeOut')
local Const = require('modules.velocities.const')

local Sheet = {
    tempo = 90,
    oscillators = {
        {
            name = 'chords',
            waveform = Square,
            velocity = EaseOut,
            amp = 0.7,
            sequence = {
                'chords'
            }
        },
        {
            name = 'bass',
            waveform = Saw,
            velocity = Const,
            amp = 0.9,
            sequence = {
                'bass'
            }
        }
    }
}

return Sheet
