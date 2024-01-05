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

require("stringutil")

PhotosPublishTask = {}

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
    -- Commas are not allowed in the nam eof an album.
    -- An album has not a problem with commas, but the album name is stored as a keyword.
    -- If y keyword contains a comma, Photos creates two keywords out of it.
    idx = string.find(string.reverse(albumPath), "/")
    if string.find(string.sub(albumPath, -idx, #albumPath), ",") then
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
local function writeSessionFile(albumPath, ignoreAlbums, ignoreRegex, mode, keepOldPhotos)
    -- Write Lightroom input to a session.txt file for AppleScript later on
    logger.trace("sessionFile=" .. Utils.getSessionFile(albumPath))
    local f = assert(io.open(Utils.getSessionFile(albumPath), "w+"))
    f:write("mode=" .. mode ..  "\n")
    f:write("exportDone=false\n")
    f:write("albumName=" .. albumPath .. "\n")
    f:write("keepOldPhotos=" .. tostring(keepOldPhotos) .. "\n")

    if ignoreAlbums == true then
        f:write("ignoreByRegex=" .. ignoreRegex .. "\n")
    end
    f:close()

end

--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function writePhotosFile(photoIDs, albumPath)
    logger.trace("photosFile=" .. Utils.getPhotosFile(albumPath))
    local g = assert(io.open(Utils.getPhotosFile(albumPath), "w+"))
    for _, photoID in ipairs(photoIDs) do
        logger.trace(photoID)
        g:write(photoID .. "\n")
    end
    g:close()
end
--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function waitForPhotosApp(albumPath)
    logger.trace("PhotosPublishTask.waitForPhotosApp() start")
    -- Wait for the import to be done
    local done = false
    local hasErrors = false
    local errorMsg = ""

    while done == false do
        LrTasks.sleep(2)
        local f = assert(io.open(Utils.getSessionFile(albumPath), "r"))
        for line in f:lines() do
            if string.find(line, 'exportDone=true') then
                logger.trace("waiting..." .. line)
                done = true
                break
            else
                if string.find(line, 'hasErrors=true') then
                    logger.trace("waiting..." .. line)
                    hasErrors = true
                else
                    if string.find(line, 'errorMsg') then
                        if hasErrors then
                            -- The error message is in Western (Mac OS Roman).
                            -- At least for latin languages.
                            -- todo check if unicode or not
                            --errorMsg = string.toutf8_mac(string.sub(line, 10))
                            errorMsg = string.sub(line, 10)
                            logger.trace("waiting...errorMsg=" .. errorMsg)
                            done = true
                        end
                    end
                end
            end
        end
        f:close()
    end
    logger.trace("PhotosPublishTask.waitForPhotosApp() end")
    return hasErrors, errorMsg
end

--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function setPhotosID(albumPath)
    local activeCatalog = LrApplication.activeCatalog()
    local f = assert(io.open(Utils.getPhotosFile(albumPath), "r"))

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
local function removePhotosID(albumPath)
    local activeCatalog = LrApplication.activeCatalog()
    local f = assert(io.open(Utils.getPhotosFile(albumPath), "r"))

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
local function getPhotoDescriptor(photo, photoPath, lrcatName)
    local pID = photo:getPropertyForPlugin(_PLUGIN, 'photosId')
    if (pID == nil) then
        pID = ""
    end
    local path = photoPath

    local cameraModel = photo:getFormattedMetadata("cameraModel")
    if ( cameraModel ~= nil and Utils.startsWith(cameraModel, "iPhone")) then
        local isHDR = false
        local keywords = photo:getFormattedMetadata("keywordTags")

        if ( keywords ~=nil) then
            for token in string.gmatch(keywords, "[^,]+") do
                local keyword = Utils.trim(token)
                if ( keyword == "iso_hdr") then
                    isHDR = true
                    break
                end
            end
        end
        if ( isHDR) then
             path = photo:getRawMetadata("path")
        end
    end
    return path .. ":" .. photo:getRawMetadata("uuid") .. ":" .. lrcatName .. ":" .. pID

end
--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function renderPhotos(exportContext, progressScope)
    local photoIDs = {}
    local renditions = {}
    logger.trace("PhotosPublishTask.renderPhotos start")
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
            photoIDs[#photoIDs + 1] = getPhotoDescriptor(photo, pathOrMessage , lrcatName)
        end
    end
    logger.trace("PhotosPublishTask.renderPhotos end")
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
local function sendPhotosToApp(albumPath)
    local importer_command = "osascript \"" .. LrPathUtils.child(_PLUGIN.path, "PhotosImport/PhotosImport.app") .. "\" " .. "\"" .. Utils.getComDir(albumPath) .. "\""
    logger.trace(importer_command)
    return LrTasks.execute(importer_command)
end
--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function createQueueEntry(collectionName)

    local queueEntryPath = LrFileUtils.chooseUniqueFileName(Utils.getQueueEntry())
    local f = assert(io.open(queueEntryPath , "w"))
    f:write(collectionName)
    f:close()
    return LrPathUtils.leafName(queueEntryPath)
end
--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function deleteQueueEntry(queueEntry, albumPath)
    logger.trace("delete queue-entry \"" .. queueEntry .. "\"" .. "\" for collection \"" .. albumPath)
    LrFileUtils.delete(LrPathUtils.child(Utils.getQueueDir(), queueEntry))
end
--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function waitForPredecessors(queueEntry)
    logger.trace("PhotosPublishTask.waitForPredecessors() start")
    logger.trace("queueEntry=" .. queueEntry)
    local done = false
    while done ~= true do
        local modDatesToQueueEntry = {}
        for currentQueueEntry in LrFileUtils.directoryEntries(Utils.getQueueDir()) do
            local leafName = LrPathUtils.leafName(currentQueueEntry)
            if (Utils.startsWith(leafName, Utils.getQueueEntryBaseName())) then
                logger.trace("leafName=" .. leafName)
                modDatesToQueueEntry[LrFileUtils.fileAttributes(currentQueueEntry).fileModificationDate] = leafName
            end
        end
        local modDates = {}
        for n in pairs(modDatesToQueueEntry) do
            table.insert(modDates, n)
        end
        table.sort(modDates)
        local entryToBeProcessed = modDatesToQueueEntry[modDates[1]]

        if (entryToBeProcessed == nil) then
            logger.trace("No entry found. Should only happen if user delete all files. Proceed processing.")
            done = true
        else
            logger.trace("entryToBeProcessed=" .. entryToBeProcessed)
            if (entryToBeProcessed == queueEntry) then
                logger.trace("Processing...")
                done = true
            else
                logger.trace("Waiting...")
                LrTasks.sleep(2)
            end
        end
    end
    logger.trace("PhotosPublishTask.waitForPredecessors() end")
end



--[[---------------------------------------------------------------------------
 global (inherited) functions
-----------------------------------------------------------------------------]]
--[[---------------------------------------------------------------------------
 processRenderedPhotos
-----------------------------------------------------------------------------]]
function PhotosPublishTask.processRenderedPhotos(_, exportContext)
    logger.trace("PhotosPublishTask.processRenderedPhotos start")
    logger.trace("collection=" .. exportContext.publishedCollectionInfo.name)

    local albumPath = getFullAlbumPath(
            exportContext.propertyTable.albumBy,
            exportContext.propertyTable.useAlbum,
            exportContext.propertyTable.rootFolder,
            exportContext.propertyTable.albumNameForService,
            exportContext.publishedCollectionInfo.name)

    if (not isValidAlbumPath(albumPath)) then
        LrDialogs.message(LOC("$$$/Photos/Error/AlbumPath=Album path is not valid."),
                LOC("$$$/Photos/Error/AlbumPathSub=The path or name of the album \"^1\" has not a valid from. The path must start with a \"/\". The album name (last portion of path) may not contain a \".\" or \"/\".", albumPath), "critical")
        return
    end

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

    writeSessionFile(
            albumPath,
            exportContext.propertyTable.ignoreAlbums,
            exportContext.propertyTable.ignoreRegex,
            "publish",
            exportContext.propertyTable.keepOldPhotos
    )

    writePhotosFile(photoIDs, albumPath)

    local queueEntry = createQueueEntry(albumPath)
    waitForPredecessors(queueEntry)

    -- Import photos in Photos app
    local result = sendPhotosToApp(albumPath)
    if (result ~= 0) then
        local errorMsg = "Error code from PhotosImport.app is " .. tostring(result)
        LrDialogs.message(LOC("$$$/Photos/Error/Import=Error while importing photos"),
                LOC("$$$/Photos/PlaceHolder=^1", errorMsg), "critical")
        deleteQueueEntry(queueEntry, albumPath)
        return
    end

    -- Wait till photos are imported by reading the session file
    local hasErrors, errorMsg = waitForPhotosApp(albumPath)
    if (hasErrors) then
        LrDialogs.message(LOC("$$$/Photos/Error/Import=Error while importing photos"), LOC("$$$/Photos/PlaceHolder=^1", errorMsg), "critical")
        deleteQueueEntry(queueEntry, albumPath)

        return
    end

    setPhotosID(albumPath)
    recordPhotoIDs(renditions)
    deleteQueueEntry(queueEntry, albumPath)
    logger.trace("PhotosPublishTask.processRenderedPhotos end")
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
    logger.trace("PhotosPublishTask.deletePhotosFromPublishedCollection start")
        -- LrMobdebug.start()
        -- LrMobdebug.on()
        local albumName = publishSettings.LR_publishedCollectionInfo.name
        logger.trace("albumName=" .. albumName)

    local albumPath = getFullAlbumPath(
                publishSettings.albumBy,
                publishSettings.useAlbum,
                publishSettings.rootFolder,
                publishSettings.albumNameForService,
                publishSettings.LR_publishedCollectionInfo.name)
    logger.trace("albumPath=" .. albumPath)


    if (not isValidAlbumPath(albumPath)) then
        LrDialogs.message(LOC("$$$/Photos/Error/AlbumPath=Album path is not valid."),
                LOC("$$$/Photos/Error/AlbumPathSub=The path or name of the album \"^1\" has not a valid from. The path must start with a \"/\". The album name (last portion of path) may not contain a \".\" or \"/\".", albumPath), "critical")
            return
        end

    writeSessionFile(albumPath, publishSettings.ignoreAlbums, publishSettings.ignoreRegex, "remove", publishSettings.keepOldPhotos)
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
    writePhotosFile(photoIDs, albumPath)

    local queueEntry = createQueueEntry(albumPath)
    waitForPredecessors(queueEntry)

    local result = sendPhotosToApp(albumPath)
        if (result ~= 0) then
            local errorMsg = "Error code from PhotosImport.app is " .. tostring(result)
            LrDialogs.message(LOC("$$$/Photos/Error/Import=Error while importing photos"),
                    LOC("$$$/Photos/PlaceHolder=^1", errorMsg), "critical")
            deleteQueueEntry(queueEntry, albumPath)

            return
        end

    local hasErrors, errorMsg = waitForPhotosApp(albumPath)
        if (hasErrors) then
            LrDialogs.message(LOC("$$$/Photos/Error/Import=Error while importing photos"), LOC("$$$/Photos/PlaceHolder=^1", errorMsg), "critical")
        end

    removePhotosID(albumPath)
    deleteQueueEntry(queueEntry, albumPath)

        for _, photosID in ipairs(arrayOfPhotoIds) do
            logger.trace("photosID to be deleted = " .. tostring(photosID))
            deletedCallback(photosID)
        end
    logger.trace("PhotosPublishTask.deletePhotosFromPublishedCollection end")

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





