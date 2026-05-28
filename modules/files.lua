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
    local err = ''

    for _, osc in pairs(composition.oscillators) do
        local oscPath = sheetPath..osc.name..'.sheet'

        if not fs.exists(oscPath) then
            err = err..'\t'..oscPath..'\n'
        end
    end

    -- Assert that all needed oscillator sheets exist
    assert(
        err == '',
        'The following sheet files are not found in "'..
        sheetPath..
        '":\n'..
        err
    )
end

return Files
