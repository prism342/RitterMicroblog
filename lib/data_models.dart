import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

T? cast<T>(x) => x is T ? x : null;

class UserData extends Object {
  String? uid;
  String? username;
  String? handle;
  Timestamp? joinedDate;
  String? profilePicUrl;

  UserData(
      {this.uid,
      this.username,
      this.handle,
      this.joinedDate,
      this.profilePicUrl});

  factory UserData.fromData(String docID, Map<String, dynamic>? data) {
    if (data == null) {
      return UserData();
    }

    String? username = cast<String>(data["username"]);
    String? handle = cast<String>(data["handle"]);
    Timestamp? joinedDate = cast<Timestamp>(data["joinedDate"]);
    String? profilePicUrl = cast<String>(data["profilePicUrl"]);

    log(data.toString());

    return UserData(
        uid: docID,
        username: username,
        handle: handle,
        joinedDate: joinedDate,
        profilePicUrl: profilePicUrl);
  }

  Map<String, dynamic> toData() {
    var data = <String, dynamic>{};

    if (username != null) {
      data["username"] = username;
    }

    if (handle != null) {
      data["handle"] = handle;
    }

    if (profilePicUrl != null) {
      data["profilePicUrl"] = profilePicUrl;
    }

    return data;
  }
}
