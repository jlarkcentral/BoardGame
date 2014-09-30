Tile = {}

-- Constructor
function Tile:new(xpos, ypos, type, tileImage)
    local object = {
    x               = xpos,
    y               = ypos,
    tileType        = type,
    isVillainOn     = false,
    isDangerTile    = false,
    isWarfoged      = true,
    isEndTile       = false,
    image           = tileImage,
    upperLayerImage = nil,
    hasUpperLayer   = false,
    }
    setmetatable(object, { __index = Tile })
    return object
end

function Tile:draw()
	draw_on_tile(self.image, {self.x-1, self.y-1} )
end

function Tile:draw_upper_layer()
    draw_on_tile(self.upperLayerImage, {self.x-1, self.y-1} )
end