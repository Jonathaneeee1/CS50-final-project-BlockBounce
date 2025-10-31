local love = require("love")
local Ball = require("object/Ball")
local Bracket = require("object/Bracket")
local Conf = require("conf")
local Menu = require("object/Menu")
local Wall = require("object/Wall")

math.randomseed(os.time())

function love.load()
    Conf()
    bracket1 = Bracket() -- create brackets
    bracket2 = Bracket() -- create brackets
    font = love.graphics.newFont("font/superglue.ttf" , 24)
    -- Créer une police plus grande pour le titre de l'écran d'intro
    title_font = love.graphics.newFont("font/superglue.ttf", 72)
    menu = Menu()
    custom_cursor = love.mouse.newCursor("images/cursor.png", 0, 0)
    love.mouse.setCursor(custom_cursor)
    button_click = love.audio.newSource("audio/button_click.wav","static")
    menu_music = love.audio.newSource("audio/menu_music.mp3","stream")
    inGame_music = love.audio.newSource("audio/inGame_music.mp3","stream")
    currentMusic = nil
    ball = Ball()
    wall = Wall()
    
    -- Load saved volume if available
    if love.filesystem.getInfo("volume_level.txt") then
        local savedVolume = love.filesystem.read("volume_level.txt")
        if savedVolume then
            local volume = tonumber(savedVolume)
            if volume then
                menu.volume_level = volume
                -- Find the closest volume step index
                local closestDiff = 1
                for i, step in ipairs(menu.volume_steps) do
                    local diff = math.abs(step - volume)
                    if diff < closestDiff then
                        closestDiff = diff
                        menu.current_volume_index = i
                    end
                end
                love.audio.setVolume(volume)
            end
        end
    end
    
    -- Load saved color if available
    if love.filesystem.getInfo("bracket_color.txt") then
        local savedColor = love.filesystem.read("bracket_color.txt")
        if savedColor then
            local r, g, b = savedColor:match("(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)")
            if r and g and b then
                -- Find the closest color match
                local targetColor = {tonumber(r), tonumber(g), tonumber(b)}
                for i, colorOption in ipairs(menu.bar_colors) do
                    if colorOption.color[1] == targetColor[1] and 
                       colorOption.color[2] == targetColor[2] and 
                       colorOption.color[3] == targetColor[3] then
                        menu.current_color_index = i
                        break
                    end
                end
                
                -- Apply color directly to brackets
                bracket1.bracket_color_running = {tonumber(r), tonumber(g), tonumber(b)}
                bracket1.bracket_color_paused = {tonumber(r), tonumber(g), tonumber(b), 0.45}
                bracket2.bracket_color_running = {tonumber(r), tonumber(g), tonumber(b)}
                bracket2.bracket_color_paused = {tonumber(r), tonumber(g), tonumber(b), 0.45}
            end
        end
    end
    
    -- Load saved theme if available
    if love.filesystem.getInfo("theme_setting.txt") then
        local savedTheme = love.filesystem.read("theme_setting.txt")
        if savedTheme then
            local themeIndex = tonumber(savedTheme)
            if themeIndex and themeIndex >= 1 and themeIndex <= #menu.themes then
                menu.current_theme_index = themeIndex
                menu:apply_current_theme()
            end
        end
    else
        menu:apply_current_theme()
    end
    
    -- Load saved difficulty if available
    if love.filesystem.getInfo("difficulty_setting.txt") then
        local difficulty_data = love.filesystem.read("difficulty_setting.txt")
        menu.current_difficulty_index = tonumber(difficulty_data) or 2
    end
end

    -- Initialize hover variables
    local start_hover = false 
    local options_hover = false
    local exit_hover = false
    local color_hover = false
    local volume_hover = false
    local theme_hover = false
    local difficulty_hover = false

local player1Score = 0
local player2Score = 0

-- Game statistics
local game_stats = {
    play_time = 0,
    bounce_count = 0,
    max_ball_speed = 0,
    games_played = 0,
    total_points = 0
}

