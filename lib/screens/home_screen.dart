import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zostawpoddrzwiami/models/item_model.dart';
import 'package:zostawpoddrzwiami/models/request_model.dart';
import 'package:zostawpoddrzwiami/models/request_model.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
import 'package:zostawpoddrzwiami/services/auth_service.dart';
import 'package:zostawpoddrzwiami/services/database_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final List<UserRequest> userRequest = Provider.of<List<UserRequest>>(context);
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: true,
            expandedHeight: 200,
            backgroundColor: Colors.white,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () => AuthService().signOut(),
                color: Colors.black,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 20.0, bottom: 16.0),
              title: Text(
                'Prośby blisko Ciebie',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: false,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final UserRequest request = userRequest[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 20.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '12:34',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Color(0xFFB1B1B1),
                              fontSize: 16.0),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.location_on,
                                size: 20.0, color: Color(0xFFB1B1B1)),
                            Text(
                              '1.3 km',
                              style: TextStyle(
                                  color: Color(0xFFB1B1B1), fontSize: 16.0),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0xFFECECEC), Colors.white],
                                  stops: [0.3, 0.9]),
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                    offset: Offset(0, 10))
                              ]),
                          width: double.infinity,
                          height: 300,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0))),
                          width: double.infinity,
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      request.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30.0),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.shopping_cart,
                                          color: Color(0xFFB1B1B1),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          '~' + request.price + 'zł',
                                          style: TextStyle(
                                              fontSize: 21.0,
                                              color: Color(0xFFB1B1B1)),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(context, '/details'),
                                  child: Container(
                                    width: 130,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFEDEDED),
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Pomagam',
                                          style:
                                              TextStyle(color: Color(0xFF707070)),
                                        ),
                                        SizedBox(width: 5.0,),
                                        Icon(Icons.arrow_forward,
                                            color: Color(0xFF707070))
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }, childCount: userRequest.length),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 3.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.home,
                    size: 30.0,
                    color: Color(0xFF583CDF),
                  ),
                  Text('Home',
                      style: TextStyle(
                        color: Color(0xFF583CDF),
                      )),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.home,
                    size: 30.0,
                    color: Colors.transparent,
                  ),
                  Text('Home',
                      style: TextStyle(
                        color: Colors.transparent,
                      )),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.shopping_basket,
                    size: 30.0,
                    color: Colors.grey[300],
                  ),
                  Text(
                    'Lista',
                    style: TextStyle(color: Colors.grey[300]),
                  )
                ],
              ),
            ],
          ),
        ),
        shape: CircularNotchedRectangle(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          UserRequest test_request = UserRequest(name: 'Kamil',
          address: 'Sosnowa', price: '13', request: [Item('Mleko', 1)], status: false);
          await DatabaseService(uid: user.uid).createNewRequest(test_request);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
