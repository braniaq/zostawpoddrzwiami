import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CurrentRequest extends StatefulWidget {
  @override
  _CurrentRequestState createState() => _CurrentRequestState();
}

class _CurrentRequestState extends State<CurrentRequest> {
  String name = "Pani Janinka";
  String phoneNumber = "555 444 333";
  String street = "Osiedle Mazurskie";

  String strNumber = "16";

  String city = "Mrągowo";

  String flat = "15";

  int rows = 10;
  bool checkbox_value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 30, top: 40, right: 30),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      phoneNumber,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                Container(
                  child: Column(children: <Widget>[
                    FittedBox(
                      child: Text(
                        street,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "$strNumber/$flat",
                          style: TextStyle(color: Colors.black, fontSize: 25),
                        ),
                        FlatButton(
                          onPressed: () {
                            _launchMapsUrl();
                          },
                          child: const Icon(Icons.location_on),
                        ),
                      ],
                    ),
                  ], crossAxisAlignment: CrossAxisAlignment.start),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: rows,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                    child: CheckboxListTile(
                      value: checkbox_value,
                      title: Column(
                        children: <Widget>[
                          Text("Mleko"),
                          Text("10l"),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      onChanged: (value) {
                        setState(() {
                          checkbox_value = value;
                        });
                      },
                      secondary: const Icon(Icons.shopping_basket),
                      //trailing: Icon(Icons.more_vert),
                    ),
                  );
                }),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    ));
  }

  void checkbox(bool b) {
    rows -= 1;
    print(rows);
    return;
  }

  void _launchMapsUrl() async {
    print("in url func");
    final url =
        'https://www.google.com/maps/search/?api=1&query=$street,$strNumber,$city';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
