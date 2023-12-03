--[[---------------------------------------------------------------------------
-- Created by Dieter Stockhausen
-- Created on 31.05.21
-----------------------------------------------------------------------------]]
local LrDialogs = import 'LrDialogs'
local LrPrefs = import 'LrPrefs'
local LrFileUtils = import 'LrFileUtils'
local LrPathUtils = import 'LrPathUtils'

local logger = require("Logger")

local InitPlugin = {
    pluginID,
    comDir,
    queueDir,
    tmpDir,
    sessionFile,
    photosFile,
    queueEntry,
    queueEntryBaseName
}

local function init()
    logger.trace("init start")
    local prefs = LrPrefs.prefsForPlugin()
    prefs.osSupported = true
    if (WIN_ENV) then
        LrDialogs.message(LOC("$$$/Photos/NotSupported=LRPhotos is not supported on Windows."), LOC("$$$/Photos/NotSupported/Subtext=Photos.app only exists on Mac."), "critical")
        prefs.osSupported = false
    end

    InitPlugin.pluginID = "at.homebrew.lrphotos"

    local tmpDir = LrPathUtils.parent(os.tmpname())
    InitPlugin.tmpDir = LrPathUtils.child(tmpDir, InitPlugin.pluginID)
    logger.trace("pluginTmpDir=" .. InitPlugin.tmpDir)
    if ( not LrFileUtils.exists(InitPlugin.tmpDir)) then
        LrFileUtils.createDirectory( InitPlugin.tmpDir)
    end
    logger.trace("init end")
end

init()

return InitPlugin