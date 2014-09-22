Mouse = {}

-- Constructor
function Mouse:new()
    local object = {
    mouseImage = love.graphics.newImage("img/game/mouse.png"),
    imageFrame = love.graphics.newImage("img/board/frame.png"),
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
    self.mouseOverTile = {(math.floor(self.mx/TILE_PIXEL_SIZE)), (math.floor(self.my/TILE_PIXEL_SIZE))}
    if self.mouseOverTile[1] <= BOARD_X_SIZE and self.mouseOverTile[2] <= BOARD_Y_SIZE then
        self.mouseOverTileValue = board.tiles[self.mouseOverTile[2]+1][self.mouseOverTile[1]+1]
    end
    -- TEMP == out of map
    if self.mouseOverTile[1] > BOARD_X_SIZE
        or self.mouseOverTile[2] > BOARD_Y_SIZE
        or (self.mouseOverTile[1] == player:current_char().x and self.mouseOverTile[2] == player:current_char().y)
        or not player:tile_in_range(self.mouseOverTile) then
            self.mouseOverIsInRange = false
    else
        self.mouseOverIsInRange = true
    end
    if love.mouse.isDown("l","r") then
        self.mousePressed = true
    else
        self.mousePressed = false
    end
end

function Mouse:draw()
    if self.mouseOverIsInRange then
        draw_on_tile(self.imageFrame, self.mouseOverTile[1], self.mouseOverTile[2])
    end
    love.graphics.draw(self.mouseImage, self.mx, self.my)
end