local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local user = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Sector = script.Parent

local Root = ReplicatedStorage:FindFirstChild("Root")
local Common = Root.Common
local Core = Common.Core
local system = Core.system
local data = Core.data

local core_modules = system[".core_modules"]
local util57 = system["util-57"]

local colors = require(util57.color.tailwind)
local Themer = require(core_modules.themer)

local Fusion = require(core_modules.Fusion)
local New = Fusion.New
local Children = Fusion.Children
local InnerScope = Fusion.innerScope
local Peek = Fusion.peek

local Services = core_modules.components.services
local IComponents = require(core_modules.components.iComponents.context)
local MenuComponents = require(script.Parent.Components)
local Context = require(script.Parent.Context)

local MainMenu = {}

function MainMenu.Init()
	
end

function MainMenu.Start(Scope: Fusion.Scope<any>, scene)
	MainMenu.DrawTabCenter(Scope, { Parent = scene })
end

function MainMenu.DrawTabCenter(Scope: Fusion.Scope<any>, Props)
	local Scope = InnerScope(Scope, Fusion, IComponents, MenuComponents)
	local Theme = Themer.Theme:now()

	Scope:Document {
		Size = Theme.ObjectSize.FitToScale,
		Parent = Props.Parent,

		[Children] = {
			Scope:Menu { },
			Scope:TrackSelector { },
		}
	}
end

return MainMenu
