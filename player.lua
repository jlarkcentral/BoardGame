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

function Player:addRanger()
	table.insert(self.characters,Ranger:new())
end

function Player:addShield()
	table.insert(self.characters,Shield:new())
end

function Player:addRogue()
	table.insert(self.characters,Rogue:new())
end


-- Update movement
function Player:update(dt,mouse)
	if self.turnState == self.turnDiceRolled then
		if self.dice > 0 then
			if not mouse.mousePressed then
				if love.mouse.isDown("l") and mouse.mouseOverIsInRange then
					self.dice = self.dice - tile_distance(self:current_position(), mouse.mouseOverTile)
					self.characters[self.currentChar].x, self.characters[self.currentChar].y = mouse.mouseOverTile[1], mouse.mouseOverTile[2]
				end
				if love.mouse.isDown("r") then
-- <<<<<<< HEAD
					if self.characters[self.currentChar].name == 'ranger' then
						self.characters[self.currentChar]:shoot(mouse.mouseOverTile)
					elseif self.characters[self.currentChar].name == 'shield' then
						self.characters[self.currentChar]:protect(self.dice)
					-- add rogue
					end
-- =======
					-- self:shoot()
-- >>>>>>> origin/master
-- 					self.dice = self.dice - 1
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
			self.dice = rollDice()
			self.turnState = self.turnDiceRolled
		end
	end
	-- if self.shooting then
	-- 	self:moveBullet(dt)
	-- end
end

-- Draw player & player items
function Player:draw()
	for i,char in ipairs(self.characters) do
		char:draw()
	end
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

function rollDice()
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

-- Shoot to target
function Player:shoot()
	self.target = { mouseOverTile[1]*tilePixelSize + tilePixelSize/2, mouseOverTile[2]*tilePixelSize + tilePixelSize/2 }
	self.bullet_x, self.bullet_y = self.x*tilePixelSize + tilePixelSize/2, self.y*tilePixelSize + tilePixelSize/2
	self.shooting = true
end

-- bullet movement
function Player:moveBullet(dt)
	if tile_distance({self.bullet_x,self.bullet_y},self.target) > 0 then
		if self.bullet_x < self.target[1] then
			self.bullet_x = self.bullet_x + 5
		elseif self.bullet_x > self.target[1] then
			self.bullet_x = self.bullet_x - 5
		end
		if self.bullet_y < self.target[2] then
			self.bullet_y = self.bullet_y + 5
		elseif self.bullet_y > self.target[2] then
			self.bullet_y = self.bullet_y - 5
		end
	else
		self.shooting = false
	end
end

function Player:tileInRange(tilePos)
	return tile_distance(self:current_position(), tilePos) <= self.dice
end

function Player:current_position()
	return {self.characters[self.currentChar].x, self.characters[self.currentChar].y}
end