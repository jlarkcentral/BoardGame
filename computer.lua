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
    }
    setmetatable(object, { __index = Computer })
    return object
end

-- Update movement
function Computer:update(board)

end

-- Draw player & player items
function Computer:draw()
	for i,char in ipairs(self.characters) do
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
	local btiles = get_blank_tiles_y(board)
	for i,char in ipairs(self.characters) do
		char.x = BOARD_X_SIZE
		local r = choose(btiles)
		char.y = r
		for i,v in ipairs(btiles) do
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
	self.currentChar = ( (self.currentChar + 1) % #(self.characters) )
	if self.currentChar == 0 then
		self.currentChar = #(self.characters)
	end
end


function get_blank_tiles_y(board)
	local btiles = {}
	for _,t in ipairs(board.tiles) do
		if t.x == 1 and t.tileType == board.blankTile then
			table.insert(btiles, t.y)
		end
	end
	return btiles
end