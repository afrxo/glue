-- build.lua / Build Glue

local Place = remodel.readPlaceFile("Bundle.rbxl")
local Bundle = Place.ReplicatedStorage.Bundle
Bundle.Name = "Packages"
Bundle.Glue.Packages:Destroy()
remodel.writeModelFile(Bundle, "Glue.rbxm")