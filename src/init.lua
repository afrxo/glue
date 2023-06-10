--!strict

--[[

	The entry point of Glue Framework.

	https://github.com/afrxo/glue

]]

local Version = script:WaitForChild("Version")

local PubTypes = require(script:WaitForChild("types"))

export type Glue = PubTypes.Glue

export type Math = PubTypes.Math
export type Network = PubTypes.Network
export type Middleware = PubTypes.Middleware
export type NetworkEvent = PubTypes.NetworkEvent
export type NetworkFunction = PubTypes.NetworkFunction

export type Provider = PubTypes.Provider
export type Map<T> = PubTypes.Map<T>
export type Array<T> = PubTypes.Array<T>

local Error = require(script:WaitForChild("Error"))
local glueUtil = require(script:WaitForChild("glueUtil"))

local Packages = script.Parent
local Promise = require(Packages:WaitForChild("Promise"))

local Math = require(script:WaitForChild("Math"))
local Network = require(script:WaitForChild("Network"))
local createLoader = require(script:WaitForChild("loader"))
local importPackage = require(script:WaitForChild("import"))
local createProvider = require(script:WaitForChild("createProvider"))

local glueManager = require(script:WaitForChild("glueManager"))
local sharedState = require(script:WaitForChild("sharedState"))
local executeGlue = require(script:WaitForChild("executeGlue"))

local GlueStickContext

local function createGlueApi()
	--[=[

		@class Glue

		The Glue Framework.

	]=]
	local Glue = {}
	--[=[

		@prop Version string
		@within Glue
		@readonly

		The current version of Glue.

	]=]
	Glue.Version = Version.Value
	--[=[
		@function Import
		@within Glue
		@param Target string | ModuleScript

		Imports a package found in the paths specified in `GlueConfig`.

		```lua
		local MakeHello = Glue.Import("MakeHello")
		MakeHello()
		```
	]=]
	Glue.Import = importPackage
	--[=[
		@function loader
		@within Glue
		@param Target Instance
		@param Seperator string?

		Creates a module loader for the specified target.

		```lua
		local require = require(game:GetService("ReplicatedStorage").Glue).loader(script)

		local Util = require("Util")
		```
	]=]
	Glue.loader = createLoader
	--[=[
		@prop Math Math
		@within Glue

		The Glue Math library.
	]=]
	Glue.Math = Math
	--[=[

		@prop Network Network
		@within Glue

		The Glue Network library.

		```lua
		local Event = Network.Event("ExampelEvent")

		Event:OnEvent(function(Player: Player)
			print("Ping")
			Event:Fire(Player)
		end)
		```
		---
		```lua
		local Signal = Network.Event("ExampleSignal")

		Signal:OnEvent(function()
			print("Pong")
		end)

		Signal:Fire()
		```

	]=]
	Glue.Network = Network
	--[=[
		@function Provider
		@within Glue
		@param Name string
		@param ProviderData Map<any>?
		@return Provider

		Creates a Provider.

		```lua
		local ExampleProvider = Glue.Provider("ExampleProvider")

		function ExampleProvider:onCreate()
			print("I have been initialized!")
		end

		function ExampleProvider:onStart()
			print("I have been started!")
		end

		return ExampleProvider
		```
	]=]
	Glue.Provider = createProvider
	--[=[

		@prop LocalPlayer Player
		@within Glue
		@readonly

	]=]
	Glue.LocalPlayer = glueUtil.getLocalPlayer()
	--[=[

		@param Name string
		@return Provider?

		Fetches a Provider by name.

		:::caution
			Providers can only be fetched after all Providers have been initialized.
		:::

	]=]
	function Glue.GetProvider(Name: string)
		if not sharedState.GluePipelineInitialized then
			Error.throw(Error.new("cannotGetProviderBeforeStart", Name))
		end

		return glueManager.GetProvider(Name)
	end
	--[=[

		@function Imports
		@param ImportPaths Array<Instance> | Instance
		@within Glue

		Sets the paths to search for packages.

		```lua
		Glue.Imports { ReplicatedStorage.Shared, ServerScriptService.Modules }
		```

	]=]
	function Glue.Imports(ImportPaths)
		if not ImportPaths then
			Error.throw(Error.new("zeroArguments"))
		end

		glueManager.UseImportPaths(ImportPaths)
	end
	--[=[

		@function Extensions
		@param extensions {[string]: (Provider) -> ()}
		@within Glue

		Configures the extensions to use.

		```lua
		Glue.Extensions {
			["beforeCreate"] = function(Provider)
				print(Provider.Name .. " beforeCreate")
			end
		}
		```

	]=]
	function Glue.Extensions(extensions)
		if not extensions then
			Error.throw(Error.new("zeroArguments"))
		end

		glueManager.UseExtensions(extensions)
	end
	--[=[

		@function Stick
		@within Glue
		@return Promise

		Starts the Glue Framework.

		```lua
		Glue.Stick():catch(warn):andThen(function()
			print("Glue started!")
		end)
		```

	]=]
	function Glue.Stick()
		if sharedState.GluePipelineStarting then
			return Promise.reject("Glue is already starting.")
		end

		GlueStickContext = executeGlue():catch(warn)

		return GlueStickContext
	end
	--[=[

		@function OnStick
		@within Glue
		@return Promise

		Returns a Promise that yields until the Glue Pipeline has started.

		```lua
		Glue.OnStick():andThen(function()
			print("Glue started!")
		end)
		```

	]=]
	function Glue.OnStick()
		if sharedState.GluePipelineStarted then
			return Promise.resolve()
		end

		return Promise.new(function(resolve, reject)
			repeat
				task.wait()
			until GlueStickContext
			GlueStickContext:catch(reject):andThen(resolve):await()
		end)
	end

	return Glue
end

local Glue = createGlueApi()

-- Lock the Glue API, preventing further changes.
return glueUtil.readOnly("Glue", Glue) :: Glue
