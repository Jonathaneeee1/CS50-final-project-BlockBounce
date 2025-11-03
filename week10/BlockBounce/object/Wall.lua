love = require('love')

local function Wall()
    local paddleWidth = 5
    local paddleHeight = 80

    return{
        paddleX = love.graphics.getWidth() / 2 -  paddleWidth / 2,
        paddleY = love.graphics.getHeight() / 2 -  paddleHeight / 2,

        draw = function(self)
            love.graphics.setColor(1,1,1,0.45)
            love.graphics.rectangle('fill', self.paddleX, self.paddleY, paddleWidth, paddleHeight,5,5)
        end,
    }
end

return Wall 
