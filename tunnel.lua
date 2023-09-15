MaxZ = 1
CurrentZ = 0
MaxX = 1
CurrentX = 1
MaxY = 1
CurrentY = 1

Heading = "n"
PreviousUTurnDirection = "left"
SkipAirSpacesAbove = false
DigOutWidthFirst = false
DebugLevel = 3 -- 0-3

function GetFuelLevel()
    local coal = 0
    local details = turtle.getItemDetail() 
    while coal == 0 do
        print ("I have " ..turtle.getFuelLevel().. " fuel")
        print ("Would you like to add more fuel? y/n")
        input = read()
        if input("y") then
            print "Confirmed"
        else 
            print "Please add coal to slot 1"
            turtle.select(1)
            print "Please confirm when done <Enter>"
            input = read()
            if details.name ~= "minecraft.coal" then
                print "I do not see coal in slot 1"
            else 
                print "Refueling"
                turtle.refuel()
                coal = 1
            end
        end
    end
end

function Init()
    local input = ""

    print("How far should I dig?")
    MaxZ = tonumber(read())
    if (MaxZ < 1) then MaxZ = 0 end

    print("How wide should the tunnel be?")
    MaxX = tonumber(read())
    if (MaxX < 1) then MaxX = 1 end

    print("... And how tall?")
    MaxY = tonumber(read())
    if (MaxY < 1) then MaxY = 1 end

    print("Oh also should I stop digging up if there's an empty space above? (y/n)")
    input = read()
    if (input == "y" or input == "Y") then
        SkipAirSpacesAbove = true
    end

    print("Dig Length first? Or Width first? (l/w)")
    input = read()
    if (input == "w" or input == "W") then
        DigOutWidthFirst = true
    end
    
end

function TryPoke()
    if (Heading == "n" and CurrentZ < MaxZ) then
        if (DebugLevel >= 3) then print("- - (" ..CurrentZ.. "," ..CurrentX.. "," ..CurrentY.. ") Poking North") end
        turtle.dig()
        return true
    elseif (Heading == "s" and CurrentZ > 1) then
        if (DebugLevel >= 3) then print("- - (" ..CurrentZ.. "," ..CurrentX.. "," ..CurrentY.. ") Poking South") end
        turtle.dig()
        return true
    elseif (Heading == "e" and CurrentX < MaxX) then
        if (DebugLevel >= 3) then print("- - (" ..CurrentZ.. "," ..CurrentX.. "," ..CurrentY.. ") Poking East") end
        turtle.dig()
        return true
    elseif (Heading == "w" and CurrentX > 1) then
        if (DebugLevel >= 3) then print("- - (" ..CurrentZ.. "," ..CurrentX.. "," ..CurrentY.. ") Poking West") end
        turtle.dig()
        return true
    end

    return false
end
function TryAdvance()
    if (TryPoke() == false) then
        if (DebugLevel >= 2) then print("- (" ..CurrentZ.. "," ..CurrentX.. "," ..CurrentY.. ") Can't Advance") end
        return false
    end

    if (Heading == "n" and CurrentZ < MaxZ) then
        if (DebugLevel >= 2) then print("- (" ..CurrentZ.. "," ..CurrentX.. "," ..CurrentY.. ") Advancing North") end
        turtle.forward()
        CurrentZ = CurrentZ + 1
        return true
    elseif (Heading == "s" and CurrentZ > 1) then
        if (DebugLevel >= 2) then print("- (" ..CurrentZ.. "," ..CurrentX.. "," ..CurrentY.. ") Advancing South") end
        turtle.forward()
        CurrentZ = CurrentZ - 1
        return true
    elseif (Heading == "e" and CurrentX < MaxX) then
        if (DebugLevel >= 2) then print("- (" ..CurrentZ.. "," ..CurrentX.. "," ..CurrentY.. ") Advancing East") end
        turtle.forward()
        CurrentX = CurrentX + 1
        return true
    elseif (Heading == "w" and CurrentX > 1) then
        if (DebugLevel >= 2) then print("- (" ..CurrentZ.. "," ..CurrentX.. "," ..CurrentY.. ") Advancing West") end
        turtle.forward()
        CurrentX = CurrentX - 1
        return true
    end

    return false
