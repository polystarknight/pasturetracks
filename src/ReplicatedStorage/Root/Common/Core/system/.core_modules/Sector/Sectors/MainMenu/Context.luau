local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Root = ReplicatedStorage:FindFirstChild("Root")
local Common = Root.Common
local Core = Common.Core
local system = Core.system

local core_modules = system[".core_modules"]
local Fusion = require(core_modules.Fusion)

local Scope = Fusion.scoped(Fusion)

return {
    menuIsPeeking = Scope:Value(false),
    mapSelectorIsPeeking = Scope:Value(false), 
}