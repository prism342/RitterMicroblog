import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

T? cast<T>(x) => x is T ? x : null;

class UserData extends Object {
  late final String? uid;
  late final String? username;
  late final String? handle;
  late final Timestamp? joinedDate;
  late final String? profilePicUrl;

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
    final data = <String, dynamic>{};

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

class Post extends Object {
  late final String? postID;
  late final String? creatorID;
  late final Timestamp? timestamp;
  late final String? textContent;
  late final List<String>? imageURLs;

  Post(
      {this.postID,
      this.creatorID,
      this.timestamp,
      this.textContent,
      this.imageURLs});

  factory Post.fromData(String docID, Map<String, dynamic>? data) {
    if (data == null) {
      return Post();
    }

    String? creatorID = cast<String>(data["creatorID"]);
    Timestamp? timestamp = cast<Timestamp>(data["timestamp"]);
    String? textContent = cast<String>(data["textContent"]);
    List<String>? imageURLs = cast<List<String>>(data["imageURLs"]);

    return Post(
        creatorID: creatorID,
        timestamp: timestamp,
        textContent: textContent,
        imageURLs: imageURLs);
  }

  Map<String, dynamic> toData() {
    final data = <String, dynamic>{};

    if (textContent != null) {
      data["textContent"] = textContent;
    }

    if (creatorID != null) {
      data["creatorID"] = creatorID;
    }

    if (timestamp != null) {
      data["timestamp"] = timestamp;
    }

    if (imageURLs != null) {
      data["imageURLs"] = imageURLs;
    }

    log("Post.toData()");
    log(data.toString());

    return data;
  }
}
