# LRPhotos

---
LRPhotos is a Lightroom Classic publishing service for Apple's Photos app.
## Features

---
* Publishing photos to Photos.app
* Tagging photos in Photos.app
* Store Photos.app IDs in Lightroom

## Requirements

---
* MacOS 10.10 (Yosemite) or later.
* Windows is not supported.

## Installation

---

1. Download the zip archive from [GitHub](https://github.com/sto3014/LRPhotos/blob/main/target/LRPhotos2.1.0.1_mac.zip).
2. Extract the archive in the download folder
3. Copy plug-in, applescript files and automator workflow into ~/Library  
   Open a terminal window, change to Downloads/LRPhotos and execute install.sh:
   ```
   -> ~ cd Downloads/LRPhotos
   -> ./install.sh 
    ```
   Install.sh copies the plug-in, the applescript files and the automator workflow into:
   * ~/Library/Application Support/Adobe/Lightroom/Modules/LRPhotos.lrplugin
   * ~/Library/Script Libraries
     * hbPhotosUtilities.scptd
     * hbMacRomanUtilities.scptd
     * hbStringUtilities.scptd
     * hbPhotosServices.scptd
   * ~/Library/Services
       * hbPhotosDisplayID.workflow
4. Restart Lightroom

Adobe Lightroom Classic needs to access System Events using Apple Script. When you access the Photos app for the
first time, the system will ask for permission.

## Usage

---
### Publishing
The publish process…
* imports photos into Photos.app
    * the file name of the photo will be different from the file name in Lightroom.
        * The name is set to the photo ID in Lightroom. This ID is also displayed in the Lightroom metadata.
        * The suffix reflects the format which is used during publishing. The format is also displayed in the Lightroom
          metadata. For export data in "original" format, the format value is original.
* sets keywords in Photos
    * lr:&lt;name of the Lightroom catalog file>
    * album:&lt;name of collection>
* saves "Photos app" metadata in Lightroom
    * Lightroom catalog: The name of lightroom catalog
    * Lightroom ID: The internal Lightroom id
  * Format: The format of the Photos file
    * Photos UUID: The unique Photos ID

When creating a new publishing service, there are three predefined options which are not default by Adobe:
* Quality for JPEGs is 85% not 60%
* Person info will NOT be removed from metadata
* Location info will NOT be removed from metadata

Remarks: If you don't export videos as original, the create-date of the video will be set to the current date.

Of course, you may change these settings for your service definition.

### Re-Publishing
The re-publishing process…
* puts re-published photos into the same albums as their predecessors.
* puts tag __lr:out-of-date__ on the predecessor
* removes out-of-date photos if collection configuration __Keep out of date photos in albums__ is un-checked.

### Remove photos from publishing service

* Removes the photo from the Photos album.
* Set tag __lr:no-longer-published__ to the current media item in Photos if it is no longer used in any album
* Set back the Photos metadata in Lightroom, if the photo is no longer used in any album.

### Deleting collections

Deleting collections and removing photos from the Photos app is currently not supported.

### Configuration
The __Use Album__ configuration in the publishing service setup defines the name of the album where photos are imported in.
The first option allows you to use a single album for all collections in a service. The second option uses the name
of the collection as the album name. The album name includes the name of the Photos.app album as well as the folders.
Examples:
* /Holidays in Spain  
  The album __Holidays in Spain__ will be created directly under __My Albums__
* /2021/Holidays in Spain  
The album  __Holidays in Spain__ will be created in the folder __2021__  
  
Remarks: As the slash is used as directory separator you can not use it for a name of an album.

The __Ignore Albums by Regex__ is used to define albums which are ignored during republishing. During re-publishing, 
the updated photos go into all albums where their predecessors are in. For technical reason,
smart albums must be explicitly excluded. This can be done by a naming convention.  
For instance, the default regex expression
__^!|!$__ excludes all albums which have an exclamation mark at the beginning or at the end of their names.

The __Root Folder for Albums__ is used to define a global folder for all albums in this service. 

The checkbox __Keep out of date photos in albums__ decides if a out-of-date photo is removed from the album.
Remarks: In Applescript it is not possible to remove media items from an album therefor, the album is deleted an
recreated.

## Use Cases

---
The applescript interface for Photos.app is restricted:
* It does not support deleting of photos
* It does not allow put photos into shared albums.
* It is not possible to remove media items from an album. Therefor, the album is deleted an
  recreated if __Keep out of date photos in albums__ is unchecked.

### Update albums

You can delete "old" photos manually after a re-publish.
Therefore, a smart album helps which filters by lr:out-of-date tag and may be by lr:<catalog name> as well.

### Update smart albums
If you are using shared albums, you must manually add the updated photos into these albums. Therefore, a second 
smart album is helpful which filters by the date, when photos were added to Photos.app.

## Maintenance

Three menu action under Library/Plug-In Extras

* Reset Photos app Attributes
* Search extra Photos in Photos app
* Search missing Photos in Photos app

### Reset Photos App Attributes

This action deletes the 4 metadata values on the selected photos. The action may be helpful if you want to delete a lot
of published photos manually and you do not want to use the normal removal process.

### Search extra Photos in Photos App

This action searches for Photos app media items that still have a lr:catalog-name keyword, but they are no longer
published
in Lightroom. This happens, when you delete a published collection, or when the publish process runs into a timeout (see
[Known Issues](#known-issues))
The action adds the additional photos found to the album Photos /Lightroom/Extra Photos.
You do not need to select any photos for this action. All photos will be included that have the Photos UUID metadata
set.

### Search missing Photos in Photos App

This action searches for published photos in Lightroom for which no photo can be found in the Photos app. Missing photos
occur when published photos were deleted manually in the Photos app. The action adds the missing photos in the
Lightroom collection /Photos app/Missing in Photos.
The search will be only done for the selected photos (unpublished photos will be ignored).

## Known issues

* When adding a lot of photos, or when you update a large album, Photos displays a modal dialog, to inform you that many
  photos were added. Since the Photos app window may not be in the foreground, you miss this dialog and after a timeout the
  publish action fails.
.
## Acknowledgements

--
Special thanks to [Simon Schoeters](https://www.suffix.be/blog/lightroom-iphoto-export/). His export provider plug-in was
the base for LRPhotos.
