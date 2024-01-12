use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

on run argv
	if argv = me then
		set mediaItemUUID to "4380429F-26A7-48D5-8521-BD4B1B2F7664/L0/001"
	else
		set mediaItemUUID to first item of argv
	end if
	tell script "PhotosUtilities" to photosMediaItemDisplay(mediaItemUUID)
end run