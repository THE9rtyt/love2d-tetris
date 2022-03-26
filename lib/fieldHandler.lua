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
local rotations = {
    I = {
        function() --rotation 1
            return {
                type = 1,
                rotation = 1,
                s1 = {x=0,y=0},
                s2 = {x=1,y=0},
                s3 = {x=2,y=0},
                s4 = {x=3,y=0},
            }
        end,
        function() --rotation 2
            return {
                type = 1,
                rotation = 1,
                s1 = {x=0,y=0},
                s2 = {x=1,y=0},
                s3 = {x=2,y=0},
                s4 = {x=3,y=0},
            }
        end
    }
}

local shapeIndex = {
    function(rotation)--1 define I
        print("making an I!")
        if not rotation then
            rotation = 1
        end
        return {
            type = 1,
            rotation = 1,
            s1 = {x=0,y=0},
            s2 = {x=1,y=0},
            s3 = {x=2,y=0},
            s4 = {x=3,y=0},
        }
    end,
    function(rotation)--2 define J
        print("making an J!")
        return {
            type = 2,
            rotation = 1,
            s1 = {x=0,y=0},
            s2 = {x=1,y=0},
            s3 = {x=2,y=0},
            s4 = {x=2,y=-1}
        }
    end,
    function(rotation)--3 define L
        print("making an L!")
        return {
            type = 3,
            rotation = 1,
            s1 = {x=0,y=0},
            s2 = {x=1,y=0},
            s3 = {x=2,y=0},
            s4 = {x=0,y=-1}
        }
    end,
    function(rotation)--4 define O
        print("making an O!")
        return {
            type = 4,
            rotation = 1,
            s1 = {x=1,y=0},
            s2 = {x=2,y=0},
            s3 = {x=1,y=-1},
            s4 = {x=2,y=-1}
        }
    end,
    function()--5 define S
        print("making an S!")
        return {
            type = 5,
            rotation = 1,
            s1 = {x=1,y=0},
            s2 = {x=2,y=0},
            s3 = {x=0,y=-1},
            s4 = {x=1,y=-1}
        }
    end,
    function(rotation)--6 define T
        print("making an T!")
        return {
            type = 6,
            rotation = 1,
            s1 = {x=0,y=0},
            s2 = {x=1,y=0},
            s3 = {x=2,y=0},
            s4 = {x=1,y=-1}
        }
    end,
    function(rotation)--7 define Z
        print("making an Z!")
        return {
            type = 7,
            rotation = 1,
            s1 = {x=0,y=0},
            s2 = {x=1,y=0},
            s3 = {x=1,y=-1},
            s4 = {x=2,y=-1}
        }
    end,
}

-------------------
--private functions
-------------------
local function newObject(type_a) -- creates an object and what's left of it
    objects = objects+1
    print(objects)
    objectData[objects] = shapeIndex[type_a]()
    objectData[objects].type = type_a
    objectData[objects].loc = {
        x=2,
        y=19
    }
    objectData[objects].rotation = 0
    print(objectData[objects].type)
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