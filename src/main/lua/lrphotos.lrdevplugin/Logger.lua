--[[---------------------------------------------------------------------------
-- Created by Dieter Stockhausen
-- Created on 06.05.21
-----------------------------------------------------------------------------]]
local LrLogger = import("LrLogger")
local _logger = LrLogger("PhotosServiceProvider")
_logger:enable("logfile")
local enabled = false
-------------------------------------------------------------------------------
local logger = {}
-------------------------------------------------------------------------------
function logger.trace(msg)
    if (enabled) then
        _logger:trace(msg)
    end
end
-------------------------------------------------------------------------------
return logger