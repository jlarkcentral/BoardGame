Mouse = {}

-- Constructor
function Mouse:new()
    local object = {
    mouseImage = love.graphics.newImage("img/game/mouse.png"),
    mouseOverTile = {1,1},
    mx = 0,
    my = 0,
    mouseOverIsInRange = false,
    mouseOverTileValue = 0,
    mousePressed = false
    }
    setmetatable(object, { __index = Mouse })
    return object
end

function Mouse:update(player)
    self.mx, self.my = love.mouse.getPosition()
    self.mouseOverTile = {(math.floor(self.mx/50)), (math.floor(self.my/50))}
    if self.mouseOverTile[1] <= boardXSize and self.mouseOverTile[2] <= boardYSize then
        self.mouseOverTileValue = board.tiles[self.mouseOverTile[2]+1][self.mouseOverTile[1]+1]
    end
    -- TEMP == out of map
    if self.mouseOverTile[1] > boardXSize
        or self.mouseOverTile[2] > boardYSize
        or (self.mouseOverTile[1] == player.characters[player.currentChar].x
            and self.mouseOverTile[2] == player.characters[player.currentChar].y
            )
        -- or not (self.mouseOverTileValue == 0 or self.mouseOverTileValue == 1 or self.mouseOverTileValue == 2 or self.mouseOverTileValue == 6)
        or not player:tileInRange(self.mouseOverTile) then
        -- self.mouseOverIsInRange = false
    else -- if (self.mouseOverTileValue == 0 or self.mouseOverTileValue == 1 or self.mouseOverTileValue == 2
        -- or self.mouseOverTileValue == 6) then
        self.mouseOverIsInRange = true
    end
    if love.mouse.isDown("l","r") then
        self.mousePressed = true
    else
        self.mousePressed = false
    end
end

function Mouse:draw()
    love.graphics.draw(self.mouseImage, self.mx, self.my)
end