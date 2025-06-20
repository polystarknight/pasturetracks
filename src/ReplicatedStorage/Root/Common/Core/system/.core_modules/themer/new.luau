local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Root = ReplicatedStorage:FindFirstChild("Root")
local Common = Root.Common
local Core = Common.Core
local system = Core.system

local core_modules = system[".core_modules"]
local util57 = system["util-57"]

local colors = require(util57.color.tailwind)
local Fusion = require(script.Parent.Parent.Fusion)

local Peek = Fusion.peek
local InnerScope = Fusion.innerScope

local function ProcessMultipliers(Objects: {
	Base: Fusion.Value<Fusion.Scope<any>, number>,
	[string]: Fusion.Value<Fusion.Scope<any>, number>,
	})
	local Base = Peek(Objects.Base)
	for Key, Value in pairs(Objects) do
		if Peek(Value) == nil then
			local Multiplier = tonumber(Key)
			if Multiplier ~= nil then
				Value:set(Base * Multiplier)
			end
		end
	end

	if Objects.Full ~= nil then
		Objects.Full:set(Base * 10000)
	end
end

local function NewTheme(Scope: Fusion.Scope<any>, ThemeSpec)
	local Scope = InnerScope(Scope, Fusion)

	local ThemeObject = {
		Colors = {
			Primary = {
				Main = Scope:Value(colors.Black),
				Dark = Scope:Value(nil),
				Light = Scope:Value(nil),
				Contrast = Scope:Value(nil),
			},
			Secondary = {
				Main = Scope:Value(colors.Black),
				Dark = Scope:Value(nil),
				Light = Scope:Value(nil),
				Contrast = Scope:Value(nil),
			},
			Accent = {
				Main = Scope:Value(Color3.fromRGB(0, 255, 140)),
				Dark = Scope:Value(nil),
				Light = Scope:Value(nil),
				Contrast = Scope:Value(nil),
			},

			Neutral = {
				Main = Scope:Value(colors.Gray["300"]),
				Dark = Scope:Value(nil),
				Light = Scope:Value(nil),
				Contrast = Scope:Value(nil),
			},
			NeutralContent = {
				Main = Scope:Value(colors.Gray["800"]),
				Dark = Scope:Value(nil),
				Light = Scope:Value(nil),
				Contrast = Scope:Value(nil),
			},

			Base = {
				Main = Scope:Value(colors.White),
				Main2 = Scope:Value(Color3.fromRGB(255, 245, 255)),
				Dark = Scope:Value(nil),
				Light = Scope:Value(nil),
				Contrast = Scope:Value(nil),
			},
			BaseContent = {
				Main = Scope:Value(colors.Black),
				Dark = Scope:Value(nil),
				Light = Scope:Value(nil),
				Contrast = Scope:Value(nil),
			},

			Success = {
				Main = Scope:Value(colors.Green["400"]),
				Dark = Scope:Value(nil),
				Light = Scope:Value(nil),
				Contrast = Scope:Value(nil),
			},
			Error = {
				Main = Scope:Value(colors.Red["400"]),
				Dark = Scope:Value(nil),
				Light = Scope:Value(nil),
				Contrast = Scope:Value(nil),
			},
			Warning = {
				Main = Scope:Value(colors.Orange["400"]),
				Dark = Scope:Value(nil),
				Light = Scope:Value(nil),
				Contrast = Scope:Value(nil),
			},
			Info = {
				Main = Scope:Value(colors.Blue["400"]),
				Dark = Scope:Value(nil),
				Light = Scope:Value(nil),
				Contrast = Scope:Value(nil),
			},
		},
		ObjectSize = {
			FitToScale = Scope:Value(UDim2.new(1, 0, 1, 0))	
		},
		Font = {
			Body = Scope:Value("rbxasset://fonts/families/Sarpanch.json"),
			Heading = Scope:Value("rbxasset://fonts/families/Sarpanch.json"),
			Monospace = Scope:Value("rbxasset://fonts/families/Sarpanch.json"),
		},
		FontWeight = {
			Body = Scope:Value(Enum.FontWeight.Regular),
			Bold = Scope:Value(Enum.FontWeight.Bold),
			Heading = Scope:Value(Enum.FontWeight.SemiBold),
		},
		TextSize = {
			Base = Scope:Value(16),
			ButtonCard = Scope:Value(42),
			["0.75"] = Scope:Value(nil),
			["0.875"] = Scope:Value(nil),
			["1"] = Scope:Value(nil),
			["1.125"] = Scope:Value(nil),
			["1.25"] = Scope:Value(nil),
			["1.5"] = Scope:Value(nil),
			["1.875"] = Scope:Value(nil),
			["2.25"] = Scope:Value(nil),
			["3"] = Scope:Value(nil),
			["3.75"] = Scope:Value(nil),
			["4.5"] = Scope:Value(nil),
		},
		Spacing = {
			Base = Scope:Value(16),
			["0"] = Scope:Value(0),
			["0.25"] = Scope:Value(nil),
			["0.5"] = Scope:Value(nil),
			["0.75"] = Scope:Value(nil),
			["1"] = Scope:Value(nil),
			["1.5"] = Scope:Value(nil),
			["2"] = Scope:Value(nil),
			["3"] = Scope:Value(nil),
			["4"] = Scope:Value(nil),
			["6"] = Scope:Value(nil),
			["8"] = Scope:Value(nil),
			["12"] = Scope:Value(nil),
			["16"] = Scope:Value(nil),
			["24"] = Scope:Value(nil),
			["32"] = Scope:Value(nil),
			["40"] = Scope:Value(nil),
			["48"] = Scope:Value(nil),
		},
		CornerRadius = {
			Base = Scope:Value(4),
			["0"] = Scope:Value(0),
			["0.5"] = Scope:Value(nil),
			["1"] = Scope:Value(nil),
			["1.5"] = Scope:Value(nil),
			["2"] = Scope:Value(nil),
			["3"] = Scope:Value(nil),
			["4"] = Scope:Value(nil),
			["6"] = Scope:Value(nil),
			Full = Scope:Value(nil),
		},
		StrokeThickness = {
			Base = Scope:Value(2),
			["0"] = Scope:Value(0),
			["1"] = Scope:Value(nil),
			["2"] = Scope:Value(nil),
			["3"] = Scope:Value(nil),
			["4"] = Scope:Value(nil),
			["8"] = Scope:Value(nil),
		},
		SpringSpeed = {
			Base = Scope:Value(40),
			["0.1"] = Scope:Value(nil),
			["0.175"] = Scope:Value(nil),
			["0.25"] = Scope:Value(nil),
			["0.375"] = Scope:Value(nil),
			["0.5"] = Scope:Value(nil),
			["0.75"] = Scope:Value(nil),
			["1"] = Scope:Value(nil),
			["1.5"] = Scope:Value(nil),
			["2"] = Scope:Value(nil),
			Immediate = Scope:Value(1000),
		},
		SpringDampening = {
			Base = Scope:Value(1),
			["0.1"] = Scope:Value(nil),
			["0.175"] = Scope:Value(nil),
			["0.25"] = Scope:Value(nil),
			["0.375"] = Scope:Value(nil),
			["0.5"] = Scope:Value(nil),
			["0.75"] = Scope:Value(nil),
			["1"] = Scope:Value(nil),
			["1.5"] = Scope:Value(nil),
			["2"] = Scope:Value(nil),
			["5"] = Scope:Value(nil),
			["10"] = Scope:Value(nil),
			Full = Scope:Value(1000),
		},
		Sound = {
			Hover = Scope:Value(Scope:New "Sound" {
				SoundId = "rbxassetid://10066936758",
				Volume = 0.05,
			}),
			Click = Scope:Value(Scope:New "Sound" {
				SoundId = "rbxassetid://16480549841",
				Volume = 0.5,
			}),
			Focus = Scope:Value(Scope:New "Sound" {
				SoundId = "rbxassetid://16480549841",
				Volume = 0.5,
			}),
			Switch = Scope:Value(Scope:New "Sound" {
				SoundId = "rbxassetid://9119713951",
				Volume = 0.5,
			}),
		},
		Emphasis = {
			Light = Scope:Value(0.15),
			Regular = Scope:Value(0.3),
			Strong = Scope:Value(0.5),
			Contrast = Scope:Value(1),
		},
	}

	ProcessMultipliers(ThemeObject.Spacing)
	ProcessMultipliers(ThemeObject.CornerRadius)
	ProcessMultipliers(ThemeObject.TextSize)
	ProcessMultipliers(ThemeObject.StrokeThickness)
	ProcessMultipliers(ThemeObject.SpringSpeed)
	ProcessMultipliers(ThemeObject.SpringDampening)

	return ThemeObject
end

return NewTheme