import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(FlutterView());

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
