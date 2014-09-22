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
    dice = 0
    }
    setmetatable(object, { __index = Player })
    return object
end

-- Update movement
function Player:update(board, mouse)
	if self.turnState == self.turnDiceRolled then
		if self.dice > 0 then
			if not mouse.mousePressed then
				if left_click_on_blank_tile(board, mouse) then
					self:move_current_char(mouse)
				end
				if love.mouse.isDown("r") then
					self:do_right_click_action(mouse)
				end
			end
		else
			self:finish_turn()
		end
	elseif self.turnState == self.turnFinished then
		if love.keyboard.isDown(" ") then
			self:roll_dice()
		end
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
	table.insert(self.characters,Ranger:new())
end

function Player:add_shield()
	table.insert(self.characters,Shield:new())
end

function Player:add_rogue()
	table.insert(self.characters,Rogue:new())
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

function Player:do_right_click_action(mouse)
	if self:current_char().name == 'ranger' and mouse.mouseOverIsInRange then
		self:current_char():shoot(mouse.mouseOverTile)
		self.dice = self.dice - tile_distance(self:current_char():position(), mouse.mouseOverTile)
	elseif self:current_char().name == 'shield' then
		self:current_char():protect(self.dice)
		self.dice = 0
	end
end

function Player:move_current_char(mouse)
	self.dice = self.dice - tile_distance(self:current_char():position(), mouse.mouseOverTile)
	self:current_char().x, self:current_char().y = mouse.mouseOverTile[1], mouse.mouseOverTile[2]
end

function Player:finish_turn()
	self.turnState = self.turnFinished
	self.currentChar = ( (self.currentChar + 1) % #(self.characters) )
	if self.currentChar == 0 then
		self.currentChar = #(self.characters)
	end
end

function Player:roll_dice()
	local d = 0
	local r = math.random(100)
	if r >= 1 and r <= 5 then
		d = 1
	elseif r > 5 and r <= 20 then
		d = 2
	elseif r > 20 and r <= 50 then
		d = 3
	elseif r > 50 and r <= 80 then
		d = 4
	elseif r > 80 and r <= 95 then
		d = 5
	elseif r > 95 and r <= 100 then
		d = 6
	end
	self.dice = d
	self.turnState = self.turnDiceRolled
end

-------------------------------
-------------------------------


function left_click_on_blank_tile(board, mouse)
	return love.mouse.isDown("l")
		and mouse.mouseOverIsInRange
		and board:get_tile(mouse.mouseOverTile[1]+1, mouse.mouseOverTile[2]+1).tileType == board.blankTile
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