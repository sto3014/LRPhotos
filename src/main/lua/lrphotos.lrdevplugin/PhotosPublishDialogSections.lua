--[[---------------------------------------------------------------------------
-- Initial created by Simon Schoeters in 2011
--
-- 2021-05-29 Dieter Stockhausen. Add regex field
-----------------------------------------------------------------------------]]--
local LrView = import 'LrView'

PhotosPublishDialogSections = {}

function PhotosPublishDialogSections.sectionsForBottomOfDialog( f, _ )

  local bind = LrView.bind
  local share = LrView.share

  local result = {

    {
      title = LOC '$$$/PhotosExportService/Title=Photos',
      f:row {
        f:spacer {
          width = share 'labelWidth'
        },

        f:checkbox {
          title = LOC '$$$/PhotoExportService/CreateAlbum=Use Album:',
          value = bind 'useAlbum',
        },

        f:edit_field {
          value = bind 'albumName',
          enabled = bind 'useAlbum',
          truncation = 'middle',
          immediate = true,
          fill_horizontal = 1,
        },
      },
      f:row {
        f:spacer {
          width = share 'labelWidth'
        },

        f:checkbox {
          title = LOC "$$$/Photos/IgnoreAlbums=Ignore Albums:",
          value = bind 'ignoreAlbums',
        },


        f:edit_field {
          title = LOC "$$$/Photos/IgnorePattern=Regex Pattern:",
          value = bind 'ignoreRegex',
          enabled = bind 'ignoreAlbums',
          truncation = 'middle',
          immediate = true,
          fill_horizontal = 1,
        },
      },
    },
  }

  return result

end
