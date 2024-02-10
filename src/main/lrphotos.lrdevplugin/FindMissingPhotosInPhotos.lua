--[[---------------------------------------------------------------------------
-- Created by Dieter Stockhausen
-- Created on 09.02.24
-----------------------------------------------------------------------------]]
local LrFunctionContext = import 'LrFunctionContext'
local LrDialogs = import 'LrDialogs'
local LrProgressScope = import 'LrProgressScope'
local LrApplication = import 'LrApplication'
local logger = require("Logger")
--[[---------------------------------------------------------------------------
ResetAttributes
-----------------------------------------------------------------------------]]
function findMissingPhotosInPhotosApp(context)
    logger.trace("findMissingPhotosInPhotosApp start")
    local activeCatalog = LrApplication.activeCatalog()
    local photos = activeCatalog:getTargetPhotos()

    if #photos == 0 then
        LrDialogs.message(
                LOC("$$$/Photos/Menu/Library/MissingInPhotos=Find Photos in Photos App with missing Lightroom Photos"),
                LOC("$$$/Photos/MsgInfo/NothingSelected=One or more photos must be selected."),
                "info"
        )
        logger.trace("No photos selected")
        logger.trace("findMissingPhotosInPhotosApp end")
        return
    end

    local result = LrDialogs.confirm(
            LOC("$$$/Photos/Menu/Library/MissingInPhotos=Find Photos in Photos App with missing Lightroom Photos"),
            LOC("$$$/Photos/Msg/MissingInPhotos=Search missing references for ^1 photo(s) in Lightroom.", #photos)
    )

    if result == "cancel" then
        logger.trace("Process interrupted by user request")
        logger.trace("findMissingPhotosInPhotosApp end")
        return
    end

    local progress = LrProgressScope({
        title = LOC("$$$/Photos/Menu/Library/MissingProcess=Searching for missing references for ^1 photo(s)", #photos),
        functionContext = context
    })

    progress:done()
    logger.trace("findMissingPhotosInPhotosApp end")
end

--[[---------------------------------------------------------------------------
Main function
-----------------------------------------------------------------------------]]
LrFunctionContext.callWithContext("FindMissingPhotosInPhotosApp", function(context)
    logger.trace("FindMissingPhotosInPhotos start")
    LrFunctionContext.postAsyncTaskWithContext("findMissingPhotosInPhotosApp", findMissingPhotosInPhotosApp)
    logger.trace("FindMissingPhotosInPhotos end")
end) -- end main function
