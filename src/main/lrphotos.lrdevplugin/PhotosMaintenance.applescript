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
-- writeError
----------------------------------------------------------------------
on writeError(comDir, errorMessage)
	local photosFile
	set photosFile to comDir & "/fromPhotos/photos.txt"
	set errorMessage to "Error: " & errorMessage
	lockFile(photosFile)
	
	set fileRef to open for access photosFile as «class utf8» with write permission
	set eof fileRef to 0
	tell script "hbMacRomanUtilities"
		set errorMessageUTF8 to transform macroman text errorMessage to UTF8
	end tell
	write errorMessageUTF8 to photosFile
	close access fileRef
	
	unlockFile(photosFile)
	
end writeError
----------------------------------------------------------------------
-- writeExtraInfo
----------------------------------------------------------------------
on writeExtraInfo(comDir, extraPhotos)
	local photosFile
	set photosFile to comDir & "/fromPhotos/photos.txt"
	
	lockFile(photosFile)
	
	set fileRef to open for access photosFile as «class utf8» with write permission
	set eof fileRef to 0
	
	write (count of extraPhotos) to photosFile
	close access fileRef
	
	unlockFile(photosFile)
	
end writeExtraInfo
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
	
	
	set AppleScript's text item delimiters to ":"
	
	local aLine
	local aReference
	repeat with aLine in allLines
		set aReference to text items of aLine
		set countTokens to count of aReference
		if countTokens is equal to 1 or countTokens is equal to 3 then
			set end of photosReferences to aReference
		else
			if countTokens is equal to 2 or countTokens is greater than 3 then
				error "input file " & inputPath & " must have 3 fields per line."
			end if
		end if
	end repeat
	
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
on processExtraPhotos(comDir, catalogNames, albumName)
	set photosReferences to readPhotosReferences(comDir)
	writeExtraInfo(comDir, {})
end processExtraPhotos
----------------------------------------------------------------------
-- main
----------------------------------------------------------------------
on run argv
	if (argv = me) then
		--set argv to {"photos-references", "/Users/dieterstockhausen/Library/Caches/at.homebrew.lrphotos/maintenance"}
		set argv to {"extra-photos", "/Users/dieterstockhausen/Library/Caches/at.homebrew.lrphotos/maintenance", "DSTO-v13.lrcat:develope-v13.lrcat", "/Lightroom/Überzählig in Fhotos"}
	end if
	if (count of argv) < 2 then
		display dialog usage
		return
	end if
	set cmdDir to item 2 of argv
	try
		if item 1 of argv is equal to "photos-references" then
			processPhotosReferences(cmdDir)
		else
			if item 1 of argv is equal to "extra-photos" then
				if (count of argv) is not equal to 4 then
					display dialog usage
					return
				else
					processExtraPhotos(cmdDir, item 3 of argv, item 4 of argv)
				end if
			else
				display dialog usage
				return
			end if
		end if
	on error e
		writeError(cmdDir, e)
		return
	end try
	
end run
