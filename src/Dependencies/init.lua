--[[

    Compact class that handles dependency injection.

]]

local DependencyBaseClass = require(script:WaitForChild("Dependency"))

--[[

    Specifies a dependency is dependant on all other dependencies.

]]
local SpecialKeyAll = {
    type = "SpecialKey",
    name = "All"
}

local DependencyManager = setmetatable( {}, {__metatable = "DependencyManager"} )
DependencyManager.Dependency = DependencyBaseClass
DependencyManager.SpecialKeys = { SpecialKeyAll = SpecialKeyAll }
DependencyManager.DependencyList = {}
DependencyManager.DependencyCount = 0
DependencyManager.Hooks = {}


--[[

    Captures a set of dependencies tagged with a given tag.

]]
function DependencyManager:Capture(tag: string, filter)
    local CapturedDependencies = {}
    table.foreach(self.DependencyList, function(Dependency)
        if (Dependency:getTag() == tag) then
            if (not filter) then
                table.insert(CapturedDependencies, Dependency)
            else
                if (filter(Dependency)) then
                    table.insert(CapturedDependencies, Dependency)
                end
            end
        end
    end)
    return CapturedDependencies
end


--[[

    Appends the given dependency to the list of dependencies.

]]
function DependencyManager:Use(Dependency)
    if (not self.DependencyList[Dependency]) then
        self.DependencyList[Dependency] = true
        self.DependencyCount = self.DependencyCount + 1
    end
end


--[[

    Removes the given dependency from the list of dependencies.

]]
function DependencyManager:Remove(Dependency)
    if (self.DependencyList[Dependency]) then
        self.DependencyList[Dependency] = nil
        self.DependencyCount = self.DependencyCount - 1
    end
end


--[[

    Updates all dependencies dependant on the given dependency.

]]
function DependencyManager:Update(DependencyToUpdate)
    for Dependency in pairs(self.DependencyList) do
        if (Dependency.dependencies[DependencyToUpdate:getTag()]) or (Dependency.dependencies[DependencyToUpdate]) or (Dependency.dependencies[SpecialKeyAll]) then
            task.spawn(Dependency._dependencyUpdated, Dependency, DependencyToUpdate)
        end
    end
end



return DependencyManager