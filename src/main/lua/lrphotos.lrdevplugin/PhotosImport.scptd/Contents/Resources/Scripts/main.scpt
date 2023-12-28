#@osa-lang:AppleScript
-------------------------------------------------------------------------------
-- Initial created by Simon Schoeters in 2011
--
-- 29.05.2021. Dieter Stockhausen. Add publishing functionality
--
-------------------------------------------------------------------------------
use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions
use framework "Foundation"

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
		set aLine to trimThis(aLine, true, true)
		log aLine
		if aLine is not equal to "" then
			copy aLine to the end of photos
		end if
	end repeat
	return photos
end getPhotoDescriptors
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
--
-------------------------------------------------------------------------------
on trimThis(pstrSourceText, pstrCharToTrim, pstrTrimDirection)
	-- http://macscripter.net/viewtopic.php?id=18519
	-- pstrSourceText : The text to be trimmed
	-- pstrCharToTrim     : A list of characters to trim, or true to use default
	-- pstrTrimDirection : Direction of Trim left, right or any value for full

	set strTrimedText to pstrSourceText

	-- If undefinied use default whitespaces
	if pstrCharToTrim is missing value or class of pstrCharToTrim is not list then
		-- trim tab, newline, return and all the unicode characters from the 'separator space' category
		-- [url]http://www.fileformat.info/info/unicode/category/Zs/list.htm[/url]
		set pstrCharToTrim to {tab, linefeed, return, space, character id 160, character id 5760, character id 8192, character id 8193, character id 8194, character id 8195, character id 8196, character id 8197, character id 8198, character id 8199, character id 8200, character id 8201, character id 8202, character id 8239, character id 8287, character id 12288}
	end if

	set lLoc to 1
	set rLoc to count of strTrimedText

	--- From left to right, get location of first non-whitespace character
	if pstrTrimDirection is not right then
		repeat until lLoc = (rLoc + 1) or character lLoc of strTrimedText is not in pstrCharToTrim
			set lLoc to lLoc + 1
		end repeat
	end if

	-- From right to left, get location of first non-whitespace character
	if pstrTrimDirection is not left then
		repeat until rLoc = 0 or character rLoc of strTrimedText is not in pstrCharToTrim
			set rLoc to rLoc - 1
		end repeat
	end if

	if lLoc ≥ rLoc then
		return ""
	else
		return text lLoc thru rLoc of strTrimedText
	end if
end trimThis
-------------------------------------------------------------------------------
-- Import exported photos in a new iPhoto album if needed
-------------------------------------------------------------------------------
on import(photoDescriptors, session)
	set AppleScript's text item delimiters to ":"
	set targetAlbum to getAlbumByPath(albumName of session, true)

	tell application id "com.apple.photos"
		set importedPhotos to {}

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

			set previousAlbums to {}
			try
				if isUpdate is true then
					set targetPhotos to (every media item whose id is equal to photosId)
					if (count of targetPhotos) is greater than 0 then
						tell me to set previousAlbums to getUsedBy(photosId)
						set theTargetPhoto to item 1 of targetPhotos
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
				repeat with aAlbum in previousAlbums
					set aAlbumName to name of aAlbum
					tell me to set isValid to not matchesRegex(aAlbumName, ignoreByRegex of session)
					if isValid is true then
						repeat with newPhoto2 in newPhotos
							try
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
								add newPhotos to aAlbum
							on error e
								error "Can't add imported photos to album '" & aAlbumName & "'. Maybe it's a smart album and you should exlude it. Error was: " & e
							end try

						end repeat
					end if
				end repeat
			end if
			--
			-- Update metadata
			try
				if (count of newPhotos) is greater than 0 then
					-- set the name of the LR catalog file
					set targetAlbumName to name of targetAlbum
					set newKeywords to {"lr:" & lrCat & ".lrcat", "album:" & targetAlbumName}
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
		end repeat
		--

		local aAlbumName
		repeat with aAlbum in previousAlbums
			set aAlbumName to name of aAlbum
			tell me to set isValid to not matchesRegex(name of aAlbum, ignoreByRegex of session)
			if isValid is true then
				if not keepOldPhotos of session then
					tell me to cleanupAlbum(aAlbum)
				end if
			end if
		end repeat
		delay 2
	end tell
	set AppleScript's text item delimiters to " "
	return importedPhotos
end import
-------------------------------------------------------------------------------
-- Remove item from list
-------------------------------------------------------------------------------
on removeItemFromList(theList, theItem)
	repeat with theIndex from 1 to the count of theList
		if item theIndex of theList is equal to theItem then
			if theIndex = 1 then
				return items 2 thru -1 of theList
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
			tell me to set theAlbum to getAlbumByPath(albumPath, true)
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
		repeat with photo in allPhotos
			set theKeywords to the keywords of photo
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

		if (count of photosToBeKept) is not equal to (count of allPhotos) then
			delete theAlbum
			tell me to set theAlbum to getAlbumByPath(albumPath, true)
			if (count of photosToBeKept) is greater than 0 then
				add photosToBeKept to theAlbum
			end if
		end if

		return theAlbum

	end tell
