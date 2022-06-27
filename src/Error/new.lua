-- create
-- Create a new error object.

local internalTypes = require(script.Parent.Parent.internalTypes)

return function (errorMessage: string, ...: any): internalTypes.Error
    return {
        type = "GlueError",
        args = {...},
        message = errorMessage,
        traceback = debug.traceback(nil, 2)
    }
end