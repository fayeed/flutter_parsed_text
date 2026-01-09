part of flutter_parsed_text;

/// Parse text and make them into multiple Flutter Text widgets.
class ParsedText extends StatefulWidget {
  /// If non-null, the style to use for the global text.
  ///
  /// It takes a [TextStyle] object as its property to style all the non-matched text.
  final TextStyle? style;

  /// Takes a list of [MatchText] objects.
  ///
  /// This list is used to find patterns in the String and assign onTap [Function] when it's
  /// tapped and also to provide custom styling to the matched text.
  final List<MatchText> parse;

  /// Text that is rendered.
  ///
  /// Takes a [String].
  final String text;

  /// A text alignment property used to align the text enclosed.
  ///
  /// Uses a [TextAlign] object and default value is [TextAlign.start].
  final TextAlign alignment;

  /// A text direction property used to determine the direction of the text.
  ///
  /// Uses a [TextDirection] object.
  final TextDirection? textDirection;

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was unlimited horizontal space.
  final bool softWrap;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// The font scaling strategy to use when laying out and rendering the text.
  ///
  /// The value usually comes from [MediaQuery.textScalerOf], which provides
  /// the [TextScaler] to use based on the user's platform preferences.
  final TextScaler textScaler;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  final int? maxLines;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.widgets.text.DefaultTextStyle.textWidthBasis}
  final TextWidthBasis textWidthBasis;

  /// Make this text selectable.
  ///
  /// Note: SelectableText does not support softWrap and overflow properties.
  final bool selectable;

  /// onTap function for the whole widget.
  final void Function()? onTap;

  /// Global regex options for pattern matching.
  final RegexOptions regexOptions;

  /// Creates a ParsedText widget.
  ///
  /// [text] parameter should not be null and is always required.
  /// If the [style] argument is null, the text will use the style from the
  /// closest enclosing [DefaultTextStyle].
  const ParsedText({
    Key? key,
    required this.text,
    this.parse = const <MatchText>[],
    this.style,
    this.alignment = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaler = TextScaler.noScaling,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.maxLines,
    this.onTap,
    this.selectable = false,
    this.regexOptions = const RegexOptions(),
  }) : super(key: key);

  @override
  State<ParsedText> createState() => _ParsedTextState();
}

