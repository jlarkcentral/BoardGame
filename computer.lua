Computer = {}



-- Constructor
function Computer:new()
    require "ranger"
    require "shield"
    require "rogue"

    local object = {
        characters = {},
        currentChar = 1,
        turnState = "",
        turnPoints = 0,
        path = {},
        delay = 10
    }
    setmetatable(object, { __index = Computer })
    return object
end

-- Update movement
function Computer:update(board, player)
    if self.turnPoints > 0 then
        if self.delay == 0 then
            --local shortestPath = self:shortest_path_to_player(board, player)
            self:move_to_player(board, player)
            self.delay = math.random(10, 20)
        else
            self.delay = self.delay - 1
        end
    end
end

-- Draw player & player items
function Computer:draw()
    for i, char in ipairs(self.characters) do
        char:draw()
    end
end

-------------------------------
-------------------------------
function Computer:add_ranger()
    table.insert(self.characters, Ranger:new())
end

function Computer:add_shield()
    table.insert(self.characters, Shield:new())
end

function Computer:add_rogue()
    table.insert(self.characters, Rogue:new())
end

-- Place player at game start
function Computer:go_to_start_position(board)
    local btiles = get_blank_tiles_y(board, BOARD_X_SIZE - 1)
    for i, char in ipairs(self.characters) do
        char.x = BOARD_X_SIZE - 1
        local r = choose(btiles)
        char.y = r
        for i, v in ipairs(btiles) do
            if v == r then
                table.remove(btiles, i)
            end
        end
        board:get_tile(char.x, char.y).isCharOn = true
    end
    self.dice = 0
    self.turnState = self.turnFinished
end

function Computer:tile_in_range(tilePos)
    return tile_distance(self:current_char():position(), tilePos) <= self.dice
end

function Computer:current_char()
    return self.characters[self.currentChar]
end

function Computer:finish_turn()
    self.turnState = self.turnFinished
    self.currentChar = ((self.currentChar + 1) % #(self.characters))
    if self.currentChar == 0 then
        self.currentChar = #(self.characters)
    end
end


function get_blank_tiles_y(board, col)
    local btiles = {}
    for _, t in ipairs(board.tiles) do
        if t.x == col and t.tileType == board.blankTile then
            table.insert(btiles, t.y)
        end
    end
    return btiles
end

function Computer:shortest_path_to_player(board, player)
    local shortPath
    for i, char in player.characters do
        local path = self:shortest_path(board, { self.x, self.y }, char:position())
        if shortPath == nil or #shortPath > #path then
            shortPath = path
        end
    end
end

function Computer:shortest_path(board, start, finish)
end

function Computer:move_to_player(board, player)
    local xdiff = self:current_char().x - player:current_char():position()[1]
    local ydiff = self:current_char().y - player:current_char():position()[2]
    if xdiff == 0 then
        if ydiff == 0 then
            print("Ha-ha !")
        elseif ydiff > 0 then
            self:current_char().y = self:current_char().y - 1
        else
            self:current_char().y = self:current_char().y + 1
        end
    elseif ydiff == 0 then
        if xdiff > 0 then
            self:current_char().x = self:current_char().x - 1
        else
            self:current_char().x = self:current_char().x + 1
        end
    else
        if ydiff > 0 then
            self:current_char().y = self:current_char().y - 1
        elseif ydiff < 0 then
            self:current_char().y = self:current_char().y + 1
        end
        if xdiff > 0 then
            self:current_char().x = self:current_char().x - 1
        elseif xdiff < 0 then
            self:current_char().x = self:current_char().x + 1
        end
    end
    self.turnPoints = self.turnPoints - 1
end