local fieldHandler   = require("lib.fieldHandler")
local displayHandler = require("lib.displayHandler")

--[[mouse stuff, now fully contained in the function, and like 30 less loops and ifs! woo for 3d Arrays
game loss to show all mines, and defeat anymore clicking
using the repeat commands allows it to scale to the size of the array, which changes based on game size

    update, it's now a library woo


local mouseHandler = {}
local rowsX = {}
local rowsY = {}
local topBar,windowX,windowY,fieldX,fieldY,menuRect,menuNumSpacing
local topBarMenuitems


-----------------------------------------
-- I/O Methods
-----------------------------------------
function mouseHandler.init(settings)--load field settings into display handler for field size
    fieldX = settings.fieldX
    fieldY = settings.fieldY
    --rowsX,rowsY,topBar,windowX,windowY,menuRect,menuNumSpacing = displayHandler.GetWindowInfo() --mouseHandler tags off of math that the displayHandler does
    topBarMenuitems = {
        settings = 170+topBar,
        reset = 500+topBar
    }
    print("mouseHandler Intialized!")
end

-------------------
--private function
-------------------
local function findRow(clickLocation,rowArray,fieldLength)
    for ArrayLook = 0,fieldLength,1 do
        if clickLocation < (rowArray[ArrayLook]+displayHandler.getCubeWidth()) then
            return ArrayLook
        end
    end --this function should never get to the end of this loop
    return 0 -- in the event it makes it here, we give it a number that will make it do nothing
end

local function limit(var,change)
    if var+change > 99 or 1 > var+change then
        return var
    else
        return var+change
    end
end

----------------------------------------
-- public method for Mouse Click Events
----------------------------------------
function mouseHandler.mousePress(x,y, button,status)
    print("click X:" .. x .. " Y:" .. y .. " button:" .. button)
    local clickX = findRow(x,rowsX,fieldX)
    local clickY = findRow(y,rowsY,fieldY)
    print("click X:" .. clickX .. " Y:" .. clickY)
    if status.menu then
        if clickY == 0 and y <= topBar then
            if x < (topBarMenuitems.settings) and x> 170 then--settings button hit
                print('settingsHit!')
                status.menu = false
                status.resetNeeded = true
            end
        else
            print('menu stuff')
            --nothing to add atm
        end
    else
        if clickY == 0 and y <= topBar then
            if x > 170 then -- 170 is pixels width of timer in corner
                if x < (topBarMenuitems.settings) then--settings button hit
                    print('settingsHit!')
                    status.menu = true
                elseif x < windowX-170 and x > topBarMenuitems.reset then
                    print('resetHit!')
                    fieldHandler.resetField()
                    status.gameEnded = false
                    status.clicked = false
                    status.inPlay = false
                    status.timeElapsed = 0
                end
            end
        elseif ((clickX < 1 or clickX > fieldX) or (clickY < 1 or clickY > fieldY)) then
            print("click not on minefield!")
        elseif button == 3 then
            print("middle click!")
            fieldHandler.resetField()
            status.gameEnded = false
            status.clicked = false
            status.timeElapsed = 0
        else
            if not status.gameEnded then --Game is not ended
                if not status.clicked then -- is the field hasn't been clicked
                    status.clicked = true --it has now been clicked
                    fieldHandler.generate()
                    status.inPlay = true --begin play
                end
                status.gameEnded = fieldHandler.click(clickX,clickY,button)
            end
        end
    end
print("EndTurn")
return status
end

function mouseHandler.wheelmoved(x,y, settings)
    local mouseX, mouseY = love.mouse.getPosition()
    --settings.fieldY = limit(settings.fieldY,y)
    if mouseY > windowY/2-menuRect.y/2 and mouseY < windowY/2+menuRect.y/2 then
        if mouseX > windowX/2-menuRect.x/2-menuNumSpacing and mouseX < windowX/2+menuRect.x/2-menuNumSpacing then
            settings.fieldX = limit(settings.fieldX,y)
        end
        if mouseX > windowX/2-menuRect.x/2 and mouseX < windowX/2+menuRect.x/2 then
        settings.fieldY = limit(settings.fieldY,y)
        end
        if mouseX > windowX/2-menuRect.x/2+menuNumSpacing and mouseX < windowX/2+menuRect.x/2+menuNumSpacing then
            settings.Mines = limit(settings.Mines,y)
        end
    end
    return settings
end

return mouseHandler]]