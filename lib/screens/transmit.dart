import 'dart:math';

import 'package:flutter/material.dart';

const morseMap = {
  ".-": "A",
  "-...": "B",
  "-.-.": "C",
  "-..": "D",
  ".": "E",
  "..-.": "F",
  "--.": "G",
  "....": "H",
  "..": "I",
  ".---": "J",
  "-.-": "K",
  ".-..": "L",
  "--": "M",
  "-.": "N",
  "---": "O",
  ".--.": "P",
  "--.-": "Q",
  ".-.": "R",
  "...": "S",
  "-": "T",
  "..-": "U",
  "...-": "V",
  ".--": "W",
  "-..-": "X",
  "-.--": "Y",
  "--..": "Z",
  ".----": "1",
  "..---": "2",
  "...--": "3",
  "....-": "4",
  ".....": "5",
  "-....": "6",
  "--...": "7",
  "---..": "8",
  "----.": "9",
  "-----": "0",
};

const timeUnit = 200;
const dit = 1 * timeUnit;
const dah = 2 * timeUnit;
const interElement = 1 * timeUnit;
const shortGap = 3 * timeUnit;
const mediumGap = 5 * timeUnit;

enum TransmitType { pause, send }

enum TransmitClass {
  dit,
  dah,
  interElement,
  shortGap,
  mediumGap;

  @override
  String toString() {
    switch (this) {
      case TransmitClass.dit:
        return '.';
      case TransmitClass.dah:
        return '-';
      case TransmitClass.interElement:
      case TransmitClass.shortGap:
      case TransmitClass.mediumGap:
        return '';
    }
  }
}

class Transmit {
  const Transmit(this.duration, this.type);

  final int duration;
  final TransmitType type;

  TransmitClass _getPauseClass() {
    if (duration > mediumGap) {
      return TransmitClass.mediumGap;
    }

    if (duration > shortGap) {
      return TransmitClass.shortGap;
    }

    return TransmitClass.interElement;
  }

  TransmitClass _getSendClass() {
    if (duration > dah) {
      return TransmitClass.dah;
    }

    return TransmitClass.dit;
  }

  TransmitClass getClass() {
    if (type == TransmitType.pause) {
      return _getPauseClass();
    }

    return _getSendClass();
  }
}

String parseLetter(List<Transmit> transmits) {
  final ts = transmits.map((t) => t.getClass().toString()).join();
  final letter = morseMap[ts];

  if (letter != null) {
    return letter;
  }

  return "?";
}

String parseWord(List<Transmit> transmits) {
  List<List<Transmit>> letters = [[]];

  for (Transmit t in transmits) {
    if (t.type == TransmitType.pause &&
        t.getClass() == TransmitClass.shortGap) {
      letters.add([]);
      continue;
    }

    letters.last.add(t);
  }

  return letters.map((l) => parseLetter(l)).join();
}

String parseMorse(List<Transmit> transmits) {
  List<List<Transmit>> words = [[]];

  var ts = transmits.where((t) => t.getClass() != TransmitClass.interElement);

  for (Transmit t in ts) {
    if (t.type == TransmitType.pause &&
        t.getClass() == TransmitClass.mediumGap) {
      words.add([]);
      continue;
    }

    words.last.add(t);
  }

  return words.map((w) => parseWord(w)).join(" ");
}

class TransmitScreen extends StatefulWidget {
  const TransmitScreen({super.key});

  @override
  State<TransmitScreen> createState() => _TransmitScreenState();
}

class _TransmitScreenState extends State<TransmitScreen> {
  var transmits = <Transmit>[];
  var ts = DateTime.now().millisecondsSinceEpoch;
  var text = "";

  final _scrollController = ScrollController();

  void addTransmit(TransmitType t) {
    setState(() {
      final now = DateTime.now().millisecondsSinceEpoch;
      final diff = min(now - ts, 3000);
      final transmit = Transmit(diff, t);

      transmits.add(transmit);
      ts = now;
      text = parseMorse(transmits);

      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(microseconds: 500), curve: Curves.easeOut);
    });
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
              Text(text),
              SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8),
                      itemCount: transmits.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        final transmit = transmits[index];
                        final color = transmit.type == TransmitType.pause
                            ? Colors.grey
                            : Colors.green;
                        final width = transmit.duration / 10;

                        Widget? child;
                        if (transmit.getClass() == TransmitClass.dit) {
                          child = Center(
                            child: Container(
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                )),
                          );
                        }

                        if (transmit.getClass() == TransmitClass.dah) {
                          child = Center(
                            child: Container(
                                height: 5,
                                width: min(width, 20),
                                decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)))),
                          );
                        }

                        return Container(
                            height: 50,
                            width: max(width, 5),
                            color: color,
                            child: child);
                      })),
              InkResponse(
                  onTapDown: (t) {
                    addTransmit(TransmitType.pause);
                  },
                  onTapUp: (t) {
                    addTransmit(TransmitType.send);
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
