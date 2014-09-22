function love.load()
	-- global declarations
	math.randomseed(os.time())
	love.mouse.setVisible(false)

	-- load all modules
	require "player"
	require "board"
	require "mouse"
	require "utils"

	-- initialization
	imageDice = love.graphics.newImage('img/game/dice.png')
    imageBgChar = love.graphics.newImage('img/game/blank.png')

	mouse = Mouse:new()

    player = Player:new()
    player:add_ranger()
    player:add_shield()
    -- player:add_rogue()

    board = Board:new()
    board:initialize()

    restart()
end

function love.update(dt)
	player:update(board, mouse)
	board:update(player)
	mouse:update(player)
end

function love.draw()
	board:draw(player, mouse)
	player:draw()
	-- board:drawDecoration(player)
	mouse:draw()

	for i=1,player.dice do
		love.graphics.draw(imageDice, i*70+300, 520)
	end
	love.graphics.draw(imageBgChar, 0, 500, 0, 2)
	love.graphics.draw(player:current_char().image, 0, 500, 0, 2)



    -- INFO

    -- love.graphics.print(tostring("update time: "..(etimeUpdate - stimeUpdate)/100000), 200, 510)
    -- love.graphics.print(tostring("draw time: "..(etimeDraw - stimeDraw)/100000), 200, 520)
    love.graphics.print(tostring("mouseOverTile: "..mouse.mouseOverTile[1]..","..mouse.mouseOverTile[2]), 200, 510)
    -- love.graphics.print(tostring("mouseOverTile value : "..mouseOverTileValue), 200, 520)
    love.graphics.print(tostring("player: "..player:current_char().x..","..player:current_char().y), 200, 520)
    love.graphics.print(tostring("player currentChar: "..player.currentChar), 200, 530)
    -- love.graphics.print(tostring("villain: "..tostring(board.villainPositions[1][1])..","..tostring(board.villainPositions[1][2])), 200, 560)
    love.graphics.print(tostring("distance: "..tostring(tile_distance(player:current_char():position(),mouse.mouseOverTile))), 200, 560)
    love.graphics.print(tostring("mouseOverIsInRange: "..tostring(mouse.mouseOverIsInRange)), 200, 540)
    love.graphics.print(tostring("tile type: "..board:get_tile(mouse.mouseOverTile[1]+1, mouse.mouseOverTile[2]+1).tileType), 200, 550)
    love.graphics.print(tostring(board:get_tile(mouse.mouseOverTile[1]+1, mouse.mouseOverTile[2]+1).x..", "..
    	board:get_tile(mouse.mouseOverTile[1]+1, mouse.mouseOverTile[2]+1).y), 350, 550)

end

function restart()
    board:initialize()
    board:generate_end_position()
    player:go_to_start_position(board)
end