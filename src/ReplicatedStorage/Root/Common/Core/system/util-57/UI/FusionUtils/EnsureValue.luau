--[=[
	@function EnsureValue
	@within Util

	@param Scope Fusion.Scope<any>
	@param Value Fusion.UsedAs<any>
	@return Fusion.Value<Fusion.Scope<any>, any>
	
	Converts the `Value` argument to a `Fusion.Value` object, if it is not one already.
]=]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Root = ReplicatedStorage:FindFirstChild("Root")
local Common = Root.Common
local Core = Common.Core

local system = Core.system
local data = Core.data

local core_modules = system[".core_modules"]
local Fusion = require(core_modules.Fusion)

local Peek = Fusion.peek

return function(Scope: Fusion.Scope<any>, Value: Fusion.UsedAs<any>): Fusion.Value<Fusion.Scope<any>, any>
	if (typeof(Value) == "table") and (Value.kind == "Value") then
		return Value
	else
		return Fusion.Value(Scope, Peek(Value))
	end
end
