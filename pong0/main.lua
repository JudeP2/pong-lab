WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200
Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'


function love.load()
    math.randomseed(os.time())

    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    love.window.setTitle('Pong')
    
    smallFont = love.graphics.newFont('font.ttf', 8)

    scoreFont = love.graphics.newFont("font.ttf", 32)
    victoryFont = love.graphics.newFont('font.ttf', 24)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('paddle_hit.wav', 'static'),
        ['point_scored'] = love.audio.newSource('point_scored.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('wall_hit.wav', 'static')
    }

    player1Score = 0
    player2Score = 0


    servingPlayer = math.random(2) == 1 and 1 or 2
    winningPlayer = 0

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizeable = true




    })
    
    
    
    player1= Paddle(10,30,5,20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT- 30, 5, 20)
    ball = Ball(VIRTUAL_WIDTH/ 2-2, VIRTUAL_HEIGHT/ 2-2, 5, 5)


    gameState = 'start'

    function love.resize(w, h)
        push:resize(w, h)
    
    end

    
    if servingPlayer == 1 then

        ball.dx = math.random(140,250)
        
    else
        ball.dx =  math.random(140,250)
    end
    
    
    
    
    
    
    
    
  


end
function love.update(dt)

    if ball.x <= 0 then
        player2Score = player2Score + 1
        servingPlayer = 1
        sounds['point_scored']:play()
        ball:reset()
        

        ball.dx = 100
        if player2Score >= 10 then
            gameState = 'victory'
            winningPlayer = 2
        else
            gameState = 'serve'
        end
    end

    if ball.x >= VIRTUAL_WIDTH - 4 then
        player1Score = player1Score + 1
        servingPlayer = 2
        sounds['point_scored']:play()
        ball.dx = -100
        ball:reset()
        


        if player1Score >= 10 then
            gameState = 'victory'
            winningPlayer = 1
        else
            gameState = 'serve'
        gameState = 'serve'
        end
    end

    if ball:collides(player1) then
    
        ball.dx = -ball.dx * 1.03
        ball.x = player1.x + 5
        sounds['paddle_hit']:play()
    end


    if ball:collides(player2) then
        ball.dx = -ball.dx *1.03
        sounds['paddle_hit']:play()
    end

    if ball.y <= 0 then
        ball.dy = -ball.dy

        sounds['wall_hit']:play()
    end


    if ball.y >= VIRTUAL_HEIGHT - 4 then
        ball.dy = -ball.dy
        ball.y = VIRTUAL_HEIGHT - 4
        sounds['wall_hit']:play()
    end

    player1:update(dt)
    player2:update(dt)
    -- player 1
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s')then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end
    --player 2
    if ball.dy < 0 then
        player2.y = ball.y
    elseif ball.y > 0 then
        player2.y = ball.y
    else 
        player2.y = 0
    end



    if gameState == 'play' then
        ball:update(dt)
    end
end


function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve' 
        elseif gameState == 'victory' then
            gameState = 'start'      
            player1Score = 0
            player2Score = 0
        elseif gameState == 'serve' then
            gameState = 'play'
        end
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    
    love.graphics.setFont(smallFont)
  
    if gameState == 'start' then
        love.graphics.printf("Welcome to Pong!", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter to Play!", 0, 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then 
        love.graphics.printf("Player " .. tostring(servingPlayer).. "'s turn!", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter to Serve!", 0, 32, VIRTUAL_WIDTH, 'center')
    
    elseif gameState == 'victory' then

        love.graphics.setFont(victoryFont)
        love.graphics.printf("Player " .. tostring(winningPlayer).. " wins!", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter to Serve!", 0, 42, VIRTUAL_WIDTH, 'center')

    
    
    end
    
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH/ 2 - 50, VIRTUAL_HEIGHT/3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH/ 2 + 30, VIRTUAL_HEIGHT/3)



    player1:render()
    player2:render()
    
    ball:render()
    
    
    displayFPS()
    
   

    push:apply('end')
end
function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS: '.. tostring(love.timer.getFPS()), 40, 20)
    love.graphics.setColor(1, 1, 1, 1)
end
