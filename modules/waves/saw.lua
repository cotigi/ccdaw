local Saw = {}

function Saw.at(freq, t)
    --[[
    return 0.637 * math.atan(
        math.tan(
            t*freq*1.57
        )
    )
    ]]--

    return ((t*freq)%1)-0.5
end

return Saw
