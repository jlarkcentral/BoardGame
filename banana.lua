Banana = {}

-- Constructor
function Banana:new(posx, posy)
    --require 'item'
    --local item = Item:new(posx, posy)
    local object = {
        x = posx,
        y = posy,
        image = love.graphics.newImage('img/items/banana.png'),
    }
    --setmetatable(self, { __index = item })
    setmetatable(object, { __index = Banana })
    return object
end

function Banana:draw()
    --Item.draw(self)
    draw_on_tile(self.image, self.x, self.y)
end

function Banana:use(board)
    board:get_tile(board.selectedTile[1], board.selectedTile[2]).image = board.imageDanger
end