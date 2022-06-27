---
sidebar_position: 7
---

# Environment

> I would highly recommend loading your games from a single script. A single-script architecture can help you avoid programming issues and let you iterate and test your game faster. Furthermore, it’ll help other people program with you. ~ Quenty


The goal behind single-script-architecture is having a a **single** entry point to your game that gets it up and running.

Here's an example of development in a single-script-architecture environment with Glue:

1. **Bootstrap-Client** `StarterPlayer/StarterPlayerScripts/Bootstrap.client.lua`
```lua
local Glue = require(game:GetService("ReplicatedStorage").Glue)

local Providers = script:WaitForChild("Providers")

Glue.SetConfig({
    Providers = Providers
})

Glue.Stick():catch(warn):andThen(function()
    print("Glue started!", Glue.Version)
end)
```

2. **ExampleController** `ReplicatedStorage/Client/Providers/ExampleController.lua`
```lua
local Glue = require(game:GetService("ReplicatedStorage").Glue)

local ExampleController = Glue.Provider("ExampleController")

-- Attaching the onCreate lifeycle method
function ExampleController:onCreate()
    print("I have been initialized.")
end

-- Attaching the onStart lifeycle method
function ExampleController:onStart()
    print("I have been started.")
end

return ExampleController
```

3. **Bootstrap-Server** `ServerScriptService/Bootstrap.client.lua`
```lua
local Glue = require(game:GetService("ReplicatedStorage").Glue)

local Providers = script:FindFirstChild("Providers")

Glue.SetConfig({
    Providers = Providers
})

Glue.Stick():catch(warn):andThen(function()
    print("Glue started!", Glue.Version)
end)
```

4. **ExampleService** `ServerStorage/Server/Providers/ExampleService.lua`
```lua
local Glue = require(game:GetService("ReplicatedStorage").Glue)

local ExampleService = Glue.Provider("ExampleService")

-- Attaching the onCreate lifeycle method
function ExampleService:onCreate()
    print("I have been initialized.")
end

-- Attaching the onStart lifeycle method
function ExampleService:onStart()
    print("I have been started.")
end

return ExampleService
```
