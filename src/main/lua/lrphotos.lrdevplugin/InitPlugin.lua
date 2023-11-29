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
    local prefs = LrPrefs.prefsForPlugin()
    prefs.osSupported = true
    if (WIN_ENV) then
        LrDialogs.message(LOC("$$$/Photos/NotSupported=LRPhotos is not supported on Windows."), LOC("$$$/Photos/NotSupported/Subtext=Photos.app only exists on Mac."), "critical")
        prefs.osSupported = false
    end

    InitPlugin.pluginID = "at.homebrew.lrphotos"

    local tmpDir = LrPathUtils.parent(os.tmpname())
    logger.trace("tmpDir=" .. tmpDir)
    InitPlugin.tmpDir = LrPathUtils.child(tmpDir, InitPlugin.pluginID)
    logger.trace("pluginTmpDir=" .. InitPlugin.tmpDir)
    LrFileUtils.delete(InitPlugin.tmpDir)
    LrFileUtils.createDirectory( InitPlugin.tmpDir)

    InitPlugin.comDir = LrPathUtils.child(InitPlugin.tmpDir, "com")
    LrFileUtils.createDirectory(InitPlugin.comDir)

    InitPlugin.queueDir = LrPathUtils.child(InitPlugin.tmpDir, "queue")
    LrFileUtils.createDirectory(InitPlugin.queueDir)

    InitPlugin.sessionFile = LrPathUtils.child(InitPlugin.comDir, "session.txt")
    InitPlugin.photosFile = LrPathUtils.child(InitPlugin.comDir, "photos.txt")

    InitPlugin.queueEntryBaseName = "queue-entry"
    InitPlugin.queueEntry = LrPathUtils.child(InitPlugin.queueDir, InitPlugin.queueEntryBaseName)

end

init()

return InitPlugin