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
local function drawObject(Data)
    --math logic:
        --inside rows arrays: taking the location of the object and adding/subtracting the relative square placement
    --draw s1
    love.graphics.drawLayer(squareImage, Data.type, rowsX[math.floor(Data.loc.x+Data.s1.x)], rowsY[math.floor(Data.loc.y+Data.s1.y)], 0,squareScale,squareScale)
    --draw s3
    love.graphics.drawLayer(squareImage, Data.type, rowsX[math.floor(Data.loc.x+Data.s2.x)], rowsY[math.floor(Data.loc.y+Data.s2.y)], 0,squareScale,squareScale)
    --draw s3
    love.graphics.drawLayer(squareImage, Data.type, rowsX[math.floor(Data.loc.x+Data.s3.x)], rowsY[math.floor(Data.loc.y+Data.s3.y)], 0,squareScale,squareScale)
    --draw s4
    love.graphics.drawLayer(squareImage, Data.type, rowsX[math.floor(Data.loc.x+Data.s4.x)], rowsY[math.floor(Data.loc.y+Data.s4.y)], 0,squareScale,squareScale)
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

function displayHandler.drawObjects(objectData,objects)--draws the field
    drawObject(objectData[objects])--draw current object
end

function displayHandler.drawMenu(settings_d)

end

return displayHandler