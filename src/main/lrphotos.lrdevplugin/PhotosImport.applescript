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
use script "hbPhotosUtilities"
use script "hbStringUtilities"
use script "hbMacRomanUtilities"

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
	set session to {mode:"", albumName:"", ignoreByRegex:"", hasErrors:false, errorMsg:"", exportDone:false, keepOldPhotos:true, keepNoLongerPublishedPhotos:true} as record
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
									else
										if aKey is equal to "keepNoLongerPublishedPhotos" then
											set keepNoLongerPublishedPhotos of session to value is equal to "true"
										end if
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
	set photoDescriptors to {}
	set allLines to every paragraph of photosContents
	set AppleScript's text item delimiters to ":"
	
	repeat with aLine in allLines
		set aLine to (remove white space around aLine)
		log aLine
		if aLine is not equal to "" then
			set tokens to text items of aLine
			set photoDescriptor to {imagefile:"", lrId:"", lrCat:"", photosId:""} as record
			set imagefile of photoDescriptor to item 1 of tokens
			set lrId of photoDescriptor to item 2 of tokens
			set lrCat of photoDescriptor to item 3 of tokens
			if (count of tokens) is equal to 4 then
				set photosId of photoDescriptor to text item 4 of aLine
			end if
			
			copy photoDescriptor to the end of photoDescriptors
		end if
	end repeat
	
	set AppleScript's text item delimiters to ""
	return photoDescriptors
end getPhotoDescriptors

-------------------------------------------------------------------------------
-- getPhotoById()
-------------------------------------------------------------------------------
on getPhotoById(theId)
	set thePhote to missing value
	try
		tell application "Photos" to set thePhoto to media item id theId
	on error
		return missing value
	end try
	return thePhoto
end getPhotoById
-------------------------------------------------------------------------------
-- setOutOfDate(thePhoto)
-------------------------------------------------------------------------------
on setKeywords(thePhoto, newKeywords)
	tell application "Photos"
		set theseKeywords to the keywords of thePhoto
		if theseKeywords is missing value then
			set keywords of thePhoto to newKeywords
		else
			set keywords of thePhoto to (theseKeywords & newKeywords)
		end if
	end tell
end setKeywords
-------------------------------------------------------------------------------
-- importPhoto
-------------------------------------------------------------------------------
on importPhoto(imagefile)
	set aliasPhotoFile to {POSIX file imagefile as alias}
	tell application "Photos"
		set newPhotos to import aliasPhotoFile with skip check duplicates
	end tell
	log message "id of new photo: " & id of first item of newPhotos
	return first item of newPhotos
end importPhoto
-------------------------------------------------------------------------------
-- getCurrentAlbums
-------------------------------------------------------------------------------
on getCurrentAlbums(photosId, ignoreByRegex)
	local allCurrentAlbums
	local currentAlbums
	local aAlbum
	set currentAlbums to {}
	set allCurrentAlbums to (every album containing media item id photosId)
	tell application "Photos"
		repeat with aAlbum in allCurrentAlbums
			set aAlbumName to name of aAlbum
			set isValid to not (regex expression ignoreByRegex matches aAlbumName)
			if isValid then
				copy aAlbum to the end of currentAlbums
			end if
		end repeat
	end tell
	return currentAlbums
end getCurrentAlbums
-------------------------------------------------------------------------------
-- getCurrentAlbums
-------------------------------------------------------------------------------
on appendAlbumsToList(targetList, source)
	local source
	local targetList
	tell application "Photos"
		if class of source is equal to list then
			repeat with sourceItem in source
				set found to false
				repeat with targetItem in targetList
					if id of targetItem is equal to id of sourceItem then
						set found to true
						exit repeat
					end if
				end repeat
				if not found then
					copy sourceItem to the end of targetList
				end if
			end repeat
		else
			set found to false
			local targetItem
			repeat with targetItem in targetList
				if id of targetItem is equal to id of source then
					set found to true
					exit repeat
				end if
			end repeat
			if not found then
				copy source to the end of targetList
			end if
		end if
	end tell
	return targetList
