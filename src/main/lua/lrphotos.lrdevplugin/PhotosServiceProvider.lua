--[[---------------------------------------------------------------------------
-- Initial created by Simon Schoeters in 2011
--
-- 2021-05-29 Dieter Stockhausen. Add publishing functionality
-----------------------------------------------------------------------------]]--
local LrPrefs = import("LrPrefs")
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
  deletePhotosFromPublishedCollection= PhotosPublishTask.deletePhotosFromPublishedCollection,
  supportsIncrementalPublish = 'only',
  small_icon = 'photos_small.png',
  publish_fallbackNameBinding = 'fullname',
  titleForGoToPublishedCollection  = 'disable'
}
local prefs = LrPrefs.prefsForPlugin()
if (prefs.osSupported) then
  return PhotosServiceProvider
else
  return {}
end