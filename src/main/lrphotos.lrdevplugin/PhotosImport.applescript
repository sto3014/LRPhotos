-------------------------------------------------------------------------------
-- Initial created by Simon Schoeters in 2011
--
-- 29.05.2021. Dieter Stockhausen. Add publishing functionality
--
-------------------------------------------------------------------------------
use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions
use framework "Foundation"
use script "hbLogger"

-- property pPhotosLib : "hbPhotosUtilities"
-- property pMacRomanLib : "hbMacRomanUtilities"
-- property pStringLib : "hbStringUtilities"

-- classes, constants, and enums used
property NSRegularExpressionSearch : a reference to 1024
property inputEncoding : "UTF-8"

-------------------------------------------------------------------------------
-- Extract the album name from the session file
-------------------------------------------------------------------------------
on getAlbumName(sessionContents)
	set albumName to ""
	set allLines to every paragraph of sessionContents
	repeat with aLine in allLines
		set equalSignOffset to (offset of "=" in aLine)
		if equalSignOffset > 0 then
			set var to text 1 thru (equalSignOffset - 1) of aLine
			if var = "albumName" then
				set len to the length of aLine
				if len is greater than equalSignOffset then
					set albumName to text ((offset of "=" in aLine) + 1) thru -1 of aLine
				end if
			end if
		end if
	end repeat
	return albumName
end getAlbumName
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
on getIgnoreRegex(sessionContents)
	set ignoreByRegex to ""
	set allLines to every paragraph of sessionContents
	repeat with aLine in allLines
		set equalSignOffset to (offset of "=" in aLine)
		if equalSignOffset > 0 then
			set var to text 1 thru (equalSignOffset - 1) of aLine
			if var = "ignoreByRegex" then
				set len to the length of aLine
				if len is greater than equalSignOffset then
					set ignoreByRegex to text ((offset of "=" in aLine) + 1) thru -1 of aLine
				end if
			end if
		end if
	end repeat
	return ignoreByRegex
end getIgnoreRegex
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
on getMode(sessionContents)
	set mode to ""
	set allLines to every paragraph of sessionContents
	repeat with aLine in allLines
		set equalSignOffset to (offset of "=" in aLine)
		if equalSignOffset > 0 then
			set var to text 1 thru (equalSignOffset - 1) of aLine
			if var = "mode" then
				set len to the length of aLine
				if len is greater than equalSignOffset then
					set mode to text ((offset of "=" in aLine) + 1) thru -1 of aLine
				end if
			end if
		end if
	end repeat
	return mode
end getMode
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
on getSession(sessionContents)
	local session
	set session to {mode:"", albumName:"", ignoreByRegex:"", hasErrors:false, errorMsg:"", exportDone:false, keepOldPhotos:true} as record
	local allLines
	set allLines to every paragraph of sessionContents
	repeat with aLine in allLines
		set equalSignOffset to (offset of "=" in aLine)
		if equalSignOffset > 0 then
			-- get the value
			set len to the length of aLine
			if len is greater than equalSignOffset then
				set value to text ((offset of "=" in aLine) + 1) thru -1 of aLine
			else
				set value to ""
			end if
			-- get the key
			set aKey to text 1 thru (equalSignOffset - 1) of aLine
			if aKey is equal to "mode" then
				set mode of session to value
			else
				if aKey is equal to "albumName" then
					set albumName of session to value
				else
					if aKey is equal to "ignoreByRegex" then
						set ignoreByRegex of session to value
					else
						if aKey is equal to "hasError" then
							set hasErrors of session to value is equal to "true"
						else
							if aKey is equal to "errorMsg" then
								set errorMsg of session to value
							else
								if aKey is equal to "exportDone" then
									set exportDone of session to value is equal to "true"
								else
									if aKey is equal to "keepOldPhotos" then
										set keepOldPhotos of session to value is equal to "true"
									end if
								end if
							end if
						end if
					end if
				end if
			end if
		end if
	end repeat
	return session
