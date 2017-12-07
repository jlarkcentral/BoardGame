Rock = {}

-- Constructor
function Rock:new(posx, posy)
    --require 'item'
    --local item = Item:new(posx, posy)
    local object = {
        x = posx,
        y = posy,
        image = love.graphics.newImage('img/items/rock.png'),
    }
    --setmetatable(self, { __index = item })
    setmetatable(object, { __index = Rock })
    return object
end

function Rock:draw()
    --Item.draw(self)
    draw_on_tile(self.image, self.x, self.y)
end