local rs = game:GetService("RunService")

local cam = workspace.CurrentCamera
local car = workspace.Car

local offset = Vector3.new(0, 10, 20)
local angle = Vector3.new(25, 0, 0)
local smoothness = 10

cam.CameraType = Enum.CameraType.Scriptable
--cam.CameraSubject = car

rs.RenderStepped:Connect(function(deltaTime)
	
	local a = CFrame.Angles(math.rad(angle.X), math.rad(angle.Y), math.rad(angle.Z))
	local c = car.CFrame - car.CFrame.LookVector*offset.Z + Vector3.new(0, offset.Y, 0)
	c = CFrame.new(c.Position, car.Position)
	
	--cam.CFrame = cam.CFrame:Lerp(c, smoothness*deltaTime)
	cam.CFrame = cam.CFrame:Lerp(c, smoothness*deltaTime)
	
end)
