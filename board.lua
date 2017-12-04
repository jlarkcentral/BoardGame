Board = {}

-- Constructor
function Board:new()
    require "tile"

    local object = {
    tiles = {},
    villainPositions = {},
    villainMoved = false,
    imageBlank       = love.graphics.newImage('img/board/blank.png'),
    imageNeutraloor  = love.graphics.newImage('img/board/tileNeutraloor.png'),
    imageDanger      = love.graphics.newImage('img/board/danger.png'),
    imageEnd         = love.graphics.newImage('img/board/end.png'),
    imageBlock       = love.graphics.newImage('img/board/block.png'),
    imageFrame       = love.graphics.newImage('img/board/frame.png'),
    imageVillain     = love.graphics.newImage('img/board/villain.png'),
    imageGrass       = love.graphics.newImage('img/board/grass.png'),
    imageGrass2      = love.graphics.newImage('img/board/grass2.png'),
    imageCloud       = love.graphics.newImage('img/board/cloud.png'),
    imageBorder      = love.graphics.newImage('img/board/border.png'),

    blankTile = "blankTile",
    blockTile = "blockTile",
    selectedTile = {1, 1},
    }
    setmetatable(object, { __index = Board })
    return object
end

function Board:initialize()
    for i=1,BOARD_Y_SIZE do
        for j=1,BOARD_X_SIZE do
            local randomType = choose({self.blankTile, self.blockTile}, {80,20})
            table.insert(self.tiles, Tile:new(j, i, randomType, self:tile_image(randomType)))
            self:get_tile(j, i).tileType = randomType
        end
    end
end

function Board:update(player)
    if not joystick:isDown(1) then
        self.selectedTile = player:current_char():position()
        local x = self.selectedTile[1]
        local y = self.selectedTile[2]
        if joystick:getAxis(1) < -0.5 then
            x = math.max(1, x - 1)
        elseif joystick:getAxis(1) > 0.5 then
            x = math.min(x + 1, BOARD_X_SIZE)
        end
        if joystick:getAxis(2) < -0.5 then
            y = math.max(1, y - 1)
        elseif joystick:getAxis(2) > 0.5 then
            y = math.min(y + 1, BOARD_Y_SIZE)
        end
        self.selectedTile = { x, y }
    end
end

function Board:draw(player)
    for i,tile in ipairs(self.tiles) do
        if tile_distance(player:current_char():position(), {tile.x, tile.y}) < 4 then
            tile.isWarfoged = false
        end
        tile:draw()
    end
    if self:get_tile(self.selectedTile[1], self.selectedTile[2]).tileType ~= self.blockTile then
        draw_on_tile(self.imageFrame, self.selectedTile[1], self.selectedTile[2])
    end
end

-----------------------------------
-----------------------------------

function Board:tile_image(tileType)
    if tileType == self.blankTile then
        return self.imageBlank
    elseif tileType == self.blockTile then
        return self.imageBlock
    end
end

function Board:get_tile(x, y)
    for _,t in ipairs(self.tiles) do
        if t.x == x and t.y == y then
            return t
        end
    end
end
