State = {}

function State:load()
    servingPlayer = 1
    winningPlayer = 0

    gameState = 'start'

    ballMaxSpeed = 400
end

function State:update(dt)
    if gameState == 'serve' then
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end

    elseif gameState == 'play' then
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5
            sounds['paddle_hit']:play()

        --[[ 
            1. Everytime the ball hits the paddle ball.dx increase by 1.03, but there will be a glitch after some time
            2. The glitch is, the ball will passed through the paddle
            3. So what we will gonna do is get the max speed to get the ball going without passing through the paddle
            4. You can do trial and error, then set ball.dx as the estimated ball max speed
        --]]

            if ball.dx > ballMaxSpeed then
                ball.dx = ballMaxSpeed
            end

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 5
            sounds['paddle_hit']:play()

        --[[ 
            1. Everytime the ball hits the paddle ball.dx increase by 1.03, but there will be a glitch after some time
            2. The glitch is, the ball will passed through the paddle
            3. So what we will gonna do is get the max speed to get the ball going without passing through the paddle
            4. You can do trial and error, then set ball.dx as the estimated ball max speed
        --]]

            if ball.dx > ballMaxSpeed then
                ball.dx = ballMaxSpeed
            end
            
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            sounds['score']:play()

            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end

        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            sounds['score']:play()

            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
        ball:update(dt)
    end
end

function State:keypressed(key)
    if key == 'return' or key == 'enter' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'play' then
            gameState = 'pause'
            ball:reset()
        elseif gameState == 'pause' then
            gameState = 'serve'
        elseif gameState == 'done' then
        
            gameState = 'serve'

            ball:reset()

            player1Score = 0
            player2Score = 0

            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end

function State:draw()
    if gameState == 'start' then    
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    
    elseif gameState == 'serve' then
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
        
    elseif gameState == 'play' then
        love.graphics.printf('Playing', 0, 20, VIRTUAL_WIDTH, 'center')

    elseif gameState == 'pause' then
        love.graphics.printf('Press Enter to resume', 0, 20, VIRTUAL_WIDTH, 'center')

    elseif gameState == 'done' then
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
        
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
    end
end