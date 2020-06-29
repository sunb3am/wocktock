import 'package:wocktock/utils/appID.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class VideoCall extends StatefulWidget {
  final String channelName;
  VideoCall(this.channelName);
  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  static final _users = <int>[];
  final _infoStrings = <String>[];

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.enableLocalVideo(false);
    await AgoraRtcEngine.enableLocalAudio(true);
    await AgoraRtcEngine.muteLocalAudioStream(true);
    await AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);
  }

  /// Add agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
  }

  /// agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    /// Use this function to obtain the uid of the person who joined the channel
    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(0, local: true, preview: true),
    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  void infoPanel(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text("About..."),
      content: Text(
          'WockTock is a walkie talkie app built using flutter and Agora SDK to help communication during event management. '
          'Click the walkie icon to begin!'),
    );

    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }

  bool micStatus = false;
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.green[500],
        body: Center(
            child: GestureDetector(
          onTapUp: (TapUpDetails details) {
            AgoraRtcEngine.muteLocalAudioStream(true);
            print('Unclicked');
            setState(() {
              clicked = false;
            });
          },
          onTapDown: (TapDownDetails details) {
            AgoraRtcEngine.muteLocalAudioStream(false);
            print('Clicked');
            setState(() {
              clicked = true;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: clicked ? Border.all(color: Colors.red, width: 2) : null,
              borderRadius: BorderRadius.circular(110),
            ),
            child: ClipOval(
              child: Container(
                width: 220.0,
                height: 220.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/walkie.png'),
                  ),
                  //border: clicked ? Border.all(color: Colors.red, width: 2): Border.all(),
                ),
              ),
            ),
          ),
        )),
      ),
    );
  }
}
