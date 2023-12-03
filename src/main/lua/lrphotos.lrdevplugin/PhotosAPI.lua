--[[---------------------------------------------------------------------------
-- Created by Dieter Stockhausen
-- Created on 29.05.21
-----------------------------------------------------------------------------]]
local LrApplication = import 'LrApplication'
local logger = require("Logger")

-- local LrMobdebug = import 'LrMobdebug' -- Import LR/ZeroBrane debug module

local PhotosAPI = {}

function PhotosAPI.getPhotosId(photo)
    return photo:getPropertyForPlugin(_PLUGIN, 'photosId')
end

function PhotosAPI.getPhotos(lrUUID)
    local activeCatalog = LrApplication.activeCatalog()
    logger.trace("lrUUID=" .. lrUUID)
    local foundPhoto = activeCatalog:findPhotoByUuid(lrUUID)
    logger.trace("Photo found via LR UUID:" .. tostring(foundPhoto))
    if (foundPhoto == nil) then
        -- Up to version 1.2 the photoId was the id of Photos app. Maybe we hav some old photos
        local foundPhotos = activeCatalog:findPhotos {
            searchDesc = {
                criteria = "sdktext:at.homebrew.lrphotos.photosId",
                operation = "any",
                value = lrUUID,
                value2 = "",
            }
        }
        foundPhoto = foundPhotos[1]
        logger.trace("Photos found via Photos UUID:" .. tostring(#foundPhotos))
    end

    return foundPhoto

end

return PhotosAPI
