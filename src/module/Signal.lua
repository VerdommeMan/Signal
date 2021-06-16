local Connection = {}
local Signal = {}

Connection.__index = Connection
Signal.__index = Signal

local weakMT = {__mode = "k"}
local connections = setmetatable({}, weakMT)
local map = setmetatable({}, weakMT)

function Connection.new(signal)
    local self = setmetatable({Connected = true}, Connection)
    map[self] = signal
    return self
end

function Connection:Disconnect()
    connections[map[self]][self] = nil
    self.Connected = false
end

function Signal.new()
    local self = {}
    connections[self] = {}
    return setmetatable(self, Signal)
end

function Signal:Wait()
    local SENTINEL = {}
    local connection
    local currentThread = coroutine.running()

    connection = self:Connect(function(...)
        connection:Disconnect()
        coroutine.resume(currentThread, SENTINEL, ...)
    end)

    while true do
        local args = {coroutine.yield()}
        if args[1] == SENTINEL then
          return unpack(args, 2)
        end
    end
end

local function printErr(err, thread)
    warn(err)
    local s = pcall(function() -- cant rely on format of traceback
        print("Stack Begin")
        local lines = debug.traceback(thread):split("\n")
        for i, line in ipairs(lines) do
           if i == #lines then continue end -- thx roblox for adding a unneccesary newline
            print(line)
        end
        print("Stack End")
    end)
    
    if not s then
        warn("debug.traceback has changed the format, this function must be updated")
    end
end

function Signal:Fire(...)
    for _, callback in pairs(connections[self]) do
        local thread = coroutine.create(callback)
        local s, msg = coroutine.resume(thread, ...)
        if not s then
            printErr(msg, thread)
        end
    end
end

function Signal:Connect(callback)
    local connection = Connection.new(self)
    connections[self][connection] = callback
    return connection
end

return Signal