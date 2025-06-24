local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Root = ReplicatedStorage:FindFirstChild("Root")
local Common = Root.Common
local Core = Common.Core
local system = Core.system
local data = Core.data

local core_modules = system[".core_modules"]
local util57 = system["util-57"]

local class = require(util57._class)
local KeybindMap = require("@self/Keybinds")
local Settings = require("@self/Settings")
local Spring = require("@self/Spring")

export type Camera = {

}

local keyFOV = 0

local BASE_MULTIPLIER = 50
local NM_ZOOM = math.tan(Settings.defaultFOV * math.pi/360)
local LVEL_GAIN = Vector3.new(1, 0.75, 1)
local RVEL_GAIN = Vector2.new(0.85, 1)/128
local FVEL_GAIN = -330

local CameraController = class() :: class.extends<Camera>

local function keyDown(key)
    for i = 1, #KeybindMap[key] do
		if UserInputService:IsKeyDown(KeybindMap[key][i]) == false then continue end
        return true
	end
end

local function createSprings()
    return {
        velSpring = Spring.new(7/9, 1/15, 1, Vector3.zero),
        rotSpring = Spring.new(7/9, 1/15, 1, Vector2.zero),
        fovSpring = Spring.new(2,   1/15, 1, 0),
    }
end

function CameraController:ctor()
    self.connection = nil

    self.springs = createSprings()

    self.DIRECTION_LEFT = 1
    self.DIRECTION_RIGHT = 2
    self.DIRECTION_FORWARD = 3
    self.DIRECTION_BACKWARD = 4
    self.DIRECTION_DOWN = 5
    self.DIRECTION_UP = 6

    self.speedModifier = 1

    self.panDeltaMouse = Vector2.new()
    self.stateRot = Vector2.new()
end

local function inputProcessing(self, dt: number, currentCamera)
    local springs = self.springs
    local cameraCFrame = currentCamera.CFrame

    local LEFT = self.DIRECTION_LEFT
    local RIGHT = self.DIRECTION_RIGHT
    local FORWARD = self.DIRECTION_FORWARD
    local BACKWARD = self.DIRECTION_BACKWARD
    local UP = self.DIRECTION_UP
    local DOWN = self.DIRECTION_DOWN

    local keyX = (keyDown(RIGHT) and 1 or 0) - (keyDown(LEFT) and 1 or 0)
    local keyY = (keyDown(UP) and 1 or 0) - (keyDown(DOWN) and 1 or 0)
    local keyZ = (keyDown(BACKWARD) and 1 or 0) - (keyDown(FORWARD) and 1 or 0)

    springs.velSpring.t = Vector3.new(keyX, keyY, keyZ) * dt * BASE_MULTIPLIER * self.speedModifier
	springs.rotSpring.t = self.panDeltaMouse
    springs.fovSpring.t = math.clamp(springs.fovSpring.t + (dt * keyFOV * FVEL_GAIN), 5, 120)

    local fov  = springs.fovSpring:Update(dt)
    local dPos = springs.velSpring:Update(dt) * LVEL_GAIN
	local dRot = springs.rotSpring:Update(dt) * (RVEL_GAIN * math.tan(fov * math.pi/360) * NM_ZOOM)

    keyFOV = 0
    self.panDeltaMouse = Vector2.new()

    self.stateRot = self.stateRot + dRot   
	self.stateRot = Vector2.new(math.clamp(self.stateRot.x, -3/2, 3/2), self.stateRot.y)

    local finalCFrame = CFrame.new(cameraCFrame.Position) * CFrame.Angles(0, self.stateRot.y, 0) * CFrame.Angles(self.stateRot.x, 0, 0) * CFrame.new(dPos)
    currentCamera.CFrame = finalCFrame
    currentCamera.Focus = finalCFrame * CFrame.new(0, 0, -16)
    currentCamera.FieldOfView = fov
end

local function panningProcessing(self, input, gameProcessedEvent)
    if not gameProcessedEvent and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Delta
		self.panDeltaMouse = Vector2.new(-delta.Y, -delta.X)
	end
end

local function handleInput(key, connection)
    if not key then
        return
    end

    if not connection then
        return
    end

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            connection:Disconnect()
        end
    end)
end

local function processInputs(self, input, gameProcessedEvent)
    local conn = nil

    if gameProcessedEvent then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        conn = UserInputService.InputChanged:Connect(function(...)
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
            panningProcessing(self, ...)
        end)

        handleInput(Enum.UserInputType.MouseButton2, conn)
    end
end 

function CameraController.hook(self)
    local connection = self.connection

    if not workspace.CurrentCamera then
        warn("[Track Editor]: Failed to get currentCamrea")
        return
    end

    if not connection then
        local springs = self.springs

        local currentCamera = workspace.currentCamera
        local lookVector = currentCamera.CFrame.LookVector.Unit
        currentCamera.CameraType = Enum.CameraType.Scriptable
        currentCamera.CFrame = CFrame.new(0, 100, 0)

        springs.velSpring.t, springs.velSpring.v, springs.velSpring.x = Vector3.new(), Vector3.new(), Vector3.new()
	    springs.rotSpring.t, springs.rotSpring.v, springs.rotSpring.x = Vector2.new(), Vector2.new(), Vector2.new()
	    springs.fovSpring.t, springs.fovSpring.v, springs.fovSpring.x = currentCamera.FieldOfView, 0, currentCamera.FieldOfView

        self.stateRot = Vector2.new(
		    math.asin(lookVector.Y),
		    math.atan2(-lookVector.Z, lookVector.X) - math.pi/2
    	)
	    self.panDeltaMouse = Vector2.new()

        connection = RunService:BindToRenderStep("newCamera", Enum.RenderPriority.Camera.Value, function(dt)
            inputProcessing(self, dt, currentCamera)
        end)

        UserInputService.InputBegan:Connect(function(...)
            processInputs(self, ...)
        end)
    end
end

function CameraController.doCleanup(self)
    local connection = self.connection
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

return CameraController.new()