love = require('love')

math.randomseed(os.time())

local function Ball()

    
return{
        x = love.graphics.getWidth()/2,
        y = love.graphics.getHeight()/2,
        width = 20,
        height = 20,
        xVelocity = nil,
        yVelocity = 1,
        speed_multiplier = 1.0, -- Speed multiplier for difficulty,


        update = function(self, dt)
            self.x = self.x + self.xVelocity * dt
            self.y = self.y + self.yVelocity * dt
        end,

        draw = function(self,color)
            love.graphics.setColor(color)
            love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
        end,

        checkCollision = function (self,x,y,width,height)
            if self.x < x + width and
                self.x + self.width > x and
                self.y < y + height and
                self.y + self.height > y then
                    return true
            end
            return false
        end,

        bounce = function(self,obj)
            self.xVelocity = -self.xVelocity * 1.03
            if self.yVelocity < 0 then
                self.yVelocity = -math.random(100, 280)
            else
                self.yVelocity = math.random(100, 280)
            end
            
            -- Update bounce count statistic
            if game_stats then
                game_stats.bounce_count = game_stats.bounce_count + 1
                
                -- Update max ball speed
                local current_speed = math.sqrt(self.xVelocity^2 + self.yVelocity^2)
                if current_speed > game_stats.max_ball_speed then
                    game_stats.max_ball_speed = current_speed
                end
            end
        end,

        reset = function(self)
            self.x = love.graphics.getWidth()/2
            self.y = love.graphics.getHeight()/2
            
            -- Keep the current speed multiplier
            local current_multiplier = self.speed_multiplier
            
            -- Keep the current speed absolute value or use the initial speed
            local current_speed = math.abs(self.xVelocity) or 300 * current_multiplier
            
            -- Ensure the speed doesn't go below the initial speed
            if current_speed < 300 * current_multiplier then
                current_speed = 300 * current_multiplier
            end
            
            -- Randomize initial direction
            local direction = math.random(1, 2)
            if direction == 1 then
                self.xVelocity = current_speed
            else
                self.xVelocity = -current_speed
            end
            
            -- Randomize y velocity tout en conservant une proportion de la vitesse actuelle
            local y_speed = math.random(100, 200) * current_multiplier
            if math.random() > 0.5 then
                self.yVelocity = y_speed
            else
                self.yVelocity = -y_speed
            end
        end

    }
end

return Ball