-- Load saved statistics if available
if love.filesystem.getInfo("game_stats.txt") then
    local stats_data = love.filesystem.read("game_stats.txt")
    local stats_values = {}
    for value in stats_data:gmatch("%S+") do
        table.insert(stats_values, tonumber(value))
    end
    
    if #stats_values >= 5 then
        game_stats.play_time = stats_values[1] or 0
        game_stats.bounce_count = stats_values[2] or 0
        game_stats.max_ball_speed = stats_values[3] or 0
        game_stats.games_played = stats_values[4] or 0
        game_stats.total_points = stats_values[5] or 0
    end
end

local states = {
    intro = true,     -- New state for intro screen
    running = false,
    paused = false,
    menu = false,     -- Changed to false as intro is now the initial state
    options = false,
    check_paused = false,
    hardness = false,
    gameover = false
}

-- Variables for intro screen animation
local intro_timer = 0
local intro_duration = 3  -- Duration of intro screen in seconds
local title_scale = 0     -- Initial scale of title (for animation)

-- AI mode (false = player vs player, true = player vs IA)
local ai_mode = false


function playMusic(source)
    love.audio.stop()  -- Önceki müziği durdur
    currentMusic = source
    currentMusic:setLooping(true)
    love.audio.play(currentMusic)
    
end

function hideMouse () -- hides mouse when game is running
    if states.running then
        love.mouse.setVisible(false)
    elseif not states.running then
        love.mouse.setVisible(true)
    end    
end

function love.keypressed(key) 
    if states.intro then
        -- Pass to main menu when intro is done by pressing any key
        states.intro = false
        states.menu = true
        playMusic(menu_music)  -- Start menu music
    elseif states.running then 
        if key == "escape" then -- pause game
            love.audio.play(button_click)
            love.audio.setVolume(1)
            states.paused = true
            states.running = false
            states.check_paused = true
        end
        -- Reset game
        if key == "r" then
            ball:reset()
            bracket1:reset()
            bracket2:reset()
            player1Score = 0
            player2Score = 0
            game_stats.games_played = game_stats.games_played + 1
        end

    elseif states.paused then -- unpause game 
        if key == "escape" then
            love.audio.play(button_click)
            love.audio.setVolume(1)
            states.paused = false
            states.running = true
            states.check_paused = false
        end
    elseif states.options then
        if states.check_paused then
            if key == "escape" then
                love.audio.play(button_click)
                love.audio.setVolume(1)
                states.options = false
                states.paused = true
                states.check_paused = false
            end
        end
    elseif states.options then
        if not states.check_paused then
            if key == "escape" then
                love.audio.play(button_click)
                love.audio.setVolume(1)
                states.options = false
                states.menu = true
                states.check_paused = false
            end
        end
    end
end


