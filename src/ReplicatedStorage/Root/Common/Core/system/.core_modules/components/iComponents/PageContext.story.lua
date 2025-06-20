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
local OnChange = Fusion.OnChange
local peek = Fusion.peek

local Themer = require(core_modules.themer)
local Frame = require(script.Parent.Frame)
local PageItemFlow = require(script.Parent.PageItemFlow)

local Components = {
	Frame = Frame,
	PageItemFlow = PageItemFlow
}

return {
	story = function(Props)
		local Scope = InnerScope(Props.scope :: Fusion.Scope<any>, Fusion, Components)
		local Theme = Themer.Theme:now()
		
		local currentPage = Scope:Value(nil)
		local page = Scope:New "UIPageLayout" {
			EasingStyle = Enum.EasingStyle.Circular,
			EasingDirection = Enum.EasingDirection.Out,
			Padding = UDim.new(0, 8),
			TweenTime = 0.25,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			[OnChange "CurrentPage"] = function(current)
				currentPage:set(current)
			end,
		}
		
		local possibleFrames = Scope:Value({
			Scope:PageItemFlow {
				CurrentPage = (currentPage)
			},
			Scope:PageItemFlow {
				CurrentPage = (currentPage)
			},
			Scope:PageItemFlow {
				CurrentPage = (currentPage)
			},
			Scope:PageItemFlow {
				CurrentPage = (currentPage)
			},
			Scope:PageItemFlow {
				CurrentPage = (currentPage)
			},
			Scope:PageItemFlow {
				CurrentPage = (currentPage)
			},
			Scope:PageItemFlow {
				CurrentPage = (currentPage)
			},
			Scope:PageItemFlow {
				CurrentPage = (currentPage)
			},
		})

		Scope:Frame {
			Parent = Props.target,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 30, 0.5, 0),
			Size = UDim2.new(0, 320, 0, 200),
			BackgroundTransparency = 1,

			[Children] = {
				page,
				possibleFrames,
			}
		}
		
	end,
	fusion = Fusion,
}
