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

## [1.0.2.0] - 2023-11-19

### Added

* Add root folder property
* Add queue for import jobs.

### Changed

### Fixed

* Fixed unicode issue with album names
* Fixed update of albums which are in folders.
