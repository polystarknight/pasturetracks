local engine = shared.engine

local CameraController = require(script.CameraController)
local Plot = require(script.Plot)
--local Sector = require(script.Sector)

local TrackEditor = {}

function TrackEditor.newSession()
    engine:CancelAllTasks()

    --Sector:start()
    CameraController:hook()
    Plot:create()
end

return TrackEditor