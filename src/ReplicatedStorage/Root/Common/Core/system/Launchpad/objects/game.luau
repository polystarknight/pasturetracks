local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local user = Players.LocalPlayer

local Launchpad = script.Parent.Parent
local system = Launchpad.Parent

local core_modules = system[".core_modules"]
local util57 = system["util-57"]
local class = require(util57._class)

local module = class() :: class.extends<gameTask>

function module:ctor(): gameTask
	self.start = function()
		--shared.Task.OnTick:Connect(OnTick, "asd")
		--shared.Task:Delay(8, OnDelay)
		shared.Task:Start(workspace:GetServerTimeNow())
	end
end

type gameTaskData = {

}

export type gameTask = setmetatable<gameTaskData, typeof(module)>

return module.new()
