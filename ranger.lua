Ranger = {}

-- Constructor
function Ranger:new()
    local object = {
    image = love.graphics.newImage('img/player/player_range.png'),
    bulletImage = love.graphics.newImage('img/player/bullet.png'),
    x = 0,
    y = 0,
    bullet_x = 0,
    bullet_y = 0,
    shooting = false,
    target = {0,0}
    }
    setmetatable(object, { __index = Ranger })
    return object
end