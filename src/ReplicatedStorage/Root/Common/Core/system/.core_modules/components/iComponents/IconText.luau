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
local Icon = require(script.Parent.Icon)
local Text = require(script.Parent.Text)

local Components = {
	Frame = Frame,
	Icon = Icon,
	Text = Text,
}

export type Props = Base.Props & {}

return function(Scope: Fusion.Scope<any>, Props: Props)
	local Scope = InnerScope(Scope, Fusion, Util, Components)
	local Theme = Themer.Theme:now()

	local Content = Util.Fallback(Props.Content, {})
	local ContentSize = Util.Fallback(Props.ContentSize, Theme.TextSize["1"])
	local ContentColor = Util.Fallback(Props.ContentColor, Theme.Colors.BaseContent.Main)
	local ContentImageColor = Util.Fallback(Props.ContentImageColor, Theme.Colors.BaseContent.Main)
	local ContentTransparency = Util.Fallback(Props.ContentTransparency, 0)
	local ContentWrapped = Util.Fallback(Props.ContentWrapped, true)
	local ContentRichText = Util.Fallback(Props.ContentRichText, true)
	local ContentFontFace = Util.Fallback(
		Props.ContentFontFace,
		Scope:Computed(function(Use)
			return Font.new(Use(Theme.Font.Body), Use(Theme.FontWeight.Body))
		end)
	)
	local TextPadding = Util.Fallback(Props.TextPadding, {})

	return Scope:Frame(Util.CombineProps(Props, {
		Name = script.Name,
		ListEnabled = true,
		ListFillDirection = Enum.FillDirection.Horizontal,
		ListPadding = Scope:Computed(function(Use)
			return UDim.new(0, Use(Theme.Spacing["0.25"]))
		end),
		
		PaddingBottom = UDim.new(0, 0),
		PaddingLeft = UDim.new(0, 12),
		PaddingRight = UDim.new(0, 12),
		PaddingTop = UDim.new(0, 0),

		[Children] = {
			Scope:ForValues(Content, function(Use, Scope, ContentString: string)
				if string.find(ContentString, "rbxassetid://", 1, true) then
					return Scope:Icon {
						Image = ContentString,
						ImageColor3 = ContentImageColor,
						Size = Props.ContentImageSize,
						ImageTransparency = ContentTransparency,
					}
				else
					return Scope:Text {
						Size = UDim2.new(1, 0, 1, 0),
						Text = ContentString,
						TextColor3 = ContentColor,
						TextSize = ContentSize,
						TextTransparency = ContentTransparency,
						TextXAlignment = Props.TextXAlignment,
						TextYAlignment = Props.TextYAlignment,
						TextWrapped = ContentWrapped,
						RichText = ContentRichText,
						FontFace = ContentFontFace,
						FlexMode = Enum.UIFlexMode.Fill,
						
						PaddingBottom = TextPadding.Bottom,
						PaddingLeft = TextPadding.Left,
						PaddingRight = TextPadding.Right,
						PaddingTop = TextPadding.Top,
					}
				end
			end)
		},
	}))
end