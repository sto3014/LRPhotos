--[[---------------------------------------------------------------------------
-- Created by Simon Schoeters
-- Created in 2011
-----------------------------------------------------------------------------]]--

local LrPathUtils = import 'LrPathUtils'
local LrTasks = import 'LrTasks'
local logger = require("Logger")

iPhotoImportTask = {}

function iPhotoImportTask.processRenderedPhotos( _, exportContext )

  local exportSession = exportContext.exportSession
  local exportParams = exportContext.propertyTable

  -- Export message settings
  local nPhotos = exportSession:countRenditions()
  local progressScope = exportContext:configureProgress{
    title = nPhotos > 1
        and LOC( '$$$/iPhotoExportService/ProgressMany=Importing ^1 photos in iPhoto', nPhotos )
        or LOC '$$$/iPhotoExportService/ProgressOne=Importing one photo in iPhoto',
  }

  -- Export the photos
  local files = {}

  for i, rendition in exportContext:renditions{ stopIfCanceled = true } do

    local photo = rendition.photo
    local success, pathOrMessage = rendition:waitForRender()

    if progressScope:isCanceled() then break end -- Check for cancellation again after photo has been rendered
    logger.trace(pathOrMessage)
    if success then
      table.insert( files, pathOrMessage )
    end

  end

  local path = LrPathUtils.parent( files[1] )

  -- Write Lightroom input to a session.txt file for AppleScript later on
  local f = assert(io.open(path .. "/session.txt", "w+"))
  f:write("export_done=false\n")
  if exportParams.createAlbum == true then
    f:write("album_name=" .. exportParams.album .. "\n")
  end
  f:close()

  -- Import photos in iPhoto and wait till photos are imported by reading the session file
  local importer_command = "osascript \"" .. LrPathUtils.child(_PLUGIN.path, "PhotosImport/PhotosImport.app") .. "\" " .. LrPathUtils.parent(files[1])
  LrTasks.execute(importer_command)

  local done = false
  while done ~= true do
    LrTasks.sleep(2)

    local f = assert(io.open(path .. "/session.txt", "r"))
    for line in f:lines() do
      if string.find(line, 'export_done=true') then
        done = true
        break
      end
    end
    f:close()
  end

end
