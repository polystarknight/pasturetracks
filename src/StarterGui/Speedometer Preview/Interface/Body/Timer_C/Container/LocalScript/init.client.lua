task.wait(1)

local RunService = game:GetService("RunService")

local timer = script.Parent.TrueContainer.Timer

local Stopwatch = require(script.Timer)
local currentTimer = Stopwatch.new(-3)

currentTimer:start()

RunService.RenderStepped:Connect(function(deltaTime: number) 
	timer.Text = currentTimer:getTime()
end)