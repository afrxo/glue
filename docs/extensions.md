---
sidebar_position: 9
---

# Extensions

An extension simply adds functionality or transformation to a provider during runtime. Extensions are useful for *collectively* modifying providers externally within the Glue Intialization pipeline.

Glue provides two modifiable extensions: 
- `beforeCreate`: This extension is run before the provider is created.
- `beforeStart`: This extension is run before the provider is started.

How do you specifiy an extension?

```lua
Glue.Extensions({
    beforeCreate = function(provider)

    end,
    beforeStart = function(provider)

    end
})
```
Here's an example:

## Service Bag

Eliminate usage of `Glue.GetProvider` and load dependent providers directly into the service bag.

```lua
local Services = {}
Glue.Extensions({
    beforeCreate = function(provider)
        Services[provider.Name] = provider.Service or provider
    end,
    beforeStart = function(provider)
        provider.services = provider.services or {}
        for _, service in ipairs(provider.services) do
            provider.services[service] = Services[service]
        end
    end
})
```
```lua
function Provider:onCreate()
	self.services = {"OtherProvider"}
end

function Provider:onStart()
	self.service.OtherProvider:doSomething()
end
```