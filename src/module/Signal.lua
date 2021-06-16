local Connection = {}
local Signal = {}

Connection.__index = Connection
Signal.__index = Signal

function Connection.new(signal)
    return setmetatable({signal = signal, connected = true}, Connection)
end

function Connection:disconnect()
    self.signal.connections[self] = nil
    self.connected = false
end

function Signal.new()
    return setmetatable({connections = {}}, Signal)
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
    for _, callback in pairs(self.connections) do
        xpcall(coroutine.wrap(callback), print, ...)
    end
end

function Signal:connect(callback)
    local connection = Connection.new(self)
    self.connections[connection] = callback
    return connection
end

return Signal