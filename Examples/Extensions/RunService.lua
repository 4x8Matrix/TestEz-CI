local TestEzCI = require("../../Source/init")

local RunServiceExtension = TestEzCI.Extension.new("RunService")

RunServiceExtension:addEvent("Heartbeat")
RunServiceExtension:addMethod("IsStudio", function()
	return true
end)

return RunServiceExtension