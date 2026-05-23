local Sine = require('modules.waves.sine')
local Saw = require('modules.waves.saw')
local Square = require('modules.waves.square')
local Triangle = require('modules.waves.triangle')
local EaseOut = require('modules.velocities.easeOut')
local Const = require('modules.velocities.const')

local Sheet = {
    tempo = 80,
    oscillators = {
        {
            name = 'lead',
            waveform = Square,
            velocity = EaseOut,
            amp = 0
        },
        {
            name = 'chords',
            waveform = Square,
            velocity = EaseOut,
            amp = 0.9
        },
        {
            name = 'bass',
            waveform = Sine,
            velocity = Const,
            amp = 0.8
        }

    }
}

return Sheet
