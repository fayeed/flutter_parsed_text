part of flutter_parsed_text;

/// Email Regex - A predefined type for handling email matching
const emailPattern =
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";

/// URL Regex - A predefined type for handling URL matching
const urlPattern =
    r"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$";

/// Phone Regex - A predefined type for handling phone matching
const phonePattern = r"^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$";

/// Parse text and make them into multiple Flutter Text widgets
class ParsedText extends StatelessWidget {
  /// If non-null, the style to use for the global text.
  ///
  /// It takes a [TextStyle] object as it's property to style all the non links text objects.
  final TextStyle style;

  /// Takes a list of [MatchText] object.
  ///
  /// This list is used to find patterns in the String and assign onTap [Function] when its
  /// tapped and also to provide custom styling to the linkify text
  final List<MatchText> parse;

  /// Text that is rendered
  ///
  /// Takes a [String]
  final String text;

  /// A wordspacing paramter to adjust spacing between each words
  ///
  /// It takes a [double] and default value is [5.0]
  final double wordSpacing;

  /// A text alignment property used to align the the text enclosed
  ///
  /// Uses a [WrapAlignment] object and default value is [WrapAlignment.start]
  final WrapAlignment alignment;

  /// Creates a parsedText widget
  ///
  /// [text] paramtere should not be null and is always required.
  /// If the [style] argument is null, the text will use the style from the
  /// closest enclosing [DefaultTextStyle].
  ParsedText({
    @required this.text,
    this.parse,
    this.style,
    this.wordSpacing = 5.0,
    this.alignment = WrapAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    // Seperate each word and create a new Array
    List<String> splits = text.split(" ");

    // Map over the splits array to get a new Array with its elements as Widgets
    // checks if each word matches either a predefined type of custom defined patterns
    // if a match is found creates a link Text with its function or return a
    // default Text
    List<Widget> widgets = splits.map<Widget>((element) {
      // Default Text object if not pattern is matched
      Widget widget = Text(
        element,
        style: style,
      );

      // loop over to find patterns
      parse.forEach((e) {
        if (e.type == CUSTOM) {
          RegExp customRegExp = RegExp(e.pattern);

          bool matched = customRegExp.hasMatch(element);

          if (matched) {
            if (e.renderText != null) {
              Map<String, String> result =
                  e.renderText(str: element, pattern: e.pattern);

              widget = LinkItem(
                style: e.style != null ? e.style : style,
                text: result['display'],
                onTap: () => e.onTap(result['value']),
              );
            } else {
              widget = LinkItem(
                style: e.style != null ? e.style : style,
                text: element,
                onTap: () => e.onTap(element),
              );
            }
          }
        } else if (e.type == EMAIL) {
          RegExp emailRegExp = RegExp(emailPattern);

          bool matched = emailRegExp.hasMatch(element);

          if (matched) {
            widget = LinkItem(
              style: e.style != null ? e.style : style,
              text: element,
              onTap: () => e.onTap(element),
            );
          }
        } else if (e.type == PHONE) {
          RegExp phoneRegExp = RegExp(phonePattern);

          bool matched = phoneRegExp.hasMatch(element);

          if (matched) {
            widget = LinkItem(
              style: e.style != null ? e.style : style,
              text: element,
              onTap: () => e.onTap(element),
            );
          }
        } else if (e.type == URL) {
          RegExp urlRegExp = RegExp(urlPattern);

          bool matched = urlRegExp.hasMatch(element);

          if (matched) {
            widget = LinkItem(
              style: e.style != null ? e.style : style,
              text: element,
              onTap: () => e.onTap(element),
            );
          }
        }
      });
      // Add padding to the right to emulate a word spacing property
      return Padding(
        padding: EdgeInsets.only(right: wordSpacing),
        child: widget,
      );
    }).toList();

    // Wrapped with a wrap widget to emulate wrap Text's wrap property
    return Wrap(
      alignment: alignment,
      children: <Widget>[...widgets],
    );
  }
}

/// A LinkItem widget which is just a GuestureDetector wrapped around Text widget
class LinkItem extends StatelessWidget {
  /// A callback funtion that will be called when a item is tapped
  final Function onTap;

  /// A custom style to be applied to the matched text
  ///
  /// It takes a [TextStyle] object
  final TextStyle style;

  /// A string text ideally a word
  final String text;

  /// Creates a LinkItem widget
  ///
  /// [text] paramtere should not be null and is always required.
  /// If the [style] argument is null, the text will use the style from the
  /// global Text.
  const LinkItem({this.onTap, this.style, @required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
