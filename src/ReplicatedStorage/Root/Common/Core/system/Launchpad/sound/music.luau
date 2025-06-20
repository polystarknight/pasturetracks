local module = {}

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://96069651195832"
sound.Looped = true
sound.Volume = 0.5
sound.Parent = game:GetService("SoundService")
sound:Play()

return module
