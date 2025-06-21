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
local InnerScope = Fusion.innerScope

local Themer = require(core_modules.themer)
local colors = require(util57.color.tailwind)

local Document = require(script.Parent.Document)
local Image = require(script.Parent.Image)
local Text = require(script.Parent.Text)

local Components = {
	Document = Document,
	Image = Image,
}

return function(Scope: Fusion.Scope<any>, Props: Props): Instance
	local Scope = InnerScope(Scope, Fusion, Util, Components)
	local Theme = Themer.Theme:now()
	
    local MapCard = Scope:Document {
        Name = "MapCard",
        Size = Theme.ObjectSize.FitToScale,

        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5),
        --PaddingRight = UDim.new(0, 5),

        [Children] = {
            Scope:Text {
                Size = Theme.ObjectSize.FitToScale,

                Text = Props.Text,
                TextSize = 75,
                TextColor3 = colors.White,
                TextTransparency = Props.TextTransparency,
                TextStrokeTransparency = Props.TextStrokeTransparency,
                FontFace = Props.FontFace,

                TextXAlignment = "Left",
                TextYAlignment = "Top",
                ZIndex = 2,

                PaddingTop = UDim.new(0, 0),
                PaddingLeft = UDim.new(0, 14),
            },

            Scope:Image {
                Size = Theme.ObjectSize.FitToScale,
                Image = "rbxassetid://80167582759941",
                ScaleType = Enum.ScaleType.Crop,    

                CornerRadius = UDim.new(0, 20),

                [Children] = Scope:Hydrate(data.cabinet.CardGradient:Clone()) {  }
            }
        }
    }
	
	return MapCard
end