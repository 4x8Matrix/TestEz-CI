local DateTime = {}

DateTime.interface = {}
DateTime.prototype = {}

function DateTime.prototype:ToUniversalTime()
	return DateTime.interface.new()
end

function DateTime.prototype:ToLocalTime()
	return DateTime.interface.new()
end

function DateTime.prototype:ToIsoDate()
	return ""
end

function DateTime.prototype:FormatUniversalTime()
	return ""
end

function DateTime.prototype:ToUniversalTime()
	return ""
end

function DateTime.interface.new()
	return setmetatable({
		UnixTimestamp = 0,
		UnixTimestampMillis = 0,
	}, { __index = DateTime.prototype })
end

function DateTime.interface.now()
	return DateTime.interface.new()
end

function DateTime.interface.fromUnixTimestamp()
	return DateTime.interface.new()
end

function DateTime.interface.fromUnixTimestampMillis()
	return DateTime.interface.new()
end

function DateTime.interface.fromUniversalTime()
	return DateTime.interface.new()
end

function DateTime.interface.fromLocalTime()
	return DateTime.interface.new()
end

function DateTime.interface.fromIsoDate()
	return DateTime.interface.new()
end

return DateTime.interface