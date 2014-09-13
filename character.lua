Character = {}

-- Constructor
function Character:new()
    local object = {
    image = nil,
    x = 0,
    y = 0,
    }
    setmetatable(object, { __index = Character })
    return object
end

function Character:draw()
    love.graphics.draw(self.image, self.x*tilePixelSize, self.y*tilePixelSize)    
end