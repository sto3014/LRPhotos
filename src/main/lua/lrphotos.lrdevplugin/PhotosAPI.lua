--[[---------------------------------------------------------------------------
-- Created by Dieter Stockhausen
-- Created on 29.05.21
-----------------------------------------------------------------------------]]

PhotosAPI = {}

function PhotosAPI.getPhotosID(photo)
    return photo:getPropertyForPlugin(PluginInit.pluginID, 'photosId')
end