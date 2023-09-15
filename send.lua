local modem = peripheral.wrap("back") -- Wraps the modem on the right side.
modem.transmit(3, 1, "Hello world!") 

--peripheral.call("right", "transmit", 3, 1, "This will also work!")
