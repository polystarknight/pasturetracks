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
local Base = require(script.Parent.Base)
local Frame = require(script.Parent.Frame)
local Image = require(script.Parent.Image)

local Components = {
	Image = Image
}

export type Props = Base.Props & {}

return function(Scope: Fusion.Scope<any>, Props: Props)
	local Scope = InnerScope(Scope, Fusion, Util, Components)
	local Theme = Themer.Theme:now()

	return Scope:Image(Util.CombineProps(Props, {
		Name = "Icon",
		Size = Scope:Computed(function(Use)
			return UDim2.fromOffset(Use(Theme.TextSize["1"]), Use(Theme.TextSize["1"]))
		end),
		BackgroundTransparency = 1,
	}))
end