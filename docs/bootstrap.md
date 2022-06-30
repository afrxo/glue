---
sidebar_position: 4
---

# Bootstrap

Here is an ideal project structure, also outlined in the [boilerplate](https://github.com/afrxo/Glue-Boilerplate).

Your game should include two bootstrap scripts, client-server per. They should both fully configure and start glue.
Here's how they'd look like:

## Server Bootstrap

```lua
-- Bootstrap.server.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Glue = require(ReplicatedStorage.Packages.Glue)

local Providers = script
local SharedModules = ReplicatedStorage.Shared
local ServerModules = ServerScriptService.Modules
local Imports = {ServerModules, SharedModules}

local function requireProviders(Directory: Instance)
    for _, descendant in ipairs(Directory:GetDescendants()) do
        if (descendant:IsA("ModuleScript")) then
            require(descendant)
        end
    end
end

Glue.Imports(Imports)
requireProviders(Providers)

Glue.Stick():andThen(function()
    print("Server Bootstrap complete.")
end)
```

## Client Bootstrap

```lua
-- Bootstrap.client.lua

local StarterPlayer = game:GetService("StarterPlayer")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Glue = require(ReplicatedStorage.Packages.Glue)

local Providers = script
local ClientModules = StarterPlayer.Modules
local SharedModules = ReplicatedStorage.Shared
local Imports = {ClientModules, SharedModules}

local function requireProviders(Directory: Instance)
    for _, descendant in ipairs(Directory:GetDescendants()) do
        if (descendant:IsA("ModuleScript")) then
            require(descendant)
        end
    end
end

Glue.Imports(Imports)
requireProviders(Providers)

Glue.Stick():andThen(function()
    print("Client Bootstrap complete.")
end)
```
## Modules

- Shared modules are to be kept within `ReplicatedStorage/Shared`.
- Server modules are to be kept within `ServerScriptService/Modules`.
- Client modules are to be kept within `StarterPlayer/Modules`.

## Providers

- Providers are to be kept within the environments according bootstrap script.