local Triangle = {}

function Triangle.at(freq, t)
    --[[
    return (2/math.pi)*math.asin(
        math.sin(
            math.pi*freq*t
        )
    )
    ]]--

    if (t*freq)%1 < 0.5 then
        return ((t*freq)%1)*4-1
    else
        return 3+((t*freq)%1)*(-4)
    end
end

return Triangle
