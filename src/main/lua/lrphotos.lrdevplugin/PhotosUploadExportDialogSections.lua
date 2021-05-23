--[[---------------------------------------------------------------------------
-- Created by Simon Schoeters
-- Created in 2011
-----------------------------------------------------------------------------]]--

local LrView = import 'LrView'

iPhotoUploadExportDialogSections = {}

function iPhotoUploadExportDialogSections.sectionsForBottomOfDialog( f, _ )

  local bind = LrView.bind
  local share = LrView.share

  local result = {

    {
      title = LOC '$$$/iPhotoExportService/Title=iPhoto',

      f:row {
        f:spacer {
          width = share 'labelWidth'
        },

        f:checkbox {
          title = LOC '$$$/iPhotoExportService/CreateAlbum=Create Album:',
          value = bind 'createAlbum',
        },

        f:edit_field {
          value = bind 'album',
          enabled = bind 'createAlbum',
          truncation = 'middle',
          immediate = true,
          fill_horizontal = 1,
        },
      },
    },
  }

  return result

end
