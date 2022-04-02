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
function displayHandler.init(x,y,size)--load field settings into display handler for field size
    fieldSize = size
    displayHandler.resize(x,y)
    love.graphics.setBackgroundColor(.5,.5,.5)
end

-------------------
--private function
-------------------

local function drawSquare(type, X,Y)
    love.graphics.drawLayer(squareImage, type, X, Y, 0,squareScale,squareScale)
end

local function drawObject(Data)
    --math logic:
        --inside rows arrays: taking the location of the object and adding/subtracting the relative square placement
    --draw s1
    drawSquare(Data.type, rowsX[Data.loc.x+Data.s1.x], rowsY[math.floor(Data.loc.y+Data.s1.y)])
    --draw s3
    drawSquare(Data.type, rowsX[Data.loc.x+Data.s2.x], rowsY[math.floor(Data.loc.y+Data.s2.y)])
    --draw s3
    drawSquare(Data.type, rowsX[Data.loc.x+Data.s3.x], rowsY[math.floor(Data.loc.y+Data.s3.y)])
    --draw s4
    drawSquare(Data.type, rowsX[Data.loc.x+Data.s4.x], rowsY[math.floor(Data.loc.y+Data.s4.y)])
end




--------------------------------------
-- public methods for drawing features
--------------------------------------
function displayHandler.resize(X,Y)--does all the math required to make drawing lines and click locationing
    windowX = X
    windowY = Y

    local squareSizeX = (windowX/fieldSize.x)
    local squareSizeY = (windowY/fieldSize.y)

    if squareSizeY*fieldSize.x > X then --wide boi
        squareSize = squareSizeX
    else -- should be tall boi
        squareSize = squareSizeY
    end

    for i = 0,fieldSize.x,1 do
        rowsX[i] = (X/2 - (fieldSize.x*squareSize)/2) + squareSize*(i-1)
        --print("rowsX:"..rowsX[i].."  i:"..i)
    end
    for i = 0,fieldSize.y,1 do
        rowsY[i] = (windowY/2 + (fieldSize.y*squareSize)/2 - squareSize*(i))
        --print("rowsY:"..rowsY[i].."  i:"..i)
    end

    squareScale = squareSize/standard
end

function displayHandler.drawObjects(currentObject)--draws the field
    drawObject(currentObject)--draw current object
end

function displayHandler.drawfield(field)
    for x=0,fieldSize.x,1 do
        for y=0,fieldSize.y,1 do
            if field[x][y] ~= 0 then
                drawSquare(field[x][y], rowsX[x], rowsY[y])
            end
        end
    end
end

function displayHandler.drawMenu(settings_d)

end

return displayHandler