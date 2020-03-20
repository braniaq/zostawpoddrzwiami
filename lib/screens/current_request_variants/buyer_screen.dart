import 'package:flutter/material.dart';
import 'package:zostawpoddrzwiami/models/current_user_request_model.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';

class BuyerScreen extends StatefulWidget {

  final CurrentUserRequest currentRequest;
  final User currentUser;
  final Function launch;
  final Function showResignDialog;

  BuyerScreen({this.currentUser, this.currentRequest, this.showResignDialog, this.launch});


  @override
  _BuyerScreenState createState() => _BuyerScreenState();
}

class _BuyerScreenState extends State<BuyerScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Twoja obecna lista',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  widget.showResignDialog(widget.currentUser);
                }
            )
          ],
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 30, top: 20, right: 30),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          widget.currentRequest.name,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 40,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              widget.currentRequest.phoneNumber,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                widget.launch("tel://${widget.currentRequest.phoneNumber}");
                              },
                              child: Icon(Icons.phone, color: Colors.green[600],),
                            )
                          ],
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Container(
                      child: Column(children: <Widget>[
                        FittedBox(
                          child: Text(
                            widget.currentRequest.address,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
//                            _launchMapsUrl();
                          },
                          child: Icon(Icons.location_on, color: Colors.red[700],
                          ),
                        ),
                      ], crossAxisAlignment: CrossAxisAlignment.start),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: widget.currentRequest.request.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 0, bottom: 0),
                        child: Card(
                          child: CheckboxListTile(
                            value: true,
                            title: Column(
                              children: <Widget>[
                                Text(widget.currentRequest.request[index].name),
                                Text(widget.currentRequest.request[index].quantity
                                    .toString() +
                                    widget.currentRequest.request[index].unit),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                            onChanged: (value) {
                              setState(() {
//                                checkbox_values[index] = value;
//                                syncWithCache();
                              });
                            },
                            secondary: const Icon(Icons.shopping_basket),
                            //trailing: Icon(Icons.more_vert),
                          ),
                        ),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: FloatingActionButton(onPressed: () {
//                    _showRequestFinishedDialog();
                  },
                    child: Icon(Icons.check, color: Colors.white,),
                    backgroundColor: Colors.green,
                  ),
                ),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ));
  }
}
