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
local PhotosAPI = require("PhotosAPI")
local Utils = require("Utils")
local InitPlugin = require("InitPlugin")



PhotosPublishTask = {}

local LrMobdebug = import 'LrMobdebug' -- Import LR/ZeroBrane debug module

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
local function getFullAlbumPath(albumBy, useAlbum, rootFolder, albumNameForService, collectionName)
    local albumName = ""
    if (useAlbum == true) then
        if (albumBy == "service") then
            albumName = albumNameForService
        else
            albumName = collectionName
        end
    end
    if (albumName == nil) then
        albumName = ""
    else
        if ( albumName ~= "" and not Utils.startsWith(albumName, "/")) then
            if (not Utils.endsWith(rootFolder, "/")) then
                albumName = rootFolder .. "/" .. albumName
            else
                albumName = rootFolder .. albumName
            end
        end
    end
    logger.trace("Album: " .. albumName)
    return albumName
end
--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function getUniqueQueueEntry(collectionName)
    logger.trace("getUniqueQueueEntry start")

    local queueEntry = InitPlugin.queueEntry .. " " .. LrPathUtils.leafName(collectionName)
    --[[
    local index = 1
    local isAvailable = false
    while not isAvailable do
        queueEntry = InitPlugin.queueEntry .. "-" .. tostring(index)
        logger.trace("check availability for queueEntry=" .. queueEntry)
        if ( not LrFileUtils.exists(queueEntry)) then
            isAvailable = true
        else
            index = index + 1
        end
    end
    --]]
    logger.trace("getUniqueQueueEntry end")
    return queueEntry
end

--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function createQueueEntry(collectionName)
    logger.trace("createQueueEntry start")
    local queueEntryPath = LrFileUtils.chooseUniqueFileName(InitPlugin.queueEntry)
    -- local queueEntryPath = getUniqueQueueEntry(collectionName)
    logger.trace("queueEntryPath=" .. queueEntryPath)
    logger.trace("create queue-entry \""  ..  LrPathUtils.leafName(queueEntryPath) .. "\" for collection \"" .. collectionName .. "\"")
    local f = assert(io.open(queueEntryPath , "w", "encoding=utf-8"))
    f:write(collectionName)
    f:flush()
    f:close()
    logger.trace("createQueueEntry end")
    return LrPathUtils.leafName(queueEntryPath)
end
--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function deleteQueueEntry(queueEntry, collectionName)
    logger.trace("delete queue-entry \"" .. queueEntry .. "\"" .. "\" for collection \"" .. collectionName)
    LrFileUtils.delete(LrPathUtils.child(InitPlugin.queueDir, queueEntry))
end

--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function waitForPredecessors(queueEntry)
    logger.trace("waitForPredecessors() start")
    logger.trace("queueEntry=" .. queueEntry)
    local done = false
    while done ~= true do
        local modDatesToQueueEntry = {}
        for currentQueueEntry in LrFileUtils.directoryEntries(InitPlugin.queueDir) do
            local leafName = LrPathUtils.leafName(currentQueueEntry)
            if (Utils.startsWith(leafName, InitPlugin.queueEntryBaseName)) then
                logger.trace("leafName=" .. leafName)
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
local function writeSessionFile(albumName, ignoreAlbums, ignoreRegex, mode)
    -- Write Lightroom input to a session.txt file for AppleScript later on
    logger.trace("sessionFile=" .. InitPlugin.sessionFile)
    local f = assert(io.open(InitPlugin.sessionFile, "w+", "encoding=utf-8"))
    f:write("mode=" .. mode ..  "\n")
    f:write("exportDone=false\n")
    f:write("albumName=" .. albumName .. "\n")

    if ignoreAlbums == true then
        f:write("ignoreByRegex=" .. ignoreRegex .. "\n")
    end
    f:close()

end

--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function writePhotosFile(photoIDs)
    logger.trace("photosFile=" .. InitPlugin.photosFile)
    local g = assert(io.open(InitPlugin.photosFile, "w+"))
    for _, photoID in ipairs(photoIDs) do
        logger.trace(photoID)
        g:write(photoID .. "\n")
    end
    g:close()

end

--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function waitForPhotosApp()
    -- Wait for the import to be done
    local done = false
    local hasErrors = false
    local errorMsg = ""
    while done ~= true and hasErrors ~= true do
        LrTasks.sleep(2)
        local f = assert(io.open(InitPlugin.sessionFile, "r"))
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
    return hasErrors, errorMsg
end

