Board = {}

-- Constructor
function Board:new()
    local object = {
    tiles = {},
    warfog = {},
    villainPositions = {},
    villainMoved = false,
    imageNeutral = love.graphics.newImage('img/board/tileNeutral.png'),
    imageNeutraloor = love.graphics.newImage('img/board/tileNeutraloor.png'),
    imageDanger = love.graphics.newImage('img/board/tileDanger.png'),
    imageEnd = love.graphics.newImage('img/board/tileEnd.png'),
    imageBlock = love.graphics.newImage('img/board/tileBlock.png'),
    imageFrame = love.graphics.newImage('img/board/frame.png'),
    imageVillain = love.graphics.newImage('img/board/villain.png'),
    imageGrass = love.graphics.newImage('img/board/grass.png'),
    imageGrass2 = love.graphics.newImage('img/board/grass2.png'),
    imageCloud = love.graphics.newImage('img/board/cloud.png'),
    imageBorder = love.graphics.newImage('img/board/border.png'),
    imageUnreachable = love.graphics.newImage('img/board/unreachable.png'),
    }
    setmetatable(object, { __index = Board })
    return object
end

function Board:initialize()
    for i=1,boardYSize+1 do
        self.tiles[i] = {}
        for j=1,boardXSize+1 do
            local r = math.random(10)
            if r > 3 then
                r = 0
            end
            self.tiles[i][j] = r
        end
    end
    for i=1,boardYSize+1 do
        self.warfog[i] = {}
        for j=1,boardXSize+1 do
            self.warfog[i][j] = 0
        end
    end
end

function Board:generateEndPosition()
    self.tiles[math.random(boardYSize+1)][boardXSize+1] = 6
end

function Board:generateEnemies(count)
    while count > 0 do
        for y,tab in ipairs(self.tiles) do
            for x,value in ipairs(tab) do
                if value == 0 then
                    chance = math.random(10)
                    if chance == 5 then
                        table.insert(self.villainPositions,{x,y})
                        count = count - 1
                        break
                    end
                end
            end
        end
    end
end

function Board:update(player)
    if player.turnState == "finished" and not self.villainMoved then
        self:villainMove(player)
    elseif player.turnState == "diceRolled" then
        self.villainMoved = false
    end
end

function Board:villainMove(player)
    love.graphics.print("villain move", 100, 580)
    for i,pos in ipairs(self.villainPositions) do
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
    for i, p in ipairs(self.warfog) do
        for j, v in ipairs(p) do
            if tileDistance(playerPos, {j-1,i-1}) < 4 then
                self.warfog[i][j] = 1
            end
        end
    end

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
        end
    end

    for i, pos in ipairs(self.villainPositions) do
        local x, y = pos[1], pos[2]
        love.graphics.draw(self.imageVillain, (x-1)*tilePixelSize, (y-1)*tilePixelSize)
        -- conditions on enemy neibourghood
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

    if mouseOverIsInRange then
        love.graphics.draw(self.imageFrame, mouseOverTile[1]*tilePixelSize, mouseOverTile[2]*tilePixelSize)
    end
end

function isoX(point)
    return drawOffset + point[1]*tilePixelXSize - point[2]*tilePixelYSize
end

function isoY(point)
    return (point[1]*tilePixelXSize + point[2]*tilePixelYSize)/2
end

function Board:drawDecoration(playerPos)
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
            if not tileInRange(playerPos,{x-1,y-1}) then
                love.graphics.draw(self.imageUnreachable, (x-1)*tilePixelSize, (y-1)*tilePixelSize)
            end
        end
    end
end