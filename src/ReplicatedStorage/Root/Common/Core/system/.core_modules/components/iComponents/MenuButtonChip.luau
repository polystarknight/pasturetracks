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
local Peek = Fusion.peek

local ColorUtils = require(util57.color["colour-utils"])
local colors = require(util57.color.tailwind)
local Themer = require(core_modules.themer)
local Base = require(script.Parent.Base)
local Frame = require(script.Parent.Frame)
local Document = require(script.Parent.Document)

local Components = {
	Frame = Frame,
	Document = Document
}

export type Props = Base.Props & {}

local DISABLED_BACKGROUND_TRANSPARENCY = 0.925
local DISABLED_CONTENT_TRANSPARENCY = 0.75

return function(Scope: Fusion.Scope<any>, Props: Props)
	local Scope = InnerScope(Scope, Fusion, Util, Components)
	local Theme = Themer.Theme:now()
	
	local Backdrop = data.cabinet.Backdrop:Clone()
	Backdrop.Backplate.UICorner.CornerRadius = Props.BackdropCornerRadius --UDim.new(0, 10) 
	Backdrop.Features.Glow.UICorner.CornerRadius = Props.BackdropGlowCornerRadius --UDim.new(0, 11)
	Backdrop.Features.Depth.UICorner.CornerRadius = Props.BackdropDepthCornerRadius --UDim.new(0, 14)
	Backdrop.Features.Glow.UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, colors.White),
		ColorSequenceKeypoint.new(1, Peek(Props.BackdropGradientColor)),
	})
	
	local SizeVariant = Util.Fallback(Props.SizeVariant, "Medium")
	local Disabled = Util.Fallback(Props.Disabled, false)
	local Content = Util.Fallback(Props.Content, {})
	local Style = Util.Fallback(Props.Style, "Filled")
	local Color = Util.Fallback(Props.Color, Theme.Colors.Neutral.Main)
	local ContentColor = Util.Fallback(
		Props.ContentColor,
		Scope:Computed(function(Use)
			return ColorUtils.Emphasize(Use(Color), Use(Theme.Emphasis.Contrast))
		end)
	)
	local ContentSize = Util.Fallback(
		Props.ContentSize,
		Scope:Computed(function(Use)
			local VariantSizes = {
				TitleCard = Use(Theme.TextSize.ButtonCard),
				ExtraSmall = Use(Theme.TextSize["0.875"]),
				Small = Use(Theme.TextSize["1"]),
				Medium = Use(Theme.TextSize["1"]),
				Large = Use(Theme.TextSize["1.25"]),
				ExtraLarge = Use(Theme.TextSize["1.25"]),
			}

			return VariantSizes[Use(SizeVariant)]
		end)
	)
	local ContentFontFace = Util.Fallback(
		Props.ContentFontFace,
		Scope:Computed(function(Use)
			return Font.new(Use(Theme.Font.Body), Use(Theme.FontWeight.Body))
		end)
	)
	local ContentWrapped = Util.Fallback(Props.ContentWrapped, false)

	local IsHovering = Scope:EnsureValue(Util.Fallback(Props.IsHovering, false))
	local IsHolding = Scope:EnsureValue(Util.Fallback(Props.IsHolding, false))

	local EffectiveColor = Scope:Computed(function(Use)
		if Use(Disabled) then
			return Use(Theme.Colors.BaseContent.Main)
		else
			if Use(IsHolding) then
				return ColorUtils.Emphasize(Use(Color), Use(Theme.Emphasis.Strong))
			elseif Use(IsHovering) then
				return ColorUtils.Emphasize(Use(Color), Use(Theme.Emphasis.Regular))
			else
				return Use(Color)
			end
		end
	end)
	local EffectiveContentColor = Scope:Computed(function(Use)
		if Use(Disabled) then
			return Use(Theme.Colors.BaseContent.Main)
		else
			if Use(Style) == "Filled" then
				return Use(ContentColor)
			elseif Use(Style) == "Outlined" then
				return Use(EffectiveColor)
			elseif Use(Style) == "Ghost" then
				return Use(EffectiveColor)
			else
				return Use(ContentColor)
			end
		end
	end)
	local EffectiveContentTransparency = Scope:Computed(function(Use)
		if Use(Disabled) then
			return DISABLED_CONTENT_TRANSPARENCY
		else
			return 0
		end
	end)
	local PaddingX = Scope:Computed(function(Use)
		local VariantSizes = {
			ExtraSmall = Use(Theme.Spacing["0.25"]),
			Small = Use(Theme.Spacing["0.5"]),
			Medium = Use(Theme.Spacing["0.75"]),
			Large = Use(Theme.Spacing["1"]),
			ExtraLarge = Use(Theme.Spacing["1.5"]),
		}

		return UDim.new(0, VariantSizes[Use(SizeVariant)])
	end)
	local PaddingY = Scope:Computed(function(Use)
		local VariantSizes = {
			ExtraSmall = 0.5,
			Small = 0.75,
			Medium = 1.25,
			Large = 1.5,
			ExtraLarge = 2,
		}

		return UDim.new(0, Use(Theme.Spacing["0.25"]) * VariantSizes[Use(SizeVariant)])
	end)

	return Scope:BaseButton(Util.CombineProps(Props, {
		Name = "Button",
		BackgroundTransparency = Scope:Computed(function(Use)
			if Use(Style) == "Filled" then
				if Use(Disabled) then
					return DISABLED_BACKGROUND_TRANSPARENCY
				else
					return 0
				end
			else
				return 1
			end
		end),
		BackgroundColor3 = Scope:Spring(EffectiveColor, Theme.SpringSpeed["1"], Theme.SpringDampening["1"]),
		CornerRadius = Scope:Computed(function(Use)
			return UDim.new(0, Use(Theme.CornerRadius["2"]))
		end),
		--[[PaddingLeft = PaddingX,
		PaddingRight = PaddingX,
		PaddingTop = PaddingY,
		PaddingBottom = PaddingY,]]
		--StrokeEnabled = true,
		--StrokeColor = Scope:Spring(EffectiveColor, Theme.SpringSpeed["1"], Theme.SpringDampening["1"]),
		--[[StrokeTransparency = Scope:Computed(function(Use)
			if Use(Style) == "Ghost" then
				return 1
			elseif Use(Disabled) then
				return DISABLED_BACKGROUND_TRANSPARENCY
			else
				return 0
			end
		end),]]
		IsHolding = IsHolding,
		IsHovering = IsHovering,

		[Children] = {
			Scope:Document {
				ListEnabled = true,
				ListFillDirection = Enum.FillDirection.Horizontal,
				ListHorizontalAlignment = Enum.HorizontalAlignment.Center,
				ListVerticalAlignment = Enum.VerticalAlignment.Center,
				ListWraps = false,
			},
			
			Scope:Hydrate(Backdrop) {},
			
			Scope:IconText {
				Size = Theme.ObjectSize.FitToScale,
				Content = Content,
				ContentFontFace = ContentFontFace,
				ContentColor = EffectiveContentColor,
				ContentImageColor = Props.ContentImageColor,
				ContentTransparency = EffectiveContentTransparency,
				ContentSize = ContentSize,
				ContentImageSize = Props.ContentImageSize,
				ContentWrapped = ContentWrapped,
				ListHorizontalAlignment = Enum.HorizontalAlignment.Center,
				ListVerticalAlignment = Enum.VerticalAlignment.Center,
				TextXAlignment = Props.TextXAlignment,
				TextYAlignment = Props.TextYAlignment,
				
				TextPadding = Props.TextPadding,
			},
		},
	}))
end