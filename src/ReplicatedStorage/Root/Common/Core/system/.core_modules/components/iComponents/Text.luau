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

local Components = {
	Base = Base,
}

export type Props = Base.Props & {}

return function(Scope: Fusion.Scope<any>, Props: Props): Instance
	local Scope = InnerScope(Scope, Fusion, Util, Components)
	local Theme = Themer.Theme:now()

	local TextColor3 = Util.Fallback(Props.TextColor3, Theme.Colors.BaseContent.Main)
	local TextSize = Util.Fallback(Props.TextSize, Theme.TextSize["1"])
	local RichText = Util.Fallback(Props.RichText, true)
	local FontFace = Util.Fallback(
		Props.FontFace,
		Scope:Computed(function(Use)
			return Font.new(Use(Theme.Font.Body), Use(Theme.FontWeight.Body))
		end)
	)
	local TextWrapped = Util.Fallback(Props.TextWrapped, true)
	local TextXAlignment = Util.Fallback(Props.TextXAlignment, Enum.TextXAlignment.Left)
	local TextYAlignment = Util.Fallback(Props.TextYAlignment, Enum.TextYAlignment.Top)

	return Scope:Hydrate(Scope:Base(Util.CombineProps(Props, {
		ClassName = "TextLabel",
		Name = "Text",
		AutomaticSize = Enum.AutomaticSize.XY,
		ClipsDescendants = false,
		BackgroundTransparency = 1,
	}))) {
		TextColor3 = TextColor3,
		TextSize = TextSize,
		RichText = RichText,
		FontFace = FontFace,
		TextWrapped = TextWrapped,
		TextXAlignment = TextXAlignment,
		TextYAlignment = TextYAlignment,

		Text = Props.Text,
		TextTransparency = Props.TextTransparency,
		TextStrokeTransparency = Props.TextStrokeTransparency,
		MaxVisibleGraphemes = Props.MaxVisibleGraphemes,
		LocalizedText = Props.LocalizedText,
		LineHeight = Props.LineHeight,
		TextTruncate = Props.TextTruncate,
		TextScaled = Props.TextScaled,
		Font = Props.Font,
	}
end