end getSession
-------------------------------------------------------------------------------
-- Extract the photo descriptors from the photos file
-- Format is:
--   image posix file path : LR photo uuid : name of LR catalog file : Photos photo ID
-------------------------------------------------------------------------------
on getPhotoDescriptors(photosContents)
	set photos to {}
	set allLines to every paragraph of photosContents
	repeat with aLine in allLines
		tell script "hbStringUtilities"
			set aLine to (remove white space around aLine)
		end tell
		log aLine
		if aLine is not equal to "" then
			copy aLine to the end of photos
		end if
	end repeat
	return photos
end getPhotoDescriptors
-------------------------------------------------------------------------------
-- Import exported photos in a new iPhoto album if needed
-------------------------------------------------------------------------------
on import(photoDescriptors, session)
	log message "import() start"
	set currentDelimiter to AppleScript's text item delimiters
	set AppleScript's text item delimiters to ":"
	
	tell application id "com.apple.photos"
		tell script "hbPhotosUtilities"
			set targetAlbum to album by path albumName of session with create if not exists
		end tell
		log message "targetAlbum=" & albumName of session
		set importedPhotos to {}
		log message "Start import of " & (count of photoDescriptors) & " photos"
		
		repeat with aPhotoDescriptor in photoDescriptors
			-- the posix file path
			local thePhotoFile
			set thePhotoFile to text item 1 of aPhotoDescriptor
			-- the LR id. Not used here, but necessary for the way back to LR
			local lrId
			set lrId to text item 2 of aPhotoDescriptor
			-- used as keyword
			local lrCat
			set lrCat to text item 3 of aPhotoDescriptor
			-- if exists a Photos id, it is an update.
			set isUpdate to false
			try
				local photosId
				set photosId to text item 4 of aPhotoDescriptor
				if photosId is not equal to "" then
					set isUpdate to true
				end if
			end try
			log message "Start import of " & thePhotoFile
			log message "update=" & isUpdate
			set previousAlbums to {}
			try
				if isUpdate is true then
					set targetPhotos to (every media item whose id is equal to photosId)
					if (count of targetPhotos) is greater than 0 then
						log message "predecessor found"
						tell script "hbPhotosUtilities"
							set previousAlbums to every album containing media item id photosId
						end tell
						set theTargetPhoto to item 1 of targetPhotos
						log message "set predecessor out-of-date"
						-- set the photo out-of-date
						set newKeywords to {"lr:out-of-date"}
						set theseKeywords to the keywords of theTargetPhoto
						if theseKeywords is missing value then
							set keywords of theTargetPhoto to newKeywords
						else
							set keywords of theTargetPhoto to (theseKeywords & newKeywords)
						end if
					else
						-- happens if photos were deleted
						log message "predecessor not found" as alarm
						set isUpdate to false
					end if
				end if
			on error e
				error "Can't get all albums for photoID " & photosId & ". Error was " & e
			end try
			--
			-- now we import the LR photo
			try
				log "The file: " & thePhotoFile
				local newPhotos
				log message "import " & thePhotoFile
				tell me to set aliasPhotoFile to {POSIX file thePhotoFile as alias}
				if targetAlbum is missing value then
					-- on update, the standard album must me ignored.
					-- later it will  added to the albums of the previous photo version
					set newPhotos to import aliasPhotoFile with skip check duplicates
				else
					-- if new, it goes into the standard album
					set newPhotos to import aliasPhotoFile into targetAlbum with skip check duplicates
				end if
			on error e
				error "Import of photos failed. Error was: " & e
			end try
			--
			-- put it into the previous albums			
			if isUpdate is true then
				log message "update all albums"
				repeat with aAlbum in previousAlbums
					set aAlbumName to name of aAlbum
					log message "aAlbumName=" & aAlbumName
					tell script "hbStringUtilities"
						set isValid to not (regex expression ignoreByRegex of session matches aAlbumName)
					end tell
					
					if isValid is true then
						repeat with newPhoto2 in newPhotos
							try
								log message "set album keyword " & "album:" & aAlbumName & " on new photo"
								set newKeywords2 to {"album:" & aAlbumName}
								set theseKeywords2 to the keywords of newPhoto2
								if theseKeywords2 is missing value then
									set keywords of newPhoto2 to newKeywords2
								else
									set keywords of newPhoto2 to (theseKeywords2 & newKeywords2)
								end if
							on error e
								error "Can't add new album tag album:" & aAlbumName & " on existing photos. Error was: " & e
							end try
							try
								log message "add new photo to album"
								add newPhotos to aAlbum
							on error e
								error "Can't add imported photos to album '" & aAlbumName & "'. Maybe it's a smart album and you should exlude it. Error was: " & e
							end try
							
						end repeat
					else
						log message "album is excluded because of regex " & ignoreByRegex of session
					end if
				end repeat
			end if
			--
			-- Update metadata
			try
				log message "update target album info on new photo"
				if (count of newPhotos) is greater than 0 then
					-- set the name of the LR catalog file
					set targetAlbumName to name of targetAlbum
					log message "set new keywords " & "lr:" & lrCat & ".lrcat"
					set newKeywords to {"lr:" & lrCat & ".lrcat"}
					set theNewPhoto to item 1 of newPhotos
					set theseKeywords to the keywords of theNewPhoto
					if theseKeywords is missing value then
						set keywords of theNewPhoto to newKeywords
					else
						set keywords of theNewPhoto to (theseKeywords & newKeywords)
					end if
					-- store the id for LR
					set photosId to get the id of theNewPhoto
					set newEntry to thePhotoFile & ":" & lrId & ":" & lrCat & ":" & photosId
					log newEntry
					copy newEntry to the end of importedPhotos
				end if
			on error e
				error "Can't keywords on imported photo. Error was: " & e
			end try
			local aAlbumName
			repeat with aAlbum in previousAlbums
				set aAlbumName to name of aAlbum
				tell script "hbStringUtilities"
					set isValid to not (regex expression ignoreByRegex of session matches aAlbumName)
				end tell
				
				if isValid is true then
					if not keepOldPhotos of session then
						log message "cleanup album " & aAlbumName
						tell me to cleanupAlbum(aAlbum)
					end if
				end if
			end repeat
			delay 2
		end repeat
	end tell
	set AppleScript's text item delimiters to currentDelimiter
	log message "import() end"
	return importedPhotos