--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function setPhotosID()
    local activeCatalog = LrApplication.activeCatalog()
    local f = assert(io.open(InitPlugin.photosFile, "r"))

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
local function removePhotosID()
    local activeCatalog = LrApplication.activeCatalog()
    local f = assert(io.open(InitPlugin.photosFile, "r"))

    activeCatalog:withWriteAccessDo("Remove photos ID", function()
        for line in f:lines() do
            logger.trace("Line: " .. line)
            local tokens = split(line, ":")
            logger.trace("LrID: " .. tokens[2])
            local photo = activeCatalog:findPhotoByUuid(tokens[2])
            logger.trace("Photo: " .. tostring(photo))
            if (photo ~= nil) then
                logger.trace("PhotosID removed: " .. tokens[4])
                photo:setPropertyForPlugin(_PLUGIN, 'photosId', "")
            end
        end
    end)
    f:close()
end

--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function renderPhotos(exportContext, progressScope)
    local photoIDs = {}
    local renditions = {}
    logger.trace("renderPhotos start")
    for i, rendition in exportContext:renditions { stopIfCanceled = true } do
        local photo = rendition.photo
        local success, pathOrMessage = rendition:waitForRender()

        if progressScope:isCanceled() then
            break
        end -- Check for cancellation again after photo has been rendered
        if success then
            renditions[#renditions + 1] = rendition
            local lrcatName = LrPathUtils.leafName(LrPathUtils.removeExtension(photo.catalog:getPath()))

            local pID = photo:getPropertyForPlugin(_PLUGIN, 'photosId')
            if (pID == nil) then
                pID = ""
            end
            photoIDs[#photoIDs + 1] = pathOrMessage .. ":" .. photo:getRawMetadata("uuid") .. ":" .. lrcatName .. ":" .. pID
        end
    end
    logger.trace("renderPhotos end")
    return renditions, photoIDs
end

--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function recordPhotoIDs(renditions)
    local activeCatalog = LrApplication.activeCatalog()
    -- store the remote photoIds in the service
    for _, rendition in ipairs(renditions) do
        local photo = rendition.photo
        local isVideo = photo:getRawMetadata("isVideo")
        logger.trace("isVideo=" .. tostring(isVideo))
        -- local photoId = PhotosAPI.getPhotosId(photo)
        local photoId = photo:getRawMetadata("uuid")
        logger.trace("uuid=" .. tostring(photoId))
        local p = activeCatalog:findPhotoByUuid(photoId)
        logger.trace("p=" .. tostring(p))
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
local function sendPhotosToApp()
    local importer_command = "osascript \"" .. LrPathUtils.child(_PLUGIN.path, "PhotosImport/PhotosImport.app") .. "\" " .. "\"" .. InitPlugin.comDir .. "\""
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
    logger.trace("processRenderedPhotos start")
    logger.trace("collection=" .. exportContext.publishedCollectionInfo.name)

    local exportSession = exportContext.exportSession

    -- Progress bar
    -- Does not work at the time. The standard bar will be displayed
    local nPhotos = exportSession:countRenditions()
    local progressScope = exportContext:configureProgress {
        title = nPhotos > 1
                and LOC('$$$/PhotosExportService/ProgressMany=Importing ^1 photos in Photo', nPhotos)
                or LOC '$$$/PhotosExportService/ProgressOne=Importing one photo in Photo',
    }


    -- Render the photos
    local renditions, photoIDs = renderPhotos(exportContext, progressScope)

    local albumName = getFullAlbumPath(
            exportContext.propertyTable.albumBy,
            exportContext.propertyTable.useAlbum,
            exportContext.propertyTable.rootFolder,
            exportContext.propertyTable.albumNameForService,
            exportContext.publishedCollectionInfo.name)

    if (not isValidAlbumPath(albumName)) then
        LrDialogs.message(LOC("$$$/Photos/Error/AlbumPath=Album path is not valid."),
                LOC("$$$/Photos/Error/AlbumPathSub=The name of the album \"^1\" has not a valid from. The name must start with a slash but may NOT end with a slash.", albumName), "critical")
        return
    end

    local queueEntryName = createQueueEntry(exportContext.publishedCollectionInfo.name)
    waitForPredecessors(queueEntryName)

    writeSessionFile(
            albumName,
            exportContext.propertyTable.ignoreAlbums,
            exportContext.propertyTable.ignoreRegex,
            "publish")

    writePhotosFile(photoIDs)

    -- Import photos in Photos app
    local result = sendPhotosToApp()
    if (result ~= 0) then
        local errorMsg = "Error code from PhotosImport.app is " .. tostring(result)
        LrDialogs.message(LOC("$$$/Photos/Error/Import=Error while importing photos"),
                LOC("$$$/Photos/PlaceHolder=^1", errorMsg), "critical")
        deleteQueueEntry(queueEntryName, exportContext.publishedCollectionInfo.name)
        return
    end

    -- Wait till photos are imported by reading the session file
    local hasErrors, errorMsg = waitForPhotosApp()
    if (hasErrors) then
        deleteQueueEntry(queueEntryName, exportContext.publishedCollectionInfo.name)
        LrDialogs.message(LOC("$$$/Photos/Error/Import=Error while importing photos"), LOC("$$$/Photos/PlaceHolder=^1", errorMsg), "critical")
        return
    end

    setPhotosID()
    recordPhotoIDs(renditions)
    deleteQueueEntry(queueEntryName, exportContext.publishedCollectionInfo.name)
    logger.trace("processRenderedPhotos end")
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
        title = false,
        caption = false,
        keywords = false,
        gps = false,
        dateCreated = false,

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

        -- LrMobdebug.start()
        -- LrMobdebug.on()
        local albumName = publishSettings.LR_publishedCollectionInfo.name
        logger.trace("albumName=" .. albumName)

        local albumName = getFullAlbumPath(
                publishSettings.albumBy,
                publishSettings.useAlbum,
                publishSettings.rootFolder,
                publishSettings.albumNameForService,
                publishSettings.LR_publishedCollectionInfo.name)
        logger.trace("albumName=" .. albumName)

        if (not isValidAlbumPath(albumName)) then
            LrDialogs.message(LOC("$$$/Photos/Error/AlbumPath=Album path is not valid."),
                    LOC("$$$/Photos/Error/AlbumPathSub=The name of the album \"^1\" has not a valid from. The name must start with a slash but may NOT end with a slash.", albumName), "critical")
            return
        end

        local queueEntryName = createQueueEntry(publishSettings.LR_publishedCollectionInfo.name)
        waitForPredecessors(queueEntryName)

        writeSessionFile(albumName, publishSettings.ignoreAlbums, publishSettings.ignoreRegex, "remove")
        local activeCatalog = LrApplication.activeCatalog()
        local catName = LrPathUtils.leafName(activeCatalog:getPath())

        local photoIDs = {}
        for i, lrUUID in ipairs(arrayOfPhotoIds) do
            logger.trace("LrUUID=" .. tostring(lrUUID))
            local photo = PhotosAPI.getPhotos(lrUUID)
            if (photo == nil) then
                LrDialogs.message(LOC("$$$/Photos/Error/PhotoNotFound=Photo not found."),
                        LOC("$$$/Photos/Error/PhotoNotFoundByPhotosID=Photo could not be found by its Photo-app UID: \"^1\".", lrUUID), "critical")
            else
                local photosID = PhotosAPI.getPhotosId(photo)
                logger.trace("photo=" .. tostring(photo))
                photoIDs[i] = "n.a." .. ":" .. lrUUID .. ":" .. catName .. ":" .. photosID
            end
        end
        writePhotosFile(photoIDs)

        local result = sendPhotosToApp()
        if (result ~= 0) then
            local errorMsg = "Error code from PhotosImport.app is " .. tostring(result)
            LrDialogs.message(LOC("$$$/Photos/Error/Import=Error while importing photos"),
                    LOC("$$$/Photos/PlaceHolder=^1", errorMsg), "critical")
            return
        end

        local hasErrors, errorMsg = waitForPhotosApp()
        if (hasErrors) then
            deleteQueueEntry(queueEntryName,publishSettings.LR_publishedCollectionInfo.name)
            LrDialogs.message(LOC("$$$/Photos/Error/Import=Error while importing photos"), LOC("$$$/Photos/PlaceHolder=^1", errorMsg), "critical")
        end

        removePhotosID()

        deleteQueueEntry(queueEntryName,publishSettings.LR_publishedCollectionInfo.name)

        for _, photosID in ipairs(arrayOfPhotoIds) do
            logger.trace("photosID to be deleted = " .. tostring(photosID))
            deletedCallback(photosID)
        end
end

--[[---------------------------------------------------------------------------
    startDialog
-----------------------------------------------------------------------------]]
function PhotosPublishTask.startDialog(propertyTable)

    if not propertyTable.LR_editingExistingPublishConnection then
        propertyTable.LR_jpeg_quality = 0.85
        propertyTable.LR_removeLocationMetadata = false
        propertyTable.LR_removeFaceMetadata = false
    end
end
