--[[---------------------------------------------------------------------------
-- Created by Dieter Stockhausen
-- Created on 2021-05-27
-----------------------------------------------------------------------------]]--


local LrView = import 'LrView'

require 'PhotosUploadExportDialogSections'
require 'PhotosImportTask'

return {
  sectionsForBottomOfDialog = iPhotoUploadExportDialogSections.sectionsForBottomOfDialog,
  processRenderedPhotos = iPhotoImportTask.processRenderedPhotos,
}
