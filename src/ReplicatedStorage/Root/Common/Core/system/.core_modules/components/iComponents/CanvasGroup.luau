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
local Components = {
	Base = Base,
}

export type Props = Base.Props & {}

--[=[
		@within CanvasGroup
		@field ... BaseProps
]=]
return function(Scope: Fusion.Scope<any>, Props: Props)
	local Scope = InnerScope(Scope, Fusion, Components)
	
	return Scope:Hydrate(Scope:Base(Util.CombineProps(Props, {
		ClassName = "CanvasGroup",
		Name = "Group",
		BackgroundTransparency = 1,
	}))) {
		GroupTransparency = Props.GroupTransparency,
		GroupColor3 = Props.GroupColor3,
	}
end