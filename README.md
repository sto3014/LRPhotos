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

1. Download the zip archive from [GitHub](https://github.com/sto3014/LRPhotos/blob/main/target/LRPhotos2.0.0.0_mac.zip).
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
     * hbPhotosDisplayUUID.workflow
4. Restart Lightroom

## Usage

---
### Publishing
The publish process…
* imports photos into Photos.app
* sets tag
    * LR:&lt;name of LR catalog file>
    * album:&lt;name of collection>
* saves "Photos App" metadata in Lightroom
    * Lightroom catalog: The name of lightroom catalog
    * Lightroom ID: The internal Lightroom id
    * Format: The format (i.e. extension of the Photos file)
    * Photos UUID: The unique Photos ID

When creating a new publishing service, there are three predefined options which are not default by Adobe:
* Quality for JPEGs is 85% not 60%
* Person info will NOT be removed from metadata
* Location info will NOT be removed from metadata

Remarks: If you don't export videos as original the create date of the video will be set to the current date.

Of course, you may change these settings for your service definition.

### Re-Publishing
The re-publishing process…
* puts re-published photos into the same albums as their predecessors.
* puts tag __LR:out-of-date__ on the predecessor
* removes out-of-date photos if collection configuration __Keep out of date photos in albums__ is un-checked.

### Remove photos from publishing service

* Removes the photo from the Photos album.
* Set tag __LR:no-longer-published__ to the current media item in Photos if it is no longer used in any album
* Set back the Photos ID in Lightroom, if the photo is no longer used in any album.

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
You must delete "old" photos manually after a re-publish.
Therefore, a smart album helps which filters by LR:out-of-date tag and may be by LR:<catalog name> as well.

### Update smart albums
If you are using shared albums, you must manually add the updated photos into these albums. Therefore, a second 
smart album is helpful which filters by the date, when photos were added to Photos.app.


## Acknowledgements

--
Special thanks to [Simon Schoeters](https://www.suffix.be/blog/lightroom-iphoto-export/). His export provider plug-in was
the base for LRPhotos.
