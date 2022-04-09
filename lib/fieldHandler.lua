local fieldHandler = {}

---------------------------------------------------------
-- Handles all private field vars and manages interaction
---------------------------------------------------------
local objects, nextObject --number of objects on the screen
local Object = {} -- array for storing object info like squaretype, location, size and what parts are left



local fieldSize = { --basic field sizing vars
    x = 9,
    y = 20
}

local field = {}

local flags = {
    speed = .3, --sets the game speed
    step = 0, --step of the game. flips between 1/0 every second

    fastDown = false, --whether or not rapid down is enabled
    rotation = 0, --the current rotation to be executed at the next possible step
    movement = 0 --the current movement to be executed at the next possible step

}
local runSpeed = flags.speed

local sIndex = {"s1", "s2", "s3", "s4"} --table to allow indexing through the 4 squares of an object

--[[
    the idea here is to store each rotation of each shape in a large array.

    this array is to be referenced for testing rotation clearences and setting an object to a rotation.
]]
local rotationSets = {
    { --type 1, I
        { -- rotation 1
            rotation = 1,
            s1 = {x=0,y=0},
            s2 = {x=1,y=0},
            s3 = {x=2,y=0},
            s4 = {x=3,y=0},
        },
        { -- rotation 2
            rotation = 2,
            s1 = {x=1,y=2},
            s2 = {x=1,y=1},
            s3 = {x=1,y=0},
            s4 = {x=1,y=-1},
        },
        { -- rotation 3
            rotation = 3,
            s1 = {x=3,y=1},
            s2 = {x=2,y=1},
            s3 = {x=1,y=1},
            s4 = {x=0,y=1},
        },
        { -- rotation 4
            rotation = 4,
            s1 = {x=2,y=-1},
            s2 = {x=2,y=0},
            s3 = {x=2,y=1},
            s4 = {x=2,y=2},
        },
    },
    { --type 2, J
        { --rotation 1
            rotation = 1,
            s1 = {x=0,y=0},
            s2 = {x=1,y=0},
            s3 = {x=2,y=0},
            s4 = {x=2,y=-1},
        },
        { --rotation 2
            rotation = 2,
            s1 = {x=1,y=1},
            s2 = {x=1,y=0},
            s3 = {x=1,y=-1},
            s4 = {x=0,y=-1},
        },
        { -- rotation 3
            rotation = 3,
            s1 = {x=2,y=0},
            s2 = {x=1,y=0},
            s3 = {x=0,y=0},
            s4 = {x=0,y=1},
        },
        { -- rotation 4
            rotation = 4,
            s1 = {x=1,y=-1},
            s2 = {x=1,y=0},
            s3 = {x=1,y=1},
            s4 = {x=2,y=1},
        }
    },
    { --type 3, L
        { --rotation 1
            rotation = 1,
            s1 = {x=0,y=0},
            s2 = {x=1,y=0},
            s3 = {x=2,y=0},
            s4 = {x=0,y=-1},
        },
        { --rotation 2
            rotation = 2,
            s1 = {x=1,y=-1},
            s2 = {x=1,y=0},
            s3 = {x=1,y=1},
            s4 = {x=0,y=1},
        },
        { -- rotation 3
            rotation = 3,
            s1 = {x=2,y=0},
            s2 = {x=1,y=0},
            s3 = {x=0,y=0},
            s4 = {x=2,y=1},
        },
        { -- rotation 4
            rotation = 4,
            s1 = {x=1,y=-1},
            s2 = {x=1,y=0},
            s3 = {x=1,y=1},
            s4 = {x=2,y=-1},
        }
    },
    { --type 4, O
        { --rotation 1
            rotation = 1,
            s1 = {x=1,y=0},
            s2 = {x=2,y=0},
            s3 = {x=1,y=-1},
            s4 = {x=2,y=-1},
        },
        { --rotation 2
            rotation = 2,
            s1 = {x=2,y=0},
            s2 = {x=2,y=-1},
            s3 = {x=1,y=0},
            s4 = {x=1,y=-1},
        },
        { -- rotation 3
            rotation = 3,
            s1 = {x=2,y=-1},
            s2 = {x=1,y=-1},
            s3 = {x=2,y=0},
            s4 = {x=1,y=0},
        },
        { -- rotation 4
            rotation = 4,
            s1 = {x=1,y=-1},
            s2 = {x=1,y=0},
            s3 = {x=2,y=-1},
            s4 = {x=2,y=0},
        }
    },
    { --type 5, S
        { --rotation 1
            rotation = 1,
            s1 = {x=1,y=0},
            s2 = {x=2,y=0},
            s3 = {x=0,y=-1},
            s4 = {x=1,y=-1},
        },
        { --rotation 2
            rotation = 2,
            s1 = {x=1,y=0},
            s2 = {x=1,y=-1},
            s3 = {x=0,y=1},
            s4 = {x=0,y=0},
        },
        { -- rotation 3
            rotation = 3,
            s1 = {x=1,y=-1},
            s2 = {x=0,y=-1},
            s3 = {x=2,y=0},
            s4 = {x=1,y=0},
        },
        { -- rotation 4
            rotation = 4,
            s1 = {x=0,y=0},
            s2 = {x=0,y=1},
            s3 = {x=1,y=-1},
            s4 = {x=1,y=0},
        }
    },
    { --type 6, T
        { --rotation 1
            rotation = 1,
            s1 = {x=0,y=0},
            s2 = {x=1,y=0},
            s3 = {x=2,y=0},
            s4 = {x=1,y=-1},
        },
        { --rotation 2
            rotation = 2,
            s1 = {x=1,y=1},
            s2 = {x=1,y=0},
            s3 = {x=1,y=-1},
            s4 = {x=0,y=0},
        },
        { -- rotation 3
            rotation = 3,
            s1 = {x=2,y=0},
            s2 = {x=1,y=0},
            s3 = {x=0,y=0},
            s4 = {x=1,y=1},
        },
        { -- rotation 4
            rotation = 4,
            s1 = {x=1,y=-1},
            s2 = {x=1,y=0},
            s3 = {x=1,y=1},
            s4 = {x=2,y=0},
        }
    },
    { --type 6, Z
        { --rotation 1
            rotation = 1,
            s1 = {x=0,y=0},
            s2 = {x=1,y=0},
            s3 = {x=1,y=-1},
            s4 = {x=2,y=-1},
        },
        { --rotation 2
            rotation = 2,
            s1 = {x=1,y=1},
            s2 = {x=1,y=0},
            s3 = {x=0,y=0},
            s4 = {x=0,y=-1},
        },
        { -- rotation 3
            rotation = 3,
            s1 = {x=2,y=-1},
            s2 = {x=1,y=-1},
            s3 = {x=1,y=0},
            s4 = {x=0,y=0},
        },
        { -- rotation 4
            rotation = 4,
            s1 = {x=0,y=-1},
            s2 = {x=0,y=0},
            s3 = {x=1,y=0},
            s4 = {x=1,y=1},
        }
    }
}

