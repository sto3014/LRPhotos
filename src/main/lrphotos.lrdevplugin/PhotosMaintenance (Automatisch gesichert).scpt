use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

property usage : "usage: PhotosMaintennce <photos-references|lightroom-references> <comDir> [catalog-name1:catalog-name2:...]"

on writeLightroomReferences(comDir, lightroomReferences)
	set outptPath to comDir & "/fromPhotos/photos.txt"
	set fileRef to open for access outptPath as «class utf8» with write permission
	set eof fileRef to 0
	-- set aLine to 
	write utf8Content to outptPath
	close access fileRef
end writeLightroomReferences
----------------------------------------------------------------------
-- readPhotosReferences(comDir)
-- return photosReferences
-- format of photosReferences:
--   {
--		{"photos id 1", "catalog-name 1", "lightroon id 1"},
--		{"photos id 2", "catalog-name 2", "lightroon id 2"},
--		...
--	  }
----------------------------------------------------------------------
on readPhotosReferences(comDir)
	set photosReferences to {}
	set inputPath to comDir & "/fromLightroom/photos.txt"
	
	set inputFile to POSIX file (inputPath)
	open for access fromLightroomFile
	set fileContents to (read inputFile as «class utf8»)
	close access inputFile
	
	set allLines to every paragraph of fileContents
	
	set currentDelimiter to AppleScript's text item delimiters
	set AppleScript's text item delimiters to ":"
	
	repeat with aLine in allLines
		if (count of aLine) is not equal to 3 then
			set AppleScript's text item delimiters to currentDelimiter
			error "input file " & inputPath & " must have 3 fields per line."
		end if
		set aReference to {}
		set end of aReference to first item of aLine
		set end of aReference to second item of aLine
		set end of aReference to third item of aLine
		set end of photosReferences to aReference
	end repeat
	
	set AppleScript's text item delimiters to currentDelimiter
	
	return photosReferences
end readPhotosReferences
----------------------------------------------------------------------
-- processPhotosReferences
----------------------------------------------------------------------
on processPhotosReferences(comDir)
	set photosReferences to readPhotosReferences(comDir)
end processPhotosReferences

----------------------------------------------------------------------
-- processLightroomReferences
----------------------------------------------------------------------
on processLightroomReferences(comDir, catalogNames)
	
end processLightroomReferences
----------------------------------------------------------------------
-- main
----------------------------------------------------------------------
on run argv
	if (argv = me) then
		set argv to {"photos-references", "/Users/dieterstockhausen/Library/Caches/at.homebrew.lrphotos/maintenance"}
		-- set argv to {"lightroom-references", "/Users/dieterstockhausen/Library/Caches/at.homebrew.lrphotos/maintenance", "DSTO-v13.lrcat:develope-v13.lrcat"}
	end if
	
	if (count of argv) < 2 then
		display dialog usage
		return
	end if
	
	if item 1 of argv is equal to "photos-references" then
		processPhotosReferences(item 2 of argv)
	else
		if item 1 of argv is equal to "lightroom-references" then
			if (count of argv) is not equal to 3 then
				display dialog usage
				return
			else
				processLightroomReferences(item 2 of argv, item 3 of argv)
			end if
		else
			display dialog usage
			return
		end if
	end if
	
end run