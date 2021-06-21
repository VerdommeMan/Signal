# Custom BindableEvent Class
This is a custom implementation of [BindableEvent](https://developer.roblox.com/en-us/api-reference/class/BindableEvent) 

## Features

* Same API as BindableEvent (means drop in replacement without any changes)
* Continuations support (unlike many other signal/bindeable replacements)
* Decent stacktrace (uses debug.traceback to reconstruct a traceback) 
* CamelCase compatibility if wanted
* No Instance overhead
* Connections lifecycle aren't tied to the script in which they are created
* No `Destroy` needed (gced when no references to itself and all its connections are disconnected)
* Prevents other threads from resuming the thread yielded by `:Wait` unlike bindeable
* Properly encapsulated the private properties (unlike many other signal/bindeable replacements)

[Use this branch if you need camelCase compatibility](https://github.com/VerdommeMan/Signal/tree/camelCase_compatibility)