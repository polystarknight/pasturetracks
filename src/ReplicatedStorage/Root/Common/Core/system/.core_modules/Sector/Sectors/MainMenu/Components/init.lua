local Sector = script.Parent
local Pages = Sector.Pages

local MenuComponents = {
	MenuButton = require(script.MenuButton),
	HomePage = require(Pages.Home),
	PlaySolo = require(Pages.PlaySolo),
}

return MenuComponents
