print("using Engine")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local user = Players.LocalPlayer

local Root = ReplicatedStorage:FindFirstChild("Root")
local Common = Root.Common
local Core = Common.Core
local system = Core.system
local data = Core.data

local events = data[".events"]
local core_modules = system[".core_modules"]
local util57 = system["util-57"]
local Components = core_modules.components

local class = require(util57._class)

export type EngineFramework = {

}

local Engine = class() :: class.extends<EngineFramework>

function Engine:ctor()

end

function Engine._bindToEvents(self)

end

function Engine:CancelAllTasks()
    warn("[Engine]: CANCELLING tasks")
    shared.ui.Stop()
end

return Engine.new()
