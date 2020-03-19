import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
import 'package:zostawpoddrzwiami/services/auth_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zostawpoddrzwiami/widgets/loading_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final textInputDecoration = InputDecoration(
    labelStyle: TextStyle(color: Color(0xFF243F38)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black12, width: 2.0)),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black12, width: 2.0),
    ),
  );

  bool _loadingInProgress;
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String emailReset = '';

  @override
  void initState() {
    super.initState();
    _loadingInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Zostaw Pod Drzwiami',
                    style: TextStyle(color: Colors.blue, fontSize: 22.0),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.white, Colors.grey[200]],
                              stops: [0.7, 1.0],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 40.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    TextFormField(
                                        validator: (val) =>
                                            val.isEmpty ? 'Wpisz email' : null,
                                        onChanged: (val) {
                                          setState(() {
                                            email = val;
                                          });
                                        },
                                        decoration: textInputDecoration
                                            .copyWith(labelText: 'email')),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    TextFormField(
                                        validator: (val) =>
                                            val.isEmpty ? 'Wpisz hasło' : null,
                                        onChanged: (val) {
                                          setState(() {
                                            password = val;
                                          });
                                        },
                                        obscureText: true,
                                        decoration: textInputDecoration
                                            .copyWith(labelText: 'hasło')),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    'Zapomniałeś hasła?',
                    style: TextStyle(color: Colors.blue),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _loadingInProgress = true;
                        });
                        User result = await AuthService().signInAnon();
                        setState(() {
                          _loadingInProgress = false;
                        });
                        if (result == null) {
                          Toast.show('Wystąpił błąd przy logowaniu', context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.CENTER);
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xFF583CDF), Colors.blue],
                              stops: [0.6, 1.0],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(50.0)),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 30.0),
                          child: Text(
                            'Zaloguj się',
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                          )),
                    ),
                  ),
                ]),
          ),
          _loadingInProgress
              ? Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black87,
                    ),
                    Center(
                      child: Loading(),
                    )
                  ],
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
