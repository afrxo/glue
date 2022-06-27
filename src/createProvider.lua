-- createProvider.lua
-- Create and initialize a Provider as an internal dependency.

local Error = require(script.Parent.Error)
local Dependencies = require(script.Parent.Dependencies)

return function (providerDefinition)
    if (type(providerDefinition) ~= "table") then
        Error.throw(Error.new("invalidProviderDefinition"))
    end

    if (not providerDefinition.Name) then
        Error.throw(Error.new("providerNameRequired"))
    end

    local Name = providerDefinition.Name

    local provider = table.unpack(Dependencies:Capture("Provider", function(Provider)
        if (Provider.Name == Name) then
            return true
        end
    end))

    if (provider) then
        Error.throw(Error.new("providerAlreadyExists", Name))
    end

    local Dependency = Dependencies.Dependency("Provider")
    local Provider = setmetatable(providerDefinition, {__index = Dependency, __metatable = "Provider"})

    Dependencies:Use(Provider)
    return Provider.Service or Provider
end