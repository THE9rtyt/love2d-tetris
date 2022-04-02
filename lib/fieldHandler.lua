local fieldHandler = {}

---------------------------------------------------------
-- Handles all private field vars and manages interaction
---------------------------------------------------------
local objects --number of objects on the screen
local Object = {} -- array for storing object info like squaretype, location, size and what parts are left

local fieldSize = { --basic field sizing vars
    x = 10,
    y = 20
}

local field = {}

local flags = {
    speed = .5, --sets the game speed
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

-------------------
--private functions
-------------------
local function newObject(type) -- creates an object and what's left of it
    objects = objects+1 --index to next object
    print("new object No. " .. objects)
    print("new object is: " .. type)
    Object = rotationSets[type][1] --grab rotation and cube placements for default 1 rotation
    Object.type = type --set type for future reference
    Object.loc = { x=2, y=19 } --set start location
end

local function canRotate(newRotation)
    local temp = rotationSets[Object.type][newRotation] --easier indexing and reduces [line 2 lines down] from being loooooooong
    for i,v in ipairs(sIndex) do
        if Object.loc.y  + Object[v].y - 1 <= 0 or not field[ Object.loc.x + temp[v].x ][ Object.loc.y + temp[v].y - 1 ] == 0 then
            return false
        end
    end
    return true
end

local function rotate(newRotation)
    if not canRotate(newRotation) then return end
    local temp = {}
    temp.loc = Object.loc --save location
    temp.type = Object.type --save type
    Object = rotationSets[ Object.type ][ newRotation ]--need ot figure out how to hot load the new cube placents w/o deleteing location info
    Object.loc = temp.loc --reload location
    Object.type = temp.type --reload type
end

local function canStep()
    for i,v in ipairs(sIndex) do
        print(field[ Object.loc.x + Object[v].x ][ Object.loc.y  + Object[v].y - 1 ])
        if Object.loc.y  + Object[v].y - 1 <= 0 or field[ Object.loc.x + Object[v].x ][ Object.loc.y  + Object[v].y - 1 ] ~= 0 then
            return false
        end
    end
    return true
end

local function saveObject()
    for i,v in ipairs(sIndex) do
        print("saving", v)
        field[Object.loc.x + Object[v].x][Object.loc.y  + Object[v].y] = Object.type
    end
end

--------------------
--module I/O methods
--------------------
function fieldHandler.Init()
    objects = 0
    newObject(2)
    fieldHandler.resetField()
    print(Object.s1.x)
end

function fieldHandler.getField()
    return field
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
function fieldHandler.resetField() -- clears field data to empty spaces with nil object
    objects = 0

    for x=0,fieldSize.x,1 do
        field[x] = {}
        for y=0,fieldSize.y do
            field[x][y] = 0 --0 so there is nothing there and gets read as `false`
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

function fieldHandler.right()
    if Object.loc.x < 7 then
        print("going right")
        Object.loc.x = Object.loc.x + 1
    end
end

function fieldHandler.left()
    if Object.loc.x > 0 then
        print("going left")
        Object.loc.x = Object.loc.x - 1
    end
end

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
function fieldHandler.update(tElapsed)-- this function handles all movement of the currentObject that is moving
    --math logic: total time divided by the speed setting, rounded and turned to 0/1
    --when runSpeed == 1, it is 1 step per second
    if math.floor(tElapsed/runSpeed)%2 ~= flags.step then -- clear to tick
        --print(math.floor(tElapsed/runSpeed)%2, flags.step)
        if flags.rotation ~= 0 then --roation flag set nonzero, so we check if can rotate and then rotate
            print("rotating", Object.rotation)
            Object.rotation = Object.rotation + flags.rotation
            if Object.rotation > 4 then --rotation check done in rotate()
                rotate(1)
            elseif Object.rotation < 1 then
                rotate(4)
            else
                rotate(Object.rotation)
            end
            flags.rotation = 0
        end

        flags.step = math.floor(tElapsed/runSpeed)%2
        if canStep() then
                print("stepping!")
                Object.loc.y = Object.loc.y-1
        else --cannot step
            saveObject()--save object placement to field and makke a new object
            --need to check for a complete line
            newObject(math.random(1,7))
        end
    end
end

return fieldHandler