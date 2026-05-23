local Audio = require('modules.audio')
local Oscillator = require('modules.oscillator')
local Note = require('modules.note')
local Sine = require('modules.waves.sine')
local Sheet = require('modules.sheet')

local test = Sheet:new('folyo')
test:play()

--[[
local A = Note:new(0.4, '4a')
local E = Note:new(0.4, '3e')
local C = Note:new(0.4, '4c')
local oscillator = Oscillator:new(0.7, Sine)
oscillator:insertNotesAt(1, A, C)
oscillator:insertNotesAt(2, C, E)
oscillator:insertNotesAt(3, A, E)
local audio = Audio:new(60, 3)
audio:insertOscillators(oscillator)
audio:play()
]]--
