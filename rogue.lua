Rogue = {}

-- Constructor
function Rogue:new()
    local object = {
    name = 'rogue',
    image = love.graphics.newImage('img/player/player_rogue.png'),
    x = 0,
    y = 0,
    }
    setmetatable(object, { __index = Rogue })
    return object
end

function Rogue:draw()
    Character.draw(self)
    if self.shooting then
        love.graphics.draw(self.bulletImage, self.bullet_x, self.bullet_y)
    end
end