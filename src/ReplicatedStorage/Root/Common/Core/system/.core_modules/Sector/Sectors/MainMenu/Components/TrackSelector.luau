local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Root = ReplicatedStorage:FindFirstChild("Root")
local Common = Root.Common
local Core = Common.Core
local system = Core.system
local data = Core.data

local Sector = script.Parent.Parent

local core_modules = system[".core_modules"]

local Fusion = require(core_modules.Fusion)
local InnerScope = Fusion.innerScope

local IComponents = require(core_modules.components.iComponents.context)
local Context = require(Sector.Context)

return function(Scope: Fusion.Scope<any>, Props)
	local Scope = InnerScope(Scope, Fusion, IComponents)

	return Scope:PageContext { 
		Enabled = Scope:Computed(function(Use)
			return Use(Context.mapSelectorIsPeeking)
		end)
	}
end