local function protect(tbl) --used to set variables to read-only
    return setmetatable({}, {
        __index = tbl,
        __newindex = function(t, key, value)
            error("attempting to change constant " ..
                   tostring(key) .. " to " .. tostring(value), 2)
        end
    })
end
protect(fieldSize)
protect(sIndex)
protect(rotationSets)

-------------------
--private functions
-------------------

local function newObject(type) -- creates an object and what's left of it
    objects = objects+1 --index to next object
    nextObject = love.math.random(1,7) --ready next Object

    print("new object No. " .. objects)
    print("new object is: " .. type)
    Object = rotationSets[type][1] --grab rotation and cube placements for default 1 rotation
    Object.type = type --set type for future reference
    Object.loc = { x=3, y=19 } --set start location
end

local function checkPosition(LocX,LocY,rotation,type)
    local temp = rotationSets[type][rotation]
    for _,v in ipairs(sIndex) do
        local X = LocX + temp[v].x
        local Y = LocY + temp[v].y
        if ((X < 0 or X > fieldSize.x) or (Y < 1 or Y > fieldSize.y)) or field[ X ][ Y ] ~= 0 then
            return false
        end
    end
    return true
end

local function saveObject()
    for _,v in ipairs(sIndex) do
        field[Object.loc.x + Object[v].x][Object.loc.y  + Object[v].y] = Object.type
    end
end

