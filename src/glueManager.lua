-- glueManager.lua
-- Manages glues internal tasks.

local Error = require(script.Parent.Error)
local Dependencies = require(script.Parent.Dependencies)

local ImportPaths;

-- Set the configured extensions.
local function UseExtensions(Extensions)
    for extension, transform in pairs(Extensions) do
        local Dependency = Dependencies.Dependency("Extension")
        local ExtensionObject = setmetatable({transform = transform, name = extension}, {__index = Dependency})
        Dependencies:Use(ExtensionObject)
    end
end

-- Set the configured import paths.
local function UseImportPaths(Imports)
    if (ImportPaths ~= nil) then
        Error.throw(Error.new("importsAlreadySet"))
    end

    if (not Imports) then
        Error.throw(Error.new("zeroArguments"))
    end

    if ((type(Imports) ~= "table") and (typeof(Imports) ~= "Instance")) then
        Error.throw(Error.new("invalidImports"))
    end

    ImportPaths = typeof(Imports) == "Instance" and {Imports} or type(Imports) == "table" and Imports
end

-- Get a Provider by name.
function GetProvider(Name: string, forceProvider)
    local Provider = table.unpack(Dependencies:Capture("Provider", function(Dependency)
        if (Dependency.Name == Name) then
            return true
        end
        return false
    end))

    if (Provider) then
        if (forceProvider) then
            return Provider
        end
        -- Expose the provider's service if it exists.
        return Provider.Service or Provider
    end
end

-- Gets the configured import paths.
function GetImportPaths()
    if (not ImportPaths) then
        Error.throw(Error.new("importsHaventBeenSet"))
    end

    local PackageImportPaths = {}
    for _, PackageImportPath in pairs(ImportPaths) do
        -- Relative Directory
        table.insert(PackageImportPaths, PackageImportPath)
        -- Absolute Directory
        table.insert(PackageImportPaths, PackageImportPath.Parent)
    end
    return PackageImportPaths
end

return {
    GetProvider = GetProvider;
    UseExtensions = UseExtensions;
    UseImportPaths = UseImportPaths;
    GetImportPaths = GetImportPaths;
}