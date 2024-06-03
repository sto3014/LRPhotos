--[[---------------------------------------------------------------------------
-- Created by Dieter Stockhausen
-- Created on 04.12.23
-----------------------------------------------------------------------------]]
local LrFileUtils = import 'LrFileUtils'
local LrPathUtils = import 'LrPathUtils'
local LrDialogs = import 'LrDialogs'
local LrPrefs = import 'LrPrefs'

local logger = require("Logger")

_G.PLUGIN_ID = "at.homebrew.lrphotos"
_G.TMP_DIR = LrPathUtils.child(LrPathUtils.getStandardFilePath("home") .. "/Library/Caches", _G.PLUGIN_ID)
_G.QUEUE_DIR = LrPathUtils.child(_G.TMP_DIR, "queue")
_G.MAINTENANCE_DIR = LrPathUtils.child(_G.TMP_DIR, "maintenance")

function init()
    logger.trace("init start")
    local prefs = LrPrefs.prefsForPlugin()
    prefs.osSupported = true
    if (WIN_ENV) then
        LrDialogs.message(LOC("$$$/Photos/NotSupported=LRPhotos is not supported on Windows."), LOC("$$$/Photos/NotSupported/Subtext=Photos.app only exists on Mac."), "critical")
        prefs.osSupported = false
    end

    if prefs.truncateCatalogVersion == nil then
        prefs.truncateCatalogVersion=false
    end

    logger.trace("tmpDir=" .. _G.TMP_DIR)
    logger.trace("queueDir=" .. _G.QUEUE_DIR)
    logger.trace("maintenanceDir=" .. _G.MAINTENANCE_DIR)

    if (not LrFileUtils.exists(_G.TMP_DIR)) then
        logger.trace("Create directory " .. _G.TMP_DIR)
        LrFileUtils.createAllDirectories(_G.TMP_DIR)
    end


    if ( LrFileUtils.exists( _G.QUEUE_DIR)) then
        logger.trace("Delete directory on start-up: " .. _G.QUEUE_DIR)
        LrFileUtils.delete(_G.QUEUE_DIR)
    end

    logger.trace("Create directory " .. _G.QUEUE_DIR)
    LrFileUtils.createAllDirectories(_G.QUEUE_DIR)

    local fromLightroomDir = _G.MAINTENANCE_DIR .. "/FromLightroom"
    if not LrFileUtils.exists(fromLightroomDir) then
        logger.trace("Create directory " .. fromLightroomDir)
        LrFileUtils.createAllDirectories(fromLightroomDir)
    end

    local fromPhotosDir = _G.MAINTENANCE_DIR .. "/FromPhotos"
    if not LrFileUtils.exists(fromPhotosDir) then
        logger.trace("Create directory " .. fromPhotosDir)
        LrFileUtils.createAllDirectories(fromPhotosDir)
    end

    logger.trace("init end")
end

init()