local function checkLines()
    local temp = {}
    --bring every line into a table
    for _,v in ipairs(sIndex) do
        table.insert(temp,Object.loc.y+Object[v].y)
    end

    --remove duplicate lines numbers
    local lines = {}
    local hash = {}
    for _,v in ipairs(temp) do
        if not hash[v] then
            lines[#lines+1] = v
            hash[v] = true
        end
    end
    temp = {}
    print("lines minimized " .. #lines .. " to check")
    
    --and check lines that might have been completed
    for _,v in ipairs(lines) do
        local complete = true
        for x=0,fieldSize.x,1 do
            if field[x][v] == 0 then
                complete = false
                break
            end
        end
        if complete then
            table.insert(temp,v)
        end
    end
    return temp
end

local function clearLines(lines)
    local highest = lines[1]
    for _,v in ipairs(lines) do
        for x=0,fieldSize.x,1 do
            field[x][v] = 0
        end
        if v > highest then
            highest = v
        end
    end
    for y=highest,fieldSize.y,1 do
        for x=0,fieldSize.x,1 do
            field[x][y-#lines] = field[x][y]
            field[x][y] = 0
        end
    end
end

--------------------
--module I/O methods
--------------------
function fieldHandler.Init()
    objects = 0
    fieldHandler.beginGame()
    print(Object.s1.x)
end

function fieldHandler.getDisplayInfo()
    return {
        field = field,
        Object = Object
    }
end

function fieldHandler.getSize()
    return fieldSize
end

function fieldHandler.getObjects()
    return Object
end

----------------------------------
-- public methods for field Events
----------------------------------
function fieldHandler.beginGame()
    objects = 0
    fieldHandler.resetField()

    nextObject = love.math.random(1,7)
    newObject(nextObject)
end

function fieldHandler.resetField() --clears field data to empty spaces
    for x=0,fieldSize.x,1 do
        field[x] = {}
        for y=0,fieldSize.y do
            field[x][y] = 0 --0 so there is nothing there
        end
    end
end

function fieldHandler.down()
    flags.fastDown = not flags.fastDown --distance to travel this step
    if flags.fastDown then
        runSpeed = flags.speed/3
    else
        runSpeed = flags.speed
    end
end

--left/right inputs to set movement flag
function fieldHandler.right()
    flags.movement = 1
end
function fieldHandler.left()
    flags.movement = -1
end

--ccw/cw inputs to set rotation flag
function fieldHandler.cclockwise()
    print("counter clockwise!")
    if flags.rotation >= 0 then
        flags.rotation = -1
    end
end
function fieldHandler.clockwise()
    print("clockwise!")
    if flags.rotation <= 0 then
        flags.rotation = 1
    end
end

-- the main field handling happens here.
function fieldHandler.update(status)-- this function handles all movement of the currentObject that is moving

    if flags.rotation ~= 0 then --rotation flag set nonzero, so we check if can rotate and then rotate
        print("rotating", Object.rotation)
        local newRotation = Object.rotation + flags.rotation
        if newRotation > 4 then --seta 5 -> 1 and 0 -> 4
            newRotation = 1
        elseif newRotation < 1 then
            newRotation = 4
        end

        if checkPosition(Object.loc.x,Object.loc.y,newRotation,Object.type) then
            local temp = {}
            temp.loc = Object.loc --save location
            temp.type = Object.type --save type
            Object = rotationSets[ Object.type ][ newRotation ]--need to figure out how to hot load the new cube placents w/o deleteing location info
            Object.loc = temp.loc --reload location
            Object.type = temp.type --reload type
        end

        flags.rotation = 0
    end

    if flags.movement ~= 0 then --movement flag set nonzero, so we check if can move and then move
        print("moving", Object.loc.x, Object.loc.y)
        if checkPosition(Object.loc.x + flags.movement,Object.loc.y,Object.rotation,Object.type) then
            Object.loc.x = Object.loc.x + flags.movement
        end

        flags.movement = 0
    end

    --math logic: total time divided by the speed setting, rounded and turned to 0/1
    --when runSpeed == 1, it is 1 step per second
    if math.floor(status.tElapsed/runSpeed)%2 ~= flags.step then -- clear to step
        --print(math.floor(tElapsed/runSpeed)%2, flags.step)
        flags.step = math.floor(status.tElapsed/runSpeed)%2
        if checkPosition(Object.loc.x,Object.loc.y-1,Object.rotation,Object.type) then
            print("stepping!")
            Object.loc.y = Object.loc.y-1
        else --cannot step
            saveObject()--save object placement to field and make a new object
            local lines = checkLines()
            if lines[1] then --if lines is set, ther is atleast 1 line to clear
                status.score = status.score + #lines
                clearLines(lines)
                print(status.score)
            end
            --need to check for a complete line
            newObject(nextObject)
        end
    end
    return status
end --function fieldHandler.update

return fieldHandler