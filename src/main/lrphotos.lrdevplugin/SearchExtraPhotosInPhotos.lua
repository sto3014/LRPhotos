--[[---------------------------------------------------------------------------
-- Created by Dieter Stockhausen
-- Created on 09.02.24
-----------------------------------------------------------------------------]]
local LrFunctionContext = import 'LrFunctionContext'
local LrDialogs = import 'LrDialogs'
local LrProgressScope = import 'LrProgressScope'
local LrApplication = import 'LrApplication'
local LrPathUtils = import 'LrPathUtils'
local LrTasks = import 'LrTasks'
local LrFileUtils = import 'LrFileUtils'

local Utils = require("Utils")
local logger = require("Logger")

--[[---------------------------------------------------------------------------
getAllPublishedPhotos
-----------------------------------------------------------------------------]]

local function getAllPublishedPhotos()
    local activeCatalog = LrApplication.activeCatalog()
    local foundPhotos = activeCatalog:findPhotos {
        searchDesc = {
            criteria = "sdktext:at.homebrew.lrphotos.photosId",
            operation = "notEmpty",
            value = "",
            value2 = "",
        }
    }
    logger.trace("Photos found via Photos UUID:" .. tostring(#foundPhotos))
    return foundPhotos
end
--[[---------------------------------------------------------------------------
createPhotosJobFile
-----------------------------------------------------------------------------]]
local function createPhotosJobFile(photos)
    logger.trace("createPhotosJobFile start")
    logger.trace("#photos=" .. #photos)
    local job = ""
    local catalogNames = ""
    for _, photo in ipairs(photos) do
        local photosID = photo:getPropertyForPlugin(_PLUGIN, 'photosId')
        logger.trace("photosID=" .. tostring("photosID"))
        local catalogName = photo:getPropertyForPlugin(_PLUGIN, 'catalogName')
        logger.trace("catalogName=" .. tostring(catalogName))
        if photosID ~= nil and catalogName ~= nil then
            if string.find(catalogNames, catalogName, 1, true) == nil then
                if catalogNames == "" then
                    catalogNames = catalogName
                else
                    catalogNames = catalogNames .. ":" .. catalogName
                end
                logger.trace("catalogNames=" .. catalogNames)
            end
            job = job .. photosID .. "\n"
        end
    end
    local photosFile = Utils.getPhotosFile("/maintenance/FromLightroom")
    logger.trace("photosFile=" .. photosFile)
    local f = assert(io.open(photosFile, "w+"))
    f:write(job)
    f:close()
    local comDir = Utils.getComDir("/maintenance")
    logger.trace("comDir=" .. tostring(comDir))
    logger.trace("createPhotosJobFile end")
    return comDir, catalogNames
end
--[[---------------------------------------------------------------------------
sendPhotosToApp
-----------------------------------------------------------------------------]]
local function sendPhotosToApp(action, maintenanceDir, catalogNames, albumName)
    logger.trace("sendPhotosToApp() start")

    local command = ""
    LrFileUtils.delete(maintenanceDir .. "/fromPhotos/photos.txt")
    logger.trace("1")
    local exePathDev = _PLUGIN.path .. "/" .. "PhotosMaintenance/PhotosMaintenance.app"
    local exePathProd = _PLUGIN.path .. "/" .. "PhotosMaintenance.app"
    logger.trace("exePathDev=" .. tostring(exePathDev))
    if LrFileUtils.exists(exePathDev) then
        logger.trace("2")
        command = "osascript \"" .. exePathDev .. "\""
                .. " " .. action
                .. " \"" .. maintenanceDir .. "\""
                .. " \"" .. catalogNames .. "\""
                .. " \"" .. albumName .. "\""
    else
        logger.trace("3")
        command = "osascript \"" .. exePathProd .. "\""
                .. " " .. action
                .. " \"" .. maintenanceDir .. "\""
                .. " \"" .. catalogNames .. "\""
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
processAnswer
LrUUID:filename:format
-----------------------------------------------------------------------------]]
local function processAnswer(maintenanceDir)
    logger.trace("processAnswer() start")

    local f = assert(io.open(maintenanceDir .. "/fromPhotos/Photos.txt"), "r")

    local answer = f:read()
    if string.find(answer, "Error", 1, true) ~= nil then
        LrDialogs.message(
                LOC("$$$/Photos/Menu/Library/ExtraInPhotos=Search extra Photos in Photos App"),
                LOC("$$$/Photos/MsgError/GeneralErrorExtra=Error while searching for extra photos. Message was: ^1", answer),
                "error"
        )
    else
        if answer ~= "0" then
            LrDialogs.message(
                    LOC("$$$/Photos/Menu/Library/ExtraInPhotos=Search extra Photos in Photos App"),
                    LOC("$$$/Photos/MsgError/ExtraPhotosFound=^1 extra photo(s) found. See album '^2' for a list of extra photos.", answer,
                    LOC("$$$/Photos/Album/ExtraInPhotos=/Lightroom/Extra Photos")),
                    "error"
            )
        else
            LrDialogs.message(
                    LOC("$$$/Photos/Menu/Library/ExtraInPhotos=Search extra Photos in Photos App"),
                    LOC("$$$/Photos/MsgError/NoExtraPhotosFound=No extra photos were found in Photos."),
                    "info"
            )
        end
    end
    f:close()
    logger.trace("processAnswer() end")

end

--[[---------------------------------------------------------------------------
searchExtraPhotos
-----------------------------------------------------------------------------]]
local function searchExtraPhotos(photos)
    logger.trace("searchExtraPhotos start")

    local maintenanceDir, catalogNames = createPhotosJobFile(photos)
    logger.trace("maintenanceDir=" .. maintenanceDir)

    local currentCatalogName = LrPathUtils.leafName(LrApplication.activeCatalog():getPath())
    if catalogNames == "" or string.find(catalogNames, currentCatalogName, 1, true) == nil then
        if catalogNames == "" then
            catalogNames = currentCatalogName
        else
            catalogNames = catalogNames .. ":" .. currentCatalogName
        end
    end
    logger.trace("catalogNames=" .. catalogNames)

    logger.trace("Create queue entry.")
    local queueEntry = Utils.createQueueEntry("Find extra photos")

    logger.trace("Waiting for predecessors")
    Utils.waitForPredecessors(queueEntry)

    logger.trace("Send jobfile to app")
    local result = sendPhotosToApp("extra-photos", maintenanceDir, catalogNames, LOC("$$$/Photos/Album/ExtraInPhotos=/Lightroom/Extra Photos"))
    if (result ~= 0) then
        local errorMsg = "Error code from PhotosImport.app is " .. tostring(result)
        LrDialogs.message(LOC("$$$/Photos/Error/ExtraPhotos=Error in Photos app while searching for extra  photos."),
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
    logger.trace("searchExtraPhotos end")
end

--[[---------------------------------------------------------------------------
searchExtraPhotosInPhotosApp
-----------------------------------------------------------------------------]]
function searchExtraPhotosInPhotosApp(context)
    logger.trace("searchExtraPhotosInPhotosApp start")
    local photos = getAllPublishedPhotos()

    local result = LrDialogs.confirm(
            LOC("$$$/Photos/Menu/Library/ExtraInPhotos=Search extra Photos in Photos App"),
            LOC("$$$/Photos/Msg/ExtraInPhotos=Search extra photos in Photos app. Currently, there are ^1 published photo(s) in Lightroom.", #photos)
    )

    if result == "cancel" then
        logger.trace("Process interrupted by user request")
        logger.trace("findMissingPhotosInPhotosApp end")
        return
    end

    local progress = LrProgressScope({
        title = LOC("$$$/Photos/Menu/Library/ExtraProcess=Searching for extra Photos in Photos App", #photos),
        functionContext = context
    })
    searchExtraPhotos(photos)
    progress:done()
    logger.trace("searchExtraPhotosInPhotosApp end")
end

--[[---------------------------------------------------------------------------
Main function
-----------------------------------------------------------------------------]]
LrFunctionContext.callWithContext("SearchExtraPhotosInPhotosApp", function(context)
    logger.trace("SearchExtraPhotosInPhotosApp start")
    LrFunctionContext.postAsyncTaskWithContext("searchExtraPhotosInPhotosApp", searchExtraPhotosInPhotosApp)
    logger.trace("SearchExtraPhotosInPhotosApp end")
end) -- end main function
