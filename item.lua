Item = {}

-- Constructor
function Item:new(posx, posy)
    local object = {
        image = nil,
        x = posx,
        y = posy,
    }
    setmetatable(object, { __index = Item })
    return object
end

function Item:draw()
    draw_on_tile(self.image, self.x, self.y)
end

function Item:position()
    return {self.x, self.y}
end