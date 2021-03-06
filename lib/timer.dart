import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'debug.dart';
import 'package:numberpicker/numberpicker.dart';

class TimerStateful extends StatefulWidget {
  @override
  TimerState createState() => TimerState();
}

String displayHours = "";
String displayMinutes = "";
String displaySeconds = "";

class TimerState extends State<TimerStateful> {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int totalSeconds = 0;
  final _controllerH = TextEditingController();
  final _controllerM = TextEditingController();
  final _controllerS = TextEditingController();

  bool timerActive = false;
  IconData buttonIcon = Icons.play_arrow;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            body: new Container(
          margin: EdgeInsets.fromLTRB(0, 130, 0, 50),
          alignment: Alignment.center,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: Text(
                  "frog will ring in",
                  style: TextStyle(
                      fontSize: 40,
                      color: timerActive
                          ? Color.fromARGB(255, 0, 70, 0)
                          : Color.fromARGB(255, 200, 200, 200)),
                ),
              ),
              Container(
                child: clocka(context),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Transform.scale(
                      scale: 1.2,
                      child: FloatingActionButton(
                        child: Icon(buttonIcon, color: Colors.white),
                        onPressed: () {
                          setFrogTimer(hours, minutes, seconds + 1);
                          setState(() {
                            displayHours = (hours < 10) ? "0$hours" : "$hours";
                            displayMinutes =
                                (minutes < 10) ? "0$minutes" : "$minutes";
                            displaySeconds =
                                (seconds < 10) ? "0$seconds" : "$seconds";

                            if (!timerActive) {
                              startTimer();
                            } else {
                              stopTimer();
                            }
                          });
                        },
                      ))),
            ],
          ),
        )));
  }

  void initState() {
    _controllerH.addListener(() {
      final text = _controllerH.text.toLowerCase();
      _controllerH.value = _controllerH.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    _controllerM.addListener(() {
      final text = _controllerM.text.toLowerCase();
      _controllerM.value = _controllerM.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    _controllerS.addListener(() {
      final text = _controllerS.text.toLowerCase();
      _controllerS.value = _controllerS.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    super.initState();

    displayHours = (hours < 10) ? "0$hours" : "$hours";
    displayMinutes = (minutes < 10) ? "0$minutes" : "$minutes";
    displaySeconds = (seconds < 10) ? "0$seconds" : "$seconds";
  }

  void dispose() {
    _controllerH.dispose();
    _controllerM.dispose();
    _controllerS.dispose();
    super.dispose();
  }

  Timer t;

  void startTimer() {
    setState(() {
      timerActive = true;
      buttonIcon = Icons.pause;
      _controllerH.text = "";
      _controllerM.text = "";
      _controllerS.text = "";
    });

    totalSeconds = seconds + minutes * 60 + hours * 60 * 60;
    setFrogTimer(hours, minutes, seconds);
    t = Timer.periodic(Duration(seconds: 1), (timer) {
      if (totalSeconds != 0) {
        print("$totalSeconds seconds");

        setState(() {
          hours = totalSeconds ~/ 3600;
          minutes = (totalSeconds % 3600) ~/ 60;
          seconds = totalSeconds % 60;

          displayHours = (hours < 10) ? "0$hours" : "$hours";
          displayMinutes = (minutes < 10) ? "0$minutes" : "$minutes";
          displaySeconds = (seconds < 10) ? "0$seconds" : "$seconds";

          totalSeconds -= 1;
        });
      } else {
        seconds = 0;
        print("$totalSeconds seconds");
        setState(() {
          _controllerS.value = TextEditingValue();
          displayHours = "00";
          displayMinutes = "00";
          displaySeconds = "00";
        });

        timerDone();
      }
    });
  }

  void stopTimer() {
    print("Timer stopped");


    t.cancel();
      Timer(Duration(seconds: 1), () {
        setState(() {
        timerActive = false;
        buttonIcon = Icons.play_arrow;
      });
      });
  }

  void timerDone() {
    print("TIMER DONE");
    stopTimer();

    //FROG LOGIC
  }

  clocka(context) {
    var theme = Theme.of(context);

    double pickerItemHeight = 60;
    double pickerWidth = 80;

    if (timerActive) {
      return BlinkingTextAnimation();
    } else {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(children: [
              new NumberPicker.integer(
                  initialValue: hours,
                  itemExtent: pickerItemHeight,
                  listViewWidth: pickerWidth,
                  minValue: 0,
                  maxValue: 23,
                  zeroPad: true,
                  infiniteLoop: true,
                  onChanged: (val) => setState(() {
                        hours = val.toInt();
                      })),
              Text(
                "Hours",
                style: TextStyle(color: theme.disabledColor, fontSize: 15),
              )
            ]),
            Text(":", style: TextStyle(fontSize: 30)),
            Column(children: [
              new NumberPicker.integer(
                  initialValue: minutes,
                  itemExtent: pickerItemHeight,
                  listViewWidth: pickerWidth,
                  minValue: 0,
                  maxValue: 59,
                  zeroPad: true,
                  infiniteLoop: true,
                  onChanged: (val) => setState(() {
                        minutes = val.toInt();
                      })),
              Text(
                "Minutes",
                style: TextStyle(color: theme.disabledColor, fontSize: 15),
              )
            ]),
            Text(":", style: TextStyle(fontSize: 30)),
            Column(children: [
              new NumberPicker.integer(
                  initialValue: seconds,
                  itemExtent: pickerItemHeight,
                  listViewWidth: pickerWidth,
                  minValue: 0,
                  maxValue: 59,
                  zeroPad: true,
                  infiniteLoop: true,
                  onChanged: (val) => setState(() {
                        seconds = val.toInt();
                      })),
              Text(
                "Seconds",
                style: TextStyle(color: theme.disabledColor, fontSize: 15),
              )
            ]),
          ]);
    }
  }
}

class BlinkingTextAnimation extends StatefulWidget {
  @override
  _BlinkingAnimationState createState() => _BlinkingAnimationState();
}

AnimationController animController;

class _BlinkingAnimationState extends State<BlinkingTextAnimation>
    with SingleTickerProviderStateMixin {
  Animation<Color> animation;

  initState() {
    super.initState();

    animController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    final CurvedAnimation curve =
        CurvedAnimation(parent: animController, curve: Curves.linear);

    animation =
        ColorTween(begin: Colors.black, end: Colors.white).animate(curve);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget child) {
          return new Container(
            margin: EdgeInsets.fromLTRB(0, 60, 0, 60),
            child: Text("$displayHours:$displayMinutes:$displaySeconds",
                style: TextStyle(color: animation.value, fontSize: 65)),
          );
        });
  }

  dispose() {
    animController.dispose();
    super.dispose();
  }
}
