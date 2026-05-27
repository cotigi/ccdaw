local speaker = peripheral.find('speaker')

local Audio = {}
Audio.__index = Audio

function Audio:new(tempo)
    local o = {}
    setmetatable(o, self)

    o.tempo = tempo
    o.oscillators = {}

    -- Originally 48000/(tempo/60)/4
    -- Adjusted to eigth note length
    -- One eigth note consists of "eigthNote" 
    -- or 720.000/tempo values
    o.eigthNote = 720000/tempo

    return o
end

function Audio:insertOscillators(...)
    for _, osc in pairs({...}) do
        table.insert(
            self.oscillators,
            osc
        )
    end
end

function Audio:getLength()
    local length = 0

    for _, osc in pairs(self.oscillators) do
        length = math.max(
            length,
            #osc.pianoRoll
        )
    end

    return length
end

function Audio:genAmp(nth)
    local amp = 0
    local nullCounter = 0

    for _, osc in pairs(self.oscillators) do
        local oscAmp = osc:ampAt(nth)

        -- When an oscillator doesn't play
        -- it needs to be ignored in the
        -- normalization process.
        if oscAmp == 0 then
            nullCounter = nullCounter + 1
        end

        amp = amp + oscAmp
    end

    -- First I normalize the amplitude
    -- with the number of playing oscillators
    -- (incase that no oscillator plays I
    -- will divide by 1) and then
    -- multiply the amplitude with 127
    -- to fill out the amplitude range
    -- (amplitude range is [-128; 127]).
    return 127*amp/math.max(
        1,
        #self.oscillators-nullCounter
    )
end

function Audio:genBuffer()
    local buffer = {}

    -- Nth eigth note in the sheet
    for nth=1, self:getLength() do
        -- Number of samples an eigth note consists of
        for _=1, self.eigthNote do
            -- Clamp amplitude to [-128; 127]
            local amp = math.max(
                -128,
                math.min(
                    127,
                    self:genAmp(nth)
                )
            )

            table.insert(
                buffer,
                amp
            )
        end
    end

    return buffer
end

function Audio:chopBuffer()
    local buffer = self:genBuffer()
    local buffers = {}

    -- Number of buffers I can 
    -- completely fill up. 
    local totalBuffers = math.floor(#buffer/48000)

    -- Range for array slicing
    local bottom = 0
    local top = 0

    for n=0, totalBuffers-1 do
        -- Calculating range so that [n*48.000+1; (n+1)48.000]
        -- Example:
        --   - [1; 48.000]
        --   - [48.001; 96.000]
        --   - [96.001; <#buffer>] - Remaining values
        bottom = n*48000 + 1
        top = (n+1)*48000

        table.insert(
            buffers,
            {
                table.unpack(buffer, bottom, top)
            }
        )
    end

    -- If 48.000 is not a factor of #buffer
    -- then add the remaining values to a buffer
    if #buffer%48000 ~= 0 then
        bottom = totalBuffers*48000 + 1
        top = #buffer

        table.insert(
            buffers,
            {
                table.unpack(buffer, bottom, top)
            }
        )
    end

    return buffers
end

function Audio:play()
    local buffers = self:chopBuffer()

    for _, buffer in pairs(buffers) do
        -- Check if the audio backlog is overflown
        -- and queue the overflown backlog for
        -- later playing.
        -- I try to minimize this case with 
        -- a sleep(x) function below.
        while not speaker.playAudio(buffer) do
            os.pullEvent('speaker_audio_empty')
        end

        -- Sleep for x seconds to wait 
        -- for empty backlog space.
        -- If the backlog in too big,
        -- new chunks will be dropped!
        sleep(self.tempo/60/4)
    end
end

return Audio
