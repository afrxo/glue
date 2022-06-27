---
sidebar_position: 4
---

# Packages

Glue strives for faster development, which its module-loader achieves. [Glue.Import](https://afrxo.github.io/glue/api/Glue#Import) searches for and imports modules from Glue's [Packages](configuration.md#packages) configuration. Here's an example.

1. **MakeHello** `ReplicatedStorage/Shared/MakeHello.lua`
```lua
return function()
    print("Hello!")
end
```

2. **Bootstrap-Server** `ServerScriptService/Bootstrap.server.lua`
```lua
local Glue = require(game:GetService("ReplicatedStorage").Glue)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

Glue.Imports(ReplicatedStorage.Shared)

local MakeHello = Glue.Import("Shared/MakeHello")
MakeHello() -- Hello!

Glue.Stick():catch(warn)
```

Packages can also be imported by their relative path as such:
```lua
local MakeHello = Glue.Import("MakeHello")
MakeHello() -- Hello!
```

## Package Dependencies

Packages can also have glue dependencies of its own:

1. **Hello** `ReplicatedStorage/Shared/Hello.lua`
```lua
return "Hello"
```

2. **MakeHello** `ReplicatedStorage/Shared/MakeHello.lua`
```lua
local Glue = require(game:GetService("ReplicatedStorage").Glue)

local Hello = Glue.Import("Shared/Hello")

return function()
    print(Hello)
end
```

## Loaders

Glue allows the construction of a module loader, that only searches for modules in a specified directory. This is useful for loading a packages submodules / dependencies relative to itself.

```lua
local require = require(game:GetService("ReplicatedStorage").Glue).loader(script)

local Util = require("Util")

local Library = {}

function Library.do()
	Util.help()
end

return Library
```


## Importing External Dependencies

The Glue module-loader also supports importing external modules by passing the target module into `Glue.Import`.

Example using Fusion:
```lua
local Glue = require(game:GetService("ReplicatedStorage").Glue)
local require = Glue.Import

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage:WaitForChild("Fusion"))
local New, Children = Fusion.New, Fusion.Children


New "ScreenGui" {
	Parent = Players.LocalPlayer.PlayerGui,

	Name = "MyFirstGui",
	ResetOnSpawn = false,
	ZIndexBehavior = "Sibling",

	[Children] = New "TextLabel" {
		Position = UDim2.fromScale(.5, .5),
		AnchorPoint = Vector2.new(.5, .5),
		Size = UDim2.fromOffset(200, 50),
		Text = "Fusion is fun :)"
	}
}

```