print("using Task")

local RunService = game:GetService("RunService")

local Launchpad = script.Parent.Parent
local system = Launchpad.Parent

local util57 = system["util-57"]
local class = require(util57._class)

local TICKS_PER_SECOND = 1
local connection = nil
local taskLists = {}

local module = class() :: class.extends<gameTask>

function module:ctor(): gameTask
	self.init = function()
		self.Tick = 0
		self.OnTick = shared.Event.new()
		self.PostTicks = shared.Event.new()
	end
end

function module.Start(self: gameTask, startTime)
	if connection ~= nil then
		return false
	end
	self.StartTime = startTime
	connection = RunService.Heartbeat:Connect(function()
		self:Loop()
	end)
	return true
end

function module.Stop(self: gameTask)
	if connection == nil then
		return false
	end
	connection:Disconnect()
	connection = nil
	table.clear(taskLists)
	self.Tick = 0
	return true
end

function module.Wait(self, amount)
	local scheduledTick = self.Tick + math.max(amount, 1)
	local taskList = taskLists[scheduledTick]
	if taskList == nil then
		taskList = shared.List.new()
		taskLists[scheduledTick] = taskList
	end
	taskList:InsertBack({ Thread = coroutine.running() })
	return coroutine.yield()
end

function module.Delay(self, amount, func, ...)
	local scheduledTick = self.Tick + math.max(amount, 1)
	local taskList = taskLists[scheduledTick]
	if taskList == nil then
		taskList = shared.List.new()
		taskLists[scheduledTick] = taskList
	end
	return taskList:InsertBack({ Function = func, Parameters = {...} })
end


function module.Loop(self: gameTask)
	local currentTick = math.round((workspace:GetServerTimeNow() - self.StartTime) * TICKS_PER_SECOND)
	if self.Tick >= currentTick then return end
	while self.Tick < currentTick do
		self.Tick += 1
		self.OnTick:Fire(self.Tick)
		local taskList = taskLists[self.Tick]
		if taskList == nil then continue end
		local scheduledTask = taskList.Next
		while scheduledTask ~= taskList do
			if scheduledTask.Thread then
				task.spawn(scheduledTask.Thread, self.Tick)
			else
				shared.Threads:Spawn(scheduledTask.Function, table.unpack(scheduledTask.Parameters))
			end
			scheduledTask = scheduledTask.Next
		end
		taskLists[self.Tick] = nil
	end
	self.PostTicks:Fire()
end

type gameTaskData = {
	Tick: number,
	StartTime: number,
}

export type gameTask = setmetatable<gameTaskData, typeof(module)>

return module.new()