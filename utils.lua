-- utils
--------


-- global params
TILE_PIXEL_SIZE = 64
BOARD_X_SIZE = 16
BOARD_Y_SIZE = 10

function tile_distance(t1, t2)
    return math.abs(t2[1]-t1[1]) + math.abs(t2[2]-t1[2])
end

function choose(tabl, weights)
	if weights == nil then
		return tabl[math.random(#tabl)]
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
				return tabl[i]
			end
		end
	end
end

function choose_n(tabl, n)
	local t = {}
	for i=1, #tabl do
		table.insert(t, i)
	end
	local r = {}
	for i=1, n do
		local x = math.random(#tabl)
		table.remove(t, x)
		table.insert(r, x)
	end
	return r
end

function draw_on_tile(image, x, y, offsetx, offsety)
	love.graphics.draw(image, (x-1)*TILE_PIXEL_SIZE + (offsetx or 0), (y-1)*TILE_PIXEL_SIZE + (offsety or 0))
end

function pixel_position(x, y)
	return {x*TILE_PIXEL_SIZE, y*TILE_PIXEL_SIZE}
end

function table_print(tabl)
	local r = '['
	for i, e in ipairs(tabl) do
		r = r .. e
		if i ~= #tabl then
			r = r .. ', '
		end
	end
	r = r .. ']'
	print(r)
end