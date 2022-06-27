--[[

    Wrapper for RemoteFunctions.

]]

local ThrowError = error
local Dependencies = require(script.Parent.Parent.Dependencies)
local NetworkCore = require(script.Parent:WaitForChild("Core"))

local RunService = game:GetService("RunService")
local isServer = RunService:IsServer()
local isClient = RunService:IsClient()

--[=[
    @interface NetworkFunction
    @within Network
    .Invoke ((Player, ...any) -> ()) & ((...any) -> ())
    .OnInvoke (function (Player, ...any) -> ())
]=]
local Function = {}

function Function.new(Name: string, asDependency: boolean?)
    local Dependency = Dependencies.Dependency("NetworkFunction")
    local New = setmetatable({ Name = Name  }, { __index = Dependency, __metatable = "NetworkFunction" })

    --[[

        Sets the function's middleware.

    ]]
    function New:OnInvoke(...)
        local Callbacks = {...}
        for _, Callback in ipairs(Callbacks) do
            if (type(Callback) ~= "function") then
                ThrowError("Expected a function, got a " .. type(Callback) .. " instead.", 2)
            end
        end
        self._callbacks = Callbacks
    end


    --[[

        Invokes the function.

    ]]
    function New:Invoke(...)
        if (isServer) then
            return self._remote:InvokeClient(select(1, ...), select(2, ...))
        elseif (isClient) then
            return self._remote:InvokeServer(...)
        end
    end

    NetworkCore:BuildNetworkFunction(New)

    if (asDependency) then
        Dependencies:Use(New)
        Dependencies:Update(New)
    end

    return New
end

return function ()
    return function (Name: string?)
        if (type(Name) ~= "string") then
            ThrowError("Expected a string, got a " .. type(Name) .. " instead.", 2)
        end
        return Function.new(Name, true)
    end, function(Remote: RemoteFunction?)
        if (not ((typeof(Remote) == "Instance") and (Remote.ClassName == "RemoteFunction"))) then
            ThrowError("Expected a RemoteFunction, got a " .. typeof(Remote) .. " instead.")
        end
        local New = Function.new(Remote.Name, false)
        NetworkCore:BuildFromRemote(Remote, New)
        return New
    end
end