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
-- <<<<<<< HEAD
--             local r = math.random(10)
--             if r > 3 then
--                 r = 0
--             end
--             self.tiles[i][j] = r
--         end
--     end
--     for i=1,boardYSize+1 do
--         self.warfog[i] = {}
--         for j=1,boardXSize+1 do
--             self.warfog[i][j] = 0
--         end
--     end
-- end

-- function Board:generateEndPosition()
--     self.tiles[math.random(boardYSize+1)][boardXSize+1] = 6
-- end

-- function Board:generateEnemies(count)
--     -- while count > 0 do
--     --     for y,tab in ipairs(self.tiles) do
--     --         for x,value in ipairs(tab) do
--     --             if value == 0 then
--     --                 chance = math.random(10)
--     --                 if chance == 5 then
--     --                     table.insert(self.villainPositions,{x,y})
--     --                     count = count - 1
--     --                     break
--     --                 end
--     --             end
--     --         end
--     --     end
--     -- end
--     table.insert(self.villainPositions,{6,6})
--     table.insert(self.villainPositions,{10,3})
-- =======
            local randomType = choose_w({self.blankTile, self.blockTile},{80,20})
            table.insert(self.tiles, Tile:new(j, i, randomType, self:tile_image(randomType)))
        end
    end
-- >>>>>>> origin/master
end

function Board:update(player)
    if player.turnState == player.turnFinished and not self.villainMoved then
        self:villainMove(player)
    elseif player.turnState == self.turnDiceRolled then
        self.villainMoved = false
    end
    for i, p in ipairs(self.warfog) do
        for j, v in ipairs(p) do
            for _,char in ipairs(player.characters) do
                if tileDistance({char.x,char.y}, {j-1,i-1}) < 4 then
                    self.warfog[i][j] = 1
                end
            end
            for _,v in ipairs(self.villainPositions) do
                if tileDistance({v[1],v[2]}, {j,i}) < 2 then
                    self.warfog[i][j] = 1
                end
            end
        end
    end
end

<<<<<<< HEAD
function Board:villainMove(player)
    -- for i,pos in ipairs(self.villainPositions) do
    --     local dir = math.random(10)
    --     if (dir <= 5) then
    --         if (pos[1] < player.characters[player.currentChar].x) then
    --             self.villainPositions[i] = {pos[1]+1,pos[2]}
    --         elseif (pos[1] > player.characters[player.currentChar].x) then
    --             self.villainPositions[i] = {pos[1]-1,pos[2]}
    --         end
    --     else
    --         if (pos[2] < player.characters[player.currentChar].y) then
    --             self.villainPositions[i] = {pos[1],pos[2]+1}
    --         elseif (pos[2] > player.characters[player.currentChar].y) then
    --             self.villainPositions[i] = {pos[1],pos[2]-1}
    --         end
    --     end
    -- end
    -- self.villainMoved = true
    for i,pos in ipairs(self.villainPositions) do
        for j,char in ipairs(player.characters) do
            if tileDistance(pos,{char.x, char.y}) <= 4 then
                villainShoot()
            end
        end
    end
end

function tileInRange(playerPos,tile)
    if tile[1] > boardXSize
        or tile[2] > boardYSize
        -- or (tile[1] == playerPos[1] and tile[2] == playerPos[2])
        -- or not (self.tiles[tile] == 0 or self.tiles[tile] == 2)
        or tileDistance(playerPos,tile) > player.dice then
        return false
    else
        return true
    end
end

function tileDistance(t1, t2)
    return math.abs(t2[1]-t1[1])+math.abs(t2[2]-t1[2])
end

function Board:draw(playerPos)
    for y,tab in ipairs(self.tiles) do
        for x,value in ipairs(tab) do
            if self.warfog[y][x] == 1 then
                if value == 0 or value == 1 or value == 2 then
                    love.graphics.draw(self.imageNeutral, (x-1)*tilePixelSize, (y-1)*tilePixelSize) -- isoX({(x-1), (y-1)}), isoY({(x-1), (y-1)}) )
                --elseif value == 1 then 
                --    love.graphics.draw(self.imageDanger, (x-1)*tilePixelSize, (y-1)*tilePixelSize)

                elseif value == 6 then
                    love.graphics.draw(self.imageEnd, (x-1)*tilePixelSize, (y-1)*tilePixelSize)
                elseif value == 3 then
                    love.graphics.draw(self.imageBlock, (x-1)*tilePixelSize, (y-1)*tilePixelSize)  -- isoX({(x-1), (y-1)}), isoY({(x-1), (y-1)}) )
                end
            else
                love.graphics.draw(self.imageCloud, (x-1)*tilePixelSize, (y-1)*tilePixelSize)
            end
-- =======
function Board:draw(player, mouse)
    for i,tile in ipairs(self.tiles) do
        if tile_distance(player:current_position(), {tile.x-1,tile.y-1}) < 4 then
            tile.isWarfoged = false
-- >>>>>>> origin/master
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
-- <<<<<<< HEAD
-- =======

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
-- >>>>>>> origin/master
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