end import
-------------------------------------------------------------------------------
-- Remove item from list
-------------------------------------------------------------------------------
on removeItemFromList(theList, theItem)
	repeat with theIndex from 1 to the count of theList
		if item theIndex of theList is equal to theItem then
			if theIndex = 1 then
				if (count theList) is equal to 1 then
					return {}
				else
					return items 2 thru -1 of theList
				end if
			else if theIndex is (count theList) then
				return items 1 thru -2 of theList
			else
				tell theList to return items 1 thru (theIndex - 1) & items (theIndex + 1) thru -1
			end if
		end if
	end repeat
	return theList
end removeItemFromList
-------------------------------------------------------------------------------
-- removePhotosFromAlbum(theAlbum, thePhotos)
--
-- Removes photos from a single album
-------------------------------------------------------------------------------
on removePhotosFromAlbum(theAlbum, thePhotos)
	tell application id "com.apple.photos"
		if theAlbum is missing value then
			return missing value
		end if
		if (count of thePhotos) is equal to 0 then
			return theAlbum
		end if
		local allPhotos
		local photosToBeKept
		local photoIds
		local albumPath
		local aKeyword
		tell me to set albumPath to getPathByAlbum(theAlbum)
		if albumPath is missing value then
			return missing value
		end if
		-- get all photos from theAlbum
		set allPhotos to (get media items of theAlbum)
		set photoIds to {}
		-- collect all photos (the id) which should be kept
		repeat with photo in allPhotos
			set found to false
			repeat with photoToBeDeleted in thePhotos
				if id of photo is equal to id of photoToBeDeleted then
					set found to true
				end if
			end repeat
			if not found then
				set end of photoIds to id of photo
			end if
		end repeat
		
		-- get the photos which should be kept
		-- remarks:
		-- the photo object in an album is different to the object which is 
		-- in the global mediathek
		set photosToBeKept to {}
		
		repeat with photoId in photoIds
			set photos to (get media items whose id is equal to photoId)
			set end of photosToBeKept to item 1 of photos
		end repeat
		
		if (count of photosToBeKept) is not equal to (count of allPhotos) then
			delete theAlbum
			tell script "hbPhotosUtilities"
				set theAlbum to album by path albumPath with create if not exists
			end tell
			if (count of photosToBeKept) is greater than 0 then
				add photosToBeKept to theAlbum
			end if
		end if
		
		return theAlbum
		
	end tell
