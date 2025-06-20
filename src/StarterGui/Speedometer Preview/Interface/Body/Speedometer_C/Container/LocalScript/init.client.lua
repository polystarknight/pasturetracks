local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Units = require(script.Units)

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid: Humanoid = character:WaitForChild("Humanoid")

local studsTraveled = 0
local startPosition = humanoid.RootPart:GetPivot().Position

local function normalizeSpeed(value: number): number
	return math.floor(value)
end

-- Update the speedometer dial and nitro bar
local function Update()
	local currentPosition = humanoid.RootPart:GetPivot().Position
	local distance = (currentPosition - startPosition).Magnitude
	
	if distance > 0.1 then
		studsTraveled += distance
		startPosition = currentPosition
	end
	
--[[	
	local minScreenSize = math.min(gui.AbsoluteSize.X, gui.AbsoluteSize.Y)
	local isSmallScreen = minScreenSize < Constants.UI_SMALL_SCREEN_THRESHOLD
	gui.Speedometer.UIScale.Scale = if isSmallScreen then Constants.UI_SMALL_SCREEN_SCALE else 1
]]

	local speed = humanoid.RootPart.AssemblyLinearVelocity.Magnitude
	local trueSpeed = Units.studsToKilometersPerHour(speed)
	local normalizedSpeed = normalizeSpeed(trueSpeed)
	local distanceTraveled = math.floor(studsTraveled)
	
	script.Parent.TrueContainer.Speed.Text = `{normalizedSpeed}`
	script.Parent.TrueContainer.Unit.Text = `{distanceTraveled} s`
end

heartbeatConnection = RunService.Heartbeat:Connect(Update)