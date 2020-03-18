import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:zostawpoddrzwiami/models/current_user_request_model.dart';
import 'package:zostawpoddrzwiami/models/request_model.dart';
import 'package:zostawpoddrzwiami/models/user_model.dart';
import 'package:zostawpoddrzwiami/models/item_model.dart';
import 'package:shortid/shortid.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference userDataCollection =
      Firestore.instance.collection('users');
  final CollectionReference itemsDataCollection =
      Firestore.instance.collection('data');
  final CollectionReference requestDataCollection =
      Firestore.instance.collection('requests');
  final CollectionReference appDataCollection =
      Firestore.instance.collection('app-data');

  Future createUserData(String name) async {
    return await userDataCollection.document(uid).setData({
      'name': name,
    });
  }

  Stream<UserData> get userData {
    return userDataCollection.document(uid).snapshots().map(_userFromSnapshot);
  }

  Stream<List<UserRequest>> get requestData {
    return requestDataCollection.snapshots().map(_requestFromSnapshot);
  }

  Stream<List<CurrentUserRequest>> get userRequests {
    final CollectionReference currentUserRequestCollection = Firestore.instance
        .collection('users')
        .document(uid)
        .collection('request');
    return currentUserRequestCollection.snapshots().map(_currentUserRequestFromSnapshot);
  }

  List<UserRequest> _requestFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      if (doc != null) {
        return UserRequest(
          name: doc.data["name"] ?? '',
          address: doc.data["name"] ?? '',
          request: doc.data["request"] ?? [],
          requestId: doc.data["requestId"] ?? '',
          price: doc.data["price"] ?? '',
          status: doc.data["status"] ?? false,
          time: doc.data["time"] != null ? doc.data['time'].toDate().toString() : '',
          longitude: doc.data["longitude"] ?? 0.0,
          latitude:  doc.data["latitude"] ?? 0.0,
        );
      } else {
        return null;
      }
    }).toList();
  }
  List<CurrentUserRequest> _currentUserRequestFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      if (doc != null) {
        return CurrentUserRequest(
          name: doc.data["name"] ?? '',
          address: doc.data["name"] ?? '',
          request: doc.data["request"] ?? [],
          requestId: doc.data["requestId"] ?? '',
          price: doc.data["price"] ?? '',
          status: doc.data["status"] ?? false,
        );
      } else {
        return null;
      }
    }).toList();
  }

  UserData _userFromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.data != null) {
      return UserData(uid: uid, name: snapshot.data['name'] ?? 'Janina');
    } else {
      return null;
    }
  }

  Future createNewRequest(UserRequest request) async {
    final id = shortid.generate();
    List<String> output = [];
    request.request.forEach((item) {
      output.add("${item.quantity.toString()} x ${item.name}");
    });
    await requestDataCollection.document(id).setData({
      'name': request.name,
      'customer': uid,
      'requestId': id,
      'order': output,
      'status': request.status,
      'price': request.price,
      'address': request.address,
    });
    await userDataCollection
        .document(uid)
        .collection('requests')
        .document(id)
        .setData({
      'name': request.name,
      'customer': uid,
      'requestId': id,
      'order': output,
      'status': request.status,
      'price': request.price,
      'address': request.address,
    });
    return true;
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' dzień temu';
      } else {
        time = diff.inDays.toString() + ' dni temu';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' tydzień temu';
      } else {

        time = (diff.inDays / 7).floor().toString() + ' tygodni temu';
      }
    }

    print(time);
    return time;
  }

}
