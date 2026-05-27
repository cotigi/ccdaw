local Sine = require('modules.waves.sine')
local Triangle = require('modules.waves.triangle')
local Square = require('modules.waves.square')
local EaseOut = require('modules.velocities.easeOut')
local Const = require('modules.velocities.const')

local Sheet = {
    tempo = 95,
    oscillators = {
        {
            name = 'lead',
            waveform = Sine,
            velocity = EaseOut,
            amp = 1
        },
        {
            name = 'chords',
            waveform = Triangle,
            velocity = Const,
            amp = 0.9
        }
    }
}

return Sheet
