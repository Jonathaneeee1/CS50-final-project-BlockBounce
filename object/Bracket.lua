---@diagnostic disable: undefined-global
love = require('love')

local function Bracket()
    
    BRACKET_HEIGHT = 130 -- Height of the bracket
    BRACKET_WIDTH = 10 -- Width of the bracket
    -- Default colors that can be overridden
    COLOR_RUNNING = {1, 1, 1} -- Color of the bracket when the game is running
    COLOR_PAUSED = {1, 1, 1 , 0.45} -- Color of the bracket when the game is paused
    
    -- Get saved color from settings if available
    local savedColor = love.filesystem.getInfo("bracket_color.txt") and love.filesystem.read("bracket_color.txt")
    if savedColor then
        local r, g, b = savedColor:match("(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)")
        if r and g and b then
            COLOR_RUNNING = {tonumber(r), tonumber(g), tonumber(b)}
            COLOR_PAUSED = {tonumber(r), tonumber(g), tonumber(b), 0.45}
        end
    end
    return{
        y = love.graphics.getHeight() / 2 - BRACKET_HEIGHT / 2, -- Y position of the bracket
        x_p1 = 20, -- X position of player 1
        x_p2 = love.graphics.getWidth() - BRACKET_WIDTH - 20, -- X position of player 2
        bracket_color_paused = COLOR_PAUSED, -- Color of the bracket when the game is paused
        bracket_color_running = COLOR_RUNNING, -- Color of the bracket when the game is running

        draw = function (self, x, y , color)
            love.graphics.setColor(color)
            love.graphics.rectangle("fill", x, y, BRACKET_WIDTH, BRACKET_HEIGHT,5,5)
        end,

        moveUp = function (self, dt)
            self.y = self.y - 500 * dt
        end,

        moveDown = function (self, dt)
            self.y = self.y + 500 * dt
        end,

        checkGrounded = function (self)
            if self.y < 0 then
                self.y = 0
            elseif self.y > love.graphics.getHeight() - BRACKET_HEIGHT then
                self.y = love.graphics.getHeight() - BRACKET_HEIGHT
            end
        end,

        reset = function (self)
            self.y = love.graphics.getHeight() / 2 - BRACKET_HEIGHT / 2
        end
    }
end

return Bracket