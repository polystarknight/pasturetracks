print("using Human") 
-- ...

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local user = Players.LocalPlayer

local Root = ReplicatedStorage:FindFirstChild("Root")
local Common = Root.Common
local Core = Common.Core
local system = Core.system
local data = Core.data

local events = data[".events"]
local core_modules = system[".core_modules"]
local util57 = system["util-57"]
local Components = core_modules.components

local class = require(util57._class)
local color = require(util57.color.tailwind)
local IComponents = require(Components.iComponents.context)
local RemoteFunction = require(util57.Suphi.RemoteFunction)

local requestLogin = RemoteFunction.new("requestLogin")

local human = class() :: class.extends<human>

function human:ctor(player: Player): human
	self.accepted = false
end

function human.defer(self: human, callback: () -> ())
	local exampleRequest = "AUTO_REQUEST_COUNTRY"
	
	requestLogin.Event = function(msg)
		print(msg)
		
		if msg == "OK" then
			task.spawn(callback)
		end
		
		return exampleRequest
	end
	
	--
end

type humanData = {
	accepted: boolean,
	player: Player,
	defer: (self: human, callback: () -> ()) -> (),
}
export type human = setmetatable<humanData, typeof(human)>

return human