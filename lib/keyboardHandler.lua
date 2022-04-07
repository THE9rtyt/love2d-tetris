local keyboardHandler = {}

local fieldHandler = require("lib.fieldHandler")



function keyboardHandler.keyPressed(key)
    if key == "s" or key == "down" then
        fieldHandler.down()
    elseif key == "right" or key == "d" then
        fieldHandler.right()
    elseif key == "left" or key == "a" then
        fieldHandler.left()
    elseif key == "z" or key == "rshift" then
        fieldHandler.cclockwise()
    elseif key == "x" or key == "return" then
        fieldHandler.clockwise()
    end
end

function keyboardHandler.keyReleased(key)
    if key == "s" or key == "down" then
        fieldHandler.down()
    end
end

return keyboardHandler