function love.mousepressed(x, y, button)
    if button == 1 then
        if menu:checkPressed( -- start game
            love.graphics.getWidth()/2 - menu.button_width/2,
            love.graphics.getHeight()/2 - menu.button_height/2 - 60,
            menu.button_width,
            menu.button_height
        ) then
            if states.menu then -- start game
                love.audio.play(button_click) -- play button click sound
                states.menu = false
                states.hardness = true -- hardness menu
                states.paused = false
            elseif states.paused then
                love.audio.play(button_click)
                love.audio.setVolume(menu.volume_level)
                states.paused = false
                states.running = true
                states.check_paused = false
            elseif states.options then
                -- Color selection button
                if menu:checkPressed(love.graphics.getWidth()/2 - menu.button_width/2, love.graphics.getHeight()/2 - menu.button_height/2 - 60, menu.button_width, menu.button_height) then
                    love.audio.play(button_click)
                    menu:next_color()
                -- Volume button
                elseif menu:checkPressed(love.graphics.getWidth()/2 - menu.button_width/2, love.graphics.getHeight()/2 - menu.button_height/2, menu.button_width, menu.button_height) then
                    love.audio.play(button_click)
                    menu:next_volume()
                -- Theme button
                elseif menu:checkPressed(love.graphics.getWidth()/2 - menu.button_width/2, love.graphics.getHeight()/2 - menu.button_height/2 + 60, menu.button_width, menu.button_height) then
                    love.audio.play(button_click)
                    menu:next_theme()

                -- Exit button
                elseif menu:checkPressed(love.graphics.getWidth()/2 - menu.button_width/2, love.graphics.getHeight()/2 - menu.button_height/2 + 180, menu.button_width, menu.button_height) then
                    love.audio.play(button_click)
                    states.options = false
                    states.menu = true
                end
        elseif states.hardness then
                love.audio.play(button_click)
                love.audio.setVolume(menu.volume_level)
                states.hardness = false
                states.running = true
                states.check_paused = false
                ball.xVelocity = -675
            end
        end

        if menu:checkPressed(
            love.graphics.getWidth() / 2 - menu.button_width / 2,
            love.graphics.getHeight() / 2 - menu.button_height / 2,
            menu.button_width,
            menu.button_height
        ) then
            love.audio.play(button_click)
            love.audio.setVolume(menu.volume_level)

            if states.menu then
                -- Go to options menu from main menu
                states.menu = false
                states.options = true
            elseif states.options then
                -- Volume adjustment button
                menu:next_volume()
            elseif states.paused then
                states.options = true
                states.paused = false
                states.running = false
            elseif states.hardness then
                states.hardness = false
                states.running = true
                states.check_paused = false
                states.options = false
                ball.xVelocity = -850
            end
        end


        if menu:checkPressed( -- exit button
            love.graphics.getWidth()/2 - menu.button_width/2,
            love.graphics.getHeight()/2 - menu.button_height/2 + 60,
            menu.button_width,
            menu.button_height
        ) then
            love.audio.play(button_click)
            love.audio.setVolume(menu.volume_level)
            if states.menu then
                love.event.quit()
            elseif states.paused then
                states.paused = false
                states.menu = true
            elseif states.options then
                -- Back button in options
                states.options = false
                if states.check_paused then
                    states.paused = true
                else
                    states.menu = true
                end
            elseif states.hardness then
                states.hardness = false
                states.running = true
                ball.xVelocity = -1125
            end
        end
        
        -- Bouton IA mode
        if menu:checkPressed(
            love.graphics.getWidth()/2 - menu.button_width/2,
            love.graphics.getHeight()/2 - menu.button_height/2 + 120, -- Position below the Exit buttons
            menu.button_width,
            menu.button_height
        ) then
            if states.menu then
                love.audio.play(button_click)
                ai_mode = not ai_mode -- Switch between IA mode and normal mode
            end
        end
    end
end


function hover_checker() -- checks if mouse is hovering over buttons
    if menu:checkPressed(
        love.graphics.getWidth()/2 - menu.button_width/2,
        love.graphics.getHeight()/2 - menu.button_height/2 - 60,
        menu.button_width,
        menu.button_height
    ) then
        start_hover = true
    else 
        start_hover = false
    end
    if menu:checkPressed(
        love.graphics.getWidth()/2 - menu.button_width/2,
        love.graphics.getHeight()/2 - menu.button_height/2 + 60,
        menu.button_width,
        menu.button_height
    ) then
        exit_hover = true
    else
        exit_hover = false
    end
    if menu:checkPressed(
        love.graphics.getWidth()/2 - menu.button_width/2,
        love.graphics.getHeight()/2 - menu.button_height/2,
        menu.button_width,
        menu.button_height
    ) then
        options_hover = true
    else
        options_hover = false
    end
end

function gameover_check()
    if player1Score == 5 then
        states.gameover = true
        states.running = false
        states.paused = false
        states.menu = false
        states.options = false
        states.hardness = false
        states.check_paused = false
    elseif player2Score == 5 then
        states.gameover = true
        states.running = false
        states.paused = false
        states.menu = false
        states.options = false
        states.hardness = false
        states.check_paused = false
    end
end

