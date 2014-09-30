Player = {}



-- Constructor
function Player:new()
	require "ranger"
	require "shield"
	require "rogue"

    local object = {
	characters     = {},
	currentChar    = 1,
	turnState      = "",
	turnFinished   = "turnFinished",
	turnDiceRolled = "turnDiceRolled",
	dice           = 0,
	moved          = false,
	correctMatches = 0,
	keypressed     = '',
	changedChar    = false
    }
    setmetatable(object, { __index = Player })
    return object
end

-- Update movement
function Player:update(board, rhythmPanel)
	if key_pressed() == 'tab' and not self.changedChar then
		self.currentChar = (self.currentChar + 1) % #self.characters
		if self.currentChar == 0 then 
			self.currentChar = #self.characters 
		end
		self.changedChar = true
	elseif key_pressed() == ''
			or not (rhythmPanel.currentMove[2] >= 490 and rhythmPanel.currentMove[2] <= 510) then
		self.moved = false
		self.keypressed = ''
	elseif rhythmPanel.currentMove[1] == 'dir' and rhythmPanel.currentMove[2] >= 490 and rhythmPanel.currentMove[2] <= 510 then
		self:move(self.keypressed, board, rhythmPanel)
	end

	if (key_pressed() == 'tab') == false then
		self.changedChar = false
	end

	if board:get_tile(self:current_char().x+1, self:current_char().y+1).hasUpperLayer then
		self:current_char().isHidden = true
	else
		self:current_char().isHidden = false
	end
end

-- Draw player & player items
function Player:draw()
	for i,char in ipairs(self.characters) do
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
	local btiles = board:get_blank_tiles_y()
	for i,char in ipairs(self.characters) do
		char.x = 0
		local r = choose(btiles)
		char.y = r-1
		for i,v in ipairs(btiles) do
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

function Player:move(key, board, rhythmPanel)
	if not self.moved then
		local moves = self:possible_moves()
		if key == 'up' and contains(moves, 'up') then
			self:current_char().y = self:current_char().y - 1
			self:end_move(rhythmPanel)
		elseif key == 'down' and contains(moves, 'down') then
			self:current_char().y = self:current_char().y + 1
			self:end_move(rhythmPanel)
		elseif key == 'left' and contains(moves, 'left') then
			self:current_char().x = self:current_char().x - 1
			self:end_move(rhythmPanel)
		elseif key == 'right' and contains(moves, 'right') then
			self:current_char().x = self:current_char().x + 1
			self:end_move(rhythmPanel)
		end
	end
end

function Player:end_move(rhythmPanel)
	table.remove(rhythmPanel.moves, 1)
	self.correctMatches = self.correctMatches + 1
	self.moved = true
end

function Player:possible_moves()
	local moves = {}
	if is_on_board({self:current_char().x+1, self:current_char().y})
		and board:get_tile(self:current_char().x+1, self:current_char().y).tileType == board.blankTile then
		
		table.insert(moves, 'up')
	end	
	if is_on_board({self:current_char().x+1, self:current_char().y+2})
		and board:get_tile(self:current_char().x+1, self:current_char().y+2).tileType == board.blankTile then
		
		table.insert(moves, 'down')
	end	
	if is_on_board({self:current_char().x, self:current_char().y+1})
		and board:get_tile(self:current_char().x, self:current_char().y+1).tileType == board.blankTile then
	
		table.insert(moves, 'left')
	end	
	if is_on_board({self:current_char().x+2, self:current_char().y+1})
		and board:get_tile(self:current_char().x+2, self:current_char().y+1).tileType == board.blankTile then
		
		table.insert(moves, 'right')
	end
	return moves
end

-------------------------------
-------------------------------




function key_pressed()
	for _,k in ipairs({'up', 'down', 'left', 'right', 'tab'}) do
		if love.keyboard.isDown(k) then
			return k
		end
	end
	return ''
end