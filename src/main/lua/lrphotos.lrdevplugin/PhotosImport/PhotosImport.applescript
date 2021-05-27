global importAlbumName, trashAlbumName


-- Extract the album name from the session file
on extractAlbumName(sessionContents)
	set albumName to ""
	set allLines to every paragraph of sessionContents
	repeat with aLine in allLines
		set equalSignOffset to (offset of "=" in aLine)
		if equalSignOffset > 0 then
			set var to text 1 thru (equalSignOffset - 1) of aLine
			if var = "album_name" then
				set albumName to text ((offset of "=" in aLine) + 1) thru -1 of aLine
			end if
		end if
	end repeat
	return albumName
end extractAlbumName

--
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

-- Extract photos from the photos file
on extractPhotos(photosContents)
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
end extractPhotos


-- Import exported photos in a new iPhoto album if needed
on import(photos, albumName)
	set AppleScript's text item delimiters to ":"
	
	tell application id "com.apple.photos"
		set importedPhotos to {}
		
		-- create trashAlbum
		if exists album trashAlbumName then
			set trashAlbum to album trashAlbumName
		else
			set trashAlbum to make new album named trashAlbumName
		end if
		
		-- create importAlbum
		if exists album importAlbumName then
			set importAlbum to album importAlbumName
		else
			set importAlbum to make new album named importAlbumName
		end if
		log importAlbum
		repeat with thePhotoDescriptor in photos
			-- the file path
			set thePhotoFile to text item 1 of thePhotoDescriptor
			-- the LR id. Not used here, but necessary for the way back to LR
			set lrId to text item 2 of thePhotoDescriptor
			-- used as keyword
			set lrCat to text item 3 of thePhotoDescriptor
			-- if exists a Photos id, it is an update.
			set isUpdate to false
			try
				set photosId to text item 4 of thePhotoDescriptor
				set isUpdate to true
			end try
			
			set previousAlbumNames to {}
			set mediaItems to {}
			
			-- if photosId is set, the LR photo was imported before and this should be moved to trashAlbum
			if isUpdate is true then
				set previousPhotos to (every media item whose id is equal to photosId)
				if (count of previousPhotos) is greater than 0 then
					set previousAlbumNames to name of (albums whose id of media items contains photosId)
					add previousPhotos to album trashAlbumName
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
			--
			-- now we import the LR photo
			log "The file: " & thePhotoFile
			if isUpdate is true then
				-- on update, the standard album must me ignored. 
				-- later it will  added to the albums of the previous photo version
				set newPhotos to import {thePhotoFile} with skip check duplicates
			else
				-- if new, it goes into the standard album
				set newPhotos to import {thePhotoFile} into container importAlbumName with skip check duplicates
			end if
			--
			-- put it into the previous albums
			if isUpdate is true then
				repeat with albumName in previousAlbumNames
					add newPhotos to album albumName
				end repeat
			end if
			--  
			-- Update metadata
			if (count of newPhotos) is greater than 0 then
				-- set the name of the LR catalog file
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
		end repeat
		delay 2
	end tell
	set AppleScript's text item delimiters to " "
	return importedPhotos
end import


-- Update status flag in session file to tell Lightroom we are finished here
on updateSessionFile(sessionFile, albumName)
	open for access sessionFile with write permission
	set eof of sessionFile to 0
	write "album_name=" & albumName & "
export_done=true" to sessionFile
	close access sessionFile
end updateSessionFile
--
on updatePhotosFile(photosFile, importedPhotos)
	open for access photosFile with write permission
	set eof of photosFile to 0
	repeat with thePhotoFile in importedPhotos
		log thePhotoFile
		write thePhotoFile & "
" to photosFile
	end repeat
	close access photosFile
end updatePhotosFile
--

-- Run the import script
on run argv
	set importAlbumName to "Import (LRPhotos)"
	set trashAlbumName to "Trash (LRPhotos)"
	
	if (argv = me) then
		set argv to {"/Users/dieterstockhausen/Pictures/LRPhotos"}
	end if
	-- Read the directory from the input and define the session file
	set tempFolder to item 1 of argv
	set sessionFile to tempFolder & "/session.txt"
	-- Scan the session file for an album name
	open for access sessionFile
	set sessionContents to (read sessionFile)
	close access sessionFile
	
	set albumName to extractAlbumName(sessionContents)
	if albumName is not equal to "" then set importAlbumName to albumName
	
	
	set photosFile to tempFolder & "/photos.txt"
	open for access photosFile
	set photosContents to (read photosFile)
	close access photosFile
	
	set photos to extractPhotos(photosContents)
	
	set importedPhotos to import(photos, albumName)
	updatePhotosFile(photosFile, importedPhotos)
	
	updateSessionFile(sessionFile, albumName)
end run
