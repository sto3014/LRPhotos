local LrView = import("LrView")
local LrPrefs = import("LrPrefs")
local logger = require("Logger")
-------------------------------------------------------------------------------

local InfoProvider = {}

-------------------------------------------------------------------------------

function InfoProvider.sectionsForTopOfDialog(f, _)
    logger:trace("sectionsForTopOfDialog")
    local prefs = LrPrefs.prefsForPlugin()
    return {
        {
            title = LOC("$$$/Photos/PluginSettings=Plug-in Settings"),
            bind_to_object = prefs,

            f:row {
                f:static_text {
                    title = LOC("$$$/Photos/CatalogName=Lightroom Catalog"),
                    width_in_chars = 19,
                },
                f:checkbox {
                    title = LOC("$$$/Photos/CatalogName/TruncateVersion=Truncate Version"),
                    value = LrView.bind("truncateCatalogVersion"),
                    --checked_value = true, -- this is the initial state
                    --unchecked_value = false,
                },
            },

        },
    }
end

-------------------------------------------------------------------------------

function InfoProvider.sectionsForBottomOfDialog(f, property_table)
   return {}
end

-------------------------------------------------------------------------------

return InfoProvider