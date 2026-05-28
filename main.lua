local Sheet = require('modules.sheet')
local Files = require('modules.files')

local name = arg[1]
Files.checkSheet(name)

local test = Sheet:new(name)
test:play()
