--[[---------------------------------------------------------------------------
-- Created by Dieter Stockhausen
-- Created on 09.02.24
-----------------------------------------------------------------------------]]
local LrFunctionContext = import 'LrFunctionContext'
local LrDialogs = import 'LrDialogs'
local LrProgressScope = import 'LrProgressScope'
local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'
local LrFileUtils = import 'LrFileUtils'
local LrPathUtils = import 'LrFileUtils'

local Utils = require("Utils")
local logger = require("Logger")

--[[---------------------------------------------------------------------------
addToCollection
-----------------------------------------------------------------------------]]
local function addToCollection(photos)
    logger.trace("addToCollection() start")

    local catalog = LrApplication.activeCatalog()
    catalog:withWriteAccessDo("Create collection", function()
        logger.trace("Create collection set.")
        local mySet = catalog:createCollectionSet(LOC "$$$/Photos/CollectionSet/Photos=Photos", nil, true)

        logger.trace("Create collection.")
        local myColl = catalog:createCollection(LOC "$$$/Photos/Collection/MissingInPhotos=Missing in Photos", mySet, true)
        if myColl ~= nil then
            logger.trace("Add " .. #photos .. " photos to collection.")
            myColl:addPhotos(photos)
        end
    end) -- create collections
    logger.trace("addToCollection() end")

end
--[[---------------------------------------------------------------------------
processAnswer
LrUUID:filename:format
-----------------------------------------------------------------------------]]
local function processAnswer(maintenanceDir)
    logger.trace("processAnswer() start")

    local activeCatalog = LrApplication.activeCatalog()
    local f = assert(io.open(maintenanceDir .. "/fromPhotos/Photos.txt"), "r")
    local photos = {}

    activeCatalog:withWriteAccessDo("Maintenance", function()

        for line in f:lines() do
            logger.trace("Line: " .. line)
            local tokens = Utils.split(line, ":")
            logger.trace("#tokens=" .. #tokens)
            local lrUUID = tokens[1]
            logger.trace("LrUUID: " .. lrUUID)
            local photo = activeCatalog:findPhotoByUuid(lrUUID)
            logger.trace("Photo: " .. tostring(photo))

            if #tokens < 3 then
                logger.trace("Photos does not exist in Photos App")
                photos[#photos + 1] = photo
            else
                -- Previous version of Photos has no localID set which is used as filename in Photos
                if photo:getPropertyForPlugin(_PLUGIN, 'localId') == nil then
                    local filename = tokens[2]
                    logger.trace("filename: " .. filename)
                    logger.trace("Set " .. filename .. " as localId")
                    photo:setPropertyForPlugin(_PLUGIN, 'localId', filename)
                end
                -- Previous version of Photos has no format set
                if photo:getPropertyForPlugin(_PLUGIN, 'format') == nil then
                    local format = tokens[3]
                    logger.trace("format: " .. format)
                    logger.trace("Set " .. format .. " as format")
                    photo:setPropertyForPlugin(_PLUGIN, 'format', format)
                end
            end

        end
    end)
    f:close()
    if #photos > 0 then
        addToCollection(photos)
    end
    logger.trace("processAnswer() end")

end
--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function sendPhotosToApp(action, maintenanceDir)
    logger.trace("sendPhotosToApp() start")

    local command="empty"
    LrFileUtils.createAllDirectories(maintenanceDir .. "/fromPhotos")
    LrFileUtils.delete(maintenanceDir .. "/fromPhotos/photos.txt")

--[[
    if LrFileUtils.exists(LrPathUtils.child(_PLUGIN.path, "PhotosMaintenance/PhotosMaintenance.app")) then
        command = "osascript \"" .. LrPathUtils.child(_PLUGIN.path, "PhotosMaintenance/PhotosMaintenance.app") .. "\" "
                .. action
                .. " \"" .. maintenanceDir .. "\""
    else
        command = "osascript \"" .. LrPathUtils.child(_PLUGIN.path, "PhotosMaintenance.app") .. "\" "
                .. action
                .. " \"" .. maintenanceDir .. "\""
    end
    --]]
    logger.trace(command)
    -- local result = LrTasks.execute(command)
    logger.trace("sendPhotosToApp() end")
    return result
end

--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function waitForPhotosApp(maintenanceDir)
    logger.trace("waitForPhotosApp() start")
    local done = false

    local answerFile = maintenanceDir .. "/fromPhotos/photos.txt"
    while done == false do
        logger.trace("Photos App still not send an answer.")
        if LrFileUtils.exists(answerFile) then
            logger.trace("Photos App answer found.")
            done = true;
        end
        LrTasks.sleep(2)
    end
    logger.trace("waitForPhotosApp() end")
    return
end

--[[---------------------------------------------------------------------------
findMissingReferences
-----------------------------------------------------------------------------]]
local function createPhotosJobFile(photos)
    logger.trace("createPhotosJobFile start")
    logger.trace("#photos=" .. #photos)
    local job = ""
    local toBeProcessed = 0
    for _, photo in ipairs(photos) do
        local photosID = photo:getPropertyForPlugin(_PLUGIN, 'photosId')
        logger.trace("photosID=" .. tostring("photosID"))
        local catalogName = photo:getPropertyForPlugin(_PLUGIN, 'catalogName')
        logger.trace("catalogName=" .. tostring(catalogName))
        if photosID ~= nil and catalogName ~= nil then
            local lightroomID = photo:getRawMetadata("uuid")
            logger.trace("lightroomID=" .. tostring(lightroomID))
            job = job .. photosID .. ":" .. catalogName .. ":" .. lightroomID .. "\n"
            toBeProcessed = toBeProcessed + 1
        end
    end
    logger.trace("toBeProcessed=" .. toBeProcessed)
    if toBeProcessed == 0 then
        return nil, toBeProcessed
    end
    local photosFile = Utils.getPhotosFile("/maintenance/FromLightroom")
    logger.trace("photosFile=" .. photosFile)
    local f = assert(io.open(photosFile, "w+"))
    f:write(job)
    f:close()
    local comDir = Utils.getComDir("/maintenance")
    logger.trace("comDir=" .. tostring(comDir))
    logger.trace("createPhotosJobFile end")
    return comDir, toBeProcessed
end
--[[---------------------------------------------------------------------------
findMissingReferences
-----------------------------------------------------------------------------]]
local function findMissingReferences(photos)
    logger.trace("findMissingReferences start")

    local maintenanceDir, toBeProcessed = createPhotosJobFile(photos)
    logger.trace("maintenanceDir=" .. maintenanceDir)
    logger.trace("toBeProcessed=" .. toBeProcessed)

    if toBeProcessed == 0 then
        LrDialogs.message(
                LOC("$$$/Photos/Menu/Library/MissingInLightroom=Find Photos in Lightroom with missing Photos App Photos"),
                LOC("$$$/Photos/MsgError/NoPhotosFound=No photos found to be processed."),
                "info"
        )
        return
    end

    logger.trace("Create queue entry.")
    local queueEntry = Utils.createQueueEntry("Find missing references")

    logger.trace("Waiting for predecessors")
    Utils.waitForPredecessors(queueEntry)

    logger.trace("Send jobfile to app")
    sendPhotosToApp("photos-references", maintenanceDir)

    logger.trace("Wait for Photos app")
    waitForPhotosApp(maintenanceDir)

    logger.trace("Processing answer")
    processAnswer(maintenanceDir)

    logger.trace("Delete queue entry.")
    Utils.deleteQueueEntry(queueEntry)
    logger.trace("findMissingReferences end")
end
--[[---------------------------------------------------------------------------
findMissingPhotosInLightroom
-----------------------------------------------------------------------------]]
function findMissingPhotosInLightroom(context)
    logger.trace("findMissingPhotosInLightroom start")
    local activeCatalog = LrApplication.activeCatalog()
    local photos = activeCatalog:getTargetPhotos()

    if #photos == 0 then
        LrDialogs.message(
                LOC("$$$/Photos/Menu/Library/MissingInLightroom=Find Photos in Lightroom with missing Photos App Photos"),
                LOC("$$$/Photos/MsgInfo/NothingSelected=One or more photos must be selected."),
                "info"
        )
        logger.trace("No photos selected")
        logger.trace("findMissingPhotosInLightroom end")
        return
    end

    local result = LrDialogs.confirm(
            LOC("$$$/Photos/Menu/Library/MissingInLightroom=Find Photos in Lightroom with missing Photos App Photos"),
            LOC("$$$/Photos/Msg/MissingInLightroom=Search missing references for ^1 photo(s) in Photos App.", #photos)
    )

    if result == "cancel" then
        logger.trace("Process interrupted by user request")
        logger.trace("findMissingPhotosInLightroom end")
        return
    end

    local progress = LrProgressScope({
        title = LOC("$$$/Photos/Menu/Library/MissingProcess=Searching for missing references for ^1 photo(s)", #photos),
        functionContext = context
    })

    findMissingReferences(photos)

    progress:done()
    logger.trace("findMissingPhotosInLightroom end")
end

--[[---------------------------------------------------------------------------
Main function
-----------------------------------------------------------------------------]]
LrFunctionContext.callWithContext("FindMissingPhotosInLightroom", function(context)
    logger.trace("FindMissingPhotosInLightroom start")
    LrFunctionContext.postAsyncTaskWithContext("findMissingPhotosInLightroom", findMissingPhotosInLightroom)
    logger.trace("FindMissingPhotosInLightroom end")
end) -- end main function
