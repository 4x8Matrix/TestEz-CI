local TestEzCI = require("../../Source/init")

local HttpServiceExtension = TestEzCI.Extension.new("HttpService")

HttpServiceExtension:addMethod("GenerateGUID", function(_, wrapInCurlyBrackets)
	local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
	local guid = string.upper(string.gsub(template, '[xy]', function (c)
		local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
		return string.format('%x', v)
	end))

	return (wrapInCurlyBrackets and "{" .. guid .. "}") or guid
end)

return HttpServiceExtension