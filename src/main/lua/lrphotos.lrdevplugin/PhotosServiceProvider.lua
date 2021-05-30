--[[---------------------------------------------------------------------------
-- Created by Simon Schoeters
-- Created in 2011
-----------------------------------------------------------------------------]]--


local LrView = import 'LrView'

require 'PhotosPublishDialogSections'
require 'PhotosPublishTask'

local PhotosServiceProvider = {
  hideSections = {  'postProcessing', 'exportLocation'},
  -- hideSections = {  'postProcessing'},
  exportPresetFields = {
    { key = 'useAlbum', default = true },
    { key = 'albumName', default = LOC '$$$/PhotosExportService/NewAlbum=Lightroom/Import' },
    { key = 'ignoreAlbums', default = true },
    { key = 'ignoreRegex', default = "^!|!$" },
  },
  canExportVideo = true,
  sectionsForBottomOfDialog = PhotosPublishDialogSections.sectionsForBottomOfDialog,
  processRenderedPhotos = PhotosPublishTask.processRenderedPhotos,
  getCollectionBehaviorInfo = PhotosPublishTask.getCollectionBehaviorInfo,
  metadataThatTriggersRepublish = PhotosPublishTask.metadataThatTriggersRepublish,
  updateExportSettings = PhotosPublishTask.updateExportSettings,
  didCreateNewPublishService= PhotosPublishTask.didCreateNewPublishService,
  viewForCollectionSettings = PhotosPublishTask.viewForCollectionSettings,
  viewForCollectionSetSettings = PhotosPublishTask.viewForCollectionSetSettings,
  supportsIncrementalPublish = 'only',
  small_icon = 'photos_small.png',
  publish_fallbackNameBinding = 'fullname',
  titleForGoToPublishedCollection  = 'disable'
}

return PhotosServiceProvider