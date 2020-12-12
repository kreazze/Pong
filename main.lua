-- Author: Colton Ogden
-- CET3 Game Development BSCOE 2-6

push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'
require 'State'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200
AI_SPEED = 150

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Pong')

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('Assets/font.ttf', 8)
    largeFont = love.graphics.newFont('Assets/font.ttf', 16)
    scoreFont = love.graphics.newFont('Assets/font.ttf', 32)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('Assets/PaddleHit.wav', 'static'),
        ['score'] = love.audio.newSource('Assets/Shoot.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('Assets/Hit_Hurt.wav', 'static')
    }
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true,
    })

    AI = Paddle(5, 30, 5, 20)
    PLAYER = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    AIScore = 0
    PLAYERScore = 0

    State:load()
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if ball.x < VIRTUAL_WIDTH/3 then
        if AI:moveUp(ball) then
            AI.dy = -PADDLE_SPEED
        elseif AI:moveDown(ball) then
            AI.dy = PADDLE_SPEED
        else
            AI.dy = 0
        end
    end

    if love.keyboard.isDown('up') then
        PLAYER.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        PLAYER.dy = PADDLE_SPEED
    else
        PLAYER.dy = 0
    end

    State:update(dt)
    AI:update(dt)
    PLAYER:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    State:keypressed(key)
end

function love.draw()
    push:start()

    love.graphics.clear(0.2, 0.21, 0.3, 1)
    love.graphics.setFont(smallFont)

    State:draw()

    AI:render()
    PLAYER:render()
    ball:render()

    displayScore()
    displayFPS()

    push:finish()
end


function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(AIScore), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(PLAYERScore), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end

function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(255, 255, 255, 255)
end
