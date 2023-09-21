local <const> myModem = peripheral.wrap("back")
local trackedSignals = {} -- {key, value} : key is the return channel, value is the last message received.

local <const> codeProgress = 0
local <const> codeSuccess = 1
local <const> codeFailure = 2

function WaitForMessage()
    local event, modemSide, senderChannel, replyChannel, message, senderDistance
        = os.pullEvent("modem_message")
    trackedSignals[replyChannel] = message
end

function DisplaySingle(replyChannel)
    if (pcall(tonumber(message))) then term.setTextColour(colours.white)
    elseif (type(message) == "string") then term.setTextColour(colours.green)
    end

    local cursorPos = {1, 1}
    for (key, value in pairs(trackedSignals)) do
        cursorPos[2] = cursorPos[2] + 1
        if (key == trackedSignals[replyChannel]) then
            term.setCursorPos(cursorPos[1], cursorPos[1])
            print(string.format("%6d %5d", key, value))
            cursorPos[1] = 1
        end
    end
    cursorPos = {1, 1}
end

function Main()
    term.clear()
    myModem.open(1)

    while (true) do
        WaitForMessage()
        DisplaySingle()
    end
end



Main()
