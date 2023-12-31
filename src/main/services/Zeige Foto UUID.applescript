use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

on run
	tell application "Photos"
		local currentSelection
		set currentSelection to the selection
		if currentSelection is {} then error number -28
		set msg to ""
		local thisPhoto
		repeat with thisPhoto in currentSelection
			-- set PhotoCaption to description of thisPhoto
			-- set PhotoTitle to name of thisPhoto
			try
				set PhotoFileName to filename of thisPhoto
				set PhotoID to id of thisPhoto
				set msg to msg & PhotoFileName & " : " & linefeed & "  " & PhotoID & linefeed
			on error e
				set AppleScript's text item delimiters to "media item id \""
				set _sub to text item 2 of e
				set AppleScript's text item delimiters to "\" of album id"
				set msg to msg & "unknown file name : " & linefeed & "  " & text item 1 of _sub & linefeed
			end try
			
		end repeat
		display dialog msg
	end tell
end run
