local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local user = Players.LocalPlayer

local Sector = script.Parent.Parent
local SectorComponents = Sector.Components

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
local Peek = Fusion.peek

local IComponents = core_modules.components.iComponents
local Themer = require(core_modules.themer)
local Document = require(IComponents.Document)
local MenuButton = require(SectorComponents.MenuButton)
local PageContext = require(IComponents.PageContext)

local Context = require(Sector.Context)

local Components = {
	Document = Document,
	MenuButton = MenuButton,
	PageContext = PageContext
}

return function(Scope: Fusion.Scope<any>, Props: Props): Instance
	local Scope = InnerScope(Scope, Fusion, Util, Components)
	local Theme = Themer.Theme:now()

	return Scope:Document {
		Name = "TrackEditorPage",
		Size = Theme.ObjectSize.FitToScale,
		Visible = Props.Visible,
		ListEnabled = true,
		ListPadding = UDim.new(0, 15),
		PaddingBottom = UDim.new(0, 15),
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10),
		PaddingTop = UDim.new(0, 0),


		[Children] = {
			Scope:MenuButton {
				Content = { "rbxassetid://0", "New Track" },
				OnMouseButton1Down = function()
					shared.TrackEditor.newSession()
                    --Context.mapSelectorIsPeeking:set(not Peek(Context.mapSelectorIsPeeking))
				end,
			},
            Scope:MenuButton {
				Content = { "rbxassetid://0", "Load Track" },
				OnMouseButton1Down = function()
					
				end,
			},
			Scope:Document {
				Name = "Padding",
				FlexMode = Enum.UIFlexMode.Fill,
				Size = Theme.ObjectSize.FitToScale,
			},
			Scope:MenuButton {
				Content = { "rbxassetid://0", "Back" },
				ContentImageColor = Color3.fromRGB(255, 255, 255),
				OnMouseButton1Down = Props.OnBack and function()
					Props.OnBack()
					Context.mapSelectorIsPeeking:set(false)
				end,
			},
		}
	}
end

