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
    }
    setmetatable(object, { __index = Player })
    return object
end

-- Update movement
function Player:update(board)
    if joystick:isDown(1) then
        if board:get_tile(board.selectedTile[1], board.selectedTile[2]).tileType ~= board.blockTile then
            self:current_char().x = board.selectedTile[1]
            self:current_char().y = board.selectedTile[2]
        end
    end
    if self:current_char().heldItem == nil then
        for i, item in ipairs(board.items) do
            if self:current_char().x == item.x and self:current_char().y == item.y then
                self:current_char().heldItem = item
                table.remove(board.items, i)
            end
        end
    else
        if joystick:isDown(2) then
            print('dfsf')
        end
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
    local btiles = get_blank_tiles_y(board)
    for i, char in ipairs(self.characters) do
        char.x = 1
        local r = choose(btiles)
        char.y = r
        for i, v in ipairs(btiles) do
            if v == r then
                table.remove(btiles, i)
            end
        end
    end
    self.dice = 0
    self.turnState = self.turnFinished
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


function get_blank_tiles_y(board)
    local btiles = {}
    for _, t in ipairs(board.tiles) do
        if t.x == 1 and t.tileType == board.blankTile then
            table.insert(btiles, t.y)
        end
    end
    return btiles
end