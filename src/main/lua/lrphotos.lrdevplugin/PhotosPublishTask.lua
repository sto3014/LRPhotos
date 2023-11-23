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


local function split (inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

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
    return albumName
end

local function createQueueEntry(exportContext )
    LrFileUtils.createDirectory(LrPathUtils.child(_PLUGIN.path, "Queue"))
    local queueEntryPath = LrFileUtils.chooseUniqueFileName(LrPathUtils.child(_PLUGIN.path, "Queue/queue-entry"))
    local f = assert(io.open(queueEntryPath , "w", "encoding=utf-8"))
    f:write(exportContext.publishedCollectionInfo.name)
    f:close()
    return LrPathUtils.leafName(queueEntryPath)
end

local function deleteQueueEntry(queueEntry)
   LrFileUtils.delete(LrPathUtils.child(_PLUGIN.path, "Queue/" .. queueEntry))
end

local function pairsByKeys (t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
    end
    return iter
end

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

function PhotosPublishTask.processRenderedPhotos(_, exportContext)
    logger.trace("name=" .. exportContext.publishedCollectionInfo.name)

    local exportSession = exportContext.exportSession
    local exportParams = exportContext.propertyTable
    -- Export message settings
    local nPhotos = exportSession:countRenditions()

    local progressScope = exportContext:configureProgress {
        title = nPhotos > 1
                and LOC('$$$/PhotosExportService/ProgressMany=Importing ^1 photos in Photo', nPhotos)
                or LOC '$$$/PhotosExportService/ProgressOne=Importing one photo in Photo',
    }

    -- Export the photos
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
    if (#files == 0) then
        return
    end

    local path = LrPathUtils.parent(files[1])
    logger.trace("path=" .. tostring(path))

    local albumName = getFullAlbumPath(exportContext)
    logger.trace("Album: " .. albumName)
    if (not isValidAlbumPath(albumName)) then
        LrDialogs.message(LOC("$$$/Photos/Error/AlbumPath=Album path is not valid."),
                LOC("$$$/Photos/Error/AlbumPathSub=The name of the album \"^1\" has not a valid from. The name must start with a slash but may NOT end with a slash.", albumName), "critical")
        return
    end

    local queueEntryName = createQueueEntry(exportContext)
    logger.trace("queueEntry=" .. queueEntryName)

    waitForPredecessors(queueEntryName)

    -- Write Lightroom input to a session.txt file for AppleScript later on
    local f = assert(io.open(path .. "/session.txt", "w+", "encoding=utf-8"))
    f:write("export_done=false\n")
    f:write("album_name=" .. albumName .. "\n")

    if exportParams.ignoreAlbums == true then
        f:write("ignoreByRegex=" .. exportParams.ignoreRegex .. "\n")
    end
    f:close()


    local g = assert(io.open(path .. "/photos.txt", "w+"))
    for _, photoID in ipairs(photoIDs) do
        logger.trace(photoID)
        g:write(photoID .. "\n")
    end
    g:close()

    if (debug) then
        LrFileUtils.delete("/tmp/session.txt")
        LrFileUtils.delete("/tmp/photos.txt")

        LrFileUtils.copy(path .. "/session.txt", "/tmp/session.txt")
        LrFileUtils.copy(path .. "/photos.txt", "/tmp/photos.txt")
    end

    -- Import photos in iPhoto and wait till photos are imported by reading the session file
    local importer_command = "osascript \"" .. LrPathUtils.child(_PLUGIN.path, "PhotosImport/PhotosImport.app") .. "\" " .. "\"" .. LrPathUtils.parent(files[1]) .. "\""
    logger.trace(importer_command)
    local result = LrTasks.execute(importer_command)
    if (result ~= 0) then
        errorMsg = "Error code from PhotosImport.app is " .. tostring(result)
        LrDialogs.message(LOC("$$$/Photos/Error/Import=Error while importing photos"),
                LOC("$$$/Photos/PlaceHolder=^1", errorMsg), "critical")
        deleteQueueEntry(queueEntryName)
        return
    end

    -- Wait for the import to be done
    local done = false
    local hasErrors = false
    local errorMsg = ""
    while done ~= true and hasErrors ~= true do
        LrTasks.sleep(2)
        local f = assert(io.open(path .. "/session.txt", "r"))
        for line in f:lines() do
            logger.trace("waiting..." .. line)
            if string.find(line, 'export_done=true') then
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
    if (hasErrors) then
        if (debug) then
            LrFileUtils.delete("/tmp/session.txt")
            LrFileUtils.copy(path .. "/session.txt", "/tmp/session.txt")
            LrDialogs.message(LOC("$$$/Photos/Error/Import=Error while importing photos"), LOC("$$$/Photos/PlaceHolder=^1", errorMsg), "critical")
            deleteQueueEntry(queueEntryName)
        end
        return
    end


    -- retrieve the remote photo ids from photos.txt and store these in the metadata of the LR photos
    local activeCatalog = LrApplication.activeCatalog()
    local f = assert(io.open(path .. "/photos.txt", "r"))

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

    deleteQueueEntry(queueEntryName)

end

function PhotosPublishTask.getCollectionBehaviorInfo(publishSettings)

    return {
        -- defaultCollectionName = LOC "$$$/Photos/DefaultCollectionName/Photostream=Photostream",
        defaultCollectionCanBeDeleted = true,
        canAddCollection = true,
        maxCollectionSetDepth = 0,
        -- Collection sets are not supported through the Flickr sample plug-in.
    }

end

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

function PhotosPublishTask.startDialog(propertyTable)

    -- LrMobdebug.on()
    if not propertyTable.LR_editingExistingPublishConnection then
        propertyTable.LR_jpeg_quality = 0.85
        propertyTable.LR_removeLocationMetadata = false
        propertyTable.LR_removeFaceMetadata = false
    end
end