class _ParsedTextState extends State<ParsedText> {
  final List<GestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();
    super.dispose();
  }

  @override
  void didUpdateWidget(ParsedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Clear old recognizers when widget updates
    if (oldWidget.text != widget.text || oldWidget.parse != widget.parse) {
      for (final recognizer in _recognizers) {
        recognizer.dispose();
      }
      _recognizers.clear();
    }
  }

  GestureRecognizer? _createRecognizer({
    void Function()? onTap,
    void Function()? onLongPress,
  }) {
    if (onTap == null && onLongPress == null) {
      return null;
    }

    if (onLongPress != null) {
      final recognizer = LongPressGestureRecognizer()
        ..onLongPress = onLongPress;
      if (onTap != null) {
        // For combined tap and long press, we use MultiTapGestureRecognizer approach
        // but since TextSpan only supports one recognizer, we prioritize long press
        // and handle tap separately via TapGestureRecognizer
      }
      _recognizers.add(recognizer);
      return recognizer;
    }

    final recognizer = TapGestureRecognizer()..onTap = onTap;
    _recognizers.add(recognizer);
    return recognizer;
  }

  @override
  Widget build(BuildContext context) {
    // Clear recognizers on each build to handle dynamic updates
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();

    // Handle empty text case
    if (widget.text.isEmpty) {
      return widget.selectable
          ? SelectableText('', style: widget.style)
          : RichText(
              text: TextSpan(text: '', style: widget.style),
              textScaler: widget.textScaler,
            );
    }

    // Handle empty parse list - just return plain text
    if (widget.parse.isEmpty) {
      return _buildPlainText();
    }

    final Map<String, MatchText> mapping = <String, MatchText>{};

    for (final e in widget.parse) {
      if (e.type == ParsedType.EMAIL) {
        mapping[emailPattern] = e;
      } else if (e.type == ParsedType.PHONE) {
        mapping[phonePattern] = e;
      } else if (e.type == ParsedType.URL) {
        mapping[urlPattern] = e;
      } else if (e.pattern != null && e.pattern!.isNotEmpty) {
        mapping[e.pattern!] = e;
      }
    }

    // If all patterns were invalid/empty, return plain text
    if (mapping.isEmpty) {
      return _buildPlainText();
    }

    final pattern = '(${mapping.keys.join('|')})';
    final List<InlineSpan> spans = [];

    widget.text.splitMapJoin(
      RegExp(
        pattern,
        multiLine: widget.regexOptions.multiLine,
        caseSensitive: widget.regexOptions.caseSensitive,
        dotAll: widget.regexOptions.dotAll,
        unicode: widget.regexOptions.unicode,
      ),
      onMatch: (Match match) {
        final matchText = match[0]!;

        final matchedConfig = mapping[matchText] ??
            mapping[mapping.keys.firstWhere((element) {
              final reg = RegExp(
                element,
                multiLine: widget.regexOptions.multiLine,
                caseSensitive: widget.regexOptions.caseSensitive,
                dotAll: widget.regexOptions.dotAll,
                unicode: widget.regexOptions.unicode,
              );
              return reg.hasMatch(matchText);
            }, orElse: () => '')];

        if (matchedConfig == null) {
          spans.add(TextSpan(text: matchText, style: widget.style));
          return '';
        }

        // Get the actual pattern used (for predefined types, use the constant)
        final actualPattern = matchedConfig.pattern ??
            _getPatternForType(matchedConfig.type) ??
            pattern;

        if (matchedConfig.renderText != null) {
          final result = matchedConfig.renderText!(
            str: matchText,
            pattern: actualPattern,
          );
          final displayText = result['display'] ?? matchText;
          final value = result['value'] ?? matchText;

          spans.add(TextSpan(
            text: displayText,
            style: matchedConfig.style ?? widget.style,
            recognizer: _createRecognizer(
              onTap: matchedConfig.onTap != null
                  ? () => matchedConfig.onTap!(value)
                  : null,
              onLongPress: matchedConfig.onLongPress != null
                  ? () => matchedConfig.onLongPress!(value)
                  : null,
            ),
          ));
        } else if (matchedConfig.renderWidget != null) {
          spans.add(WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: matchedConfig.onTap != null
                  ? () => matchedConfig.onTap!(matchText)
                  : null,
              onLongPress: matchedConfig.onLongPress != null
                  ? () => matchedConfig.onLongPress!(matchText)
                  : null,
              child: matchedConfig.renderWidget!(
                text: matchText,
                pattern: actualPattern,
              ),
            ),
          ));
        } else {
          spans.add(TextSpan(
            text: matchText,
            style: matchedConfig.style ?? widget.style,
            recognizer: _createRecognizer(
              onTap: matchedConfig.onTap != null
                  ? () => matchedConfig.onTap!(matchText)
                  : null,
              onLongPress: matchedConfig.onLongPress != null
                  ? () => matchedConfig.onLongPress!(matchText)
                  : null,
            ),
          ));
        }

        return '';
      },
      onNonMatch: (String text) {
        spans.add(TextSpan(text: text, style: widget.style));
        return '';
      },
    );

    if (widget.selectable) {
      return SelectableText.rich(
        TextSpan(children: spans, style: widget.style),
        maxLines: widget.maxLines,
        strutStyle: widget.strutStyle,
        textWidthBasis: widget.textWidthBasis,
        textAlign: widget.alignment,
        textDirection: widget.textDirection,
        textScaler: widget.textScaler,
        onTap: widget.onTap,
      );
    }

    return RichText(
      softWrap: widget.softWrap,
      overflow: widget.overflow,
      textScaler: widget.textScaler,
      maxLines: widget.maxLines,
      strutStyle: widget.strutStyle,
      textWidthBasis: widget.textWidthBasis,
      textAlign: widget.alignment,
      textDirection: widget.textDirection,
      text: TextSpan(children: spans, style: widget.style),
    );
  }

  Widget _buildPlainText() {
    if (widget.selectable) {
      return SelectableText(
        widget.text,
        style: widget.style,
        maxLines: widget.maxLines,
        strutStyle: widget.strutStyle,
        textWidthBasis: widget.textWidthBasis,
        textAlign: widget.alignment,
        textDirection: widget.textDirection,
        textScaler: widget.textScaler,
        onTap: widget.onTap,
      );
    }
    return RichText(
      softWrap: widget.softWrap,
      overflow: widget.overflow,
      textScaler: widget.textScaler,
      maxLines: widget.maxLines,
      strutStyle: widget.strutStyle,
      textWidthBasis: widget.textWidthBasis,
      textAlign: widget.alignment,
      textDirection: widget.textDirection,
      text: TextSpan(text: widget.text, style: widget.style),
    );
  }

  String? _getPatternForType(ParsedType type) {
    switch (type) {
      case ParsedType.EMAIL:
        return emailPattern;
      case ParsedType.PHONE:
        return phonePattern;
      case ParsedType.URL:
        return urlPattern;
      case ParsedType.CUSTOM:
        return null;
    }
  }
}
