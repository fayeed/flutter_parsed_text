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
