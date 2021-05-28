--[[---------------------------------------------------------------------------
-- Created by Simon Schoeters
-- Created in 2011
-----------------------------------------------------------------------------]]--

local LrPathUtils = import 'LrPathUtils'
local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'
local LrDialogs = import 'LrDialogs'

local logger = require("Logger")
require ("PluginInit")

iPhotoImportTask = {}

local function split (inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function iPhotoImportTask.processRenderedPhotos(_, exportContext)

    local exportSession = exportContext.exportSession
    local exportParams = exportContext.propertyTable

    -- Export message settings
    local nPhotos = exportSession:countRenditions()
    local progressScope = exportContext:configureProgress {
        title = nPhotos > 1
                and LOC('$$$/iPhotoExportService/ProgressMany=Importing ^1 photos in iPhoto', nPhotos)
                or LOC '$$$/iPhotoExportService/ProgressOne=Importing one photo in iPhoto',
    }

    -- Export the photos
    local files = {}

    local photoIDs = {}

    for i, rendition in exportContext:renditions { stopIfCanceled = true } do

        local photo = rendition.photo
        local success, pathOrMessage = rendition:waitForRender()

        if progressScope:isCanceled() then
            break
        end -- Check for cancellation again after photo has been rendered
        if success then
            table.insert(files, pathOrMessage)
            local lrcatName = LrPathUtils.leafName( LrPathUtils.removeExtension(photo.catalog:getPath()))

            local pID = photo:getPropertyForPlugin(PluginInit.pluginID, 'photosId')
            if ( pID == nil) then
                pID = ""
            end
            table.insert(photoIDs,pathOrMessage .. ":" .. photo:getRawMetadata("uuid") .. ":" .. lrcatName .. ":" .. pID)
        end

    end

    local path = LrPathUtils.parent(files[1])

    -- Write Lightroom input to a session.txt file for AppleScript later on
    local f = assert(io.open(path .. "/session.txt", "w+"))
    f:write("export_done=false\n")
    if exportParams.createAlbum == true then
        f:write("album_name=" .. exportParams.album .. "\n")
    end
    f:close()

    local g = assert(io.open(path .. "/photos.txt", "w+"))
    for _, photoID in ipairs(photoIDs) do
        logger.trace(photoID)
        g:write(photoID .. "\n")
    end
    g:close()

    -- Import photos in iPhoto and wait till photos are imported by reading the session file
    local importer_command = "osascript \"" .. LrPathUtils.child(_PLUGIN.path, "PhotosImport/PhotosImport.app") .. "\" " .. LrPathUtils.parent(files[1])
    LrTasks.execute(importer_command)

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
    if ( hasErrors) then
        LrDialogs.message(LOC("$$$/Photos/Error/Import=Error while importing photos"), LOC("$$$/Photos/PlaceHolder=^1", errorMsg), "critical")
        return
    end

    local activeCatalog = LrApplication.activeCatalog()

    local f = assert(io.open(path .. "/photos.txt", "r"))

    activeCatalog:withWriteAccessDo("Set photos ID", function()
        for line in f:lines() do
            logger.trace("Line: " .. line)
            local tokens = split( line, ":")
            logger.trace("LrID: " .. tokens[2])
            local photo = activeCatalog:findPhotoByUuid(tokens[2])
            logger.trace("Photo: " .. tostring(photo))
            if ( photo ~= nil) then
                logger.trace("PhotosID: " .. tokens[4])
                photo:setPropertyForPlugin(_PLUGIN, 'photosId', tokens[4])
            end
        end
    end)
    f:close()


end
