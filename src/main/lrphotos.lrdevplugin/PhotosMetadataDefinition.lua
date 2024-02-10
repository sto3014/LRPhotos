--[[---------------------------------------------------------------------------
-- Created by Dieter Stockhausen
-- Created on 31.05.21
-----------------------------------------------------------------------------]]
local LrPrefs = import("LrPrefs")
local logger = require("Logger")

-------------------------------------------------------------------------------

local PhotosMetadataDefinition = {
    metadataFieldsForPhotos = {
        {
            id = 'siteId',
        },

        {
            id = 'photosId',
            title = LOC "$$$/Photos/Metadata/Fields/PhotosId=Photos ID",
            dataType = 'string', -- Specifies the data type for this field.
            searchable = true,
            browsable = true,
            readOnly = false,
        },
        {
            id = 'localId',
            title = LOC "$$$/Photos/Metadata/Fields/LocalId=Local ID",
            dataType = 'string', -- Specifies the data type for this field.
            searchable = true,
            browsable = true,
            readOnly = false,
        },
        {
            id = 'catalogName',
            title = LOC "$$$/Photos/Metadata/Fields/CatalogName=Catalog name",
            dataType = 'string', -- Specifies the data type for this field.
            searchable = true,
            browsable = true,
            readOnly = false,
        },
        {
            id = 'format',
            title = LOC "$$$/Photos/Metadata/Fields/Format=Format",
            dataType = 'string', -- Specifies the data type for this field.
            searchable = true,
            browsable = true,
            readOnly = false,
        },
    },

    schemaVersion = 1, -- must be a number, preferably a positive integer
}

-------------------------------------------------------------------------------

function PhotosMetadataDefinition.updateFromEarlierSchemaVersion(catalog, previousSchemaVersion)
    -- Note: This function is called from within a catalog:withPrivateWriteAccessDo
    -- block. You should not call any of the with___Do functions yourself.

    catalog:assertHasPrivateWriteAccess("CustomMetadataDefinition.updateFromEarlierSchemaVersion")

--[[
    if previousSchemaVersion == 1 then

        -- Retrieve photos that have been used already with the custom metadata.

        local photosToMigrate = catalog:findPhotosWithProperty(_PLUGIN, 'siteId')

        -- Optional:  can add property version number here.

        for _, photo in ipairs(photosToMigrate) do
            local oldSiteId = photo:getPropertyForPlugin(_PLUGIN, 'siteId') -- add property version here if used above
            local newSiteId = "new:" .. oldSiteId -- replace this with whatever data transformation you need to do
            photo:setPropertyForPlugin(_PLUGIN, 'siteId', newSiteId)
        end
    elseif previousSchemaVersion == 2 then

        -- Optional area to do further processing etc.
    end
]]
end

-------------------------------------------------------------------------------
local prefs = LrPrefs.prefsForPlugin()
if (prefs.osSupported) then
    return PhotosMetadataDefinition
else
    return {metadataFieldsForPhotos = {}, schemaVersion = 1}
end
