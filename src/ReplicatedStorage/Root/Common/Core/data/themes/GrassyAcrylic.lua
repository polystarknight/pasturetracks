local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Root = ReplicatedStorage:FindFirstChild("Root")
local Common = Root.Common
local Core = Common.Core
local system = Core.system

local core_modules = system[".core_modules"]
local util57 = system["util-57"]

local colors = require(util57.color.tailwind)

local NewTheme = require(core_modules.themer.new)
local Fusion = require(core_modules.Fusion)

local Scope = Fusion.scoped(Fusion)

local GrassyAcrylic = NewTheme(Scope, {
	Colors = {
		Primary = {
			Main = colors.Violet["500"],
		},
		Secondary = {
			Main = colors.White,
		},
		Accent = {
			Main = colors.White,
		},

		Neutral = {
			Main = colors.Stone["800"],
		},
		NeutralContent = {
			Main = colors.Stone["300"],
		},

		Base = {
			Main = colors.Stone["900"],
		},
		BaseContent = {
			Main = colors.White,
		},

		Success = {
			Main = colors.Green["500"],
		},
		Error = {
			Main = colors.Red["500"],
		},
		Warning = {
			Main = colors.Amber["500"],
		},
		Info = {
			Main = colors.Cyan["400"],
		},
	},
	Font = {
		Body = "rbxasset://fonts/families/Sarpanch.json",
		Heading = "rbxasset://fonts/families/Sarpanch.json",
		Monospace = "rbxasset://fonts/families/Sarpanch.json",
	},
	FontWeight = {
		Body = Enum.FontWeight.SemiBold,
		Bold = Enum.FontWeight.Bold,
		Heading = Enum.FontWeight.Bold,
	},
	TextSize = {
		Base = 19,
	},
	CornerRadius = {
		Base = 6,
	},
	StrokeThickness = {
		Base = 2,
	},
	Spacing = {
		Base = 16,
	},
	SpringSpeed = {
		Base = 50,
	},
	SpringDampening = {
		Base = 1,
	},
	Sound = {},
	Emphasis = {},
})

return GrassyAcrylic