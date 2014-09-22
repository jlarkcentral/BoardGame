Shield = {}

-- Constructor
function Shield:new()
    require 'character'

    local char = Character:new()
    local object = {
    name = 'shield',
    image = love.graphics.newImage('img/player/player_shield.png'),
    protectZoneImage = love.graphics.newImage('img/player/protectZone.png'),
    shieldPoints = 0,
    protecting = false,
    }
    setmetatable(self, {__index = char })
    setmetatable(object, {__index = Shield })
    return object
end

function Shield:draw()
    if self.protecting then
        for i=(math.max(0, self.x-self.shieldPoints)), (math.min(BOARD_X_SIZE, self.x+self.shieldPoints)) do
            for j=(math.max(0, self.y-self.shieldPoints)), (math.min(BOARD_Y_SIZE, self.y+self.shieldPoints)) do
                draw_on_tile(self.protectZoneImage, i, j)    
            end        
        end
    end
    Character.draw(self)
end

function Shield:protect(points)
    self.protecting = true
    self.shieldPoints = points
end