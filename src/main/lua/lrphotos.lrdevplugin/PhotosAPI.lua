--[[---------------------------------------------------------------------------
-- Created by Dieter Stockhausen
-- Created on 29.05.21
-----------------------------------------------------------------------------]]
local LrApplication = import 'LrApplication'
local logger = require("Logger")

-- local LrMobdebug = import 'LrMobdebug' -- Import LR/ZeroBrane debug module

PhotosAPI = {}

function PhotosAPI.getPhotosId(photo)
    return photo:getPropertyForPlugin(_PLUGIN, 'photosId')
end

function PhotosAPI.resetPhotoId(photoId)
    LrMobdebug.start()
    LrMobdebug.on()
    local activeCatalog = LrApplication.activeCatalog()

    local foundPhotos = activeCatalog:findPhotos {
        searchDesc = {
            criteria = "sdktext:at.homebrew.lrphotos.photosId",
            operation = "any",
            value = photoId,
            value2 = "",
        }
    }

    activeCatalog:withWriteAccessDo("Reset photos ID", function()
        for i, photo in ipairs(foundPhotos) do
            logger.trace("Reset photoId: " .. photoId)
            photo:setPropertyForPlugin(_PLUGIN, 'photosId', "")
        end

    end )


end
