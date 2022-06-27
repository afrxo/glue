---
sidebar_position: 6
---

# Services

Services are tables that expose a public API for Providers. Services allow for you to keep providers self contained and secure. Why do we need Services? Lets take a look at an example:
    
Here we have a Provider that creates a table of names on `onCreate` and has a getter method that returns a direct reference to those names.

```lua
local NameProvider = { Name = "NameProvider" }

function NameProvider:onCreate()
    self.Names = {"Foo", "Bar", "Baz"}
end

function NameProvider:CountNames()
    print("There are " .. #self:GetNames() .. " names")
end

function NameProvider:GetNames()
    return self.Names
end

Glue.Provider(NameProvider)
```
How do we gain access to those names outside of the NameProvider? Well, here's two ways you could.
```lua
Glue.Stick():andThen(function()
    local NameProvider = Glue.GetProvider("NameProvider")
    local Names = NameProvider.Names
end)
```
```lua
Glue.Stick():andThen(function()
    local NameProvider = Glue.GetProvider("NameProvider")
    local Names = NameProvider:GetNames()
end)
```
## Security
Though both of these method acquire the Names accordingly, they aren't as secure since we now have a direct reference to the Names state, which means we can actively makes changes to it, that will be replicated everywhere else the Names state is being used. 
```lua
Glue.Stick():andThen(function()
    local NameProvider = Glue.GetProvider("NameProvider")
    local Names = NameProvider:GetNames()
    Names[4] = "Qux"
    print(Names, NameProvider:GetNames())
end)
```
I suppose we could have the `GetNames` return a table.copy of the Names state like so:
```lua
local NameProvider = { Name = "NameProvider" }

function NameProvider:onCreate()
    self.Names = {"Foo", "Bar", "Baz"}
end

function NameProvider:GetNames()
    return table.copy(self.Names)
end

Glue.Provider(NameProvider)
```
Though this means that the method is rendered completely useless for internal usage, because it doesnt return a direct reference to the Names state. Well how can we make the Names state secure for Internal and Public usage? This is where Services come in handy. Here's how you do it:
## Abstraction
```lua
local NameServiceProvider = { Name = "NameProvider" }

function NameServiceProvider:onCreate()
	self.Names = {"Foo", "Bar", "Baz"}
end

function NameServiceProvider:GetNames()
	return self.Names
end

local NameService = {}

function NameService:GetNames()
	return table.clone(NameServiceProvider:GetNames())
end

NameServiceProvider.Service = NameService
Glue.Provider("NameProvider", NameServiceProvider)
```
Pretty simple, right? The service definition is just a table of methods or properties ready for public usage, completely isolating the Provider itself.


## Full Example
```lua
local Glue = require(game.ReplicatedStorage.Bundle.Glue)

local NameServiceProvider = Glue.Provider("NameProvider")

function NameServiceProvider:onCreate()
	self.Names = {"Foo", "Bar", "Baz"}
end

function NameServiceProvider:CountNames()
	print("There are " .. #self:GetNames() .. " names.")
end

function NameServiceProvider:GetNames()
	return self.Names
end

local NameService = {}

function NameService:GetNames()
	return table.clone(NameServiceProvider:GetNames())
end

function NameService:CountNames()
	NameServiceProvider:CountNames()
end

NameServiceProvider.Service = NameService

Glue.Stick():andThen(function()
	local BuiltNameProvider = Glue.GetProvider("NameProvider")
	local Names = BuiltNameProvider:GetNames()
	NameService:CountNames()
	Names[4] = "Quz"
	NameService:CountNames()	
end)
```