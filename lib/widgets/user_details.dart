import 'package:flutter/material.dart';

class UserDetails extends StatefulWidget {
  final String userName;
  UserDetails(this.userName);
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 90,
            width: double.infinity,
            color: Color.fromRGBO(152, 174, 0, 0.5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/profile_pic.png'),
                  radius: 30,
                  backgroundColor: Color.fromRGBO(255, 104, 220, 1),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      widget.userName,
                      style: TextStyle(
                        color: Color.fromRGBO(255, 104, 220, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
