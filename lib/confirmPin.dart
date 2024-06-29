import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uas_ambw/home.dart';

class Confirm extends StatefulWidget {
  final String pin;
  const Confirm({super.key, required this.pin});

  @override
  State<Confirm> createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConfirmPage(pin:widget.pin),
    );
  }
}

class ConfirmPage extends StatefulWidget {
  final String pin;
  const ConfirmPage({super.key, required this.pin});

  @override
  State<ConfirmPage> createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  String confirmPin = '';
  Box? settingBox;

  @override
  void initState() {
    super.initState();
    settingBox = Hive.box('settings');
  }

  @override
  Widget buildNumberRow(List<dynamic> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) {
        return buildNumberButton(number);
      }).toList(),
    );
  }

  Widget buildNumberButton(dynamic number) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (number is int) {
            if (confirmPin.length < 6) {
              confirmPin += number.toString();
            }
          } else if (number == Icons.arrow_back) {
            if (confirmPin.isNotEmpty) {
              confirmPin = confirmPin.substring(0, confirmPin.length - 1);
            }
          } else if (number == Icons.check) {
            if (confirmPin.length == 6) {
              if (confirmPin == widget.pin) {
                settingBox?.put('pin', widget.pin);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false,
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "Failed",
                        style: TextStyle(color: Colors.red),
                      ),
                      content: Text("PINs do not match!"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  },
                );
                confirmPin = '';
              }
            }
          }
        });
      },
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        child: number is int
            ? Text(
                number.toString(),
                style: TextStyle(fontSize: 24, color: Colors.white),
              )
            : Icon(
                number,
                size: 24,
                color: Colors.white,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Guest',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            Icon(
              Icons.lock,
              size: 60,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Confirm Your PIN',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < confirmPin.length
                        ? Colors.white
                        : Colors.transparent,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 40),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildNumberRow([1, 2, 3]),
                    buildNumberRow([4, 5, 6]),
                    buildNumberRow([7, 8, 9]),
                    buildNumberRow([Icons.arrow_back, 0, Icons.check]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
