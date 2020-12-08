import 'dart:convert';

import 'package:attandee/global/constants/const.dart';
import 'package:attandee/global/models/miscellaneous/absent.dart';
import 'package:attandee/global/models/miscellaneous/attended.dart';
import 'package:attandee/global/models/user.dart';
import 'package:attandee/user/widgets/Attended_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AttendedScreen extends StatefulWidget {
  final String id;

  const AttendedScreen({Key key, @required this.id}) : super(key: key);

  @override
  _AttendedScreenState createState() => _AttendedScreenState();
}

class _AttendedScreenState extends State<AttendedScreen> {
  Attended _attended;
  var _user;
  @override
  void initState() {
    super.initState();
    _user = _getUser(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sessions Attended"),
      ),
      body: FutureBuilder<User>(
        future: _user,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            _attended = snapshot.data.attended;
            return AttendedListView(attended: _attended);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<User> _getUser(String _id) async {
    var res = await http.post(
      Api.getUser,
      body: json.encode({"_id": _id}),
      headers: Api.header,
    );
    var _body = json.decode(res.body);
    if (_body.containsKey("err")) {
      return User(
        attended: Attended(count: 0, sessions: []),
        absent: Absent(count: 0, sessions: []),
        isAdmin: false,
        attendancePercentage: 0,
        id: _id,
        batch: 'NAN',
        fullName: 'NaN',
        uniqueId: 'NaN',
        emailId: 'NaN',
      );
    }
    // print('HELP' + res.body);
    return userFromJson(res.body);
  }
}
