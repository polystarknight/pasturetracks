local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Root = ReplicatedStorage:FindFirstChild("Root")
local Common = Root.Common
local Core = Common.Core

local system = Core.system
local data = Core.data

local core_modules = system[".core_modules"]
local util57 = system["util-57"]

local THEME_GOES_HERE = require(data.themes.GrassyAcrylic)
local NewTheme = require(script.new)
local Fusion = require(script.Parent.Fusion)

local Scoped = Fusion.scoped
local Contextual = Fusion.Contextual

local Themer = {}

--[=[
	@function NewTheme
	@within Themer

	@param Scope Fusion.Scope<any>
	@param ThemeSpec ThemeSpec
	@return Theme

	Creates the specified theme.
]=]
function Themer.NewTheme(Scope: Fusion.Scope<any>, ThemeSpec)
	return NewTheme(Scope, ThemeSpec)
end

--[=[
	@prop Theme Fusion.Contextual<Theme>
	@within Themer

	The currently active theme. Use `Themer.Theme:now()` to get the active theme, and `Themer.Theme:is(MyTheme):during()` to make code use another theme. See [Fusion Contextuals](https://elttob.uk/Fusion/0.3/tutorials/best-practices/sharing-values/?h=contextuals#contextuals) for more information.
]=]
local Theme: Fusion.Contextual<Theme> = Contextual(THEME_GOES_HERE)
Themer.Theme = Theme

export type Theme = typeof(Themer.NewTheme(Scoped(), {}))

return Themer