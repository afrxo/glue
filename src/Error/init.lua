-- Error
-- The Error class is used to throw errors.

local new = require(script:WaitForChild("new"))
local throw = require(script:WaitForChild("throw"))
local assert = require(script:WaitForChild("assert"))
local messages = require(script:WaitForChild("messages"))

return {
    new = new,
    throw = throw,
    assert = assert,
    messages = messages
}