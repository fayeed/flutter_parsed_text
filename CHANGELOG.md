## [3.0.0]

### Breaking Changes

- **Dart SDK**: Now requires Dart 3.0.0 or higher
- **Flutter SDK**: Now requires Flutter 3.10.0 or higher
- `textScaleFactor` parameter renamed to `textScaler` (use `TextScaler.linear(factor)` for migration)
- `onTap` parameter type changed from `Function?` to `void Function()?` for type safety
- `ParsedText` is now a `StatefulWidget` (for proper gesture recognizer disposal)
- `MatchText` class is now immutable (all fields are `final`)

### New Features

- Added `onLongPress` callback support for `MatchText`
- Added `textScaler` parameter to `SelectableText` variants
- Added `contextMenuBuilder` parameter for custom context menus when text is selectable (fixes [#32](https://github.com/fayeed/flutter_parsed_text/issues/32))
- Added `selectionControls` parameter for custom selection handles
- Added `onSelectionChanged` callback for selection change events

### Bug Fixes

- Fixed URL regex pattern to properly handle URLs with commas (fixes [#19](https://github.com/fayeed/flutter_parsed_text/issues/19))
- Fixed malformed URL regex that was treating `http(s)?` as a character class
- Improved phone number regex to be more precise and avoid false positives
- Updated email regex to support longer TLDs (up to 63 characters)
- Fixed variable shadowing bug that could cause incorrect pattern matching
- Fixed null safety issues where `onTap` was force-unwrapped causing crashes
- Fixed `renderWidget` pattern access for predefined types (EMAIL, PHONE, URL)
- Fixed memory leak from undisposed `TapGestureRecognizer` instances
- Fixed crash when using empty parse list
- Fixed crash when using empty or null patterns with CUSTOM type
- Properly handle empty text input

### Improvements

- Added `flutter_lints` for static analysis
- Improved documentation across all classes
- Added comprehensive documentation for `RegexOptions` with examples for multiline matching (relates to [#11](https://github.com/fayeed/flutter_parsed_text/issues/11))
- Updated example app to properly demonstrate multiline spoiler pattern with `dotAll: true`
- Code cleanup and modernization for Dart 3.x

## [2.2.1]

- Fixes the issue where having an empty list of parse (MatchText) or not being able to find the mapping for the pattern lead the widget to crash.

## [2.2.0]

- Removed regexOptions property from MatchText and now comes with a global regexOptions property for ParsedText Widget.
- Changed the internals of the ParsedText widget, it now works similar to [flutter_mentions](https://github.com/fayeed/flutter_mentions)
- This also fixes issue [#11](https://github.com/fayeed/flutter_parsed_text/issues/11)

## [2.1.1]

- Add dash to the ParsedType.URL match

## [2.1.0]

- Added support for Inline widgets. Thanks to - [@angelosilvestre](https://github.com/angelosilvestre)

## [2.0.0]

- Migrates to dart null-safety. Thanks to - [@josh-burton](https://github.com/josh-burton)

## [1.2.5]

- Fixed an issue where not passing `onTap` for MatchText would result in an error.

## [1.2.4]

- Add option to make text selectable

- Add onTap callback

## [1.2.3]

- ParsedType enum added and fixed a issue where a space was added after the parsed text.

## [1.2.2]

- Regex Options added as parameter

## [1.2.1]

- Empty List as default value for parse

## [1.2.0]

- Key added & In build types inproved & Changed how text parsing works

## [1.1.2]

- README.md updated

## [1.1.1]

- README.md updated

## [1.1.0]

- Replace Text Widget with RichText Widget

## [1.0.0]

- Initial Release
