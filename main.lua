function love.load()
	love.window.setMode(900, 600)

	-- global declarations
	math.randomseed(os.time())
	love.mouse.setVisible(false)

	-- load all modules
	require "player"
	require "board"
	require "rhythmPanel"
	require "utils"

	-- initialization
	imageDice = love.graphics.newImage('img/game/dice.png')
    imageBgChar = love.graphics.newImage('img/game/blank.png')

    music = love.audio.newSource( 'img/rhythmPanel/Barcroft45_-_Above_and_Ahead.mp3', 'static' )
    love.audio.setVolume(0)

    player = Player:new()
    player:add_ranger()
    player:add_shield()
    -- player:add_rogue()

    board = Board:new()

    rhythmPanel = RhythmPanel:new()

    restart()
end

function love.update(dt)
	player:update(board, rhythmPanel)
	board:update(player)
	rhythmPanel:update(player)
end

function love.draw()
	board:draw(player)
	player:draw()
	board:draw_upper_layer()
	rhythmPanel:draw()

	love.graphics.draw(imageBgChar, 0, 500, 0, 2)
	love.graphics.draw(player:current_char().image, 0, 500, 0, 2)



    -- INFO

    love.graphics.print(tostring("player: "..player:current_char().x..","..player:current_char().y.."   killed : "..tostring(player.killed)), 200, 520)
    love.graphics.print(tostring("player currentChar: "..player.currentChar), 200, 530)
    love.graphics.print(tostring("player keypressed: "..tostring(player.keypressed).."     "..tostring(player.moved)), 200, 540)

	love.graphics.print(tostring("currentMove : "..rhythmPanel.currentMove[1]), 200, 550)
	love.graphics.print(tostring("combo : "..player.correctMatches), 400, 550)


end

function love.keypressed(key, isrepeat)
	if key == 'escape' then
		restart()
	else
		player.keypressed = key
	end
end

-------------------------
-------------------------

function restart()
	board.villainPositions = {}
    board:initialize()
    board:generate_end_position()
    player:go_to_start_position(board)
    rhythmPanel = {}
    rhythmPanel = RhythmPanel:new()
    music:stop()
    music:play()
end