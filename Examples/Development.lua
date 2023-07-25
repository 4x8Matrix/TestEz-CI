--[[
	Challenge: Create a Tool that can execute the 'TestEz' framework & various unit tests outside of the Roblox Environment.

	Inspired by Lemur, use `Habitat` objects to house all functionality under

	- Arguments:
		- "latest.rbxl"
		- "ServerScriptService.CI"

	- Principle
		- System should be scaleable, the idea behind this is that other programmers will add `extensions` - these `extensions` being
			blocks of functions/methods that will provide API responses
		- If no 'extension' for an object is found, we must return the default value of the return type.
			For example, if the return type of `workspace:GetRealPhysicsFPS` is a number, and there's no extension in place, return 0 as default.

			- Use a studio dump to get the type of returned values.
]]--

local TestEzCI = require("../Source/init")

local Habitat = TestEzCI.Habitat.fromPlace("latest.rbxl")

Habitat:addExtension(require("Extensions/Workspace"))
Habitat:addExtension(require("Extensions/DataModel"))
Habitat:addExtension(require("Extensions/RunService"))
Habitat:addExtension(require("Extensions/TestService"))
Habitat:addExtension(require("Extensions/HttpService"))

Habitat:addGlobal("DateTime", require("Globals/Roblox/DateTime"))

Habitat:execute("ServerScriptService.CI")