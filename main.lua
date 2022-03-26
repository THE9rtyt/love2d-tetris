--[[ I have no idea what i'm doing
here we go

trying to make a Tetris cuz why not
]]

local fieldHandler = require('lib.fieldHandler')
local displayHandler = require('lib.displayHandler')

local status = {
    clicked = false,
    gameEnded = false,
    inPlay = false,
    timeElapsed = 0,
}

function love.load()
    --game setup
    fieldHandler.resetField()
    fieldHandler.Init()

    --Initialize displayHandler
    local windowX, windowY = love.window.getMode()
    displayHandler.init(windowX,windowY,fieldHandler.getSize())
end

function love.resize(X, Y) --activated everytime the window is resized, it then redoes all the math for love.draw so it's always displayed correctly
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
    local objectData,objects = fieldHandler.getObjects()
    displayHandler.drawObjects(objectData,objects)--draws current moving piece
end

function love.mousepressed(x, y, button, istouch)
    print(x,y)
end

function love.quit()
    print("bye lol.")
end

function love.wheelmoved( x,y )
    
end