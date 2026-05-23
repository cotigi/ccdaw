local EaseOut = {}

function EaseOut.at(t)
    if t > 1 then t = 1 end

    return math.min(
        1,
        1.2-math.sin(t*math.pi/2)
    )
end

return EaseOut
