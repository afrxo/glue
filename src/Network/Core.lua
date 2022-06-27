--[[

    The internal class that handles Networking.

]]

local Dependencies = require(script.Parent.Parent.Dependencies)

local RunService = game:GetService("RunService")
local isServer = RunService:IsServer()
local isClient = RunService:IsClient()

local RemoteFolderName = "Endpoints"

--[[

    Simple string to int hash function.

]]
local function HashStringToInt(s)
    local h = 37
    for c = 1, s:len() do
        h = (bit32.lshift(h, 5) + h) + c * string.byte(s:sub(c, c))
    end
    return h
end


local Dependency = Dependencies.Dependency("NetworkClass")
Dependency:useDependency("NetworkEvent")
Dependency:useDependency("NetworkFunction")

local Network = setmetatable({}, {__metatable = "Network", __index = Dependency})

if (isServer) then
    local RemoteFolder = Instance.new("Folder", script.Parent.Parent)
    RemoteFolder.Name = RemoteFolderName
    Network.RemoteFolder = RemoteFolder
elseif (isClient) then
    Network.RemoteFolder = script.Parent.Parent:WaitForChild(RemoteFolderName)
end

function Network:MakeMiddlewareFactory(Signal)
    local function RunMiddlewareChain(...)
        local Index = 0
        local GlobalIndex = 1
        local IncomingMiddleware = self:GetIncomingMiddleware()
        local Callbacks = Signal._callbacks

        local RootNode = IncomingMiddleware[1] or Signal._callbacks[1]

        if (not RootNode) then return end

        local function Next(...)
            if (GlobalIndex >= #IncomingMiddleware) or (#IncomingMiddleware == 0) then
                Index = Index + 1
                if (Index > #Callbacks) or (#Callbacks == 0) then
                    return
                end
                if (Index == #Callbacks) then
                    return Callbacks[Index](...)
                else
                    return Callbacks[Index](Next, ...)
                end
            else
                GlobalIndex = GlobalIndex + 1
                return IncomingMiddleware[GlobalIndex](Next, Signal.Name, {...})
            end
        end

        if (IncomingMiddleware[1]) then
            return RootNode(Next, Signal.Name, {...})
        else
            if (#Callbacks == 1) then
                return RootNode(...)
            else
                Index = 1
                return RootNode(Next, ...)
            end
        end
    end

    return function (...)
        return RunMiddlewareChain(...)
    end
end


--[[

    Initializes a RemoteEvent/RemoteFunction from NetworkSignal info.

]]
function Network:BuildRemoteFromName(Name: string, Type: string)
    local HashedName = HashStringToInt(Name)
    local RemoteType = "";
    if (Type == "NetworkFunction") then
        RemoteType = "RemoteFunction"
    elseif (Type == "NetworkEvent") then
        RemoteType = "RemoteEvent"
    else
        error("Unknown type: " .. Type)
    end
    if (isServer) then
        if (self.RemoteFolder:FindFirstChild(HashedName)) then
            error("Remote " .. Type .. " with name " .. Name .. " already exists.")
        end
        local NewRemoteEndpoint = Instance.new(RemoteType, self.RemoteFolder)
        NewRemoteEndpoint.Name = tostring(HashedName)
        return NewRemoteEndpoint
    elseif (isClient) then
        return self.RemoteFolder:WaitForChild(HashedName)
    end
end


function Network:GetIncomingMiddleware()
    local Middleware = table.create(100)
    for _,  middleware in ipairs(Dependencies:Capture("IncomingMiddleware")) do
        table.insert(Middleware, middleware.task)
    end
    return Middleware
end


--[[

    Initializes a NetworkEvent.

]]
function Network:BuildNetworkEvent(Event)
    Event._remote = self:BuildRemoteFromName(Event.Name, getmetatable(Event) :: string)
    Event._callbacks = {}

    if (isServer) then
        Event._remote.OnServerEvent:Connect(self:MakeMiddlewareFactory(Event))
    elseif (isClient) then
        Event._remote.OnClientEvent:Connect(self:MakeMiddlewareFactory(Event))
    end
end


--[[

    Initializes a NetworkFunction.

]]
function Network:BuildNetworkFunction(Function)
    Function._remote = self:BuildRemoteFromName(Function.Name, getmetatable(Function) :: string)
    Function._callbacks = {}

    if (isServer) then
        Function._remote.OnServerInvoke = self:MakeMiddlewareFactory(Function)
    elseif (isClient) then
        Function._remote.OnClientInvoke = self:MakeMiddlewareFactory(Function)
    end
end

--[[

    Initializes a NetworkSignal from a RemoteEvent/RemoteFunction.

]]
function Network:BuildFromRemote(Remote: RemoteEvent | RemoteFunction, NetworkSignal)
    if (getmetatable(NetworkSignal) == "NetworkEvent") and (Remote:IsA("RemoteEvent")) then
        local Event = NetworkSignal
        Event._remote = Remote
        Event._callbacks = {}

        if (isServer) then
            Event._remote.OnServerEvent:Connect(self:MakeMiddlewareFactory(Event))
        elseif (isClient) then
            Event._remote.OnClientEvent:Connect(self:MakeMiddlewareFactory(Event))
        end
    elseif (getmetatable(NetworkSignal) == "NetworkFunction") and (Remote:IsA("RemoteFunction")) then
        local Function = NetworkSignal
        Function._remote = Remote
        Function._callbacks = {}

        if (isServer) then
            Function._remote.OnServerInvoke = self:MakeMiddlewareFactory(Function)
        elseif (isClient) then
            Function._remote.OnClientInvoke = self:MakeMiddlewareFactory(Function)
        end
    else
        error("Invalid network signal type.")
    end
end


Dependency._dependencyUpdated = function(_, newDependency)
    if (newDependency.tag == "NetworkEvent") then
        Network:BuildNetworkEvent(newDependency)
    elseif (newDependency.tag == "NetworkFunction") then
        Network:BuildNetworkFunction(newDependency)
    end
end

return Network