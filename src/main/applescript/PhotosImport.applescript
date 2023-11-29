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
	set session to {mode:"", albumName:"", ignoreByRegex:"", hasErrors:false, errorMsg:"", exportDone:false} as record
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
-- getAlbumByPath(albumPath)
--
-- format of albumPath:
--   "folder1/folder2/..../album"
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
						set theFolder to make new folder named folderName
					end if
				else
					-- we are in between folders
					tell theFolder to set allFolders to every folder whose name is folderName
					if (count of allFolders) is greater than 0 then
						set theFolder to item 1 of allFolders
					else
						set theFolder to make new folder named folderName at theFolder
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
					set theAlbum to make new album named albumPath
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
						set theAlbum to missing value
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
-- Import exported photos in a new iPhoto album if needed
-------------------------------------------------------------------------------
on import(photoDescriptors, session)
	set AppleScript's text item delimiters to ":"
	set importAlbum to getAlbumByPath(albumName of session, true)
	
	tell application id "com.apple.photos"
		set importedPhotos to {}
		
		repeat with aPhotoDescriptor in photoDescriptors
			-- the posix file path
			set thePhotoFile to text item 1 of aPhotoDescriptor
			-- the LR id. Not used here, but necessary for the way back to LR
			set lrId to text item 2 of aPhotoDescriptor
			-- used as keyword
			set lrCat to text item 3 of aPhotoDescriptor
			-- if exists a Photos id, it is an update.
			set isUpdate to false
			try
				set photosId to text item 4 of aPhotoDescriptor
				if photosId is not equal to "" then
					set isUpdate to true
				end if
			end try
			
			set previousAlbums to {}
			try
				if isUpdate is true then
					set previousPhotos to (every media item whose id is equal to photosId)
					if (count of previousPhotos) is greater than 0 then
						tell me to set previousAlbums to getPreviousAlbums(photosId)
						set thePreviousPhoto to item 1 of previousPhotos
						-- set the photo out-of-date
						set newKeywords to {"lr:out-of-date"}
						set theseKeywords to the keywords of thePreviousPhoto
						if theseKeywords is missing value then
							set keywords of thePreviousPhoto to newKeywords
						else
							set keywords of thePreviousPhoto to (theseKeywords & newKeywords)
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
				if importAlbum is missing value then
					-- on update, the standard album must me ignored.
					-- later it will  added to the albums of the previous photo version
					set newPhotos to import aliasPhotoFile with skip check duplicates
				else
					-- if new, it goes into the standard album
					set newPhotos to import aliasPhotoFile into importAlbum with skip check duplicates
				end if
			on error e
				error "Import of photos failed. Error was: " & e
			end try
			--
			-- put it into the previous albums
			
			if isUpdate is true then
				repeat with aAlbum in previousAlbums
					local aAlbumName
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
					set importAlbumName to name of importAlbum
					set newKeywords to {"lr:" & lrCat & ".lrcat", "album:" & importAlbumName}
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
				tell me to set aAlbum to cleanupAlbum(aAlbum)
			end if
		end repeat
		(*
		tell me to set importAlbum to cleanupAlbum(importAlbum)
		tell importAlbum
			spotlight
		end tell
		*)
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
-- Remove photos from a single album
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
	
	set importAlbum to getAlbumByPath(albumName of session, false)
	if importAlbum is missing value then
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
				set previousPhotos to (every media item whose id is equal to photosId)
				if (count of previousPhotos) is greater than 0 then
					set thePreviousPhoto to item 1 of previousPhotos
					
					local theseKeywords
					set theseKeywords to the keywords of thePreviousPhoto
					
					local allUsedAlbums
					tell me to set allUsedAlbums to getPreviousAlbums(photosId)
					local validAlbums
					set validAlbums to {}
					repeat with aAlbum in allUsedAlbums
						set aAlbumName to name of aAlbum
						tell me to set isValid to not matchesRegex(aAlbumName, ignoreByRegex of session)
						if isValid then
							set end of validAlbums to aAlbum
						end if
					end repeat
					
					if (count of validAlbums) is equal to 1 then
						set newEntry to "n.a." & ":" & lrId & ":" & lrCat & ":" & photosId
						copy newEntry to the end of removedPhotos
						set noLongerPublishedKeyword to "lr:no-longer-published"
					else
						set noLongerPublishedKeyword to missing value
					end if
					
					if theseKeywords is not missing value then
						local oldKeyword
						set oldKeyword to "album:" & name of importAlbum
						tell me to set newKeywords to removeItemFromList(theseKeywords, oldKeyword)
						if noLongerPublishedKeyword is not missing value then
							set end of newKeywords to noLongerPublishedKeyword
						end if
						set keywords of thePreviousPhoto to newKeywords
					else
						if noLongerPublishedKeyword is not missing value then
							set newKeywords to {}
							set end of newKeywords to noLongerPublishedKeyword
							set keywords of thePreviousPhoto to newKeywords
						end if
					end if
					set end of photosToBeRemovedFromAlbum to thePreviousPhoto
				end if
			on error e
				error "Can't remove photo from album for photoID " & photosId & ". Error was " & e
			end try
		end repeat
		--
		tell me to set importAlbum to cleanupAlbum(importAlbum)
		tell importAlbum
			spotlight
		end tell
	end tell
	set AppleScript's text item delimiters to " "
	return removedPhotos
