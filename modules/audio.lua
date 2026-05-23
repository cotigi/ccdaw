local speaker = peripheral.find('speaker')

local Audio = {}
Audio.__index = Audio

function Audio:new(tempo)
    local o = {}
    setmetatable(o, self)

    o.tempo = tempo
    o.sampleIndex = 0
    o.sampleRate = Audio.calcSampleRate(o.tempo)
    o.sampleStep = o.sampleRate/48000
    o.oscillators = {}
    o.length = 0

    return o
end

function Audio:time()
    self.sampleIndex = self.sampleIndex+self.sampleStep

    --[[
    if self.sampleIndex > self.sampleRate then
        self.sampleIndex = 0
    end
    ]]--

    return self.sampleIndex/self.sampleRate
end

function Audio.calcSampleRate(tempo)
    return 48000/(tempo/60)/4--/2
end

function Audio:insertOscillators(...)
    for _, osc in pairs({...}) do
        table.insert(
            self.oscillators,
            osc
        )
    end
end

function Audio:dumpOscillators()
    self.oscillators = {}
end

function Audio:genAmp(nth, sampleIndex, t)
    local amp = 0
    local nullCounter = -1

    for _, osc in pairs(self.oscillators) do
        local oscAmp = osc:ampAt(nth, sampleIndex)

        if oscAmp == 0 then
            nullCounter = nullCounter + 1
        end

        amp = amp + oscAmp
    end

    return math.floor(127*amp/(#self.oscillators-nullCounter))
end

function Audio:genBuffer()
    local buffer = {}

    for n=1, self.length do
        for minorIndex=0, self.sampleRate do
            table.insert(
                buffer,
                self:genAmp(
                    n,
                    (n-1)*self.sampleRate + minorIndex,
                    self:time()
                )
            )
        end
    end


    return buffer
end

function Audio:getBuffers()
    local buffer = self:genBuffer()
    local buffers = {}
    local base = 1

    for i=1, #buffer do

        if i%48000 == 0 then
            table.insert(
                buffers,
                {table.unpack(buffer, base, i)}
            )

            base = i+1

            if #buffer-i < 48000 then
                table.insert(
                    buffers,
                    {table.unpack(buffer, i+1, #buffer)}
                )

                goto done
            end
        end
    end

    ::done::

    return buffers
end

function Audio:play()
    local buffers = self:getBuffers()

    for _, buffer in pairs(buffers) do
        while not speaker.playAudio(buffer) do
            os.pullEvent('speaker_audio_empty')
        end
        sleep(self.tempo/60/4)
    end
end

return Audio
