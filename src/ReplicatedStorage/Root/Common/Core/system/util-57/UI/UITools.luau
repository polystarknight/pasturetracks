local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local Player = game:GetService("Players")
local user = game.Players.LocalPlayer

local Camera = workspace.CurrentCamera
local ViewportSize = Camera.ViewportSize
local BasePlayerGui: BasePlayerGui = user.PlayerGui

local UITools = {}
UITools.__index = UITools

function UITools:GetRawElementSize(element, specialProperty)
	if element ~= nil then
		if element:IsA("ScreenGui") == true then
			return Vector2.new(ViewportSize.X, ViewportSize.Y)

		elseif element:IsA("GuiBase2d") == true then
			return element[specialProperty or "AbsoluteSize"]
		end
	end

	return Vector2.new(0, 0)
end
function UITools:GetTrueElementSize(element, specialProperty)
	local uiPadding = element:FindFirstChildOfClass("UIPadding")
	local elementSize = UITools:GetRawElementSize(element, specialProperty)

	if uiPadding ~= nil then
		return math.abs(elementSize.X - (uiPadding.PaddingLeft.Scale * elementSize.X + uiPadding.PaddingLeft.Offset) - (uiPadding.PaddingRight.Scale * elementSize.X + uiPadding.PaddingRight.Offset)), math.abs(elementSize.Y - (uiPadding.PaddingTop.Scale * elementSize.Y + uiPadding.PaddingTop.Offset) - (uiPadding.PaddingBottom.Scale * elementSize.Y + uiPadding.PaddingBottom.Offset))
	else
		return elementSize.X, elementSize.Y
	end
end

function UITools:GetTrueElementPosition(element, specialPositionProperty, specialSizeProperty)
	local elementParent = element.Parent
	if elementParent ~= nil then
		local epPadding = elementParent:FindFirstChildOfClass("UIPadding")
		local elementPosition = element[specialPositionProperty or "AbsolutePosition"]
		if epPadding ~= nil then
			local epSize = UITools:GetRawElementSize(elementParent, specialSizeProperty)
			local paddingTopSize = epPadding.PaddingTop.Scale * epSize.Y + epPadding.PaddingTop.Offset
			local paddingBottomSize = epPadding.PaddingBottom.Scale * epSize.Y + epPadding.PaddingBottom.Offset
			local paddingLeftSize = epPadding.PaddingLeft.Scale * epSize.X + epPadding.PaddingLeft.Offset
			local paddingRightSize = epPadding.PaddingRight.Scale * epSize.X + epPadding.PaddingRight.Offset

			return elementPosition.X - paddingLeftSize - math.min(epSize.X - paddingLeftSize - (epPadding.PaddingRight.Scale * epSize.X + epPadding.PaddingRight.Offset), 0), elementPosition.Y - paddingTopSize - math.min(epSize.Y - paddingTopSize - (epPadding.PaddingBottom.Scale * epSize.Y + epPadding.PaddingBottom.Offset), 0)
		else
			return elementPosition.X, elementPosition.Y
		end
	else
		return 0, 0
	end
end

function UITools:isHovering(input: GuiObject, applyInset: boolean)
	local currentMouse = UserInputService:GetMouseLocation()
	if applyInset == true then
		currentMouse -= GuiService:GetGuiInset()
	end

	local Guis = BasePlayerGui:GetGuiObjectsAtPosition(currentMouse.X, currentMouse.Y)
	for _, _ui in ipairs(Guis) do
		if _ui == input then
			return true
		end
	end
	return false
end

function UITools:GetGuiLocation(applyInset: boolean)
	local currentMouse = UserInputService:GetMouseLocation()
	if applyInset == true then
		currentMouse -= GuiService:GetGuiInset()
	end

	local Guis = BasePlayerGui:GetGuiObjectsAtPosition(currentMouse.X, currentMouse.Y)
	
	for _, _ui in ipairs(Guis) do
		return _ui :: GuiObject
	end
end

function UITools:ConvertOffsetToScale(input: UDim2)
	return UDim2.new(
		input.X.Offset / ViewportSize.X,
		0,
		input.Y.Offset / ViewportSize.Y,
		0
	)
end

function UITools:ConvertScaleToOffset(input: UDim2)
	return UDim2.new(
		0,
		math.round(input.X.Scale * ViewportSize.X),
		0,
		math.round(input.Y.Scale * ViewportSize.Y)
	)
end

function UITools.SetAnchorPoint(input: GuiObject, targetAnchorPoint: Vector2, preservePosition: boolean)
	if preservePosition == true then
		local epAbsX, epAbsY

		if input.Parent:IsA("ScrollingFrame") == true then
			epAbsX, epAbsY = UITools:GetTrueElementSize(input.Parent, "AbsoluteCanvasSize")
		else
			epAbsX, epAbsY = UITools:GetTrueElementSize(input.Parent)
		end

		local displayPosition = input.Position
		local anchorPoint = input.AnchorPoint
		local objectSize = input.AbsoluteSize

		local pxs = displayPosition.X.Scale
		local pxo = displayPosition.X.Offset
		local pys = displayPosition.Y.Scale
		local pyo = displayPosition.Y.Offset
		if displayPosition.X.Offset ~= 0 or displayPosition.X.Scale == 0 then
			pxo += (targetAnchorPoint.X - anchorPoint.X) * objectSize.X
		else
			pxs += (targetAnchorPoint.X - anchorPoint.X) * objectSize.X / epAbsX
		end
		if displayPosition.Y.Offset ~= 0 or displayPosition.Y.Scale == 0 then
			pyo += (targetAnchorPoint.Y - anchorPoint.Y) * objectSize.Y
		else
			pys += (targetAnchorPoint.Y - anchorPoint.Y) * objectSize.Y / epAbsY
		end
		input.Position = UDim2.new(
			pxs,
			pxo,
			pys,
			pyo
		)
	elseif preservePosition == false then
		input.Position = UDim2.fromScale(
			input.X,
			input.Y
		)
	end
	
	input.AnchorPoint = targetAnchorPoint
end

return UITools
