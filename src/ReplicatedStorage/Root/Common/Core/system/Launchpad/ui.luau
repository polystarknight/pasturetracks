print("using UI") 
-- ...

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local user = Players.LocalPlayer

local Root = ReplicatedStorage:FindFirstChild("Root")
local Common = Root.Common
local Core = Common.Core
local system = Core.system
local data = Core.data

local core_modules = system[".core_modules"]
local util57 = system["util-57"]
local Components = core_modules.components

local color = require(util57.color.tailwind)
local IComponents = require(Components.iComponents.context)
local Fusion = require(core_modules.Fusion)

local New = Fusion.New
local Children = Fusion.Children
local FusionScope = Fusion.scoped(Fusion)
local InnerScope = Fusion.innerScope

local PlayerGui: BasePlayerGui = user:FindFirstChildOfClass("PlayerGui")
local Sectors = require(core_modules.Sector.Sectors)

local self = {}

function self.start()
	draw(0)
end

local function getScene()
	local scope = InnerScope(FusionScope, Fusion, IComponents)

	return scope:New "ScreenGui" {
		Name = "App",
		Parent = PlayerGui,
		Enabled = true,
		IgnoreGuiInset = true,
	}
end

function draw(level: number)
	local humanServices = shared.humanitarianServices
	local human = humanServices.new()
	
	if level == 0 then
		human:defer(function()
			warn("UI draw level 0")	
		end)
		
		return
	end
	
	local scope = InnerScope(FusionScope, Fusion, Sectors)
	local scene = getScene()
	
	human:defer(function()
		scope.MainMenu.Start(scope, scene)
	end)
	
	return 0
end

return self