function love.update(dt)
    if states.intro then
        -- Update intro timer and animation
        intro_timer = intro_timer + dt
        title_scale = math.min(1, intro_timer / 1.5)  -- Scale animation over 1.5 seconds
        
        -- Transition to menu after defined duration
        if intro_timer >= intro_duration then
            states.intro = false
            states.menu = true
            playMusic(menu_music)  -- Start menu music
        end
    elseif states.running then
        -- Update play time when game is running
        game_stats.play_time = game_stats.play_time + dt
        -- Track max ball speed
        local current_speed = math.sqrt(ball.xVelocity^2 + ball.yVelocity^2)
        if current_speed > game_stats.max_ball_speed then
            game_stats.max_ball_speed = current_speed
        end
        -- Controls of player 1 or IA
        if ai_mode then
            -- Logic of IA : follow the ball
            local ball_center = ball.y + ball.width/2
            local bracket_center = bracket1.y + BRACKET_HEIGHT/2
            
            -- Apply difficulty settings to AI
            local difficulty = menu.difficulty_levels[menu.current_difficulty_index]
            local ai_speed = 1.8 * (difficulty and difficulty.ai_speed or 1.8)
            
            -- Add a delay to make the AI not perfect
            if ball.xVelocity < 0 then -- Only when the ball is moving towards the IA
                if bracket_center < ball_center - 10 then
                    bracket1:moveDown(dt * ai_speed) -- Speed adjusted according to difficulty
                elseif bracket_center > ball_center + 10 then
                    bracket1:moveUp(dt * ai_speed) -- Speed adjusted according to difficulty
                end
            end
        else
            -- Normal controls of player 1
            if love.keyboard.isDown("w") then
                bracket1:moveUp(dt)
            end
            if love.keyboard.isDown("s") then
                bracket1:moveDown(dt)
            end
        end
        
        -- Check if mouse is hovering over buttons in options menu
        if states.options then
            color_hover = menu:checkPressed(
                love.graphics.getWidth()/2 - menu.button_width/2,
                love.graphics.getHeight()/2 - menu.button_height/2 - 60,
                menu.button_width,
                menu.button_height
            )
            volume_hover = menu:checkPressed(
                love.graphics.getWidth()/2 - menu.button_width/2,
                love.graphics.getHeight()/2 - menu.button_height/2,
                menu.button_width,
                menu.button_height
            )
            theme_hover = menu:checkPressed(
                love.graphics.getWidth()/2 - menu.button_width/2,
                love.graphics.getHeight()/2 - menu.button_height/2 + 60,
                menu.button_width,
                menu.button_height
            )
        end
        
        -- Controls of player 2 (always controlled by human player)
        if love.keyboard.isDown("up") then
            bracket2:moveUp(dt)
        end
        if love.keyboard.isDown("down") then
            bracket2:moveDown(dt)
        end
        ball:update(dt)
        if ball:checkCollision(bracket1.x_p1,bracket1.y,BRACKET_WIDTH,BRACKET_HEIGHT) then
            ball:bounce(bracket1)
        end
        if ball:checkCollision(bracket2.x_p2,bracket2.y,BRACKET_WIDTH,BRACKET_HEIGHT    ) then
            ball:bounce(bracket2)
        end
        if ball.x < - 500 then
            player2Score = player2Score + 1
            game_stats.total_points = game_stats.total_points + 1
            ball:reset()
            bracket1:reset()
            bracket2:reset()
        end
        if ball.x > love.graphics.getWidth() + 500 then
            player1Score = player1Score + 1
            game_stats.total_points = game_stats.total_points + 1
            ball:reset()
            bracket1:reset()
            bracket2:reset()
        end
        if ball.y < 0 then
            ball.yVelocity = -ball.yVelocity
        end
        if ball.y > love.graphics.getHeight() - ball.width then
            ball.yVelocity = -ball.yVelocity
        end
        bracket1:checkGrounded()
        bracket2:checkGrounded()
        
        gameover_check()
    end

    hideMouse()
    hover_checker()
    if states.menu and currentMusic ~= menu_music then
        playMusic(menu_music)
        love.audio.setVolume(0.1)
    end
    if states.running and currentMusic ~= inGame_music then
        playMusic(inGame_music)
        love.audio.setVolume(0.1)
    end
    if states.paused and currentMusic ~= menu_music then
        playMusic(menu_music)
        love.audio.setVolume(0.1)
    end
    if states.menu and currentMusic == menu_music then
        love.audio.setVolume(0.1)
    end
