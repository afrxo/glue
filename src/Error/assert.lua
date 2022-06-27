-- assert
-- Assert that a condition is true. If it is not, throw an error.

-- @param condition boolean The condition to assert.
-- @param message string The message to throw if the condition is false.
return function (condition: boolean, message: string)
    if not condition then
        error(message, 2)
    end
end