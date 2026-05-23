local Sine = require('modules.waves.sine')
local Square = {}

function Square.at(freq, t)
    return Square.sign(
        math.sin(2*math.pi*freq*t)
    )
end

function Square.sign(x)
    if x == 0 then return 0 end

    return x / math.abs(x)
end

return Square
