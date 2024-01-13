use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

on run argv
	if argv = me then
		set albumPath to "/2024/2024 Worms *"
	else
		set albumPath to first item of argv
	end if
	tell script "hbPhotosUtilities" to photosAlbumDisplay(albumPath, true)
end run