local TestEzCI = require("../../Source/init")

local TestServiceExtension = TestEzCI.Extension.new("TestService")

TestServiceExtension:addMethod("Error", function(_, errorMessage)
	error(string.split(errorMessage, "\n")[2])
end)

return TestServiceExtension