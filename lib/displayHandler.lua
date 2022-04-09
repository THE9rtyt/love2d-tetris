local displayHandler = {}
-------------------------------------------------------------------------------------
-- Handles drawing screen features and private vars, each section in its own function
-------------------------------------------------------------------------------------
local squareSize,squareScale
local windowX,windowY,fieldSize
local rowsX = {}
local rowsY = {}
local standard = 101


-------------
--load assets
-------------

local numbers = {
"/assets/SquareI.png",
"/assets/SquareJ.png",
"/assets/SquareL.png",
"/assets/SquareO.png",
"/assets/SquareS.png",
"/assets/SquareT.png",
"/assets/SquareZ.png",}
local squareImage = love.graphics.newArrayImage(numbers)


--------------------
--module I/O methods
--------------------
function displayHandler.init(size)--load field settings into display handler for field size
    fieldSize = size
    windowX, windowY = love.window.getMode()
    displayHandler.resize()
    love.graphics.setBackgroundColor(.6,.6,.5)
end

-------------------
--private function
-------------------

local function drawSquare(type, X,Y)
    love.graphics.drawLayer(squareImage, type, X, Y, 0,squareScale,squareScale)
end

--------------------------------------
-- public methods for drawing features
--------------------------------------
function displayHandler.resize(X,Y)--does all the math required to make drawing lines and click locationing
    if X and Y then
        windowX = X
        windowY = Y
    end

    local squareSizeX = (windowX/fieldSize.x)
    local squareSizeY = (windowY/fieldSize.y)

    if squareSizeY*fieldSize.x > windowX then --wide boi
        squareSize = squareSizeX
    else -- should be tall boi
        squareSize = squareSizeY
    end

    for i = 0,fieldSize.x,1 do
        rowsX[i] = (windowX/2 - (fieldSize.x*squareSize)/2) + squareSize*(i-1)
        --print("rowsX:"..rowsX[i].."  i:"..i)
    end
    for i = 0,fieldSize.y,1 do
        rowsY[i] = (windowY/2 + (fieldSize.y*squareSize)/2 - squareSize*(i))
        --print("rowsY:"..rowsY[i].."  i:"..i)
    end

    squareScale = squareSize/standard
end



function displayHandler.drawGame(tbl)

    --draw field background first
    love.graphics.setColor(.6,.5,.4)
    love.graphics.rectangle("fill", rowsX[0], rowsY[fieldSize.y], rowsX[fieldSize.x]-rowsX[0]+squareSize, windowY)
    love.graphics.setColor(1,1,1)

    --draw the field second
    for x=0,fieldSize.x,1 do
        for y=0,fieldSize.y,1 do
            if tbl.field[x][y] ~= 0 then
                drawSquare(tbl.field[x][y], rowsX[x], rowsY[y])
            end
        end
    end

    --draw current object third
    for i,v in ipairs({"s1","s2","s3","s4"}) do
        drawSquare(tbl.Object.type, rowsX[tbl.Object.loc.x+tbl.Object[v].x], rowsY[math.floor(tbl.Object.loc.y+tbl.Object[v].y)])
    end
end

function displayHandler.drawMenu(settings_d)

end

return displayHandler