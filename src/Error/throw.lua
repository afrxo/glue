-- throw.lua
-- Throw a Glue error.

local messages = require(script.Parent.messages)
local internalTypes = require(script.Parent.Parent.internalTypes)

local outputFormat = "[Glue] %s\n<ID: %s>\n---\tStack Trace\t---\n%s"

-- @param errorObject table The error to throw.
return function (errorObject: internalTypes.Error?)
    if (type(errorObject) ~= "table") or (errorObject == nil) or (errorObject.type ~= "GlueError") then
        error(messages.invalidErrorObject, 2)
    end

    local formatString: string
    if (messages[errorObject.message] ~= nil) then
        formatString = messages[errorObject.message]
    else
        formatString = messages.unkownErrorMessage:gsub("ERROR", errorObject.message)
        errorObject.message = "unkownErrorMessage"
    end

    formatString = formatString:format(unpack(errorObject.args))
    local output = outputFormat:format(formatString, errorObject.message, errorObject.traceback)
    error(output, 0)
end