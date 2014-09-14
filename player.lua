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
function Player:update(dt,mouse)
	if self.turnState == self.turnDiceRolled then
		if self.dice > 0 then
			if not mouse.mousePressed then
				if love.mouse.isDown("l") and mouse.mouseOverIsInRange then
					self.dice = self.dice - tile_distance(self:current_char():position(), mouse.mouseOverTile)
					self:current_char().x, self:current_char().y = mouse.mouseOverTile[1], mouse.mouseOverTile[2]
				end
				if love.mouse.isDown("r") then
					if self:current_char().name == 'ranger' and mouse.mouseOverIsInRange then
						self:current_char():shoot(mouse.mouseOverTile)
						self.dice = self.dice - tile_distance(self:current_char():position(), mouse.mouseOverTile)
					elseif self:current_char().name == 'shield' then
						self:current_char():protect(self.dice)
						self.dice = 0
					-- add rogue
					end
				end
			end
		else
			self.turnState = self.turnFinished
			self.currentChar = ( (self.currentChar + 1) % #(self.characters) )
			if self.currentChar == 0 then
				self.currentChar = #(self.characters)
			end
		end
	elseif self.turnState == self.turnFinished then
		if love.keyboard.isDown(" ") then
			self.dice = roll_dice()
			self.turnState = self.turnDiceRolled
		end
	end
end

-- Draw player & player items
function Player:draw()
	for i,char in ipairs(self.characters) do
		char:draw()
	end
end

------------------------------------------------------------

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

function get_blank_tiles_y(board)
	local btiles = {}
	for _,t in ipairs(board.tiles) do
		if t.x == 1 and t.tileType == board.blankTile then
			table.insert(btiles, t.y)
		end
	end
	return btiles
end

function roll_dice()
	local r = math.random(100)
	if r >= 1 and r <= 5 then
		return 1
	elseif r > 5 and r <= 20 then
		return 2
	elseif r > 20 and r <= 50 then
		return 3
	elseif r > 50 and r <= 80 then
		return 4
	elseif r > 80 and r <= 95 then
		return 5
	elseif r > 95 and r <= 100 then
		return 6
	end
end

-- Shoot to target
-- function Player:shoot()
-- 	self.target = { (mouseOverTile[1] + 0.5)*TILE_PIXEL_SIZE, (mouseOverTile[2] + 0.5)*TILE_PIXEL_SIZE }
-- 	self.bullet_x, self.bullet_y = (self.x + 0.5)*TILE_PIXEL_SIZE, (self.y + 0.5)*TILE_PIXEL_SIZE
-- 	self.shooting = true
-- end

function Player:tile_in_range(tilePos)
	return tile_distance(self:current_char():position(), tilePos) <= self.dice
end

function Player:current_char()
	return self.characters[self.currentChar]
end