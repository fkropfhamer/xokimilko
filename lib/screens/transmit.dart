import 'package:flutter/material.dart';

class TransmitScreen extends StatefulWidget {
  const TransmitScreen({super.key});

  @override
  State<TransmitScreen> createState() => _TransmitScreenState();
}

class _TransmitScreenState extends State<TransmitScreen> {
  var transmits = <int>[];
  var ts = DateTime.now().millisecondsSinceEpoch;

  void a() {
    final now = DateTime.now().millisecondsSinceEpoch;
    transmits.add(now - ts);
    ts = now;

    print(transmits);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Transmit"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkResponse(
                  onTapDown: (t) {
                    print("down");
                    a();
                  },
                  onTapUp: (t) {
                    print("up");
                    a();
                  },
                  child: Container(
                      width: 100.0,
                      height: 100.0,
                      // margin: EdgeInsets.all(100.0),
                      decoration: BoxDecoration(
                          // color: Colors.orange,
                          shape: BoxShape.circle,
                          border: Border.all(width: 5.0, color: Colors.green))))
            ]),
      ),
    );
  }
}
