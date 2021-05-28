--[[---------------------------------------------------------------------------
-- Created by Simon Schoeters
-- Created in 2011
-----------------------------------------------------------------------------]]--


local LrView = import 'LrView'

require 'PhotosUploadExportDialogSections'
require 'PhotosImportTask'

local PhotosServiceProvider = {
  hideSections = {  'postProcessing' },
  canExportVideo = true,
  exportPresetFields = {
    { key = 'createAlbum', default = true },
    { key = 'album', default = LOC '$$$/iPhotoExportService/UnknownAlbum=From Lightroom' },
  },
  sectionsForBottomOfDialog = iPhotoUploadExportDialogSections.sectionsForBottomOfDialog,
  processRenderedPhotos = iPhotoImportTask.processRenderedPhotos,
  supportsIncrementalPublish = true
}

return PhotosServiceProvider