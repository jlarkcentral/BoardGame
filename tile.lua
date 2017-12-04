Tile = {}

-- Constructor
function Tile:new(xpos, ypos, type, tileImage)
    local object = {
    x = xpos,
    y = ypos,
    tileType = type,
    isVillainOn = false,
    isDangerTile = false,
    isWarfoged = true,
    isEndTile = false,
    image = tileImage,
    imageWarfoged = love.graphics.newImage('img/board/warfoged.png'),
    }
    setmetatable(object, { __index = Tile })
    return object
end

function Tile:draw()
	draw_on_tile(self.image, (self.x), (self.y))
	if self.isWarfoged then
		draw_on_tile(self.imageWarfoged, (self.x), (self.y))
	end
end