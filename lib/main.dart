import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

void main() {
  runApp(FlutterView());
}

void firebaseCloudMessagingListeners() {
  // if (Platform.isIOS) iOS_Permission();

  _firebaseMessaging.getToken().then((token) {
    print('token: $token');
  });

  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
    },
    onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
    },
    onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
    },
  );
}

class FlutterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const platform = const MethodChannel('com.mrporter.pomangam/bootpay');

  _MyHomePageState() {

    platform.setMethodCallHandler(_handleMethod);
  }

  @override
  void initState() {
    super.initState();
    firebaseCloudMessagingListeners();
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'handleCallback':
        print('arguments: ${call.arguments}');
        break;
      default:
        throw ('method not defined');
    }
  }

  Future<void> _openPay() async {
    try {
      final String result = await platform.invokeMethod('openPay');
      print(result);
    } on PlatformException catch (e) {
      print('error $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'bootpay',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openPay,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
