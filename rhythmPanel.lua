RhythmPanel = {}


-- Constructor
function RhythmPanel:new()

    local object = {
    
    imageBackground = love.graphics.newImage('img/rhythmPanel/background.png'),
    imageFrameIdle = love.graphics.newImage('img/rhythmPanel/idle.png'),
    imageFrameOk = love.graphics.newImage('img/rhythmPanel/ok.png'),
    imageFrameWrong = love.graphics.newImage('img/rhythmPanel/wrong.png'),

    icons = {
	    -- ['up']     = love.graphics.newImage('img/rhythmPanel/up.png'),
	    -- ['down']   = love.graphics.newImage('img/rhythmPanel/down.png'),
	    -- ['left']   = love.graphics.newImage('img/rhythmPanel/left.png'),
	    -- ['right']  = love.graphics.newImage('img/rhythmPanel/right.png'),
    	['arrow']  = love.graphics.newImage('img/rhythmPanel/arrow.png'),
    	['shield'] = love.graphics.newImage('img/rhythmPanel/shield.png'),
    	['dir'] = love.graphics.newImage('img/rhythmPanel/directions.png'),
	    },

    moves = {},
    currentMove = '',
    speed = 2.5,
    next_in = 1

    }
    setmetatable(object, { __index = RhythmPanel })
    return object
end

function RhythmPanel:update(player)
	if #self.moves == 0 or self.moves[#self.moves][2] > self.next_in*100 then
		-- local move = choose(tables_concat(player:possible_moves(), {'arrow','shield'}))
		local move = choose({'dir','arrow','shield'},{8,1,1})
		table.insert(self.moves, {move, 0})
		self.next_in = choose({1,2,3})
	end
	if #self.moves > 0 then
		if self.moves[1][2] > 550 then
			table.remove(self.moves, 1)
		end
		self.currentMove = self.moves[1]
	end
	-- (player) update probas ...
end

function RhythmPanel:draw()
	love.graphics.draw(self.imageBackground, 800, 0)
	-- if ... then
	-- else
	love.graphics.draw(self.imageFrameIdle, 800, 500)
	-- end
	for _,m in ipairs(self.moves) do
		love.graphics.draw(self.icons[m[1]], 800, m[2])
		m[2] = m[2] + self.speed
	end
end