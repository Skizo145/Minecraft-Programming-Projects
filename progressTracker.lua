myModem = peripheral.wrap("back")
myModem.open(1)
trackedSignals = {}

function Display()
    for key, value in pairs(trackedSignals) do
        print(key, value)
    end
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