import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

class StatusBar extends StatefulWidget {
  @override
  _StatusBarState createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> {
  bool micStatus = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CircleAvatar(
              backgroundColor: Colors.red,
              child: IconButton(
                icon: Icon(
                  Icons.call_end,
                  color: Colors.white,
                ),
                onPressed: disconnectCall,
              )),
        ],
      ),
    );
  }

  void toggleMute() {
    setState(() {
      micStatus = !micStatus;
    });
    AgoraRtcEngine.muteLocalAudioStream(micStatus);
  }

  void disconnectCall() {
    Navigator.pop(context);
  }
}
