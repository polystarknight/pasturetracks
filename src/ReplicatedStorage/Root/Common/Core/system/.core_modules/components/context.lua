local module = script.Parent

local components = {
	Services = module.services,
	iComponents = require(module.iComponents.context),
	-- ...
}

return components