return {
  LrSdkVersion = 3.0,
  LrSdkMinimumVersion = 3.0,

  LrPluginName = 'Photos',
  LrToolkitIdentifier = 'at.homebrew.lrphotos',
  VERSION = { major = 1, minor = 0, revision = 0, build = 0, },

  -- Add the Metadata Definition File
  LrMetadataProvider = 'PhotosMetadataDefinition.lua',

  LrInitPlugin = "InitPlugin.lua",

  LrExportServiceProvider = {
    title = "Photos",  -- this string appears as the export destination
    file = "PhotosServiceProvider.lua",
  },

}
