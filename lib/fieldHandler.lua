local fieldHandler = {}

---------------------------------------------------------
-- Handles all private field vars and manages interaction
---------------------------------------------------------
local objects --number of objects on the screen
local objectData = {} -- array for storing object info like squaretype, location, size and what parts are left
local field = {} --acts as a interference lookup and displayHandler aid

local fieldSize = { --basic field sizing vars
    x = 10,
    y = 20
}

local squareType = { --object shape to number for drawing
    none = 0,
    I = 1,
    J = 2,
    L = 3,
    O = 4,
    S = 5,
    T = 6,
    Z = 7,
}

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
            s4 = {x=3,y=0},
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
            s4 = {x=0,y=-1},
        },
        { -- rotation 4
            rotation = 4,
            s1 = {x=1,y=-1},
            s2 = {x=1,y=0},
            s3 = {x=1,y=1},
            s4 = {x=2,y=-1},
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
    objectData[objects] = rotationSets[type][1] --grab rotation and cube placements for default 1 rotation
    objectData[objects].type = type --set type for future reference
    objectData[objects].loc = { x=2, y=19 } --set start location
end

--------------------
--module I/O methods
--------------------
function fieldHandler.Init()
    objects = 0
    newObject(1)
end

function fieldHandler.getSize()
    return fieldSize
end

function fieldHandler.getObjects()
    return objectData,objects
end

function fieldHandler.fieldSize()
    return fieldSize
end

----------------------------------
-- public methods for field Events
----------------------------------
function fieldHandler.resetField() -- clears field data to empty spaces with nil object
    for i = 1,fieldSize.x*fieldSize.y,1 do
        field[i] = nil
    end
    objects = 0
end

function fieldHandler.update(t)
    if objectData[objects].loc.y > 3 then
        objectData[objects].loc.y = objectData[objects].loc.y-t*.05
    end
end

return fieldHandler