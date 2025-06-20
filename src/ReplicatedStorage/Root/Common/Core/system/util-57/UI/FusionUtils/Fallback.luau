--[=[
	@function Fallback
	@within Util

	@param Value Fusion.UsedAs<any>
	@param Fallback any
	@return any
	
	Defaults the given `Value` to `Fallback` if nil.
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

return function(Value: Fusion.UsedAs<any>, Fallback: any)
	if Peek(Value) == nil then
		if (typeof(Value) == "table") and (Value.kind == "Value") and (Value.set ~= nil) then
			Value:set(Fallback)
			return Value
		else
			return Fallback
		end
	else
		return Value
	end
end
