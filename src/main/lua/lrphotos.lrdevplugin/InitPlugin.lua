--
-- Created by IntelliJ IDEA.
-- User: Dieter Stockhausen
-- Date: 02.05.21
-- To change this template use File | Settings | File Templates.
-------------------------------------------------------------------------------
local LrPrefs = import "LrPrefs"

local logger = require("Logger")
-------------------------------------------------------------------------------

local InitProvider = {}

-------------------------------------------------------------------------------

local function resetPrefs()
    local prefs = LrPrefs.prefsForPlugin()
    prefs.hasErrors = nil
    prefs.useAlbum=nil
    prefs.albumName=nil
    prefs.ignoreAlbums=nil
    prefs.ignoreByRegex=nil

end

-------------------------------------------------------------------------------

local function init()
    -- resetPrefs()

    logger.trace("Init plug-in")
    local prefs = LrPrefs.prefsForPlugin()
    prefs.hasErrors = false



    if ( prefs.useAlbum == nil) then
        prefs.useAlbum = true
    end

    if ( prefs.albumName == nil or prefs.albumName == "") then
        prefs.albumName = LOC('$$$/PhotosExportService/UnknownAlbum=Lightroom')
    end

    if ( prefs.ignoreAlbums == nil) then
        prefs.ignoreAlbums = true
    end

    if ( prefs.ignoreByRegex == nil or prefs.ignoreByRegex) then
        prefs.ignoreByRegex = "^!|!$"
    end

    logger.trace("Init done.")
end

-------------------------------------------------------------------------------

init()

