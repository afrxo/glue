-- throwError.luau

return function (value, expected_type, arg, arg_name)
    if (typeof(value) == expected_type) then return end
    error(`Expected type {expected_type} to parameter [{arg_name}]({arg}), got {typeof(value)}!`)
end