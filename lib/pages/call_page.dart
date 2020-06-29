import 'package:wocktock/widgets/app_bar.dart';
import 'package:wocktock/widgets/call_function.dart';
import 'package:flutter/material.dart';

class CallPage extends StatefulWidget {
  final String userName;
  final String channelName;
  CallPage(this.userName, this.channelName);
  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  void infoPanel(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text("About..."),
      content: Text('Hi ' +
          widget.userName +
          '! WockTock is a walkie talkie app built using flutter and Agora SDK to help communication during event management. '
              'Click the walkie icon to begin!'),
    );

    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: Center(child: Text('WockTock!')),
        elevation: 10,
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/walkster.png'),
          radius: 10,
          backgroundColor: Color.fromRGBO(207, 181, 59, 1),
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.info),
            onPressed: () => infoPanel(context),
          ),
        ],
      ),
      body: Stack(
        // fit: StackFit.expand,
        children: <Widget>[
          VideoCall(widget.channelName),
          Positioned(
            bottom: 10,
            left: 60,
            child: StatusBar(),
          ),
        ],
      ),
    );
  }
}
