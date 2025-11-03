---@diagnostic disable: undefined-global

love = require('love')

local function Menu()
   
    return
    {
        start_color = {71/255, 186/255, 30/255},
        exit_color = {186/255, 28/255, 36/255},
        options_color = {128/255, 120/255, 120/255},

        hover_start_color = {19/255, 71/255, 1/255},
        hover_exit_color = {89/255, 2/255, 6/255},
        hover_options_color = {77/255, 72/255, 72/255},

        -- Bar color options
        bar_colors = {
            {name = "WHITE", color = {1, 1, 1}},
            {name = "RED", color = {1, 0, 0}},
            {name = "GREEN", color = {0, 1, 0}},
            {name = "BLUE", color = {0, 0, 1}},
            {name = "YELLOW", color = {1, 1, 0}},
            {name = "PURPLE", color = {1, 0, 1}}
        },
        current_color_index = 1,
        
        -- Volume settings
        volume_level = 1.0,
        volume_steps = {0.0, 0.2, 0.4, 0.6, 0.8, 1.0},
        current_volume_index = 6,
        
        -- Visual themes
        themes = {
            {name = "CLASSIC", background = {0, 0, 0}, text = {1, 1, 1}, accent = {0.5, 0.5, 0.5}},
            {name = "NEON", background = {0.05, 0.05, 0.1}, text = {0, 1, 1}, accent = {1, 0, 1}},
            {name = "RETRO", background = {0.1, 0, 0.2}, text = {1, 0.7, 0}, accent = {0, 0.8, 0.2}},
            {name = "OCEAN", background = {0, 0.1, 0.2}, text = {0.8, 1, 1}, accent = {0, 0.6, 1}}
        },
        current_theme_index = 1,
        
        -- Difficulty levels
        difficulty_levels = {
            {name = "EASY", ball_speed = 1.2, ai_speed = 1.3},
            {name = "NORMAL", ball_speed = 1.3, ai_speed = 1.3},
            {name = "HARD", ball_speed = 1.2, ai_speed = 1.3}
        },
        current_difficulty_index = 2, -- Default to NORMAL

        button_width = 200,
        button_height = 50,
    
    
        button = function (self, text , x , y , color, font)
            love.graphics.setColor(color)
            love.graphics.setFont(font)
            love.graphics.rectangle("fill", x, y, self.button_width , self.button_height,10,10)
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(text, x, y + 6, self.button_width, "center")
        end,  
        
        checkPressed = function (self, x, y, width, height)
            local mouseX = love.mouse.getX()
            local mouseY = love.mouse.getY()
            if mouseX > x and mouseX < x + width and mouseY > y and mouseY < y + height then
                return true
            end
            return false
        end,
        start_button = function (self)
            self:button(
            "START",
            love.graphics.getWidth()/2 - self.button_width/2,
            love.graphics.getHeight()/2 - self.button_height/2 - 60,
            self.start_color,
            font
        )end,

        options_button =  function (self)
            self:button(
            "OPTIONS",
            love.graphics.getWidth()/2 - self.button_width/2,
            love.graphics.getHeight()/2 - self.button_height/2,
            self.options_color,
            font 
        )end,

        exit_button = function (self)
            self:button(
            "EXIT",
            love.graphics.getWidth()/2 - self.button_width/2,
            love.graphics.getHeight()/2 - self.button_height/2 + 60,
            self.exit_color,
            font
        ) end,

        hover_start = function (self)
            self:button(    
                "START",
                love.graphics.getWidth()/2 - self.button_width/2,
                love.graphics.getHeight()/2 - self.button_height/2 - 60,
                self.hover_start_color,
                font
        ) end,
        

        hover_options = function (self)
            self:button(
            "OPTIONS",
            love.graphics.getWidth()/2 - self.button_width/2,
            love.graphics.getHeight()/2 - self.button_height/2,
            self.hover_options_color,
            font
        ) end,

        hover_exit = function (self)
            self:button(
                "EXIT",
                love.graphics.getWidth()/2 - self.button_width/2,
                love.graphics.getHeight()/2 - self.button_height/2 + 60,
                self.hover_exit_color,
                font
        )end,
        
        resume_button = function (self)
            self:button(
            "RESUME",
            love.graphics.getWidth()/2 - self.button_width/2,
            love.graphics.getHeight()/2 - self.button_height/2 - 60,
            self.start_color,
            font
        )end,

        hover_resume = function (self)
            self:button(
            "RESUME",
            love.graphics.getWidth()/2 - self.button_width/2,
            love.graphics.getHeight()/2 - self.button_height/2 - 60,
            self.hover_start_color,
            font
        )end,
        back_button = function (self)
            self:button(
            "BACK",
            love.graphics.getWidth()/2 - self.button_width/2,
            love.graphics.getHeight()/2 - self.button_height/2 + 60,
            self.exit_color,
            font
        )end,

        hover_back = function (self)
            self:button(
            "BACK",
            love.graphics.getWidth()/2 - self.button_width/2,
            love.graphics.getHeight()/2 - self.button_height/2 + 60,
            self.hover_exit_color,
            font
        )end,
        
        slow_button = function (self)
            self:button(
            "SLOW",
            love.graphics.getWidth()/2 - self.button_width/2,
            love.graphics.getHeight()/2 - self.button_height/2 - 60,
            self.start_color,
            font
        )end,

        medium_button = function (self)
            self:button(
            "MEDIUM",
            love.graphics.getWidth()/2 - self.button_width/2,
            love.graphics.getHeight()/2 - self.button_height/2,
            self.options_color,
            font
        )end,

        fast_button = function (self)
            self:button(
            "FAST",
            love.graphics.getWidth()/2 - self.button_width/2,
            love.graphics.getHeight()/2 - self.button_height/2 + 60,
            self.exit_color,
            font
        )end,

        hover_slow = function (self)
            self:button(
            "SLOW",
            love.graphics.getWidth()/2 - self.button_width/2,
            love.graphics.getHeight()/2 - self.button_height/2 - 60,
            self.hover_start_color,
            font
        )end,

        hover_medium = function (self)
            self:button(
            "MEDIUM",
            love.graphics.getWidth()/2 - self.button_width/2,
            love.graphics.getHeight()/2 - self.button_height/2,
            self.hover_options_color,
            font
        )end,

        hover_fast = function (self)
            self:button(
            "FAST",
            love.graphics.getWidth()/2 - self.button_width/2,
            love.graphics.getHeight()/2 - self.button_height/2 + 60,
            self.hover_exit_color,
            font
        )end,
        
        -- Color selection buttons
        color_button = function (self)
            local colorName = self.bar_colors[self.current_color_index].name
            self:button(
                "COLOR: " .. colorName,
                love.graphics.getWidth()/2 - self.button_width/2,
                love.graphics.getHeight()/2 - self.button_height/2 - 60,
                self.options_color,
                font
            )
        end,
        
        hover_color = function (self)
            local colorName = self.bar_colors[self.current_color_index].name
            self:button(
                "COLOR: " .. colorName,
                love.graphics.getWidth()/2 - self.button_width/2,
                love.graphics.getHeight()/2 - self.button_height/2 - 60,
                self.hover_options_color,
                font
            )
        end,
        
        -- Volume adjustment buttons
        volume_button = function (self)
            local volumePercent = math.floor(self.volume_steps[self.current_volume_index] * 100)
            self:button(
                "VOLUME: " .. volumePercent .. "%",
                love.graphics.getWidth()/2 - self.button_width/2,
                love.graphics.getHeight()/2 - self.button_height/2,
                self.options_color,
                font
            )
        end,
        
        hover_volume = function (self)
            local volumePercent = math.floor(self.volume_steps[self.current_volume_index] * 100)
            self:button(
                "VOLUME: " .. volumePercent .. "%",
                love.graphics.getWidth()/2 - self.button_width/2,
                love.graphics.getHeight()/2 - self.button_height/2,
                self.hover_options_color,
                font
            )
        end,
        
        theme_button = function (self)
            self:button(
            "THEME: " .. self.themes[self.current_theme_index].name,
            love.graphics.getWidth()/2 - self.button_width/2,
            love.graphics.getHeight()/2 - self.button_height/2 + 60,
            self.options_color,
            font
        ) end,
        
        hover_theme = function (self)
            self:button(
            "THEME: " .. self.themes[self.current_theme_index].name,
            love.graphics.getWidth()/2 - self.button_width/2,
            love.graphics.getHeight()/2 - self.button_height/2 + 60,
            self.hover_options_color,
            font
        ) end,
        
        next_theme = function (self)
            self.current_theme_index = self.current_theme_index % #self.themes + 1
            
            -- Save the selected theme
            local themeData = self.current_theme_index
            love.filesystem.write("theme_setting.txt", themeData)
            
            -- Apply theme immediately
            self:apply_current_theme()
            
            return self.themes[self.current_theme_index].name
        end,
        
        apply_current_theme = function (self)
            local theme = self.themes[self.current_theme_index]
            self.current_theme = theme
            return theme
        end,
        
        difficulty_button = function(self)
            local difficulty = self.difficulty_levels[self.current_difficulty_index]
            self:button(
                "DIFFICULTÉ: " .. difficulty.name,
                love.graphics.getWidth()/2 - self.button_width/2,
                love.graphics.getHeight()/2 - self.button_height/2 + 120,
                self.options_color,
                font
            )
        end,
        
        hover_difficulty = function(self)
            local difficulty = self.difficulty_levels[self.current_difficulty_index]
            self:button(
                "DIFFICULTÉ: " .. difficulty.name,
                love.graphics.getWidth()/2 - self.button_width/2,
                love.graphics.getHeight()/2 - self.button_height/2 + 120,
                self.hover_options_color,
                font
            )
        end,
        
        next_difficulty = function(self)
            self.current_difficulty_index = self.current_difficulty_index % #self.difficulty_levels + 1
            love.filesystem.write("difficulty_setting.txt", tostring(self.current_difficulty_index))
            return self.difficulty_levels[self.current_difficulty_index].name
        end,
        
        -- Change color to next option
        next_color = function (self)
            self.current_color_index = self.current_color_index + 1
            if self.current_color_index > #self.bar_colors then
                self.current_color_index = 1
            end
            -- Save the selected color
            local color = self.bar_colors[self.current_color_index].color
            love.filesystem.write("bracket_color.txt", color[1] .. "," .. color[2] .. "," .. color[3])
            
            -- Apply color immediately to brackets
            if bracket1 and bracket2 then
                bracket1.bracket_color_running = {color[1], color[2], color[3]}
                bracket1.bracket_color_paused = {color[1], color[2], color[3], 0.45}
                bracket2.bracket_color_running = {color[1], color[2], color[3]}
                bracket2.bracket_color_paused = {color[1], color[2], color[3], 0.45}
            end
        end,
        
        -- Change volume level
        next_volume = function (self)
            self.current_volume_index = self.current_volume_index + 1
            if self.current_volume_index > #self.volume_steps then
                self.current_volume_index = 1
            end
            self.volume_level = self.volume_steps[self.current_volume_index]
            love.audio.setVolume(self.volume_level)
            -- Save the selected volume
            love.filesystem.write("volume_level.txt", tostring(self.volume_level))
        end
    }
end

return Menu