# LRPhotos

# Features
Lightroom Classic publish service for Apple's Photos app.
* Publishing photos to Photos.app
* Tag photos in Photos.app
* Store photo IDs in Lightroom

## Requirements
* MacOS 10.10 (Yosemite) or later.
* Windows is not supported.

## Installation
* Download the zip archive from [GitHub](https://github.com/sto3014/LRPhotos/tree/main/target).
* Extract the archive into your home directory.
* Restart Lightroom

## Usage
### Publishing
The publish process
* Imports photos to Photos.app
* Set the tag "LR:<name of lr catalog>"
* Writes ths Photos.app Ids back to Lightroom into metadata Photos ID

### Re-Publishing
The re-publishing process
* A re-published photo is put to the same albums as its predecessor.
* The predecessor get the tag "LR:out-of-date"

### Remove photos from publishing service
The Photos ID is set back, if you remove a photo from the service

### Configuration
The __Use Album__ configuration in the publishing service setup defines the target album where photos are imported in.
It allows you to use not only the album name but also its path. Example:
* Lightroom/Import

The __Ignore Albums by Regex__ is used to define albums which are ignored during republishing.  
During re-publishing, the updated photos go into all albums where their predecessors are in. For technical reason,
smart albums must be explicitly excluded. This can be done by a naming convention. The default regex expression
__^!|!$__ exludes all albums which have an exclamation mark at the beginning or at the end of their names.

## Use Cases
The applescript interface for Photos.app is restricted:
* It does not support deleting of photos
* It does not allow put photos into shared albums.

I.e., you must delete "old" photos manually after a re-publish.
Therefore, a smart album helps which filters by LR:out-of-date tag and may be by LR:<catalog name> as well.

If you are using shared albums, you must additionally add the updated photos into these albums. Therefore, a second 
smart album is helpful which filters by the date, when photos were added to Photos.app


# Acknowledgements
Special thanks to [Simon Schoeters](https://www.suffix.be/blog/lightroom-iphoto-export/). His export provider plug-in was
the base for LRPhotos.
