part of flutter_parsed_text;

/// Parse text and make them into multiple Flutter Text widgets
class ParsedText extends StatelessWidget {
  /// If non-null, the style to use for the global text.
  ///
  /// It takes a [TextStyle] object as it's property to style all the non links text objects.
  final TextStyle? style;

  /// Takes a list of [MatchText] object.
  ///
  /// This list is used to find patterns in the String and assign onTap [Function] when its
  /// tapped and also to provide custom styling to the linkify text
  final List<MatchText> parse;

  /// Text that is rendered
  ///
  /// Takes a [String]
  final String text;

  /// A text alignment property used to align the the text enclosed
  ///
  /// Uses a [TextAlign] object and default value is [TextAlign.start]
  final TextAlign alignment;

  /// A text alignment property used to align the the text enclosed
  ///
  /// Uses a [TextDirection] object and default value is [TextDirection.start]
  final TextDirection? textDirection;

  /// Whether the text should break at soft line breaks.
  ///
  ///If false, the glyphs in the text will be positioned as if there was unlimited horizontal space.
  final bool softWrap;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// The number of font pixels for each logical pixel.
  ///
  /// For example, if the text scale factor is 1.5, text will be 50% larger than
  /// the specified font size.
  final double textScaleFactor;

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
  /// SelectableText does not support softwrap, overflow, textScaleFactor
  final bool selectable;

  final Function? onTap;

  /// Creates a parsedText widget
  ///
  /// [text] paramtere should not be null and is always required.
  /// If the [style] argument is null, the text will use the style from the
  /// closest enclosing [DefaultTextStyle].
  ParsedText({
    Key? key,
    required this.text,
    this.parse = const <MatchText>[],
    this.style,
    this.alignment = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.maxLines,
    this.onTap,
    this.selectable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Seperate each word and create a new Array
    String newString = text;

    // Parse the whole text and adds "%%%%" before and after the
    // each matched text this will be used to split the text affectively
    parse.forEach((e) {
      if (e.type == ParsedType.EMAIL) {
        RegExp regExp = RegExp(emailPattern, multiLine: true);
        newString = newString.splitMapJoin(regExp,
            onMatch: (m) => "%%%%${m.group(0)}%%%%", onNonMatch: (m) => "$m");
      } else if (e.type == ParsedType.PHONE) {
        RegExp regExp = RegExp(phonePattern);
        newString = newString.splitMapJoin(regExp,
            onMatch: (m) => "%%%%${m.group(0)}%%%%", onNonMatch: (m) => "$m");
      } else if (e.type == ParsedType.URL) {
        RegExp regExp = RegExp(urlPattern);
        newString = newString.splitMapJoin(regExp,
            onMatch: (m) => "%%%%${m.group(0)}%%%%", onNonMatch: (m) => "$m");
      } else if (e.type == ParsedType.CUSTOM) {
        RegExp regExp = RegExp(e.pattern!,
            multiLine: e.regexOptions.multiLine,
            caseSensitive: e.regexOptions.caseSensitive,
            unicode: e.regexOptions.unicode,
            dotAll: e.regexOptions.dotAll);
        newString = newString.splitMapJoin(regExp,
            onMatch: (m) => "%%%%${m.group(0)}%%%%", onNonMatch: (m) => "$m");
      }
    });

    // splits the modified text at "%%%%"
    List<String> splits = newString.split("%%%%");

    // Map over the splits array to get a new Array with its elements as Widgets
    // checks if each word matches either a predefined type of custom defined patterns
    // if a match is found creates a link Text with its function or return a
    // default Text
    List<InlineSpan> widgets = splits.map<InlineSpan>((element) {
      // Default Text object if not pattern is matched
      InlineSpan widget = TextSpan(
        text: "$element",
      );

      // loop over to find patterns
      for (final e in parse) {
        if (e.type == ParsedType.CUSTOM) {
          final String pattern = e.pattern!;
          RegExp customRegExp = RegExp(
            pattern,
            multiLine: e.regexOptions.multiLine,
            caseSensitive: e.regexOptions.caseSensitive,
            unicode: e.regexOptions.unicode,
            dotAll: e.regexOptions.dotAll,
          );

          bool matched = customRegExp.hasMatch(element);

          if (matched) {
            if (e.renderText != null) {
              Map<String, String> result =
                  e.renderText!(str: element, pattern: pattern);

              widget = WidgetSpan(
                child: GestureDetector(
                  onTap: () => e.onTap!(element),
                  onLongPress: () => e.onLongTap!(element),
                  child: Text(
                    "${result['display']}",
                    style: e.style != null ? e.style : style,
                  ),
                ),
              );
            } else if (e.renderWidget != null) {
              widget = WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: GestureDetector(
                  onTap: () => e.onTap!(element),
                  onLongPress: () => e.onLongTap!(element),
                  child: e.renderWidget!(text: element, pattern: e.pattern!),
                ),
              );
            } else {
              widget = WidgetSpan(
                child: GestureDetector(
                  onTap: () => e.onTap!(element),
                  onLongPress: () => e.onLongTap!(element),
                  child: Text(
                    "$element",
                    style: e.style != null ? e.style : style,
                  ),
                ),
              );
            }
            break;
          }
        } else if (e.type == ParsedType.EMAIL) {
          RegExp emailRegExp = RegExp(emailPattern);

          bool matched = emailRegExp.hasMatch(element);

          if (matched) {
            widget = WidgetSpan(
              child: GestureDetector(
                onTap: () => e.onTap!(element),
                onLongPress: () => e.onLongTap!(element),
                child: Text(
                  "$element",
                  style: e.style != null ? e.style : style,
                ),
              ),
            );
            break;
          }
        } else if (e.type == ParsedType.PHONE) {
          RegExp phoneRegExp = RegExp(phonePattern);

          bool matched = phoneRegExp.hasMatch(element);

          if (matched) {
            widget = WidgetSpan(
              child: GestureDetector(
                onTap: () => e.onTap!(element),
                onLongPress: () => e.onLongTap!(element),
                child: Text(
                  "$element",
                  style: e.style != null ? e.style : style,
                ),
              ),
            );
            break;
          }
        } else if (e.type == ParsedType.URL) {
          RegExp urlRegExp = RegExp(urlPattern);

          bool matched = urlRegExp.hasMatch(element);

          if (matched) {
            widget = WidgetSpan(
              child: GestureDetector(
                onTap: () => e.onTap!(element),
                onLongPress: () => e.onLongTap!(element),
                child: Text(
                  "$element",
                  style: e.style != null ? e.style : style,
                ),
              ),
            );
            break;
          }
        }
      }

      return widget;
    }).toList();

    if (selectable) {
      return SelectableText.rich(
        TextSpan(children: <InlineSpan>[...widgets], style: style),
        maxLines: maxLines,
        strutStyle: strutStyle,
        textWidthBasis: textWidthBasis,
        textAlign: alignment,
        textDirection: textDirection,
        onTap: onTap as void Function()?,
      );
    }

    return RichText(
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textAlign: alignment,
      textDirection: textDirection,
      text: TextSpan(children: <InlineSpan>[...widgets], style: style),
    );
  }
}
