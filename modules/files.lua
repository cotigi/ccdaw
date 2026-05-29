local Files = {}

-- Check if sheet has all the necessary components.
-- If succesful, the program continues.
-- Otherwise one of the asserts will
-- throw an error.
function Files.checkSheet(name)
    local sheetPath = '/'..fs.getDir(
        shell.getRunningProgram()
    )..'/sheet/'..name..'/'

    -- Assert that sheet dir exists
    assert(
        fs.exists(sheetPath),
        'Sheet "'..
        sheetPath..
        '" doesn\'t exist'
    )

    local compPath = sheetPath..'composition.lua'

    -- Assert that composition.lua exists
    assert(
        fs.exists(compPath),
        'Composition file for "'..
        name..
        '" doesn\'t exist'
    )

    local composition = require(sheetPath..'composition')
    -- The following attributes will be
    -- set a given default value when missing:
    --  - waveform -> Sine
    --  - velocity -> Const
    --  - amp      -> 1
    local mandatoryAttributes = {
        'name',
        'sequence'
    }
    local attributeErr = ''

    for i, osc in pairs(composition.oscillators) do
        -- If the name attribute is absent
        -- then use the given index number.
        local name = osc.name or i

        -- Check for mandatory attributes
        for _, attribute in pairs(mandatoryAttributes) do
            if osc[attribute] == nil then
                attributeErr = attributeErr..
                '\t'..
                name..
                '.'..
                attribute..
                '\n'
            end
        end
    end

    -- Assert that all mandatory attributes exist
    assert(
        attributeErr == '',
        'The following oscillator attributes are not set "'..
        sheetPath..
        '":\n'..
        attributeErr
    )

    local oscErr = ''

    for _, osc in pairs(composition.oscillators) do
        local oscPath = sheetPath..osc.name..'/'

        -- Check for pattern directory
        if not fs.exists(oscPath) then
            oscErr = oscErr..'\t'..oscPath..'\n'
        end
    end

    -- Assert that all needed oscillator sheets exist
    assert(
        oscErr == '',
        'The following oscillator parrent directories are not found in "'..
        sheetPath..
        '":\n'..
        oscErr
    )

    local patternErr = ''

    for _, osc in pairs(composition.oscillators) do
        local oscPath = sheetPath..osc.name..'/'

        -- Check for all the patterns used
        for _, pattern in pairs(osc.sequence) do
            local patternPath = oscPath..pattern..'.sheet'

            if not fs.exists(patternPath) then
                patternErr = patternErr..'\t'..patternPath..'\n'
            end
        end
    end

    -- Assert that all needed oscillator sheets exist
    assert(
        patternErr == '',
        'The following oscillator parrents are not found in "'..
        sheetPath..
        '":\n'..
        patternErr
    )
end

return Files
