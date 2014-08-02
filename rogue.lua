Rogue = {}

-- Constructor
function Rogue:new()
    local object = {
    image = love.graphics.newImage('img/player/player_rogue.png'),
    bulletImage = love.graphics.newImage('img/player/bullet.png'),
    x = 0,
    y = 0,
    bullet_x = 0,
    bullet_y = 0,
    shooting = false,
    target = {0,0},
    }
    setmetatable(object, { __index = Rogue })
    return object
end