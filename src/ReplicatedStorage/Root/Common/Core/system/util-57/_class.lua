export type extends<T> = {
    new: () -> T,
    static: {[string]: any},
    __index: T,
    super: any?, 
}

local function class<T, S>(super: extends<S>?): extends<T & S>
	local obj = {}
	obj.__index = obj
	obj.__type = "Class"
	setmetatable(obj, super)

	function obj.new(...: any): T & S
		local instance = setmetatable({}, obj) :: T & S
		if instance.ctor then
			instance:ctor(...)
		end

		return instance
	end

	function obj:ExtendMetatable(metaTable)
		local mt = getmetatable(self) or {}
		for k, v in pairs(metaTable) do
			mt[k] = v
		end
		setmetatable(self, mt)
	end

	function obj.Static(methodName, method)
		rawset(obj, methodName, method)
	end

	return obj
end

return class

