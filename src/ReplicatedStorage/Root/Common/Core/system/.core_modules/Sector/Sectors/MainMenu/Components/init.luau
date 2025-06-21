local Sector = script.Parent
local Pages = Sector.Pages

local MenuComponents = {
	Menu = require(script.Menu),
	TrackSelector = require(script.TrackSelector),
	MenuButton = require(script.MenuButton),
	HomePage = require(Pages.Home),
	PlaySolo = require(Pages.PlaySolo),
}

return MenuComponents
