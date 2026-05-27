local speaker = peripheral.find('speaker')

local Audio = {}
Audio.__index = Audio

function Audio:new(tempo)
    local o = {}
    setmetatable(o, self)

    o.tempo = tempo
    o.oscillators = {}

    o.eigthNote = 48000/(tempo/60)/4

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

        if oscAmp == 0 then
            nullCounter = nullCounter + 1
        end

        amp = amp + oscAmp
    end

    return 127*amp/math.max(
        1,
        #self.oscillators-nullCounter
    )
end

function Audio:genBuffer()
    local buffer = {}

    -- Number of eigth notes in the sheet
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

    local totalBuffers = math.floor(#buffer/48000)
    local bottom = 0
    local top = 0

    for n=0, totalBuffers-1 do
        bottom = n*48000 + 1
        top = (n+1)*48000

        table.insert(
            buffers,
            {
                table.unpack(buffer, bottom, top)
            }
        )
    end

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
        while not speaker.playAudio(buffer) do
            os.pullEvent('speaker_audio_empty')
        end
        sleep(self.tempo/60/4)
    end
end

return Audio
