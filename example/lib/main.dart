import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:url_launcher/url_launcher.dart' show canLaunch, launch;

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'example_app',
      home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
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
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 24,
                    ),
                    onTap: (url) {
                      launch("mailto:" + url);
                    }),
                MatchText(
                    type: ParsedType.URL,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 24,
                    ),
                    onTap: (url) async {
                      var a = await canLaunch(url);

                      if (a) {
                        launch(url);
                      }
                    }),
                MatchText(
                    type: ParsedType.PHONE,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 24,
                    ),
                    onTap: (url) {
                      launch("tel:" + url);
                    }),
                MatchText(
                  type: ParsedType.CUSTOM,
                  pattern:
                      r"^(?:http|https):\/\/[\w\-_]+(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)",
                  style: TextStyle(color: Colors.lime),
                  onTap: (url) => print(url),
                ),
                MatchText(
                    type: ParsedType.CUSTOM,
                    pattern:
                        "(---( )?(`)?spoiler(`)?( )?---)\n\n(.*?)\n( )?(---( )?(`)?spoiler(`)?( )?---)",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 50,
                    ),
                    onTap: (url) {
                      launch("tel:" + url);
                    }),
                MatchText(
                  pattern: r"\[(@[^:]+):([^\]]+)\]",
                  style: TextStyle(
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
                        Map<String, String> map = Map<String, String>();
                        RegExp customRegExp = RegExp(r"\[(@[^:]+):([^\]]+)\]");
                        Match match = customRegExp.firstMatch(url)!;
                        // return object of type Dialog
                        return AlertDialog(
                          title: new Text("Mentions clicked"),
                          content: new Text("${match.group(1)!} clicked."),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            new FlatButton(
                              child: new Text("Close"),
                              onPressed: () {},
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
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 24,
                  ),
                  onTap: (url) async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          title: new Text("Hashtag clicked"),
                          content: new Text("$url clicked."),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            new FlatButton(
                              child: new Text("Close"),
                              onPressed: () {},
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
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: 24,
                    ),
                    onTap: (url) async {})
              ],
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
