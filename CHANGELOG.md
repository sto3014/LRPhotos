# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0.0] - 2021-06-06

Initial version

## [1.0.0.1] - 2021-12-30

Only the documentation has changed. No need to update.

### Added

### Changed

### Fixed

* Fix installation chapter in README.md

## [1.0.0.2] - 2022-01-14

### Added

### Changed

### Fixed

* If the ``Use one album for all collections`` is checked but no value is provided you get
  an unreasonable error message.

## [1.0.1.0] - 2023-11-17

### Added

* Add keyword album:"name of the album" to the imported photo.

### Changed

### Fixed

* Videos are always set as being published. This is a workaround, because even if the video is successfully rendered the
  rendition is marked as skipped.

## [2.0.0.0] - 2023-12-28

### Added

* Added root folder property
* Added queue for import jobs.
* Added service for displaying photo UUID in Photos.
* Added Lightroom menu action for displaying published photos in Photos.
* Added Lightroom menu action for displaying published collections in Photos.
* Added "Photos App" metadata

### Changed

### Fixed

* Fixed unicode issue with album names.
* Fixed update of albums which are in folders.

## [2.0.0.1] - 2024-01-31

### Fixed

* Fix reset issue for photosId metadata field.

## [2.0.0.2] - 2024-02-01

### Changed

* Exchange- and queue-folder are moved to ~/Library/Caches.

## [2.0.0.3] - 2024-02-05

### Changed

* Refactored AppleScript scripts

## [2.1.0.0] - 2024-02-18

### Added

* An action has need added that searches for published photos in Lightroom which do not have a corresponded Photos
  photo.
* An action has been added that searches for additional photos in Photos that appear to have been published.
* Added action to clear Photos metadata

### Fixed

* Fixed issue when running multiple jobs.
* Fixed issue when removing photos from albums.
* Fixed issue with albums which contains photos without any keywords.

### Changed

* Photos of export format original get "original" as format (metadata).
* The format is now the export format, not the file extension.
* Metadata is no longer read-only

## [2.1.0.1] - 2024-02-22

### Fixed

* Fixed issue that occurs when publish process must start Photos app and thereby, import or photo fails.

### Changed

* Remove version from install script

## [2.1.0.2] - 2024-02-24

### Fixed

* Fixed issue that occurs when removing a photo if the UUID of Photos is not present in Photos.

## [2.1.0.3]

### Changed

* Move Applescript handler to script library
* Add logging to script library

## [2.1.1.0]

### Added

* Add preference Truncate Version. If set to true the version in the catalog name will be truncated.

## [2.1.2.0]

### Added

* Add collection configuration "Keep no longer published photos in albums". If set to false (default value) photos will
  be removed from Photos app if they are removed from collection, otherwise photos must be removed from album manually.

## [2.1.3.0]

### Changed

* Changed standard folder name on Photos app from /Lightroom to /LR Photos

## [2.2.0.0]

### Added

* Add action that adds source photos into album /LR Photos/Source Photos
