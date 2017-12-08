function love.load()
	-- global declarations
	math.randomseed(os.time())
	love.mouse.setVisible(false)

	-- load all modules
	require "player"
	require "computer"
	require "board"
	require "utils"

	-- initialization
	-- imageDice = love.graphics.newImage('img/game/dice.png')
 --    imageBgChar = love.graphics.newImage('img/game/blank.png')

    local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]

    player = Player:new()
    player:add_ranger()
    -- player:add_shield()
    -- player:add_rogue()

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
    computer:update(board)
	board:update(player)
    if love.keyboard.isDown("escape") then
        restart()
    end
end

function love.draw()
	board:draw(player)
	player:draw()
    computer:draw()
	-- board:drawDecoration(player)

	love.graphics.draw(player:current_char().image, 0, 500, 0, 2)
    if player:current_char().heldItem ~= nil then
	    love.graphics.draw(player:current_char().heldItem.image, 100, 500, 0, 2)
    end

    -- INFO
    love.graphics.print(tostring("player: "..player:current_char().x..","..player:current_char().y), 200, 520)
    love.graphics.print(tostring("player currentChar: "..player.currentChar), 200, 530)
    love.graphics.print(tostring("selected tile: "..board.selectedTile[1] .. "," .. board.selectedTile[2]), 200, 540)
    love.graphics.print(tostring("selected tile type: "..board:get_tile(board.selectedTile[1], board.selectedTile[2]).tileType), 200, 550)

end
