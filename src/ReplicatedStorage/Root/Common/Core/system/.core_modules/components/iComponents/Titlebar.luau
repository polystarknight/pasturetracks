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
local colors = require(util57.color.tailwind)

local Base = require(script.Parent.Base)
local Document = require(script.Parent.Document)
local Frame = require(script.Parent.Frame)
local IconText = require(script.Parent.IconText)
local Components = {
	Base = Base,
	Document = Document,
	Frame = Frame,
	IconText = IconText,
}

export type Props = Base.Props & {}

--[=[
		@within Frame
		@field ... BaseProps
]=]
return function(Scope: Fusion.Scope<any>, Props: Props)
	local Scope = InnerScope(Scope, Fusion, Components)
	local Theme = Themer.Theme:now()
	
	local TitleIcon = Util.Fallback(Props.TitleIcon, "rbxassetid://80218226919142")
	local Content = Util.Fallback(Props.Content, {})
	local ContentSize = Util.Fallback(Props.ContentSize, Theme.TextSize["1.5"])
	local ContentColor = Util.Fallback(Props.ContentColor, Theme.Colors.BaseContent.Main)
	local ContentFontFace = Util.Fallback(
		Props.ContentFontFace,
		Scope:Computed(function(Use)
			return Font.new(Use(Theme.Font.Heading), Use(Theme.FontWeight.Heading))
		end)
	)
	
	return Scope:Frame(Util.CombineProps(Props, {
		Name = "Titlebar",
		Size = UDim2.new(1, 0, 0, 52),
		PaddingTop = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10),
		PaddingBottom = UDim.new(0, 0),
		
		[Children] = {
			Scope:Computed(function()
				return data.cabinet.Backdrop:Clone()
			end),
			
			Scope:IconText {
				Name = "Title",
				Size = UDim2.new(1, 0, 1, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0),
				Content = Content,
				ContentColor = ContentColor,
				ContentSize = ContentSize,
				ContentFontFace = ContentFontFace,
				ContentWrapped = false,
				TextXAlignment = Props.TextXAlignment,
				TextYAlignment = Props.TextYAlignment,
				PaddingTop = UDim.new(0, 0),
				PaddingLeft = UDim.new(0, 30),
				PaddingRight = UDim.new(0, 30),
				PaddingBottom = UDim.new(0, 0),
				ListPadding = Scope:Computed(function(Use)
					return UDim.new(0, Use(Theme.Spacing["0.5"]))
				end),
			}
		}
	}))
end