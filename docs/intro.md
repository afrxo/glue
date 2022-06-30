---
sidebar_position: 3
---

# Introduction

Here's how to start Glue:
```lua
local Glue = require(game:GetService("ReplicatedStorage").Glue)

Glue.Stick()
```

Here's how to start Glue and **additionally** catch any execution errors, using [Promises](https://eryn.io/roblox-lua-promise):
```lua
local Glue = require(game:GetService("ReplicatedStorage").Glue)

Glue.Stick():catch(warn)
```
    
### Execution Model

Providers have two built-in lifecycle methods: `onCreate` & `onStart`

`Glue.Stick` calls `onCreate` on all Providers before calling `onStart`, and rendering the Framework as started. Glue will wait for any yielding processes to commence during `onCreate` until it calls `onStart`.

```
Glue.Stick -> Provider.onCreate & yield -> Provider.onStart -> Glue.OnStick
```

### Creating a Provider

Here is the simplest example of creating a provider:

```lua
local Glue = require(game:GetService("ReplicatedStorage").Glue)

-- Creating the Provider
local ExampleProvider = Glue.Provider("ExampleProvider")

-- Attaching the onCreate lifeycle method
function ExampleProvider:onCreate()
    print("I have been created!")
end

-- Attaching the onStart lifecyle method
function ExampleProvider:onStart()
    print("I have been started!")
end

-- Starting Glue
Glue.Stick():catch(warn)
```