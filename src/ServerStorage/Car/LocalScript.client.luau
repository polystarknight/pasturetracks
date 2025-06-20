local uis = game:GetService("UserInputService")

local car = workspace.Car

uis.InputBegan:Connect(function(key)
	
	local dir = Vector2int16.new(
		(uis:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (uis:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
		(uis:IsKeyDown(Enum.KeyCode.W) and 1 or 0) - (uis:IsKeyDown(Enum.KeyCode.S) and 1 or 0)
	)
	
	car.Control:FireServer(dir)
	
end)

uis.InputEnded:Connect(function(key)
	
	local dir = Vector2int16.new(
		(uis:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (uis:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
		(uis:IsKeyDown(Enum.KeyCode.W) and 1 or 0) - (uis:IsKeyDown(Enum.KeyCode.S) and 1 or 0)
	)

	car.Control:FireServer(dir)
	
end)
