local maxZ = 0
local maxX = 1
local maxY = 1
local currentZ = 0
local currentX = 1
local currentY = 1
local blocksTraveledZ = 0
local blocksTraveledX = 0
local blocksTraveledY = 0

local heading = "n"
local previousUTurnDirection = "left"
local skipAirSpacesAbove = false
local digOutWidthFirst = false

local MY_MODEM = peripheral.wrap("right")
local MY_CHANNEL = math.random(100, 65530)
local HOST_CHANNEL = 1
local CODE_PROGRESS = 0
local CODE_SUCCESS = 1
local CODE_FAILURE = 2
local SUCCESS_MESSAGES = {"I'm done!", "Done :D", "All finished ^.^", "*Dances*"}
local ERROR_MESSAGES = {"Help plz", "x.x *dead*", "is stuck :(", "aw hec", "heckin stuck", "I can't do it :'("}

local debugLevel = 0 -- 0-3



function Transmit(codeNumber, message)
    MY_MODEM.transmit(HOST_CHANNEL, MY_CHANNEL, (codeNumber .. message))
end
function TransmitSuccess()
    Transmit(CODE_SUCCESS, SUCCESS_MESSAGES[math.random(#SUCCESS_MESSAGES)])
end
function TransmitFailure()
    Transmit(CODE_FAILURE, ERROR_MESSAGES[math.random(#ERROR_MESSAGES)])
end

function GetPercentageComplete()
    return ((blocksTraveledZ * maxY) + (blocksTraveledX * maxY) + blocksTraveledY)
        / (maxZ * maxX * maxY) * 100 - maxY
end
function TakeAction(nameOfAction)
    if (nameOfAction == "dig") then turtle.dig() return
    elseif (nameOfAction == "digUp") then turtle.digUp() return
    elseif (nameOfAction == "digDown") then turtle.digDown() return
    elseif (nameOfAction == "turnRight") then turtle.turnRight() return
    elseif (nameOfAction == "turnLeft") then turtle.turnLeft() return
    end
    
    if (nameOfAction == "forward") then turtle.forward()
    elseif (nameOfAction == "up") then turtle.up()
    elseif (nameOfAction == "down") then turtle.down()
    end
    Transmit(CODE_PROGRESS, GetPercentageComplete())
end

function Prompt()
    local input = ""
    term.clear()
    term.setCursorPos(1, 1)

    print("*Beep boop* OMG hi nice to meet you ^.^ I'm a lil helper that can dig out big chunks of blocks :3")
    print("Thing is though I'm kinda dumb and idk where I am X.X plz tell me how much to dig cuz I can't see anything lol")
    print()

    print("How far forward should I dig?")
    maxZ = tonumber(read())
    if (maxZ < 1) then maxZ = 0 end

    print("aaand how wide do you want it? :3")
    maxX = tonumber(read())
    if (maxX < 1) then maxX = 1 end

    print("ok last question! How high up? ^.^")
    maxY = tonumber(read())
    if (maxY < 1) then maxY = 1 end

    print("Oh also! Should I stop digging up if there's an empty space above me? (y/n)")
    input = read()
    if (input == "y" or input == "Y") then
        skipAirSpacesAbove = true
    end

    print("Wait one more question sowwy x//x umm do you want me to dig long-ways or wide-ways? (l/w)")
    input = read()
    if (input == "w" or input == "W") then
        digOutWidthFirst = true
    end

    print()
    print("kk that's all! I'll try my best for you master ^//^")
    print("Oh my channel is " ..MY_CHANNEL.. " btw if you ever need me uwu~")
end

function TryPoke()
    if (heading == "n" and currentZ < maxZ) then
        if (debugLevel >= 3) then print("- - (" ..currentZ.. "," ..currentX.. "," ..currentY.. ") Poking North") end
        TakeAction("dig")
        return true
    elseif (heading == "s" and currentZ > 1) then
        if (debugLevel >= 3) then print("- - (" ..currentZ.. "," ..currentX.. "," ..currentY.. ") Poking South") end
        TakeAction("dig")
        return true
    elseif (heading == "e" and currentX < maxX) then
        if (debugLevel >= 3) then print("- - (" ..currentZ.. "," ..currentX.. "," ..currentY.. ") Poking East") end
        TakeAction("dig")
        return true
    elseif (heading == "w" and currentX > 1) then
        if (debugLevel >= 3) then print("- - (" ..currentZ.. "," ..currentX.. "," ..currentY.. ") Poking West") end
        TakeAction("dig")
        return true
    end

    return false
end
function TryAdvance()
    if (TryPoke() == false) then
        if (debugLevel >= 2) then print("- (" ..currentZ.. "," ..currentX.. "," ..currentY.. ") Can't Advance") end
        return false
    end

    if (heading == "n" and currentZ < maxZ) then
        if (debugLevel >= 2) then print("- (" ..currentZ.. "," ..currentX.. "," ..currentY.. ") Advancing North") end
        TakeAction("forward")
        currentZ = currentZ + 1
        blocksTraveledZ = blocksTraveledZ + 1
        blocksTraveledY = 0
        return true
    elseif (heading == "s" and currentZ > 1) then
        if (debugLevel >= 2) then print("- (" ..currentZ.. "," ..currentX.. "," ..currentY.. ") Advancing South") end
        TakeAction("forward")
        currentZ = currentZ - 1
        blocksTraveledZ = blocksTraveledZ + 1
        blocksTraveledY = 0
        return true
    elseif (heading == "e" and currentX < maxX) then
        if (debugLevel >= 2) then print("- (" ..currentZ.. "," ..currentX.. "," ..currentY.. ") Advancing East") end
        TakeAction("forward")
        currentX = currentX + 1
        blocksTraveledX = blocksTraveledX + 1
        blocksTraveledY = 0
        return true
    elseif (heading == "w" and currentX > 1) then
        if (debugLevel >= 2) then print("- (" ..currentZ.. "," ..currentX.. "," ..currentY.. ") Advancing West") end
        TakeAction("forward")
        currentX = currentX - 1
        blocksTraveledX = blocksTraveledX + 1
        blocksTraveledY = 0
        return true
    end

    return false
end

function AdvanceUpward()
    if (debugLevel >= 3) then print("- - (" ..currentZ.. "," ..currentX.. "," ..currentY.. ") Advancing Upward") end
    TakeAction("digUp")
    TakeAction("up")
    currentY = currentY + 1
    blocksTraveledY = blocksTraveledY + 1
end
function AdvanceDownward()
    if (debugLevel >= 3) then print("- - (" ..currentZ.. "," ..currentX.. "," ..currentY.. ") Advancing Downward") end
    TakeAction("digDown")
    TakeAction("down")
    currentY = currentY - 1
    blocksTraveledY = blocksTraveledY + 1
end
function DigUpToTop()
    if (currentY >= maxY) then return end
    if (debugLevel >= 2) then print("- (" ..currentZ.. "," ..currentX.. "," ..currentY.. ") Digging Up To Top") end

    while (currentY < maxY) do
        if (skipAirSpacesAbove and turtle.detectUp() == false) then
            if (debugLevel >= 3) then print("- - (" ..currentZ.. "," ..currentX.. "," ..currentY.. ") Detected Empty Space Above") end
            break
        end
        TryPoke()
        AdvanceUpward()
    end
end
function DigDownToOne()
    if (debugLevel >= 2) then print("- (" ..currentZ.. "," ..currentX.. "," ..currentY.. ") Digging Down To Zero") end

    while (currentY > 1) do
        TryPoke()
        AdvanceDownward()
    end
end

function TryAdvanceTilEndOfLine()
    if (debugLevel >= 1) then print("(" ..currentZ.. "," ..currentX.. "," ..currentY.. ") Beginning Line") end
    local atDestination = (not TryPoke())
    if (atDestination) then return false end
    
    while (not atDestination) do
        DigUpToTop()
        TryAdvance()
        DigUpToTop()
        DigDownToOne()
        if (skipAirSpacesAbove == false) then
            TryAdvance()
        end
        atDestination = (not TryAdvance())
    end
    return true
end

function TurnRight()
    if (heading == "n") then heading = "e"
    elseif (heading == "e") then heading = "s"
    elseif (heading == "s") then heading = "w"
    elseif (heading == "w") then heading = "n"
    end
    if (debugLevel >= 2) then print("- (" ..currentZ.. "," ..currentX.. "," ..currentY.. ") Turned Right. New Heading = " ..heading) end
    TakeAction("turnRight")
end
function TurnLeft()
    if (heading == "n") then heading = "w"
    elseif (heading == "w") then heading = "s"
    elseif (heading == "s") then heading = "e"
    elseif (heading == "e") then heading = "n"
    end
    if (debugLevel >= 2) then print("- (" ..currentZ.. "," ..currentX.. "," ..currentY.. ") Turned Left. New Heading = " ..heading) end
    TakeAction("turnLeft")
end
function Turn()
    if (previousUTurnDirection == "left") then
        TurnRight()
    elseif (previousUTurnDirection == "right") then
        TurnLeft()
    end
end
function TryUTurn()
    Turn()
    if (not TryAdvance()) then return false end
    Turn()

    if (debugLevel >= 1) then print("(" ..currentZ.. "," ..currentX.. "," ..currentY.. ") UTurning. Heading = " ..heading) end
    if (previousUTurnDirection == "right") then previousUTurnDirection = "left"
    elseif (previousUTurnDirection == "left") then previousUTurnDirection = "right" end

    return true
end

function Main()
    if (TryAdvance() == false) then
        TransmitFailure()
        print("aw heck you tricked me :'(")
        return
    end
    if (digOutWidthFirst) then
        TurnRight()
        previousUTurnDirection = "right"
    end

    while (true) do
        if (not TryAdvanceTilEndOfLine()) then break end
        if (not TryUTurn()) then break end
    end

    TransmitSuccess()
    print(SUCCESS_MESSAGES[math.random(#SUCCESS_MESSAGES)])
end

function DoIhaveEnoughFuel()
    local fuel = turtle.getFuelLevel()
    if (fuel < (maxZ * maxX * maxY)) then
        print("I dont have enough fuel for that... Plz fill me daddy >.<")
        sleep(2)
        print("I need at least " ..((maxZ * maxX * maxY) - fuel).. " more")
        sleep(1)
        print("Press enter when you are done filling me up UwU")
        read()
        shell.run("refuel all")
    end
end



Prompt()
DoIhaveEnoughFuel()
Main()