end removePhotosFromAlbum

-------------------------------------------------------------------------------
-- cleanupAlbum(theAlbum)
--
-- Removes photos from a single album which are out of date or no onger published
-------------------------------------------------------------------------------
on cleanupAlbum(theAlbum)
	log message "cleanupAlbum() start"
	tell application id "com.apple.photos"
		if theAlbum is missing value then
			return missing value
		end if
		local allPhotos
		local photosToBeKept
		local photoIds
		local albumPath
		local aKeyword
		tell me to set albumPath to getPathByAlbum(theAlbum)
		if albumPath is missing value then
			return missing value
		end if
		set allPhotos to (get media items of theAlbum)
		set photoIds to {}
		log message "get for all photos that should be kept in album"
		log message "count photos: " & (count of allPhotos)
		repeat with photo in allPhotos
			set theKeywords to the keywords of photo
			if theKeywords is missing value then
				set theKeywords to {}
			end if
			set found to false
			repeat with index from 1 to count of theKeywords
				if item index of theKeywords is equal to "lr:out-of-date" or item index of theKeywords is equal to "lr:no-longer-published" then
					set found to true
				end if
			end repeat
			if not found then
				set end of photoIds to id of photo
			end if
		end repeat
		
		set photosToBeKept to {}
		
		repeat with photoId in photoIds
			set photos to (get media items whose id is equal to photoId)
			set end of photosToBeKept to item 1 of photos
		end repeat
		
		log message "count photos to keep: " & (count of photosToBeKept)
		
		if (count of photosToBeKept) is not equal to (count of allPhotos) then
			log message "delete album " & name of theAlbum
			delete theAlbum
			log message "recreate album"
			tell script "hbPhotosUtilities"
				set theAlbum to album by path albumPath with create if not exists
			end tell
			if (count of photosToBeKept) is greater than 0 then
				log message "add photos to recreated album"
				add photosToBeKept to theAlbum
			end if
		end if
		
		return theAlbum
		
	end tell
	log message "cleanupAlbum() end"
	
end cleanupAlbum
-------------------------------------------------------------------------------
-- removeAlbumKeyword( photo, albumName )
-------------------------------------------------------------------------------
on removeAlbumKeyword(photo, albumName)
	tell application "Photos"
		set theseKeywords to the keywords of photo
		if theseKeywords is missing value then
			set theseKeywords to {}
		end if
		set newKeywords to {}
		repeat with aKeyword in theseKeywords
			if aKeyword does not start with "album:" then
				set end of newKeywords to aKeyword
			else
				if albumName is not equal to "*" and aKeyword does not end with albumName then
					set end of newKeywords to aKeyword
				end if
			end if
		end repeat
		if (count of theseKeywords) is not equal to (count of newKeywords) then
			set keywords of photo to newKeywords
		end if
	end tell
