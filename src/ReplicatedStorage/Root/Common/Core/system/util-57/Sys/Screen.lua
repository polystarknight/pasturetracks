local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Screen = {}

function Screen:GetScreenResolution(method: "Camera" | "Mouse")
	if method == "Camera" then
		local camera = workspace.CurrentCamera
		return camera.ViewportSize
	elseif method == "Mouse" then
		if RunService:IsServer() then
			warn("Unable to get screen resolution on server.")
			return
		end

		local mouse = game.Players.LocalPlayer:GetMouse()
		return Vector2.new(mouse.ViewSizeX, mouse.ViewSizeY)

	end

	return nil
end

return Screen