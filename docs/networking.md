---
sidebar_position: 5
---

# Networking

Glue allows for a modular approach at writing netcode by removing the necessity of keeping track of RemoteEvents/RemoteFunctions. These are embedded as singleton objects, instantiated by Glue on runtime. Let's look at a simple example of server-client communication using `Glue.Network`.

1. **Server**
```lua
local Glue = require(game:GetService("ReplicatedStorage").Glue)
local Network = Glue.Network

-- Create the NetworkEvent
local Signal = Network.Event("ExampleSignal")

-- Listen to any client events
Signal:OnEvent(function(Player: Player)
	print("Ping")
    -- Fire an event to the client
	Signal:Fire(Player)
end)
```

2. **Client**
```lua
local Glue = require(game:GetService("ReplicatedStorage").Glue)
local Network = Glue.Network

-- Wait for the RemoteSignal to 
local Signal = Network.Event("ExampleSignal")

-- Listen to events from the server
Signal:OnEvent(function()
	print("Pong")
end)

-- Fire an event to the server
Signal:Fire()
```

# Middleware

What is a middleware? A middleware is an operation or task, that lies between two processes. Middlewares might be useful for cutting down on tasks required by multiple endpoints. Middlewares are embedded as simple functions in Glue, here's a classic example: We would like to log any requests made to an event endpoint, here's how it would look like in Glue:
```lua
local Glue = require(game:GetService("ReplicatedStorage").Glue)
local Network = Glue.Network

local Signal = Network.Event("ExampleSignal")

local LoggerMiddleware = function(Next, Player, ...)
	warn(string.format("[EVENT LOG] Client %s fired event %s", Player.Name, Signal.Name), ...)
	Next(Player, ...)
end

Signal:OnEvent(LoggerMiddleware, function(Player, ...)
	DoSomething(Player, ...)
end)
```

The same concept is applicable to NetworkFunctions, the next statement must simply return any values that need to be sent back:
```lua
local Glue = require(game:GetService("ReplicatedStorage").Glue)
local Network = Glue.Network

local Signal = Network.Function("ExampleSignal")

local MultiplierMiddleware = function(Next, Player, Value)
	return Next(Player, Value * 2)
end

Signal:OnInvoke(MultiplierMiddleware, function(Player, Value)
	return Value
end)
```