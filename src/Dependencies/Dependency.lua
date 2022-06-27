--[[

    Base-class for all dependencies.

]]

local Dependency = {}

-- Returns the dependency's tag.
function Dependency:getTag()
    return self.tag
end

-- Appends the given dependency to the list of dependencies.
function Dependency:useDependency(Dependency)
    self.dependencies[Dependency] = true
end

-- Removes the given dependency from the list of dependencies.
function Dependency:removeDependency(Dependency)
    self.dependencies[Dependency] = nil
end

-- Gets called when the dependents of this dependency are updated.
function Dependency:_dependencyUpdated()

end

return function (tag: string)
    return setmetatable({ dependencies = {}, tag = tag }, { __index = Dependency })
end