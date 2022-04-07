--[[ I have no idea what i'm doing
here we go

trying to make a Tetris cuz why not
]]

local fieldHandler = require('lib.fieldHandler')
local displayHandler = require('lib.displayHandler')
local keyboardHandler= require('lib.keyboardHandler')

local status = {
    clicked = false,
    gameEnded = false,
    inPlay = false,
    timeElapsed = 0,
}

function love.load()
    --game setup
    --initialize fieldHandler
    fieldHandler.Init()

    --Initialize displayHandler
    displayHandler.init(fieldHandler.getSize())
end

function love.resize(X,Y) --activated everytime the window is resized, it then redoes all the math for love.draw so it's always displayed correctly
    displayHandler.resize(X,Y)
end

function love.focus(f)
    if f then
        status.inPlay = true
    else
        status.inPlay = false
    end
end

function love.update(t)
    if status.inPlay and not status.gameEnded then
        status.timeElapsed = status.timeElapsed + t
        fieldHandler.update(status.timeElapsed)
    end
end

function love.draw()
    displayHandler.drawfield(fieldHandler.getField())
    displayHandler.drawObjects(fieldHandler.getObjects())--draws current moving piece
end

function love.keypressed(key, scancode, isrepeat)
    keyboardHandler.keyPressed(key)
end

function love.keyreleased(key)
    print(key)
    keyboardHandler.keyReleased(key)

    if key == "escape" then
       love.event.quit()
    end
 end

function love.mousepressed(x, y, button, istouch)
    print(x,y)
end

function love.wheelmoved( x,y )
    
end

function love.quit()
    print("bye lol.")
end