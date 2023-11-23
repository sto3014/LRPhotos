--[[---------------------------------------------------------------------------
-- Initial created by Simon Schoeters in 2011
--
-- 2021-05-29 Dieter Stockhausen. Add publishing functionality
-----------------------------------------------------------------------------]]--

local LrPathUtils = import 'LrPathUtils'
local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'
local LrDialogs = import 'LrDialogs'
local LrFileUtils = import 'LrFileUtils'

local logger = require("Logger")
require("PhotosAPI")
local Utils = require("Utils")



PhotosPublishTask = {}

local debug=false
-- local LrMobdebug = import 'LrMobdebug' -- Import LR/ZeroBrane debug module

--[[---------------------------------------------------------------------------
 local functions
-----------------------------------------------------------------------------]]
--[[---------------------------------------------------------------------------
f
-----------------------------------------------------------------------------]]
local function split (inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
    -----------------------------------------------------------------------------]]
end
--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function isValidAlbumPath(albumPath)
    if (albumPath == nil) then
        return false
    end
    if (albumPath == "") then
        return true
    end
    local idx = string.find(albumPath, "/")
    if (idx ~= 1) then
        return false
    end
    idx = string.find(albumPath, "/", -1)
    if (idx == #albumPath) then
        return nil
    end
    return true
end
--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function getFullAlbumPath(exportContext)
    local exportParams = exportContext.propertyTable
    local albumName = ""
    if exportParams.useAlbum == true then
        if (exportParams.albumBy == "service") then
            albumName = exportParams.albumNameForService
        else
            albumName = exportContext.publishedCollectionInfo.name
        end
    end
    if (albumName == nil) then
        albumName = ""
    else
        if ( albumName ~= "" and not Utils.startsWith(albumName, "/")) then
            if ( not Utils.endsWith(exportParams.rootFolder, "/")) then
                albumName = exportParams.rootFolder .. "/" .. albumName
            else
                albumName = exportParams.rootFolder .. albumName
            end
        end
    end
    logger.trace("Album: " .. albumName)
    return albumName
end
--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function createQueueEntry(exportContext )
    LrFileUtils.createDirectory(LrPathUtils.child(_PLUGIN.path, "Queue"))
    local queueEntryPath = LrFileUtils.chooseUniqueFileName(LrPathUtils.child(_PLUGIN.path, "Queue/queue-entry"))
    local f = assert(io.open(queueEntryPath , "w", "encoding=utf-8"))
    f:write(exportContext.publishedCollectionInfo.name)
    f:close()
    return LrPathUtils.leafName(queueEntryPath)
end
--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function deleteQueueEntry(queueEntry)
    LrFileUtils.delete(LrPathUtils.child(_PLUGIN.path, "Queue/" .. queueEntry))
end

--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function waitForPredecessors(queueEntry)
    logger.trace("waitForPredecessors() start")
    logger.trace("queueEntry=" .. queueEntry)
    local done = false
    while done ~= true do
        local modDatesToQueueEntry = {}
        for currentQueueEntry in LrFileUtils.directoryEntries( LrPathUtils.child(_PLUGIN.path, "Queue") ) do
            local leafName = LrPathUtils.leafName(currentQueueEntry)
            if ( Utils.startsWith(leafName, "queue-entry")) then
                -- logger.trace("leafName=" .. leafName)
                modDatesToQueueEntry[LrFileUtils.fileAttributes(currentQueueEntry).fileModificationDate] = leafName
            end
        end
        local modDates = {}
        for n in pairs(modDatesToQueueEntry) do table.insert(modDates, n) end
        table.sort(modDates)
        local entryToBeProcessed = modDatesToQueueEntry[modDates[1]]

        if ( entryToBeProcessed == nil) then
            logger.trace("No entry found. Should only happen if user delete all files. Proceed processing.")
            done = true
        else
            logger.trace("entryToBeProcessed=" .. entryToBeProcessed )
            if ( entryToBeProcessed == queueEntry) then
                logger.trace("Processing...")
                done=true
            else
                logger.trace("Waiting...")
                LrTasks.sleep(2)
            end
        end
    end
    logger.trace("waitForPredecessors() end")
end

--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function writeSessionFile(path, albumName, exportParams, mode)
    -- Write Lightroom input to a session.txt file for AppleScript later on
    local sessionFileName = path .. "/session.txt"
    local f = assert(io.open(sessionFileName, "w+", "encoding=utf-8"))
    f:write("mode=" .. mode ..  "\n")
    f:write("exportDone=false\n")
    f:write("albumName=" .. albumName .. "\n")

    if exportParams.ignoreAlbums == true then
        f:write("ignoreByRegex=" .. exportParams.ignoreRegex .. "\n")
    end
    f:close()

    if (debug) then
        LrFileUtils.delete("/tmp/session.txt")
        LrFileUtils.copy(path .. "/session.txt", "/tmp/session.txt")
    end
    logger.trace("sessionFile=" .. sessionFileName)
    return sessionFileName
end

--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function writePhotosFile(path, photoIDs)
    local photosFileName = path .. "/photos.txt"
    local g = assert(io.open(photosFileName, "w+"))
    for _, photoID in ipairs(photoIDs) do
        logger.trace(photoID)
        g:write(photoID .. "\n")
    end
    g:close()

    if (debug) then
        LrFileUtils.delete("/tmp/photos.txt")
        LrFileUtils.copy(path .. "/photos.txt", "/tmp/photos.txt")
    end
    logger.trace("photosFile=" .. photosFileName)
    return photosFileName
end

--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function waitForPhotosApp(sessionFileName)
    -- Wait for the import to be done
    local done = false
    local hasErrors = false
    local errorMsg = ""
    while done ~= true and hasErrors ~= true do
        LrTasks.sleep(2)
        local f = assert(io.open(sessionFileName, "r"))
        for line in f:lines() do
            logger.trace("waiting..." .. line)
            if string.find(line, 'exportDone=true') then
                done = true
                break
            else
                if string.find(line, 'hasErrors=true') then
                    hasErrors = true
                else
                    if string.find(line, 'errorMsg=') then
                        errorMsg = string.sub(line, 10)
                    end
                end
            end
        end
        f:close()
    end

    if (debug) then
        LrFileUtils.delete("/tmp/session.txt")
        LrFileUtils.copy(sessionFileName, "/tmp/session.txt")
    end
    return hasErrors, errorMsg
end

--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function setPhotosID(photosFileName)
    local activeCatalog = LrApplication.activeCatalog()
    local f = assert(io.open(photosFileName, "r"))

    activeCatalog:withWriteAccessDo("Set photos ID", function()
        for line in f:lines() do
            logger.trace("Line: " .. line)
            local tokens = split(line, ":")
            logger.trace("LrID: " .. tokens[2])
            local photo = activeCatalog:findPhotoByUuid(tokens[2])
            logger.trace("Photo: " .. tostring(photo))
            if (photo ~= nil) then
                logger.trace("PhotosID: " .. tokens[4])
                photo:setPropertyForPlugin(_PLUGIN, 'photosId', tokens[4])
            end
        end
    end)
    f:close()
end

--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function renderPhotos(exportContext, progressScope)
    local files = {}
    local photoIDs = {}
    local renditions = {}

    for i, rendition in exportContext:renditions { stopIfCanceled = true } do
        local photo = rendition.photo
        local success, pathOrMessage = rendition:waitForRender()

        if progressScope:isCanceled() then
            break
        end -- Check for cancellation again after photo has been rendered
        if success then
            renditions[#renditions + 1] = rendition
            files[#files + 1] = pathOrMessage
            local lrcatName = LrPathUtils.leafName(LrPathUtils.removeExtension(photo.catalog:getPath()))

            local pID = photo:getPropertyForPlugin(_PLUGIN, 'photosId')
            if (pID == nil) then
                pID = ""
            end
            photoIDs[#photoIDs + 1] = pathOrMessage .. ":" .. photo:getRawMetadata("uuid") .. ":" .. lrcatName .. ":" .. pID
        end
    end
    local exportPath = nil
    if (#files ~= 0) then
        exportPath = LrPathUtils.parent(files[1])
        logger.trace("exportPath=" .. tostring(exportPath))
    end
    return renditions, exportPath, photoIDs
end

--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function recordPhotoIDs(renditions)
    -- store the remote photoIds in the service
    for _, rendition in ipairs(renditions) do
        local photo = rendition.photo
        local isVideo = photo:getRawMetadata("isVideo")
        logger.trace("isVideo=" .. tostring(isVideo))
        local photoId = PhotosAPI.getPhotosId(photo)
        logger.trace("Record photo?:" .. tostring(photoId))
        -- Videos are always marked as skipped. Hmmm?
        if not rendition.wasSkipped or isVideo then
            logger.trace("Record=" .. tostring(photoId))
            if (photoId ~= nil) then
                rendition:recordPublishedPhotoId(photoId)
            end
        end
    end
end

--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function sendPhotosToApp(path)
    local importer_command = "osascript \"" .. LrPathUtils.child(_PLUGIN.path, "PhotosImport/PhotosImport.app") .. "\" " .. "\"" .. path .. "\""
    logger.trace(importer_command)
    return LrTasks.execute(importer_command)
end

--[[---------------------------------------------------------------------------
 global (inherited) functions
-----------------------------------------------------------------------------]]
--[[---------------------------------------------------------------------------
 processRenderedPhotos
-----------------------------------------------------------------------------]]
function PhotosPublishTask.processRenderedPhotos(_, exportContext)
    logger.trace("name=" .. exportContext.publishedCollectionInfo.name)

    local exportSession = exportContext.exportSession
    local exportParams = exportContext.propertyTable

    -- Progress bar
    -- Does not work at the time. The standard bar will be displayed
    local nPhotos = exportSession:countRenditions()
    local progressScope = exportContext:configureProgress {
        title = nPhotos > 1
                and LOC('$$$/PhotosExportService/ProgressMany=Importing ^1 photos in Photo', nPhotos)
                or LOC '$$$/PhotosExportService/ProgressOne=Importing one photo in Photo',
    }

    -- Render the photos
    local renditions, exportPath, photoIDs = renderPhotos(exportContext, progressScope)
    if (exportPath == nil) then
        return
    end

    local albumName = getFullAlbumPath(exportContext)
    if (not isValidAlbumPath(albumName)) then
        LrDialogs.message(LOC("$$$/Photos/Error/AlbumPath=Album path is not valid."),
                LOC("$$$/Photos/Error/AlbumPathSub=The name of the album \"^1\" has not a valid from. The name must start with a slash but may NOT end with a slash.", albumName), "critical")
        return
    end

    local queueEntryName = createQueueEntry(exportContext)
    logger.trace("queueEntry=" .. queueEntryName)
    waitForPredecessors(queueEntryName)

    local sessionFileName = writeSessionFile(exportPath, albumName, exportParams, "publish")
    local photosFileName = writePhotosFile(exportPath, photoIDs)

    -- Import photos in Photos app
    local result = sendPhotosToApp(exportPath)
    if (result ~= 0) then
        local errorMsg = "Error code from PhotosImport.app is " .. tostring(result)
        LrDialogs.message(LOC("$$$/Photos/Error/Import=Error while importing photos"),
                LOC("$$$/Photos/PlaceHolder=^1", errorMsg), "critical")
        deleteQueueEntry(queueEntryName)
        return
    end

    -- Wait till photos are imported by reading the session file
    local hasErrors, errorMsg = waitForPhotosApp(sessionFileName)
    if (hasErrors) then
        LrDialogs.message(LOC("$$$/Photos/Error/Import=Error while importing photos"), LOC("$$$/Photos/PlaceHolder=^1", errorMsg), "critical")
        deleteQueueEntry(queueEntryName)
        return
    end

    setPhotosID(photosFileName)
    recordPhotoIDs(renditions)
    deleteQueueEntry(queueEntryName)
end
--[[---------------------------------------------------------------------------
 getCollectionBehaviorInfo
-----------------------------------------------------------------------------]]
function PhotosPublishTask.getCollectionBehaviorInfo(publishSettings)

    return {
        -- defaultCollectionName = LOC "$$$/Photos/DefaultCollectionName/Photostream=Photostream",
        defaultCollectionCanBeDeleted = true,
        canAddCollection = true,
        maxCollectionSetDepth = 0,
        -- Collection sets are not supported through the Flickr sample plug-in.
    }

end

--[[---------------------------------------------------------------------------
 metadataThatTriggersRepublish
-----------------------------------------------------------------------------]]
function PhotosPublishTask.metadataThatTriggersRepublish(publishSettings)
    return {

        default = false,
        title = true,
        caption = true,
        keywords = true,
        gps = true,
        dateCreated = true,

        -- also (not used by Flickr sample plug-in):
        -- customMetadata = true,
        -- com.whoever.plugin_name.* = true,
        -- com.whoever.plugin_name.field_name = true,
    }
end

--[[---------------------------------------------------------------------------
 deletePhotosFromPublishedCollection
-----------------------------------------------------------------------------]]
function PhotosPublishTask.deletePhotosFromPublishedCollection(publishSettings, arrayOfPhotoIds, deletedCallback)
    for _, photoId in ipairs(arrayOfPhotoIds) do
        -- todo
        -- We can only remove it when photo does not longer exist.
        -- 1. When we don't find it we can delete the id in LR
        -- 2. Otherwise we remove it from the album, and delete the album: tag
        -- PhotosAPI.resetPhotoId(photoId)
        deletedCallback(photoId)
    end
end

--[[---------------------------------------------------------------------------
    startDialog
-----------------------------------------------------------------------------]]
function PhotosPublishTask.startDialog(propertyTable)

    -- LrMobdebug.on()
    if not propertyTable.LR_editingExistingPublishConnection then
        propertyTable.LR_jpeg_quality = 0.85
        propertyTable.LR_removeLocationMetadata = false
        propertyTable.LR_removeFaceMetadata = false
    end
end