end removeAlbumKeyword
-------------------------------------------------------------------------------
-- setNoLongerPublished( photo )
-------------------------------------------------------------------------------
on setNoLongerPublished(photo)
	tell application "Photos"
		local newKeywords
		set newKeywords to {}
		set noLongerPublishedKeyword to "lr:no-longer-published"
		set theseKeywords to the keywords of photo
		if theseKeywords does not contain noLongerPublishedKeyword then
			if theseKeywords is missing value then
				set newKeywords to {}
			else
				set newKeywords to theseKeywords
			end if
			set end of newKeywords to noLongerPublishedKeyword
			set keywords of photo to newKeywords
		end if
	end tell
end setNoLongerPublished
-------------------------------------------------------------------------------
-- Remove photos from albums
-------------------------------------------------------------------------------
on remove(photoDescriptors, session)
	set currentDelimiter to AppleScript's text item delimiters
	set AppleScript's text item delimiters to ":"
	set removedPhotos to {}
	local targetAlbum
	tell script "hbPhotosUtilities"
		set targetAlbum to album by path albumName of session without create if not exists
	end tell
	if targetAlbum is missing value then
		return removedPhotos
	end if
	
	tell application id "com.apple.photos"
		set photosToBeRemovedFromAlbum to {}
		repeat with aPhotoDescriptor in photoDescriptors
			-- the LR id. For future use
			set lrId to text item 2 of aPhotoDescriptor
			-- name of cataloge
			set lrCat to text item 3 of aPhotoDescriptor
			-- Photos app UID
			set photosId to text item 4 of aPhotoDescriptor
			
			try
				set targetPhotos to (every media item whose id is equal to photosId)
				if (count of targetPhotos) is greater than 0 then
					-- the photo exists
					set theTargetPhoto to item 1 of targetPhotos
					
					local psAlbums
					tell me to set psAlbums to getPublishServiceAlbums(theTargetPhoto)
					
					if (count of psAlbums) is equal to 0 then
						-- This should never happen
						-- Clean up album:* keywords
						tell me to removeAlbumKeyword(theTargetPhoto, "*")
						-- set no longer published
						tell me to setNoLongerPublished(theTargetPhoto)
						-- remove ID in Lightroom
						set newEntry to "n.a." & ":" & lrId & ":" & lrCat & ":" & photosId
						copy newEntry to the end of removedPhotos
					else
						tell me to set hasAlbum to containsAlbum(psAlbums, targetAlbum)
						if hasAlbum then
							-- remove photo from album
							set end of photosToBeRemovedFromAlbum to theTargetPhoto
							-- remove album:keyword
							tell me to removeAlbumKeyword(theTargetPhoto, name of targetAlbum)
							if (count of psAlbums) is equal to 1 then
								tell me to setNoLongerPublished(theTargetPhoto)
								-- remove ID in Lightroom
								set newEntry to "n.a." & ":" & lrId & ":" & lrCat & ":" & photosId
								copy newEntry to the end of removedPhotos
							end if
						else
							-- This should never happen
							-- But there is no metadata which we have to clean up.
							-- Even the ID in Lightroom may not be deleted.
						end if
					end if
				else
					-- target photo was not found at all.
					-- but as it was sent from LR we should clear photosId in LR
					set newEntry to "n.a." & ":" & lrId & ":" & lrCat & ":" & photosId
					copy newEntry to the end of removedPhotos
				end if
			on error e
				error "Can't remove photo from album for photoID " & photosId & ". Error was " & e
			end try
		end repeat
		--
		tell me to set targetAlbum to removePhotosFromAlbum(targetAlbum, photosToBeRemovedFromAlbum)
	end tell
	set AppleScript's text item delimiters to currentDelimiter
	return removedPhotos
end remove

-------------------------------------------------------------------------------
-- Update status flag in session file to tell Lightroom we are finished here
-------------------------------------------------------------------------------
on updateSessionFile(sessionFile, session)
	-- tell application "Finder" to delete POSIX file sessionFile
	set fileRef to open for access sessionFile as «class utf8» with write permission
	set eof fileRef to 0
	if hasErrors of session then
		set exportDone of session to false
	else
		set exportDone of session to true
	end if
	set romanContent to ¬
		"albumName=" & albumName of session & linefeed & ¬
		"mode=" & mode of session & linefeed & ¬
		"exportDone=" & exportDone of session & linefeed & ¬
		"ignoreByRegex=" & ignoreByRegex of session & linefeed & ¬
		"hasErrors=" & hasErrors of session & linefeed & ¬
		"keepOldPhotos=" & keepOldPhotos of session & linefeed & ¬
		"errorMsg=" & errorMsg of session
	tell script "hbMacRomanUtilities"
		set utf8Content to transform macroman text romanContent to UTF8
	end tell
	write utf8Content to sessionFile
	close access fileRef
