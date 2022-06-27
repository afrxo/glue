--[[

    Wrapper for RemoteEvents.

]]


local ThrowError = error

local Dependencies = require(script.Parent.Parent.Dependencies)
local NetworkCore = require(script.Parent:WaitForChild("Core"))

local RunService = game:GetService("RunService")
local isServer = RunService:IsServer()
local isClient = RunService:IsClient()

--[=[
    @interface NetworkEvent
    @within Network
    .OnEvent (NetworkEvent, ...Middleware) -> ()
    .Fire (NetworkEvent, ...any) -> ()
]=]
local Event = {}


function Event.new(Name: string, asDependency: boolean?)
    local Dependency = Dependencies.Dependency("NetworkEvent")
    local New = setmetatable({ Name = Name  }, { __index = Dependency, __metatable = "NetworkEvent" })

    --[[

        Sets the event's middleware.

    ]]
    function New:OnEvent(...)
        local Callbacks = {...}
        for _, Callback in ipairs(Callbacks) do
            if (type(Callback) ~= "function") then
                ThrowError("Expected a function, got a " .. type(Callback) .. " instead.", 2)
            end
        end
        self._callbacks = Callbacks
    end


    --[[

        Fires the event.

    ]]
    function New:Fire(...)
        if (isServer) then
            self._remote:FireClient(select(1, ...), select(2, ...))
        elseif (isClient) then
            self._remote:FireServer(...)
        end
    end

    NetworkCore:BuildNetworkEvent(New)

    if (asDependency) then
        Dependencies:Use(New)
        Dependencies:Update(New)
    end

    return New
end


return function ()
    return function (Name: string?)
        if (type(Name) ~= "string") then
            ThrowError("Expected a string, got a " .. type(Name) .. " instead.")
        end
        return Event.new(Name, true)
    end, function(Remote: RemoteEvent?)
        if (not ((typeof(Remote) == "Instance") and (Remote.ClassName == "RemoteEvent"))) then
            ThrowError("Expected a RemoteEvent, got a " .. typeof(Remote) .. " instead.")
        end
        local New = Event.new(Remote.Name, false)
        NetworkCore:BuildFromRemote(Remote, New)
        return New
    end
end