end remove

-------------------------------------------------------------------------------
-- Update status flag in session file to tell Lightroom we are finished here
-------------------------------------------------------------------------------
on updateSessionFile(sessionFile, session)
	open for access sessionFile as «class utf8» with write permission
	if hasErrors of session then
		set exportDone of session to false
	else
		set exportDone of session to true
	end if
	set eof of sessionFile to 0
	write "albumName=" & albumName of session & "
mode=" & mode of session & "
exportDone=" & exportDone of session & "
ignoreByRegex=" & ignoreByRegex of session & "
hasErrors=" & hasErrors of session & "
errorMsg=" & stringReplace(stringReplace(errorMsg of session, "„", ""), "“", "") to sessionFile
	close access sessionFile
end updateSessionFile
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
on updatePhotosFile(photosFile, photosList)
	open for access photosFile with write permission
	set eof of photosFile to 0
	repeat with thePhotoFile in photosList
		log thePhotoFile
		write thePhotoFile & "
" to photosFile
	end repeat
	close access photosFile
end updatePhotosFile

-------------------------------------------------------------------------------
-- getPreviousAlbums
-------------------------------------------------------------------------------
on getPreviousAlbums(photosId)
	tell application id "com.apple.photos"
		local previousAlbums
		set previousAlbums to {}
		
		local previousFolderAlbumsL0
		set previousFolderAlbumsL0 to get (albums whose id of media items contains photosId)
		
		local previousFolderAlbumsL1
		set previousFolderAlbumsL1 to get (albums in every folder whose id of media items contains photosId)
		
		local previousFolderAlbumsL2
		set previousFolderAlbumsL2 to get (albums in every folder in every folder whose id of media items contains photosId)
		
		local previousFolderAlbumsL3
		set previousFolderAlbumsL3 to get (albums in every folder in every folder in every folder whose id of media items contains photosId)
		
		if (count of previousFolderAlbumsL0) is greater than 0 then
			repeat with rootAlbums in previousFolderAlbumsL0
				set aAlbum to item 1 of rootAlbums
				copy aAlbum to the end of the previousAlbums
			end repeat
		end if
		
		
		if (count of previousFolderAlbumsL1) is greater than 0 then
			repeat with folderL1Albums in previousFolderAlbumsL1
				repeat with rootAlbums in folderL1Albums
					set aAlbum to item 1 of rootAlbums
					copy aAlbum to the end of the previousAlbums
				end repeat
			end repeat
		end if
		
		if (count of previousFolderAlbumsL2) is greater than 0 then
			repeat with folderL2Albums in previousFolderAlbumsL2
				repeat with folderL1Albums in folderL2Albums
					repeat with rootAlbums in folderL1Albums
						set aAlbum to item 1 of rootAlbums
						copy aAlbum to the end of the previousAlbums
					end repeat
				end repeat
			end repeat
		end if
		
		if (count of previousFolderAlbumsL3) is greater than 0 then
			repeat with folderL3Albums in previousFolderAlbumsL3
				repeat with folderL2Albums in folderL3Albums
					repeat with folderL1Albums in folderL2Albums
						repeat with rootAlbums in folderL1Albums
							set aAlbum to item 1 of rootAlbums
							copy aAlbum to the end of the previousAlbums
						end repeat
					end repeat
				end repeat
			end repeat
		end if
		
	end tell
	return previousAlbums
