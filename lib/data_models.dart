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

enum ActivityType { post, comment, repost, like }

abstract class Activity extends Object {
  late String? docID;
  late String creatorID;
  late Timestamp timestamp;

  Activity({
    this.docID,
    required this.creatorID,
    required this.timestamp,
  });

  Map<String, dynamic> toMap();
}

class PostActivity extends Activity {
  late String postContent;
  late List<String>? postImageURLs;

  PostActivity({
    String? docID,
    required String creatorID,
    required Timestamp timestamp,
    required this.postContent,
    required this.postImageURLs,
  }) : super(docID: docID, creatorID: creatorID, timestamp: timestamp);

  @override
  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};

    data["creatorID"] = creatorID;
    data["timestamp"] = timestamp;

    data["postContent"] = postContent;
    data["postImageURLs"] = postImageURLs;

    return data;
  }

  static PostActivity? fromMap(String docID, Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    String? creatorID = cast<String>(data["creatorID"]);
    Timestamp? timestamp = cast<Timestamp>(data["timestamp"]);
    String? postContent = cast<String>(data["postContent"]);
    List<String>? postImageURLs = cast<List<String>>(data["postImageURLs"]);

    if (creatorID == null || timestamp == null || postContent == null) {
      return null;
    } else {
      return PostActivity(
          docID: docID,
          creatorID: creatorID,
          timestamp: timestamp,
          postContent: postContent,
          postImageURLs: postImageURLs);
    }
  }
}

class CommentActivity extends Activity {
  late String refPostID;
  late String comment;

  CommentActivity({
    String? docID,
    required String creatorID,
    required Timestamp timestamp,
    required this.refPostID,
    required this.comment,
  }) : super(docID: docID, creatorID: creatorID, timestamp: timestamp);

  @override
  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};

    data["creatorID"] = creatorID;
    data["timestamp"] = timestamp;

    data["refPostID"] = refPostID;
    data["comment"] = comment;

    return data;
  }

  static CommentActivity? fromMap(String docID, Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    String? creatorID = cast<String>(data["creatorID"]);
    Timestamp? timestamp = cast<Timestamp>(data["timestamp"]);
    String? refPostID = cast<String>(data["refPostID"]);
    String? comment = cast<String>(data["comment"]);

    if (creatorID == null ||
        timestamp == null ||
        refPostID == null ||
        comment == null) {
      return null;
    } else {
      return CommentActivity(
          docID: docID,
          creatorID: creatorID,
          timestamp: timestamp,
          refPostID: refPostID,
          comment: comment);
    }
  }
}

class RepostActivity extends Activity {
  late String refPostID;

  RepostActivity({
    String? docID,
    required String creatorID,
    required Timestamp timestamp,
    required this.refPostID,
  }) : super(docID: docID, creatorID: creatorID, timestamp: timestamp);

  @override
  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};

    data["creatorID"] = creatorID;
    data["timestamp"] = timestamp;

    data["refPostID"] = refPostID;

    return data;
  }

  static RepostActivity? fromMap(String docID, Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    String? creatorID = cast<String>(data["creatorID"]);
    Timestamp? timestamp = cast<Timestamp>(data["timestamp"]);
    String? refPostID = cast<String>(data["refPostID"]);

    if (creatorID == null || timestamp == null || refPostID == null) {
      return null;
    } else {
      return RepostActivity(
        docID: docID,
        creatorID: creatorID,
        timestamp: timestamp,
        refPostID: refPostID,
      );
    }
  }
}

class LikeActivity extends Activity {
  late String refPostID;

  LikeActivity({
    String? docID,
    required String creatorID,
    required Timestamp timestamp,
    required this.refPostID,
  }) : super(docID: docID, creatorID: creatorID, timestamp: timestamp);

  @override
  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};

    data["creatorID"] = creatorID;
    data["timestamp"] = timestamp;

    data["refPostID"] = refPostID;

    return data;
  }

  static LikeActivity? fromMap(String docID, Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    String? creatorID = cast<String>(data["creatorID"]);
    Timestamp? timestamp = cast<Timestamp>(data["timestamp"]);
    String? refPostID = cast<String>(data["refPostID"]);

    if (creatorID == null || timestamp == null || refPostID == null) {
      return null;
    } else {
      return LikeActivity(
        docID: docID,
        creatorID: creatorID,
        timestamp: timestamp,
        refPostID: refPostID,
      );
    }
  }
}
