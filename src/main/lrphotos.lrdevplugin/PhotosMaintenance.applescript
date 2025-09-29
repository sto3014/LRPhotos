use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions
use script "hbLogger"

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
	-- local countOf
	-- set countOf to (count of extraPhotos) as string
	
	write ((count of extraPhotos) as string) to photosFile
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
-- writeCountSourcePhotos
----------------------------------------------------------------------
on writeCountSourcePhotos(comDir, countPhotos)
	local photosFile
	set photosFile to comDir & "/fromPhotos/photos.txt"
	
	lockFile(photosFile)
	
	set fileRef to open for access photosFile as «class utf8» with write permission
	set eof fileRef to 0
	set aLine to "count=" & countPhotos
	write aLine to photosFile
	close access fileRef
	
	unlockFile(photosFile)
	
end writeCountSourcePhotos
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
		if countTokens is equal to 1 then
			set end of photosReferences to first item of aReference
		else
			if countTokens is equal to 3 then
				set end of photosReferences to aReference
			else
				if countTokens is equal to 2 or countTokens is greater than 3 then
					error "input file " & inputPath & " must have 3 fields per line."
				end if
			end if
		end if
	end repeat
	
	return photosReferences
end readPhotosReferences
----------------------------------------------------------------------
-- processPhotosReferences
----------------------------------------------------------------------
on processPhotosReferences(comDir)
	log message "processPhotosReferences() start"
	log message "read list of Lightroom photos from " & comDir
	set photosReferences to readPhotosReferences(comDir)
	log message "read " & (count of photosReferences) & " photos"
	local lightroomReferences
	local aReference
	set lightroomReferences to {}
	tell application "Photos"
		log message "search for photos that are missing"
		set found to 0
		set missing to 0
		repeat with aReference in photosReferences
			set aLightroomReference to {}
			set end of aLightroomReference to item 3 of aReference
			try
				set thePhoto to media item id (contents of first item of aReference)
				set end of aLightroomReference to "found"
				set found to found + 1
			on error e
				set end of aLightroomReference to "missing"
				set missing to missing + 1
			end try
			set end of lightroomReferences to aLightroomReference
		end repeat
	end tell
	log message "found=" & found
	log message "missing=" & missing
	
	writeLightroomReferences(comDir, lightroomReferences)
	log message "processPhotosReferences() end"
end processPhotosReferences
----------------------------------------------------------------------
-- readSourcePhotos(comDir)
----------------------------------------------------------------------
on readSourcePhotos(comDir)
	local sourcePhotos
	set inputPath to comDir & "/fromLightroom/photos.txt"
	
	set inputFile to POSIX file (inputPath)
	open for access inputFile
	set fileContents to (read inputFile as «class utf8»)
	close access inputFile
	
	local sourcePhotos
	set sourcePhotos to {}
	local allLines
	set allLines to every paragraph of fileContents
	repeat with aLine in allLines
		if length of aLine > 0 then
			set sourcePhotos to sourcePhotos & aLine
		end if
	end repeat
	
	return sourcePhotos
end readSourcePhotos

----------------------------------------------------------------------
-- processSourcePhotos
----------------------------------------------------------------------
on processSourcePhotos(comDir, albumName)
	log message "processSourcePhotos() start"
	log message "read list of Lightroom source photos leafNames from " & comDir
	set sourcePhotos to readSourcePhotos(comDir)
	log message "read " & (count of sourcePhotos) & " photos"
	
	log message "search for source photos"
	tell script "hbPhotosUtilities" to set targetAlbum to album by path albumName with create if not exists
	local mediaItems
	set mediaItems to {}
	set batchSize to 50 -- tune to taste
	local upperLevel
	repeat with i from 1 to count sourcePhotos by batchSize
		set upperLevel to i + batchSize - 1
		if (upperLevel > (count of sourcePhotos)) then
			set upperLevel to count of sourcePhotos
		end if
		set batch to items i thru upperLevel of sourcePhotos
		local batchClause
		set batchClause to ""
		local baseName
		repeat with baseName in batch
			log message "baseName=" & baseName
			set batchClause to batchClause & "filename contains \"" & (baseName as string) & "\" or "
		end repeat
		set batchClause to text 1 thru -5 of batchClause -- trim last " or "
		local localScript
		set localScript to "tell application \"Photos\" to (every media item whose (" & batchClause & "))"
		set found to run script localScript
		set mediaItems to mediaItems & found
	end repeat
	local found
	set found to count of mediaItems
	tell application "Photos"
		if found is greater than 0 then
			-- activate
			add mediaItems to targetAlbum
		end if
		-- spotlight targetAlbum
	end tell
	log message "found=" & found
	
	writeCountSourcePhotos(comDir, found)
	log message "processSourcePhotos() end"
