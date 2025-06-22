local engine = shared.engine
--local Sector = require(script.Sector)

local TrackEditor = {}

function TrackEditor.newSession()
    engine:CancelAllTasks()

    --Sector.start()
end

return TrackEditor