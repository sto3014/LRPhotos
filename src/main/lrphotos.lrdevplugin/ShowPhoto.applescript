use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions
use script "hbPhotosUtilities"

on run argv
	if argv = me then
		set mediaItemUUID to "212A2955-EF79-4EE0-B088-C94B62B1F4F9/L0/001"
	else
		set mediaItemUUID to first item of argv
	end if
	tell application "Photos"
		spotlight media item by id mediaItemUUID
		activate
	end tell
end run