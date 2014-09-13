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
					if self.characters[self.currentChar].name == 'ranger' then
						self.characters[self.currentChar]:shoot(mouse.mouseOverTile)
					elseif self.characters[self.currentChar].name == 'shield' then
						self.characters[self.currentChar]:protect(self.dice)
					-- add rogue
					end
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
			self.dice = rollDice()
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
		char:draw()
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
end

function distanceFrom(x1,y1,x2,y2)
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end