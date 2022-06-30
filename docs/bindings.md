---
sidebar_position: 8
---

# Bindings

Bindings allow providers to have interal methods executed externally, past the Service layer. Let's look at an example:

Here we have two providers, one consumer providers that reacts to the vendor provider, and the vendor provider that emits a reaction to the consumer provider.

```lua
local Consumer = Glue.Provider({ Name = "Consumer1" })

function Consumer:valueChanged(value: string)
    print("New value ->", value)
end
```

```lua
local Vendor = Glue.Provider({ Name = "Vendor" })

function Vendor:onCreate()
    self.value = "Foo"
end

function Vendor:onStart()
    self:changeValue("Bar")
end

function Vendor:changeValue(value: string)
    self.value = value
end
```

So how do we get the two consumers to react to the vendor provider? Enter Bindings. Bindings are a way to bind a provider to a consumer. Well, how do we bind a provider to a consumer? 

To create a binding, you use the createBinding function, that gets passed into `Provider.onConfig`. The key of the binding specifies the name of the binding. `createBinding` returns a symbol, that gets resolved after `Provider.onCreate`.

```lua
function Vendor:onConfig(bindTo, createBinding)
	self.valueChanged = createBinding()
end
```

Well, now we created the binding, how do we emit it though? It's pretty simple, the Binding Symbol resolves to a function, so we can simply call it like so:

```lua
function Vendor:changeValue(value: string)
    self.value = value
    self.valueChanged(value)
end
```

If we run this nothing will happen, since we haven't binded the consumer to the vendor provider directly. This step is vital in security so the developer can directly control method invokation. Here's how that looks like:

```lua
function Consumer:onConfig(bindTo, createBinding)
	bindTo("Vendor")
end
```

The string passed to `bindTo` must be the name of the provider you are binding to. If the provider does not exist, glue will throw an error.

## Full Example

`Vendor.lua`
```lua
local Vendor = Glue.Provider({ Name = "Vendor" })

function Vendor:onConfig(bindTo, createBinding)
	self.valueChanged = createBinding()
end

function Vendor:onCreate()
	self.value = "Foo"
end

function Vendor:onStart()
	self:changeValue("Bar")
end

function Vendor:changeValue(value: string)
	self.value = value
	self.valueChanged(value)
end
```
`Consumer.lua`
```lua
local Consumer = Glue.Provider({ Name = "Consumer" })

function Consumer:onConfig(bindTo, createBinding)
	bindTo("Vendor")
end

function Consumer:valueChanged(value: string)
	print("New value from Consumer:", value)
end
```