end cleanupAlbum
-------------------------------------------------------------------------------
-- Remove photos from albums
-------------------------------------------------------------------------------
on remove(photoDescriptors, session)
	set AppleScript's text item delimiters to ":"
	set removedPhotos to {}

	set targetAlbum to getAlbumByPath(albumName of session, false)
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
					local allUsedByAlbums
					tell me to set allUsedByAlbums to getUsedBy(photosId)


					if (count of allUsedByAlbums) is equal to 0 then
						-- if photos is not used any more we clear photosId from LR
						set newEntry to "n.a." & ":" & lrId & ":" & lrCat & ":" & photosId
						copy newEntry to the end of removedPhotos
					else
						-- the photo exists and is used in any album
						--
						-- validate that the target photos is really in the target album
						set photoIsInTargetAlbum to false
						repeat with aUsedByAlbum in allUsedByAlbums
							if id of aUsedByAlbum is equal to id of targetAlbum then
								set photoIsInTargetAlbum to true
							end if
						end repeat

						-- if target photo is not in the target album, there is nothing to do
						if photoIsInTargetAlbum then
							local theseKeywords
							set theseKeywords to the keywords of theTargetPhoto

							local validAlbums
							local aAlbumName
							set validAlbums to {}
							repeat with aAlbum in allUsedByAlbums
								set aAlbumName to name of aAlbum
								tell me to set isValid to not matchesRegex(aAlbumName, ignoreByRegex of session)
								if isValid then
									set end of validAlbums to aAlbum
								end if
							end repeat

							-- mark photo as no-longer-published if necessary
							if (count of validAlbums) is equal to 1 then
								-- target album is the last album which holds the target photo
								-- we mark it as no-longer-published
								set newEntry to "n.a." & ":" & lrId & ":" & lrCat & ":" & photosId
								copy newEntry to the end of removedPhotos
								set noLongerPublishedKeyword to "lr:no-longer-published"
							else
								-- target is still in use
								set noLongerPublishedKeyword to missing value
							end if

							-- remove the album keyword
							if theseKeywords is not missing value then
								local oldKeyword
								set oldKeyword to "album:" & name of targetAlbum
								tell me to set newKeywords to removeItemFromList(theseKeywords, oldKeyword)
								if noLongerPublishedKeyword is not missing value then
									set end of newKeywords to noLongerPublishedKeyword
								end if
								set keywords of theTargetPhoto to newKeywords
							else
								if noLongerPublishedKeyword is not missing value then
									set newKeywords to {}
									set end of newKeywords to noLongerPublishedKeyword
									set keywords of theTargetPhoto to newKeywords
								end if
							end if
							-- remove target photo from target album
							set end of photosToBeRemovedFromAlbum to theTargetPhoto
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
	set AppleScript's text item delimiters to " "
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

	write ¬
		"albumName=" & albumName of session & linefeed & ¬
		"mode=" & mode of session & linefeed & ¬
		"exportDone=" & exportDone of session & linefeed & ¬
		"ignoreByRegex=" & ignoreByRegex of session & linefeed & ¬
		"hasErrors=" & hasErrors of session & linefeed & ¬
		"keepOldPotos=" & keepOldPhotos of session & linefeed & ¬
		"errorMsg=" & errorMsg of session to sessionFile
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
-- getUsedBy(photosId)
--
-- returns a list of albums of all folders which uses the photo identified by
-- ptotosId
--
-------------------------------------------------------------------------------
on getUsedBy(photosId)
	local usedBy
	set usedBy to {}
	tell application "Photos"
		set usedBy to get (albums whose id of media items contains photosId)
		repeat with aFolder in folders
			tell me to set usedBy to _getUsedBy(aFolder, photosId, usedBy)
		end repeat
	end tell
	return usedBy
end getUsedBy

-- recursive function used by getUsedBy()
on _getUsedBy(aFolder, photosId, usedBy)
	local usedBy
	tell application "Photos"
		tell aFolder
			set usedBy to usedBy & (albums whose id of media items contains photosId)
			repeat with aFolder in folders
				tell me to set usedBy to _getUsedBy(aFolder, photosId, usedBy)
			end repeat
		end tell
	end tell
	return usedBy
end _getUsedBy

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
		end tell
	on error e
		error "Can't get album for path " & albumPath & ". Error was: " & e
	end try
	return theAlbum

end getAlbumByPath
-------------------------------------------------------------------------------
-- spotlightTargetAlbum(session)
--
--  activates import album
-------------------------------------------------------------------------------
on spotlightTargetAlbum(session)
	set targetAlbum to getAlbumByPath(albumName of session, false)
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
	-- set targetAlbum to getAlbumByPath("/Test/Test3/Test4/Yield4", false)
	set targetAlbum to getAlbumByPath("/Test/Test3/Test4/Test5/Test6/Yield7", false)
	-- set targetAlbum to getAlbumByPath("/Yield0", false)
	-- set targetAlbum to getAlbumByPath("/Test/Yield2", false)


	local thePath
	set thePath to getPathByAlbum(targetAlbum)
	set dummy to 0
end testImport
-------------------------------------------------------------------------------
-- Run the import script
-------------------------------------------------------------------------------
on run argv
	-- testImport()
	-- return

	if (argv = me) then
		set argv to {"/private/tmp/at.homebrew.lrphotos/Test/Yield2, Yield2.1"}
	end if
	-- Read the directory from the input and define the session file
	set tempFolder to item 1 of argv

	set sessionFile to POSIX file (tempFolder & "/session.txt")
	open for access sessionFile
	local sessionContents
	set sessionContents to (read sessionFile as «class utf8»)
	close access sessionFile

	local session
	set session to getSession(sessionContents)
	set hasErrors of session to false
	try
		if mode of session is equal to "" then
			error "Mode is not set."
		else
			set photosFile to tempFolder & "/photos.txt"
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
		set hasErrors of session to true
		set errorMsg of session to e
		updateSessionFile(sessionFile, session)
		return
	end try
	--
	spotlightTargetAlbum(session)

	updateSessionFile(sessionFile, session)

end run
