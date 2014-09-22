Board = {}

-- Constructor
function Board:new()
    require "tile"

    local object = {
    tiles = {},
    villainPositions = {},
    villainDelay = 0,
    imageBlank       = love.graphics.newImage('img/board/blank.png'),
    imageEnd         = love.graphics.newImage('img/board/end.png'),
    imageBlock       = love.graphics.newImage('img/board/block.png'),
    imageFrame       = love.graphics.newImage('img/board/frame.png'),
    imageVillain     = love.graphics.newImage('img/board/villain.png'),
    imageGrass       = love.graphics.newImage('img/board/grass.png'),
    imageGrass2      = love.graphics.newImage('img/board/grass2.png'),

    blankTile = "blankTile",
    blockTile = "blockTile",

    }
    setmetatable(object, { __index = Board })
    return object
end

function Board:initialize()
    for i=1,BOARD_Y_SIZE+1 do
        for j=1,BOARD_X_SIZE+1 do
            local randomType = choose({self.blankTile, self.blockTile}, {80,20})
            table.insert(self.tiles, Tile:new(j, i, randomType, self:tile_image(randomType)))
            local t = self:get_tile(j, i)
            t.tileType = randomType
            if randomType == self.blankTile then
                local tileUpperLayerImage = choose({nil, self.imageGrass, self.imageGrass2}, {80,10,10})
                if (tileUpperLayerImage == nil) == false then
                    t.upperLayerImage = tileUpperLayerImage
                    t.hasUpperLayer = true
                end
            end
        end
    end
    self:generate_enemies(2)
end

function Board:update(player)
    if self.villainDelay == 300 and not player:current_char().isHidden then
        self:villain_move(player)
        self.villainDelay = 0
    end
    self.villainDelay = (self.villainDelay + 1) % 301
end

function Board:draw(player)
    for i,tile in ipairs(self.tiles) do
        if tile_distance(player:current_char():position(), {tile.x-1,tile.y-1}) < 6 then
            tile.isWarfoged = false
        end
        tile:draw()
    end
    for i, pos in ipairs(self.villainPositions) do
        local x, y = pos[1], pos[2]
        draw_on_tile(self.imageVillain, x-1, y-1)
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

function Board:generate_end_position()
    
end

function Board:generate_enemies(nbEnemies)
    for n=1,nbEnemies do
        local x = math.random(5,BOARD_X_SIZE)
        local y = math.random(1,BOARD_Y_SIZE)
        table.insert(self.villainPositions,{x,y})
        self:get_tile(x,y).tileType = self.blankTile
        self:get_tile(x,y).image = self.imageBlank
    end
end



function Board:villain_move(player)
    for i,pos in ipairs(self.villainPositions) do
        if (pos[1]-1 < player:current_char().x) then
                self.villainPositions[i] = {pos[1]+1,pos[2]}
        elseif (pos[1]-1 > player:current_char().x) then
                self.villainPositions[i] = {pos[1]-1,pos[2]}
        end
        if pos[1]-1 == player:current_char().x then
            if (pos[2]-1 < player:current_char().y) then
                self.villainPositions[i] = {pos[1],pos[2]+1}
            elseif (pos[2]-1 > player:current_char().y) then
                self.villainPositions[i] = {pos[1],pos[2]-1}
            end
            -- if pos[2]-1 == player:current_char().y then
            --     player.killed = true
            -- end
        end
        -- for j,char in ipairs(player.characters) do
        --     if tile_distance(pos,{char.x, char.y}) <= 4 then
        --         villain_shoot()
        --     end
        -- end
    end
end

function Board:draw_upper_layer()
    for _,t in ipairs(self.tiles) do
        if t.hasUpperLayer then
            t:draw_upper_layer()
        end
    end
end

function Board:get_tile(x, y)
    for _,t in ipairs(self.tiles) do
        if t.x == x and t.y == y then
            return t
        end
    end
end