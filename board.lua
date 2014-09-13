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

    }
    setmetatable(object, { __index = Board })
    return object
end

function Board:initialize()
    for i=1,boardYSize+1 do
        for j=1,boardXSize+1 do
            local randomType = choose_w({self.blankTile, self.blockTile},{80,20})
            table.insert(self.tiles, Tile:new(j, i, randomType, self:tile_image(randomType)))
        end
    end
end

function Board:update(player)
    if player.turnState == player.turnFinished and not self.villainMoved then
        self:villainMove(player)
    elseif player.turnState == self.turnDiceRolled then
        self.villainMoved = false
    end
end

function Board:draw(player, mouse)
    for i,tile in ipairs(self.tiles) do
        if tile_distance(player:current_position(), {tile.x-1,tile.y-1}) < 4 then
            tile.isWarfoged = false
        end
        tile:draw()
    end

    for i, pos in ipairs(self.villainPositions) do
        local x, y = pos[1], pos[2]
        love.graphics.draw(self.imageVillain, (x-1)*tilePixelSize, (y-1)*tilePixelSize)
    --     -- conditions on enemy neibourghood
        if x < boardXSize then
            love.graphics.draw(self.imageDanger, (x)*tilePixelSize, (y-1)*tilePixelSize)
        end
        if x > 1 then
            love.graphics.draw(self.imageDanger, (x-2)*tilePixelSize, (y-1)*tilePixelSize)
        end
        if y < boardYSize then
            love.graphics.draw(self.imageDanger, (x-1)*tilePixelSize, (y)*tilePixelSize)
        end
        if y > 1 then
            love.graphics.draw(self.imageDanger, (x-1)*tilePixelSize, (y-2)*tilePixelSize)
        end
    end

    if mouse.mouseOverIsInRange then
        love.graphics.draw(self.imageFrame, mouse.mouseOverTile[1]*tilePixelSize, mouse.mouseOverTile[2]*tilePixelSize)
    end
end

-- other functions

function Board:tile_image(tileType)
    if tileType == self.blankTile then
        return self.imageBlank
    elseif tileType == self.blockTile then
        return self.imageBlock
    end
end

function Board:generateEndPosition()
    
end

function Board:generate_enemies(nbEnemies)
    for n=1,nbEnemies do
        local x = math.random(5,boardXSize)
        local y = math.random(1,boardYSize)
        table.insert(self.villainPositions,{x,y})
        self:get_tile(x,y).tileType = self.blankTile
        self:get_tile(x,y).image = self.imageBlank
    end
end



function Board:villainMove(player)
    love.graphics.print("villain move", 100, 580)
    for i,pos in ipairs(self.villainPositions) do
        -- TODO redo random movement
        local dir = math.random(10)
        if (dir <= 5) then
            if (pos[1] < player.characters[player.currentChar].x) then
                self.villainPositions[i] = {pos[1]+1,pos[2]}
            elseif (pos[1] > player.characters[player.currentChar].x) then
                self.villainPositions[i] = {pos[1]-1,pos[2]}
            end
        else
            if (pos[2] < player.characters[player.currentChar].y) then
                self.villainPositions[i] = {pos[1],pos[2]+1}
            elseif (pos[2] > player.characters[player.currentChar].y) then
                self.villainPositions[i] = {pos[1],pos[2]-1}
            end
        end
    end
    self.villainMoved = true
end

function Board:drawDecoration(player)
    love.graphics.draw(self.imageBorder, 0, 0)
    for y,tab in ipairs(self.tiles) do
        for x,value in ipairs(tab) do
            if self.warfog[y][x] == 1 then
                if value == 1 then
                    love.graphics.draw(self.imageGrass, (x-1)*tilePixelSize, (y-1)*tilePixelSize)
                elseif value == 2 then
                    love.graphics.draw(self.imageGrass2, (x-1)*tilePixelSize, (y-1)*tilePixelSize)
                end
            elseif self.warfog[y][x] == 0 then
                love.graphics.draw(self.imageCloud, (x-1)*tilePixelSize, (y-1)*tilePixelSize)
            end
            if not player:tileInRange({x-1,y-1}) then
                love.graphics.draw(self.imageUnreachable, (x-1)*tilePixelSize, (y-1)*tilePixelSize)
            end
        end
    end
end

function Board:get_tile(x, y)
    for _,t in ipairs(self.tiles) do
        if t.x == x then
            if t.y == y then
                return t
            end
        end
    end
end