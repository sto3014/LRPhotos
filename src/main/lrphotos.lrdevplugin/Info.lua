return {
  LrSdkVersion = 3.0,
  LrSdkMinimumVersion = 3.0,

  LrPluginName = 'Photos',
  LrToolkitIdentifier = 'at.homebrew.lrphotos',
  VERSION = { major = 2, minor = 0, revision = 0, build = 3, },
  LrInitPlugin = "InitPlugin.lua",
  -- Add the Metadata Definition File
  LrMetadataProvider = 'PhotosMetadataDefinition.lua',
  -- Add the Metadata Tagset File
  LrMetadataTagsetFactory = {
    'PhotosMetadataTagset.lua',
  },
  LrExportServiceProvider = {
    title = "Photos",  -- this string appears as the export destination
    file = "PhotosServiceProvider.lua",
  },
}
