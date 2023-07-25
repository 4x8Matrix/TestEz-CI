local Signal = require("Dependencies/Github/Signal")

local Extension = {}

Extension.interface = {}
Extension.prototype = {}

function Extension.prototype:addMethod(methodName, methodCallback)
	self.methods[methodName] = methodCallback
end

function Extension.prototype:addProperty(propertyName, propertyValue)
	self.properties[propertyName] = {
		value = propertyValue
	}
end

function Extension.prototype:addEvent(eventName)
	self.events[eventName] = Signal.new()
end

function Extension.prototype:__index(_, index)
	if self.methods[index] or self.events[index] then
		return true, self.methods[index] or self.events[index]
	end

	if self.properties[index] then
		return true, self.properties[index].value
	end
end

function Extension.prototype:__newindex(_, index, value)
	if self.methods[index] or self.events[index] then
		error(`Failed to overwrite '{index}' on {self.name} extension!`)
	end

	if not self.properties[index] then
		return
	end

	self.properties[index].value = value
end

function Extension.interface.new(extensionName)
	return setmetatable({
		name = extensionName,

		methods = {},
		properties = {},
		events = {}
	}, { __index = Extension.prototype })
end

return Extension.interface