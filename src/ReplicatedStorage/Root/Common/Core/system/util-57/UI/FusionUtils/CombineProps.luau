--[=[
		@function CombineProps
		@within Util

		@param Source Fusion.PropertyTable
		@param Target Fusion.PropertyTable
		@param ExcludedKeys { any }?
		@return Fusion.PropertyTable
		
		Combines two sets of props for easy passthrough, adding `Source`'s props to `Target`. If a prop is already in `Target`, it will be overridden.
]=]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Root = ReplicatedStorage:FindFirstChild("Root")
local Common = Root.Common
local Core = Common.Core

local system = Core.system
local data = Core.data

local core_modules = system[".core_modules"]
local Fusion = require(core_modules.Fusion)

local function CombineProps(
	Source: Fusion.PropertyTable,
	Target: Fusion.PropertyTable,
	ExcludedKeys: { any }?
): Fusion.PropertyTable
	for Key, Value in pairs(Source) do
		if (ExcludedKeys ~= nil) and (table.find(ExcludedKeys, Key) ~= nil) then
			continue
		end

		Target[Key] = Value
	end

	return Target
end

return CombineProps