end updateSessionFile
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
on updatePhotosFile(photosFile, photosList)
	open for access photosFile as «class utf8» with write permission
	set eof of photosFile to 0
	repeat with thePhotoFile in photosList
		log thePhotoFile
		write thePhotoFile & "
" to photosFile
	end repeat
	close access photosFile
end updatePhotosFile
-------------------------------------------------------------------------------
-- getPublishServiceAlbums(photosId)
--
-- returns a list of albums wich uses the photosId and are maintanined by 
-- a Lightroom publish service.
-- 
-------------------------------------------------------------------------------
on getPublishServiceAlbums(thePhoto)
	local psAlbums
	set psAlbums to {}
	
	local allPSAlbumNames
	set allPSAlbumNames to getPublishServiceAlbumNames(thePhoto)
	tell application id "com.apple.photos"
		local allAlbums
		tell script "hbPhotosUtilities"
			set allAlbums to every album containing media item id (get id of thePhoto)
		end tell
		repeat with aAlbum in allAlbums
			repeat with aPSAlbumName in allPSAlbumNames
				if aPSAlbumName as string is equal to name of aAlbum then
					set end of psAlbums to aAlbum
				end if
			end repeat
		end repeat
	end tell
	return psAlbums
end getPublishServiceAlbums
-------------------------------------------------------------------------------
-- getPublishServiceAlbumNames(thePhoto)
--
-- returns a list of album names which are mentioned in the "album:*" keywords of 
-- thePhoto.
-- 
-------------------------------------------------------------------------------
on getPublishServiceAlbumNames(thePhoto)
	local psAlbumNames
	set psAlbumNames to {}
	tell application id "com.apple.photos" to set currentKeywords to the keywords of thePhoto
	if currentKeywords is missing value then
		set currentKeywords to {}
	end if
	set currentDelimiter to AppleScript's text item delimiters
	set AppleScript's text item delimiters to "album:"
	repeat with aKeyword in currentKeywords
		if aKeyword starts with "album:" then
			set aAlbumName to text item 2 of aKeyword
			copy aAlbumName to the end of psAlbumNames
		end if
	end repeat
	set AppleScript's text item delimiters to currentDelimiter
	return psAlbumNames
end getPublishServiceAlbumNames
-------------------------------------------------------------------------------
-- containsAlbum(theList, theAlbum)
-------------------------------------------------------------------------------
on containsAlbum(theList, theAlbum)
	tell application id "com.apple.photos"
		repeat with aAlbum in theList
			if id of aAlbum is equal to id of theAlbum then
				return true
			end if
		end repeat
	end tell
	return false
end containsAlbum
-------------------------------------------------------------------------------
-- getPathByAlbum(theAlbum)
--
-- Returns full path of theAlbum
--
-- format of path: "/folder1/folder2/..../album"
-------------------------------------------------------------------------------
on getPathByAlbum(theAlbum)
	local thePath
	set thePath to missing value
	local theAlbums
	tell application "Photos"
		set theAlbums to get albums whose id is equal to id of theAlbum
		-- repeat with aAlbum in albums
		--	if id of aAlbum equals 
		--end
		if theAlbums is not {} then
			return "/" & name of first item of theAlbums
		end if
		repeat with aFolder in folders
			local folderName
			set folderName to name of aFolder
			tell me to set thePath to _getPathByAlbum(aFolder, theAlbum, thePath)
			if thePath is not missing value then
				set thePath to "/" & thePath
				return thePath
			end if
		end repeat
	end tell
	return missing value
