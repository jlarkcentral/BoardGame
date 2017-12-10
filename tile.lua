Tile = {}

-- Constructor
function Tile:new(xpos, ypos, type)
    local object = {
        x = xpos,
        y = ypos,
        tileType = type,
        color = nil,
        isCharOn = false,
        isVillainOn = false,
        isDangerTile = false,
        isWarfoged = true,
        moving = false,
        destination = nil,
        imageWarfoged = love.graphics.newImage('img/board/warfoged.png'),
        imageBlank = love.graphics.newImage('img/board/blank.png'),
        imageBlock = love.graphics.newImage('img/board/block.png'),
        imageBlue = love.graphics.newImage('img/board/blue.png'),
        imageRed = love.graphics.newImage('img/board/red.png'),
    }
    setmetatable(object, { __index = Tile })
    return object
end

function Tile:draw()
    if self.tileType == "blankTile" then
        draw_on_tile(self.imageBlank, (self.x), (self.y))
    elseif self.tileType == "blockTile" then
        draw_on_tile(self.imageBlock, (self.x), (self.y))
    end
    if self.color == 'blue' then
        draw_on_tile(self.imageBlue, (self.x), (self.y))
    elseif self.color == 'red' then
        draw_on_tile(self.imageRed, (self.x), (self.y))
    end
    --if self.isWarfoged then
    --    draw_on_tile(self.imageWarfoged, (self.x), (self.y))
    --end
end
