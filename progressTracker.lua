myModem = peripheral.wrap("back")
myModem.open(1)
trackedSignals = {}

function Display()
    term.clear()
    
    local cursorPos = {1, 1}
    for key, value in pairs(trackedSignals) do
        cursorPos[0] = 1
        cursorPos[1] = cursorPos[1] + 1
        term.setCursorPos(cursorPos[0], cursorPos[1])
        print(key, value)
    end
    cursorPos = {1, 1}
end

function WaitForMessage()
    local event, modemSide, senderChannel, replyChannel, message, senderDistance
        = os.pullEvent("modem_message")

    if (trackedSignals[replyChannel] == nil) then
        trackedSignals[replyChannel] = 0
        return
    end
    if (type(message) == "number") then
        trackedSignals[replyChannel] = message
    end
end

function Main()
    while (true) do
        WaitForMessage()
        Display()
    end
end



Main()