Shield = {}

-- Constructor
function Shield:new()
    local object = {
    name = 'shield',
    image = love.graphics.newImage('img/player/player_shield.png'),
    protectZoneImage = love.graphics.newImage('img/player/protectZone.png'),
    shieldPoints = 0,
    protecting = false,
    }
    setmetatable(object, { __index = Shield })
    return object
end

function Shield:draw()
    if self.protecting then
        for i=(math.max(0,self.x-self.shieldPoints)), (math.min(boardXSize,self.x+self.shieldPoints)) do
            for j=(math.max(0,self.y-self.shieldPoints)), (math.min(boardYSize,self.y+self.shieldPoints)) do
                love.graphics.draw(self.protectZoneImage, i*tilePixelSize, j*tilePixelSize)    
            end        
        end
    end
    love.graphics.draw(self.image, self.x*tilePixelSize, self.y*tilePixelSize)
end

function Shield:protect(points)
    self.protecting = true
    self.shieldPoints = points
end