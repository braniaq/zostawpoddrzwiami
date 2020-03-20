import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
import 'package:zostawpoddrzwiami/models/current_user_request_model.dart';
import "package:zostawpoddrzwiami/models/request_model.dart";
import 'package:zostawpoddrzwiami/screens/current_request_variants/buyer_screen.dart';
import 'package:zostawpoddrzwiami/screens/current_request_variants/no_requests.dart';
import 'package:zostawpoddrzwiami/screens/current_request_variants/requester_screen.dart';
import "package:zostawpoddrzwiami/services/database_service.dart";
import "package:shared_preferences/shared_preferences.dart";

import '../models/request_model.dart';

// to do: better details for when receiver

class CurrentRequest extends StatefulWidget {
  @override
  _CurrentRequestState createState() {
    _CurrentRequestState state = _CurrentRequestState();
    for (var i = 0; i <= 500; i++) {
      state.checkbox_values.add(false);
    }
    return state;
  }
}

class _CurrentRequestState extends State<CurrentRequest> {
  bool isCarrier = true;
  String name = "Pani Janinka";
  String phoneNumber = "555 444 333";
  String street = "Osiedle Mazurskie";
  String strNumber = "16";
  String city = "Mrągowo";
  String flat = "15";
  CurrentUserRequest currentRequest;
  int rows = 10;
  List<bool> checkbox_values = [];
  String checkBoxString = "";
  String cachedID = "";
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i <= 500; i++) {
      checkbox_values.add(false);
    }
    _loadCachedData();
  }

  _loadCachedData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      cachedID = (prefs.getString('cachedID') ?? "");
      checkBoxString = (prefs.getString('checkBoxString') ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    final User currentUser = Provider.of<User>(context);
    final List<CurrentUserRequest> allRequests =
        Provider.of<List<CurrentUserRequest>>(context);

    if (allRequests != null) {
      allRequests.forEach((CurrentUserRequest req) {
        if (!req.status) {
          currentRequest = req;
        }
      });
    } else {
      return NoRequestsScreen();
    }
    if (currentRequest == null) {
      print("current request null");
      return NoRequestsScreen();
    }
    if (cachedID == currentRequest.requestId) {
      for (var i = 0; i < checkBoxString.length; i++) {
        if (checkBoxString[i] == "1") {
          checkbox_values[i] = true;
        } else {
          checkbox_values[i] = false;
        }
      }
    }
    if (currentUser.uid != currentRequest.requestId) {
      print("in is carrier");
      return BuyerScreen(
        currentUser: currentUser,
        currentRequest: currentRequest,
        launch: launch,
        showResignDialog: showResignDialog,
      );
    } else {
      return RequesterScreen(
        currentUser: currentUser,
        currentRequest: currentRequest,
        launch: launch,
        showCancelDialog: showCancelDialog,
      );
    }
  }

  void checkbox(bool b) {
    rows -= 1;
    print(rows);
    return;
  }

  void launchMapsUrl() async {
    print("in url func");
    final url =
        'https://www.google.com/maps/search/?api=1&query=$street,$strNumber,$city';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showResignDialog(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Uwaga!"),
          content: new Text(
              "Czy na pewno chcesz zrezygnowac z obecnie wykonywanej prośby?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Nie"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Tak"),
              onPressed: () {
                print(user.uid);
                DatabaseService(uid: user.uid).abandonRequest(currentRequest);
                print("abandoning request");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showCancelDialog(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Uwaga!"),
          content:
              new Text("Czy na pewno chcesz zrezygnowac ze złożonej prośby?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Nie"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Tak"),
              onPressed: () {
                DatabaseService(uid: user.uid).abandonRequest(currentRequest);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showRequestFinishedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Uwaga!"),
          content: new Text(
              "Czy na pewno chcesz oznaczyć zamowienie jako wykonane?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Nie"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Tak"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void syncWithCache() async {
    prefs = await SharedPreferences.getInstance();
    String newCheckboxString = "";
    for (var i = 0; i < currentRequest.request.length; i++) {
      if (checkbox_values[i] == false) {
        newCheckboxString += "0";
      } else {
        newCheckboxString += "1";
      }
    }
    prefs.setString("checkBoxString", newCheckboxString);
    prefs.setString("cachedID", currentRequest.requestId);
    cachedID = currentRequest.requestId;
    checkBoxString = newCheckboxString;
  }
}
