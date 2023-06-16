-- glueUtil.lua
-- Utility functions for the glue library.
local HttpService = game:GetService("HttpService")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")


-- Get an Instance by its FullName
-- @param FullName The full name of the Instance
function getInstance(FullName: string): Instance?
	local Layers = FullName:split(".")
	local CurrentLayer = game

	for _, Layer in ipairs(Layers) do
		CurrentLayer = CurrentLayer:FindFirstChild(Layer)
		if (CurrentLayer == nil) then return end
	end

	return CurrentLayer
end


-- Gets the clients platform
function getPlatform()
	local InputEnabledMap = {
		["Keyboard"] = UserInputService.KeyboardEnabled;
		["Gamepad"] = UserInputService.GamepadEnabled;
		["Touch"] = UserInputService.TouchEnabled;
	}
	if (InputEnabledMap.Touch and not InputEnabledMap.Gamepad and not InputEnabledMap.Keyboard) then
		return "Mobile"
	elseif (InputEnabledMap.Gamepad and not InputEnabledMap.Touch and not InputEnabledMap.Keyboard) then
		return "Console"
	end
	return "Desktop"
end


-- Gets the environment Roblox is running in.
function getEnvironment()
	return if (RunService:IsClient()) then "Client" else if (RunService:IsServer()) then "Server" else "Unknown"
end


-- Make a table read-only
-- @param tableName string The name of the table
-- @param strictTable table The table to make read-only
function readOnly(tableName: string, strictTable): any
	return setmetatable({}, {
		__index = strictTable,
		__newindex = function()
			error(string.format("%s is read-only!", tableName))
		end,
		__metatable = tableName
	})
end

-- Gets the local player
function getLocalPlayer()
	return Players.LocalPlayer
end

-- Generate a guid
function generateGuid(wrapInCurlyBraces: boolean?)
	return HttpService:GenerateGUID(wrapInCurlyBraces)
end

-- Merge multiple tables
function with(...)
	local function merge(t1, t2)
		for k, v in pairs(t2) do t1[k] = v end
	end

	local init = {}
	for _, v in {...} do
		if (type(v) == "table") then
			merge(init, v)
		else
			init[#init+1] = v
		end
	end
	return init
end

return {
	with = with,
	readOnly = readOnly,
	getPlatform = getPlatform,
	getInstance = getInstance,
	generateGuid = generateGuid,
	getEnvironment = getEnvironment,
	getLocalPlayer = getLocalPlayer,
}