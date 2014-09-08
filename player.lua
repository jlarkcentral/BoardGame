Player = {}



-- Constructor
function Player:new()
	require "Ranger"
	require "Shield"
	require "Rogue"

    local object = {
    characters = {},
    currentChar = 1,
    turnState = "finished",
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
	if self.turnState == "diceRolled" then
		if self.dice > 0 then
			if not mouse.mousePressed then
				if love.mouse.isDown("l") and mouse.mouseOverIsInRange then
					self.characters[self.currentChar].x, self.characters[self.currentChar].y = mouse.mouseOverTile[1], mouse.mouseOverTile[2]
					self.dice = self.dice - 1
				end
				if love.mouse.isDown("r") then
					-- self:shoot()
					self.dice = self.dice - 1
				end
			end
		else
			self.turnState = "finished"
			self.currentChar = ( (self.currentChar + 1) % #(self.characters) )
			if self.currentChar == 0 then
				self.currentChar = #(self.characters)
			end
		end
	elseif self.turnState == "finished" then
		if love.keyboard.isDown(" ") then
			self.dice = math.random(6)
			self.turnState = "diceRolled"
		end
	end
	-- if self.shooting then
	-- 	self:moveBullet(dt)
	-- end
end

-- Draw player & player items
function Player:draw()
	for i,char in ipairs(self.characters) do
		love.graphics.draw(char.image, char.x*tilePixelSize, char.y*tilePixelSize)
		-- if self.shooting then
		-- 	love.graphics.draw(self.bulletImage, self.bullet_x, self.bullet_y)
		-- end
	end
end

-- Place player at game start
function Player:goToStartPosition(board)
	local positions = {}
	for i,char in ipairs(self.characters) do
		char.x = 0
		local ok = false
		while not ok do
			r = math.random(boardYSize)
			if board.tiles[1][r] == 0 then
				local contains = false
				for _,val in ipairs(positions) do
					if r == val then
						contains = true
					end
				end
				if not contains then
					char.y = r
					ok = true
				end
			end
		end
	end
	self.dice = 0
	self.turnState = "finished"
end

-- Shoot to target
function Player:shoot()
	self.target = { mouseOverTile[1]*tilePixelSize + tilePixelSize/2, mouseOverTile[2]*tilePixelSize + tilePixelSize/2 }
	self.bullet_x, self.bullet_y = self.x*tilePixelSize + tilePixelSize/2, self.y*tilePixelSize + tilePixelSize/2
	self.shooting = true
end

-- bullet movement
function Player:moveBullet(dt)
	if distanceFrom(self.bullet_x,self.bullet_y,self.target[1],self.target[2]) > 0 then
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

function Player:distanceFrom(x1,y1,x2,y2)
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function Player:tileInRange(tilePos)
	return self:distanceFrom(self.characters[self.currentChar].x,self.characters[self.currentChar].x,tilePos[1],tilePos[2]) <= self.dice
end