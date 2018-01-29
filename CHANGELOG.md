# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and
this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2018-01-29

- Add new `MegaphoneMessageDelayWarning` exception for transient errors
- Support`buffer_overflow` callbacks
- Update Fluentd Gem from 0.7.1 to 0.7.2
- Do not dump entire payload into exceptions; just stream/topic IDs

## [1.0.1] - 2017-09-18

### Fixed

- Output format to match the [stream-schema v2][stream-schema-v2].

  [stream-schema-v2]: https://github.com/redbubble/megaphone-event-type-registry/blob/master/stream-schema-2.0.0.json

## [1.0.0] - 2017-08-18

### Changed

- The `Megaphone::Client` API is now stable!

## [0.3.0] - 2017-08-17

### Changed

- Signature of the `Megaphone::Client` constructor : now takes a host and a port as optional arguments and doesn't take the logger as an argument anymore.

## [0.2.0] - 2017-08-14

### Changed

- Signature of the `publish!` method: now takes a schema and a partition key as arguments

## [0.1.2] - 2017-08-04

### Fixed

- Removing unnecessary files from gemspec

## [0.1.1] - 2017-08-03

### Fixed

- Including files in gemspec

## 0.1.0 - 2017-08-03 [YANKED]

### Added

- Initial implementation of the `Megaphone::Client.publish!` method

  [1.0.1]: https://github.com/redbubble/megaphone-client-ruby/compare/v1.0.1...v1.0.1
  [1.0.0]: https://github.com/redbubble/megaphone-client-ruby/compare/v0.3.0...v1.0.0
  [0.3.0]: https://github.com/redbubble/megaphone-client-ruby/compare/v0.2.0...v0.3.0
  [0.2.0]: https://github.com/redbubble/megaphone-client-ruby/compare/v0.1.2...v0.2.0
  [0.1.2]: https://github.com/redbubble/megaphone-client-ruby/compare/v0.1.1...v0.1.2
  [0.1.2]: https://github.com/redbubble/megaphone-client-ruby/compare/v0.1.1...v0.1.2
  [0.1.1]: https://github.com/redbubble/megaphone-client-ruby/compare/v0.1.0...v0.1.1
