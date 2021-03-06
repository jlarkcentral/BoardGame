Board = {}

-- Constructor
function Board:new()
    require 'tile'
    require 'banana'
    require 'rock'

    local object = {
        tiles = {},
        items = {},
        blankTiles = {},
        blockTiles = {},
        noneTiles = {},
        villainPositions = {},
        villainMoved = false,
        imageFrame = love.graphics.newImage('img/board/frame.png'),
        blankTile = "blankTile",
        blockTile = "blockTile",
        noneTile = "noneTile",
        selectedTile = { 1, 1 },
    }
    setmetatable(object, { __index = Board })
    return object
end

function Board:initialize()
    for i = 1, BOARD_Y_SIZE do
        for j = 1, BOARD_X_SIZE do
            local tileType = choose({ self.blankTile, self.blockTile, self.noneTile }, { 80, 20, 0 })
            local newTile = Tile:new(j, i, tileType)
            table.insert(self.tiles, newTile)
            if tileType == self.blankTile then
                table.insert(self.blankTiles, newTile)
            elseif tileType == self.blockTile then
                table.insert(self.blockTiles, newTile)
            elseif tileType == self.noneTile then
                table.insert(self.noneTiles, newTile)
            end
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
    for i, tile in ipairs(self.tiles) do
        if tile_distance(player:current_char():position(), { tile.x, tile.y }) < 2 then
            tile.isWarfoged = false
        end
        tile:draw()
    end
    for i, item in ipairs(self.items) do
        item:draw()
    end
    if player.turn then
        draw_on_tile(self.imageFrame, self.selectedTile[1], self.selectedTile[2])
    end

end

-----------------------------------
-----------------------------------

function Board:get_tile(x, y)
    for _, t in ipairs(self.tiles) do
        if t.x == x and t.y == y then
            return t
        end
    end
end

function Board:add_item()
    local itemType = choose({ 'banana', 'rock' })
    local tileInd = math.random(#self.blankTiles)
    local tile = self.blankTiles[tileInd]
    if itemType == 'banana' then
        table.insert(self.items, Banana:new(tile.x, tile.y))
    elseif itemType == 'rock' then
        table.insert(self.items, Rock:new(tile.x, tile.y))
    end
    table.remove(self.blankTiles, tileInd)
end

function Board:push_to_the_max_up()
    for i=1, self.selectedTile[2] do
        if i == self.selectedTile[2]
                or self:get_tile(self.selectedTile[1], self.selectedTile[2] - i).tileType == self.blockTile
                or self:get_tile(self.selectedTile[1], self.selectedTile[2] - i).isCharOn then
            self:get_tile(self.selectedTile[1], self.selectedTile[2]).tileType = self.blankTile
            self:get_tile(self.selectedTile[1], self.selectedTile[2] - i + 1).tileType = self.blockTile
            return
        end
    end
end

function Board:push_to_the_max_down()
    for i=self.selectedTile[2], BOARD_Y_SIZE do
        if i == BOARD_Y_SIZE
                or self:get_tile(self.selectedTile[1], i + 1).tileType == self.blockTile
                or self:get_tile(self.selectedTile[1], i + 1).isCharOn then
            self:get_tile(self.selectedTile[1], self.selectedTile[2]).tileType = self.blankTile
            self:get_tile(self.selectedTile[1], i).tileType = self.blockTile
            return
        end
    end
end

function Board:push_to_the_max_left()
    for i=1, self.selectedTile[1] do
        if i == self.selectedTile[1]
                or self:get_tile(self.selectedTile[1] - i, self.selectedTile[2]).tileType == self.blockTile
                or self:get_tile(self.selectedTile[1] - i, self.selectedTile[2]).isCharOn then
            self:get_tile(self.selectedTile[1], self.selectedTile[2]).tileType = self.blankTile
            self:get_tile(self.selectedTile[1] - i + 1, self.selectedTile[2]).tileType = self.blockTile
            return
        end
    end
end

function Board:push_to_the_max_right()
    for i=self.selectedTile[1], BOARD_X_SIZE do
        if i == BOARD_X_SIZE
                or self:get_tile(i + 1, self.selectedTile[2]).tileType == self.blockTile
                or self:get_tile(i + 1, self.selectedTile[2]).isCharOn then
            self:get_tile(self.selectedTile[1], self.selectedTile[2]).tileType = self.blankTile
            self:get_tile(i, self.selectedTile[2]).tileType = self.blockTile
            return
        end
    end
end