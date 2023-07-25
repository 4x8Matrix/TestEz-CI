local TestEzCI = require("../../Source/init")

local DataModelExtension = TestEzCI.Extension.new("DataModel")

DataModelExtension:addProperty("PlaceId", 0)
DataModelExtension:addMethod("BindToClose", function()
	
end)

return DataModelExtension