local RunService = game:GetService("RunService")

local camera = workspace.CurrentCamera
camera.FieldOfView = 50
camera.CameraType = Enum.CameraType.Scriptable

local target = script.Parent:GetPivot()
local orbitRadius = shared.EarthSettings.orbitRadius
local orbitSpeed = shared.EarthSettings.orbitSpeed
local orbitInclinationAngle = shared.EarthSettings.orbitInclinationAngle

local angle = 0

RunService:BindToRenderStep("OrbitCamera", Enum.RenderPriority.Character.Value, function(dt)
	if not camera then
		return
	end
	
	angle += orbitSpeed * dt

	-- Orbit inclination (rotate around X-axis before applying orbit)
	local xRotCFrame = CFrame.Angles(orbitInclinationAngle, 0, 0)
	local orbitOffset = Vector3.new(
		math.cos(angle) * orbitRadius,
		0,
		-math.sin(angle) * orbitRadius
	)
	orbitOffset = xRotCFrame:VectorToWorldSpace(orbitOffset)

	local cameraPosition = target.Position + orbitOffset
	camera.CFrame = CFrame.new(cameraPosition, target.Position)
end)