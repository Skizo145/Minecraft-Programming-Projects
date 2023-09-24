local MY_MODEM = peripheral.wrap("back")
local trackedSignals = {} -- {key, value} : key is the return channel, value is the last message received.

local CODE_PROGRESS = 0
local COLOR_PROGRESS = colors.gray
local CODE_SUCCESS = 1
local COLOR_SUCCESS = colors.green
local CODE_FAILURE = 2
local COLOR_FAILURE = colors.red

function WaitForMessage()
    local event, modemSide, senderChannel, replyChannel, message, senderDistance
        = os.pullEvent("modem_message")
    return replyChannel, message
end

function SetTextColour(code)
    if (code == CODE_PROGRESS) then term.setTextColor(COLOR_PROGRESS)
    elseif (code == CODE_SUCCESS) then term.setTextColor(COLOR_SUCCESS)
    elseif (code == CODE_FAILURE) then term.setTextColor(COLOR_FAILURE)
    end
end

function DisplaySingle(replyChannel, message)
    local code = string.sub(message, 1, 1)
    if (pcall(tonumber(code))) then
        SetTextColour(code)
        message = string.sub(message, 2)
    end

    local cursorPos = {1, 1}
    for key, value in pairs(trackedSignals) do
        if (key == trackedSignals[replyChannel]) then
            term.setCursorPos(cursorPos[1], cursorPos[2])
            term.clearLine()
            print(string.format("%6d %5d", key, value))
            cursorPos[1] = 1
        end
        cursorPos[2] = cursorPos[2] + 1
    end
    cursorPos = {1, 1}
end

function Main()
    term.clear()
    MY_MODEM.open(1)

    while (true) do
        local replyChannel, message = WaitForMessage()
        DisplaySingle(replyChannel, message)
    end
end



Main()
