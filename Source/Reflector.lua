local Reflector = {}

local Generics = {
	["string"] = true,
	["number"] = true,
	["boolean"] = true,
	["nil"] = true
}

Reflector.interface = {}
Reflector.prototype = {}

function Reflector.prototype:generateNewIndexForObject(object)
	return function(_, index, value)
		local isValidNewIndex = self.__newindex(object, index, value)

		if isValidNewIndex then
			return
		end

		object[index] = value
	end
end

function Reflector.prototype:generateIndexForObject(object)
	return function(_, index)
		local isValidIndex, indexResult = self.__index(object, index)

		if isValidIndex then
			return indexResult
		end

		indexResult = object[index]

		return self:getProxyFromObject(indexResult)
	end
end

function Reflector.prototype:getProxyFromArgs(...)
	local proxies = {}

	for index, object in { ... } do
		proxies[index] = self:getProxyFromObject(object)
	end

	return table.unpack(proxies, 1, select("#", ...))
end

function Reflector.prototype:getObjectsFromArgs(...)
	local objects = {}

	for index, proxy in { ... } do
		objects[index] = self:getObjectFromProxy(proxy)
	end

	return table.unpack(objects, 1, select("#", ...))
end

function Reflector.prototype:createProxyForObject(object)
	local proxyObject = object

	if Generics[type(object)] then
		return object
	end

	if type(object) == "userdata" then
		proxyObject = newproxy(true)

		getmetatable(proxyObject).__index = self:generateIndexForObject(object)
		getmetatable(proxyObject).__newindex = self:generateNewIndexForObject(object)
	elseif type(object) == "function" then
		proxyObject = function(...)
			local response = { object(self:getObjectsFromArgs(...)) }

			return self:getProxyFromArgs(table.unpack(response))
		end
	end

	self.Proxies[object] = proxyObject
	self.Objects[proxyObject] = object

	return proxyObject
end

function Reflector.prototype:getProxyFromObject(object)
	return self.Proxies[object] or self:createProxyForObject(object)
end

function Reflector.prototype:getObjectFromProxy(proxyObject)
	if not self.Objects[proxyObject] then
		-- If there is no 'proxyObject' entry, this means that this wasn't a proxy to begin with.
		-- For something to be a proxy, both `Objects` and `Proxies` table need to be filled

		return proxyObject
	end

	return self.Objects[proxyObject]
end

function Reflector.prototype:setIndexCallback(callbackFn)
	self.__index = callbackFn
end

function Reflector.prototype:setNewIndexCallback(callbackFn)
	self.__newindex = callbackFn
end

function Reflector.interface.new()
	return setmetatable({
		Objects = {},
		Proxies = {},

		__index = function() end,
		__newindex = function() end
	}, { __index = Reflector.prototype })
end

return Reflector.interface