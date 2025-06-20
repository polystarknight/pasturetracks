local UserInputService = game:GetService("UserInputService")
local mouse = UserInputService.GetMouseLocation
local Player = game:GetService("Players")

local user = Player.LocalPlayer
local PlayerGui = user:FindFirstChildOfClass("PlayerGui")

local MouseContainer = Instance.new("ScreenGui")
MouseContainer.Name = "_MOUSE"
MouseContainer.DisplayOrder = 99999999
MouseContainer.IgnoreGuiInset = true
MouseContainer.ResetOnSpawn = false
MouseContainer.Parent = PlayerGui

local newMouse = Instance.new("ImageLabel")
newMouse.Image = "rbxassetid://1000000"
newMouse.ResampleMode = Enum.ResamplerMode.Pixelated
newMouse.AnchorPoint = Vector2.new(0.5, 0.5)
newMouse.ScaleType = Enum.ScaleType.Crop
newMouse.Size = UDim2.fromOffset(64, 64)
newMouse.BackgroundTransparency = 1
newMouse.Parent = MouseContainer

UserInputService.MouseIconEnabled = false

local UDim2 = UDim2.new

local function Update()
	local currentMouse = mouse(UserInputService)

	newMouse.Position = UDim2(0, currentMouse.X, 0, currentMouse.Y)
end

return Update