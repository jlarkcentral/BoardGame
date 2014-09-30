Board = {}

-- Constructor
function Board:new()
    require "tile"
    require "enemy"

    local object = {
    tiles = {},
    enemies = {},
    imageBlank       = love.graphics.newImage('img/board/blank.png'),
    imageEnd         = love.graphics.newImage('img/board/end.png'),
    imageBlock       = love.graphics.newImage('img/board/block.png'),
    imageFrame       = love.graphics.newImage('img/board/frame.png'),
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
            local randomType = choose({self.blankTile, self.blockTile}, {90,10})
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
    for _,e in ipairs(self.enemies) do
        e:update(player)
    end
end

function Board:draw()
    for i,tile in ipairs(self.tiles) do
        tile:draw()
    end
    for _,e in ipairs(self.enemies) do
        e:draw()
    end
end

--------------------------------
--------------------------------

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
        local x = math.random(5, BOARD_X_SIZE)
        local y = math.random(1, BOARD_Y_SIZE)
        table.insert(self.enemies, Enemy:new(x, y))
        self:get_tile(x,y).tileType = self.blankTile
        self:get_tile(x,y).image = self.imageBlank
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

function Board:get_blank_tiles_y()
    local btiles = {}
    for _,t in ipairs(self.tiles) do
        if t.x == 1 and t.tileType == self.blankTile then
            table.insert(btiles, t.y)
        end
    end
    return btiles
end