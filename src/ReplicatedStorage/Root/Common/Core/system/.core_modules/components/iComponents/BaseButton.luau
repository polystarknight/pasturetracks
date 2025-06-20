local SoundService = game:GetService("SoundService")

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
local OnEvent = Fusion.OnEvent
local Peek = Fusion.peek
local InnerScope = Fusion.innerScope

local Themer = require(core_modules.themer)
local Base = require(script.Parent.Base)
local Frame = require(script.Parent.Frame)

local Components = {
	Base = Base,
	Frame = Frame
}

export type Props = Base.Props & {}

return function(Scope: Fusion.Scope<any>, Props: Props)
	local Scope = InnerScope(Scope, Fusion, Util, Components)
	local Theme = Themer.Theme:now()

	local Disabled = Util.Fallback(Props.Disabled, false)
	local IsHovering = Scope:EnsureValue(Util.Fallback(Props.IsHovering, false))
	local IsHolding = Scope:EnsureValue(Util.Fallback(Props.IsHolding, false))
	local OnActivated = Util.Fallback(Props.OnActivated, function() end)
	local OnMouseEnter = Util.Fallback(Props.OnMouseEnter, function() end)
	local OnMouseLeave = Util.Fallback(Props.OnMouseLeave, function() end)
	local OnMouseButton1Down = Util.Fallback(Props.OnMouseButton1Down, function() end)
	local OnMouseButton1Up = Util.Fallback(Props.OnMouseButton1Up, function() end)
	local HoverSound = Util.Fallback(Props.HoverSound, Theme.Sound.Hover)
	local ClickSound = Util.Fallback(Props.ClickSound, Theme.Sound.Click)
	local Active = Util.Fallback(
		Props.Active,
		Scope:Computed(function(Use)
			return not Use(Disabled)
		end)
	)
	local Selectable = Util.Fallback(
		Props.Selectable,
		Scope:Computed(function(Use)
			return not Use(Disabled)
		end)
	)

	return Scope:Hydrate(Scope:Base(Util.CombineProps(Props, {
		ClassName = "TextButton",
		Name = "BaseButton",
		Selectable = Selectable,
		BackgroundTransparency = 1,
	}))) {
		Text = "",
		RichText = false,
		TextSize = 0,

		[OnEvent "Activated"] = function()
			if not Peek(Disabled) then
				SoundService:PlayLocalSound(Peek(ClickSound))
				Peek(OnActivated)()
			end
		end,
		[OnEvent "MouseEnter"] = function()
			if Peek(Active) then
				SoundService:PlayLocalSound(Peek(HoverSound))
			end
			IsHovering:set(true)
			Peek(OnMouseEnter)()
		end,
		[OnEvent "SelectionGained"] = function()
			if Peek(Active) then
				SoundService:PlayLocalSound(Peek(HoverSound))
			end
			IsHovering:set(true)
			Peek(OnMouseEnter)()
		end,
		[OnEvent "MouseLeave"] = function()
			IsHovering:set(false)
			IsHolding:set(false)
			Peek(OnMouseLeave)()
		end,
		[OnEvent "MouseButton1Down"] = function()
			if not Peek(Disabled) then
				IsHolding:set(true)
				Peek(OnMouseButton1Down)()
			end
		end,
		[OnEvent "MouseButton1Up"] = function()
			IsHolding:set(false)
			Peek(OnMouseButton1Up)()
		end,
	}
end