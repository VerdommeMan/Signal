local Bindable = {}
Bindable.__index = Bindable

local Signal = require(script.Signal)

function Bindable.new()
    local signal = Signal.new()
    local fire = signal.Fire
    signal.Fire = nil
    signal.fire = nil
    
    local function newFire(_, ...)   
        fire(signal, ...)     
    end

    return setmetatable({Event = signal, event = signal, Fire = newFire, fire = newFire}, Bindable)
end

return Bindable