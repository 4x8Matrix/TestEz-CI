local FileSystem = require("@lune/fs")
local Roblox = require("@lune/roblox")
local Task = require("@lune/task")

local Reflector = require("Reflector")

local Habitat = {}

Habitat.interface = {}
Habitat.prototype = {}

function Habitat.prototype:fetchObjectFromPath(path)
	local head = self.root

	for _, node in string.split(path, ".") do
		head = head[node]
	end

	return head
end

function Habitat.prototype:generateEnvironmentFor(source)
	local sourceEnvironment = setmetatable({
		script = source,
	}, { __index = self.environment })

	return setmetatable({ }, {
		__index = self.reflector:generateIndexForObject(sourceEnvironment),
		__newindex = self.reflector:generateNewIndexForObject(sourceEnvironment)
	})
end

function Habitat.prototype:addExtension(extensionObject)
	self.extensions[extensionObject.name] = extensionObject
end

function Habitat.prototype:removeExtension(extensionObject)
	self.extensions[extensionObject.name] = nil
end

function Habitat.prototype:addGlobal(globalName, object)
	self.environment[globalName] = object
end

function Habitat.prototype:removeGlobal(globalName)
	self.environment[globalName] = nil
end

function Habitat.prototype:require(module)
	local moduleFunction = loadstring(module.Source)

	setfenv(moduleFunction, self:generateEnvironmentFor(module))

	return moduleFunction()
end

function Habitat.prototype:execute(entrypointPath)
	local entrypointScript = self:fetchObjectFromPath(entrypointPath)
	local entrypointFunction = loadstring(entrypointScript.Source)

	setfenv(entrypointFunction, self:generateEnvironmentFor(entrypointScript))

	return entrypointFunction()
end

function Habitat.interface.new(rootUserdata)
	local self = setmetatable({
		reflector = Reflector.new(),
		extensions = {},

		root = rootUserdata,
		environment = setmetatable({
			game = rootUserdata,
			workspace = rootUserdata.Workspace,

			task = Task,
			tick = os.clock
		}, { __index = getfenv() })
	}, { __index = Habitat.prototype })

	for index, value in Roblox do
		self.environment[index] = value
	end

	self.environment.require = function(...)
		return self:require(...)
	end

	self.reflector:setIndexCallback(function(object, index)
		if typeof(object) ~= "Instance" then
			return false
		end

		if not self.extensions[object.ClassName] then
			return false
		end

		local isValid, indexResult = self.extensions[object.ClassName]:__index(object, index)

		if not isValid then
			return false
		else
			return true, indexResult
		end
	end)

	self.reflector:setNewIndexCallback(function(object, index, value)
		local extensionObject = self.extensions[object.ClassName]

		if extensionObject then
			local indexResult = extensionObject:__newindex(object, index, value)

			if indexResult ~= nil then
				return true, indexResult
			end
		end

		return false
	end)

	return self
end

function Habitat.interface.fromPlace(placeFilePath)
	local fileContents = FileSystem.readFile(placeFilePath)
	local rootUserdata = Roblox.deserializePlace(fileContents)

	return Habitat.interface.new(rootUserdata)
end

function Habitat.interface.fromModel(modelFilePath)
	local fileContents = FileSystem.readFile(modelFilePath)
	local rootUserdata = Roblox.deserializeModel(fileContents)

	return Habitat.interface.new(rootUserdata)
end

return Habitat.interface