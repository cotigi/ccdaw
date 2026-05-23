local Sine = require('modules.waves.sine')
local Saw = require('modules.waves.saw')
local Square = require('modules.waves.square')
local EaseOut = require('modules.velocities.easeOut')
local Const = require('modules.velocities.const')

local Sheet = {
    tempo = 120,
    oscillators = {
        {
            name = 'lead',
            waveform = Saw,
            velocity = Const,--EaseOut,
            amp = 0.4
        }
    }
}

return Sheet