end getPathByAlbum

-- recursive function used by getPathByAlbum()
on _getPathByAlbum(thisFolder, theAlbum, thePath)
	local theAlbums
	local thePath
	local thisFolderName
	tell application "Photos"
		tell thisFolder
			set thisFolderName to name of thisFolder
			set theAlbums to albums whose id is equal to id of theAlbum
			if theAlbums is not {} then
				return thisFolderName & "/" & name of first item of theAlbums
			end if
			repeat with aFolder in folders
				local folderName
				set folderName to name of aFolder
				tell me to set thePath to _getPathByAlbum(aFolder, theAlbum, thePath)
				if thePath is not missing value then
					set thePath to thisFolderName & "/" & thePath
					return thePath
				end if
			end repeat
		end tell
	end tell
	return missing value
end _getPathByAlbum
-------------------------------------------------------------------------------
-- spotlightTargetAlbum(session)
--
--  activates import album
-------------------------------------------------------------------------------
on spotlightTargetAlbum(session)
	tell script "hbPhotosUtilities"
		set targetAlbum to album by path albumName of session without create if not exists
	end tell
	tell application id "com.apple.photos"
		if targetAlbum is not missing value then
			tell targetAlbum
				spotlight
			end tell
		end if
	end tell
end spotlightTargetAlbum
-------------------------------------------------------------------------------
-- testImport
-------------------------------------------------------------------------------
on testImport()
	tell script "hbPhotosUtilities"
		set targetAlbum to album by path "/Test/Test3/Test4/Test5/Test6/Yield7" without create if not exists
	end tell
	local thePath
	set thePath to getPathByAlbum(targetAlbum)
	set dummy to 0
end testImport
-------------------------------------------------------------------------------
-- Run the import script
-------------------------------------------------------------------------------
on run argv
	set logFile to ((path to documents folder) as Unicode text) & "LrClassicLogs:PhotosServiceProvider.log"
	enable logging to file logFile
	log message "PhotosImport.app start"
	
	if (argv = me) then
		set argv to {"/Users/dieterstockhausen/Library/Caches/at.homebrew.lrphotos/Dieses und Dases/Hintergrundbilder *"}
	end if
	-- Read the directory from the input and define the session file
	set tempFolder to item 1 of argv
	log message "tempFolder=" & tempFolder
	
	try
		set sessionFile to tempFolder & "/session.txt"
		log message "sessionFile=" & sessionFile
		
		open for access sessionFile
		local sessionContents
		set sessionContents to (read sessionFile as «class utf8»)
		close access sessionFile
	on error e
		log message e as severe
		return
	end try
	local session
	set session to getSession(sessionContents)
	set hasErrors of session to false
	try
		if mode of session is equal to "" then
			error "Mode is not set."
		else
			set photosFile to tempFolder & "/photos.txt"
			log message "photosFile=" & photosFile
			
			open for access photosFile as «class utf8»
			set photosContents to (read photosFile)
			close access photosFile
			local photoDescriptors
			set photoDescriptors to getPhotoDescriptors(photosContents)
			if mode of session is equal to "publish" then
				set importedPhotos to import(photoDescriptors, session)
				if (count of importedPhotos) is equal to 0 then
					error "Unknown error. No photos were not imported."
				end if
				
				updatePhotosFile(photosFile, importedPhotos)
			else
				if mode of session is equal to "remove" then
					set removedPhotos to remove(photoDescriptors, session)
					updatePhotosFile(photosFile, removedPhotos)
				else
					error "The value for mode is not valid: " & mode of session
				end if
			end if
		end if
	on error e
		log message e as severe
		set hasErrors of session to true
		set errorMsg of session to e
		updateSessionFile(sessionFile, session)
		log message "PhotosImport.app end"
		return
	end try
	--
	spotlightTargetAlbum(session)
	
	updateSessionFile(sessionFile, session)
	log message "PhotosImport.app end"
	
end run
