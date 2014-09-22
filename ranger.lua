Ranger = {}

-- Constructor
function Ranger:new()
    require 'character'

    local char = Character:new()
    local object = {
    name = 'ranger',
    image = love.graphics.newImage('img/player/player_range.png'),
    bulletImage = love.graphics.newImage('img/player/bullet.png'),
    bullet_x = 0,
    bullet_y = 0,
    shooting = false,
    target = {0,0}
    }
    setmetatable(self, {__index = char })
    setmetatable(object, {__index = Ranger})
    return object
end

function Ranger:draw()
    Character.draw(self)
    if self.shooting then
        love.graphics.draw(self.bulletImage, self.bullet_x, self.bullet_y)
        self:moveBullet(dt)
    end
end

-- Shoot to target
function Ranger:shoot(mouseOverTile)
    self.target = pixel_position(mouseOverTile[1] + 0.5, mouseOverTile[2] + 0.5)
    self.bullet_x, self.bullet_y = (self.x + 0.5)*TILE_PIXEL_SIZE, (self.y + 0.5)*TILE_PIXEL_SIZE
    self.shooting = true
end

-- bullet movement
function Ranger:moveBullet(dt)
    if tile_distance({self.bullet_x, self.bullet_y}, self.target) > 0 then
        if self.bullet_x < self.target[1] then
            self.bullet_x = self.bullet_x + 5
        elseif self.bullet_x > self.target[1] then
            self.bullet_x = self.bullet_x - 5
        end
        if self.bullet_y < self.target[2] then
            self.bullet_y = self.bullet_y + 5
        elseif self.bullet_y > self.target[2] then
            self.bullet_y = self.bullet_y - 5
        end
    else
        self.shooting = false
    end
end