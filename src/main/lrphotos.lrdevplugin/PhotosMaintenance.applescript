use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

property usage : "usage: PhotosMaintennce <photos-references|lightroom-references> <comDir> [catalog-name1:catalog-name2:...]"
----------------------------------------------------------------------
-- suffix
----------------------------------------------------------------------
on suffix(theFileName)
	set theReversedFileName to (reverse of (characters of theFileName)) as string
	set theOffset to offset of "." in theReversedFileName
	set theSuffix to (reverse of (characters 1 thru (theOffset - 1) of theReversedFileName)) as string
	return theSuffix
end suffix
----------------------------------------------------------------------
-- prefix
----------------------------------------------------------------------
on prefix(theFileName)
	set theReversedFileName to (reverse of (characters of theFileName)) as string
	set theOffset to offset of "." in theReversedFileName
	set thePrefix to (reverse of (characters (theOffset + 1) thru -1 of theReversedFileName)) as string
	return thePrefix
end prefix

----------------------------------------------------------------------
-- lockFile
----------------------------------------------------------------------
on lockFile(fileName)
	set lockFileName to fileName & ".lck"
	do shell script "/usr/bin/touch " & quoted form of lockFileName
end lockFile

----------------------------------------------------------------------
-- unlockFile
----------------------------------------------------------------------
on unlockFile(fileName)
	local lockFile
	set lockFile to POSIX path of fileName & ".lck"
	do shell script "/bin/rm " & quoted form of lockFile
end unlockFile

----------------------------------------------------------------------
-- writeLightroomReferences
----------------------------------------------------------------------
on writeLightroomReferences(comDir, lightroomReferences)
	local photosFile
	set photosFile to comDir & "/fromPhotos/photos.txt"
	
	lockFile(photosFile)
	
	set fileRef to open for access photosFile as «class utf8» with write permission
	set eof fileRef to 0
	repeat with aReference in lightroomReferences
		set aLine to first item of aReference & ":" & second item of aReference & linefeed
		write aLine to photosFile
	end repeat
	close access fileRef
	
	unlockFile(photosFile)
	
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
	local photosReferences
	set photosReferences to {}
	set inputPath to comDir & "/fromLightroom/photos.txt"
	
	set inputFile to POSIX file (inputPath)
	open for access inputFile
	set fileContents to (read inputFile as «class utf8»)
	close access inputFile
	
	local allLines
	set allLines to every paragraph of fileContents
	
	set currentDelimiter to AppleScript's text item delimiters
	set AppleScript's text item delimiters to ":"
	
	local aLine
	local aReference
	repeat with aLine in allLines
		if (count of aLine) is not equal to 0 then
			if text item 3 of aLine is missing value then
				set AppleScript's text item delimiters to currentDelimiter
				error "input file " & inputPath & " must have 3 fields per line."
			end if
			set aReference to {}
			set end of aReference to text item 1 of aLine
			set end of aReference to text item 2 of aLine
			set end of aReference to text item 3 of aLine
			set end of photosReferences to aReference
		end if
	end repeat
	
	set AppleScript's text item delimiters to currentDelimiter
	
	return photosReferences
end readPhotosReferences
----------------------------------------------------------------------
-- processPhotosReferences
----------------------------------------------------------------------
on processPhotosReferences(comDir)
	set photosReferences to readPhotosReferences(comDir)
	local lightroomReferences
	local aReference
	set lightroomReferences to {}
	tell application "Photos"
		repeat with aReference in photosReferences
			set aLightroomReference to {}
			set end of aLightroomReference to item 3 of aReference
			set thePhotos to (every media item whose id is equal to first item of aReference)
			if (count of thePhotos) is greater than 0 then
				set photoFileName to get filename of first item of thePhotos
				set end of aLightroomReference to "found"
			else
				set end of aLightroomReference to "missing"
			end if
			set end of lightroomReferences to aLightroomReference
		end repeat
	end tell
	
	writeLightroomReferences(comDir, lightroomReferences)
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
