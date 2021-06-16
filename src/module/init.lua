local Bindable = {}
Bindable.__index = Bindable

local Signal = require(script.Signal)

function Bindable.new()
    local signal = Signal.new()
    local fire = signal.Fire
    signal.Fire = nil
    return setmetatable({Event = signal, Fire = function(_, ...)   
        fire(signal, ...)     
    end}, Bindable)
end

return Bindable