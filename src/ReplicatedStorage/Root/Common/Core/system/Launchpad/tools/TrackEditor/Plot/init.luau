local plotContainer = Instance.new("Folder")
plotContainer.Name = "Plot"
plotContainer.Parent = workspace

local Settings = require("@self/Settings")
local BLOCK_SIZE = Settings.BLOCK_SIZE
local GRID_BOUNDS = Settings.GRID_BOUNDS
local CENTER_OFFSET = (GRID_BOUNDS.X * BLOCK_SIZE) / 2 - (BLOCK_SIZE / 2)

local function newPlot()
    for x = 1, GRID_BOUNDS.X do
        for z = 1, GRID_BOUNDS.Z do
            local block = Instance.new("Part")
            block.Anchored = true
            block.Size = Vector3.new(BLOCK_SIZE, 1, BLOCK_SIZE)
            block.Position = Vector3.new(
			    x * BLOCK_SIZE - CENTER_OFFSET,
			    0,
			    z * BLOCK_SIZE - CENTER_OFFSET
		    )
            block.Name = string.format("Block_%d_%d", x, z)
            block.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
            block.Parent = plotContainer
        end
    end
end

return {
    create = newPlot
}