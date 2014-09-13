Tile = {}

-- Constructor
function Tile:new(xpos,ypos,type,tileImage)
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
	love.graphics.draw(self.image, (self.x-1)*tilePixelSize, (self.y-1)*tilePixelSize)
	if self.isWarfoged then
		love.graphics.draw(self.imageWarfoged, (self.x-1)*tilePixelSize, (self.y-1)*tilePixelSize)
	end
end