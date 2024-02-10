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
resetPhotosAppAttributes
-----------------------------------------------------------------------------]]
function resetPhotosAppAttributes(context)
    logger.trace("resetPhotosAppAttributes start")

    local activeCatalog = LrApplication.activeCatalog()
    local photos = activeCatalog:getTargetPhotos()

    if #photos == 0 then
        LrDialogs.message(
                LOC("$$$/Photos/MsgMain/ResetAttributes=Reset Attributes"),
                LOC("$$$/Photos/MsgInfo/NothingSelected=One or more photos must be selected."),
                "info"
        )
        logger.trace("No photos selected")
        logger.trace("resetPhotosAppAttributes end")
        return
    end

    local result = LrDialogs.confirm(
            LOC("$$$/Photos/MsgMain/ResetAttributes=Reset Attributes"),
            LOC("$$$/Photos/Msg/ResetAttributes=Attributes for ^1 photo(s) will be deleted.", #photos)
    )

    if result == "cancel" then
        logger.trace("Process interrupted by user request")
        logger.trace("resetPhotosAppAttributes end")
        return
    end

    local progress = LrProgressScope({
        title = LOC("$$$/Photos/Menu/Library/ResetAttributesProgress=Reset attributes for ^1 photo(s)", #photos),
        functionContext = context
    })
    activeCatalog:withWriteAccessDo("Set Lightroom photo catalog", function()
        for _, photo in ipairs(photos) do
            photo:setPropertyForPlugin(_PLUGIN, 'photosId', nil)
            photo:setPropertyForPlugin(_PLUGIN, 'format', nil)
            photo:setPropertyForPlugin(_PLUGIN, 'localId', nil)
            photo:setPropertyForPlugin(_PLUGIN, 'catalogName', nil)
        end
    end)
    progress:done()
    logger.trace("resetPhotosAppAttributes end")
end

--[[---------------------------------------------------------------------------
Main function
-----------------------------------------------------------------------------]]
LrFunctionContext.callWithContext("ResetPhotosAppAttributes", function(context)
    logger.trace("ResetPhotosAppAttributes start")
    LrFunctionContext.postAsyncTaskWithContext("resetPhotosAppAttributes", resetPhotosAppAttributes)
    logger.trace("ResetPhotosAppAttributes end")
end) -- end main function
