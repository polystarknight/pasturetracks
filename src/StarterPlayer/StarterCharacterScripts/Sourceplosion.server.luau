local soundTable = script.Sounds:GetChildren()

game.Workspace.DescendantAdded:Connect(function(Thing)
	if Thing.ClassName == "Explosion" then
		local ExplosionSoundPart = Instance.new("Part")
		
		ExplosionSoundPart.Name = "ExplosionSoundPart"
		ExplosionSoundPart.Anchored = true
		ExplosionSoundPart.CanCollide = false
		ExplosionSoundPart.CanTouch = false
		ExplosionSoundPart.CanQuery = false
		ExplosionSoundPart.Size = Vector3.new(1, 1, 1)
		ExplosionSoundPart.Transparency = 1
		
		local randomSound = soundTable[math.random(1, #soundTable)]
		local clonedSound = randomSound:Clone()
		
		clonedSound.Parent = ExplosionSoundPart
		
		ExplosionSoundPart.Position = Thing.Position
		
		ExplosionSoundPart.Parent = Thing
		
		clonedSound:Play()
		
		wait(5)
		
		ExplosionSoundPart:Destroy()
	end
end)