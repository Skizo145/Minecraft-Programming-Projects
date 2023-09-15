myModem = peripheral.wrap("back")
myModem.open(1)
trackedSignals = {}

function Display()
    
    for (k, v) in ipairs(trackedSignals) do
        print(k, v)
    end
end

function WaitForMessage()
    local event, modemSide, senderChannel, replyChannel, message, senderDistance
        = os.pullEvent("modem_message")

    if (trackedSignals[replyChannel] == nil) then
        trackedSignals[replyChannel] = 0
        return
    end
    if (typeof(message) == "number") then
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