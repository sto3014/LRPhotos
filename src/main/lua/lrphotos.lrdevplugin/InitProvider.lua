--[[---------------------------------------------------------------------------
-- Created by Dieter Stockhausen
-- Created on 31.05.21
-----------------------------------------------------------------------------]]
local LrDialogs = import ("LrDialogs")
local LrPrefs = import("LrPrefs")
local LrFileUtils = import 'LrFileUtils'
local LrPathUtils = import 'LrPathUtils'


InitProvider = {}
local function init()
    local prefs = LrPrefs.prefsForPlugin()
    prefs.osSupported = true
    if (WIN_ENV) then
        LrDialogs.message(LOC("$$$/Photos/NotSupported=LRPhotos is not supported on Windows."), LOC("$$$/Photos/NotSupported/Subtext=Photos.app only exists on Mac."), "critical")
        prefs.osSupported = false
    end

    LrFileUtils.delete(LrPathUtils.child(_PLUGIN.path, "Queue"))
end

init()