part of flutter_parsed_text;

/// Configuration options for regex pattern matching.
///
/// These options are passed to the [RegExp] constructor when matching patterns.
///
/// ## Common Use Cases
///
/// ### Matching across multiple lines
/// If your pattern needs to match text that spans multiple lines (e.g., spoiler
/// blocks, code blocks), you should enable [dotAll]:
///
/// ```dart
/// ParsedText(
///   text: '--- spoiler ---\nHidden content\n--- spoiler ---',
///   regexOptions: RegexOptions(dotAll: true),
///   parse: [
///     MatchText(
///       pattern: r'--- spoiler ---.*?--- spoiler ---',
///       style: TextStyle(color: Colors.grey),
///     ),
///   ],
/// )
/// ```
///
/// ### Case-insensitive matching
/// For patterns that should ignore case:
///
/// ```dart
/// ParsedText(
///   text: 'Hello WORLD hello World',
///   regexOptions: RegexOptions(caseSensitive: false),
///   parse: [
///     MatchText(
///       pattern: r'hello',
///       style: TextStyle(fontWeight: FontWeight.bold),
///     ),
///   ],
/// )
/// ```
class RegexOptions {
  /// If `multiLine` is enabled, then `^` and `$` will match the beginning and
  /// end of a _line_, in addition to matching beginning and end of input,
  /// respectively.
  ///
  /// Use this when your patterns use `^` or `$` and you want them to match
  /// at line boundaries within the text, not just at the start/end of the
  /// entire string.
  final bool multiLine;

  /// If `caseSensitive` is disabled, then case is ignored during matching.
  ///
  /// Defaults to `true` (case-sensitive matching).
  final bool caseSensitive;

  /// If `unicode` is enabled, then the pattern is treated as a Unicode
  /// pattern as described by the ECMAScript standard.
  ///
  /// This affects how character classes like `\w`, `\d`, and `\s` behave
  /// with Unicode characters.
  final bool unicode;

  /// If `dotAll` is enabled, then the `.` pattern will match _all_ characters,
  /// including line terminators (`\n`, `\r`).
  ///
  /// **Important:** If your pattern uses `.*` or `.+` and needs to match
  /// across newlines (e.g., multiline spoiler blocks, code blocks), you
  /// must set this to `true`.
  ///
  /// Example patterns that require `dotAll: true`:
  /// - `r'--- spoiler ---.*?--- spoiler ---'` (multiline spoiler)
  /// - `r'\`\`\`.*?\`\`\`'` (code blocks)
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
