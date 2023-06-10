-- build.lua

local roblox = require("@lune/roblox")
local throwError = require("./throwError")

local function main()
    local Place = roblox.readPlaceFile(PLACE_FILE)
    local Bundle = Place.ReplicatedStorage.Packages
    Bundle.Name = "Packages"
    Bundle.Glue.Packages:Destroy()
    roblox.writeModelFile(`{OUTPUT_NAME}.rbxm`, { Bundle })
end

if #process.args == 2 then
    PLACE_FILE = process.args[1]
    OUTPUT_NAME = process.args[2]
    return main()
else
	throwError(process.args[1], "string", 1, "Place File")
	throwError(process.args[2], "string", 2, "Output Name")
end