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
    turnFinished = "turnFinished",
    turnDiceRolled = "turnDiceRolled",
    dice = 0,
    moved = false,
    correctMatches = 0,
    keypressed = ''
    }
    setmetatable(object, { __index = Player })
    return object
end

-- Update movement
function Player:update(board, rhythmPanel)
	if key_pressed() == '' 
		or not (rhythmPanel.currentMove[2] >= 490 and rhythmPanel.currentMove[2] <= 510) then
		self.moved = false
		self.keypressed = ''
	elseif self.keypressed == rhythmPanel.currentMove[1] and rhythmPanel.currentMove[2] >= 490 and rhythmPanel.currentMove[2] <= 510 then
		self:move(self.keypressed, board, rhythmPanel)
	else
		self.combo = 0
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
	local btiles = get_blank_tiles_y(board)
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

function Player:move_current_char(mouse)
	self.dice = self.dice - tile_distance(self:current_char():position(), mouse.mouseOverTile)
	self:current_char().x, self:current_char().y = mouse.mouseOverTile[1], mouse.mouseOverTile[2]
end

function Player:move(key, board, rhythmPanel)
	if not self.moved then
		if key == 'up' then
			if is_on_board({self:current_char().x+1, self:current_char().y})
				and board:get_tile(self:current_char().x+1, self:current_char().y).tileType == board.blankTile then
				
				self:current_char().y = self:current_char().y - 1
				table.remove(rhythmPanel.moves, 1)
				self.correctMatches = self.correctMatches + 1
			end
			self.moved = true
		elseif key == 'down' then
			if is_on_board({self:current_char().x+1, self:current_char().y+2})
				and board:get_tile(self:current_char().x+1, self:current_char().y+2).tileType == board.blankTile then
				
				self:current_char().y = self:current_char().y + 1
				table.remove(rhythmPanel.moves, 1)
				self.correctMatches = self.correctMatches + 1
			end
			self.moved = true
		elseif key == 'left' then
			if is_on_board({self:current_char().x, self:current_char().y+1})
				and board:get_tile(self:current_char().x, self:current_char().y+1).tileType == board.blankTile then
				
				self:current_char().x = self:current_char().x - 1
				table.remove(rhythmPanel.moves, 1)
				self.correctMatches = self.correctMatches + 1
			end
			self.moved = true
		elseif key == 'right' then
			if is_on_board({self:current_char().x+2, self:current_char().y+1})
				and board:get_tile(self:current_char().x+2, self:current_char().y+1).tileType == board.blankTile then
				
				self:current_char().x = self:current_char().x + 1
				table.remove(rhythmPanel.moves, 1)
				self.correctMatches = self.correctMatches + 1
			end
			self.moved = true
		end
	end
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


function get_blank_tiles_y(board)
	local btiles = {}
	for _,t in ipairs(board.tiles) do
		if t.x == 1 and t.tileType == board.blankTile then
			table.insert(btiles, t.y)
		end
	end
	return btiles
end

function key_pressed()
	for _,k in ipairs({'up', 'down', 'left', 'right'}) do
		if love.keyboard.isDown(k) then
			return k
		end
	end
	return ''
end