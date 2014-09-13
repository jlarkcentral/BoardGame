-- utils

function tile_distance(t1, t2)
    return math.abs(t2[1]-t1[1]) + math.abs(t2[2]-t1[2])
end

function choose(table)
	return table[math.random(#table)]
end

function choose_w(table, weights)
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