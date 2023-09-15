local myModem = peripheral.wrap("back")
local myChannel = math.random(2, 65530)
local hostChannel = 1
local percentComplete = 0

print("Opening channel: " ..myChannel)

while (percentComplete < 100) do
    if (percentComplete > 100) then
        percentComplete = 100
    end
    myModem.transmit(hostChannel, myChannel, percentComplete)
    print("sent")
    sleep(0.4)
    percentComplete = percentComplete + 18
end
