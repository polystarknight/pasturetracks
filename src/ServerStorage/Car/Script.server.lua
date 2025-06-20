local rs = game:GetService("RunService")

local car = script.Parent

local corners = {
	TopRight = Vector3.new(car.Size.X/2, 0, car.Size.Z/2),
	TopLeft = Vector3.new(-car.Size.X/2, 0, car.Size.Z/2),
	BottomRight = Vector3.new(car.Size.X/2, 0, -car.Size.Z/2),
	BottomLeft = Vector3.new(-car.Size.X/2, 0, -car.Size.Z/2)
}

local forces:{VectorForce} = {
	TopRight = Instance.new("VectorForce", car),
	TopLeft = Instance.new("VectorForce", car),
	BottomRight = Instance.new("VectorForce", car),
	BottomLeft = Instance.new("VectorForce", car)
}

local parts = {}

local suspensionLength = 3
local suspensionForce = 5000

local airDrag  = .1
local drag = 2
local angularDrag = 7

local accerleration = 250
local turnSpeed = 35

local params = RaycastParams.new()
params.FilterDescendantsInstances = {script.Parent}
params.FilterType = Enum.RaycastFilterType.Blacklist

local dir = Vector2int16.new(0, 0)

for i, v in pairs(corners) do

	local att = Instance.new("Attachment", car)
	att.Name = tostring(i)
	att.Position = v
	forces[i].Attachment0 = att
	forces[i].Force = Vector3.zero
	forces[i].Name = tostring(i)
	
	
	parts[i] = Instance.new("Part",workspace)
	parts[i].Size = Vector3.new(1, 1, 1)
	parts[i].CanCollide = false
	parts[i].Anchored = true
	parts[i].CanQuery = false
	table.insert(params.FilterDescendantsInstances, parts[i])

end

local upsideDown = 0
rs.Stepped:Connect(function(t, deltaTime)
	local r = workspace:Raycast(car.Position, car.CFrame.UpVector*2, params)
	local rotation = math.abs(car.Orientation.Z) > 100 or math.abs(car.Orientation.X) > 100
	if r and rotation then
		upsideDown+=deltaTime
	else
		upsideDown = 0
	end
	if upsideDown > 2 then
		print("turning")
		upsideDown = 0
		car.Orientation = car.Orientation + Vector3.new(0, 0, 180)
		return
	end
	
	local isGrounded = 0

	for i, corner in pairs(corners) do
		
		local s = math.sin(-math.rad(car.Orientation.Y))
		local c = math.cos(-math.rad(car.Orientation.Y))
		local z = math.sin(-math.rad(car.Orientation.Z))
		
		corner += car.Position
		
		corner = Vector3.new(
			corner.X - car.Position.X,
			corner.Y - car.Position.Y,
			corner.Z - car.Position.Z
		)
		
		local xNew = corner.X * c - corner.Z * s
		local yNew = corner.Y * z - corner.X * z
		local zNew = corner.X * s + corner.Z * c
		
		corner = Vector3.new(
			xNew + car.Position.X,
			yNew + car.Position.Y,
			zNew + car.Position.Z
		)
		
		local c = CFrame.new( corner )
		local ray = workspace:Raycast(c.Position, -car.CFrame.UpVector*suspensionLength, params)
		
		
		parts[i].Position = c.Position
		if ray then
			
			isGrounded += 1
			
			local ratio = (suspensionLength-ray.Distance)/suspensionLength

			forces[i].Force = Vector3.new(0, 1, 0)*(ratio*suspensionForce)
		end

	end
	if isGrounded >= 3 then isGrounded = true else isGrounded = false end

	local multiplier = 1 - (isGrounded and drag or airDrag) * deltaTime
	if multiplier < 0 then multiplier = 0 end
	car.AssemblyLinearVelocity *= multiplier
	
	multiplier = 1 - angularDrag * deltaTime
	if multiplier < 0 then multiplier = 0 end
	car.AssemblyAngularVelocity *= multiplier
	
	if isGrounded then car.AssemblyLinearVelocity += car.CFrame.LookVector*dir.Y*accerleration*deltaTime end
	car.AssemblyAngularVelocity += Vector3.new(0, -dir.X*turnSpeed*deltaTime, 0)

end)
car.Control.OnServerEvent:Connect(function(player, direction:Vector2int16)
	
	dir = direction
	
end)
