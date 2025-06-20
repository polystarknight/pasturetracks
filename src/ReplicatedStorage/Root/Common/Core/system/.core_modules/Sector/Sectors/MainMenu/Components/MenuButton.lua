local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Sector = script.Parent

local Root = ReplicatedStorage:FindFirstChild("Root")
local Common = Root.Common
local Core = Common.Core
local system = Core.system
local data = Core.data

local core_modules = system[".core_modules"]
local util57 = system["util-57"]

local Util = require(util57.UI.FusionUtils)
local Fusion = require(core_modules.Fusion)
local New = Fusion.New
local Child = Fusion.Child
local Children = Fusion.Children
local InnerScope = Fusion.innerScope

local IComponents = require(core_modules.components.iComponents.context)
local Themer = require(core_modules.themer)

export type Props = Base.Props & {}

return function(Scope: Fusion.Scope<any>, Props: Props): Instance
	local Scope = InnerScope(Scope, Fusion, Util, IComponents)
	local Theme = Themer.Theme:now()

	return Scope:MenuButtonChip(Util.CombineProps(Props, {
		Content = { "rbxassetid://16170737185", "ButtonChip" },
		ContentFontFace = Font.fromEnum(Enum.Font.Highway),
		ContentSize = Theme.TextSize.ButtonCard,
		ContentColor = Theme.Colors.Base.Main2,
		ContentImageColor = Theme.Colors.Accent.Main,
		ContentImageSize = UDim2.new(0, 100, 0, 65),
		Size = UDim2.new(1, 0, 0, 95),
		BackdropCornerRadius = UDim.new(0, 10),
		BackdropGlowCornerRadius = UDim.new(0, 12),
		BackdropDepthCornerRadius = UDim.new(0, 14),
		BackdropGradientColor = Theme.Colors.Accent.Main,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,

		TextPadding = {
			Bottom = UDim.new(0, 18),
			Left = UDim.new(0, 0),
			Right = UDim.new(0, 0),
			Top = UDim.new(0, 0),
		},

		OnMouseButton1Down = function()
			print("Unassigned")
		end,
	}))
end