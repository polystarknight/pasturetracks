local components = script.Parent.Parent
local core_modules = components.Parent
local util57 = core_modules.Parent["util-57"]

local Core = core_modules.Parent.Parent
local data = Core.data

local Util = require(util57.UI.FusionUtils)
local Fusion = require(core_modules.Fusion)
local New = Fusion.New
local Child = Fusion.Child
local Children = Fusion.Children
local InnerScope = Fusion.innerScope

local Themer = require(core_modules.themer)
local Frame = require(script.Parent.Frame)

local Components = {
	Frame = Frame
}

export type Props = Base.Props & {}

local NEW_SIZE = UDim2.new(1, 250, 1, 0)
local NORMAL_SIZE = UDim2.new(0, 100, 1, 0)
local NEW_TR = 0
local NORMAL_TR = 0.75

return function(Scope: Fusion.Scope<any>, Props: Props): Instance
	local Scope = InnerScope(Scope, Fusion, Util, Components)
	local Theme = Themer.Theme:now()
	
	local isFirstRender = Scope:Value(true)

	local currentSize = Scope:Value(NORMAL_SIZE)
	local frameRef = Scope:Value(nil)

	local targetSize = Scope:Spring(Scope:Computed(function(Use)
		if Use(Props.CurrentPage) == Use(frameRef) then
			return NEW_SIZE
		else
			return NORMAL_SIZE
		end
	end), 30, 1)
	
	--[[local targetTransparency = Scope:Spring(Scope:Computed(function(Use)
		if Use(Props.CurrentPage) == Use(frameRef) then
			return NEW_TR
		else
			return NORMAL_TR
		end
	end), 20, 1)]]


	local page = frameRef:set(Scope:Frame {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Color3.fromRGB(150, 25, 25),
		--BackgroundTransparency = targetTransparency,
		Size = targetSize,
		Style = "Aero",
	})
	
	return page
end