end appendAlbumsToList
-------------------------------------------------------------------------------
-- Import exported photos in a new iPhoto album if needed
-------------------------------------------------------------------------------
on import(photoDescriptors, session)
	log message "import() start"
	set AppleScript's text item delimiters to ":"
	
	tell application "Photos"
		log message "targetAlbum=" & albumName of session
		try
			set targetAlbum to album by path albumName of session with create if not exists
			log message "id of target album: " & id of targetAlbum
			log message "class of target album: " & class of targetAlbum
		on error e
			error "Album " & albumName of session & " could not be found or created. Error was: " & e
		end try
		
		set importedPhotos to {}
		log message "Start import of " & (count of photoDescriptors) & " photos"
		
		local allChangedAlbums
		set allChangedAlbums to {}
		
		repeat with photoDescriptor in photoDescriptors
			log message "Start import of " & imagefile of photoDescriptor
			
			set isUpdate to true
			if photosId of photoDescriptor is equal to "" then
				set isUpdate to false
			end if
			log message "update=" & isUpdate
			
			local currentAlbums
			set currentAlbums to {}
			--
			-- if is update 
			-- 		get all albums that uses the current photo 
			-- 		set the current photo to out of date
			--
			try
				if isUpdate is true then
					tell me to set currentPhoto to getPhotoById(photosId of photoDescriptor)
					if currentPhoto is missing value then
						-- happens if the photo was deleted in Photos
						log message "no current photo found" as alarm
						set isUpdate to false
					else
						log message "current photo found"
						tell me to set currentAlbums to getCurrentAlbums(photosId of photoDescriptor, ignoreByRegex of session)
						log message "set predecessor to out of date"
						tell me to setKeywords(currentPhoto, {"lr:out-of-date"})
					end if
				end if
			on error e
				error "Can't get all albums for photoID " & photosId of photoDescriptor & ". Error was " & e
			end try
			--
			-- Import the LR photo
			--
			try
				log message "import " & imagefile of photoDescriptor
				tell me to set newPhoto to importPhoto(imagefile of photoDescriptor)
			on error e
				error "Import of photos failed. Error was: " & e
			end try
			
			-- For more cleaness we create a new list of all albums
			local newAlbums
			set newAlbums to currentAlbums
			tell me to set newAlbums to appendAlbumsToList(newAlbums, targetAlbum)
			--
			-- Add new photo to all albums	(current ones and the targeAlbum)
			--		
			log message "update all albums"
			repeat with aAlbum in newAlbums
				set aAlbumName to name of aAlbum
				log message "aAlbumName=" & aAlbumName
				try
					log message "set album keyword " & "album:" & aAlbumName & " on new photo"
					tell me to setKeywords(newPhoto, {"album:" & aAlbumName})
				on error e
					error "Can't add new album tag album:" & aAlbumName & " on existing photos. Error was: " & e
				end try
				try
					log message "add new photo to album"
					set newPhotoList to {}
					copy newPhoto to end of newPhotoList
					log message "id of album " & aAlbumName & " is: " & id of aAlbum
					log message "class of album " & aAlbumName & " is: " & class of aAlbum
					-- add newPhotoList to aAlbum
					add newPhotoList to album id (aAlbum's id)
				on error e
					error "Can't add imported photos to album '" & aAlbumName & "'. Maybe it's a smart album and you should exlude it. Error was: " & e
				end try
			end repeat
			-- 
			-- Add catalog keyword to new photos 
			--
			try
				log message "update target album info on new photo"
				log message "set new keywords " & "lr:" & lrCat of photoDescriptor & ".lrcat"
				tell me to setKeywords(newPhoto, {"lr:" & lrCat of photoDescriptor & ".lrcat"})
			on error e
				error "Can't keywords on imported photo. Error was: " & e
			end try
			
			--
			-- Add new photo ID for LR
			--
			set photosId to get the id of newPhoto
			set newEntry to imagefile of photoDescriptor & ":" & lrId of photoDescriptor & ":" & lrCat of photoDescriptor & ":" & photosId
			log message "add new photo id for LR: " & newEntry
			copy newEntry to the end of importedPhotos
			
			--
			-- Add newAlbums to the global list
			--
			tell me to appendAlbumsToList(allChangedAlbums, newAlbums)
		end repeat
		
		--
		-- Remove predecessor photos from albums
		--
		if not keepOldPhotos of session then
			log message "remove predecessor photos from " & (count of allChangedAlbums) & " album(s)"
			local aAlbumName
			repeat with aAlbum in allChangedAlbums
				set aAlbumName to name of aAlbum
				log message "cleanup album " & aAlbumName
				tell me to cleanupAlbum(aAlbum)
			end repeat
			delay 2
		else
			log message "predecessor photos will not be removed from albums"
		end if
	end tell
	log message "import() end"
	set AppleScript's text item delimiters to ""
	
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
		set albumId to theAlbum's id
		set albumPath to path for album id albumId
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
			delete album id (theAlbum's id)
			delay 1
			tell me to set theAlbum to getAlbumByPath(albumPath, true)
			-- set theAlbum to album by path albumPath with create if not exists
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
		set albumId to theAlbum's id
		set albumPath to path for album id albumId
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
		
		log message "photos to keep: " & (count of photosToBeKept)
		
		if (count of photosToBeKept) is not equal to (count of allPhotos) then
			log message "delete album " & name of theAlbum
			delete theAlbum
			log message "recreate album"
			set theAlbum to album by path albumPath with create if not exists
			if (count of photosToBeKept) is greater than 0 then
				log message "add photos to recreated album"
				try
					add photosToBeKept to theAlbum
				on error e
					error "Photo(s) can't be added to album " & albumPath & ". Error was: " & e
				end try
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
	log message "remove() start"
	set AppleScript's text item delimiters to ":"
	set removedPhotos to {}
	local targetAlbum
	set targetAlbum to album by path albumName of session without create if not exists
	if targetAlbum is missing value then
		log message "Album " & albumName of session & " was not found." as severe
		return removedPhotos
	end if
	
	tell application "Photos"
		set photosToBeRemovedFromAlbum to {}
		repeat with photoDescriptor in photoDescriptors
			try
				log message "remove photo " & photosId of photoDescriptor & " from album " & name of targetAlbum
				tell me to set targetPhoto to getPhotoById(photosId of photoDescriptor)
				if targetPhoto is missing value then
					log message "photo was not found" as fault
					-- target photo was not found at all.
					-- but as it was sent from LR we should clear photosId in LR
					set newEntry to "n.a." & ":" & lrId of photoDescriptor & ":" & lrCat of photoDescriptor & ":" & photosId of photoDescriptor
					copy newEntry to the end of removedPhotos
				else
					-- the photo exists					
					local psAlbums
					log message "get all albums that uses the photo and are maintained by the publish service"
					tell me to set psAlbums to getPublishServiceAlbums(targetPhoto)
					
					if (count of psAlbums) is equal to 0 then
						log message "no album uses this photo" as alarm
						-- This should never happen
						-- Clean up album:* keywords
						log message "clean up album:* keywords"
						tell me to removeAlbumKeyword(targetPhoto, "*")
						-- set no longer published
						tell me to setNoLongerPublished(targetPhoto)
						-- remove ID in Lightroom
						set newEntry to "n.a." & ":" & lrId of photoDescriptor & ":" & lrCat of photoDescriptor & ":" & photosId of photoDescriptor
						copy newEntry to the end of removedPhotos
					else
						log message "found " & (count of psAlbums) & " that uses the photo"
						tell me to set hasAlbum to containsAlbum(psAlbums, targetAlbum)
						if hasAlbum then
							-- remove photo from album
							log message "mark photo for removal"
							set end of photosToBeRemovedFromAlbum to targetPhoto
							-- remove album:keyword
							log message "remove album:* keyword"
							tell me to removeAlbumKeyword(targetPhoto, name of targetAlbum)
							if (count of psAlbums) is equal to 1 then
								log message "as this was the last album that uses the photo, we set keyword no-longer-publish"
								tell me to setNoLongerPublished(targetPhoto)
								-- remove ID in Lightroom
								set newEntry to "n.a." & ":" & lrId of photoDescriptor & ":" & lrCat of photoDescriptor & ":" & photosId of photoDescriptor
								copy newEntry to the end of removedPhotos
							end if
						else
							log message "the target album does not use the photo" as warn
							-- This should never happen
							-- But there is no metadata which we have to clean up.
							-- Even the ID in Lightroom may not be deleted.
						end if
					end if
				end if
			on error e
				error "Can't remove photo from album for photoID " & photosId & ". Error was " & e
			end try
		end repeat
		--
		if not keepNoLongerPublishedPhotos of session then
			tell me to set targetAlbum to removePhotosFromAlbum(targetAlbum, photosToBeRemovedFromAlbum)
		end if
	end tell
	log message "remove() end"
	set AppleScript's text item delimiters to ""
	
	return removedPhotos
end remove

-------------------------------------------------------------------------------
-- Update status flag in session file to tell Lightroom we are finished here
-------------------------------------------------------------------------------
on updateSessionFile(sessionFile, session)
	log message "updateSessionFile() start"
	-- tell application "Finder" to delete POSIX file sessionFile
	log message "sessionFile=" & sessionFile
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
		"keepNoLongerPublishedPhotos=" & keepNoLongerPublishedPhotos of session & linefeed & ¬
		"errorMsg=" & errorMsg of session
	set utf8Content to transform macroman text romanContent to UTF8
	write utf8Content to sessionFile
	close access fileRef
	log message "updateSessionFile() end"
end updateSessionFile
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
on updatePhotosFile(photosFile, photosList)
	log message "updatePhotosFile() start"
	log message "photosFile=" & photosFile
	open for access photosFile as «class utf8» with write permission
	set eof of photosFile to 0
	repeat with thePhotoFile in photosList
		log thePhotoFile
		write thePhotoFile & "
" to photosFile
	end repeat
	close access photosFile
	log message "updatePhotosFile() end"
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
		set allAlbums to every album containing media item id (get id of thePhoto)
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
	set AppleScript's text item delimiters to "album:"
	repeat with aKeyword in currentKeywords
		if aKeyword starts with "album:" then
			set aAlbumName to text item 2 of aKeyword
			copy aAlbumName to the end of psAlbumNames
		end if
	end repeat
	set AppleScript's text item delimiters to ""
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
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- matchesRegex
-------------------------------------------------------------------------------
on matchesRegex(theText, theRegex)
	set theText to current application's NSString's stringWithString:theText
	set theRange to theText's rangeOfString:(theRegex) options:NSRegularExpressionSearch
	if |length| of theRange is greater than 0 then
		return true
	else
		return false
	end if
end matchesRegex

-------------------------------------------------------------------------------
-- getAlbumByPath(albumPath, createIfNotExists)
--
-- returns the album for the given path
--
-- if createIfNotExists is true missing folders are created as well as the album
-- format of albumPath: "/folder1/folder2/..../album"
-------------------------------------------------------------------------------
on getAlbumByPath(albumPath, createIfNotExists)
	try
		if albumPath is missing value or albumPath is equal to "" then
			return missing value
		end if
		set isValid to matchesRegex(albumPath, "^(\\/[^\\/]+)+$")
		if not isValid then
			error "Albumpath " & albumPath & " is not a valid path."
		end if
		set len to the length of albumPath
		set albumPath to text 2 thru len of albumPath
		set slashOffset to (offset of "/" in albumPath)
		
		set theFolder to missing value
		if albumPath is missing value or albumPath is equal to "" then return missing value
		tell application id "com.apple.photos"
			-- go thru all path components of type folder
			repeat until slashOffset is less than 1
				-- there is at least one folder
				set folderName to text 1 thru (slashOffset - 1) of albumPath
				if theFolder is missing value then
					--  we are in the root
					set allFolders to every folder whose name is folderName
					if (count of allFolders) is greater than 0 then
						set theFolder to item 1 of allFolders
					else
						if createIfNotExists then
							set theFolder to make new folder named folderName
						else
							return missing value
						end if
					end if
				else
					-- we are in between folders
					tell theFolder to set allFolders to every folder whose name is folderName
					if (count of allFolders) is greater than 0 then
						set theFolder to item 1 of allFolders
					else
						if createIfNotExists then
							set theFolder to make new folder named folderName at theFolder
						else
							return missing value
						end if
					end if
				end if
				set albumPath to text ((offset of "/" in albumPath) + 1) thru -1 of albumPath
				set slashOffset to (offset of "/" in albumPath)
			end repeat
			if theFolder is missing value then
				--  we are in the root
				log message "search for album " & albumPath & " in root folder"
				set allAlbums to albums whose name is albumPath
				if (count of allAlbums) is greater than 0 then
					set theAlbum to item 1 of allAlbums
				else
					if createIfNotExists then
						set theAlbum to make new album named albumPath
					else
						return missing value
					end if
				end if
			else
				-- we are in a folder
				log message "search for album " & albumPath & " in folder " & name of theFolder
				tell theFolder to set allAlbums to every album whose name is albumPath
				if (count of allAlbums) is greater than 0 then
					set theAlbum to item 1 of allAlbums
				else
					if createIfNotExists then
						set theAlbum to make new album named albumPath at theFolder
					else
						return missing value
					end if
				end if
			end if
			return theAlbum
		end tell
	on error e
		error "Can't get album for path " & albumPath & ". Error was: " & e
	end try
	return missing value
end getAlbumByPath
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- testImport
-------------------------------------------------------------------------------
on testImport()
	set targetAlbum to album by path "/Test/Test3/Test4/Test5/Test6/Yield7" without create if not exists
	local thePath
	tell application "Photos" to set albumId to targetAlbum's id
	set thePath to path for album id albumId
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
		set argv to {"/Users/dieterstockhausen/Library/Caches/at.homebrew.lrphotos/Dieses und Dases/Test/Test2/Test3"}
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
			-- startPhotos()
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
	
	log message "spotlight album '" & albumName of session & "'"
	spotlight album by path albumName of session without create if not exists
	
	updateSessionFile(sessionFile, session)
	log message "PhotosImport.app end"
	
end run