end

function AdvanceUpward()
    if (DebugLevel >= 3) then print("- - (" ..CurrentZ.. "," ..CurrentX.. "," ..CurrentY.. ") Advancing Upward") end
    turtle.digUp()
    turtle.up()
    CurrentY = CurrentY + 1
end
function AdvanceDownward()
    if (DebugLevel >= 3) then print("- - (" ..CurrentZ.. "," ..CurrentX.. "," ..CurrentY.. ") Advancing Downward") end
    turtle.digDown()
    turtle.down()
    CurrentY = CurrentY - 1
end
function DigUpToTop()
    if (CurrentY >= MaxY) then return end

    if (DebugLevel >= 2) then print("- (" ..CurrentZ.. "," ..CurrentX.. "," ..CurrentY.. ") Digging Up To Top") end

    while (CurrentY < MaxY) do
        if (SkipAirSpacesAbove and turtle.detectUp() == false) then
            if (DebugLevel >= 3) then print("- - (" ..CurrentZ.. "," ..CurrentX.. "," ..CurrentY.. ") Detected Empty Space Above") end
            break
        end
        TryPoke()
        AdvanceUpward()
    end
end
function DigDownToOne()
    if (DebugLevel >= 2) then print("- (" ..CurrentZ.. "," ..CurrentX.. "," ..CurrentY.. ") Digging Down To Zero") end

    while (CurrentY > 1) do
        TryPoke()
        AdvanceDownward()
    end
end

function TryAdvanceTilEndOfLine()
    if (DebugLevel >= 1) then print("(" ..CurrentZ.. "," ..CurrentX.. "," ..CurrentY.. ") Beginning Line") end
    local atDestination = (not TryPoke())
    if (atDestination) then return false end
    while (not atDestination) do
        DigUpToTop()
        TryAdvance()
        DigUpToTop()
        DigDownToOne()
        if (SkipAirSpacesAbove == false) then
            TryAdvance()
        end
        atDestination = (not TryAdvance())
    end
    return true
end

function TurnRight()
    if (Heading == "n") then Heading = "e"
    elseif (Heading == "e") then Heading = "s"
    elseif (Heading == "s") then Heading = "w"
    elseif (Heading == "w") then Heading = "n"
    end
    if (DebugLevel >= 2) then print("- (" ..CurrentZ.. "," ..CurrentX.. "," ..CurrentY.. ") Turned Right. New Heading = " ..Heading) end
    turtle.turnRight()
end
function TurnLeft()
    if (Heading == "n") then Heading = "w"
    elseif (Heading == "w") then Heading = "s"
    elseif (Heading == "s") then Heading = "e"
    elseif (Heading == "e") then Heading = "n"
    end
    if (DebugLevel >= 2) then print("- (" ..CurrentZ.. "," ..CurrentX.. "," ..CurrentY.. ") Turned Left. New Heading = " ..Heading) end
    turtle.turnLeft()
end
function Turn()
    if (PreviousUTurnDirection == "left") then
        TurnRight()
    elseif (PreviousUTurnDirection == "right") then
        TurnLeft()
    end
end
function TryUTurn()    
    Turn()
    if (not TryAdvance()) then return false end
    Turn()

    if (DebugLevel >= 1) then print("(" ..CurrentZ.. "," ..CurrentX.. "," ..CurrentY.. ") UTurning. Heading = " ..Heading) end
    if (PreviousUTurnDirection == "right") then PreviousUTurnDirection = "left"
    elseif (PreviousUTurnDirection == "left") then PreviousUTurnDirection = "right" end

    return true
end



function Main()
    if (TryAdvance() == false) then
        print("aw heck you tricked me :'(")
        return
    end
    if (DigOutWidthFirst) then
        TurnRight()
        PreviousUTurnDirection = "right"
    end

    local done = false
    while (not done) do
        done = (not TryAdvanceTilEndOfLine())
        if (done) then break end
        done = (not TryUTurn())
    end

    print("I'm all done! :D")
end


Init()
Main()