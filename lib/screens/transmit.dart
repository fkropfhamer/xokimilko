import 'package:flutter/material.dart';

class TransmitScreen extends StatefulWidget {
  const TransmitScreen({super.key});

  @override
  State<TransmitScreen> createState() => _TransmitScreenState();
}

class _TransmitScreenState extends State<TransmitScreen> {
  var transmits = <int>[];
  var ts = DateTime.now().millisecondsSinceEpoch;

  final _scrollController = ScrollController();

  void a() {

    setState(() {
      final now = DateTime.now().millisecondsSinceEpoch;
      transmits.add(now - ts);
      ts = now;

      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(microseconds: 500), curve: Curves.easeOut);
    });

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
              SizedBox(
                height: 50,
               width: double.infinity,
               child: ListView.builder(
                 controller: _scrollController,
                   padding: const EdgeInsets.all(8),
                   itemCount: transmits.length,
                   scrollDirection: Axis.horizontal,
                   itemBuilder: (BuildContext context, int index) {
                     final color = index % 2 == 0 ? Colors.green : Colors.grey;

                     return Container(
                       height: 50,
                       width: transmits[index] / 10,
                       color: color,
                       child: Center(child: Text('${transmits[index]}')),
                     );
                   })
              ),
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
