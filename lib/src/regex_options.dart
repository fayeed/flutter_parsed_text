part of flutter_parsed_text;

/// Configuration options for regex pattern matching.
///
/// These options are passed to the [RegExp] constructor when matching patterns.
class RegexOptions {
  /// If `multiLine` is enabled, then `^` and `$` will match the beginning and
  /// end of a _line_, in addition to matching beginning and end of input,
  /// respectively.
  final bool multiLine;

  /// If `caseSensitive` is disabled, then case is ignored during matching.
  final bool caseSensitive;

  /// If `unicode` is enabled, then the pattern is treated as a Unicode
  /// pattern as described by the ECMAScript standard.
  final bool unicode;

  /// If `dotAll` is enabled, then the `.` pattern will match _all_ characters,
  /// including line terminators.
  final bool dotAll;

  /// Creates a RegexOptions object with the specified options.
  ///
  /// All options default to standard regex behavior:
  /// - [multiLine] defaults to `false`
  /// - [caseSensitive] defaults to `true`
  /// - [unicode] defaults to `false`
  /// - [dotAll] defaults to `false`
  const RegexOptions({
    this.multiLine = false,
    this.caseSensitive = true,
    this.unicode = false,
    this.dotAll = false,
  });
}
