Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
end

function Paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Paddle:moveUp(ball)
    if ball.y + ball.height < self.y + 10 then
        return true
    else
        return false
    end
end

function Paddle:moveDown(ball)
    if ball.y > self.y + self.height - 10 then
        return true
    else
        return false
    end
end