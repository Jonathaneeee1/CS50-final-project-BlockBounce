love = require('love')

local function conf ()
    love.window.setTitle('Pong')
    love.window.setMode(1280, 720, {resizable = false})
end

return conf