end processSourcePhotos

----------------------------------------------------------------------
-- isNoLongerPublished
----------------------------------------------------------------------
on isActiveMediaItem(mediaItem)
	tell application "Photos"
		set theKeywords to the keywords of mediaItem
		if theKeywords is not missing value then
			if theKeywords contains "lr:no-longer-published" or theKeywords contains "lr:out-of-date" then
				return false
			else
				return true
			end if
		else
			return true
		end if
	end tell
end isActiveMediaItem
----------------------------------------------------------------------
-- processLightroomReferences
----------------------------------------------------------------------
on processExtraPhotos(comDir, catalogNames, albumName)
	log message "processExtraPhotos() start"
	
	log message "catalogNames=" & catalogNames
	log message "albumName=" & albumName
	log message "read list of Lightroom photos from " & comDir
	
	set photosReferences to readPhotosReferences(comDir)
	log message "read " & (count of photosReferences) & " photos"
	
	set AppleScript's text item delimiters to ":"
	set catalogList to text items of catalogNames
	set extraMediaItems to {}
	
	tell application "Photos"
		repeat with aCatalog in catalogList
			-- set aCatalog to "develope"
			log message "get all photos of catalog " & aCatalog
			set theMediaItems to search for aCatalog
			log message "count=" & (count of theMediaItems)
			log message "filter for extra photos"
			repeat with aMediaItem in theMediaItems
				set photosId to id of aMediaItem
				if photosReferences does not contain photosId then
					tell me
						if isActiveMediaItem(aMediaItem) then
							set end of extraMediaItems to aMediaItem
						end if
					end tell
				end if
			end repeat
			log message "extra=" & (count of extraMediaItems)
		end repeat
	end tell
	
	if (count of extraMediaItems) is greater than 0 then
		tell script "hbPhotosUtilities" to set targetAlbum to album by path albumName with create if not exists
		tell application "Photos"
			activate
			add extraMediaItems to targetAlbum
			spotlight targetAlbum
		end tell
	end if
	writeExtraInfo(comDir, extraMediaItems)
	log message "processExtraPhotos() end"
	
end processExtraPhotos
----------------------------------------------------------------------
-- main
----------------------------------------------------------------------
on run argv
	local logFile
	set logFile to ((path to home folder) as Unicode text) & "Library:Logs:Adobe:Lightroom:LrClassicLogs:PhotosServiceProvider.log"
	enable logging to file logFile
	log message "PhotosMaintenance.app start"
	if (argv = me) then
		-- set argv to {"photos-references", "/Users/dieterstockhausen/Library/Caches/at.homebrew.lrphotos/maintenance"}
		-- set argv to {"extra-photos", "/Users/dieterstockhausen/Library/Caches/at.homebrew.lrphotos/maintenance", "Develop-v13.lrcat", "/Lightroom/Überzählig in Fhotos"}
		set argv to {"source-photos", "/Users/dieterstockhausen/Library/Caches/at.homebrew.lrphotos/maintenance", "/LR Photos/Quellfotos"}
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
				if item 1 of argv is equal to "source-photos" then
					processSourcePhotos(cmdDir, item 3 of argv)
				else
					display dialog usage
				end if
				return
			end if
		end if
	on error e
		log message e as severe
		writeError(cmdDir, e)
		return
	end try
	log message "PhotosMaintenance.app end"
	
end run
