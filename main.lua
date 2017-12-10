function love.load()
	-- global declarations
	math.randomseed(os.time())
	--love.mouse.setVisible(false)
    love.window.setMode( 1024, 768 )

	-- load all modules
	require "player"
	require "computer"
	require "board"
	require "utils"

	-- initialization

    local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]

    player = Player:new()
    player:add_ranger()
    player:add_ranger()
    player.turn = true
    player.turnPoints = 5

    computer = Computer:new()
    computer:add_rogue()

    board = Board:new()

    restart()
end

function restart()
    board:initialize()
    --board:add_item()
    player:go_to_start_position(board)
    computer:go_to_start_position(board)
end

function love.update(dt)
	player:update(board)
    computer:update(board, player)
	board:update(player)
    if love.keyboard.isDown("escape") then
        restart()
    end
    if player.turn and player.turnPoints == 0 then
        computer.turnPoints = 5
        computer.turn = true
        player.turn = false
    elseif computer.turn and computer.turnPoints == 0 then
        player.turnPoints = 5
        computer.turn = false
        player.turn = true
    end
end

function love.draw()
	board:draw(player)
	player:draw()
    computer:draw()
	-- board:drawDecoration(player)

	love.graphics.draw(player:current_char().image, 0, 650, 0, 2)
    if player:current_char().heldItem ~= nil then
	    love.graphics.draw(player:current_char().heldItem.image, 100, 650, 0, 2)
    end

    -- INFO
    love.graphics.print(tostring("player: "..player:current_char().x..","..player:current_char().y), 200, 670)
    love.graphics.print(tostring("player currentChar: "..player.currentChar), 200, 680)
    love.graphics.print(tostring("selected tile: "..board.selectedTile[1] .. "," .. board.selectedTile[2]), 200, 690)
    love.graphics.print(tostring("selected tile type: "..board:get_tile(board.selectedTile[1], board.selectedTile[2]).tileType), 200, 700)
    love.graphics.print(tostring("player turn points: "..player.turnPoints), 200, 710)
    love.graphics.print(tostring("computer turn points: "..computer.turnPoints), 400, 710)

end
