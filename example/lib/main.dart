import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:url_launcher/url_launcher.dart';

main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'example_app',
      home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 40.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ParsedText(
              selectable: true,
              alignment: TextAlign.start,
              // regexOptions: RegexOptions(
              //   caseSensitive: false,
              //   multiLine: true,
              //   dotAll: false,
              //   unicode: false,
              // ),
              text:
                  "[@michael:51515151] Hello  --- spoiler ---\n\n spoiler content \n--- spoiler ---\n  https://172.0.0.1 london this is https://apps.apple.com/id/app/facebook/id284882215  an example of the ParsedText, links like http://www.google.com or http://www.facebook.com are clickable and phone number 444-555-6666 can call too. But you can also do more with this package, for example Bob will change style and David too.\nAlso a US number example +1-(800)-831-1117. foo@gmail.com And the magic number is 42! #flutter #flutterdev",
              parse: <MatchText>[
                MatchText(
                    type: ParsedType.EMAIL,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 24,
                    ),
                    onTap: (url) {
                      _launchUrl(url);
                    }),
                MatchText(
                    type: ParsedType.URL,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 24,
                    ),
                    onTap: (url) {
                      _launchUrl(url);
                    }),
                MatchText(
                    type: ParsedType.PHONE,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 24,
                    ),
                    onTap: (url) {
                      _launchUrl(url);
                    }),
                MatchText(
                  type: ParsedType.CUSTOM,
                  pattern:
                      r"^(?:http|https):\/\/[\w\-_]+(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)",
                  style: const TextStyle(color: Colors.lime),
                  onTap: (url) => print(url),
                ),
                MatchText(
                    type: ParsedType.CUSTOM,
                    pattern:
                        "(---( )?(`)?spoiler(`)?( )?---)\n\n(.*?)\n( )?(---( )?(`)?spoiler(`)?( )?---)",
                    style: const TextStyle(
                      color: Colors.purple,
                      fontSize: 50,
                    ),
                    onTap: (url) {
                      _launchUrl(url);
                    }),
                MatchText(
                  pattern: r"\[(@[^:]+):([^\]]+)\]",
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 24,
                  ),
                  renderText: ({required pattern, required str}) {
                    RegExp customRegExp = RegExp(r"\[(@[^:]+):([^\]]+)\]");
                    Match match = customRegExp.firstMatch(str)!;

                    print('test test: ${match[1]}');
                    // return Container(
                    //   padding: EdgeInsets.all(5.0),
                    //   color: Colors.amber,
                    //   child: Text(match[1]!),
                    // );
                    //
                    return {'display': match[1]!};
                  },
                  onTap: (url) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        RegExp customRegExp = RegExp(r"\[(@[^:]+):([^\]]+)\]");
                        Match match = customRegExp.firstMatch(url)!;
                        // return object of type Dialog
                        return AlertDialog(
                          title: const Text("Mentions clicked"),
                          content: Text("${match.group(1)!} clicked."),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            FilledButton(
                              child: const Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  // onLongTap: (url) {
                  //   print('long press');
                  // },
                ),
                MatchText(
                  pattern: r"\B#+([\w]+)\b",
                  style: const TextStyle(
                    color: Colors.pink,
                    fontSize: 24,
                  ),
                  onTap: (url) async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          title: const Text("Hashtag clicked"),
                          content: Text("$url clicked."),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            FilledButton(
                              child: const Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  // onLongTap: (url) {
                  //   print('long press');
                  // },
                ),
                MatchText(
                    pattern: r"lon",
                    style: const TextStyle(
                      color: Colors.pink,
                      fontSize: 24,
                    ),
                    onTap: (url) async {})
              ],
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }

  _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
