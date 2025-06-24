local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Root = ReplicatedStorage:FindFirstChild("Root")
local Common = Root.Common
local Core = Common.Core
local system = Core.system

local class = require("./util-57/_class")

export type GameProcess = {
	id: string,
	timer: number,
	mode: string,
	
	launch: () -> (),
}

local process = class() :: class.extends<GameProcess>

function process:ctor()
	
end

function process.launch(self: typeof(process.new()))
	for _, component in ipairs(system.Launchpad:GetDescendants()) do
		if not component:IsA("ModuleScript") then continue end
		if component:GetAttribute("ignoreModuleOnStartup") == true then continue end

		shared[component.Name] = require(component)
	end
	
	for _, module in shared do
		if module == nil then continue end
		if type(module) == "function" then continue end

		if type(module.init) == "function" then 
			module.init() 
		end
		if type(module.start) == "function" then 
			task.defer(module.start) 
		end
	end
end

function process.kill()
	
end

return process.new()