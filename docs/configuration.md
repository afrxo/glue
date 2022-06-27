---
sidebar_position: 8
---

# Configuration

Glue should make development quick & easy, hence why it allows for simple configuration.

See all configurable options [here](https://afrxo.github.io/glue/api/Glue#GlueConfig).

## Providers

The **Providers** key points to directories with ModuleScripts that contain a `Provider`. An array of multiple provider paths are specifable. This would look the following:
```lua
local Glue = require(game:GetService("ReplicatedStorage").Glue)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

Glue.SetConfig({
    Providers = ReplicatedStorage.ClientProviders
})
```

## Packages

The **Packages** key points to directories, within Glue should search for modules. An array of multiple search paths are specifable. This would look the following:
```lua
local Glue = require(game:GetService("ReplicatedStorage").Glue)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

Glue.SetConfig({
    Packages = ReplicatedStorage.Shared
})
```

```lua
local Glue = require(game:GetService("ReplicatedStorage").Glue)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

Glue.SetConfig({
    Packages = {ReplicatedStorage.Shared, ReplicatedStorage.Client}
})
```

### PathSeperator

The **PathSeperator** key specifies a character that seperates the directories in your import path, which is set to `/` by default.
```lua
local Glue = require(game:GetService("ReplicatedStorage").Glue)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

Glue.SetConfig({
    PathSeperator = "."
})

local Parser = Glue.Import("Util.Parser")
```