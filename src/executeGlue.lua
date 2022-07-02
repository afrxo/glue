-- executeGlue.lua
-- Executes the glue library.

local Error = require(script.Parent.Error)
local symbols = require(script.Parent.symbols)
local Promise = require(script.Parent.Parent.Promise)
local glueManager = require(script.Parent.glueManager)
local sharedState = require(script.Parent.sharedState)
local Dependencies = require(script.Parent.Dependencies)

local RunService = game:GetService("RunService")
local isServer = RunService:IsServer()
local isClient = RunService:IsClient()


local function createInternalBinding(bindedMethod: string)
	return function (...)
		for _, Provider in ipairs(Dependencies:Capture("Provider")) do
			if (type(rawget(Provider, bindedMethod)) == "function") then
				Provider[bindedMethod](Provider, ...)
			end
		end
	end
end


local function createBindingFactory(Provider)
	local Dependency = Dependencies.Dependency("Binding")
	local bindings = setmetatable({index = {}, Provider = Provider}, { __index = Dependency, __metatable = "Binding" })
    Dependencies:Use(bindings)
	return function(BindingProviderName: string)
		if BindingProviderName == nil then
			Error.throw(Error.new("bindingNameRequired"))
		end
        if BindingProviderName == Provider.Name then
            Error.throw(Error.new("cannotBindToSelf"))
        end
		if table.find(bindings.index, BindingProviderName) then
			Error.throw(Error.new("bindingAlreadyExists", BindingProviderName))
		end
		bindings.index[#bindings.index + 1] = BindingProviderName
	end
end

local function createBinding()
	return symbols.binding
end

local function attachProviderBindings()
	return Promise.new(function(resolve, reject)
		local Bindings = Dependencies:Capture("Binding")

        --> Validate bindings
		for _, Binding in ipairs(Bindings) do
            local Provider = Binding.Provider
			for _, BindingProviderName in ipairs(Binding.index) do
				local BindingProvider = glueManager.GetProvider(BindingProviderName, true)
                if (BindingProvider == Provider) then continue end

                --> We cannot be binding to providers than don't exist.
				if BindingProvider == nil then
					local success, err = pcall(Error.throw, Error.new("bindingProviderNotFound", BindingProviderName))
					if not success then
						reject(err)
					end
				end

                local implementations = 0
                --> Check if bindings have been implemented
                for Key, Value in pairs(BindingProvider) do
                    --> We are dealing with a binding here.
                    if (Value == createBinding()) and (type(rawget(Provider, Key)) == "function") then
                        implementations += 1
                    end
                end

                --> If there are no implementations, throw an error.
                if (implementations == 0) then
                    Error.throw(Error.new("noBindingsImplemented", Provider.Name, BindingProviderName, BindingProviderName))
                end
			end
		end

        
        --> Attach bindings
        for _, Binding in ipairs(Bindings) do
            local Provider = Binding.Provider
            for Key, Value in pairs(Provider) do
                --> We are dealing with a binding here.
                if (Value == createBinding()) then
                    --> Override the key
                    Provider[Key] = function(...)
                        for _, anotherBinding in ipairs(Bindings) do
                            if (anotherBinding == Binding) then continue end
                            --> Check if binding is implemented
                            if (table.find(anotherBinding.index, Provider.Name)) then
								--> Check if implementation exists
								if (type(rawget(anotherBinding.Provider, Key)) == "function") then
									task.spawn(anotherBinding.Provider[Key], anotherBinding.Provider, ...)
								end
                            end
                        end
                    end
                end
            end
        end

        resolve()
	end)
end

local function attachProviderEventBindings()
	if sharedState.EventPipelineStarting then
		return Promise.resolve()
	end

	sharedState.EventPipelineStarting = true

	return Promise.new(function(resolve, reject)
		RunService.Heartbeat:Connect(createInternalBinding("onTick"))

		if isClient then
			RunService.RenderStepped:Connect(createInternalBinding("onRender"))
		elseif not isServer then
			reject("Unknown environment")
		end

		resolve()
	end)
end

local function runExtensions(extensionName: string)
	return function()
		return Promise.new(function(resolve, reject)
			local Providers = Dependencies:Capture("Provider")
			local extension = Dependencies:Capture("Extension", function(extension)
				if extension.name == extensionName then
					return true
				end
				return false
			end)[1]
			if extension then
				for _, Provider in pairs(Providers) do
					Promise.try(extension.transform, Provider):catch(reject)
				end
			end
			resolve()
		end)
	end
end

local function configureProviders()
	return Promise.new(function(resolve, reject)
		local Providers = Dependencies:Capture("Provider")
		for _, Provider in ipairs(Providers) do
			if rawget(Provider, "onConfig") then
				Promise.try(function()
					Provider:onConfig(createBindingFactory(Provider), createBinding)
				end):catch(reject):await()
			end
		end
		resolve()
	end)
end

local function initalizeProviders()
	return Promise.new(function(resolve, reject)
		local Providers = Dependencies:Capture("Provider")
		for _, Provider in ipairs(Providers) do
			if rawget(Provider, "onCreate") then
				Promise.try(function()
					Provider:onCreate()
				end):catch(reject):await()
			end
		end
		sharedState.GluePipelineInitialized = true
		resolve()
	end)
end

local function startProviders()
	return Promise.new(function(resolve, reject)
		local Providers = Dependencies:Capture("Provider")
		for _, Provider in ipairs(Providers) do
			if rawget(Provider, "onStart") then
				Promise.try(function()
					Provider:onStart()
				end):catch(reject)
			end
		end
		resolve()
	end)
end

return function()
	if sharedState.GluePipelineStarting then
		return Promise.resolve()
	end

	sharedState.GluePipelineStarting = true

	return Promise.new(function(resolve, reject)
		Promise.resolve()
			:andThen(configureProviders)
			:andThen(runExtensions("beforeCreate"))
			:andThen(initalizeProviders)
			:andThen(runExtensions("beforeStart"))
			:andThen(attachProviderBindings)
			:andThen(startProviders)
			:andThen(function()
				sharedState.GluePipelineStarted = true
			end)
			:andThen(attachProviderEventBindings)
			:andThen(resolve)
			:catch(reject)
	end)
end
