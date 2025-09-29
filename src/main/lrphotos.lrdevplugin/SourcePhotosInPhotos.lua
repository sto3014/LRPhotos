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
local LrPathUtils = import 'LrPathUtils'


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
        local myColl = catalog:createCollection(LOC "$$$/Photos/Collection/MissingInPhotos=Missing in Photos", mySet,
            true)
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

    local countSourcePhotos = -1
    activeCatalog:withWriteAccessDo("Maintenance", function()
        for line in f:lines() do
            logger.trace("Line: " .. line)
            if string.find(line, "Error", 1, true) ~= nil then
                LrDialogs.message(
                    LOC("$$$/Photos/Error/SourcePhotos=Error in Photos app while searching for source photos."),
                    LOC(
                        "$$$/Photos/MsgError/GeneralErrorMissing=Error while searching for missing references. Message was: ^1",
                        line),
                    "error")
                return
            end
            if string.find(line, "count=", 1, true) ~= nil then
                local tokens = Utils.split(line, "=")
                logger.trace("#tokens=" .. #tokens)
                countSourcePhotos = math.floor(math.abs(tonumber(tokens[2])))
                logger.trace("countSourcePhotos=" .. tostring(countSourcePhotos))

            end
        end
    end)
    f:close()
    if countSourcePhotos < 0 then
        LrDialogs.message(
            LOC("$$$/Photos/Menu/Library/SourceFromPhotos=Search source Photos in Photos App"),
            LOC("$$$/Photos/Error/SourcePhotosUnexpectedAnswer=Unexpected return value from Photos App"),
            "error"
        )
    else
        LrDialogs.message(
            LOC("$$$/Photos/Menu/Library/SourceFromPhotos=Search source Photos in Photos App"),
            LOC("$$$/Photos/Msg/SourcePhotosFound=Added ^1 source photo(s) into album ^2.", countSourcePhotos, LOC("$$$/Photos/Album/SourcePhotos=/LR Photos/Source Photos")),
            "info"
        )
    end
    logger.trace("processAnswer() end")
end
--[[---------------------------------------------------------------------------
sendPhotosToApp
-----------------------------------------------------------------------------]]
local function sendPhotosToApp(action, maintenanceDir, albumName)
    logger.trace("sendPhotosToApp() start")

    local command = ""
    LrFileUtils.delete(maintenanceDir .. "/fromPhotos/photos.txt")
    local exePathDev = _PLUGIN.path .. "/" .. "PhotosMaintenance/PhotosMaintenance.app"
    local exePathProd = _PLUGIN.path .. "/" .. "PhotosMaintenance.app"
    logger.trace("exePathDev=" .. tostring(exePathDev))
    if LrFileUtils.exists(exePathDev) then
        command = "osascript \"" .. exePathDev .. "\" "
            .. action
            .. " \"" .. maintenanceDir .. "\""
              .. " \"" .. albumName .. "\""
        else
        command = "osascript \"" .. exePathProd .. "\" "
            .. action
            .. " \"" .. maintenanceDir .. "\""
              .. " \"" .. albumName .. "\""
    end

    logger.trace("command=" .. tostring(command))
    local result = LrTasks.execute(command)
    logger.trace("result=" .. tostring(result))
    logger.trace("sendPhotosToApp() end")
    return result
end

--[[---------------------------------------------------------------------------
waitForPhotosApp
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
createPhotosJobFile
-----------------------------------------------------------------------------]]
local function createPhotosJobFile(photos)
    logger.trace("createPhotosJobFile start")
    logger.trace("#photos=" .. #photos)
    local job = ""
    local toBeProcessed = 0
    for _, photo in ipairs(photos) do
        local leafName = LrPathUtils.leafName(LrPathUtils.removeExtension(photo:getRawMetadata("path")))
        job = job .. leafName .. "\n"
        toBeProcessed = toBeProcessed + 1
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
searchMissingReferences
-----------------------------------------------------------------------------]]
local function findSourcePhotos(photos)
    logger.trace("findSourcePhotos start")

    local maintenanceDir, toBeProcessed = createPhotosJobFile(photos)
    logger.trace("maintenanceDir=" .. maintenanceDir)
    logger.trace("toBeProcessed=" .. toBeProcessed)

    logger.trace("Create queue entry.")
    local queueEntry = Utils.createQueueEntry("Find source photos")

    logger.trace("Waiting for predecessors")
    Utils.waitForPredecessors(queueEntry)

    logger.trace("Send jobfile to app")
    local result = sendPhotosToApp("source-photos", maintenanceDir, LOC("$$$/Photos/Album/SourcePhotos=/LR Photos/Source Photos"))
    if (result ~= 0) then
        local errorMsg = "Error code from PhotosImport.app is " .. tostring(result)
        LrDialogs.message(
            LOC("$$$/Photos/Error/SourcePhotos=Error in Photos app while searching for source photos."),
            LOC("$$$/Photos/PlaceHolder=^1", errorMsg), "critical")
        Utils.deleteQueueEntry(queueEntry)
        return
    end

    logger.trace("Wait for Photos app")
    waitForPhotosApp(maintenanceDir)

    logger.trace("Processing answer")
    processAnswer(maintenanceDir)

    logger.trace("Delete queue entry.")
    Utils.deleteQueueEntry(queueEntry)
    logger.trace("findSourcePhotos end")
end
--[[---------------------------------------------------------------------------
searchMissingPhotosInLightroom
-----------------------------------------------------------------------------]]
function searchSourcePhotosInPhotos(context)
    logger.trace("searchSourcePhotosInPhotos start")
    local activeCatalog = LrApplication.activeCatalog()
    local photos = activeCatalog:getTargetPhotos()

    if #photos == 0 then
        LrDialogs.message(
            LOC("$$$/Photos/Menu/Library/SourceFromPhotos=Search source Photos in Photos App"),
            LOC("$$$/Photos/MsgInfo/NothingSelected=One or more photos must be selected."),
            "info"
        )
        logger.trace("No photos selected")
        logger.trace("searchSourcePhotosInPhotos end")
        return
    end

    local result = LrDialogs.confirm(
        LOC("$$$/Photos/Menu/Library/SourceFromPhotos=Search source Photos in Photos App"),
        LOC("$$$/Photos/Msg/SourcePhotosInPhotos=Search source photos for ^1 photo(s) in Photos App.", #photos)
    )

    if result == "cancel" then
        logger.trace("Process interrupted by user request")
        logger.trace("searchSourcePhotosInPhotos end")
        return
    end

    local progress = LrProgressScope({
        title = LOC("$$$/Photos/Msg/SourcePhotosInPhotos=Search source photos for ^1 photo(s) in Photos App.", #photos),
        functionContext = context
    })

    findSourcePhotos(photos)

    progress:done()
    logger.trace("searchSourcePhotosInPhotos end")
end

--[[---------------------------------------------------------------------------
Main function
-----------------------------------------------------------------------------]]
LrFunctionContext.callWithContext("SearchSourcePhotosInPhotos", function(context)
    logger.trace("SearchSourcePhotosInPhotos start")
    LrFunctionContext.postAsyncTaskWithContext("searchSourcePhotosInPhotos", searchSourcePhotosInPhotos)
    logger.trace("SearchSourcePhotosInPhotos end")
end) -- end main function
