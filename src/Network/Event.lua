--[[

    Wrapper for RemoteEvents.

]]


local ThrowError = error

local glueUtil = require(script.Parent.Parent.glueUtil)
local Dependencies = require(script.Parent.Parent.Dependencies)
local NetworkCore = require(script.Parent:WaitForChild("Core"))

local RunService = game:GetService("RunService")
local isServer = RunService:IsServer()
local isClient = RunService:IsClient()

--[=[
    @interface NetworkEvent
    @within Network
    .OnEvent (NetworkEvent, ...Middleware) -> ()
    .Connect (NetworkEvent, ...Middleware) -> EventConnection
    .Once (NetworkEvent, ...Middleware) -> EventConnection
    .Fire (NetworkEvent, ...any) -> ()
    .FireAll (NetworkEvent, ...any) -> ()
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

    function New:Connect(...)
        local Callbacks = {...}
        for _, Callback in ipairs(Callbacks) do
            if (type(Callback) ~= "function") then
                ThrowError("Expected a function, got a " .. type(Callback) .. " instead.", 2)
            end
        end

        local connectionId = #self._connections + 1
        local connection = {
            id = connectionId,
            callbacks = Callbacks,
            Disconnect = function(conn)
                self._connections[connectionId] = nil
                conn.Connected = false
            end,
            Connected = true
        }

        self._connections[connectionId] = connection
        return connection
    end

    --[[

        Connects to an event once and disconnects intertnally.

    ]]
    function New:Once(...)
        local connection; connection = self:Connect(table.unpack(glueUtil.with({...}, {
            function ()
                connection:Disconnect()
            end
        })))
        return connection
    end

    --[[

        Fires the event.

    ]]
    function New:Fire(...)
        if (isServer) then
            self._remote:FireClient(...)
        elseif (isClient) then
            self._remote:FireServer(...)
        end
    end

    --[[

        Fires the event to all clients. Only usable on Server.

    ]]

    function New:FireAll(...)
        if (isServer) then
            self._remote:FireAllClients(...)
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