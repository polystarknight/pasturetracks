local balls = Instance.new("Folder")
balls.Parent = workspace

local density = .7
local friction = 0
local elasticity = 1
local frictionweight = 1
local elasticityweight = 25
local properties = PhysicalProperties.new(density, friction, elasticity, frictionweight, elasticityweight)

local function createBall()
	--local trail = Instance.new("Trail")
	local part = Instance.new("Part")
	local attachment0 = Instance.new("Attachment")
	local attachment1 = Instance.new("Attachment")
	attachment0.Parent = part
	attachment1.Parent = part
	attachment0.Position -= Vector3.new(0, 0.5, 0)
	attachment1.Position += Vector3.new(0, 0.5, 0)
	part.Shape = Enum.PartType.Ball
	part.Size = Vector3.new(1, 1, 1)
	part.Parent = balls
	part.Position = script.Parent.Position
	part.AssemblyLinearVelocity = Vector3.new(75, 50, 0)
	part.CustomPhysicalProperties = properties
	--[[trail.Brightness = 0.5
	trail.Lifetime = 10
	trail.Attachment0 = attachment0
	trail.Attachment1 = attachment1
	trail.Parent = part]]
end

while true do
	createBall()
	task.wait(0.3)
end