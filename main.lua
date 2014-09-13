function love.load()
	-- global declarations
	math.randomseed(os.time())
	love.mouse.setVisible(false)
	
	-- global params
	tilePixelSize = 50
	boardXSize = 15
	boardYSize = 9

	-- load all modules
	require "Player"
	require "Board"
	require "Mouse"

	-- objects initialization
	mouse = Mouse:new()

    player = Player:new()
    player:addRanger()
    player:addShield()
    player:addRogue()

    board = Board:new()
    board:initialize()
    board:generateEndPosition()
    board:generateEnemies(2)

    player:goToStartPosition(board)

    imageDice = love.graphics.newImage('img/game/dice.png')
    imageBgChar = love.graphics.newImage('img/game/blank.png')
end

function love.update(dt)
	stimeUpdate = os.clock()
	player:update(dt,mouse)
	if board.tiles[player.characters[player.currentChar].y+1][player.characters[player.currentChar].x+1] == 6 then
		restart()
	end
	board:update(player)
	mouse:update(player)
	etimeUpdate = os.clock()
end

function love.draw()
	board:draw({player.characters[player.currentChar].x,player.characters[player.currentChar].y})
	player:draw()
	board:drawDecoration({player.characters[player.currentChar].x,player.characters[player.currentChar].y})

	if player.dice > 0 then
		for i=1,player.dice do
			love.graphics.draw(imageDice, i*70+300, 520)
		end
	end
	mouse:draw()


	love.graphics.draw(imageBgChar, 0, 500, 0, 2)
	love.graphics.draw(player.characters[player.currentChar].image, 0, 500, 0, 2)

    -- INFO
    -- love.graphics.print(tostring("update time: "..(etimeUpdate - stimeUpdate)/100000), 200, 510)
    -- love.graphics.print(tostring("draw time: "..(etimeDraw - stimeDraw)/100000), 200, 520)
    -- love.graphics.print(tostring("mouseOverTile: "..mouseOverTile[1]..","..mouseOverTile[2]), 200, 510)
    -- love.graphics.print(tostring("mouseOverTile value : "..mouseOverTileValue), 200, 520)
    -- love.graphics.print(tostring("player: "..player.x..","..player.y), 200, 530)
    love.graphics.print(tostring("player currentChar: "..player.currentChar), 200, 530)
    -- love.graphics.print(tostring("villain: "..tostring(board.villainPositions[1][1])..","..tostring(board.villainPositions[1][2])), 200, 560)
    -- love.graphics.print(tostring("mouseOverIsInRange: "..tostring(mouseOverIsInRange)), 200, 540)
    -- love.graphics.print(tostring("DICE: "..tostring(player.dice)), 200, 550)

    -- love.graphics.print(tostring("turnState: "..player.turnState), 200, 580)
end



function restart()
    board:initialize()
    board:generateEndPosition()
    player:goToStartPosition(board)
end