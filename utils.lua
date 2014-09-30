-- utils
--------


-- global params
TILE_PIXEL_SIZE = 50
BOARD_X_SIZE    = 15
BOARD_Y_SIZE    = 9

function tile_distance(pos1, pos2)
    return math.abs(pos2[1]-pos1[1]) + math.abs(pos2[2]-pos1[2])
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

function draw_on_tile(image, pos)
	love.graphics.draw(image, pos[1]*TILE_PIXEL_SIZE, pos[2]*TILE_PIXEL_SIZE)
end

function pixel_position(board_pos)
	return {board_pos[1]*TILE_PIXEL_SIZE, board_pos[2]*TILE_PIXEL_SIZE}
end

function is_on_board(pos)
	return pos[1] > 0 
		and pos[1] <= BOARD_X_SIZE+1
		and pos[2] > 0
		and pos[2] <= BOARD_Y_SIZE+1
end

function shortest_path(pos1, pos2)
	
end

-----------------------------------
-----------------------------------

function table_concat(t1, t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

function table_add(t1, t2)
	if not #t1 == #t2 then 
		error()
	else
		for i=1,#t1 do
			t1[i] = t1[i] + t2[i]
		end
		return t1
	end
end

function contains(table, element)
	for _, value in pairs(table) do
		if value == element then
		  	return true
		end
	end
	return false
end

function direction(ref, target)
	if ref[1] == target[1] then
		if ref[2] == target[2] then
			return {0, 0}
		elseif ref[2] > target[2] then
			return {0, -1} -- go north
		elseif ref[2] < target[2] then
			return {0, 1}  -- go south
		end	
	elseif ref[1] > target[1] then
		if ref[2] == target[2] then
			return {-1, 0} -- go west
		elseif ref[2] > target[2] then
			return {-1, -1} -- go northwest
		elseif ref[2] < target[2] then
			return {-1, 1}  -- go southwest
		end	
	elseif ref[1] == target[1] then
		if ref[2] < target[2] then
			return {1, 0} -- go east
		elseif ref[2] > target[2] then
			return {1, -1} -- go northeast
		elseif ref[2] < target[2] then
			return {1, 1} -- go southeast
		end
	end
end