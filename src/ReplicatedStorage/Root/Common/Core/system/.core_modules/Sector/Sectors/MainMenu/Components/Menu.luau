local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Root = ReplicatedStorage:FindFirstChild("Root")
local Common = Root.Common
local Core = Common.Core
local system = Core.system
local data = Core.data

local Sector = script.Parent.Parent

local core_modules = system[".core_modules"]
local Themer = require(core_modules.themer)

local Fusion = require(core_modules.Fusion)
local Children = Fusion.Children
local InnerScope = Fusion.innerScope
local Peek = Fusion.peek

local IComponents = require(core_modules.components.iComponents.context)
local Context = require(Sector.Context)

return function(Scope: Fusion.Scope<any>, Props)
	local Scope = InnerScope(Scope, Fusion, IComponents)
    local Theme = Themer.Theme:now()

    local currentPage = Scope:Value("Home")
	local pageHistoryStack = Scope:Value({})
	local currentPageLabel = Scope:Value(nil)
	
	local function goToPage(newPage)
		local history = Peek(currentPage)
		if history ~= newPage then
			pageHistoryStack:set(table.clone(Peek(pageHistoryStack)))
			table.insert(Peek(pageHistoryStack), Peek((currentPage)))
		end
		
		currentPage:set(newPage)
	end
	
	local function goBack()
		local history = Peek(pageHistoryStack)
		local lastPage = history[#history]

		if lastPage then
			currentPage:set(lastPage)
			local newHistory = table.clone(history)
			table.remove(newHistory, #newHistory)
			pageHistoryStack:set(newHistory)
		end
	end

	local pageContents = Scope:Computed(function(Use)
		local page = Use(currentPage)
		if page == "Home" then
			currentPageLabel:set({ "Welcome!" })
			return Scope:HomePage { 
				Visible = Use(currentPage) == "Home",
				OnNext = goToPage,
			}
		elseif page == "PlaySolo"  then
			currentPageLabel:set({ "Play Solo" })
			return Scope:PlaySolo { 
				Visible = Use(currentPage) == "PlaySolo",
				OnBack = goBack
			}
		elseif page == "TrackEditor"  then
			currentPageLabel:set({ "Track Editor" })
			return Scope:TrackEditor { 
				Visible = Use(currentPage) == "TrackEditor",
				OnBack = goBack
			}
		else
			return {}
		end
	end)

	local Peeking = Scope:Value(false)
	local animatePeek = Scope:Tween(Scope:Computed(function(Use)
		return Use(Peeking) and 0 or -500
	end), TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out))

    task.delay(0.1, function()
		Peeking:set(true)
	end)

	return Scope:Document {
		AnchorPoint = Vector2.new(0, 0),
		Position = Scope:Computed(function(Use)
			return UDim2.new(0, Use(animatePeek), 0, 0)
		end),
		Parent = Props.Parent,
		Size = UDim2.new(0, 450, 1, 0),

		[Children] = {
			Scope:Document {
				Name = "Container",
				Size = UDim2.new(1, 0, 1, 0),
				ListEnabled = true,
				ListPadding = UDim.new(0, 30),
				[Children] = {
					Scope:Titlebar {
						Content = currentPageLabel,
						ContentSize = 42,
						ContentColor = Color3.fromRGB(255, 245, 255),
						ContentFontFace = Font.new(
							"rbxasset://fonts/families/Sarpanch.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Italic),
						Size = UDim2.new(1, 0, 0, 52),
						TextXAlignment = Enum.TextXAlignment.Right,
						TextYAlignment = Enum.TextYAlignment.Center,
					},
					Scope:Document {
						Name = "PageHost",
						Size = Theme.ObjectSize.FitToScale,
						FlexMode = Enum.UIFlexMode.Fill,
						
						[Children] = pageContents,
					}
				}
			},
			Scope:Hydrate(data.cabinet.Backdrop:Clone()) {
				Size = UDim2.new(1, 0, 1, 0)
			},
			Scope:New "UIPadding" {
				PaddingBottom = UDim.new(0, 4),
				PaddingLeft = UDim.new(0, 5),
				PaddingRight = UDim.new(0, 4),
				PaddingTop = UDim.new(0, 4),
			}
		},
	}
end