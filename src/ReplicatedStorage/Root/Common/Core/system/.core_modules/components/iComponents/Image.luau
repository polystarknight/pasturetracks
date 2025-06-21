local components = script.Parent.Parent
local core_modules = components.Parent
local util57 = core_modules.Parent["util-57"]

local Core = core_modules.Parent.Parent

local Util = require(util57.UI.FusionUtils)
local Fusion = require(core_modules.Fusion)
local New = Fusion.New
local Child = Fusion.Child
local Children = Fusion.Children
local InnerScope = Fusion.innerScope

local Themer = require(core_modules.themer)
local Base = require(script.Parent.Base)

local Components = {
	Base = Base,
}

--[=[
		@within Image
		@interface ImageProps

		@field ... BaseProps
		@field Image Fusion.UsedAs<string>?
		@field FallbackImage Fusion.UsedAs<string>?
		@field ImageColor3 Fusion.UsedAs<Color3>?
		@field ImageTransparency Fusion.UsedAs<number>?
		@field ImageRectOffset Fusion.UsedAs<Vector2>?
		@field ImageRectSize Fusion.UsedAs<Vector2>?
		@field ResampleMode Fusion.UsedAs<Enum.ResamplerMode>?
		@field ScaleType Fusion.UsedAs<Enum.ScaleType>?
		@field SliceCenter Fusion.UsedAs<Rect>?
		@field SliceScale Fusion.UsedAs<number>?
		@field TileSize Fusion.UsedAs<UDim2>?
]=]
return function(Scope: Fusion.Scope<any>, Props: Props)
	local Scope = InnerScope(Scope, Fusion, Util, Components)

	local FallbackImage = Util.Fallback(Props.FallbackImage, "rbxasset://textures/ui/GuiImagePlaceholder.png")
	local Image = Util.Fallback(Props.Image, nil)

	local ImageInUse = Scope:Computed(function(Use)
		if Use(Image) then
			return Use(Image)
		else
			return Use(FallbackImage)
		end
	end)

	return Scope:Hydrate(Scope:Base(Util.CombineProps(Props, {
		ClassName = "ImageLabel",
		Name = "Image",
		Size = UDim2.fromOffset(100, 100),
		AutomaticSize = Enum.AutomaticSize.None,
	}))) {
		Image = ImageInUse,
		ImageColor3 = Props.ImageColor3,
		ImageTransparency = Props.ImageTransparency,
		ImageRectOffset = Props.ImageRectOffset,
		ImageRectSize = Props.ImageRectSize,
		ResampleMode = Props.ResampleMode,
		ScaleType = Props.ScaleType,
		SliceCenter = Props.SliceCenter,
		SliceScale = Props.SliceScale,
		TileSize = Props.TileSize,
	}
end