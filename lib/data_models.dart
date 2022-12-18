T? cast<T>(x) => x is T ? x : null;

class UserData extends Object {
  String? uid;
  String? username;
  String? handle;
  DateTime? joinedDate;

  UserData({this.uid, this.username, this.handle, this.joinedDate});

  factory UserData.fromData(String docID, Map<String, dynamic>? data) {
    if (data == null) {
      return UserData();
    }

    String? username = cast<String>(data["username"]);
    String? handle = cast<String>(data["handle"]);
    DateTime? joinedDate = cast<DateTime>(data["joinedDate"]);
    return UserData(
        uid: docID, username: username, handle: handle, joinedDate: joinedDate);
  }

  Map<String, dynamic> toData() {
    var data = <String, dynamic>{};

    if (username != null) {
      data["username"] = username;
    }

    if (handle != null) {
      data["handle"] = handle;
    }

    return data;
  }
}
