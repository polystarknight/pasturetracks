local system = script.Parent
local core_modules = system[".core_modules"]

local index = {
	core_modules = core_modules,

	Fusion = require(core_modules.Fusion),
	Components = require(core_modules.components.context),
	-- ...
}

return table.freeze(index)