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
    local missingPhotos = {}

    activeCatalog:withWriteAccessDo("Maintenance", function()

        for line in f:lines() do
            logger.trace("Line: " .. line)
            local tokens = Utils.split(line, ":")
            logger.trace("#tokens=" .. #tokens)
            local lrUUID = tokens[1]
            logger.trace("LrUUID: " .. lrUUID)
            local photo = activeCatalog:findPhotoByUuid(lrUUID)
            logger.trace("Photo: " .. tostring(photo))

            logger.trace("tokens[2]=" .. tostring(tokens[2]))
            if tokens[2] == "missing" then
                logger.trace("Photos does not exist in Photos App")
                missingPhotos[#missingPhotos + 1] = photo
            end

        end
    end)
    f:close()
    if #missingPhotos > 0 then
        addToCollection(missingPhotos)
        LrDialogs.message(
                LOC("$$$/Photos/Menu/Library/MissingInLightroom=Find Photos in Lightroom with missing Photos App Photos"),
                LOC("$$$/Photos/MsgError/MissingPhotosFound=^1 published Lightroom photos could not be found in Photos.", #missingPhotos),
                "error"
        )
    else
        LrDialogs.message(
                LOC("$$$/Photos/Menu/Library/MissingInLightroom=Find Photos in Lightroom with missing Photos App Photos"),
                LOC("$$$/Photos/MsgError/AllPhotosFound=All published Lightroom photos were found in Photos."),
                "info"
        )
    end
    logger.trace("processAnswer() end")

end
--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
local function sendPhotosToApp(action, maintenanceDir)
    logger.trace("sendPhotosToApp() start")

    local command = ""
    LrFileUtils.delete(maintenanceDir .. "/fromPhotos/photos.txt")
    logger.trace("1")
    local exePathDev = _PLUGIN.path .. "/" .. "PhotosMaintenance/PhotosMaintenance.app"
    local exePathProd = _PLUGIN.path .. "/" .. "PhotosMaintenance.app"
    logger.trace("exePathDev=" .. tostring(exePathDev))
    if LrFileUtils.exists(exePathDev) then
        logger.trace("2")
        command = "osascript \"" .. exePathDev .. "\" "
                .. action
                .. " \"" .. maintenanceDir .. "\""
    else
        logger.trace("3")
        command = "osascript \"" .. exePathProd .. "\" "
                .. action
                .. " \"" .. maintenanceDir .. "\""
    end

    logger.trace("command=" .. tostring(command))
    local result = LrTasks.execute(command)
    logger.trace("result=" .. tostring(result))
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
            if LrFileUtils.exists(answerFile .. ".lck") then
                logger.trace("Photos App is writing the answer.")
            else
                logger.trace("Photos App answer found.")
                done = true;
            end
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
    local result = sendPhotosToApp("photos-references", maintenanceDir)
    if (result ~= 0) then
        local errorMsg = "Error code from PhotosImport.app is " .. tostring(result)
        LrDialogs.message(LOC("$$$/Photos/Error/Import=Error while importing photos"),
                LOC("$$$/Photos/PlaceHolder=^1", errorMsg), "critical")
        deleteQueueEntry(queueEntry)
        return
    end

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
