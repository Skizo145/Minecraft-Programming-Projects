local MY_MODEM = peripheral.wrap("back")
local trackedSignals = {} -- {key, value} : key is the return channel, value is the last message received.

local COLOR_DEFAULT = colors.white
local CODE_PROGRESS = 0
local COLOR_PROGRESS = colors.white
local CODE_SUCCESS = 1
local COLOR_SUCCESS = colors.lime
local CODE_FAILURE = 2
local COLOR_FAILURE = colors.red

function WaitForMessage()
    local event, modemSide, senderChannel, replyChannel, message, senderDistance
        = os.pullEvent("modem_message")
    return replyChannel, message
end

function SetTextColor(code)
    if (code == CODE_PROGRESS) then term.setTextColor(COLOR_PROGRESS)
    elseif (code == CODE_SUCCESS) then term.setTextColor(COLOR_SUCCESS)
    elseif (code == CODE_FAILURE) then term.setTextColor(COLOR_FAILURE)
    else term.setTextColor(COLOR_DEFAULT)
    end
end

function DisplaySingle(replyChannel, message)
    local code = string.sub(message, 0, 1)

    if (pcall(tonumber, code)) then
        code = tonumber(code)
        if (term.isColor()) then SetTextColor(code) end
        message = string.sub(message, 2)
    end
    if (code == CODE_PROGRESS) then
        message = tonumber(string.format("%.1f", message))
    end

    trackedSignals[replyChannel] = message

    local cursorPos = {1, 1}
    for key, value in pairs(trackedSignals) do
        if (key == replyChannel) then
            term.setCursorPos(cursorPos[1], cursorPos[2])
            term.clearLine()
            io.write(string.format("%7s -- %s", key, value))
            break
        end
        cursorPos[2] = cursorPos[2] + 1
    end

end

function Main()
    term.clear()
    term.setCursorPos(1, 1)
    MY_MODEM.open(1)

    while (true) do
        local replyChannel, message = WaitForMessage()
        DisplaySingle(replyChannel, message)
    end
end



Main()
