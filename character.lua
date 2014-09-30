Character = {}

-- Constructor
function Character:new()
    local object = {
    image    = nil,
    x        = 0,
    y        = 0,
    isKilled = false,
    isHidden = false
    }
    setmetatable(object, { __index = Character })
    return object
end

function Character:draw()
    draw_on_tile(self.image, self:position())    
end

function Character:position()
	return {self.x, self.y}
end