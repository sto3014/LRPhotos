--[[---------------------------------------------------------------------------
-- Initial created by Simon Schoeters in 2011
--
-- 2021-05-29 Dieter Stockhausen. Add publishing functionality
-----------------------------------------------------------------------------]]--

local LrPathUtils = import 'LrPathUtils'
local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'
local LrDialogs = import 'LrDialogs'


local logger = require("Logger")
require("PhotosAPI")

--local LrMobdebug = import 'LrMobdebug' -- Import LR/ZeroBrane debug module
--LrMobdebug.start()

PhotosPublishTask = {}

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

function PhotosPublishTask.processRenderedPhotos(_, exportContext)

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

    -- Write Lightroom input to a session.txt file for AppleScript later on
    local f = assert(io.open(path .. "/session.txt", "w+"))
    f:write("export_done=false\n")
    if exportParams.useAlbum == true then
        logger.trace("Album: " .. exportParams.albumName)
        f:write("album_name=" .. exportParams.albumName .. "\n")
    end
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

    -- Import photos in iPhoto and wait till photos are imported by reading the session file
    local importer_command = "osascript \"" .. LrPathUtils.child(_PLUGIN.path, "PhotosImport/PhotosImport.app") .. "\" " .. "\"" .. LrPathUtils.parent(files[1]) .. "\""
    logger.trace(importer_command)
    local result = LrTasks.execute(importer_command)
    if (result ~= 0) then
        errorMsg = "Error code from PhotosImport.app is " .. tostring(result)
        LrDialogs.message(LOC("$$$/Photos/Error/Import=Error while importing photos"),
                LOC("$$$/Photos/PlaceHolder=^1", errorMsg), "critical")
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
        LrDialogs.message(LOC("$$$/Photos/Error/Import=Error while importing photos"), LOC("$$$/Photos/PlaceHolder=^1", errorMsg), "critical")
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
        if not rendition.wasSkipped then
            local photoId = PhotosAPI.getPhotosId(photo)
            if (photoId ~= nil) then
                rendition:recordPublishedPhotoId(photoId)
            end
        end
    end

end

function PhotosPublishTask.getCollectionBehaviorInfo(publishSettings)

    return {
        defaultCollectionName = LOC "$$$/Photos/DefaultCollectionName/Photostream=Photostream",
        defaultCollectionCanBeDeleted = false,
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

function PhotosPublishTask.deletePhotosFromPublishedCollection( publishSettings, arrayOfPhotoIds, deletedCallback )
    for _, photoId in ipairs( arrayOfPhotoIds ) do
        PhotosAPI.resetPhotoId(photoId)
        deletedCallback( photoId )
    end
end


