sleep(1)
print()"Deleting old programs...")
shell.run("delete test")
shell.run("delete tunnel")
sleep(1)
print()"Reinitialising...")
shell.run("pastebin get 5rau3jQ3 tunnel")
sleep(1)
print()"Starting new program")
sleep(1)
shell.run("tunnel")