end getPreviousAlbums
-------------------------------------------------------------------------------
-- testImport
-------------------------------------------------------------------------------
on stringReplace(haystack, needle, replace)
	tell AppleScript
		set oldTIDs to text item delimiters
		set text item delimiters to needle
		set lst to text items of haystack
		set text item delimiters to replace
		set str to lst as string
		set text item delimiters to oldTIDs
	end tell
	return str
end stringReplace
-------------------------------------------------------------------------------
-- getParentFolder
-------------------------------------------------------------------------------
on getParentFolder(aContainer, depth)
	tell application id "com.apple.photos"
		set theParent to parent of aContainer
		if theParent is missing value then
			return missing value
		end if
		set parentId1 to id of parent of aContainer
		set aFolder to missing value
		if parentId1 is not missing value then
			if depth is equal to 3 then
				set folders1 to get every folder in every folder in every folder whose id is equal to parentId1
			else
				if depth is equal to 2 then
					set folders1 to get every folder in every folder whose id is equal to parentId1
				else
					if depth is equal to 1 then
						set folders1 to get every folder whose id is equal to parentId1
					end if
				end if
			end if
			set found to false
			repeat with rootFolders in folders1
				if not found then
					set theType to class of rootFolders
					if theType is folder then
						set aFolder to rootFolders
						set found to true
					else
						repeat with subfolders1 in rootFolders
							if not found then
								set theType to class of subfolders1
								if theType is folder then
									set aFolder to subfolders1
									set found to true
								else
									repeat with subfolders2 in subfolders1
										if not found then
											set theType to class of subfolders2
											if theType is folder then
												set aFolder to subfolders2
												set found to true
											end if
										end if
									end repeat
								end if
							end if
						end repeat
					end if
				end if
			end repeat
		end if
	end tell
	return aFolder
end getParentFolder
-------------------------------------------------------------------------------
-- getPathByAlbum()
-------------------------------------------------------------------------------
on getPathByAlbum(aAlbum)
	local theAlbumPath
	set theAlbumPath to missing value
	if parent of aAlbum is missing value then
		set theAlbumPath to "/" & name of aAlbum
		return theAlbumPath
	end if
	--
	set albumPath to "/" & name of aAlbum
	tell application id "com.apple.photos"
		local aContainer
		tell me to set aContainer to getParentFolder(aAlbum, 3)
		if aContainer is not missing value then
			set albumPath to "/" & name of aContainer & albumPath
		else
			set aContainer to aAlbum
		end if
		tell me to set aContainer to getParentFolder(aContainer, 2)
		if aContainer is not missing value then
			set albumPath to "/" & name of aContainer & albumPath
		else
			set aContainer to aAlbum
		end if
		tell me to set aContainer to getParentFolder(aContainer, 1)
		if aContainer is not missing value then
			set albumPath to "/" & name of aContainer & albumPath
		end if
	end tell
	--
	if albumPath is equal to "/" & name of aAlbum then
		set theAlbumPath to missing value
	else
		set theAlbumPath to albumPath
	end if
	return theAlbumPath
end getPathByAlbum
-------------------------------------------------------------------------------
-- testImport
-------------------------------------------------------------------------------
on testImport()
	set importAlbum to getAlbumByPath("/Test/Test3/Test4/Yield4", false)
	-- set importAlbum to getAlbumByPath("/Test/Test3/Yield5", false)
	-- set importAlbum to getAlbumByPath("/Test/Yield2", false)
	-- set importAlbum to getAlbumByPath("/Yield0", false)
	-- set importAlbum to getAlbumByPath("/Test/Test3/Test4/Test5/Yield6", false)
	local pFolder
	local pFolderName
	set pFolder to get parent of importAlbum
	set pFolderName to name of pFolder
	set dummy to "x"
end testImport
-------------------------------------------------------------------------------
-- Run the import script
-------------------------------------------------------------------------------
on run argv
	-- testImport()
	-- return
	
	if (argv = me) then
		set argv to {"/private/tmp/at.homebrew.lrphotos/com"}
	end if
	-- Read the directory from the input and define the session file
	set tempFolder to item 1 of argv
	
	set sessionFile to POSIX file (tempFolder & "/session.txt")
	open for access sessionFile
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
			open for access photosFile
			set photosContents to (read photosFile)
			close access photosFile
			
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
	updateSessionFile(sessionFile, session)
end run
