-- utils
--------


-- global params
TILE_PIXEL_SIZE = 50
BOARD_X_SIZE = 15
BOARD_Y_SIZE = 9

function tile_distance(t1, t2)
    return math.abs(t2[1]-t1[1]) + math.abs(t2[2]-t1[2])
end

function choose(table, weights)
	if weights == nil then
		return table[math.random(#table)]
	else
		local s = 0
		for _,v in ipairs(weights) do
			s = s + v 
		end
		local r = math.random(s)
		local sum = 0
		for i=1,#weights do
			sum = sum + weights[i]
			if r <= sum then
				return table[i]
			end
		end
	end
end

function draw_on_tile(image, x, y)
	love.graphics.draw(image, x*TILE_PIXEL_SIZE, y*TILE_PIXEL_SIZE)
end

function pixel_position(x, y)
	return {x*TILE_PIXEL_SIZE, y*TILE_PIXEL_SIZE}
end

function is_on_board(pos)
	return pos[1] > 0 
		and pos[1] <= BOARD_X_SIZE
		and pos[2] > 0
		and pos[2] <= BOARD_Y_SIZE
end

function tables_concat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end