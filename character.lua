Character = {}

-- Constructor
function Character:new()
    local object = {
        image = nil,
        x = 1,
        y = 1,
        heldItem = nil
    }
    setmetatable(object, { __index = Character })
    return object
end

function Character:draw()
    draw_on_tile(self.image, self.x, self.y, 0, -20)
end

function Character:position()
    return { self.x, self.y }
end