end

-- Colors of players
local PLAYER1_COLOR = {1, 0, 0} -- Red for player 1
local PLAYER2_COLOR = {0, 0, 1} -- Blue for player 2
local PLAYER1_COLOR_PAUSED = {1, 0, 0, 0.45} -- Semi-transparent red for pause
local PLAYER2_COLOR_PAUSED = {0, 0, 1, 0.45} -- Semi-transparent blue for pause

function love.draw()
    if states.intro then
        -- Draw introduction screen with title "BlockBounce"
        -- Background of intro screen (use current theme color)
        love.graphics.setBackgroundColor(menu.themes[menu.current_theme_index].background)
        
        -- Afficher left title "BlockBounce" 
        love.graphics.setFont(title_font)
        local title = "BlockBounce"
        local title_width = title_font:getWidth(title)
        local title_height = title_font:getHeight()
        
        -- Center title with scale animation
        love.graphics.setColor(1, 1, 1)
        love.graphics.push()
        love.graphics.translate(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
        love.graphics.scale(title_scale, title_scale)
        love.graphics.print(title, -title_width/2, -title_height/2)
        love.graphics.pop()
        
        -- Display a message 'Press any key to continue' if the animation is finished
        if title_scale >= 1 then
            love.graphics.setFont(font)
            local message = "Press any key to continue"
            local message_width = font:getWidth(message)
            love.graphics.setColor(1, 1, 1, math.sin(love.timer.getTime() * 2) * 0.5 + 0.5) -- Effect of blinking
            love.graphics.print(message, love.graphics.getWidth()/2 - message_width/2, love.graphics.getHeight()/2 + 100)
        end
    elseif states.running then
        bracket1:draw(bracket1.x_p1,bracket1.y,PLAYER1_COLOR)
        bracket2:draw(bracket2.x_p2,bracket2.y,PLAYER2_COLOR)
        ball:draw(COLOR_RUNNING)
        wall:draw()
        love.graphics.setColor(1,1,1)
        love.graphics.print("Player 1: " .. player1Score, 20, 20)
        local player2ScoreWidth = font:getWidth("Player 2: " .. player2Score)
        love.graphics.print("Player 2: " .. player2Score, love.graphics.getWidth() - player2ScoreWidth - 20, 20)
        
        -- Draw statistics
        local smallFont = love.graphics.newFont("font/superglue.ttf", 14)
        love.graphics.setFont(smallFont)
        love.graphics.setColor(0.8, 0.8, 0.8, 0.7)
        love.graphics.print("TIME: " .. string.format("%.1f", game_stats.play_time) .. "s", 10, 60)
        love.graphics.print("BOUNCES: " .. game_stats.bounce_count, 10, 80)
        love.graphics.print("MAX SPEED: " .. string.format("%.0f", game_stats.max_ball_speed), 10, 100)
        love.graphics.setFont(font)
    
    elseif states.paused then
        bracket1:draw(bracket1.x_p1,bracket1.y,PLAYER1_COLOR_PAUSED)
        bracket2:draw(bracket2.x_p2,bracket2.y,PLAYER2_COLOR_PAUSED)
        ball:draw(COLOR_PAUSED)
    end
    if states.paused then
        if not start_hover then
            menu:resume_button()
        
        elseif start_hover then
            menu:hover_resume()
        end
        if not options_hover then
            menu:options_button()
        elseif options_hover then
            menu:hover_options()
        end
        if not exit_hover then
            menu:back_button()
        elseif exit_hover then
            menu:hover_back()
        end
    end
    if states.menu then
        if not start_hover then
            menu:start_button()

        elseif start_hover then
            menu:hover_start()
        end
        if not options_hover then

            menu:options_button()

        elseif options_hover then
            menu:hover_options()
        end
        if not exit_hover then
            menu:exit_button()

        elseif exit_hover then
            menu:hover_exit()
        end
        
        -- Draw AI mode button
        love.graphics.setColor(0.2, 0.2, 0.8)
        love.graphics.rectangle(
            "fill",
            love.graphics.getWidth()/2 - menu.button_width/2,
            love.graphics.getHeight()/2 - menu.button_height/2 + 120,
            menu.button_width,
            menu.button_height
        )
        love.graphics.setColor(1, 1, 1)
        local text = ai_mode and "AI Player : ON" or "AI Player : OFF"
        local textWidth = font:getWidth(text)
        love.graphics.print(
            text,
            love.graphics.getWidth()/2 - textWidth/2,
            love.graphics.getHeight()/2 - menu.button_height/2 + 120 + menu.button_height/2 - font:getHeight()/2
        )
    end

    if states.options then
        -- Draw options menu
        local theme = menu.themes[menu.current_theme_index]
        love.graphics.setBackgroundColor(theme.background or 0.1, 0.1, 0.1)
        love.graphics.setColor(theme.text or {1, 1, 1})
        love.graphics.setFont(font)
        love.graphics.printf("OPTIONS", 0, 100, love.graphics.getWidth(), "center")
        
        -- Draw color selection button
        if color_hover then
            menu:hover_color()
        else
            menu:color_button()
        end
        
        -- Draw volume adjustment button
        if volume_hover then
            menu:hover_volume()
        else
            menu:volume_button()
        end
        
        -- Draw theme button
        if theme_hover then
            menu:hover_theme()
        else
            menu:theme_button()
        end
        
        -- Draw back button
        if exit_hover then
            menu:hover_back()
        else
            menu:back_button()
        end
        
        -- Preview bar color
        local previewColor = menu.bar_colors[menu.current_color_index].color
        love.graphics.setColor(previewColor)
        love.graphics.rectangle("fill", 
            love.graphics.getWidth()/2 - 100, 
            love.graphics.getHeight() - 100, 
            200, 20, 5, 5)
            
        -- Preview theme
        love.graphics.setColor(theme.accent or {0.5, 0.5, 0.8})
        love.graphics.rectangle("fill",
            love.graphics.getWidth()/2 - 100,
            love.graphics.getHeight() - 150,
            200, 20, 5, 5)
    end
    if states.hardness then
        if not start_hover then
            menu:slow_button()

        elseif start_hover then
            menu:hover_slow()
        end
        if not options_hover then

            menu:medium_button()

        elseif options_hover then
            menu:hover_medium()
        end
        if not exit_hover then
            menu:fast_button()

        elseif exit_hover then
            menu:hover_fast()
        end
    end
    winner = nil
    function setWinnter()
        if player1Score == 5 then
            winner = "Player 1"
        elseif player2Score == 5 then
            winner = "Player 2"
        end
    end
    if states.gameover then
        love.graphics.setColor(1,1,1)
        love.graphics.print("Game Over", love.graphics.getWidth()/2 - 100, love.graphics.getHeight()/2 - 100)
        setWinnter()
        love.graphics.print(winner .. " wins!", love.graphics.getWidth()/2 - 100, love.graphics.getHeight()/2 - 50)
        love.graphics.print("Press ESC to return to menu", love.graphics.getWidth()/2 - 100, love.graphics.getHeight()/2)
        if love.keyboard.isDown("escape") then
            states.gameover = false
            states.menu = true
            states.running = false
            states.paused = false
            states.options = false
            states.hardness = false
            states.check_paused = false
            player1Score = 0
            player2Score = 0
            game_stats.games_played = game_stats.games_played + 1
        end
    end
end

function love.quit()
    -- Save volume level
    love.filesystem.write("volume_level.txt", tostring(menu.volume_level))
    -- Save bracket color
    local color = bracket1.bracket_color_running
    love.filesystem.write("bracket_color.txt", string.format("%f,%f,%f", color[1], color[2], color[3]))
    -- Save theme setting
    love.filesystem.write("theme_setting.txt", tostring(menu.current_theme_index))
    -- Save game statistics
    local stats_string = string.format("%f %d %f %d %d", 
        game_stats.play_time, 
        game_stats.bounce_count, 
        game_stats.max_ball_speed, 
        game_stats.games_played, 
        game_stats.total_points)
    love.filesystem.write("game_stats.txt", stats_string)
end