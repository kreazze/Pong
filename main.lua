-- Author: Colton Ogden
-- CET3 Game Development BSCOE 2 - 6

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

    player1 = Paddle(5, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    paddleTimer = 0
    paddleRate = 0.5

    player1Score = 0
    player2Score = 0

    State:load()
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if player1:moveUp(ball) then
        player1.dy = -PADDLE_SPEED
    elseif player1:moveDown(ball) then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    State:update(dt)
    player1:update(dt)
    player2:update(dt)
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

    player1:render()
    player2:render()
    ball:render()

    displayScore()
    displayFPS()

    push:finish()
end


function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end

function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(255, 255, 255, 255)
end
