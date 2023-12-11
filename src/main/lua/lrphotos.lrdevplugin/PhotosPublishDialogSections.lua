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
        --       f:spacer {
        --         width = share 'labelWidth'
        --       },

        f:checkbox {
          title = LOC '$$$/PhotosExportService/UseAlbum=Use Album:',
          value = bind 'useAlbum',
        },

        f:group_box { -- the buttons in this container make a set
          fill_horizontal = 1,
          spacing = f:control_spacing(),
          f:row {

            f:radio_button {
              title = LOC "$$$/Photos/UseOneAlbumForService=Use one album for all collections",
              value = bind 'albumBy', -- all of the buttons bound to the same key
              checked_value = 'service',
              enabled = bind 'useAlbum',
            },
            f:edit_field {
              value = bind 'albumNameForService',
              enabled = bind 'useAlbum',
              truncation = 'middle',
              immediate = true,
              fill_horizontal = 1,
            },
          },
          f:row {
            f:radio_button {
              title = LOC "$$$/Photos/UseCollectionNameAsAlbum=Use collection name as album",
              value = bind 'albumBy',
              checked_value = 'collection',
              enabled = bind 'useAlbum',
            },
          },
        },
      },
      f:row {
        --       f:spacer
        --        width = share 'labelWidth'
        --       },

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
      f:row {
        --       f:spacer
        --        width = share 'labelWidth'
        --       },

        f:static_text({
          title = LOC("$$$/Photos/RootFolder=Root Folder for Albums:"),
          width_in_chars = 19,
        }),

        f:edit_field {
          -- title = LOC "$$$/Photos/RootFolder=Root Folder for Albums:",
          value = bind 'rootFolder',
          truncation = 'middle',
          immediate = true,
          fill_horizontal = 1,
        },
      },
      f:row {
        --       f:spacer
        --        width = share 'labelWidth'
        --       },

        --[[
        f:static_text({
          title = LOC("$$$/Photos/KeepOldPhotos=Keep out of date photos in albums:"),
          width_in_chars = 25,
        }),
        ]]--

        f:checkbox {
          title = LOC "$$$/Photos/KeepOldPhotos=Keep out of date photos in albums.",
          value = bind 'keepOldPhotos',
        },
      },
    },
  }

  return result

end
