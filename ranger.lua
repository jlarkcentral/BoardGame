Ranger = {}

-- Constructor
function Ranger:new()
    require 'Character'

    local char = Character:new()
    local object = {
    name = 'ranger',
    image = love.graphics.newImage('img/player/player_range.png'),

    -- specs
    bulletImage = love.graphics.newImage('img/player/bullet.png'),
    bullet_x = 0,
    bullet_y = 0,
    shooting = false,
    target = {0,0}
    }
    setmetatable(self, { __index = char })
    setmetatable(object, {__index = Ranger})
    return object
end

function Ranger:draw()
    Character.draw(self)
    if self.shooting then
        love.graphics.draw(self.bulletImage, self.bullet_x, self.bullet_y)
    end
end

-- Shoot to target
function Ranger:shoot(mouseOverTile)
    self.target = { mouseOverTile[1]*tilePixelSize + tilePixelSize/2, mouseOverTile[2]*tilePixelSize + tilePixelSize/2 }
    self.bullet_x, self.bullet_y = self.x*tilePixelSize + tilePixelSize/2, self.y*tilePixelSize + tilePixelSize/2
    self.shooting = true
end

-- bullet movement
function Ranger:moveBullet(dt)
    if distanceFrom(self.bullet_x,self.bullet_y,self.target[1],self.target[2]) > 0 then
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