part of flutter_parsed_text;

/// Predefined types for common text patterns.
enum ParsedType { EMAIL, PHONE, URL, CUSTOM }

/// A MatchText class which provides a structure for [ParsedText] to handle
/// pattern matching and also to provide custom [Function] and custom [TextStyle].
class MatchText {
  /// Used to enforce predefined regex to match from.
  final ParsedType type;

  /// If no [type] property is explicitly defined then this property must be
  /// non-null and takes a regex string.
  final String? pattern;

  /// Takes a custom style of [TextStyle] for the matched text widget.
  final TextStyle? style;

  /// A custom callback to handle tap events.
  ///
  /// The callback receives the matched text as a parameter.
  final void Function(String)? onTap;

  /// A custom callback to handle long press events.
  ///
  /// The callback receives the matched text as a parameter.
  final void Function(String)? onLongPress;

  /// A callback function that takes two parameters: String & pattern.
  ///
  /// @param str - the word that is being matched
  /// @param pattern - pattern passed to the MatchText class
  ///
  /// Example: Your str is 'Mention [@michel:5455345]' where 5455345 is ID of this user
  /// and @michel the value to display on interface.
  /// Your pattern for ID & username extraction: `/\[(@[^:]+):([^\]]+)\]/`i
  /// Displayed text will be: Mention `@michel`
  ///
  /// Return a Map with 'display' key for the text to show, and optionally
  /// a 'value' key for the value to pass to onTap (defaults to matched text).
  final Map<String, String> Function({
    required String str,
    required String pattern,
  })? renderText;

  /// A callback function that takes the [text] that matches the [pattern] and returns
  /// the [Widget] to be displayed inside a [WidgetSpan].
  final Widget Function({
    required String text,
    required String pattern,
  })? renderWidget;

  /// Creates a MatchText object.
  const MatchText({
    this.type = ParsedType.CUSTOM,
    this.pattern,
    this.style,
    this.onTap,
    this.onLongPress,
    this.renderText,
    this.renderWidget,
  });
}
