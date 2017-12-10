Player = {}



-- Constructor
function Player:new()
    require "ranger"
    require "shield"
    require "rogue"

    local object = {
        characters = {},
        currentChar = 1,
        turnState = "",
        useItemMode = false,
        canUseItem = true,
        useItemDelay = 0,
        turnPoints = 0
    }
    setmetatable(object, { __index = Player })
    return object
end

-- Update movement
function Player:update(board)
    if self.turnPoints > 0 then
        if joystick:isDown(1) and self.released then
            if not board:get_tile(board.selectedTile[1], board.selectedTile[2]).isCharOn then
                local type = board:get_tile(board.selectedTile[1], board.selectedTile[2]).tileType
                if type == board.blankTile then
                    self:move(board)
                elseif type == board.blockTile then
                    self:push(board)
                end
            end
            self.released = false
            self.turnPoints = self.turnPoints - 1
        end
        if joystick:isDown(5) and self.released then
            self.currentChar = ((self.currentChar + 1) % #(self.characters))
            if self.currentChar == 0 then
                self.currentChar = #(self.characters)
            end
            self.released = false
            self.turnPoints = self.turnPoints - 1
        end
    end
    if self:current_char().heldItem == nil then
        self:check_items(board)
    end
    if not joystick:isDown(1, 2, 3, 4, 5, 6, 7) then
        self.released = true
    end
end

-- Draw player & player items
function Player:draw()
    for i, char in ipairs(self.characters) do
        char:draw()
    end
end

-------------------------------
-------------------------------
function Player:add_ranger()
    table.insert(self.characters, Ranger:new())
end

function Player:add_shield()
    table.insert(self.characters, Shield:new())
end

function Player:add_rogue()
    table.insert(self.characters, Rogue:new())
end

-- Place player at game start
function Player:go_to_start_position(board)
    local startTiles = choose_n(board.blankTiles, #self.characters)
    for i, char in ipairs(self.characters) do
        char.x = board.blankTiles[startTiles[i]].x
        char.y = board.blankTiles[startTiles[i]].y
        board.blankTiles[startTiles[i]].isCharOn = true
    end
end

function Player:tile_in_range(tilePos)
    return tile_distance(self:current_char():position(), tilePos) <= self.dice
end

function Player:current_char()
    return self.characters[self.currentChar]
end

function Player:finish_turn()
    self.turnState = self.turnFinished
    self.currentChar = ((self.currentChar + 1) % #(self.characters))
    if self.currentChar == 0 then
        self.currentChar = #(self.characters)
    end
end

function Player:move(board)
    board:get_tile(self:current_char().x, self:current_char().y).isCharOn = false
    self:current_char().x = board.selectedTile[1]
    self:current_char().y = board.selectedTile[2]
    board:get_tile(self:current_char().x, self:current_char().y).isCharOn = true
end

function Player:push(board)
    if self:current_char().x == board.selectedTile[1] then
        if self:current_char().y > board.selectedTile[2] then
            board:push_to_the_max_up()
        elseif self:current_char().y < board.selectedTile[2] then
            board:push_to_the_max_down()
        end
    elseif self:current_char().y == board.selectedTile[2] then
        if self:current_char().x > board.selectedTile[1] then
            board:push_to_the_max_left()
        elseif self:current_char().x < board.selectedTile[1] then
            board:push_to_the_max_right()
        end
    end
end

function Player:check_items(board)
    for i, item in ipairs(board.items) do
        if self:current_char().x == item.x and self:current_char().y == item.y then
            self:current_char().heldItem = item
            table.remove(board.items, i)
        end
    end
end

function get_blank_tiles_y(board)
    local btiles = {}
    for _, t in ipairs(board.tiles) do
        if t.x == 1 and t.tileType == board.blankTile then
            table.insert(btiles, t.y)
        end
    end
    return btiles
end