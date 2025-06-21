local components = script.Parent.Parent
local core_modules = components.Parent
local util57 = core_modules.Parent["util-57"]

local Core = core_modules.Parent.Parent
local data = Core.data

local Util = require(util57.UI.FusionUtils)
local Fusion = require(core_modules.Fusion)
local New = Fusion.New
local Children = Fusion.Children
local InnerScope = Fusion.innerScope

local Base = require(script.Parent.Base)
local Document = require(script.Parent.Document)
local Components = {
	Base = Base,
	Document = Document,
}

export type Props = Base.Props & {}

--[=[
		@within Frame
		@field ... BaseProps
]=]
return function(Scope: Fusion.Scope<any>, Props: Props)
	local Scope = InnerScope(Scope, Fusion, Components)
	
	local Style = Props.Style

	local Frame = Scope:Base(Util.CombineProps(Props, {
		ClassName = "Frame",
		Name = "Frame",
		BackgroundTransparency = 1,
	}))

	
	return Frame
end