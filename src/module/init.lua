local Bindable = {}
Bindable.__index = Bindable

local Signal = require(script.Signal)

function Bindable.new()
    local signal = Signal.new()
    local fire = signal.fire
    signal.fire = nil
    return setmetatable({event = signal, fire = function(_, ...)   
        fire(signal, ...)     
    end}, Bindable)
end

return Bindable