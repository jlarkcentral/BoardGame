-- utils
--------


-- global params
TILE_PIXEL_SIZE = 50
BOARD_X_SIZE = 16
BOARD_Y_SIZE = 10

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
	love.graphics.draw(image, (x-1)*TILE_PIXEL_SIZE, (y-1)*TILE_PIXEL_SIZE)
end

function pixel_position(x, y)
	return {x*TILE_PIXEL_SIZE, y*TILE_PIXEL_SIZE}
end