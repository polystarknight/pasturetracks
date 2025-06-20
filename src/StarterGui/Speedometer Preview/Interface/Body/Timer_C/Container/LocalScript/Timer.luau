local Timer = {}
Timer.__index = Timer

function Timer.new(initialTime)
	local self = setmetatable({}, Timer)
	self._startTime = 0
	self._elapsed = 0
	self._running = false
	self._lastUpdate = 0
	self._initialTime = typeof(initialTime) == "number" and initialTime or 0
	self._timeScale = 1
	return self
end

function Timer:start()
	if not self._running then
		self._startTime = os.clock() - self._elapsed
		self._running = true
	end
end

function Timer:stop()
	if self._running then
		self._elapsed = os.clock() - self._startTime
		self._running = false
	end
end

function Timer:reset()
	self._startTime = os.clock()
	self._elapsed = 0
	self._running = false
end

function Timer:isCountingDown()
	return self._initialTime < 0 and self:getRawTime() < 0
end

function Timer:getRawTime()
	local realElapsed = self._running and (os.clock() - self._startTime) or self._elapsed
	local scaledTime = realElapsed * self._timeScale
	return self._initialTime + scaledTime
end

function Timer:getTime()
	local rawTime = self:getRawTime()
	local isNegative = rawTime < 0
	local time = math.abs(rawTime)
	local totalMilliseconds = math.floor(time * 100)
	local hours = math.floor(time / 3600)
	local minutes = math.floor((time % 3600) / 60)
	local seconds = math.floor(time % 60)
	local centiseconds = totalMilliseconds % 100

	local formatted
	if hours >= 1 then
		formatted = string.format("%d:%02d:%02d.%02d", hours, minutes, seconds, centiseconds)
	else
		formatted = string.format("%d:%02d.%02d", minutes, seconds, centiseconds)
	end

	if isNegative then
		return "-" .. formatted
	else
		return formatted
	end
end

return Timer
