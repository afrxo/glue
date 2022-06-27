-- import.lua
-- Require a module relative to the import paths.

local Error = require(script.Parent.Error)
local GlueUtil = require(script.Parent.glueUtil)
local Manager = require(script.Parent.glueManager)

local function Import(Target: (string | Instance))
	if (type(Target) == "string") then
		local ImportPaths = Manager:GetPackageImportPaths()
		for _, Path: Instance in ipairs(ImportPaths) do
			local Module = GlueUtil.getInstance(string.format("%s.%s", Path:GetFullName(), Target:gsub("/", ".")))
			if (Module) then
				return require(Module)
			end
		end
	elseif (typeof(Target) == "Instance") then
		if (not Target:IsA("ModuleScript")) then
			Error.throw(Error.new("invalidImportTarget", Target))
		end
		return require(Target)
	end
end

return function (Target: (string | ModuleScript)?)
	if (type(Target) ~= "string" and typeof(Target) ~= "Instance") then
		Error.throw(Error.new("invalidImportPath", Target))
	end

	return Import(Target)
end