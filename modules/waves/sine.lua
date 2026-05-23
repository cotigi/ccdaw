local Sine = {}

function Sine.at(freq, t)
    return math.sin(2*math.pi*freq*t)
end

return Sine
