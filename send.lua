local myModem = peripheral.wrap("back")
local myChannel = math.random(2, 65530)
local hostChannel = 1

print("Opening channel: " ..myChannel)

myModem.transmit(1, myChannel, 10) 
