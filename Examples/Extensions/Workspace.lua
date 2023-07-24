local TestEzCI = require("../../Source/init")

local WorkspaceServiceExtension = TestEzCI.Extension.new("Workspace")

WorkspaceServiceExtension:addMethod("GetRealPhysicsFPS", function()
	return 60
end)

return WorkspaceServiceExtension