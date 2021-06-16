local Connection = {}
local Signal = {}

Connection.__index = Connection
Signal.__index = Signal

local weakMT = {__mode = "k"}
local connections = setmetatable({}, weakMT)
local map = setmetatable({}, weakMT)

function Connection.new(signal)
    local self = setmetatable({connected = true}, Connection)
    map[self] = signal
    return self
end

function Connection:disconnect()
    connections[map[self]][self] = nil
    self.connected = false
end

function Signal.new()
    local self = {}
    connections[self] = {}
    return setmetatable(self, Signal)
end

function Signal:wait()
    local SENTINEL = {}
    local connection
    local currentThread = coroutine.running()

    connection = self:connect(function(...)
        connection:disconnect()
        coroutine.resume(currentThread, SENTINEL, ...)
    end)

    while true do
        local args = {coroutine.yield()}
        if args[1] == SENTINEL then
          return unpack(args, 2)
        end
    end
end

function Signal:fire(...)
    for _, callback in pairs(connections[self]) do
        xpcall(coroutine.wrap(callback), print, ...)
    end
end

function Signal:connect(callback)
    local connection = Connection.new(self)
    connections[self][connection] = callback
    return connection
end

return Signal