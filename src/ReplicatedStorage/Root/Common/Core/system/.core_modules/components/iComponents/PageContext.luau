local components = script.Parent.Parent
local core_modules = components.Parent
local util57 = core_modules.Parent["util-57"]

local Core = core_modules.Parent.Parent

local Util = require(util57.UI.FusionUtils)
local Fusion = require(core_modules.Fusion)
local New = Fusion.New
local Child = Fusion.Child
local Children = Fusion.Children
local OnChange = Fusion.OnChange
local InnerScope = Fusion.innerScope

local Themer = require(core_modules.themer)
local colors = require(util57.color.tailwind)

local Frame = require(script.Parent.Frame)
local PageItemFlow = require(script.Parent.PageItemFlow)

local Components = {
	Frame = Frame,
	PageItemFlow = PageItemFlow
}

return function(Scope: Fusion.Scope<any>, Props: Props)
	local Scope = InnerScope(Scope, Fusion, Components)
	local Theme = Themer.Theme:now()

	local currentPage = Scope:Value(nil)
	local SelectorAbsolutePositionX = Scope:Value(nil)
	local Peeking = Props.Enabled or Scope:Value(false)

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

	local animatePeek = Scope:Spring(Scope:Computed(function(Use)
		return Use(Peeking) and 1 or 1.5
	end), 30, 0.8)

	local animatePeekCursor = Scope:Spring(Scope:Computed(function(Use)
		-- Tried not to hardcode this, but OnChange has forced my hand.
		return Use(Peeking) and -525 or 525
	end), 30, 0.8)

	local animatePeekCursorTransparency = Scope:Spring(Scope:Computed(function(Use)
		-- Tried not to hardcode this, but OnChange has forced my hand.
		return Use(Peeking) and 0 or 1
	end), 25, 1)

	local Selector = Scope:Frame {
		Parent = Props.target,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = Scope:Computed(function(Use)
			return UDim2.new(Use(animatePeek), 50, 0.5, 0)
		end),
		Size = UDim2.new(0, 320, 0, 300),
		BackgroundTransparency = 1,

			--[[
			OnChange "AbsolutePosition"] = function(Position)
				print("e")
				SelectorAbsolutePositionX:set(Position.X)
			end,
			]]

		[Children] = {
			page,
			possibleFrames,
		}
	}

	local Cursor = Scope:Text {
		AnchorPoint = Vector2.new(1, 0.5),
		Name = "Cursor",
		Size = UDim2.new(0, 50, 0, 50),
		Position = Scope:Computed(function(Use)
			return UDim2.new(1, math.round(Use(animatePeekCursor)), 0.5, 0)
		end),

		TextTransparency = Scope:Computed(function(Use)
			return Use(animatePeekCursorTransparency)
		end),

		TextColor3 = colors.White,
		TextSize = 40,
		Text = "▶",
		TextXAlignment = "Center",
		TextYAlignment = "Center",

		StrokeEnabled = true,
		StrokeColor = colors.Black,
		StrokeTransparency = 0.4,
		StrokeApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,

		Visible = Props.Enabled,
	}

	return Scope:Document {
		Name = "PageContextContainer",
		Size = Theme.ObjectSize.FitToScale,

		[Children] = {
			Selector,
			Cursor,
		}
	}

end